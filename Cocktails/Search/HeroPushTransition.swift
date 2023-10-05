import UIKit

class HeroPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    return 1 //0.3
  }

  func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    guard 
      let fromVC = transitionContext.viewController(forKey: .from) as? DrinksViewController,
      let toVC = transitionContext.viewController(forKey: .to) as? DetailViewController
    else {
      return
    }
            
    let containerView = transitionContext.containerView
          
    let fromTableView: UITableView = fromVC.tableView
    let toImageView: UIImageView = toVC.imageView
    let toTableView: UITableView = toVC.tableView
            
    guard
      let selectedIndexPath = fromTableView.indexPathForSelectedRow,
      let selectedCell: UITableViewCell = fromTableView.cellForRow(
        at: selectedIndexPath
      ),
      let drinkCell: DrinkCell = selectedCell as? DrinkCell
    else {
      return
    }
    let fromImageView: UIImageView = drinkCell.thumb
            
    // Create a snapshot of the cell's image view
    let imageSnapshot = fromImageView.snapshotView(afterScreenUpdates: false)!
    imageSnapshot.frame = containerView.convert(
      fromImageView.frame,
      from: fromImageView.superview
    )
    fromImageView.isHidden = true
            
    // Set initial state for the destination view controller (it starts off-screen)
    toVC.view.frame = transitionContext.finalFrame(for: toVC)
    print("toVC.view.frame: \(toVC.view.frame)")
    toVC.view.alpha = 0
    toImageView.isHidden = true
    
    let toImageFrame: CGRect
    if toImageView.frame == CGRect.zero {
      print("toTableView.bounds: \(toTableView.bounds)")
      print("fromTableView.bounds: \(fromTableView.bounds)")
      toImageFrame = CGRect(
        x: 20.0,
        y: 150, //-tableView.bounds.origin.y,
        width: toTableView.bounds.width - 40,
        height: toTableView.bounds.width - 40
      )
      print("toImageFrame: \(toImageFrame)")
      print("should be:    (20.0, 150.0, 353.0, 353.0")
    } else {
      toImageFrame = toImageView.frame
    }
            
    containerView.addSubview(toVC.view)
    containerView.addSubview(imageSnapshot)
            
    // Animate
    let duration = transitionDuration(using: transitionContext)
    UIView.animate(
      withDuration: duration,
      animations: {
        toVC.view.alpha = 1.0
        imageSnapshot.frame = containerView.convert(
          toImageFrame,
          from: toImageView.superview
        )
      }, 
      completion: { _ in
        toImageView.isHidden = false
        fromImageView.isHidden = false
        imageSnapshot.removeFromSuperview()
        transitionContext.completeTransition(
          !transitionContext.transitionWasCancelled
        )
      }
    )
//    print("finished animation")
  }
}

//MARK: - UINavigationControllerDelegate

extension DrinksViewController: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController,
    to toVC: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    switch operation {
    case .push:
      return HeroPushTransition()
      
    case .pop:
      print("Pop transition is not handled")
      return HeroPopTransition()
      
    case .none:
      return nil
      
    @unknown default:
      return nil
    }
  }
}
