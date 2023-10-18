import ComposableArchitecture
import SnapshotTesting
import XCTest

@testable import Cocktails

class DetailSnapshotTests: XCTestCase {
  
  func testDetailViewController() {
    let mainQueue = DispatchQueue.test

    let drink = Drink(
      id: "1",
      name: "Empty Wineglass",
      tagString: "Empty,Wineglass,Test",
      glass: "Wine glass",
      category: "Healthy liver",
      ingredient1: "Red wine",
      measure1: "0 oz",
      instructions: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
    )
    
    let store = Store(
      initialState: DetailFeature.State(
        drink: drink
      )
    ) {
      DetailFeature()
    } withDependencies: {
      $0.mainQueue = mainQueue.eraseToAnyScheduler()
    }
    
    let rootVC = DetailViewController(store: store)
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
  
  func testDetailViewController_withVideoURL() {
    let mainQueue = DispatchQueue.test
    
    let drink = Drink(
      id: "1",
      name: "Empty Wineglass",
      tagString: "Empty,Wineglass,Test",
      glass: "Wine glass",
      category: "Healthy liver",
      videoURL: "https://www.x.com",
      ingredient1: "Red wine",
      measure1: "0 oz",
      instructions: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
    )
    
    let store = Store(
      initialState: DetailFeature.State(
        drink: drink
      )
    ) {
      DetailFeature()
    } withDependencies: {
      $0.mainQueue = mainQueue.eraseToAnyScheduler()
    }
    
    let rootVC = DetailViewController(store: store)
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

