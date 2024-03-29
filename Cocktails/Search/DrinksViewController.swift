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

    title = "Cocktails"
    navigationController?.navigationBar.prefersLargeTitles = true

    setupLoadingView()
    setupTableView()
    setupSearchController()

    viewStore.publisher.loadedDrinks
      .sink(
        receiveValue: { [weak self] _ in
          self?.loadingView.stopAnimating()
          self?.tableView.separatorStyle = .singleLine
          self?.tableView.reloadData()
        }
      )
      .store(in: &cancellables)
    
    viewStore.publisher.showDetail
      .sink(
        receiveValue: { [weak self] detailState in
          guard let self = self else { return }
          
          if let detailState = detailState {
            let detail = DetailViewController(
              store: Store(
                initialState: detailState
              ) {
                DetailFeature()
              }
            )
            self.navigationController?.delegate = self
            self.navigationController?.pushViewController(
              detail,
              animated: true
            )
          }
        }
      )
      .store(in: &cancellables)
    
    viewStore.send(
      .searchTextDidChange("gin")
    )
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let errorText = viewStore.errorText {
      let errorTitle = UILabel()
      errorTitle.text = "ERROR"
      errorTitle.font = UIFont.preferredFont(forTextStyle: .largeTitle)
      let errorLabel = UILabel()
      errorLabel.text = errorText
      errorLabel.font = UIFont.preferredFont(forTextStyle: .headline)
      let errorView = UIStackView(
        arrangedSubviews: [
          UIView(),
          errorTitle,
          errorLabel,
          UIView()
        ]
      )
      errorView.axis = .vertical
      errorView.alignment = .center
      errorView.distribution = .fillEqually
      tableView.backgroundView = errorView
      self.errorView = errorView
    } else if (viewStore.isLoading) {
      loadingView.startAnimating()
    } else if viewStore.loadedDrinks.isEmpty {
      searchController.isActive = true
      DispatchQueue.main.async {
        self.searchController.searchBar.searchTextField.becomeFirstResponder()
      }
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
    if viewStore.loadedDrinks.isEmpty {
      if viewStore.errorText != nil {
        return nil
      }
      return "Start typing to search for drinks"
    }
    return "Drinks from recent searches"
  }
  
  //MARK: - UITableViewDelegate

  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let drink: Drink
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
      drink = self.viewStore.searchResults[indexPath.row]
    } else {
      drink = self.viewStore.loadedDrinks[indexPath.row]
    }
    viewStore.send(.selectedDrink(drink.id))
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
    if #available(iOS 15.0, *) {
      tableView.isPrefetchingEnabled = true
    }
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
    searchController.searchBar.placeholder = "Search cocktail drinks"
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
    let thumbnailURLs: [URL]
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
      let thumbnailStrings = indexPaths.compactMap {
        viewStore.loadedDrinks[$0.row].thumbnail
      }
      thumbnailURLs = thumbnailStrings.compactMap {
        URL(string: $0)
      }
    } else {
      let thumbnailStrings = indexPaths.compactMap {
        viewStore.searchResults[$0.row].thumbnail
      }
      thumbnailURLs = thumbnailStrings.compactMap {
        URL(string: $0)
      }
    }
    
    SDWebImagePrefetcher.shared.prefetchURLs(thumbnailURLs)
  }
}
