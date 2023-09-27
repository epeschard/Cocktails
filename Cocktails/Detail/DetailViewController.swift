import Combine
import ComposableArchitecture
import UIKit

final class DetailViewController: UIViewController {
//final class DetailVC: UITableViewController {
  let viewStore: ViewStoreOf<DetailFeature>
  var cancellables: Set<AnyCancellable> = []
  var tableView: UITableView!
  
  init(store: StoreOf<DetailFeature>) {
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init(nibName: nil, bundle: nil)
    /*
    tableView = UITableView(frame: view.frame, style: .insetGrouped)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.delegate = self
    tableView.dataSource = self
    
    view.addSubview(tableView)

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
     */
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
 
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView = UITableView(frame: view.frame, style: .insetGrouped)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.delegate = self
    tableView.dataSource = self
    
    view.addSubview(tableView)

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    
    self.tableView.register(
      UITableViewCell.self,
      forCellReuseIdentifier: "default"
    )
    self.tableView.register(
      UITableViewCell.self,
      forCellReuseIdentifier: "subtitle"
    )
    self.tableView.register(
      UITableViewCell.self,
      forCellReuseIdentifier: "value1"
    )
    self.tableView.register(
      UITableViewCell.self,
      forCellReuseIdentifier: "value2"
    )
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let drink = viewStore.drink {
      populate(with: drink)
    }
  }
  
