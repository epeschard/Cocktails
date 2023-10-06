import ComposableArchitecture
import SnapshotTesting
import XCTest

@testable import Cocktails

class SearchSnapshotTests: XCTestCase {
  
  @MainActor
  func testSearchDrinksVC_Loaded() {
    let mainQueue = DispatchQueue.test
    
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
    
    let store = Store(
      initialState: DrinksFeature.State(
        searchText: "win",
        loadedDrinks: drinks,
        searchResults: drinks,
        isLoading: false
      )
    ) {
      DrinksFeature()
    } withDependencies: {
      $0.mainQueue = mainQueue.eraseToAnyScheduler()
    }
    let rootVC = DrinksViewController(store: store)
    let nav = UINavigationController(rootViewController: rootVC)

    assertSnapshots(
      of: nav,
      as: ["3": .image(on: .iPhone13)]
    )
  }
  
  func testSearchDrinksVC_Error() {
    let mainQueue = DispatchQueue.test
    let drinks: IdentifiedArrayOf<Drink> = []
    
    let store = Store(
      initialState: DrinksFeature.State(
        searchText: "gin",
        loadedDrinks: drinks,
        searchResults: drinks,
        isLoading: false,
        errorText: "Failed to load"
      )
    ) {
      DrinksFeature()
    } withDependencies: {
      $0.mainQueue = mainQueue.eraseToAnyScheduler()
    }
    let rootVC = DrinksViewController(store: store)
    let nav = UINavigationController(rootViewController: rootVC)

    assertSnapshots(of: nav, as: ["Data": .image(on: .iPhone13)])
  }
  
  func testSearchDrinksVC_Loading() {
    let mainQueue = DispatchQueue.test
    let drinks: IdentifiedArrayOf<Drink> = []
    
    let store = Store(
      initialState: DrinksFeature.State(
        searchText: "",
        loadedDrinks: drinks,
        searchResults: drinks,
        isLoading: true
      )
    ) {
      DrinksFeature()
    } withDependencies: {
      $0.mainQueue = mainQueue.eraseToAnyScheduler()
    }
    let rootVC = DrinksViewController(store: store)
    let nav = UINavigationController(rootViewController: rootVC)

    assertSnapshots(of: nav, as: ["Empty": .image(on: .iPhone13)])
  }
}
