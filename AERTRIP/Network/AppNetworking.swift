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
typealias DownloadData = (_ data : Data) -> ()
typealias ProgressUpdate = ((Double) -> Void)


enum AppNetworking {
    
    enum MultiPartFileType:String {
        case image, video
    }
    
    static let username = ""
    static let password = ""
    //static var manager:AFHTTPSessionManager?
    internal typealias Success = ((JSON) -> Void) //success response clouser
    internal typealias Failure = ((_ error : NSError) -> Void) //failure response clouser
    internal typealias Progress = ((Double) -> Void) //shows the upload progress
    
    static let noInternetError = NSError(code: -4531, localizedDescription: LocalizedString.NoInternet.localized)
    //check device has internet connection or not
    static var isConnectedToNetwork : Bool {
        return AppGlobals.shared.isNetworkRechable()
    }
    
    static private func addMandatoryParams(toExistingParams params: JSONDictionary) -> JSONDictionary {
        
        var temp = params
        temp["_"] = Int(Date().timeIntervalSince1970)
        
        return temp
    }
    
    
    static func POST(endPoint : APIEndPoint,
                     parameters : JSONDictionary = [:],
                     headers : HTTPHeaders = [:],
                     loader : Bool = true,
                     success : @escaping Success,
                     failure : @escaping Failure){
        
        
        request(URLString: endPoint.path, httpMethod: .post, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    static func POST(endPointPath : String,
                     parameters : JSONDictionary = [:],
                     headers : HTTPHeaders = [:],
                     loader : Bool = true,
                     success : @escaping Success,
                     failure : @escaping Failure){
        
        
        request(URLString: endPointPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "", httpMethod: .post, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    static func POSTWithMultiPart(endPoint : APIEndPoint,
                                  parameters : JSONDictionary = [:],
                                  multipartData : [(key:String, filePath:String, fileExtention:String, fileType:MultiPartFileType)]? = [],
                                  headers : HTTPHeaders = [:],
                                  loader : Bool = false,
                                  success : @escaping Success,
                                  progress : @escaping Progress,
                                  failure : @escaping Failure) {
        
        upload(URLString: endPoint.path, httpMethod: .post, parameters: parameters,multipartData: multipartData ,headers: headers,loader:loader, success: success, progress: progress, failure: failure )
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
    
    static func DOWNLOAD(sourceUrl : String,
                         parameters : JSONDictionary = [:],
                         headers : HTTPHeaders = [:],
                         destinationUrl: URL,
                         loader : Bool = false,
                         requestHandler: @escaping (DownloadRequest) -> Void,
                         progressUpdate: @escaping (Double) -> Void,
                         success : @escaping (JSON) -> Void,
                         failure : @escaping (NSError) -> Void) {
        
        download(URLString: sourceUrl, httpMethod: .get, parameters: parameters, headers: headers, destinationUrl: destinationUrl, loader: loader, requestHandler: requestHandler, progressUpdate: progressUpdate, success: success, failure: failure)
    }
    
    private static func download(URLString : String,
                                 httpMethod : HTTPMethod,
                                 parameters : JSONDictionary = [:],
                                 encoding: ParameterEncoding = JSONEncoding.default,
                                 headers : HTTPHeaders = [:],
                                 destinationUrl : URL,
                                 loader : Bool = true,
                                 requestHandler: @escaping (DownloadRequest) -> Void,
                                 progressUpdate: @escaping ProgressUpdate,
                                 success : @escaping (JSON) -> Void,
                                 failure : @escaping (NSError) -> Void) {
        
        
        let destination: DownloadRequest.Destination = { _, _  in
            return (destinationUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        if loader { showLoader() }
        let encoding: ParameterEncoder = {
            switch httpMethod {
            case .get:
                return URLEncodedFormParameterEncoder.default
            default:
                return JSONParameterEncoder.default
            }
        }()
        let downloadRequest = AF.download(URLString, method: httpMethod, parameters: parameters, headers: headers, to: destination).response { (response) in
        
        if loader { showLoader() }
        
        if response.error != nil {
            printDebug("===================== FAILURE =======================")
            let e = response.error!
            printDebug(e.localizedDescription)
            
            if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                printDebug("response: \(e)\nresponse url: \(URLString)")
            }
            failure(e as NSError)
            
        } else {
            printDebug("===================== RESPONSE =======================")
            guard response.error == nil else { return }
            
            
            success(JSON.init([:]))
        }
        }.downloadProgress { (progress) in
        progressUpdate(progress.fractionCompleted)
        }
        
//
//        let downloadRequest = Alamofire.SessionManager.download(URLString, method: httpMethod, parameters: parameters, encoding: encoding, headers: headers, to: destination).response { (response) in
//
//            if loader { showLoader() }
//
//            if response.error != nil {
//                printDebug("===================== FAILURE =======================")
//                let e = response.error!
//                printDebug(e.localizedDescription)
//
//                if (e as NSError).code == NSURLErrorNotConnectedToInternet {
//                    printDebug("response: \(e)\nresponse url: \(URLString)")
//                }
//                failure(e as NSError)
//
//            } else {
//                printDebug("===================== RESPONSE =======================")
//                guard response.error == nil else { return }
//
//
//                success(JSON.init([:]))
//            }
//            }.downloadProgress { (progress) in
//                progressUpdate(progress.fractionCompleted)
//        }
        requestHandler(downloadRequest)
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
            header["content-type"] = "application/x-www-form-urlencoded"
            header["Authorization"] = "Basic \(base64LoginString)"
            if let accessToken = UserInfo.loggedInUser?.accessToken, !accessToken.isEmpty {
                
                header["Access-Token"] = accessToken
            }
            else {
                header["api-key"] = APIEndPoint.apiKey.rawValue
                printDebug("Api-Key: \(APIEndPoint.apiKey.rawValue)")
            }
            
            
            for head in headers {
                header[head.name] = head.value
            }
        }
        else{
            printDebug("request params: \(parameters)\nrequest url: \(URLString)\nmethod: \(httpMethod)")
        }
        
        guard self.isConnectedToNetwork else {
            failure(self.noInternetError)
            return
        }
        
        //add the X-Auth-Token for the security perpose as discussed with aertrip backend
        if let xToken = UserDefaults.getObject(forKey: UserDefaults.Key.xAuthToken.rawValue) as? String {
            header["X-Auth-Token"] = xToken
        }
        
        AF.sessionConfiguration.timeoutIntervalForRequest = 120
       let request = AF.request(URLString,
                          method: httpMethod,
                          parameters: isLocalServerUrl ? addMandatoryParams(toExistingParams: parameters):parameters,
                          encoding: encoding,
                          headers: header)
        
        request.responseString { (data) in
            //printDebug(data)
        }
        
        self.addCookies(forUrl: request.request?.url)
        
        request.responseData { (response:DataResponse) in
                            
                            printDebug(headers)
            
            //save the X-Auth-Token for the security perpose as discussed with aertrip backend
            if let headers = response.response?.allHeaderFields, let xToken = headers["X-Auth-Token"] {
                UserDefaults.setObject("\(xToken)", forKey: UserDefaults.Key.xAuthToken.rawValue)
            }
            printDebug("Cookies:--\(HTTPCookieStorage.shared.cookies(for: request.request!.url!))")
            
            AppNetworking.saveCookies(fromUrl: response.response?.url)
            
                            if loader { hideLoader() }
                            
                            switch(response.result) {
                                
                            case .success(let value):
                                if value.isEmpty, let resData = response.data, let string = String(data: resData, encoding: String.Encoding.utf8) {
                                    printDebug("response: \(string)\nresponse url: \(URLString)")
                                }
                                else {
                                    printDebug("response: \(value)\nresponse url: \(URLString)")
                                }
                                printDebug(JSON(value))
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
        
        for head in headers {
            header[head.name] = head.value
        }
        
        //add the X-Auth-Token for the security perpose as discussed with aertrip backend
        if let xToken = UserDefaults.getObject(forKey: UserDefaults.Key.xAuthToken.rawValue) as? String {
            header["X-Auth-Token"] = xToken
        }
        
        let url = try! URLRequest(url: URLString, method: httpMethod, headers: header)
        
        guard self.isConnectedToNetwork else {
            failure(self.noInternetError)
            return
        }
        
        self.addCookies(forUrl: url.url)
        
        

            AF.upload(multipartFormData: { (multipartFormData) in
                
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
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: ky)
                }
            },to: URLString, usingThreshold: UInt64.init(),
              method: httpMethod,
              headers: header).response{ response in
                
                AppNetworking.saveCookies(fromUrl: response.response?.url)
                switch response.result{
                    
                case .success(let value):
                    if loader {
                        if loader { hideLoader() }
                    }
                    
                    printDebug("response: \(String(describing: value))\nresponse url: \(URLString)")
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
                
            }
        
        
        
        
        
//        AF.upload(multipartFormData: { (multipartFormData) in
//
//            if let mltiprtData = multipartData {
//
//                for (key, filePath, fileExtention, fileType) in mltiprtData {
//                    if !filePath.isEmpty {
//                        let mimeType = "\(fileType.rawValue)/\(fileExtention)"
//                        var fileUrl: URL?
//                        if filePath.hasPrefix("file:/") {
//                            fileUrl = URL(string: filePath)
//                        }
//                        else {
//                            fileUrl = URL(fileURLWithPath: filePath)
//                        }
//                        if let url = fileUrl{
//                            do{
//                                let data = try Data(contentsOf: url, options: NSData.ReadingOptions.alwaysMapped)
//                                multipartFormData.append(data, withName: key, fileName: "\(UUID().uuidString).\(fileExtention)", mimeType: mimeType)
//
//                            }
//                            catch let error{
//                                printDebug(error)
//                            }
//                        }
//                    }
//                }
//            }
//
//            for (ky , value) in addMandatoryParams(toExistingParams: parameters){
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: ky)
//            }
//        },
//                         with: url, encodingCompletion: { encodingResult in
//
//                            switch encodingResult{
//                            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
//
//                                upload.uploadProgress(closure: { (prgrss) in
//                                    progress(prgrss.fractionCompleted)
//                                })
//
//                                upload.responseData(completionHandler: { (response:DataResponse<Data>) in
//
//                                    AppNetworking.saveCookies(fromUrl: response.response?.url)
//                                    switch response.result{
//
//                                    case .success(let value):
//                                        if loader {
//                                            if loader { hideLoader() }
//                                        }
//
//                                        printDebug("response: \(value)\nresponse url: \(URLString)")
//                                        success(JSON(value))
//
//                                    case .failure(let e):
//                                        if loader {
//                                            if loader { hideLoader() }
//                                        }
//
//                                        if (e as NSError).code == NSURLErrorNotConnectedToInternet {
//                                            printDebug("response: \(e)\nresponse url: \(URLString)")
//                                        }
//                                        else{
//                                            printDebug("response: some error occured\nresponse url: \(URLString)")
//                                        }
//                                        failure(e as NSError)
//                                    }
//                                })
//
//                            case .failure(let e):
//                                if loader {
//                                    if loader { hideLoader() }
//                                }
//
//
//                                if (e as NSError).code == NSURLErrorNotConnectedToInternet {
//                                    printDebug("response: \(e)\nresponse url: \(URLString)")
//                                }
//                                else{
//                                    printDebug("response: some error occured\nresponse url: \(URLString)")
//                                }
//                                failure(e as NSError)
//                            }
//        })
    }
}


extension AppNetworking {
    private static func addCookies(forUrl: URL?) {
        if let allCookies = UserDefaults.getCustomObject(forKey: UserDefaults.Key.currentUserCookies.rawValue) as? [HTTPCookie] {
            for cookie in allCookies {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
    }
    
    private static func saveCookies(fromUrl: URL?) {
        if let cookies = HTTPCookieStorage.shared.cookies {
            UserDefaults.saveCustomObject(customObject: cookies, forKey: UserDefaults.Key.currentUserCookies.rawValue)
        }
    }
}

extension AppNetworking {
    
    static func showLoader() {
//        guard let window = AppDelegate.shared.window else {return}
    }
    
    static func hideLoader() {
    }
}


extension AppNetworking {
    static func POSTWithString(endPoint : String,
                     parameters : JSONDictionary = [:],
                     headers : HTTPHeaders = [:],
                     loader : Bool = true,
                     success : @escaping Success,
                     failure : @escaping Failure){
        
        
        request(URLString: endPoint, httpMethod: .post, parameters: parameters, headers: headers, success: success, failure: failure)
    }
}
