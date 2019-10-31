//
//  SearchBarPlaceHolder.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/6/11.
//  Copyright © 2019 Redstar. All rights reserved.
//

import UIKit

class SearchBarPlaceHolder: UIView {
    
    typealias CallBack = () -> (Void)
    
    @objc var callback: CallBack?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var placeHolder: String? {
        didSet {
            titleLabel.text = placeHolder
        }
    }
    
    
    var view: UIView?
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        if let v = UINib(nibName: "SearchBarPlaceHolder", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            view = v
            v.frame = self.bounds
            self.addSubview(v)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let v = UINib(nibName: "SearchBarPlaceHolder", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            view = v
            v.frame = self.bounds
            self.addSubview(v)
        }
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 36))
    }
    
    @IBAction func searchBegin(_ sender: Any) {
        callback?()
    }
}
