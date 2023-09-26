import ComposableArchitecture
import UIKit

class SceneDelegate: UIResponder {
  
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
    let searchViewController = SearchViewController(
      store: Store(initialState: SearchFeature.State()) {
        SearchFeature()
      }
    )
    window?.rootViewController = searchViewController
    window?.makeKeyAndVisible()
  }
}

