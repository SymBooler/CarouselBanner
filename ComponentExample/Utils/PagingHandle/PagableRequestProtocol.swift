//
//  PagableRequestProtocol.swift
//  MeetStar
//
//  Created by 张广路 on 2019/9/27.
//  Copyright © 2019 王超. All rights reserved.
//

import Foundation

protocol PagableRequestProtocol {
    var hasNext: Bool { get }
    var index: Int { get }
    var size: Int { get }
    mutating func first()
    mutating func next()
    
    init()
    init?(fromDictionary dictionary: [String: Any])
    func toDictionary() -> [String:Any]
}
