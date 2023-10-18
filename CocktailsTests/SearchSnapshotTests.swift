import ComposableArchitecture
import SnapshotTesting
import XCTest

@testable import Cocktails

class SearchSnapshotTests: XCTestCase {
  
  @MainActor
  func testSearchDrinksVC_Loaded3() {
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
    let navVC = UINavigationController(rootViewController: rootVC)

    navVC.overrideUserInterfaceStyle = .light
    assertSnapshots(
      of: navVC,
      as: ["13ProMax_light": .image(on: .iPhone13ProMax)]
    )
    assertSnapshots(
      of: navVC,
      as: ["iPhoneSe_light": .image(on: .iPhoneSe)]
    )
    
    navVC.overrideUserInterfaceStyle = .dark
    assertSnapshots(
      of: navVC,
      as: ["13ProMax_dark": .image(on: .iPhone13ProMax)]
    )
    assertSnapshots(
      of: navVC,
      as: ["iPhoneSe_dark": .image(on: .iPhoneSe)]
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
    let navVC = UINavigationController(rootViewController: rootVC)

    navVC.overrideUserInterfaceStyle = .light
    assertSnapshots(
      of: navVC,
      as: ["13ProMax_light": .image(on: .iPhone13ProMax)]
    )
    assertSnapshots(
      of: navVC,
      as: ["iPhoneSe_light": .image(on: .iPhoneSe)]
    )
    
    navVC.overrideUserInterfaceStyle = .dark
    assertSnapshots(
      of: navVC,
      as: ["13ProMax_dark": .image(on: .iPhone13ProMax)]
    )
    assertSnapshots(
      of: navVC,
      as: ["iPhoneSe_dark": .image(on: .iPhoneSe)]
    )
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
    let navVC = UINavigationController(rootViewController: rootVC)

    navVC.overrideUserInterfaceStyle = .light
    assertSnapshots(
      of: navVC,
      as: ["13ProMax_light": .image(on: .iPhone13ProMax)]
    )
    assertSnapshots(
      of: navVC,
      as: ["iPhoneSe_light": .image(on: .iPhoneSe)]
    )
    
    navVC.overrideUserInterfaceStyle = .dark
    assertSnapshots(
      of: navVC,
      as: ["13ProMax_dark": .image(on: .iPhone13ProMax)]
    )
    assertSnapshots(
      of: navVC,
      as: ["iPhoneSe_dark": .image(on: .iPhoneSe)]
    )
  }
}
