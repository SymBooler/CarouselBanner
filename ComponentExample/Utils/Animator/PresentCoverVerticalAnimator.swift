//
//  PresentCoverVerticalAnimator.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/6/24.
//  Copyright © 2019 Redstar. All rights reserved.
//
/*
import UIKit

@objc class PresentCoverVerticalAnimator: NSObject, PresentAnimatorProtocol {

    @objc var duration: TimeInterval = 0.25
    
    convenience init(_ duration: TimeInterval = 0.25) {
        self.init(duration: duration)
    }
    
    @objc init(duration: TimeInterval) {
        self.duration = duration
        super.init()
    }
    
    func present(transitionContext: UIViewControllerContextTransitioning) {
        
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
    
    func dismiss(transitionContext: UIViewControllerContextTransitioning) {
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
*/
