import ComposableArchitecture
import XCTest

@testable import Cocktails

final class SearchFeatureTests: XCTestCase {

  @MainActor
  func testLoadDrinks_Success() async throws {
    let store = TestStore(
      initialState: SearchFeature.State()
    ) {
      SearchFeature(
        fetchDrinks: {
          [
            Drink(idDrink: "1", strDrink: "\($0) 1", strInstructions: "Instructions 1"),
            Drink(idDrink: "2", strDrink: "\($0) 2", strInstructions: "Instructions 2"),
          ]
        }
      )
    }
    
    await store.send(.loadDrinks) {
      $0.isLoading = true
    }
    
    await store.receive(
      .loadedDrinks(
        .success([
          Drink(idDrink: "1", strDrink: "margarita 1", strInstructions: "Instructions 1"),
          Drink(idDrink: "2", strDrink: "margarita 2", strInstructions: "Instructions 2"),
        ])
      )
    ) {
      $0.isLoading = false
      $0.drinks = [
        Drink(idDrink: "1", strDrink: "margarita 1", strInstructions: "Instructions 1"),
        Drink(idDrink: "2", strDrink: "margarita 2", strInstructions: "Instructions 2"),
      ]
    }
  }
  
  @MainActor
  func testLoadDrinks_Failure() async throws {
    let store = TestStore(
      initialState: SearchFeature.State()
    ) {
      SearchFeature(
        fetchDrinks: { _ in
          struct SomeError: Error {}
          throw SomeError()
        }
      )
    }
    XCTExpectFailure()
    await store.send(.loadDrinks) {
      $0.isLoading = true
    }
    
    await store.receive(
      .drinksLoaded(
        Result.failure(error)
      )
    ) {
      $0.isLoading = false
      $0.drinks = []
      $0.error = "The operation couldn’t be completed. (cocktails error 1.)"
    }
  }

}
