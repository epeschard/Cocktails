import UIKit

class HeroPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    return 5 //0.3
  }

  func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    guard
      let fromVC = transitionContext.viewController(forKey: .from) as? DetailViewController,
      let toVC = transitionContext.viewController(forKey: .to) as? DrinksViewController
    else {
      return
    }
            
    let containerView = transitionContext.containerView
          
    let fromTableView: UITableView = fromVC.tableView
    let toTableView: UITableView = toVC.tableView
    let firstIndexPath = IndexPath(row: 0, section: 0)
            
    guard
      let selectedIndexPath = toTableView.indexPathForSelectedRow,
      let selectedCell: UITableViewCell = toTableView.cellForRow(
        at: selectedIndexPath
      ),
      let drinkCell: DrinkCell = selectedCell as? DrinkCell,
      let fromFirstCell: UITableViewCell = fromTableView.cellForRow(
        at: firstIndexPath
      ),
      let imageCell: ImageCell = fromFirstCell as? ImageCell
    else {
      return
    }
    let fromImageView: UIImageView = imageCell.poster
    let toImageView: UIImageView = drinkCell.thumb
            
    // Create a snapshot of the cell's image view
    let imageSnapshot = fromImageView.snapshotView(afterScreenUpdates: false)!
    imageSnapshot.frame = containerView.convert(
      fromImageView.frame,
      from: fromImageView.superview
    )
    fromImageView.isHidden = true
            
    // Set initial state for the destination view controller (it starts off-screen)
    toVC.view.frame = transitionContext.finalFrame(for: toVC)
    toVC.view.alpha = 0
    fromImageView.isHidden = true
    
    let fromImageFrame: CGRect
    if fromImageView.frame == CGRect.zero {
      fromImageFrame = CGRect(
        x: 20.0,
        y: 150,
        width: fromTableView.bounds.width - 40,
        height: fromTableView.bounds.width - 40
      )
    } else {
      fromImageFrame = fromImageView.frame
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
          toImageView.frame,
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
  }
}
