//
//  PresentTransitionHandler.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/6/24.
//  Copyright © 2019 Redstar. All rights reserved.
//

import UIKit

@objc class PresentTransitionHandler: NSObject {

    @objc var duration: TimeInterval = 0.25
    let animator: PresentAnimatorProtocol
    var type: PresentType = .present
    
    init(duration: TimeInterval = 0.25, animator: PresentAnimatorProtocol) {
        self.duration = duration
        self.animator = animator
        super.init()
    }
    
    @objc convenience init(duration: TimeInterval, animator: AnyObject) {
        self.init(duration: duration, animator: animator as? PresentAnimatorProtocol ?? PresentScaleAnimator(duration: duration))
    }
}


extension PresentTransitionHandler: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        switch type {
        case .present:
            animator.present(transitionContext: transitionContext)
        default:
            animator.dismiss(transitionContext: transitionContext)
        }
    }
}

extension PresentTransitionHandler: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        perform(#selector(wakeupMainThread), afterDelay: 0.01)
        type = .present
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        perform(#selector(wakeupMainThread), afterDelay: 0.01)
        type = .dismiss
        return self
    }
    
    @objc func wakeupMainThread() {
        
        dispatch_sync_on_main_queue {
            debugPrint()
        }
    }
}
