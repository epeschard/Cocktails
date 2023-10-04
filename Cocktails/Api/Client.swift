import Foundation

struct TheCocktailDbClient {
  var fetchDrinks: @Sendable (String) async throws -> IdentifiedArrayOf<Drink>
}

extension TheCocktailDbClient: DependencyKey {

  static let liveValue = Self { query in
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    configuration.urlCache = URLCache(
      memoryCapacity: 10 * 1024 * 1024,
      diskCapacity: 50 * 1024 * 1024,
      diskPath: nil
    )
    let urlSession = URLSession(configuration: configuration)
    
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
    
    guard let (data, _) = try? await urlSession
      .data(from: componentsUrl) else {
      throw FetchDrinksError.noDataFromResponse
    }
    
    do {
      let decodedResponse = try JSONDecoder().decode(
        Cocktail.self,
        from: data
      )
      let drinks = decodedResponse.drinks
      
      return IdentifiedArray(
        uniqueElements: drinks.map { $0 }
      )
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
