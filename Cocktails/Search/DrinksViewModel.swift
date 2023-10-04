import IdentifiedCollections
import UIKit

class DrinksViewModel {
  var view: DrinksViewProtocol!
  
  var router: DrinksRouterProtocol
  
  private var debounceWorkItem: DispatchWorkItem?
  
  var theCocktailDb: TheCocktailDbClient
  
  init(
    debounceWorkItem: DispatchWorkItem? = nil,
    router: DrinksRouterProtocol,
    theCocktailDb: TheCocktailDbClient
  ) {
    self.debounceWorkItem = debounceWorkItem
    self.router = router
    self.theCocktailDb = theCocktailDb
  }
  
  var searchText: String = ""
  var isLoading = false
  var loadedDrinks: IdentifiedArrayOf<Drink> = []
  var searchResults: IdentifiedArrayOf<Drink> = []
  var errorText: String? = nil
  
  func loadView() {
    self.view.didLoadView()
  }
  
  func searchTextDidChange(searchText: String) {
    self.searchText = searchText
    debounceWorkItem?.cancel()

    debounceWorkItem = DispatchWorkItem { [weak self] in
      self?.search(query: searchText)
    }
    
    DispatchQueue.main.asyncAfter(
      deadline: .now() + 0.5,
      execute: debounceWorkItem!
    )
  }
  
  func search(query: String) {
    isLoading = true
    view.startLoading()
    Task.detached(priority: .userInitiated) { [weak self] in
      do {
        if let drinks: IdentifiedArrayOf<Drink> = try await self?.theCocktailDb.fetchDrinks(query) {
          self?.view.finishLoading()
          self?.searchResponse(result: .success(drinks))
        }
      } catch {
        self?.view.finishLoading()
        self?.searchResponse(result: .failure(error))
      }
    }
  }
  
  func searchResponse(result: Result<IdentifiedArrayOf<Drink>, Error>) {
    isLoading = false
    switch result {
    case .success(let drinks):
      // Keep drinks from recent searches
      for drink in drinks {
        loadedDrinks.append(drink)
      }
      
      // Filter only the drinks matching the query
      if !searchText.isEmpty {
        searchResults = loadedDrinks.filter {
          $0.name.lowercased().contains(searchText.lowercased())
        }
      } else {
        searchResults = loadedDrinks
      }
  
      errorText = nil
      view.didFetchDrinks()
      
    case .failure(let error):
      errorText = error.localizedDescription
    }
  }
  
  func didClearSearchText() {
    searchText = ""
    searchResults = []
  }
  
  func didSelect(
    _ drink: Drink,
    from parent: UIViewController?,
    sender: Any?
  ) {
    router.showDetailView(for: drink, from: parent, sender: sender)
  }
}
