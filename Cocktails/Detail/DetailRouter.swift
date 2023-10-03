import UIKit

protocol DetailRouterProtocol {
  func openImageURL(_ imageURL: URL)
  func openVideoURL(_ videoURL: URL)
}

class MockDetailRouter: DetailRouterProtocol {
  var didCallOpenImageURL = false

  func openImageURL(_ imageURL: URL) {
    didCallOpenImageURL = true
  }
  
  var didCallOpenVideoURL = false

  func openVideoURL(_ videoURL: URL) {
    didCallOpenVideoURL = true
  }
}

class DetailRouter: DetailRouterProtocol {
  private func open(_ url: URL) {
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
        UIApplication.shared.openURL(url)
    }
  }
  
  func openImageURL(_ imageURL: URL) {
    open(imageURL)
  }
  
  func openVideoURL(_ videoURL: URL) {
    open(videoURL)
  }
}
