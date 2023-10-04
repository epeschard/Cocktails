import ComposableArchitecture
import UIKit

final class SceneDelegate: UIResponder {
  
  var window: UIWindow?
  
}

extension SceneDelegate: UIWindowSceneDelegate {
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard
        let windowScene = (scene as? UIWindowScene)
    else { return }
    window = UIWindow(windowScene: windowScene)
    
    let router = DrinksRouter()
    let viewModel = DrinksViewModel(
      router: router,
      theCocktailDb: TheCocktailDbClient.liveValue
    )
    let drinksViewController = DrinksViewController()
    viewModel.view = drinksViewController
    drinksViewController.viewModel = viewModel

    window?.rootViewController = UINavigationController(
      rootViewController: drinksViewController
    )
    window?.makeKeyAndVisible()
  }
}

