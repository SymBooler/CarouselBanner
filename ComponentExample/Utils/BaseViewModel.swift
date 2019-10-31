//
//  BaseViewModel.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/5/5.
//  Copyright © 2019 Redstar. All rights reserved.
//

import UIKit

class BaseViewModel<T: UIViewController, M>: NSObject {
    
    weak var viewModelController: T?
    var dataModel: M?
    init(_ contoller: T?, dataModel: M? = nil){
        super.init()
        self.viewModelController = contoller
        self.dataModel = dataModel
        initContent()
    }
    
    func initContent() {
        //extend this, if you want do some after init
    }
}

@objc public class DataModel: NSObject {
    
    @objc public enum Result: Int{
        public typealias RawValue = Int
        
        case failure = -1
        case success = 1
        case error
    }
    
    public struct Null {
        var description: String {
            return "Null"
        }
    }
}



