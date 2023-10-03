import Foundation

//MARK: - Equatable

extension TheCocktailDbClient.FetchDrinksError: Equatable {}

//MARK: - Error

extension TheCocktailDbClient {  
  enum FetchDrinksError: Error {
    case noDataFromResponse
    case decodingFailed
    case invalidUrl
  }
}

extension TheCocktailDbClient.FetchDrinksError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidUrl:
      return NSLocalizedString(
        "Invalid URL",
        comment: ""
      )
      
    case .noDataFromResponse:
      return NSLocalizedString(
        "Received no data from response",
        comment: ""
      )
      
    case .decodingFailed:
      return NSLocalizedString(
        "Failed decoding JSON",
        comment: ""
      )
    }
  }
}
