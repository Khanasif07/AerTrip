//
//  APICaller+Settings.swift
//  AERTRIP
//
//  Created by Appinventiv on 06/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {

    func getCurrencies(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: MessageModel?) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.currencies, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in

//                if sucess {
//                    completionBlock(true, MessageModel(json: jsonData[APIKeys.data.rawValue]),jsonData[APIKeys.data.rawValue][APIKeys.session_id.rawValue].stringValue)
//                }else{
//                    completionBlock(false,nil,"")
//                }
                
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .chatBot)
                
                completionBlock(false,nil)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
//                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, nil)
            }
            else {
                completionBlock(false, nil)
            }
        }
    }

}
