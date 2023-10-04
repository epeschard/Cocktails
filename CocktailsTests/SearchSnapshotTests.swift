import SnapshotTesting
import XCTest

@testable import Cocktails

class SearchSnapshotTests: XCTestCase {
  
  func testSearchDrinksVC_Loaded() {
    let mockRouter = MockDrinksRouter()
    let viewModel = DrinksViewModel(
      router: mockRouter,
      theCocktailDb: TheCocktailDbClient.testValue
    )
    let rootVC = DrinksViewController()
    viewModel.view = rootVC
    rootVC.viewModel = viewModel
    let nav = UINavigationController(rootViewController: rootVC)
    
    viewModel.loadView()
    viewModel.search(query: "gin")

    assertSnapshots(of: nav, as: ["3": .image(on: .iPhone13)])
  }
  
  func testSearchDrinksVC_Error() {    
    let mockRouter = MockDrinksRouter()
    let viewModel = DrinksViewModel(
      router: mockRouter,
      theCocktailDb: TheCocktailDbClient.testInvalidUrl
    )
    let rootVC = DrinksViewController()
    viewModel.view = rootVC
    rootVC.viewModel = viewModel
    let nav = UINavigationController(rootViewController: rootVC)
    
    viewModel.loadView()
    viewModel.search(query: "gin")

    assertSnapshots(of: nav, as: ["Data": .image(on: .iPhone13)])
  }
  
  func testSearchDrinksVC_Loading() {
    let mockRouter = MockDrinksRouter()
    let viewModel = DrinksViewModel(
      router: mockRouter,
      theCocktailDb: TheCocktailDbClient.testEmpty
    )
    let rootVC = DrinksViewController()
    viewModel.view = rootVC
    rootVC.viewModel = viewModel
    let nav = UINavigationController(rootViewController: rootVC)
    
    viewModel.loadView()
    viewModel.search(query: "gin")

    assertSnapshots(of: nav, as: ["Empty": .image(on: .iPhone13)])
  }
}
