import Combine
import ComposableArchitecture
import SDWebImage
import UIKit

final class DetailViewController: UIViewController {
  var viewModel: DetailViewModel!
  var tableView: UITableView!
  var imageView: UIImageView!
  
  //MARK: - Initializers

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Lifecycle Overrides
 
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = viewModel.drink.name
    navigationController?.navigationBar.prefersLargeTitles = true
    
    setupTableView()
  }
}

//MARK: - UITableViewDataSource

extension DetailViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    let drink = viewModel.drink
    switch section {
    case 0:
      return drink.tags.isEmpty ? 2 : 3
    case 1:
      return drink.videoURL == nil ? 1 : 2
    case 2:
      return drink.ingredients.count
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
    titleForFooterInSection section: Int
  ) -> String? {
    if section == 2, viewModel.drink.dateModified != nil {
      return viewModel.drink.dateModified ?? ""
    }
    return nil
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let imageCell: ImageCell = tableView.dequeueReusableCell(
      withIdentifier: ImageCell.reuseIdentifier,
      for: indexPath
    ) as! ImageCell
    
    var subtitleCell: UITableViewCell? = tableView.dequeueReusableCell(
      withIdentifier: "subtitle",
      for: indexPath
    )
    if subtitleCell == nil || subtitleCell?.detailTextLabel == nil {
      subtitleCell = UITableViewCell(
        style: .subtitle,
        reuseIdentifier: "subtitle"
      )
    }
    subtitleCell?.selectionStyle = .none
    
    var valueCell: UITableViewCell? = tableView.dequeueReusableCell(
      withIdentifier: "value2",
      for: indexPath
    )
    if valueCell == nil || valueCell?.detailTextLabel == nil {
      valueCell = UITableViewCell(
        style: .value1,
        reuseIdentifier: "value2"
      )
    }
    valueCell?.selectionStyle = .none
    
    let drink = viewModel.drink
    
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0:
        imageCell.configure(with: drink)
        return imageCell
      case 1:
        subtitleCell!.textLabel?.text = drink.category
        subtitleCell!.detailTextLabel?.text = "Category"
      case 2:
        subtitleCell!.textLabel?.text = drink.glass
        subtitleCell!.detailTextLabel?.text = "Glass"
      case 3:
        let tags = drink.tagString?.replacingOccurrences(
          of: ",",
          with: ", "
        )
        valueCell!.textLabel?.text = "Tags"
        valueCell!.detailTextLabel?.text = tags

        return valueCell!
      default:
        subtitleCell!.textLabel?.text = drink.id
        subtitleCell!.detailTextLabel?.text = "Identifier"
      }
      return subtitleCell!
      
    case 1:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "default",
        for: indexPath
      )
      
      switch indexPath.row {
      case 0:
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = drink.instructions
        return cell
        
      case 1:
        cell.imageView?.image = UIImage(systemName: "video")
        cell.selectionStyle = .blue
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Show me the video"
        return cell
        
      default:
        cell.textLabel?.text = drink.name
        return cell
      }
        
      
    case 2:
      let ingredients: [(name: String, measure: String)] = drink.ingredients
      if ingredients.isEmpty {
        valueCell!.textLabel?.text = "No measure"
        valueCell!.detailTextLabel?.text = " No ingredient"
      } else {
        let ingredient = ingredients[indexPath.row]
        valueCell!.textLabel?.text = ingredient.name
        valueCell!.detailTextLabel?.text = ingredient.measure
      }
      return valueCell!
      
    default:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "default",
        for: indexPath
      )
      cell.textLabel?.text = "default"
      return cell
    }
  }
}

//MARK: - UITableViewDelegate

extension DetailViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    switch indexPath.section {
    case 0:
      if indexPath.row == 0 {
        viewModel.imageButtonTapped()
        tableView.deselectRow(at: indexPath, animated: true)
        return
      }
      return
    case 1:
      if indexPath.row == 1 {
        viewModel.videoButtonTapped()
        tableView.deselectRow(at: indexPath, animated: true)
        return
      }
      return
    case 2:
      return
    default:
      return
    }
  }
}

//MARK: - Private

private extension DetailViewController {

  func setupTableView() {
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
      ImageCell.self,
      forCellReuseIdentifier: ImageCell.reuseIdentifier
    )
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
      forCellReuseIdentifier: "value2"
    )
  }
}

//MARK: - DetailViewControllerProtocol

protocol DetailViewControllerProtocol {
  func didLoadView()
}

extension DetailViewController: DetailViewControllerProtocol {
  func didLoadView() {
    tableView.reloadData()
    /*
    let indexPaths = [
      IndexPath(row: <#T##Int#>, section: <#T##Int#>),
      IndexPath(row: Int, section: <#T##Int#>),
      IndexPath(row: <#T##Int#>, section: <#T##Int#>),
    ]
    tableView.reloadRows(
      at: indexPaths,
      with: .automatic
    )*/
  }
}
