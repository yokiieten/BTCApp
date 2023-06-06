
import UIKit

final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var isDisabledDismiss: Bool = false
    var dismissCompletedAction: (() -> Void)?

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {

        let controller = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
        controller.dismissCompletedAction = dismissCompletedAction
        controller.isDisabledDismiss = isDisabledDismiss

        return controller
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let animator = BouncyAnimator()
        animator.presenting = true
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let animator = BouncyAnimator()
        animator.presenting = false
        return animator
    }
}
