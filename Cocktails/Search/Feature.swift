import Foundation
import ComposableArchitecture

struct SearchFeature: Reducer {
  
  struct State: Equatable {
    var query: String = "margarita"
    var drinks: [Drink] = []
    var isLoading: Bool = false
    var errorText: String? = nil
  }
  
  enum Action: Equatable {
    case loadDrinks
    case loadedDrinks(TaskResult<[Drink]>)
  }
  
  let fetchDrinks: @Sendable (String) async throws -> [Drink]
  
  func reduce(
    into state: inout State,
    action: Action
  ) -> Effect<Action> {
    struct SomeError: Error {}
    switch action {
    case .loadDrinks:
      state.isLoading = true
      return .run { [query = state.query] send in
        let drinks = try await fetchDrinks(query)
        await send(
          .loadedDrinks(.success(drinks))
        )
      }
      
    case .loadedDrinks(.success(let cocktails)):
      state.isLoading = false
      state.drinks = cocktails
      return .none
      
    case .loadedDrinks(.failure(let error)):
      state.isLoading = false
      state.errorText = error.localizedDescription
      return .none
    }
  }
}
