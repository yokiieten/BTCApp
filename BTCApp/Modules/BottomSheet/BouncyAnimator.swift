
import UIKit

final class BouncyAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var cornerRadius: CGFloat = 10
    var presenting: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        let animatingView: UIView
        let finalFrame: CGRect
        let initialFrame: CGRect
        
        if presenting {
            guard let toView = toView else {
                transitionContext.completeTransition(false)
                return
            }
            
            animatingView = toView
            finalFrame = transitionContext.finalFrame(for: toViewController)
            initialFrame = finalFrame.offsetBy(dx: 0, dy: finalFrame.size.height)
            
            animatingView.roundCorners(corners: [.topLeft, .topRight], radius: cornerRadius)
        } else {
            guard let fromView = fromView else {
                transitionContext.completeTransition(false)
                return
            }
            
            animatingView = fromView
            initialFrame = transitionContext.initialFrame(for: fromViewController)
            finalFrame = initialFrame.offsetBy(dx: 0, dy: initialFrame.size.height)
        }
        
        animatingView.frame = initialFrame
        containerView.addSubview(animatingView)
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                animatingView.frame = finalFrame
            },
            completion: { (finished) in
                transitionContext.completeTransition(finished)
            })
    }
}
