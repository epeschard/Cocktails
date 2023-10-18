import ComposableArchitecture
import Foundation

struct DrinksFeature: Reducer {
  struct State: Equatable {
    var searchText: String = "gin"
    var loadedDrinks: IdentifiedArrayOf<Drink> = []
    var searchResults: IdentifiedArrayOf<Drink> = []
    var isLoading: Bool = false
    var errorText: String? = nil
    @PresentationState var showDetail: DetailFeature.State?
  }

  enum Action: Equatable {
    case searchTextDidChange(String)
    case search(query: String)
    case searchResponse(TaskResult<IdentifiedArrayOf<Drink>>)
    case didClearSearchText
    case selectedDrink(Drink.ID)
    case showDetail(PresentationAction<DetailFeature.Action>)
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
        
      case .selectedDrink(let drinkID):
        if let drink = state.loadedDrinks[id: drinkID] {
          let drinkDetailState = DetailFeature.State(drink: drink)
          state.showDetail = drinkDetailState
        }
        return .none
        
      case .showDetail:
        return .none
      }
    }
    .ifLet(
      \.$showDetail,
       action: /Action.showDetail) {
         DetailFeature()
       }
    ._printChanges()
  }
}
