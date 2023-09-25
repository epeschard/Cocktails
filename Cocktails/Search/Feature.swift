import Foundation
import ComposableArchitecture

struct SearchFeature: Reducer {
  
  struct State: Equatable {
    var query: String = "margarita"
    var drinks: [Drink] = []
    var isLoading: Bool = false
    var error: String? = nil
  }
  
  enum Action: Equatable {
    case loadDrinks
    case drinksLoaded(Result<[Drink], NSError>)
  }
  
  let fetchDrinks: (String) async throws -> Result<[Drink], NSError>
  
  func reduce(
    into state: inout State,
    action: Action
  ) -> Effect<Action> {
    switch action {
    case .loadDrinks:
      state.isLoading = true
      return .run { [query = state.query] send in
        let drinks = try await fetchDrinks(query)
        await send(
          .drinksLoaded(drinks)
        )
      }
      
    case .drinksLoaded(.success(let cocktails)):
      state.isLoading = false
      state.drinks = cocktails
      return .none
      
    case .drinksLoaded(.failure(let error)):
      state.isLoading = false
      state.error = error.localizedDescription
      return .none
    }
  }
}
