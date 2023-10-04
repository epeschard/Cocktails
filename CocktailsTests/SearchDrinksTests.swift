import ComposableArchitecture
import XCTest

@testable import Cocktails

final class SearchDrinksTests: XCTestCase {
  
  func testLoadDrinks_Success() {
    
    var drinks: IdentifiedArrayOf<Drink> = []
    let emptyRed = Drink(
      id: "1",
      name: "Empty Red Wineglass",
      tagString: "Empty,Wineglass,Test",
      glass: "Wine glass",
      category: "Healthy liver",
      ingredient1: "Red wine",
      measure1: "0 oz",
      instructions: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
    )
    let emptyRose = Drink(
      id: "2",
      name: "Empty Rosé Wineglass",
      tagString: "Empty,Wineglass,Test",
      glass: "Wine glass",
      category: "Healthy liver",
      ingredient1: "Rosé wine",
      measure1: "0 oz",
      instructions: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
    )
    let emptyWhite = Drink(
      id: "3",
      name: "Empty White Wineglass",
      tagString: "Empty,Wineglass,Test",
      glass: "Wine glass",
      category: "Healthy liver",
      ingredient1: "White wine",
      measure1: "0 oz",
      instructions: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
    )
    drinks.append(emptyRed)
    drinks.append(emptyRose)
    drinks.append(emptyWhite)
    
    let testCocktailDb = TheCocktailDbClient.testValue
    
    let testView = TestDrinksView()
    let mockRouter = MockDrinksRouter()
    let viewModel = DrinksViewModel(
      router: mockRouter,
      theCocktailDb: testCocktailDb
    )
    viewModel.view = testView
    
    viewModel.searchTextDidChange(searchText: "e")
    XCTAssertEqual(viewModel.searchText, "e")
    XCTAssertFalse(viewModel.isLoading)
    
    let expectation1 = XCTestExpectation(description: "first debounce")
    DispatchQueue.global().async {
      Thread.sleep(forTimeInterval: 0.2)
      expectation1.fulfill()
    }
    
    //Nothing emits right away
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(testView.startLoadingWasCalled)
    
    viewModel.searchTextDidChange(searchText: "em")
    XCTAssertEqual(viewModel.searchText, "em")
    
    let expectation2 = XCTestExpectation(description: "second debounce")
    DispatchQueue.global().async {
      Thread.sleep(forTimeInterval: 0.4)
      expectation2.fulfill()
    }
    
    //Search field text changes are still being debounced
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(testView.startLoadingWasCalled)
    
    viewModel.searchTextDidChange(searchText: "empty")
    XCTAssertEqual(viewModel.searchText, "empty")
    
    let expectation3 = XCTestExpectation(description: "third's the charm")
    DispatchQueue.global().async {
      Thread.sleep(forTimeInterval: 0.6)
      expectation3.fulfill()
    }
    wait(for: [expectation1, expectation2, expectation3], timeout: 1)
    
    let expectation4 = XCTestExpectation(description: "call search(query:)")
    DispatchQueue.global().async {
      Thread.sleep(forTimeInterval: 0.5)
      expectation4.fulfill()
    }
    wait(for: [expectation4], timeout: 5)
    XCTAssertTrue(testView.startLoadingWasCalled)
    
    let expectation5 = XCTestExpectation(description: "fetch drinks from TheCocktailDb")
    DispatchQueue.global().async {
      Thread.sleep(forTimeInterval: 0.5)
      expectation5.fulfill()
    }
    wait(for: [expectation5], timeout: 3)
    
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertEqual(viewModel.loadedDrinks, drinks)
    XCTAssertEqual(viewModel.searchResults, drinks)
    
    viewModel.didClearSearchText()
    
    XCTAssertEqual(viewModel.searchText, "")
    XCTAssertEqual(viewModel.searchResults, [])
  }
  
  func testLoadDrinks_Failure_InvalidUrl() {
    let testCocktailDb = TheCocktailDbClient.testInvalidUrl
    
    let testView = TestDrinksView()
    let mockRouter = MockDrinksRouter()
    let viewModel = DrinksViewModel(
      router: mockRouter,
      theCocktailDb: testCocktailDb
    )
    viewModel.view = testView
    
    viewModel.searchTextDidChange(searchText: "gin")
    XCTAssertEqual(viewModel.searchText, "gin")
    
    let expectation1 = XCTestExpectation(description: "call search(query:)")
    DispatchQueue.global().async {
      Thread.sleep(forTimeInterval: 0.6)
      expectation1.fulfill()
    }
    wait(for: [expectation1], timeout: 1)
    XCTAssertTrue(testView.startLoadingWasCalled)
    
    let expectation2 = XCTestExpectation(description: "fetch drinks from TheCocktailDb")
    DispatchQueue.global().async {
      Thread.sleep(forTimeInterval: 0.5)
      expectation2.fulfill()
    }
    wait(for: [expectation2], timeout: 1)
    
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertEqual(viewModel.errorText, "Invalid URL")
  }
  
