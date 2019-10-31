//
//  BottomLineTextField.swift
//  MeetStar
//
//  Created by 张广路 on 2019/7/19.
//  Copyright © 2019 王超. All rights reserved.
//

import UIKit

class BottomLineTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(bottomLineLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(bottomLineLayer)
    }
    
    lazy var bottomLineLayer = CALayer()
    @IBInspectable var bottomLineNormalColor: UIColor? {
        didSet {
            if bottomLineColor == nil, !self.isFirstResponder {
                bottomLineColor = bottomLineNormalColor
            }
        }
    }
    @IBInspectable var bottomLineHighlightColor: UIColor?
    
    @IBInspectable var bottomLineColor: UIColor? {
        get {
            if let color = bottomLineLayer.backgroundColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            bottomLineLayer.backgroundColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var bottomLineHeight: CGFloat {
        get {
            return bottomLineLayer.bounds.height
        }
        set {
            bottomLineLayer.frame.size.height = newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLineLayer.frame.origin.y = bounds.size.height - bottomLineHeight
        bottomLineLayer.frame.size = CGSize(width: bounds.size.width, height: bottomLineHeight)
    }
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result, let hc = bottomLineHighlightColor {
            bottomLineColor = hc
        }
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result, let nc = bottomLineNormalColor {
            bottomLineColor = nc
        }
        return result
    }
    
    override func deleteBackward() {
        if let str = text, str.count == 0, let callback = delegate?.textField(_:shouldChangeCharactersIn:replacementString:) {
            
            _ = callback(self, NSRange(location: 0, length: 0), "")
        }
        super.deleteBackward()
    }
}
