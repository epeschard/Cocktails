import UIKit

protocol DrinksRouterProtocol {
  func showDetailView(
    for drink:Drink,
    from parent: UIViewController?,
    sender: Any?
  )
}

class MockDrinksRouter: DrinksRouterProtocol {
  var didCallShowDetailView: Bool = false
  func showDetailView(
    for drink: Drink,
    from _: UIViewController?,
    sender: Any?
  ) {
    didCallShowDetailView = true
  }
}

class DrinksRouter: DrinksRouterProtocol {
  func showDetailView(
    for drink: Drink,
    from parent: UIViewController?,
    sender: Any?
  ) {
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
