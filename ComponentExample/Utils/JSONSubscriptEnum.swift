//
//  JSONSubscriptEnum.swift
//  MeetStar
//
//  Created by 张广路 on 2019/10/31.
//  Copyright © 2019 王超. All rights reserved.
//

import Foundation
import SwiftyJSON

enum JSONSubscriptEnum: String {
    case name = "name"
    case pumsEmployeeId = "pumsEmployeeId"
    case visitorMobile = "visitorMobile"
    case list = "list"
    case employeeCnt = "employeeCnt"
    case data = "data"
    case pageNo = "pageNo"
    case totalPage = "totalPage"
    case releaseTitle = "releaseTitle"
    case coverImage = "coverImage"
    case releaseTime = "releaseTime"
    case content = "content"
    case departmentName = "departmentName"
    case positionName = "positionName"
    case imageUrl = "imageUrl"
    case bu = "bu"
    case mobile = "mobile"
}

extension JSON {
    subscript(sub: JSONSubscriptEnum) -> JSON {
        get {
            return self[sub.rawValue]
        }
        set {
            self[sub.rawValue] = newValue
        }
    }
    subscript(path: [JSONSubscriptEnum]) -> JSON {
        get {
            let rawPath = path.map { $0.rawValue }
            return self[rawPath]
        }
        set {
            let rawPath = path.map { $0.rawValue }
            self[rawPath] = newValue
        }
    }
    subscript(path: JSONSubscriptEnum...) -> JSON {
        get {
            return self[path]
        }
        set {
            self[path] = newValue
        }
    }
}
