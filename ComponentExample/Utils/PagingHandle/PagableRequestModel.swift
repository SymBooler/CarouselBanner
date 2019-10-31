//
//  PagableRequestModel.swift
//  MeetStar
//
//  Created by 张广路 on 2019/9/27.
//  Copyright © 2019 王超. All rights reserved.
//

import Foundation

struct PagableRequestModel: PagableRequestProtocol, Codable {
    
    var hasNext: Bool {  return index < total }
    var index: Int
    var size: Int
    var total: Int
    mutating func first() {
        index = 1
        size = 20
        total = 1
    }
    
    mutating func next() {
        index = min(index + 1, total)
    }
    
    enum CodingKeys: String, CodingKey {
        case index = "pageNo"
        case size = "pageSize"
        case total = "totalPage"
    }
    
    init() {
        index = 1
        size = 20
        total = 1
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        index = try value.decode(Int.self, forKey: .index)
        size = try value.decode(Int.self, forKey: .size)
        total = try value.decode(Int.self, forKey: .total)
    }
    
    func encode(to encoder: Encoder) throws {
        var value = encoder.container(keyedBy: CodingKeys.self)
        try value.encode(index, forKey: .index)
        try value.encode(size, forKey: .size)
        try value.encode(total, forKey: .total)
    }
    
    init?(fromDictionary dictionary: [String:Any]){
        
        guard let index = dictionary["pageNo"] as? Int, let size = dictionary["pageSize"] as? Int, let total = dictionary["totalPage"] as? Int else {
            return nil
        }
        self.index = index
        self.size = size
        self.total = total
    }
    
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        dictionary["pageNo"] = index
        dictionary["pageSize"] = size
        dictionary["totalPage"] = total
        return dictionary
    }
}
