import ComposableArchitecture
import Foundation

struct TheCocktailDbClient {
  var fetchDrinks: @Sendable (String) async throws -> [Drink]
}

extension TheCocktailDbClient: DependencyKey {
  static let liveValue = Self { query in
    var components = URLComponents()
    components.scheme = "https"
    components.host = "thecocktaildb.com"
    components.path = "/api/json/v1/1/search.php"
    components.queryItems = [
      URLQueryItem(name: "s", value: query)
    ]
    guard let componentsUrl = components.url else {
      throw FetchDrinksError.invalidUrl
    }
    
    guard let (data, _) = try? await URLSession.shared
      .data(from: componentsUrl) else {
      throw FetchDrinksError.noDataFromResponse
    }
    
    do {
      let decodedResponse = try JSONDecoder().decode(
        Cocktail.self,
        from: data
      )
      return decodedResponse.drinks
    } catch {
      throw FetchDrinksError.decodingFailed
    }
  }
}

extension DependencyValues {
  var theCocktailDb: TheCocktailDbClient {
    get { self[TheCocktailDbClient.self] }
    set { self[TheCocktailDbClient.self] = newValue }
  }
}
