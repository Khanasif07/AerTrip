//
//  APICaller+OPTVarification+VersionControl.swift
//  AERTRIP
//
//  Created by Admin on 29/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller{

    
    func checkFOrUpdates(params: JSONDictionary, completionBlock: @escaping(_ data: JSONDictionary?, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .versionControl,parameters: params,success: {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, versionData) in
            
                printDebug(versionData)
                
//                completionBlock(data[APIKeys.data.rawValue].dictionaryObject, [])
           
            } failure: { (errorCode) in
                completionBlock(nil, errorCode)
            }
        },failure: { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(nil, [])
            }
            else {
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.default.message)
                completionBlock(nil, [])
            }
        })
    }
    
    
}


