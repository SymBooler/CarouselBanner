//
//  Bottombar.swift
//  MeetStar
//
//  Created by 张广路 on 2019/7/15.
//  Copyright © 2019 王超. All rights reserved.
//

import UIKit
import Reusable

final class Bottombar: UIView, NibOwnerLoadable {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundHeight: NSLayoutConstraint!
    
    override var backgroundColor: UIColor? {
        didSet {
            backgroundView?.backgroundColor = backgroundColor
        }
    }
    
    var animateFrame: CGRect {
        var f = frame
        f.size.height += backgroundHeight.constant
        return f
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        sendSubviewToBack(containerView)
        setBackgroundHeight()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        sendSubviewToBack(containerView)
        setBackgroundHeight()
    }
    
    @available(iOS 11.0, *)
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        setBackgroundHeight()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBackgroundHeight()
    }
}

extension Bottombar {
    
    func setBackgroundHeight() {
        if #available(iOS 11.0, *) {
            backgroundHeight.constant = topMostController?.view.safeAreaInsets.bottom ?? 0
            layoutIfNeeded()
        }
    }
    
    func desc() -> UIEdgeInsets? {
        if #available(iOS 11.0, *) {
            return safeAreaInsets
        } else {
            // Fallback on earlier versions
        }
        return nil
    }
}
