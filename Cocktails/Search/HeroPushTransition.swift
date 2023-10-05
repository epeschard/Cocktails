import UIKit

class HeroPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    return 0.3
  }

  func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    guard 
      let fromVC = transitionContext.viewController(forKey: .from) as? DrinksViewController,
      let toVC = transitionContext.viewController(forKey: .to) as? DetailViewController
    else {
      transitionContext.completeTransition(false)
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
      transitionContext.completeTransition(false)
      return
    }
    let fromImageView: UIImageView = drinkCell.thumb
    let fromTitle: UILabel = drinkCell.title
            
    // Create a snapshot of the cell's image view
    let imageSnapshot = fromImageView.snapshotView(afterScreenUpdates: false)!
    imageSnapshot.frame = containerView.convert(
      fromImageView.frame,
      from: fromImageView.superview
    )
    fromImageView.isHidden = true
    
    // Create a snapshot of the cell's title label
    let titleSnapshot = fromTitle.snapshotView(afterScreenUpdates: false)!
    titleSnapshot.frame = containerView.convert(
      fromTitle.frame,
      from: fromTitle.superview
    )
    fromTitle.isHidden = true
            
    // Set initial state for the destination view controller (it starts off-screen)
    toVC.view.frame = transitionContext.finalFrame(for: toVC)
    toVC.view.alpha = 0
    toImageView.isHidden = true
    
    //TODO: calculate frame instead of hardcoding
    let toImageFrame: CGRect
    if toImageView.frame == CGRect.zero {
      toImageFrame = CGRect(
        x: 20.0,
        y: 150,
        width: toTableView.bounds.width - 40,
        height: toTableView.bounds.width - 40
      )
    } else {
      toImageFrame = toImageView.frame
    }
    let toImageFrameConvert = containerView.convert(
      toImageView.frame,
      to: toImageView.superview
    )
    containerView.addSubview(toVC.view)
    containerView.addSubview(imageSnapshot)
    containerView.addSubview(titleSnapshot)
            
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
        titleSnapshot.frame = CGRect(
          x: 16,
          y: 104,
          width: 124,
          height: 41
        )
      },
      completion: { _ in
        toImageView.isHidden = false
        fromImageView.isHidden = false
        imageSnapshot.removeFromSuperview()
        titleSnapshot.removeFromSuperview()
        transitionContext.completeTransition(
          !transitionContext.transitionWasCancelled
        )
      }
    )
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
      return HeroPopTransition()
      
    case .none:
      return nil
      
    @unknown default:
      return nil
    }
  }
}
