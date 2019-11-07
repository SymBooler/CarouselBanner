//
//  NetworkUtil.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/4/25.
//  Copyright © 2019 Redstar. All rights reserved.
//

import Foundation
import AFNetworking

//MARK:- API
public struct API {
    var url: String
    var method = HTTPMethod.get
    var params: [String: Any]?
    var body: [String: Any]?
    var timeoutInterval: TimeInterval = 20
    var fileInfo: [String: Any]?
    var header = [String: String]()
    var httpBody: Data? {
        guard let b = body else {
            return nil
        }
        let json = try? JSONSerialization.data(withJSONObject: b)
        return json
    }
    
    init(url: String, method: HTTPMethod, header: [String: String] = [:], params: [String: Any]? = nil, body: [String: Any]? = nil, fileInfo: [String: Any]? = nil, timeoutInterval: TimeInterval = 20) {
        self.url = url
        self.method = method
        self.params = params
        self.body = body
        self.fileInfo = fileInfo
        initHttpHeaders()
        addHeader(params: header)
        self.timeoutInterval = timeoutInterval
    }
    
    mutating func addHeader(params: [String: String]) {
        header.merge(params) { current,_ in current }
    }
    
    private mutating func initHttpHeaders() {
        header = ["Content-Type": "application/json", "app-pums-source": "ios"]
//        if let version = UIApplication.shared.appVersion {
//            header["app-pums-version"] = version
//        }
//        if let token = StaticInfo.shared.userToken {
//            header[SessionConst.HTTPHeaderForTokenKey] = token
//        }
    }
}
//MARK:- NetworkUtil
open class NetworkUtil: NSObject {
    
    public class func upload(url: String, parameters: Any? = nil, body: [String:Any]? = nil, httpHeaderField headers: [String:String]? = nil, fileInfo: [String: Any], timeoutInterval: TimeInterval = 15, completionHandler: @escaping (Result<NetworkResultModel,NetworkError>) -> Void) {
        
        let manager = AFHTTPSessionManager()
        let rs = AFHTTPRequestSerializer()
        rs.timeoutInterval = 15
        rs.setValue("application/json", forHTTPHeaderField: "Content-Type")
        rs.setValue("ios", forHTTPHeaderField: "app-pums-source")
        if let userToken = UserDefaults.standard.string(forKey: SessionConst.UserTokenKey) {
            rs.setValue(userToken, forHTTPHeaderField: SessionConst.HTTPHeaderForTokenKey)
        }
        
//        if let version = UIApplication.shared.appVersion {
//            rs.setValue(version, forHTTPHeaderField: "app-pums-version")
//        }
        
        if let h = headers {
            for (header, value) in h {
                rs.setValue(value, forHTTPHeaderField: header)
            }
        }
        manager.requestSerializer = rs
        let r = manager.requestSerializer.multipartFormRequest(withMethod: HTTPMethod.post.rawValue, urlString: url, parameters: parameters as? [String : Any], constructingBodyWith: { (formData) in
            
            formData.appendPart(withFileData: fileInfo["data"] as! Data, name: fileInfo["name"] as? String ?? "avatar", fileName: fileInfo["fileName"] as? String ?? "avatar", mimeType: fileInfo["mimeType"] as? String ?? "jpeg")
        }, error: nil)
        
        do {
            if let b = body {
                let json = try JSONSerialization.data(withJSONObject: b)
                r.httpBody = json
            }
            self.request(manager: manager, request: r as URLRequest, completionHandler: completionHandler)
            
        } catch {
            print(error)
        }
    }
    
    public class func request(url: String, method: HTTPMethod = .get, parameters: Any? = nil, body: [String:Any]? = nil, httpHeaderField headers: [String:String]? = nil, fileInfo: [String: Any]? = nil, timeoutInterval: TimeInterval = 15, completionHandler: @escaping (Result<NetworkResultModel,NetworkError>) -> Void) {

