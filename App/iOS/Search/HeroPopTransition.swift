import UIKit

class HeroPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    return 0.3
  }

  func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    guard
      let fromVC = transitionContext.viewController(forKey: .from) as? DetailViewController,
      let fromNavBar = fromVC.navigationController?.navigationBar,
      let toVC = transitionContext.viewController(forKey: .to) as? DrinksViewController,
      let toNavBar = toVC.navigationController?.navigationBar,
      // This code digs into the internal subviews of UINavigationBar and
      // searches for a view with a specific name. Apple's internal view
      // hierarchy and naming conventions are not guaranteed to stay the
      // same across iOS versions. This means that this approach can break
      // with new iOS updates.
      let toLargeTitle = toNavBar.subviews.first(
        where: {
          String(describing: type(of: $0)) == "_UINavigationBarLargeTitleView"
        }
      ),
      let fromLargeTitle = fromNavBar.subviews.first(
        where: {
          String(describing: type(of: $0)) == "_UINavigationBarLargeTitleView"
        }
      )
    else {
      transitionContext.completeTransition(false)
      return
    }
            
    let containerView = transitionContext.containerView
          
    let fromTableView: UITableView = fromVC.tableView
    let toTableView: UITableView = toVC.tableView
    
    
    var firstImageCell: ImageCell? = nil
    for cell in fromTableView.visibleCells {
      if let imageCell = cell as? ImageCell {
        firstImageCell = imageCell
        break
      }
    }
            
    guard
      let selectedIndexPath = toTableView.indexPathForSelectedRow,
      let selectedCell: UITableViewCell = toTableView.cellForRow(
        at: selectedIndexPath
      ),
      let drinkCell: DrinkCell = selectedCell as? DrinkCell,
      let imageCell = firstImageCell
    else {
      transitionContext.completeTransition(false)
      return
    }
    let fromImageView: UIImageView = imageCell.poster
    let toImageView: UIImageView = drinkCell.thumb
    let toTitleLabel: UILabel = drinkCell.title
    
    let fromLargeTitleFrameInNavigationBar = fromLargeTitle.frame
            
    // Create a snapshot of the cell's image view
    let imageSnapshot = fromImageView.snapshotView(afterScreenUpdates: false)!
    imageSnapshot.frame = containerView.convert(
      fromImageView.frame,
      from: fromImageView.superview
    )
    fromImageView.isHidden = true
    
    // Create a snapshot of the LargeTitle's label
    let titleSnapshot = fromLargeTitle.snapshotView(afterScreenUpdates: false)!
    titleSnapshot.frame = containerView.convert(
      fromLargeTitle.frame,
      from: fromLargeTitle.superview
    )
    fromLargeTitle.isHidden = true
            
    // Set initial state for the destination view controller (it starts off-screen)
    toVC.view.frame = transitionContext.finalFrame(for: toVC)
    toVC.view.alpha = 0
    fromImageView.isHidden = true
    fromLargeTitle.isHidden = false
    if toVC.searchController.isActive {
      toLargeTitle.isHidden = true
    }
    toTitleLabel.isHidden = true
            
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
          toImageView.frame,
          from: toImageView.superview
        )
        titleSnapshot.frame = containerView.convert(
          toTitleLabel.frame,
          from: toTitleLabel.superview
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
        toLargeTitle.isHidden = false
        toTitleLabel.isHidden = false
      }
    )
  }
}
