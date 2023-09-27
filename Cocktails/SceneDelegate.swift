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
    let splitViewController = UISplitViewController(style: .doubleColumn)
    let searchViewController = SearchViewController(
      store: Store(initialState: SearchFeature.State()) {
        SearchFeature()
      }
    )
    let detailViewController = DetailViewController(
      store: Store(initialState: DetailFeature.State()) {
        DetailFeature()
      }
    )
    splitViewController.setViewController(
      searchViewController,
      for: .primary
    )
    splitViewController.setViewController(
      detailViewController,
      for: .secondary
    )
//    splitViewController.preferredDisplayMode = .oneOverSecondary
//    splitViewController.isCollapsed = false

//    splitViewController.preferredSplitBehavior = .displace

    window?.rootViewController = splitViewController
    window?.makeKeyAndVisible()
  }
}

