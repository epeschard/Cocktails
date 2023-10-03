import XCTest

@testable import Cocktails

final class DrinkDetailTests: XCTestCase {
  
  func testImageButtonTapped_NoAction() {
    let withoutImageURL = Drink(
      id: "1",
      name: "gin 1",
      glass: "glass",
      category: "category",
      instructions: "Instructions 1"
    )
    
    let mockRouter = MockDetailRouter()
    let viewModel = DetailViewModel(
      router: mockRouter,
      drink: withoutImageURL
    )
    
    viewModel.imageButtonTapped()
    
    XCTAssertFalse(mockRouter.didCallOpenImageURL)
  }
  
  func testImageButtonTapped_CallsRouter() {
    let withImageURL = Drink(
      id: "1",
      name: "gin 1",
      glass: "glass",
      category: "category",
      imageURL: "https://www.x.com",
      instructions: "Instructions 1"
    )
    
    let mockRouter = MockDetailRouter()
    let viewModel = DetailViewModel(
      router: mockRouter,
      drink: withImageURL
    )
    
    viewModel.imageButtonTapped()
    
    XCTAssertTrue(mockRouter.didCallOpenImageURL)
  }
  
  func testVideoButtonTapped_NoAction() {
    let withoutVideoURL = Drink(
      id: "1",
      name: "gin 1",
      glass: "glass",
      category: "category",
      instructions: "Instructions 1"
    )
    
    let mockRouter = MockDetailRouter()
    let viewModel = DetailViewModel(
      router: mockRouter,
      drink: withoutVideoURL
    )
    
    viewModel.videoButtonTapped()
    
    XCTAssertFalse(mockRouter.didCallOpenVideoURL)
  }
  
  func testVideoButtonTapped_CallsRouter() {
    let withVideoURL = Drink(
      id: "1",
      name: "gin 1",
      glass: "glass",
      category: "category",
      videoURL: "https://www.x.com",
      instructions: "Instructions 1"
    )
    
    let mockRouter = MockDetailRouter()
    let viewModel = DetailViewModel(
      router: mockRouter,
      drink: withVideoURL
    )
    
    viewModel.videoButtonTapped()
    
    XCTAssertTrue(mockRouter.didCallOpenVideoURL)
  }
}
