import Foundation

struct CocktailResponse: Decodable {
  var drinks: [Drink]
}
struct Drink: Decodable {
  var idDrink: String
  var strDrink: String
  var strInstructions: String
}

extension Drink: Equatable {}
