//
//  PresentAnimator.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/6/24.
//  Copyright © 2019 Redstar. All rights reserved.
//

import UIKit

protocol PresentAnimatorProtocol {
    
    var duration: TimeInterval { get }
    
    func present(transitionContext: UIViewControllerContextTransitioning)
    func dismiss(transitionContext: UIViewControllerContextTransitioning)
}