  func testLoadDrinks_Failure_NoData() {
    let testCocktailDb = TheCocktailDbClient.testNoDataFromResponse
    
    let testView = TestDrinksView()
    let mockRouter = MockDrinksRouter()
    let viewModel = DrinksViewModel(
      router: mockRouter,
      theCocktailDb: testCocktailDb
    )
    viewModel.view = testView
    
    viewModel.searchTextDidChange(searchText: "gin")
    XCTAssertEqual(viewModel.searchText, "gin")
    
    let expectation1 = XCTestExpectation(description: "call search(query:)")
    DispatchQueue.global().async {
      Thread.sleep(forTimeInterval: 0.6)
      expectation1.fulfill()
    }
    wait(for: [expectation1], timeout: 1)
    XCTAssertTrue(testView.startLoadingWasCalled)
    
    let expectation2 = XCTestExpectation(description: "fetch drinks from TheCocktailDb")
    DispatchQueue.global().async {
      Thread.sleep(forTimeInterval: 0.5)
      expectation2.fulfill()
    }
    wait(for: [expectation2], timeout: 1)
    
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertEqual(viewModel.errorText, "Received no data from response")
  }
  
  func testLoadDrinks_Failure_Decoding() {
    let testCocktailDb = TheCocktailDbClient.testDecodingFailed
    
    let testView = TestDrinksView()
    let mockRouter = MockDrinksRouter()
    let viewModel = DrinksViewModel(
      router: mockRouter,
      theCocktailDb: testCocktailDb
    )
    viewModel.view = testView
    
    viewModel.searchTextDidChange(searchText: "gin")
    XCTAssertEqual(viewModel.searchText, "gin")
    
    let expectation1 = XCTestExpectation(description: "call search(query:)")
    DispatchQueue.global().async {
      Thread.sleep(forTimeInterval: 0.6)
      expectation1.fulfill()
    }
    wait(for: [expectation1], timeout: 1)
    XCTAssertTrue(testView.startLoadingWasCalled)
    
    let expectation2 = XCTestExpectation(description: "fetch drinks from TheCocktailDb")
    DispatchQueue.global().async {
      Thread.sleep(forTimeInterval: 0.5)
      expectation2.fulfill()
    }
    wait(for: [expectation2], timeout: 1)
    
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertEqual(viewModel.errorText, "Failed decoding JSON")
  }
}

extension TheCocktailDbClient {
  static let testValue = Self { query in
    var drinks: IdentifiedArrayOf<Drink> = []
    let emptyRed = Drink(
      id: "1",
      name: "Empty Red Wineglass",
      tagString: "Empty,Wineglass,Test",
      glass: "Wine glass",
      category: "Healthy liver",
      ingredient1: "Red wine",
      measure1: "0 oz",
      instructions: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
    )
    let emptyRose = Drink(
      id: "2",
      name: "Empty Rosé Wineglass",
      tagString: "Empty,Wineglass,Test",
      glass: "Wine glass",
      category: "Healthy liver",
      ingredient1: "Rosé wine",
      measure1: "0 oz",
      instructions: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
    )
    let emptyWhite = Drink(
      id: "3",
      name: "Empty White Wineglass",
      tagString: "Empty,Wineglass,Test",
      glass: "Wine glass",
      category: "Healthy liver",
      ingredient1: "White wine",
      measure1: "0 oz",
      instructions: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
    )
    drinks.append(emptyRed)
    drinks.append(emptyRose)
    drinks.append(emptyWhite)
    
    return drinks
  }
  
  static let testEmpty = Self { query in
    var drinks: IdentifiedArrayOf<Drink> = []
    return drinks
  }
  
  static let testInvalidUrl = Self { query in
    throw TheCocktailDbClient.FetchDrinksError.invalidUrl
  }
  
  static let testNoDataFromResponse = Self { query in
    throw TheCocktailDbClient.FetchDrinksError.noDataFromResponse
  }
  
  static let testDecodingFailed = Self { query in
    throw TheCocktailDbClient.FetchDrinksError.decodingFailed
  }
}
