import ComposableArchitecture
import Combine
import UIKit

final class SearchViewController: UITableViewController {
  let viewStore: ViewStoreOf<SearchFeature>
  var cancellables: Set<AnyCancellable> = []
  weak var loadingView: UIActivityIndicatorView!
  weak var errorView: UIView!
  
  init(store: StoreOf<SearchFeature>) {
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let loadingView = UIActivityIndicatorView(style: .medium)
    tableView.backgroundView = loadingView
    tableView.separatorStyle = .none
    self.loadingView = loadingView
    
    self.tableView.register(
      UITableViewCell.self,
      forCellReuseIdentifier: "subtitle"
    )
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
    
    viewStore.publisher.drinks
      .sink { [weak self] _ in
        loadingView.stopAnimating()
        self?.tableView.separatorStyle = .singleLine
        self?.tableView.reloadData()
      }
      .store(in: &cancellables)
    
    viewStore.send(.loadDrinks)
    title = "Cocktails"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if (viewStore.isLoading) {
      loadingView.startAnimating()
    } else if let errorText = viewStore.errorText {
      let errorIcon = UIImage(
        systemName: "exclamationmark.triangle.fill"
      )
      let errorImage = UIImageView(image: errorIcon)
      let errorTitle = UILabel()
      errorTitle.text = "ERROR"
      errorTitle.font = UIFont.preferredFont(forTextStyle: .headline)
      let errorLabel = UILabel()
      errorLabel.text = errorText
      errorLabel.font = UIFont.preferredFont(forTextStyle: .body)
      let errorView = UIStackView(
        arrangedSubviews: [
          errorImage,
          errorTitle,
          errorLabel,
        ]
      )
      tableView.backgroundView = errorView
      self.errorView = errorView
    }
  }
  
  //MARK: - UITableViewDataSource
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return viewStore.isLoading ? 0 : 1
  }
  
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return viewStore.drinks.count
  }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    var cell: UITableViewCell? = tableView.dequeueReusableCell(
      withIdentifier: "subtitle",
      for: indexPath
    )
    if cell == nil || cell?.detailTextLabel == nil {
      cell = UITableViewCell(
        style: .subtitle,
        reuseIdentifier: "subtitle"
      )
    }
    let drink = viewStore.drinks[indexPath.row]
    
    if let source = drink.imageURL, let url = URL(string: source) {
      cell?.imageView?.load(url: url)
    } else {
      cell?.imageView?.image = UIImage(systemName: "wineglass")
    }
    
    cell?.textLabel?.text = drink.name
    cell?.detailTextLabel?.text = drink.instructions
    cell?.detailTextLabel?.numberOfLines = 4
    return cell!
  }
  
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let drink = viewStore.drinks[indexPath.row]
    let detail = DetailViewController(
      store: Store(initialState: DetailFeature.State(drink: drink)) {
        DetailFeature()
      }
    )
    parent?.showDetailViewController(
      detail,
      sender: parent
    )
  }
}
