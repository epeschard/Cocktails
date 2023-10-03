import Combine
import ComposableArchitecture
import SDWebImage
import UIKit

let drinkCellIdentifier = "subtitle"

final class DrinksViewController: UITableViewController {
  let viewStore: ViewStoreOf<DrinksFeature>
  var cancellables: Set<AnyCancellable> = []
  
  weak var loadingView: UIActivityIndicatorView!
  weak var errorView: UIView!
  var searchController: UISearchController!
  
  //MARK: - Initializers

  init(store: StoreOf<DrinksFeature>) {
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Lifecycle Overrides

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Cocktails"
    navigationController?.navigationBar.prefersLargeTitles = true

    setupLoadingView()
    setupTableView()
    setupSearchController()

    self.viewStore.publisher.loadedDrinks
      .sink(
        receiveValue: { [weak self] _ in
          self?.loadingView.stopAnimating()
          self?.tableView.separatorStyle = .singleLine
          self?.tableView.reloadData()
        }
      )
      .store(in: &cancellables)
    
    self.viewStore.publisher.loadedDrinks
      .sink(
        receiveValue: { [weak self] _ in
          self?.loadingView.stopAnimating()
          self?.tableView.reloadData()
        }
      )
      .store(in: &cancellables)
    
    viewStore.send(
      .search(query: "gin")
    )
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
    if searchController.isActive && searchController.searchBar.text != "" {
      return viewStore.searchResults.count
    }
    return viewStore.loadedDrinks.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let drink: Drink
    if searchController.isActive && searchController.searchBar.text != "" {
      drink = viewStore.searchResults[indexPath.row]
    } else {
      drink = viewStore.loadedDrinks[indexPath.row]
    }
    
    var cell: DrinkCell? = tableView.dequeueReusableCell(
      withIdentifier: DrinkCell.reuseIdentifier,
      for: indexPath
    ) as? DrinkCell
    if cell == nil || cell?.instructions == nil {
      cell = DrinkCell(
        style: .subtitle,
        reuseIdentifier: drinkCellIdentifier
      )
    }
  
    cell!.configure(with: drink)

    return cell!
  }
  
  override func tableView(
    _ tableView: UITableView,
    titleForHeaderInSection section: Int
  ) -> String? {
    if searchController.isActive && searchController.searchBar.text != "" {
      if viewStore.searchResults.isEmpty {
        return "Couldn't find drinks with '\(viewStore.searchText)'"
      } else {
        return nil
      }
    }
    return "Drinks from recent searches"
  }
  
  //MARK: - UITableViewDelegate

  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let drink = self.viewStore.loadedDrinks[indexPath.row]
    
    let detail = DetailViewController(
      store: Store(
        initialState: DetailFeature.State(drink: drink)
      ) {
        DetailFeature()
      }
    )
    
    parent?.show(detail, sender: self)
  }
}

//MARK: - Private

private extension DrinksViewController {
  func setupLoadingView() {
    let loadingView = UIActivityIndicatorView(style: .medium)
    tableView.backgroundView = loadingView
    tableView.separatorStyle = .none
    self.loadingView = loadingView
  }
  
  func setupTableView() {
    tableView.isPrefetchingEnabled = true
    tableView.prefetchDataSource = self
    
    tableView.register(
      DrinkCell.self,
      forCellReuseIdentifier: DrinkCell.reuseIdentifier
    )
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
  }
  
  func setupSearchController() {
    searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Items"
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
}

extension DrinksViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
      viewStore.send(.searchTextDidChange(searchText))
    } else {
      viewStore.send(.didClearSearchText)
    }
    tableView.reloadData()
  }
}

//MARK: - UITableViewDataSourcePrefetching

extension DrinksViewController: UITableViewDataSourcePrefetching {
  func tableView(
    _ tableView: UITableView,
    prefetchRowsAt indexPaths: [IndexPath]
  ) {
    let thumbnailStrings = indexPaths.compactMap {
      viewStore.searchResults[$0.row].thumbnail
    }
    let thumbnailURLs = thumbnailStrings.compactMap {
      URL(string: $0)
    }
    SDWebImagePrefetcher.shared.prefetchURLs(thumbnailURLs)
  }
}
