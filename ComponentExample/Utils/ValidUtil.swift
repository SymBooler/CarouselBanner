//
//  ValidUtil.swift
//  MeetStar
//
//  Created by 张广路 on 2019/7/25.
//  Copyright © 2019 王超. All rights reserved.
//

import Foundation

class ValidUtil {
    public static func validate(mobile: String?) -> InputValidType {
        guard let str = mobile else {
            return .none
        }
        return str.validateMobile()
    }
    
    public static func validate(password: String?) -> InputValidType {
        guard let str = password else {
            return .none
        }
        return str.validatePassword()
    }
    @discardableResult
    public static func validate(passwords: String?...) -> Bool {
        for pwd in passwords {
            switch pwd?.validatePassword() {
            case .none, .none?:
                MBProgressHUD.showMessage("密码不能为空")
                return false
            case .format?, .length?:
                MBProgressHUD.showMessage("密码格式不对")
                return false
            default:
                break
            }
        }
        if passwords.count == 2, passwords.first != passwords[1] {
            MBProgressHUD.showMessage("两次密码输入不一致")
            return false
        }
        
        return true
    }
}
