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
      store: Store(
        initialState: SearchFeature.State()
      ) {
        SearchFeature(
          fetchDrinks: { query in
            var components = URLComponents()
            components.scheme = "https"
            components.host = "thecocktaildb.com"
            components.path = "/api/json/v1/1/search.php"
            components.queryItems = [
              URLQueryItem(name: "s", value: query)
            ]
            do {
              let (data, _) = try await URLSession.shared
                .data(
                  from: components.url!
                )
            
              let decodedResponse = try JSONDecoder().decode(
                CocktailResponse.self,
                from: data
              )
              return decodedResponse.drinks
            } catch {
              throw error
            }
          }
        )
      }
    )
    window?.rootViewController = searchViewController
    window?.makeKeyAndVisible()
  }
}

