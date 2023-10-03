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
      alternateName: nil,
      tagString: nil,
      glass: "glass",
      category: "category",
      thumbnail: nil,
      imageURL: nil,
      videoURL: nil,
      iba: nil,
      alcoholic: nil,
      ingredient1: nil,
      ingredient2: nil,
      ingredient3: nil,
      ingredient4: nil,
      ingredient5: nil,
      ingredient6: nil,
      ingredient7: nil,
      ingredient8: nil,
      ingredient9: nil,
      ingredient10: nil,
      ingredient11: nil,
      ingredient12: nil,
      ingredient13: nil,
      ingredient14: nil,
      ingredient15: nil,
      measure1: nil,
      measure2: nil,
      measure3: nil,
      measure4: nil,
      measure5: nil,
      measure6: nil,
      measure7: nil,
      measure8: nil,
      measure9: nil,
      measure10: nil,
      measure11: nil,
      measure12: nil,
      measure13: nil,
      measure14: nil,
      measure15: nil,
      instructions: "Instructions 1",
      strImageAttribution: nil,
      strCreativeCommonsConfirmed: nil,
      dateModified: nil
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
      alternateName: nil,
      tagString: nil,
      glass: "glass",
      category: "category",
      thumbnail: nil,
      imageURL: "https://www.x.com",
      videoURL: nil,
      iba: nil,
      alcoholic: nil,
      ingredient1: nil,
      ingredient2: nil,
      ingredient3: nil,
      ingredient4: nil,
      ingredient5: nil,
      ingredient6: nil,
      ingredient7: nil,
      ingredient8: nil,
      ingredient9: nil,
      ingredient10: nil,
      ingredient11: nil,
      ingredient12: nil,
      ingredient13: nil,
      ingredient14: nil,
      ingredient15: nil,
      measure1: nil,
      measure2: nil,
      measure3: nil,
      measure4: nil,
      measure5: nil,
      measure6: nil,
      measure7: nil,
      measure8: nil,
      measure9: nil,
      measure10: nil,
      measure11: nil,
      measure12: nil,
      measure13: nil,
      measure14: nil,
      measure15: nil,
      instructions: "Instructions 1",
      strImageAttribution: nil,
      strCreativeCommonsConfirmed: nil,
      dateModified: nil
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
      alternateName: nil,
      tagString: nil,
      glass: "glass",
      category: "category",
      thumbnail: nil,
      imageURL: nil,
      videoURL: nil,
      iba: nil,
      alcoholic: nil,
      ingredient1: nil,
      ingredient2: nil,
      ingredient3: nil,
      ingredient4: nil,
      ingredient5: nil,
      ingredient6: nil,
      ingredient7: nil,
      ingredient8: nil,
      ingredient9: nil,
      ingredient10: nil,
      ingredient11: nil,
      ingredient12: nil,
      ingredient13: nil,
      ingredient14: nil,
      ingredient15: nil,
      measure1: nil,
      measure2: nil,
      measure3: nil,
      measure4: nil,
      measure5: nil,
      measure6: nil,
      measure7: nil,
      measure8: nil,
      measure9: nil,
      measure10: nil,
      measure11: nil,
      measure12: nil,
      measure13: nil,
      measure14: nil,
      measure15: nil,
      instructions: "Instructions 1",
      strImageAttribution: nil,
      strCreativeCommonsConfirmed: nil,
      dateModified: nil
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
      alternateName: nil,
      tagString: nil,
      glass: "glass",
      category: "category",
      thumbnail: nil,
      imageURL: nil,
      videoURL: "https://www.x.com",
      iba: nil,
      alcoholic: nil,
      ingredient1: nil,
      ingredient2: nil,
      ingredient3: nil,
      ingredient4: nil,
      ingredient5: nil,
      ingredient6: nil,
      ingredient7: nil,
      ingredient8: nil,
      ingredient9: nil,
      ingredient10: nil,
      ingredient11: nil,
      ingredient12: nil,
      ingredient13: nil,
      ingredient14: nil,
      ingredient15: nil,
      measure1: nil,
      measure2: nil,
      measure3: nil,
      measure4: nil,
      measure5: nil,
      measure6: nil,
      measure7: nil,
      measure8: nil,
      measure9: nil,
      measure10: nil,
      measure11: nil,
      measure12: nil,
      measure13: nil,
      measure14: nil,
      measure15: nil,
      instructions: "Instructions 1",
      strImageAttribution: nil,
      strCreativeCommonsConfirmed: nil,
      dateModified: nil
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
