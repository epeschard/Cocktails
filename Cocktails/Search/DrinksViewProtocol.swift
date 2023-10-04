import Foundation

protocol DrinksViewProtocol {
  func didLoadView()
  func startLoading()
  func finishLoading()
  func didFetchDrinks()
}

extension DrinksViewController: DrinksViewProtocol {
  func didLoadView() {
    title = "Cocktails"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    setupLoadingView()
    setupTableView()
    setupSearchController()
    
    tableView.reloadData()
  }
  
  func didFetchDrinks() {
    DispatchQueue.main.async { [weak self] in
      self?.tableView.separatorStyle = .singleLine
      self?.tableView.reloadData()
    }
  }
  
  func startLoading() {
    loadingView.startAnimating()
  }
  
  func finishLoading() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      if let loadingView = self.loadingView {
        loadingView.stopAnimating()
      }
      self.tableView.separatorStyle = .singleLine
      self.tableView.reloadData()
    }
  }
}

class TestDrinksView: DrinksViewProtocol {
  var didLoadViewWasCalled = false
  func didLoadView() {
    didLoadViewWasCalled = true
  }
  
  var didFetchDrinksWasCalled = false
  func didFetchDrinks() {
    didFetchDrinksWasCalled = true
  }
  
  var startLoadingWasCalled = false
  func startLoading() {
    startLoadingWasCalled = true
  }
  
  var finishLoadingWasCalled = false
  func finishLoading() {
    finishLoadingWasCalled = true
  }
}
