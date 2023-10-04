import UIKit

protocol DrinksRouterProtocol {
  func didSelect(_ drink:Drink, from parent: UIViewController?)
}

class MockDrinksRouter: DrinksRouterProtocol {
  var didSelectCalled: Bool = false
  func didSelect(_ drink: Drink, from _: UIViewController?) {
    didSelectCalled = true
  }
}

class DrinksRouter: DrinksRouterProtocol {
  func didSelect(_ drink: Drink, from parent: UIViewController?) {
    let drinkRouter = DetailRouter()
    let detailViewModel = DetailViewModel(
      router: drinkRouter,
      drink: drink
    )
    let detail = DetailViewController()
    detail.viewModel = detailViewModel
    
    detailViewModel.view = detail
    
    parent?.show(detail, sender: self)
  }
}
