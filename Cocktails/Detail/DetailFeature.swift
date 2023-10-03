import ComposableArchitecture
import UIKit
import Foundation

struct DetailFeature: Reducer {
  
  struct State: Equatable {
    var drink: Drink
  }
  
  enum Action: Equatable {
    case imageButtonTapped
    case videoButtonTapped
  }
  
//  @Dependency(\.urlSession) var urlSession
  @Dependency(\.openURL) var openURL
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .imageButtonTapped:
        guard
          let stringURL = state.drink.imageURL,
          let imageURL = URL(string: stringURL)
            
        else {
          return .none
        }
        return .run { [imageURL = imageURL] send in
          await openURL(imageURL)
        }
        
      case .videoButtonTapped:
        guard
          let stringURL = state.drink.videoURL,
          let videoURL = URL(string: stringURL)
        else {
          return .none
        }
        return .run { [videoURL = videoURL] send in
          await openURL(videoURL)
        }
      }
    }
  }
  /*
  func reduce(
    into state: inout State,
    action: Action
  ) -> Effect<Action> {
    switch action {
    case .imageButtonTapped:
      guard
        let stringURL = state.drink.imageURL,
        let imageURL = URL(string: stringURL)
      else {
        return .none
      }
/*
      return .run { [imageURL = imageURL] send in
        send(_ = openURL(imageURL))
      }
      .eraseToAnyPublisher()
*/
      UIApplication.shared.open(imageURL)
      let _ = openURL.callAsFunction(imageURL)
      return E
      //return .none
      
    case .videoButtonTapped:
      guard
        let stringURL = state.drink.videoURL,
        let videoURL = URL(string: stringURL)
      else {
        return .none
      }
      UIApplication.shared.open(videoURL)
      return .none
    }
  }
   */
}
