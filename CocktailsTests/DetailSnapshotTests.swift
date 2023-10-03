import ComposableArchitecture
import SnapshotTesting
import XCTest

@testable import Cocktails

class DetailSnapshotTests: XCTestCase {
  
  func testDetailViewController() {
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
    }
    
    let rootVC = DetailViewController(store: store)
    let nav = UINavigationController(rootViewController: rootVC)

    assertSnapshots(of: nav, as: ["iPhone13ProMax": .image(on: .iPhone13ProMax)])
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
    }
    
    let rootVC = DetailViewController(store: store)
    let nav = UINavigationController(rootViewController: rootVC)

    assertSnapshots(of: nav, as: ["iPhone13ProMax": .image(on: .iPhone13ProMax)])
  }
}

