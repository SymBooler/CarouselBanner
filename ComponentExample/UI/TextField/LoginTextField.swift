//
//  LoginTextField.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/5/7.
//  Copyright © 2019 Redstar. All rights reserved.
//

import UIKit

typealias RightViewAction = (_ textField: LoginTextField, _ view: UIView?) -> Void
private let sesureViewTag: Int = 100

class LoginTextField: UITextField {

    var rightViewTaped: RightViewAction?
    
    var lineLayer: CALayer?
    var fieldType: FieldType?
    
    var lineBorderColor: UIColor? {
        get {
            return UIColor(cgColor: lineLayer?.backgroundColor ?? UIColor.clear.cgColor)
        }
        set {
            lineLayer?.backgroundColor = newValue?.cgColor
        }
    }
    var showBottomLine: Bool {
        get {
            return lineLayer != nil
        }
        set {
            guard newValue else {
                return
            }
            if let _ = lineLayer {
                return
            }
            lineLayer = CALayer()
            guard let borderLayer = lineLayer else {
                return
            }
            borderLayer.frame = CGRect(x: 0.0, y: frame.size.height - 0.5, width: frame.size.width, height: 0.5)
            borderLayer.backgroundColor = ColorConst.separator.cgColor
            layer.addSublayer(borderLayer)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineLayer?.frame = CGRect(x: 0.0, y: frame.size.height - 0.5, width: frame.size.width, height: 0.5)
    }
    
    func config(type fieldType: FieldType, leftImage: UIImage? = nil, rightImage: UIImage? = nil, leftRect: CGRect? = nil, rightRect: CGRect? = nil, leftEdge: UIEdgeInsets? = nil, rightEdge: UIEdgeInsets? = nil) {
        
        self.fieldType = fieldType
        leftView = createView(image: leftImage, r: leftRect, e: leftEdge, isLeft: true)
        leftViewMode = .always
        rightViewMode = .always
        switch fieldType {
        case .password:
            rightView = createView(image: rightImage, r: rightRect, e: rightEdge, isLeft: false)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(rightViewTaped(gesture:)))
            rightView?.addGestureRecognizer(gesture)
            rightView?.isUserInteractionEnabled = true
            
        default: break
            
        }
    }
    
    @objc func rightViewTaped(gesture: UITapGestureRecognizer) {
        if let action = rightViewTaped {
            action(self, gesture.view)
        }
    }
    
    func createView(image: UIImage?, r: CGRect?, e: UIEdgeInsets?, isLeft: Bool) -> UIView {
        
        let imageSize = image?.size
        let imageView = UIImageView(image: image)
        let rect = r ?? CGRect(origin: CGPoint.zero, size: imageSize ?? CGSize.zero)
        let edge = e ?? UIEdgeInsets.zero
        var f = rect
        f.origin.x = edge.left
        f.origin.y = edge.top
        imageView.frame = f
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: rect.size(by: edge)))
        imageView.tag = sesureViewTag
        view.addSubview(imageView)
        if isLeft {
            leftViewRect(forBounds: CGRect(origin: CGPoint.zero, size: rect.size(by: edge)))
        } else {
            rightViewRect(forBounds: rect.edge(by: edge))
        }
        
        return view
    }
    
    func resetSecureImage(image: UIImage?) {
        if let imageView = rightView?.viewWithTag(sesureViewTag) as? UIImageView {
            imageView.image = image
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result {
            lineLayer?.backgroundColor = ColorConst.theme.cgColor
        }
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result {
            lineLayer?.backgroundColor = ColorConst.separator.cgColor
        }
        return result
    }
}

extension CGRect {
    func edge(by edge: UIEdgeInsets) -> CGRect {
        return CGRect(x: self.origin.x + edge.left,
                      y: self.origin.y + edge.top,
                      width: self.size.width + edge.left + edge.right,
                      height: self.size.height + edge.top + edge.bottom)
    }
    func size(by edge: UIEdgeInsets) -> CGSize {
        return CGSize(width: self.size.width + edge.left + edge.right,
                      height: self.size.height + edge.top + edge.bottom)
    }
    func applySize(by edge: UIEdgeInsets) -> CGRect {
        return CGRect(x: self.origin.x,
                      y: self.origin.y,
                      width: self.size.width + edge.left + edge.right,
                      height: self.size.height + edge.top + edge.bottom)
    }
}

public enum FieldType {
    case name
    case password
}

