//
//  RequestPageDataProtocol.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/6/14.
//  Copyright © 2019 Redstar. All rights reserved.
//

import Foundation

protocol RequestPageDataProtocolSwift {
    
    associatedtype Element
    func requestResult(result: DataModel.Result, list: [Element]?, message: String?, model: RequestedPageDataModel?)
}

@objc protocol RequestPageDataProtocol {
    @objc func requestResult(result: DataModel.Result, list: [Any]?, message: String?, model: RequestedPageDataModel?, clearData: Bool)
}

//MARK:- PagingListProtocol

typealias PagingListProtocol = RequestPagingListParseProtocol & RequestPageDataResultProtocol

protocol RequestPagingListParseProtocol {
    
    func transform(data: Any) -> [Any]
}

extension RequestPagingListParseProtocol {
    
    func transform(data: Any) -> [Any] {
        if let list = data as? [Any] {
            return list
        }
        guard let dic = data as? [String: Any] else {
            return []
        }
        if let list = dic["list"] as? [Any] {
            return list
        }
        if let list = dic["data"] as? [Any] {
            return list
        }
        return []
    }
}

protocol RequestPageDataResultProtocol {
    
    func result(response: PagingListResponse)
}
