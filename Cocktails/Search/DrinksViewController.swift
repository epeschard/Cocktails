import Combine
import ComposableArchitecture
import SDWebImage
import UIKit

let drinkCellIdentifier = "subtitle"

final class DrinksViewController: UITableViewController {

  var viewModel: DrinksViewModel!
  weak var loadingView: UIActivityIndicatorView!
  weak var errorView: UIView!
  var searchController: UISearchController!
  
  //MARK: - Initializers

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Lifecycle Overrides

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.loadView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let errorText = viewModel.errorText {
      let errorIcon = UIImage(
        systemName: "exclamationmark.triangle.fill"
      )
      let errorImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
      errorImage.image = errorIcon
      let errorTitle = UILabel()
      errorTitle.text = "ERROR"
      errorTitle.font = UIFont.preferredFont(forTextStyle: .largeTitle)
      let errorLabel = UILabel()
      errorLabel.text = errorText
      errorLabel.font = UIFont.preferredFont(forTextStyle: .headline)
      let errorView = UIStackView(
        arrangedSubviews: [
          UIView(),
//          errorImage,
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
    } else if viewModel.loadedDrinks.isEmpty {
      searchController.isActive = true
      DispatchQueue.main.async {
        self.searchController.searchBar.searchTextField.becomeFirstResponder()
      }
    } else if (viewModel.isLoading) {
      loadingView.startAnimating()
    }
  }
  
  //MARK: - UITableViewDataSource
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.isLoading ? 0 : 1
  }

  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    if searchController.isActive && searchController.searchBar.text != "" {
      return viewModel.searchResults.count
    }
    return viewModel.loadedDrinks.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let drink: Drink
    if searchController.isActive && searchController.searchBar.text != "" {
      drink = viewModel.searchResults[indexPath.row]
    } else {
      drink = viewModel.loadedDrinks[indexPath.row]
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
      if viewModel.searchResults.isEmpty {
        return "Couldn't find drinks with '\(viewModel.searchText)'"
      } else {
        return nil
      }
    }
    if viewModel.loadedDrinks.isEmpty {
      if viewModel.errorText != nil {
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
      drink = self.viewModel.searchResults[indexPath.row]
    } else {
      drink = self.viewModel.loadedDrinks[indexPath.row]
    }
    
    viewModel.didSelect(drink, from: parent)
  }
}

//MARK: - Private

extension DrinksViewController {
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
    searchController.searchBar.placeholder = "Search cocktail drinks"
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
}

extension DrinksViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
      viewModel.searchTextDidChange(searchText: searchText)
    } else {
      viewModel.didClearSearchText()
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
        viewModel.loadedDrinks[$0.row].thumbnail
      }
      thumbnailURLs = thumbnailStrings.compactMap {
        URL(string: $0)
      }
    } else {
      let thumbnailStrings = indexPaths.compactMap {
        viewModel.searchResults[$0.row].thumbnail
      }
      thumbnailURLs = thumbnailStrings.compactMap {
        URL(string: $0)
      }
    }
    
    SDWebImagePrefetcher.shared.prefetchURLs(thumbnailURLs)
  }
}
