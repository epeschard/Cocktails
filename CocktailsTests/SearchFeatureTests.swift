import ComposableArchitecture
import XCTest

@testable import Cocktails

final class SearchFeatureTests: XCTestCase {

  @MainActor
  func testSearchFeatureLoadDrinksSucceeds() async throws {
    let store = TestStore(
      initialState: SearchFeature.State()
    ) {
      SearchFeature(
        fetchDrinks: { query in
          return Result.success([
            Drink(idDrink: "1", strDrink: "Drink 1", strInstructions: "Instructions 1"),
            Drink(idDrink: "2", strDrink: "Drink 2", strInstructions: "Instructions 2"),
          ])
        }
      )
    }
    await store.send(.loadDrinks) {
      $0.isLoading = true
    }
    
    await store.receive(
      .drinksLoaded(
        Result.success([
          Drink(idDrink: "1", strDrink: "Drink 1", strInstructions: "Instructions 1"),
          Drink(idDrink: "2", strDrink: "Drink 2", strInstructions: "Instructions 2"),
        ])
      )
    ) {
      $0.isLoading = false
      $0.drinks = [
        Drink(idDrink: "1", strDrink: "Drink 1", strInstructions: "Instructions 1"),
        Drink(idDrink: "2", strDrink: "Drink 2", strInstructions: "Instructions 2"),
      ]
    }
  }
  
  @MainActor
  func testSearchFeatureLoadDrinksFails() async throws {
    let error = NSError(domain: "cocktails", code: 1/*, userInfo: ["": ""]*/)
    let store = TestStore(
      initialState: SearchFeature.State()
    ) {
      SearchFeature(
        fetchDrinks: { query in
          return Result.failure(error)
        }
      )
    }
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
