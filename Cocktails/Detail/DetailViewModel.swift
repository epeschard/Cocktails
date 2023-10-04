import Foundation

class DetailViewModel {
  var view: DetailViewControllerProtocol!
  
  var router: DetailRouterProtocol
  
  var drink: Drink
  
  init(
    router: DetailRouterProtocol,
    drink: Drink
  ) {
    self.router = router
    self.drink = drink
  }
  
  func loadView() {
    self.view.didLoadView()
  }
  
  func imageButtonTapped() {
    if let stringURL = drink.imageURL,
       let imageURL = URL(string: stringURL) {
      router.openImageURL(imageURL)
    }
  }
  
  func videoButtonTapped() {
    if let stringURL = drink.videoURL,
       let videoURL = URL(string: stringURL) {
      router.openVideoURL(videoURL)
    }
  }
}
