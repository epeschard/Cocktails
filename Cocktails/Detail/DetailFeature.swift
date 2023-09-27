import ComposableArchitecture
import UIKit

struct DetailFeature: Reducer {
  
  struct State: Equatable {
    var drink: Drink?
  }
  
  enum Action: Equatable {
    case selected(Drink)
    case imageButtonTapped
    case videoButtonTapped
  }
  
  func reduce(
    into state: inout State,
    action: Action
  ) -> Effect<Action> {
    switch action {
    case .selected(let drink):
      state.drink = drink
      return .none
      
    case .imageButtonTapped:
      print("image Button Tapped")
      return .none
      
    case .videoButtonTapped:
      print("video Button Tapped")
      return .none
    }
  }
}
