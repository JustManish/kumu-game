//
//  NetworkClient.swift
//  KumuApp
//
//  Created by mac on 30/06/21.
//

import UIKit
import Alamofire

typealias OnPrimitiveResponse = (Error?) -> (Void)

class NetworkClient: NSObject {
    
    static var shared = NetworkClient()
    
    var baseURL: String
   // var baseURL_wp: String
    let decoder: JSONDecoder
    let sessionManager = SessionManager.default
    internal var token: String? = nil
    internal var headers: HTTPHeaders  {
//        if let userToken = authToken {
//            self.token = userToken
//            mylog("self.token === \(self.token)")
//        }
//        guard let token = token else {
//            return [:]
//        }
        return [
            //"Authorization": token,
            "X-kumu-UserId" : "5EvuBLZWwhJrN4Pj",
            //"X-kumu-UserId" : "g5aiu2fbMDSMruYc",
            "X-kumu-Token"  : "db708c58e3513b30c874ce690c82292b",
            //"X-kumu-Token"  : "7cba492bacdb8ff4a6b238fd6f0b2ed8",
            "Device-Type"   : DeviceInfo.platform,
            "Version-Code"  : DeviceInfo.version,
            "Device-Id"     : DeviceInfo.deviceId
            
        ]
    }
    init(domain: String = BaseURL, decoder: JSONDecoder = JSONDecoder()) {
        self.baseURL = domain
        self.decoder = decoder
        //self.baseURL_wp = baseURL_wp
    }
    func getRequest(_ url: URLConvertible, parameters: Parameters? = nil) -> DataRequest {
           return sessionManager.request("\(baseURL)/\(url)", method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
    }
    
    func deleteRequest(_ url: URLConvertible, parameters: Parameters? = nil) -> DataRequest {
        return sessionManager.request("\(baseURL)/\(url)", method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
    }
    
    func postRequest(_ url: URLConvertible, parameters: Parameters? = nil) -> DataRequest {
        return sessionManager.request("\(baseURL)/\(url)", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
    }
    
    func putRequest(_ url: URLConvertible, parameters: Parameters? = nil) -> DataRequest {
        return sessionManager.request("\(baseURL)/\(url)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
    }
    
}

