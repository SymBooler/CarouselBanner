//
//  PresentScaleAnimator.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/6/24.
//  Copyright © 2019 Redstar. All rights reserved.
//

import UIKit

@objc class PresentScaleAnimator: NSObject, PresentAnimatorProtocol {

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
        let toVCProtocol = toVC as? PresentControllerProtocol
        let bgView = toVCProtocol?.backgroundView
        let alpha = bgView?.alpha
        bgView?.alpha = 0
        var foreView = toVCProtocol?.foregroundView
        if toVCProtocol == nil {
            foreView = toView
        }
        foreView?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            bgView?.alpha = alpha ?? 0.4
            foreView?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (completion) in
            toView.becomeFirstResponder()
            transitionContext.completeTransition(completion)
        }
    }
    
    func dismiss(transitionContext: UIViewControllerContextTransitioning) {
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
}