  private func populate(with drink: Drink) {
    title = drink.name
  }
  /*
  private func buildIngredients(for drink: Drink.CodingData?) -> [String: String] {
    var ingredients: [String: String] = Dictionary<String, String>()
    guard let drink = drink?.drinkData else { return ingredients}
    
    if let measure1 = drink.strMeasure1, let ingredient1 = drink.strIngredient1 {
      ingredients[measure1] = ingredient1
    }
    if let measure2 = drink.strMeasure2, let ingredient2 = drink.strIngredient2 {
      ingredients[measure2] = ingredient2
    }
    if let measure3 = drink.strMeasure3, let ingredient3 = drink.strIngredient3 {
      ingredients[measure3] = ingredient3
    }
    if let measure4 = drink.strMeasure4, let ingredient4 = drink.strIngredient4 {
      ingredients[measure4] = ingredient4
    }
    if let measure5 = drink.strMeasure5, let ingredient5 = drink.strIngredient5 {
      ingredients[measure5] = ingredient5
    }
    if let measure6 = drink.strMeasure6, let ingredient6 = drink.strIngredient6 {
      ingredients[measure6] = ingredient6
    }
    if let measure7 = drink.strMeasure7, let ingredient7 = drink.strIngredient7 {
      ingredients[measure7] = ingredient7
    }
    if let measure8 = drink.strMeasure8, let ingredient8 = drink.strIngredient8 {
      ingredients[measure8] = ingredient8
    }
    if let measure9 = drink.strMeasure9, let ingredient9 = drink.strIngredient9 {
      ingredients[measure9] = ingredient9
    }
    if let measure10 = drink.strMeasure10, let ingredient10 = drink.strIngredient10 {
      ingredients[measure10] = ingredient10
    }
    if let measure11 = drink.strMeasure11, let ingredient11 = drink.strIngredient11 {
      ingredients[measure11] = ingredient11
    }
    if let measure12 = drink.strMeasure12, let ingredient12 = drink.strIngredient12 {
      ingredients[measure12] = ingredient12
    }
    if let measure13 = drink.strMeasure13, let ingredient13 = drink.strIngredient13 {
      ingredients[measure13] = ingredient13
    }
    if let measure14 = drink.strMeasure14, let ingredient14 = drink.strIngredient14 {
      ingredients[measure14] = ingredient14
    }
    if let measure15 = drink.strMeasure15, let ingredient15 = drink.strIngredient15 {
      ingredients[measure15] = ingredient15
    }
    return ingredients
  }
  */
}
/*
  private func buildIngredients(for drink: Drink?) -> [String: String] {
    var ingredients: [String: String] = Dictionary<String, String>()
    guard let drink = drink else { return ingredients}
    
    if let measure1 = drink.strMeasure1, let ingredient1 = drink.strIngredient1 {
      ingredients[measure1] = ingredient1
    }
    if let measure2 = drink.strMeasure2, let ingredient2 = drink.strIngredient2 {
      ingredients[measure2] = ingredient2
    }
    if let measure3 = drink.strMeasure3, let ingredient3 = drink.strIngredient3 {
      ingredients[measure3] = ingredient3
    }
    if let measure4 = drink.strMeasure4, let ingredient4 = drink.strIngredient4 {
      ingredients[measure4] = ingredient4
    }
    if let measure5 = drink.strMeasure5, let ingredient5 = drink.strIngredient5 {
      ingredients[measure5] = ingredient5
    }
    if let measure6 = drink.strMeasure6, let ingredient6 = drink.strIngredient6 {
      ingredients[measure6] = ingredient6
    }
    if let measure7 = drink.strMeasure7, let ingredient7 = drink.strIngredient7 {
      ingredients[measure7] = ingredient7
    }
    if let measure8 = drink.strMeasure8, let ingredient8 = drink.strIngredient8 {
      ingredients[measure8] = ingredient8
    }
    if let measure9 = drink.strMeasure9, let ingredient9 = drink.strIngredient9 {
      ingredients[measure9] = ingredient9
    }
    if let measure10 = drink.strMeasure10, let ingredient10 = drink.strIngredient10 {
      ingredients[measure10] = ingredient10
    }
    if let measure11 = drink.strMeasure11, let ingredient11 = drink.strIngredient11 {
      ingredients[measure11] = ingredient11
    }
    if let measure12 = drink.strMeasure12, let ingredient12 = drink.strIngredient12 {
      ingredients[measure12] = ingredient12
    }
    if let measure13 = drink.strMeasure13, let ingredient13 = drink.strIngredient13 {
      ingredients[measure13] = ingredient13
    }
    if let measure14 = drink.strMeasure14, let ingredient14 = drink.strIngredient14 {
      ingredients[measure14] = ingredient14
    }
    if let measure15 = drink.strMeasure15, let ingredient15 = drink.strIngredient15 {
      ingredients[measure15] = ingredient15
    }
    return ingredients
  }
}
*/
extension DetailViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    let ingredients = viewStore.drink?.ingredients
    switch section {
    case 0:
      return 5
    case 1:
      return 1
    case 2:
      return ingredients?.count ?? 0
    default:
      return 0
    }
  }
  
  func tableView(
    _ tableView: UITableView, 
    titleForHeaderInSection section: Int
  ) -> String? {
    switch section {
    case 0:
      return nil
    case 1:
      return "Instructions"
    case 2:
      return "Ingredients"
    default:
      return nil
    }
  }
  
  func tableView(
    _ tableView: UITableView,
    viewForFooterInSection section: Int
  ) -> UIView? {
    switch section {
    case 0:
      let tags = viewStore.drink?.tags.map {
        let tag = UILabel()
        tag.text = " \($0)  "
        tag.font = UIFont.preferredFont(forTextStyle: .footnote)
        tag.textColor = .gray
        tag.sizingRule = .oversize
        tag.textAlignment = .center
        tag.layer.borderColor = UIColor.gray.cgColor
        tag.layer.borderWidth = 1.0
        tag.layer.cornerRadius = 5.0
        tag.layer.masksToBounds = true
        return tag
      }
      if let tags = tags {
        let title = UILabel()
        title.text = "    TAGS:"
        title.textColor = .gray
        title.font = UIFont.preferredFont(forTextStyle: .footnote)
        let stack = UIStackView(arrangedSubviews: tags)
        stack.spacing = 5.0
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        let footer = UIStackView(
          arrangedSubviews: [title, stack, UIView()]
        )
        footer.spacing = 8.0
        return footer
      } else {
        return nil
      }
      
    default:
      return nil
    }
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      var cell: UITableViewCell? = tableView.dequeueReusableCell(
        withIdentifier: "subtitle",
        for: indexPath
      )
      if cell == nil || cell?.detailTextLabel == nil {
        cell = UITableViewCell(
          style: .subtitle,
          reuseIdentifier: "subtitle"
        )
      }
      switch indexPath.row {
      case 0:
        cell!.textLabel?.text = viewStore.drink?.name
        cell!.detailTextLabel?.text = "Name"
      case 1:
        cell!.textLabel?.text = viewStore.drink?.category
        cell!.detailTextLabel?.text = "Category"
      case 2:
        cell!.textLabel?.text = viewStore.drink?.glass
        cell!.detailTextLabel?.text = "Glass"
      case 3:
        cell!.textLabel?.text = viewStore.drink?.alternateName
        cell!.detailTextLabel?.text = "Alternate Drink"
      case 4:
        cell!.textLabel?.text = viewStore.drink?.tagString
        cell!.detailTextLabel?.text = "Tags"
      default:
        cell!.textLabel?.text = viewStore.drink?.id //.idDrink
        cell!.detailTextLabel?.text = "Identifier"
      }
      return cell!
      
    case 1:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "default",
        for: indexPath
      )
      cell.textLabel?.numberOfLines = 0
      cell.textLabel?.text = viewStore.drink?.instructions
      return cell
      
    case 2:
      var cell: UITableViewCell? = tableView.dequeueReusableCell(
        withIdentifier: "value1",
        for: indexPath
      )
      if cell == nil || cell?.detailTextLabel == nil {
        cell = UITableViewCell(
          style: .value1,
          reuseIdentifier: "value1"
        )
      }
      let ingredients: [String: String] = viewStore.drink?.ingredients ?? [:]
      if ingredients.isEmpty {
          cell!.textLabel?.text = "No measure"
          cell!.detailTextLabel?.text = " No ingredient"
      } else {
        let measure = Array(ingredients.keys)[indexPath.row]
/*        let index = ingredients.index(
          ingredients.startIndex,
          offsetBy: indexPath.row
        )
        let measure = Array(ingredients.keys)[index]*/
        cell!.textLabel?.text = ingredients[measure]
        cell!.detailTextLabel?.text = measure
      }
      return cell!
      
    default:
      var cell = tableView.dequeueReusableCell(
        withIdentifier: "default",
        for: indexPath
      )
      cell.textLabel?.text = "default"
      return cell
    }
  }
}

extension DetailViewController: UITableViewDelegate {
  
}
