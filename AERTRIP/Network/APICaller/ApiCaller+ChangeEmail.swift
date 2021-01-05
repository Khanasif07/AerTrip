//
//  ApiCaller+ChangeEmail.swift
//  AERTRIP
//
//  Created by Admin on 05/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    
    func changeEmail(params: JSONDictionary, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .changeLogin,parameters: params,success: {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, data) in
                completionBlock(true, [])
            } failure: { (errorCode) in
                completionBlock(false, errorCode)
            }
        },failure: { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.default.message)
                completionBlock(false, [])
            }
        })
    }
    
}
