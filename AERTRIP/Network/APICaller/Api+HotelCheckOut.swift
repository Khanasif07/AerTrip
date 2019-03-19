//
//  Api+HotelCheckOut.swift
//  AERTRIP
//
//  Created by Admin on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    
    func sendDashBoardEmailIDAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ successMessage: String)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.emailItineraries, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                completionBlock(sucess, [], jsonData[APIKeys.data.rawValue][APIKeys.msg.rawValue].stringValue)
                
            }, failure: { (errors) in
                completionBlock(false, errors, "")
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue], "")
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], "")
            }
        }
    }
}
