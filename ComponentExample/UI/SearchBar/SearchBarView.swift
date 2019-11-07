////
////  SearchBarView.swift
////  MeetStar
////
////  Created by 张广路 on 2019/9/18.
////  Copyright © 2019 王超. All rights reserved.
////
//
//import UIKit
//import Reusable
//
//final class SearchBarView: UIView, NibOwnerLoadable {
//    var delegate: UITextFieldDelegate? {
//        didSet {
//            searchField.delegate = delegate
//        }
//    }
//    override var tintColor: UIColor! {
//        didSet {
//            searchField.tintColor = tintColor
//        }
//    }
//    var text: String? {
//        get {
//            return searchField.text
//        }
//        set {
//            searchField.text = newValue
//        }
//    }
//    var placeHolder: String? {
//        get {
//            return searchField.attributedPlaceholder?.string
//        }
//        set {
//            if let value = newValue {
//                searchField.attributedPlaceholder = NSAttributedString(string: value, attributes: [NSAttributedString.Key.foregroundColor: ColorConst.disable, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
//            }
//        }
//    }
//    
//    func beginEditing() {
//        searchField.becomeFirstResponder()
//    }
//    
//    var actionHandler: (()->Void)?
//    @IBOutlet weak var searchField: SearchField!
//    @IBOutlet weak var cancelButton: UIButton!
//    @IBOutlet weak var space: NSLayoutConstraint!
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.loadNibContent()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.loadNibContent()
//    }
//    
//    @IBAction func cancelButtonTapped(_ sender: Any) {
//        actionHandler?()
//    }
//    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let buttonRect = cancelButton.convert(cancelButton.bounds, to: self)
//        let expandRext = CGRect(x: buttonRect.origin.x - 10.0, y: buttonRect.origin.y - 10.0, width: buttonRect.size.width + 20, height: buttonRect.size.height + 20)
//        if expandRext.contains(point) {
//            return cancelButton
//        }
//        return super.hitTest(point, with: event)
//    }
//}
