//
//  ConstUrl.swift
//  MeetStar
//
//  Created by 张广路 on 2019/7/24.
//  Copyright © 2019 王超. All rights reserved.
//

import Foundation

class ConstUrl: NSObject {
    
}

extension ConstUrl {
    
    @objc public static var baseUrl: String {
        get {
            #if DEV
            return "http://pums.dev.rs.com/"
            #elseif UAT
            return "http://pums.uat1.rs.com/"
            #elseif PRD
            return "https://pums.mklsoft.com/"
            #elseif STAGE
            return "http://pums.uat1.rs.com/"
            #endif
        }
    }
}

//MARK:- User(Login、Logout、Home)
extension ConstUrl {
    
    @objc public static let action_loginUnencrypt = "pums/api/auth/login"
    @objc public static let action_login = "pums/api/auth/loginEncrypt"
    @objc public static let action_logout = "pums/api/auth/logout"
    @objc public static let action_sendMessage = "pums/api/auth/sendMsg"
    @objc public static let action_sendCode = "pums/api/auth/sendCode"
    @objc public static let action_resetPassword = "pums/api/ldap/modifyPwd"
    @objc public static let action_changePassword = "pums/api/auth/changePassword"
    @objc public static let action_loginCode = "pums/api/auth/loginCode"
    
    @objc public static func url(action: String) -> String {
        return baseUrl + action
    }
    
    @objc public static var login: String {
        get {
            return self.url(action: action_login)
        }
    }
    
    @objc public static var logout: String {
        get {
            return self.url(action: action_logout)
        }
    }
    
    @objc public static var sendMessage: String {
        get {
            return self.url(action: action_sendMessage)
        }
    }
    
    @objc public static var resetPassword: String {
        get {
            return self.url(action: action_resetPassword)
        }
    }
    
    @objc public static var changePassword: String {
        get {
            return self.url(action: action_changePassword)
        }
    }
    
    @objc public static var sendCode: String {
        get {
            return self.url(action: action_sendCode)
        }
    }
    
    @objc public static var loginCode: String {
        get {
            return self.url(action: action_loginCode)
        }
    }
}

//MARK:- 首页
extension ConstUrl {
    
    @objc public static let action_appFirstPageInfo = "app-pums/api/subapplicationPlatformApp/getAppFirstPageInfoList"
    @objc public static let action_subAppList = "app-pums/api/subapplicationPlatformApp/subAppPageList"
    @objc public static let action_releaseList = "app-pums/api/releaseInfoApp/releaseList"
    @objc public static let action_getCollectStatusById = "app-pums/api/releaseInfoApp/getCollectStatusById"
    
    @objc public static var appFirstPageInfo: String {
        get {
            return self.url(action: action_appFirstPageInfo)
        }
    }
    
    @objc public static var subAppList: String {
        get {
            return self.url(action: action_subAppList)
        }
    }
    
    @objc public static var releaseList: String {
        get {
            return self.url(action: action_releaseList)
        }
    }
    
    @objc public static var getCollectStatusById: String {
        get {
            return self.url(action: action_getCollectStatusById)
        }
    }
}
//MARK:- user center & sub page
extension ConstUrl {
    
    @objc public static let action_userInfo = "app-pums/api/userCentreApp/getUserInfo"
    @objc public static let action_avatarUpload = "app-pums/api/userCentreApp/upload"
    @objc public static let action_collectList = "app-pums/api/releaseInfoApp/collectList"
    @objc public static let action_cancelCollect = "app-pums/api/releaseInfoApp/cancelCollect"
    @objc public static let action_messageManagerAppList = "app-pums/api/messageManager/getMessageManagerAppList"
    @objc public static let action_faqs = "app/help/#/"
    
    
    @objc public static let action_startCollect = "app-pums/api/releaseInfoApp/startCollect"
    @objc public static let action_messageDetail = "app-pums/api/messageManager/getMessageManagerDetail"
    @objc public static let action_releaseDetail = "app-pums/api/releaseInfoApp/getDetailById"
    @objc public static let action_mobileShowStatus = "app-pums/api/notebook/getMobileShowStatus"
    @objc public static let action_changeMobileShowStatus = "app-pums/api/notebook/changeMobileShowStatus"
    
    @objc public static var userInfo: String {
        get {
            return self.url(action: action_userInfo)
        }
    }
    
    @objc public static var avatarUpload: String {
        get {
            return self.url(action: action_avatarUpload)
        }
    }
    
    @objc public static var collectList: String {
        get {
            return self.url(action: action_collectList)
        }
    }
    
    @objc public static var cancelCollect: String {
        get {
            return self.url(action: action_cancelCollect)
        }
    }
    
    @objc public static var startCollect: String {
        get {
            return self.url(action: action_startCollect)
        }
    }
    
