//
//  Networking.swift
//
//  Created by Pramod Kumar on 04/02/16.
//  Copyright © 2016 Pramod Kumar. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire
import SwiftyJSON

typealias JSONDictionary = [String: Any]
typealias JSONDictionaryArray = [JSONDictionary]




enum AppNetworking {
    
    enum MultiPartFileType:String {
        case image, video
    }
    
    static var loader = __Loader(frame: CGRect(x:0, y:0, width:0, height:0))
    static let username = ""
    static let password = ""
    //static var manager:AFHTTPSessionManager?
    internal typealias Success = ((JSON) -> Void) //success response clouser
    internal typealias Failure = ((_ error : NSError) -> Void) //failure response clouser
    internal typealias Progress = ((Double) -> Void) //shows the upload progress
    
    //check device has internet connection or not
    static var isConnectedToNetwork : Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    static private func addMandatoryParams(toExistingParams params: JSONDictionary) -> JSONDictionary {
        
        return params
        //        var temp = params
        //        temp["device_type"] = UIDevice.deviceOSType
        //        if let remotePushToken = UIDevice.remotePushToken{
        //            temp["device_token"] = remotePushToken
        //        }
        //        if let version: Any = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
        //            temp["app_version"] = "\(version)"
        //        }
        //        if let user_id = (UserInfo.loggedInUser?.userId), temp["user_id"] == nil{
        //            temp["user_id"] = "\(user_id)"
        //        }
        //
        //        let keyChainMngr = PKKeyChainManager(keyPrefix: "\(AppConstant.AppName)")
        //        if let deviceId = keyChainMngr.get(UserDefaultKeys.deviceID) {
        //            temp["device_id"] = "\(deviceId)"
        //        }
        //        else {
        //            let uuid = UUID().uuidString
        //            keyChainMngr.set(uuid, forKey: UserDefaultKeys.deviceID)
        //            temp["device_id"] = "\(uuid)"
        //        }
        //
        //        return temp
    }
    
    
    static func POST(endPoint : APIEndPoint,
                     parameters : JSONDictionary = [:],
                     headers : HTTPHeaders = [:],
                     loader : Bool = true,
                     success : @escaping Success,
                     failure : @escaping Failure){
        
        
        request(URLString: endPoint.path, httpMethod: .post, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    static func POSTWithMultiPart(endPoint : APIEndPoint,
                                  parameters : JSONDictionary = [:],
                                  multipartData : [(key:String, filePath:String, fileExtention:String, fileType:MultiPartFileType)]? = [],
                                  headers : HTTPHeaders = [:],
                                  loader : Bool = true,
                                  success : @escaping Success,
                                  progress : @escaping Progress,
                                  failure : @escaping Failure) {
        
        upload(URLString: endPoint.path, httpMethod: .post, parameters: parameters,multipartData: multipartData ,headers: headers, success: success, progress: progress, failure: failure )
    }
    
    static func GET(endPoint : APIEndPoint,
                    parameters : JSONDictionary = [:],
                    headers : HTTPHeaders = [:],
                    loader : Bool = true,
                    loaderContainerView: UIView? = nil,
                    success : @escaping Success,
                    failure : @escaping Failure) {
        
        request(URLString: endPoint.path, httpMethod: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers, loaderContainerView: loaderContainerView, success: success, failure: failure)
    }
    static func GET(endPoint : String,
                    parameters : JSONDictionary = [:],
                    headers : HTTPHeaders = [:],
                    loader : Bool = true,
                    loaderContainerView: UIView? = nil,
                    success : @escaping Success,
                    failure : @escaping Failure) {
        
        request(URLString: endPoint, httpMethod: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers, loaderContainerView: loaderContainerView, success: success, failure: failure)
    }
    
    static func PUT(endPoint : APIEndPoint,
                    parameters : JSONDictionary = [:],
                    headers : HTTPHeaders = [:],
                    loader : Bool = true,
                    success : @escaping Success,
                    failure : @escaping Failure) {
        
        request(URLString: endPoint.path, httpMethod: .put, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    static func DELETE(endPoint : APIEndPoint,
                       parameters : JSONDictionary = [:],
                       headers : HTTPHeaders = [:],
                       loader : Bool = true,
                       success : @escaping Success,
                       failure : @escaping Failure) {
        
        request(URLString: endPoint.path, httpMethod: .delete, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    private static func request(URLString : String,
                                httpMethod : HTTPMethod,
                                parameters : JSONDictionary = [:],
                                encoding: URLEncoding = .httpBody,
                                headers : HTTPHeaders = [:],
                                loader : Bool = false,
                                loaderContainerView: UIView? = nil,
                                success : @escaping Success,
                                failure : @escaping Failure) {
        
        
        if loader { showLoader() }
        
        var header : HTTPHeaders = [:]
        let isLocalServerUrl = URLString.hasPrefix(APIEndPoint.baseUrlPath.rawValue)
        
        if isLocalServerUrl{
            
            printDebug("request params: \(addMandatoryParams(toExistingParams: parameters))\nrequest url: \(URLString)\nmethod: \(httpMethod)")
            
            guard let data = "\(username):\(password)".data(using: String.Encoding.utf8) else { return  }
            
            let base64LoginString = data.base64EncodedString()
//            header["api-key"] = "3a457a74be76d6c3603059b559f6addf"
            header["content-type"] = "application/x-www-form-urlencoded"
            header["Authorization"] = "Basic \(base64LoginString)"
            if let accessToken = UserInfo.loggedInUser?.accessToken, !accessToken.isEmpty {
                
                header["Access-Token"] = accessToken
                //            printDebug("Access-Token: \(accessToken)")
            }
            else {
                header["api-key"] = APIEndPoint.apiKey.rawValue
                printDebug("Api-Key: \(APIEndPoint.apiKey.rawValue)")
            }
            
            for (key, value) in headers {
                header[key] = value
            }
        }
        else{
            printDebug("request params: \(parameters)\nrequest url: \(URLString)\nmethod: \(httpMethod)")
        }
        
       let request = Alamofire.request(URLString,
                          method: httpMethod,
                          parameters: isLocalServerUrl ? addMandatoryParams(toExistingParams: parameters):parameters,
                          encoding: encoding,
                          headers: header)
        
        request.responseString { (data) in
            printDebug(data)
        }
        request.responseData { (response:DataResponse<Data>) in
                            
                            printDebug(headers)
                            
                            if loader { hideLoader() }
                            
                            switch(response.result) {
                                
                            case .success(let value):
                                
                                printDebug("response: \(value)\nresponse url: \(URLString)")
                                success(JSON(value))
                                
                            case .failure(let e):
                                
                                if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                    
                                    printDebug("response: \(e)\nresponse url: \(URLString)")
                                    
                                    // Handle Internet Not available UI
                                    if loader {
                                        if loader { hideLoader() }
                                    }
                                }
                                else{
                                    printDebug("response: some error occured\nresponse url: \(URLString)")
                                }
                                failure(e as NSError)
                            }
        }
        
    }
    
    //Multipart
    private static func upload(URLString : String,
                               httpMethod : HTTPMethod,
                               parameters : JSONDictionary = [:],
                               multipartData : [(key:String, filePath:String, fileExtention:String, fileType:MultiPartFileType)]? = [],
                               headers : HTTPHeaders = [:],
                               loader : Bool = true,
                               success : @escaping Success,
                               progress : @escaping Progress,
                               failure : @escaping Failure) {
        
        if loader { showLoader() }
        
        printDebug("request params: \(addMandatoryParams(toExistingParams: parameters))\nmultipart params: \(multipartData ?? [])\nurl: \(URLString)\nmethod: \(httpMethod)")
        
        guard let data = "\(username):\(password)".data(using: String.Encoding.utf8) else { return  }
        
        let base64LoginString = data.base64EncodedString()
        
        var header : HTTPHeaders = ["Authorization":"Basic \(base64LoginString)"]
        
        if let miltiPart = multipartData?.first, !miltiPart.filePath.isEmpty {
            
            header["content-type"] = "multipart/form-data; boundary=Boundary-\(NSUUID().uuidString)"
        }
        else {
            header["content-type"] = "application/x-www-form-urlencoded"
        }
        
        if let accessToken = UserInfo.loggedInUser?.accessToken, !accessToken.isEmpty {
            
            header["Access-Token"] = accessToken
            printDebug("Access-Token: \(accessToken)")
        }
        else {
            header["Api-Key"] = APIEndPoint.apiKey.rawValue
            printDebug("Api-Key: \(APIEndPoint.apiKey.rawValue)")
        }
        
        for (key, value) in headers {
            header[key] = value
        }
        
        let url = try! URLRequest(url: URLString, method: httpMethod, headers: header)
//        let url = try! URLRequest(url: "https://encryptorapp.000webhostapp.com/test.php", method: httpMethod, headers: header)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let mltiprtData = multipartData {
                
                for (key, filePath, fileExtention, fileType) in mltiprtData {
                    if !filePath.isEmpty {
                        let mimeType = "\(fileType.rawValue)/\(fileExtention)"
                        var fileUrl: URL?
                        if filePath.hasPrefix("file:/") {
                            fileUrl = URL(string: filePath)
                        }
                        else {
                            fileUrl = URL(fileURLWithPath: filePath)
                        }
                        if let url = fileUrl{
                            do{
                                let data = try Data(contentsOf: url, options: NSData.ReadingOptions.alwaysMapped)
                                multipartFormData.append(data, withName: key, fileName: "\(UUID().uuidString).\(fileExtention)", mimeType: mimeType)
                                
                            }
                            catch let error{
                                printDebug(error)
                            }
                        }
                    }
                }
            }
            
            for (ky , value) in addMandatoryParams(toExistingParams: parameters){
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: ky)
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: ky)
            }
        },
                         with: url, encodingCompletion: { encodingResult in
                            
                            switch encodingResult{
                            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                                
                                upload.uploadProgress(closure: { (prgrss) in
                                    progress(prgrss.fractionCompleted)
                                })
                                
                                upload.responseData(completionHandler: { (response:DataResponse<Data>) in
                                    
                                    switch response.result{
                                        
                                    case .success(let value):
                                        if loader {
                                            if loader { hideLoader() }
                                        }
                                        
                                        printDebug("response: \(value)\nresponse url: \(URLString)")
                                        success(JSON(value))
                                        
                                    case .failure(let e):
                                        if loader {
                                            if loader { hideLoader() }
                                        }
                                        
                                        if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                            printDebug("response: \(e)\nresponse url: \(URLString)")
                                        }
                                        else{
                                            printDebug("response: some error occured\nresponse url: \(URLString)")
                                        }
                                        failure(e as NSError)
                                    }
                                })
                                
                            case .failure(let e):
                                if loader {
                                    if loader { hideLoader() }
                                }
                                
                                
                                if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                    printDebug("response: \(e)\nresponse url: \(URLString)")
                                }
                                else{
                                    printDebug("response: some error occured\nresponse url: \(URLString)")
                                }
                                failure(e as NSError)
                            }
        })
    }
}

extension AppNetworking {
    
    static func showLoader() {
        
        guard let window = AppDelegate.shared.window else {return}
        loader.start(sender: window)
    }
    
    static func hideLoader() {
        loader.stop()
    }
}


