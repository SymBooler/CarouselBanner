//
//  StaticInfo.swift
//  MeetStar
//
//  Created by 张广路 on 2019/9/27.
//  Copyright © 2019 王超. All rights reserved.
//
/*
import UIKit

class StaticInfo: NSObject {
    
    private var _userToken: String?
    private var _userInfo: [String: Any]?
    var userInfoModel: UserInfoModel?
    
    var userToken: String? {
        return _userToken
    }
    
//    var userInfo: [String: Any]? {
//        return _userInfo
//    }

    public static var shared: StaticInfo = {
        let instance = StaticInfo()
        NotificationCenter.default.addObserver(instance, selector: #selector(resetSession), name: Notification.Name(NotificationConst.UserSessionReset), object: nil)
        return instance
    }()
    
    private override init() {
        super.init()
        restore()
    }
    
    func storeUserInfoModel() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(userInfoModel), let str = String(data: data, encoding: .utf8) {
            UserDefaults.standard.set(str, forKey: SessionConst.UserInfoKey)
        }
    }
    
    func restore() {
        _userToken = UserDefaults.standard.string(forKey: SessionConst.UserTokenKey)
        let userInfoStr = UserDefaults.standard.string(forKey: SessionConst.UserInfoKey)
        if let userInfoData = userInfoStr?.data(using: .utf8) {
            let decoder = JSONDecoder()
            if let userInfoModel = try? decoder.decode(UserInfoModel.self, from: userInfoData) {
                self.userInfoModel = userInfoModel
            }
        }
        _userInfo = userInfoStr?.jsonValueDecoded() as? Dictionary<String, Any>
    }
    
    @objc func resetSession() {
        restore()
    }
}

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
*/
