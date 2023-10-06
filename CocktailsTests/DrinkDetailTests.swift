import ComposableArchitecture
import XCTest

@testable import Cocktails

final class DrinkDetailTests: XCTestCase {
  
  @MainActor
  func testImageButtonTapped_NoAction() async throws {
    let openURL = OpenURLEffect { _ in return false }
    let withoutImageURL = Drink(
      id: "1",
      name: "gin 1",
      glass: "glass",
      category: "category",
      instructions: "Instructions 1"
    )
    
    let store = TestStore(
      initialState: DetailFeature.State(
        drink: withoutImageURL
      )
    ) {
      DetailFeature()
    } withDependencies: {
      $0.openURL = openURL
    }

    await store.send(.imageButtonTapped)
  }
  
  @MainActor
  func testImageButtonTapped_OpenSafari() async throws {
    let openURL = OpenURLEffect { _ in return true }
    let withImageURL = Drink(
      id: "1",
      name: "gin 1",
      glass: "glass",
      category: "category",
      imageURL: "https://www.x.com",
      instructions: "Instructions 1"
    )
    
    let store = TestStore(
      initialState: DetailFeature.State(
        drink: withImageURL
      )
    ) {
      DetailFeature()
    } withDependencies: {
      $0.openURL = openURL
    }

    await store.send(.imageButtonTapped)
  }
  
  @MainActor
  func testVideoButtonTapped_NoAction() async throws {
    let openURL = OpenURLEffect { _ in return false }
    let withoutVideoURL = Drink(
      id: "1",
      name: "gin 1",
      glass: "glass",
      category: "category",
      instructions: "Instructions 1"
    )
    
    let store = TestStore(
      initialState: DetailFeature.State(
        drink: withoutVideoURL
      )
    ) {
      DetailFeature()
    } withDependencies: {
      $0.openURL = openURL
    }

    await store.send(.videoButtonTapped)
  }
  
  @MainActor
  func testVideoButtonTapped_OpenSafari() async throws {
    let openURL = OpenURLEffect { _ in return true }
    let withVideoURL = Drink(
      id: "1",
      name: "gin 1",
      glass: "glass",
      category: "category",
      videoURL: "https://www.x.com",
      instructions: "Instructions 1"
    )
    
    let store = TestStore(
      initialState: DetailFeature.State(
        drink: withVideoURL
      )
    ) {
      DetailFeature()
    } withDependencies: {
      $0.openURL = openURL
    }

    await store.send(.videoButtonTapped)
  }
}
