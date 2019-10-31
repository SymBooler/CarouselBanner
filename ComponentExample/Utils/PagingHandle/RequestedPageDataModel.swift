//
//  RequestedPageDataModel.swift
//  MeetStar
//
//  Created by 张广路 on 2019/8/12.
//  Copyright © 2019 王超. All rights reserved.
//

import UIKit

class RequestedPageDataModel: NSObject {
    
    @objc var pageNum: Int = 0
    @objc var totalPage: Int = 1
    @objc var pageSize: Int = 20
    @objc var totalSize: Int = 1
    @objc var list: [Any]?
    
    var nextPage: Int {
        get {
            guard pageNum <= totalPage - 1 else {
                return totalPage
            }
            return pageNum + 1
        }
        
        set {
            guard newValue - 1 >= 0 else {
                pageNum = 0
                return
            }
            pageNum = newValue - 1
        }
    }
    
    var hasNextPage: Bool {
        guard pageNum <= totalPage - 1 else {
            return false
        }
        return true
    }
    
    func reset() {
        pageNum = 0
        totalPage = 1
        pageSize = 20
        totalSize = 1
    }
}

extension RequestedPageDataModel {
//    @objc static func modelContainerPropertyGenericClass() -> [String: AnyClass] {
//        return ["list": MSReleaseInfo.self]
//    }
    
    @objc static func modelCustomPropertyMapper() -> [String: String] {
        return ["pageNum": "pageNo", "list": "data"]
    }
}
