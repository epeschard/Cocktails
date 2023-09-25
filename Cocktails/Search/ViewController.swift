import ComposableArchitecture
import Combine
import UIKit

//class SearchViewController: UIViewController {
//  let tableView = UITableView()
class SearchViewController: UITableViewController {
  let viewStore: ViewStoreOf<SearchFeature>
  var cancellables: Set<AnyCancellable> = []
  
  init(store: StoreOf<SearchFeature>) {
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.register(
      UITableViewCell.self,
      forCellReuseIdentifier: "DrinkCell"
    )
    
    viewStore.publisher.drinks
      .sink { [weak self] _ in
        self?.tableView.reloadData()
      }
      .store(in: &cancellables)
    
    viewStore.send(.loadDrinks)
    title = "Cocktails"
  }
  
  //MARK: - UITableViewDataSource
  
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return viewStore.drinks.count
  }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    var cell: UITableViewCell? = tableView.dequeueReusableCell(
      withIdentifier: "DrinkCell",
      for: indexPath
    )
    if cell == nil || cell?.detailTextLabel == nil {
      cell = UITableViewCell(
        style: .subtitle,
        reuseIdentifier: "DrinkCell"
      )
    }
    let drink = viewStore.drinks[indexPath.row]
    cell!.textLabel?.text = drink.strDrink
    cell!.detailTextLabel?.text = drink.strInstructions
    
    return cell!
  }
}
