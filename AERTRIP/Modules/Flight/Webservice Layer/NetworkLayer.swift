//
//  NetworkLayer.swift
//  Aertrip
//
//  Created by  hrishikesh on 13/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


protocol APIProtocol {
    
    func getUrlRequest() -> URLRequest
    
    var flightBaseUrl : String { get }

    var tripsBaseUrl : String { get }

    var path : String { get }
    
    var httpMethod : String { get }
    
    var data : Data? { get }
    
    var successCode : Int { get }
    
    var httpHeader : [String : String]? { get}
    
}

class WebAPIService
{    
    func executeAPI(apiServive : WebService, completionHandler : @escaping (Data) -> Void , failureHandler: @escaping (Error) -> Void )
    {
        var urlRequest = apiServive.getUrlRequest()
        urlRequest.httpBody = apiServive.data
        urlRequest.httpMethod = apiServive.httpMethod
            
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {  (data, response, error) in
            
            guard error == nil else {
                failureHandler( error!)
                return
            }
            
            
            if let httpResponse = response as? HTTPURLResponse {
                
                //                    if httpResponse.statusCode != strongSelf.APIService.successCode {
                if httpResponse.statusCode != apiServive.successCode {
                    
                    failureHandler( NSError(domain:"", code:httpResponse.statusCode, userInfo:nil))
                    return
                }
            }
            
            guard let responseData = data else {
                return
            }
            
            completionHandler (responseData)
        }
        task.resume()
        
    }
    
    
    func getJSONFileFromAPI(APIRequest : APIProtocol , completionHandler : @escaping (Data) -> Void , failureHandler: @escaping (Error) -> Void ){
        
        let urlRequest = APIRequest.getUrlRequest()
        
        let session = URLSession.shared
        let task = session.downloadTask(with: urlRequest){ url , response, error in
            
            
            guard error == nil else {
                failureHandler( error!)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode != APIRequest.successCode {
                    failureHandler( NSError(domain:"", code:httpResponse.statusCode, userInfo:nil))
                }
            }
            
            do {
                
                guard let urlfilePath = url else {
                    return
                }
                let responseData = try Data(contentsOf: urlfilePath)
                completionHandler (responseData)
            }
            catch {
            }
            
        }
        task.resume()
        
        
    }
    
    func getImageForPath( path:String , completionHandler: @escaping (() -> Void )) -> UIImage? {
        
        let urlRequest = URLRequest(url: URL(string: path)!)
        if let responseObj = URLCache.shared.cachedResponse(for: urlRequest) {
            
            let image = UIImage(data: responseObj.data)
            return image
        }else {
            
            let urlSession = URLSession.shared
            let dataTask =  urlSession.dataTask(with: urlRequest) { ( downloadedData, response, error) in
                
                if (error != nil) {
                    return
                }
                
                if let data = downloadedData , let response = response {
                    let cacheResponse = CachedURLResponse(response: response, data: data)
                    URLCache.shared.storeCachedResponse(cacheResponse, for: urlRequest)
                    completionHandler()
                }
            }
            
            dataTask.resume()
        }
        return nil
    }
}