//
//  APICaller+Search.swift
//  AERTRIP
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    func getFlyerList(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ data: [FlyerModel], _ errorCodes: ErrorCodes)->Void ) {
        
        
        AppNetworking.GET(endPoint: .flyerSearch, parameters: params, loader: loader, success: { [weak self] (data) in
            
            
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                
                let data = FlyerModel.retunsFlyerArray(jsonArr: jsonData["data"].arrayValue)
                completionBlock(true, data, [])
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .profile)
                 completionBlock(false,[],errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], [])
            }
            else {
                completionBlock(false, [], [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
}
