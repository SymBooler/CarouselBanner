//
//  ConstUtil.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/4/26.
//  Copyright © 2019 Redstar. All rights reserved.
//

import Foundation

extension LoginViewModel {
    @objc public static let userName = "userName"
    @objc public static let password = "password"
}

class NotificationConst: NSObject {
    @objc public static let BackFromAssignUserController = "BackFromAssignUserController"
    @objc public static let PatrolTaskTransferCompletion = "PatrolTaskTransferCompletion"
    @objc public static let Refresh = "BackToHomeAndNeedRefresh"
    @objc public static let UserSessionInvalidate = "UserSessionInvalidate"
    @objc public static let UserSessionReset = "UserSessionReset"
    @objc public static let UserAvatorChanged = "UserAvatorChanged"
}

class SessionConst: NSObject {
    @objc public static let UserInfoKey = "UserInfo"
    @objc public static let UserTokenKey = "UserToken"
    @objc public static let UserIDKey = "pumsEmployeeId"
    @objc public static let UserCodeKey = "employeeCode"
    @objc public static let HTTP_TokenKey = "HTTP_Token"
    @objc public static let HTTPHeaderForTokenKey = "pums-token"
}

class ColorConst: NSObject {
    @objc public static var theme: UIColor {
        return UIColor(hexString: "#1D85FE") ?? UIColor(red: 70/255.0, green: 86/255.0, blue: 251/255.0, alpha: 1.0)
    }
    @objc public static var normal: UIColor {
        return UIColor(hexString: "#C7C7C7") ?? UIColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1.0)
    }
    @objc public static var disable: UIColor {
        return UIColor(hexString: "#999999") ?? UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
    }
    @objc public static var background: UIColor {
        return UIColor(hexString: "#F5F5F5") ?? UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
    }
    @objc public static var textNormal: UIColor {
        return UIColor(hexString: "#444444") ?? UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1.0)
    }
    @objc public static var textNormalLight: UIColor {
        return UIColor(hexString: "#666666") ?? UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)
    }
    @objc public static var separator: UIColor {
        return UIColor(hexString: "#e4e4e4") ?? UIColor(red: 228/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1.0)
    }
}

class UserDefaultKey: NSObject {
    @objc public static let AppInstallHelpUrl = "AppInstallHelpUrl"
    @objc public static let ContactSearchHistory = "ContactSearchHistory"
    @objc public static let NewsSearchHistory = "NewsSearchHistory"
    @objc public static let FAQStoreKey = "FAQStoreKey"
    @objc public static let HomeData = "HomeData"
    @objc public static let NewsData = "NewsData"
}

class EncryptUtil {
    //MARK: AES KEY & VECTOR
    #if PRD
    @objc public static let cryptoPwd = "`1@A<,?:]+^6%4#*"
    @objc public static let cryptoVector = "1qazxcde32ws*&^%"
    #else
    @objc public static let cryptoPwd = "123456789qazwsxe"
    @objc public static let cryptoVector = "123456789qazwsxe"
    #endif
}
