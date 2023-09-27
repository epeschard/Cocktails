import Foundation

struct Cocktail: Decodable {
  var drinks: [Drink]
}

struct Drink: Decodable {
  
  private enum CodingKeys: String, CodingKey {
    case id = "idDrink"
    case name = "strDrink"
    case tagString = "strTags"
    case glass = "strGlass"
    case category = "strCategory"

    case iba = "strIBA"
    case alcoholic = "strAlcoholic"
    
    case ingredient1 = "strIngredient1"
    case ingredient2 = "strIngredient2"
    case ingredient3 = "strIngredient3"
    case ingredient4 = "strIngredient4"
    case ingredient5 = "strIngredient5"
    case ingredient6 = "strIngredient6"
    case ingredient7 = "strIngredient7"
    case ingredient8 = "strIngredient8"
    case ingredient9 = "strIngredient9"
    case ingredient10 = "strIngredient10"
    case ingredient11 = "strIngredient11"
    case ingredient12 = "strIngredient12"
    case ingredient13 = "strIngredient13"
    case ingredient14 = "strIngredient14"
    case ingredient15 = "strIngredient15"
    
    case measure1 = "strMeasure1"
    case measure2 = "strMeasure2"
    case measure3 = "strMeasure3"
    case measure4 = "strMeasure4"
    case measure5 = "strMeasure5"
    case measure6 = "strMeasure6"
    case measure7 = "strMeasure7"
    case measure8 = "strMeasure8"
    case measure9 = "strMeasure9"
    case measure10 = "strMeasure10"
    case measure11 = "strMeasure11"
    case measure12 = "strMeasure12"
    case measure13 = "strMeasure13"
    case measure14 = "strMeasure14"
    case measure15 = "strMeasure15"
    
    case thumbnail = "strDrinkThumb"
    case imageURL = "strImageSource"
    case videoURL = "strVideo"

    case instructions = "strInstructions"
    case instructionsES = "strInstructionsES"
    case instructionsDE = "strInstructionsDE"
    case instructionsFR = "strInstructionsFR"
    case instructionsIT = "strInstructionsIT"
    case instructionsZH_HANS = "strInstructionsZH-HANS"
    case instructionsZH_HANT = "strInstructionsZH-HANT"
    
    case alternateName = "strDrinkAlternate"
  }
  
  var id: String
  var name: String
  var alternateName: String?
  
  var tagString: String?

  var glass: String
  var category: String
  
  var thumbnail: String?
  var imageURL: String?
  var videoURL: String?
  
  var iba: String?
  var alcoholic: String?

  var ingredient1: String?
  var ingredient2: String?
  var ingredient3: String?
  var ingredient4: String?
  var ingredient5: String?
  var ingredient6: String?
  var ingredient7: String?
  var ingredient8: String?
  var ingredient9: String?
  var ingredient10: String?
  var ingredient11: String?
  var ingredient12: String?
  var ingredient13: String?
  var ingredient14: String?
  var ingredient15: String?
  
  var measure1: String?
  var measure2: String?
  var measure3: String?
  var measure4: String?
  var measure5: String?
  var measure6: String?
  var measure7: String?
  var measure8: String?
  var measure9: String?
  var measure10: String?
  var measure11: String?
  var measure12: String?
  var measure13: String?
  var measure14: String?
  var measure15: String?

  var instructions: String
  var instructionsES: String?
  var instructionsDE: String?
  var instructionsFR: String?
  var instructionsIT: String?
  var instructionsZH_HANS: String?
  var instructionsZH_HANT: String?
  
  var strImageAttribution: String?
  var strCreativeCommonsConfirmed: String?
  var dateModified: String?
  
  //MARK: - Computed Properties
  
  var tags: [String] {
    return tagString?.components(separatedBy: ",") ?? []
  }
  
  var ingredients: Dictionary<String, String> {
    var ingredients: [String: String] = [String: String]()
    if let measure1 = measure1, let ingredient1 = ingredient1 {
      ingredients[measure1] = ingredient1
    }
    if let measure2 = measure2, let ingredient2 = ingredient2 {
      ingredients[measure2] = ingredient2
    }
    if let measure3 = measure3, let ingredient3 = ingredient3 {
      ingredients[measure3] = ingredient3
    }
    if let measure4 = measure4, let ingredient4 = ingredient4 {
      ingredients[measure4] = ingredient4
    }
    if let measure5 = measure5, let ingredient5 = ingredient5 {
      ingredients[measure5] = ingredient5
    }
    if let measure6 = measure6, let ingredient6 = ingredient6 {
      ingredients[measure6] = ingredient6
    }
    if let measure7 = measure7, let ingredient7 = ingredient7 {
      ingredients[measure7] = ingredient7
    }
    if let measure8 = measure8, let ingredient8 = ingredient8 {
      ingredients[measure8] = ingredient8
    }
    if let measure9 = measure9, let ingredient9 = ingredient9 {
      ingredients[measure9] = ingredient9
    }
    if let measure10 = measure10, let ingredient10 = ingredient10 {
      ingredients[measure10] = ingredient10
    }
    if let measure11 = measure11, let ingredient11 = ingredient11 {
      ingredients[measure11] = ingredient11
    }
    if let measure12 = measure12, let ingredient12 = ingredient12 {
      ingredients[measure12] = ingredient12
    }
    if let measure13 = measure13, let ingredient13 = ingredient13 {
      ingredients[measure13] = ingredient13
    }
    if let measure14 = measure14, let ingredient14 = ingredient14 {
      ingredients[measure14] = ingredient14
    }
    if let measure15 = measure15, let ingredient15 = ingredient15 {
      ingredients[measure15] = ingredient15
    }

    return ingredients
  }
}

extension Drink: Equatable {}
