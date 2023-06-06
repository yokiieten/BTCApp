
import UIKit

// swiftlint:disable all
final class BottomSheetPresentationController: UIPresentationController {
    private let dimmingView = UIView()
    private let panGesture = UIPanGestureRecognizer()
    private let tapGesture = UITapGestureRecognizer()
    
    private var handleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private enum Constants {
        static let dismissThreshold: CGFloat = 100
        static let minimum: CGFloat = 20
    }
    
    var dismissCompletedAction: (() -> Void)?
    
    var isDisabledDismiss: Bool = false {
        didSet {
            disabledDismiss()
        }
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        panGesture.addTarget(self, action: #selector(handlePan(_:)))
        tapGesture.addTarget(self, action: #selector(didTap(_:)))
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = containerView else {
            return
        }
        
        presentedView?.addGestureRecognizer(panGesture)
        
        dimmingView.alpha = 0
        dimmingView.addGestureRecognizer(tapGesture)
        
        containerView.addSubview(dimmingView)
        containerView.addConstraints([
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        
        if let presentedView = presentedView {
            presentedView.addSubview(handleView)
            NSLayoutConstraint.activate([
                handleView.centerXAnchor.constraint(equalTo: presentedView.centerXAnchor),
                handleView.topAnchor.constraint(equalTo: presentedView.topAnchor, constant: 8),
                handleView.heightAnchor.constraint(equalToConstant: 5),
                handleView.widthAnchor.constraint(equalToConstant: 48)
            ])
        }
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: {  [weak self] _ in
            guard let self = self else {
                return
            }
            self.dimmingView.alpha = 1
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (_) in
            guard let self = self else {
                return
            }
            
            self.dimmingView.alpha = 0
        }, completion: { [weak self] (_) in
            guard let self = self else {
                return
            }
            
            self.dimmingView.removeFromSuperview()
        })
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        let rect = self.frameOfPresentedViewInContainerView
        
        if rect == .zero {
            return
        }
        
        UIView.animate(withDuration: 0.3,
                       animations: { () -> Void in
            self.presentedViewController.view.frame = rect
        })
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return .zero
        }
        
        let threshold: CGFloat
        if #available(iOS 11.0, *) {
            let safeAreaTop = containerView.safeAreaInsets.top
            threshold = containerView.frame.height - Constants.minimum - safeAreaTop
        } else {
            threshold = containerView.frame.height - Constants.minimum
        }
        
        if presentedViewController.preferredContentSize != .zero {
            var size = presentedViewController.preferredContentSize
            
            if size.height > threshold {
                size.height = threshold
            }
            
            let offset = (containerView.frame.size.height - size.height) / 2
            
            var rect = containerView.bounds.insetBy(dx: 0, dy: offset)
            rect = rect.offsetBy(dx: 0, dy: offset)
            
            return rect
            
        } else {
            let width = containerView.frame.size.width
            
            var fittingSize = UIView.layoutFittingCompressedSize
            fittingSize.width = width
            
            var size = presentedViewController.view.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
            
            if size.height > threshold {
                size.height = threshold
            }
            
            let offset = (containerView.frame.size.height - size.height) / 2
            
            var rect = containerView.bounds.insetBy(dx: 0, dy: offset)
            rect = rect.offsetBy(dx: 0, dy: offset)
            
            return rect
        }
    }
    
    @objc private func didTap(_ gesture: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: dismissCompletedAction)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else {
            return
        }
        
        let yTranslation = gesture.translation(in: view).y
        
        switch gesture.state {
            
        case .changed:
            if yTranslation < 0 {
                view.transform = CGAffineTransform.identity
            } else {
                view.transform = CGAffineTransform(translationX: 0, y: yTranslation)
            }
            
        case .ended:
            if yTranslation > Constants.dismissThreshold {
                presentedViewController.dismiss(animated: true, completion: dismissCompletedAction)
            } else {
                UIView.animate(withDuration: 0.3) {
                    view.transform = CGAffineTransform.identity
                }
            }
            
        default:
            break
        }
    }
    
    private func disabledDismiss() {
        guard isDisabledDismiss else { return }
        
        handleView.alpha = 0
        panGesture.removeTarget(self, action: #selector(handlePan(_:)))
        tapGesture.removeTarget(self, action: #selector(didTap(_:)))
    }
}
// swiftlint:enable all
