import ComposableArchitecture
import XCTest

@testable import Cocktails

final class SearchDrinksTests: XCTestCase {

  @MainActor
  func testLoadDrinks_Success() async throws {
    
    let mainQueue = DispatchQueue.test
    
    var drinks: IdentifiedArrayOf<Drink> = []
    let drink1 = Drink(
      id: "1",
      name: "gin 1",
      glass: "glass",
      category: "category",
      instructions: "Instructions 1"
    )
    let drink2 = Drink(
      id: "2",
      name: "gin 2",
      glass: "glass",
      category: "category",
      instructions: "Instructions 1"
    )
    drinks.append(drink1)
    drinks.append(drink2)
    
    let store = TestStore(
      initialState: DrinksFeature.State()
    ) {
      DrinksFeature()
    } withDependencies: {
      $0.theCocktailDb.fetchDrinks = { [drinks = drinks] query in
        return drinks
      }
      $0.mainQueue = mainQueue.eraseToAnyScheduler()
    }

    await store.send(.searchTextDidChange("g")) {
      $0.searchText = "g"
    }
    await mainQueue.advance(by: 0.2)
    
    //Nothing emits right away
    XCTAssertEqual(store.state.isLoading, false)
    
    await store.send(.searchTextDidChange("gi")) {
      $0.searchText = "gi"
    }
    await mainQueue.advance(by: 0.4)
    
    //Search field text changes are still being debounced
    XCTAssertEqual(store.state.isLoading, false)
    
    await store.send(.searchTextDidChange("gin")) {
      $0.searchText = "gin"
    }
    await mainQueue.advance(by: 0.6)
    
    await store.receive(
      .search(query: "gin")
    ) {
      $0.isLoading = true
    }
    
    await store.receive(
      .searchResponse(
        .success(
          drinks
        )
      )
    ) {
      $0.isLoading = false
      $0.loadedDrinks = drinks
      $0.searchResults = drinks
    }
    
    await store.send(.didClearSearchText) {
      $0.searchText = ""
    }
  }
  
  @MainActor
  func testLoadDrinks_Failure_InvalidUrl() async throws {
    let mainQueue = DispatchQueue.test
    
    let store = TestStore(
      initialState: DrinksFeature.State()
    ) {
      DrinksFeature()
    } withDependencies: {
      $0.theCocktailDb.fetchDrinks = { _ in
        throw TheCocktailDbClient.FetchDrinksError.invalidUrl
      }
      $0.mainQueue = mainQueue.eraseToAnyScheduler()
    }

    await store.send(.searchTextDidChange("gin"))
    await mainQueue.advance(by: 0.6)
    
    await store.receive(
      .search(query: "gin")
    ) {
      $0.isLoading = true
    }
    
    await store.receive(
      .searchResponse(
        .failure(TheCocktailDbClient.FetchDrinksError.invalidUrl)
      )
    ) {
      $0.isLoading = false
      $0.errorText = "Invalid URL"
    }
  }
  
  @MainActor
  func testLoadDrinks_Failure_NoData() async throws {
    let mainQueue = DispatchQueue.test
    
    let store = TestStore(
      initialState: DrinksFeature.State()
    ) {
      DrinksFeature()
    } withDependencies: {
      $0.theCocktailDb.fetchDrinks = { _ in
        throw TheCocktailDbClient.FetchDrinksError.noDataFromResponse
      }
      $0.mainQueue = mainQueue.eraseToAnyScheduler()
    }

    await store.send(.searchTextDidChange("gin"))
    await mainQueue.advance(by: 0.6)
    
    await store.receive(
      .search(query: "gin")
    ) {
      $0.isLoading = true
    }
    
    await store.receive(
      .searchResponse(
        .failure(TheCocktailDbClient.FetchDrinksError.noDataFromResponse)
      )
    ) {
      $0.isLoading = false
      $0.errorText = "Received no data from response"
    }
  }
  
  @MainActor
  func testLoadDrinks_Failure_Decoding() async throws {
    let mainQueue = DispatchQueue.test
    
    let store = TestStore(
      initialState: DrinksFeature.State()
    ) {
      DrinksFeature()
    } withDependencies: {
      $0.theCocktailDb.fetchDrinks = { _ in
        throw TheCocktailDbClient.FetchDrinksError.decodingFailed
      }
      $0.mainQueue = mainQueue.eraseToAnyScheduler()
    }

    await store.send(.searchTextDidChange("gin"))
    await mainQueue.advance(by: 0.6)
    
    await store.receive(
      .search(query: "gin")
    ) {
      $0.isLoading = true
    }
    
    await store.receive(
      .searchResponse(
        .failure(TheCocktailDbClient.FetchDrinksError.decodingFailed)
      )
    ) {
      $0.isLoading = false
      $0.errorText = "Failed decoding JSON"
    }
  }
}