    @objc public static var messageManagerAppList: String {
        get {
            return self.url(action: action_messageManagerAppList)
        }
    }
    
    @objc public static var faqs: String {
        get {
            return self.url(action: action_faqs)
        }
    }
    
    @objc public static var messageDetail: String {
        get {
            return self.url(action: action_messageDetail)
        }
    }
    
    @objc public static var releaseDetail: String {
        get {
            return self.url(action: action_releaseDetail)
        }
    }
    @objc public static var mobileShowStatus: String {
        get {
            return self.url(action: action_mobileShowStatus)
        }
    }
    @objc public static var changeMobileShowStatus: String {
        get {
            return self.url(action: action_changeMobileShowStatus)
        }
    }
}
//MARK:- app version
extension ConstUrl {
    @objc fileprivate static let action_appVersion = "app-pums/api/versionManager/getVersionManagerByType"
    @objc public static var appVersion: String {
        get {
            return self.url(action: action_appVersion)
        }
    }
}
//MARK: contact
extension ConstUrl {
    @objc fileprivate static let action_departmentList = "app-pums/api/notebook/itemList"
    @objc public static var departmentList: String {
        get {
            return self.url(action: action_departmentList)
        }
    }
    @objc fileprivate static let action_employeeList = "app-pums/api/notebook/employeeList"
    @objc public static var employeeList: String {
        get {
            return self.url(action: action_employeeList)
        }
    }
    @objc fileprivate static let action_employeeDetail = "app-pums/api/notebook/employeeDetail"
    @objc public static var employeeDetail: String {
        get {
            return self.url(action: action_employeeDetail)
        }
    }
    @objc fileprivate static let action_searchEmployeeDetail = "app-pums/api/notebook/searchEmployeeDetail"
    @objc public static var searchEmployeeDetail: String {
        get {
            return self.url(action: action_searchEmployeeDetail)
        }
    }
    @objc fileprivate static let action_smsList = "app-pums/api/notebook/smsList"
    @objc public static var smsList: String {
        get {
            return self.url(action: action_smsList)
        }
    }
    @objc fileprivate static let action_sendSms = "app-pums/api/notebook/sendSms"
    @objc public static var sendSms: String {
        get {
            return self.url(action: action_sendSms)
        }
    }
    @objc fileprivate static let action_contactList = "app-pums/api/notebook/contactList"
    @objc public static var contactList: String {
        get {
            return self.url(action: action_contactList)
        }
    }
    @objc fileprivate static let action_contactSearch = "app-pums/api/notebook/search"
    @objc public static var contactSearch: String {
        get {
            return self.url(action: action_contactSearch)
        }
    }
    @objc fileprivate static let action_addressSearch = "app-pums/api/employeeAddress/getAddressList"
    @objc public static var addressSearch: String {
        get {
            return self.url(action: action_addressSearch)
        }
    }
    @objc fileprivate static let action_employeeAddressById = "app-pums/api/employeeAddress/getEmployeeAddress"
    @objc public static var employeeAddressById: String {
        get {
            return self.url(action: action_employeeAddressById)
        }
    }
    @objc fileprivate static let action_defendEmployeeAddressById = "app-pums/api/employeeAddress/getDefendEmployeeAddress"
    @objc public static var defendEmployeeAddressById: String {
        get {
            return self.url(action: action_defendEmployeeAddressById)
        }
    }
    @objc fileprivate static let action_meetingRoomAddressById = "app-pums/api/employeeAddress/getMeetingRoomAddress"
    @objc public static var meetingRoomAddressById: String {
        get {
            return self.url(action: action_meetingRoomAddressById)
        }
    }
    @objc fileprivate static let action_insterAndSaveEmployeeAddress = "app-pums/api/employeeAddress/insterAndSaveEmployeeAddress"
    @objc public static var insterAndSaveEmployeeAddress: String {
        get {
            return self.url(action: action_insterAndSaveEmployeeAddress)
        }
    }
    @objc fileprivate static let action_queryAreaInfoList = "app-pums/api/employeeAddress/queryAreaInfoList"
    @objc public static var queryAreaInfoList: String {
        get {
            return self.url(action: action_queryAreaInfoList)
        }
    }
}

//MARK: guest account
extension ConstUrl {
    
    @objc fileprivate static let action_guestHistoryList = "app-pums/api/visitorNetwork/getHistoryList"
    @objc public static var guestHistoryList: String {
        get {
            return self.url(action: action_guestHistoryList)
        }
    }
    @objc fileprivate static let action_guestAccount = "app-pums/api/visitorNetwork/getAccount"
    @objc public static var guestAccount: String {
        get {
            return self.url(action: action_guestAccount)
        }
    }
}
