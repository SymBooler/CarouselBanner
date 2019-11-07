//
//  SearchField.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/6/11.
//  Copyright © 2019 Redstar. All rights reserved.
//

import UIKit

class SearchField: UITextField {
    
//    lazy var leftSeparator: CALayer = {
//        let layer = CALayer()
//        layer.backgroundColor = UIColor(hex: "#999999")?.cgColor
//        return layer
//    }()
    lazy var leftIcon: UIImageView = {
        return  UIImageView(image: UIImage(named: "searchLittle"))
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        leftView = createLeftView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftView = createLeftView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        
        leftView?.frame = CGRect(x: 0, y: 0, width: 40, height: bounds.size.height)
        leftIcon.center = leftView?.center ?? CGPoint.zero
        leftIcon.sizeToFit()
//        leftSeparator.frame = CGRect(x: 38, y: (bounds.size.height - leftIcon.frame.size.height) / 2.0, width: 0.5, height: leftIcon.frame.size.height)
        return CGRect(x: 0, y: 0, width: 40, height: bounds.size.height)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 40, y: 0, width: bounds.size.width - 40 - 20, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 40, y: 0, width: bounds.size.width - 40 - 20, height: bounds.size.height)
    }
}

extension SearchField {
    
    func createLeftView() -> UIView {
        let view = UIView(frame: CGRect.zero)
        view.addSubview(leftIcon)
//        view.layer.addSublayer(leftSeparator)
        leftViewMode = .always
        return view
    }
}