        let manager = AFHTTPSessionManager()
        let rs = AFHTTPRequestSerializer()
        rs.timeoutInterval = timeoutInterval
        rs.setValue("application/json", forHTTPHeaderField: "Content-Type")
        rs.setValue("ios", forHTTPHeaderField: "app-pums-source")
        if let userToken = UserDefaults.standard.string(forKey: SessionConst.UserTokenKey) {
            rs.setValue(userToken, forHTTPHeaderField: SessionConst.HTTPHeaderForTokenKey)
        }
        
//        if let version = UIApplication.shared.appVersion {
//            rs.setValue(version, forHTTPHeaderField: "app-pums-version")
//        }
        
        if let h = headers {
            for (header, value) in h {
                rs.setValue(value, forHTTPHeaderField: header)
            }
        }
        manager.requestSerializer = rs
        var request: NSMutableURLRequest
        if let _fileInfo = fileInfo {
            request = manager.requestSerializer.multipartFormRequest(withMethod: HTTPMethod.post.rawValue, urlString: url, parameters: parameters as? [String : Any], constructingBodyWith: { (formData) in
                
                formData.appendPart(withFileData: _fileInfo["data"] as! Data, name: _fileInfo["name"] as? String ?? "", fileName: _fileInfo["fileName"] as? String ?? "", mimeType: _fileInfo["mimeType"] as? String ?? "jpeg")
            }, error: nil)
        } else {
            request = manager.requestSerializer.request(withMethod: method.rawValue, urlString: url, parameters: parameters, error: nil)
        }
        do {
            if let b = body {
                let json = try JSONSerialization.data(withJSONObject: b)
                request.httpBody = json
            }
            self.request(manager: manager, request: request as URLRequest, completionHandler: completionHandler)
            
        } catch {
            print(error)
        }
    }
    
    public class func request(api: API, completionHandler: @escaping (Result<NetworkResultModel,NetworkError>) -> Void) {
        let manager = AFHTTPSessionManager()
        let rs = AFHTTPRequestSerializer()
        rs.timeoutInterval = api.timeoutInterval
        for (key, value) in api.header {
            rs.setValue(value, forHTTPHeaderField: key)
        }
        manager.requestSerializer = rs
        var request: NSMutableURLRequest
        if let fileInfo = api.fileInfo {
            request = manager.requestSerializer.multipartFormRequest(withMethod: HTTPMethod.post.rawValue, urlString: api.url, parameters: api.params, constructingBodyWith: { (formData) in

                formData.appendPart(withFileData: fileInfo["data"] as! Data, name: fileInfo["name"] as? String ?? "", fileName: fileInfo["fileName"] as? String ?? "", mimeType: fileInfo["mimeType"] as? String ?? "jpeg")
            }, error: nil)
        } else {
            request = manager.requestSerializer.request(withMethod: api.method.rawValue, urlString: api.url, parameters: api.params, error: nil)
        }
        request.httpBody = api.httpBody
        self.request(manager: manager, request: request as URLRequest, completionHandler: completionHandler)
    }
    
    fileprivate static func request(manager: AFHTTPSessionManager, request: URLRequest, completionHandler: @escaping (Result<NetworkResultModel,NetworkError>) -> Void) {
        
        let task = manager.dataTask(with: request, uploadProgress: nil, downloadProgress: nil, completionHandler: { (urlResponse, responseObj, e) in
            
            let r = urlResponse as! HTTPURLResponse
            if r.statusCode == 200 {
                completionHandler(responseModel(httpResponse: responseObj!))
            } else {
                var responseResult = [String: Any]()
                responseResult["httpCode"] = r.statusCode
                var message = "请求出错，请稍后重试！"
                
                if let res = responseObj as? Dictionary<String, Any>, let error = res["error"] as? String, error.count > 0  {
                    message = error
                    responseResult["data"] = res
                }
//                if !YYReachability().isReachable {
//                    message = "网络已断开，请检查网络"
//                }
                responseResult["msg"] = message
                let ne = NetworkError(httpCode: r.statusCode, info: NetworkResultModel(from: responseResult))
                completionHandler(.failure(ne))
            }
        })
        task.resume()
    }
}

