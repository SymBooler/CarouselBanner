//
//  MJRefreshHeaderBridge.swift
//  MeetStar
//
//  Created by 张广路 on 2019/10/21.
//  Copyright © 2019 王超. All rights reserved.
//

import Foundation

class MJRefreshHeaderBridge: NSObject {
    static func createHeader(refreshingBlock: MJRefreshComponentRefreshingBlock!) -> MSRefreshHeader {
        return MSRefreshHeader(refreshingBlock: refreshingBlock)
    }
    
    static func createHeader(refreshingTarget: Any!, refreshingAction: Selector!) -> MSRefreshHeader {
        return MSRefreshHeader(refreshingTarget: refreshingTarget, refreshingAction: refreshingAction)
    }
}
