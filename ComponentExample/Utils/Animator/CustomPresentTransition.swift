//
//  CustomPresentTransition.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/5/17.
//  Copyright © 2019 Redstar. All rights reserved.
//
/*
import UIKit

class CustomPresentTransition: NSObject {
    
    @objc var duration: TimeInterval
    @objc var type: PresentType
    @objc var transition: Transition
    
    @objc override init() {
        self.type = .present
        self.transition = .coverVertical
        self.duration = 0.25
        super.init()
    }
        
    init(with type: PresentType = .present, transition: Transition = .shrink, duration: TimeInterval = 0.25) {
        self.type = type
        self.duration = duration
        self.transition = transition
        super.init()
    }
}

extension CustomPresentTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        debugPrint("AlertController:// animateTransition  \(Date().timeIntervalSince(AlertController.date as Date))")
        
        switch type {
        case .present:
            present(transitionContext: transitionContext)
        default:
            dismiss(transitionContext: transitionContext)
        }
    }
    
    func present(transitionContext: UIViewControllerContextTransitioning) {
        
        switch transition {
        case .shrink:
            shrink(transitionContext: transitionContext)
        case .coverVertical:
            coverVertical(transitionContext: transitionContext)
        default:
            break
        }
    }
    
    func dismiss(transitionContext: UIViewControllerContextTransitioning) {
        
        switch transition {
        case .crossDissolve:
        crossDissolve(transitionContext: transitionContext)
        case .dismissVertical:
            dismissVertical(transitionContext: transitionContext)
        default:
            break
        }
    }
}

extension CustomPresentTransition: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        perform(#selector(wakeupMainThread), with: nil, afterDelay: 0.01)
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        debugPrint("AlertController:// animationController forDismissed \(Date().timeIntervalSince(AlertController.date as Date))")
        perform(#selector(wakeupMainThread), with: nil, afterDelay: 0.01)
        return self
    }
    
    @objc func wakeupMainThread() {
        
        DispatchQueue.main.async {
            debugPrint()
        }
    }
}

extension CustomPresentTransition {
    
    func shrink(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: .to),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return;
        }
        toView.frame = transitionContext.finalFrame(for: toVC)
        toView.layoutIfNeeded()
        transitionContext.containerView.addSubview(toView)
        let toVCProtocol = toVC as! PresentControllerProtocol
        let bgView = toVCProtocol.backgroundView
        let alpha = bgView?.alpha
        bgView?.alpha = 0
        let foreView = toVCProtocol.foregroundView
        foreView?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            bgView?.alpha = alpha ?? 0.4
            foreView?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (completion) in
            toView.becomeFirstResponder()
            transitionContext.completeTransition(completion)
        }
    }
    
    func coverVertical(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: .to),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return;
        }
        toView.frame = transitionContext.finalFrame(for: toVC)
        toView.layoutIfNeeded()
        transitionContext.containerView.addSubview(toView)
        let toVCProtocol = toVC as! PresentControllerProtocol
        let bgView = toVCProtocol.backgroundView
        let alpha = bgView?.alpha
        bgView?.alpha = 0
        let foreView = toVCProtocol.foregroundView
        foreView?.transform = CGAffineTransform(translationX: 0, y: foreView?.frame.size.height ?? UIScreen.main.bounds.size.height / 2)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            bgView?.alpha = alpha ?? 0.4
            foreView?.transform = CGAffineTransform.identity
        }) { (completion) in
            transitionContext.completeTransition(completion)
        }
    }
    
    func crossDissolve(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let fromVC = transitionContext.viewController(forKey: .from) else {
                return;
        }
        let fromProtocol = fromVC as! PresentControllerProtocol
        let fgView = fromProtocol.foregroundView
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            fromView.alpha = 0
            fgView?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (completion) in
            transitionContext.completeTransition(completion)
        }
    }
    
    func dismissVertical(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
                return;
        }
        let fromProtocol = fromVC as! PresentControllerProtocol
        let fgView = fromProtocol.foregroundView
        let bgView = fromProtocol.backgroundView
        
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            bgView?.alpha = 0
            let transform = CGAffineTransform(translationX: 0, y: fgView?.frame.size.height ?? UIScreen.main.bounds.size.height / 2)
            fgView?.transform = transform
        }) { (completion) in
            transitionContext.completeTransition(completion)
        }
    }
}


@objc public enum PresentType: Int {
    case present = 1
    case dismiss
}

@objc public enum Transition: Int {
    case shrink = 1
    case crossDissolve
    case coverVertical
    case dismissVertical
}
*/
