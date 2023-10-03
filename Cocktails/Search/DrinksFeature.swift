import ComposableArchitecture
import Foundation

struct DrinksFeature: Reducer {
  struct State: Equatable {
    var searchText: String = "gin"
    var loadedDrinks: IdentifiedArrayOf<Drink> = []
    var searchResults: IdentifiedArrayOf<Drink> = []
    var isLoading: Bool = false
    var errorText: String? = nil
  }

  enum Action: Equatable {
    case searchTextDidChange(String)
    case search(query: String)
    case searchResponse(TaskResult<IdentifiedArrayOf<Drink>>)
    case didClearSearchText
  }
  
  @Dependency(\.theCocktailDb) var theCocktailDb
  @Dependency(\.mainQueue) var mainQueue
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .searchTextDidChange(let query):
        enum CancelID { case search }
        
        state.searchText = query
        return .run { [query = query] send in
          await send(
            .search(query: query)
          )
        }
        .debounce(
          id: CancelID.search,
          for: 0.5,
          scheduler: mainQueue
        )
        
      case .search(query: let query):
        state.isLoading = true
        return .run { [query = query] send in
          do {
            let drinks = try await self.theCocktailDb.fetchDrinks(query)
            await send(
              .searchResponse(.success(drinks))
            )
          } catch {
            await send(
              .searchResponse(.failure(error))
            )
          }
        }

      case .didClearSearchText:
        state.searchText = ""
        state.searchResults = []
        return .none

      case .searchResponse(.success(let loadedDrinks)):
        state.isLoading = false

        // Keep drinks from recent searches
        for drink in loadedDrinks {
          state.loadedDrinks.append(drink)
        }
        
        // Filter only the drinks matching the query
        if !state.searchText.isEmpty {
          state.searchResults = state.loadedDrinks.filter {
            $0.name.lowercased().contains(state.searchText.lowercased())
          }
        } else {
          state.searchResults = state.loadedDrinks
        }
        
        state.errorText = nil
        return .none
        
      case .searchResponse(.failure(let error)):
        state.isLoading = false
        state.errorText = error.localizedDescription
        return .none
      }
    }
//    ._printChanges()
  }
}
