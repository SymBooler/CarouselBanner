//
//  Double+Extension.swift
//  MeetStar
//
//  Created by 张广路 on 2019/9/26.
//  Copyright © 2019 王超. All rights reserved.
//

import Foundation

extension Double {
    
    func formatDate() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        return format.string(from: Date(timeIntervalSince1970: self/1000))
    }
    
    func formatShortDate() -> String {
        let format = DateFormatter()
        format.dateFormat = "MM-dd"
        
        return format.string(from: Date(timeIntervalSince1970: self/1000))
    }
}
