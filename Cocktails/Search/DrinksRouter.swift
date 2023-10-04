import UIKit

protocol DrinksRouterProtocol {
  func didSelect(_ drink:Drink, from parent: UIViewController?, sender: Any?)
}

class MockDrinksRouter: DrinksRouterProtocol {
  var didSelectCalled: Bool = false
  func didSelect(_ drink: Drink, from _: UIViewController?, sender: Any?) {
    didSelectCalled = true
  }
}

class DrinksRouter: DrinksRouterProtocol {
  func didSelect(_ drink: Drink, from parent: UIViewController?, sender: Any?) {
    let drinkRouter = DetailRouter()
    let detailViewModel = DetailViewModel(
      router: drinkRouter,
      drink: drink
    )
    let detail = DetailViewController()
    detail.viewModel = detailViewModel
    
    detailViewModel.view = detail
    
    parent?.show(detail, sender: sender)
  }
}
