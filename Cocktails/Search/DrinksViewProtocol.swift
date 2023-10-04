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

//import XCTest

class TestDrinksView: DrinksViewProtocol {
/*
  //  var expectation1: XCTestExpectation
//  var expectation2: XCTestExpectation
  var expectation3: XCTestExpectation!
  var expectation4: XCTestExpectation!
  var expectation5: XCTestExpectation!
  var expectation6: XCTestExpectation!
  /*
  init(
//    expectation1: XCTestExpectation,
//    expectation2: XCTestExpectation,
    expectation3: XCTestExpectation,
    expectation4: XCTestExpectation,
    expectation5: XCTestExpectation,
    expectation6: XCTestExpectation,
    didLoadViewWasCalled: Bool = false,
    didFetchDrinksWasCalled: Bool = false,
    startLoadingWasCalled: Bool = false,
    finishLoadingWasCalled: Bool = false
  ) {
//    self.expectation1 = expectation1
//    self.expectation2 = expectation2
    self.expectation3 = expectation3
    self.expectation4 = expectation4
    self.expectation5 = expectation5
    self.expectation6 = expectation6
    self.didLoadViewWasCalled = didLoadViewWasCalled
    self.didFetchDrinksWasCalled = didFetchDrinksWasCalled
    self.startLoadingWasCalled = startLoadingWasCalled
    self.finishLoadingWasCalled = finishLoadingWasCalled
  }
  */
*/
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
//    expectation3.fulfill()
    startLoadingWasCalled = true
  }
  
  var finishLoadingWasCalled = false
  func finishLoading() {
    finishLoadingWasCalled = true
  }
}