extension NetworkUtil {
    
    public static func responseModel(httpResponse response: Any) -> Result<NetworkResultModel,NetworkError> {
        let result = parseResponse(httpSuccessResponse: response)
        guard result.code == 200 else {
            let e = NetworkError(httpCode: result.httpCode, code: result.code, info: result)
            
            return Result.failure(e)
        }
        return Result.success(result)
    }
    
    static func parseResponse(httpSuccessResponse response: Any) -> NetworkResultModel {
        
        let d = response as! Dictionary<String, Any>
        guard d["code"] is String || d["code"] is Int else {return NetworkResultModel(code:-1, message: "code type error: code type not Int or ")}
        return NetworkResultModel(from: d)
    }
}
//MARK:- handler
class NetworkHandler: NetworkUtil {
    
    public override class func request(api: API, completionHandler: @escaping (Result<NetworkResultModel,NetworkError>) -> Void) {
        super.request(api: api) { (result) in
            switch result {
            case .failure(let e):
                if e.code == -401 {
                    NotificationCenter.default.post(name: NSNotification.Name(NotificationConst.UserSessionInvalidate), object: nil)
                }
            case .success(let m):
                if m.code == -401 {
                    NotificationCenter.default.post(name: NSNotification.Name(NotificationConst.UserSessionInvalidate), object: nil)
                }
            }
            completionHandler(result)
        }
    }

    public override class func request(url: String, method: HTTPMethod = .get, parameters: Any? = nil, body: [String:Any]? = nil, httpHeaderField headers: [String:String]? = nil, fileInfo: [String: Any]? = nil, timeoutInterval: TimeInterval = 15, completionHandler: @escaping (Result<NetworkResultModel,NetworkError>) -> Void) {
        super.request(url: url, method: method, parameters: parameters, body: body, httpHeaderField: headers, fileInfo: fileInfo) { (result) in
            switch result {
            case .failure(let e):
                if e.code == -401 {
                    NotificationCenter.default.post(name: NSNotification.Name(NotificationConst.UserSessionInvalidate), object: nil)
                }
            case .success(let m):
                if m.code == -401 {
                    NotificationCenter.default.post(name: NSNotification.Name(NotificationConst.UserSessionInvalidate), object: nil)
                }
            }
            completionHandler(result)
        }
    }
}
//MARK:- model
public struct NetworkResultModel {
    var httpCode: Int
    var code: Int?
    let message: String
    let type: String?
    let data: Dictionary<String, Any>
    
    init(httpCode: Int = 200, code: Int?, message: String = "", type: String? = nil, data: [String: Any] = [:]) {
        self.httpCode = httpCode
        self.code = code
        self.message = message
        self.type = type
        self.data = [:]
    }
    
    init(from result: Dictionary<String, Any>) {
        
        switch result["code"] {
        case let c where c is Int:
            self.code = c as? Int
        default:
            self.code = Int(result["code"] as? String ?? "403") ?? 403
        }
        self.httpCode = result["httpCode"] as? Int ?? 200
        self.message = result["msg"] as? String ?? ""
        self.type = result["type"] as? String
        if let dataMap = result["dataMap"] as? [String: Any] {
            self.data = dataMap
        } else if let dataMap = result["dataMap"] as? [Any] {
            data = ["list": dataMap]
        } else if let dataMap = result["dataMap"] {
            self.data = ["data": dataMap]
        } else {
            data = [:]
        }
    }
}
//MARK:- error
public struct NetworkError: Error {
    let httpCode: Int
    let code: Int?
    var info: NetworkResultModel?
    init(httpCode: Int, code: Int? = nil, info: NetworkResultModel?) {
        self.httpCode = httpCode
        self.code = code ?? info?.code
        self.info = info ?? NetworkResultModel(code: code)
    }
}
