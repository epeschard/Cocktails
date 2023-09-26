import ComposableArchitecture
import XCTest

@testable import Cocktails

final class SearchFeatureTests: XCTestCase {

  @MainActor
  func testLoadDrinks_Success() async throws {
    let store = TestStore(
      initialState: SearchFeature.State()
    ) {
      SearchFeature()
    } withDependencies: {
      $0.theCocktailDb.fetchDrinks = {
        [
          Drink(idDrink: "1", strDrink: "\($0) 1", strInstructions: "Instructions 1"),
          Drink(idDrink: "2", strDrink: "\($0) 2", strInstructions: "Instructions 2"),
        ]
      }
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
  func testLoadDrinks_InvalidUrl_Failure() async throws {
    let store = TestStore(
      initialState: SearchFeature.State()
    ) {
      SearchFeature()
    } withDependencies: {
      $0.theCocktailDb.fetchDrinks = { _ in
        throw TheCocktailDbClient.FetchDrinksError.invalidUrl
      }
    }

    await store.send(.loadDrinks) {
      $0.isLoading = true
    }
    
    await store.receive(
      .loadedDrinks(
        .failure(TheCocktailDbClient.FetchDrinksError.invalidUrl)
      )
    ) {
      $0.isLoading = false
      $0.errorText = "Invalid URL"
    }
  }
  
  @MainActor
  func testLoadDrinks_NoData_Failure() async throws {
    let store = TestStore(
      initialState: SearchFeature.State()
    ) {
      SearchFeature()
    } withDependencies: {
      $0.theCocktailDb.fetchDrinks = { _ in
        throw TheCocktailDbClient.FetchDrinksError.noDataFromResponse
      }
    }

    await store.send(.loadDrinks) {
      $0.isLoading = true
    }
    
    await store.receive(
      .loadedDrinks(
        .failure(TheCocktailDbClient.FetchDrinksError.noDataFromResponse)
      )
    ) {
      $0.isLoading = false
      $0.errorText = "Received no data from response"
    }
  }
  
  @MainActor
  func testLoadDrinks_Decoding_Failure() async throws {
    let store = TestStore(
      initialState: SearchFeature.State()
    ) {
      SearchFeature()
    } withDependencies: {
      $0.theCocktailDb.fetchDrinks = { _ in
        throw TheCocktailDbClient.FetchDrinksError.decodingFailed
      }
    }

    await store.send(.loadDrinks) {
      $0.isLoading = true
    }
    
    await store.receive(
      .loadedDrinks(
        .failure(TheCocktailDbClient.FetchDrinksError.decodingFailed)
      )
    ) {
      $0.isLoading = false
      $0.errorText = "Failed decoding JSON"
    }
  }

}
