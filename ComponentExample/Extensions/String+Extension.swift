//
//  StringCategory.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/6/3.
//  Copyright © 2019 Redstar. All rights reserved.
//

import Foundation
import CryptoSwift

extension String {
    
    func isValidMobilePhoneNum() -> Bool {
        
        guard self.isValidString(), self.count == 11 else {
            return false
        }
        //移动号段正则表达式
        let CM_NUM = "^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        //联通号段正则表达式
        let CU_NUM = "^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        //电信号段正则表达式
        let CT_NUM = "^((133)|(153)|(173)|(177)|(170)||(171)|(18[0,1,9]))\\d{8}$";
        
        let pred1 = NSPredicate(format: "SELF MATCHES %@", CM_NUM)
        let isMatch1 = pred1.evaluate(with: self)
        let pred2 = NSPredicate(format: "SELF MATCHES %@", CU_NUM)
        let isMatch2 = pred2.evaluate(with: self)
        let pred3 = NSPredicate(format: "SELF MATCHES %@", CT_NUM)
        let isMatch3 = pred3.evaluate(with: self)
        
        guard isMatch1 || isMatch2 || isMatch3 else {
            return false
        }
        return true
    }
    
    func isValidString() -> Bool {
        guard self.count > 0, self != "null", self != "(null)", self != "<null>" else {
            return false
        }
        return true
    }
    
    func validateMobile() -> InputValidType {
        
        if count == 0 {
            return .none
        }
//        guard count == 11 else {
//            return .length
//        }
        let regex = "^1\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = predicate.evaluate(with: self)
        if !result {
            return .format
        }
        
        return .correct
    }
    
    func validatePassword() -> InputValidType {
        
        if count == 0 {
            return .none
        }
        //        guard count == 11 else {
        //            return .length
        //        }
        let regex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[a-zA-Z0-9]{8,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = predicate.evaluate(with: self)
        if !result {
            return .format
        }
        
        return .correct
    }
    
    func formatDate() -> String {
        guard let interval = TimeInterval(self) else {
            return self
        }
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        return format.string(from: Date(timeIntervalSince1970: interval/1000))
    }
}

enum InputValidType {
    case none
    case length
    case format
    case correct
}

extension String {
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
    
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
}

extension String {
    //CBC/pkcs5/  throws -> String?
    public func aesEncrypt() -> String?  {
        
        do {
            let aes = try AES(key: EncryptUtil.cryptoPwd, iv: EncryptUtil.cryptoVector, padding: .pkcs5)
            return try encryptToBase64(cipher: aes)
        } catch {
            return nil
        }
//        if let aes = try? AES(key: EncryptUtil.cryptoPwd, iv: EncryptUtil.cryptoVector, padding: .pkcs5) {
//            return try? encryptToBase64(cipher: aes)
//        }
//        return nil
    }
}

extension String {
    func ranges(of string: String, options: CompareOptions = .caseInsensitive) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
}
