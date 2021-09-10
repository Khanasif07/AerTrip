//
//  APICaller+ChangePassword.swift
//  AERTRIP
//
//  Created by Admin on 20/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    
    func callChangePasswordAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.POST(endPoint: APIEndPoint.changePassword, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(json, success: { _, jsonData in
                
                completionBlock(true, [])
                
            }, failure: { errors in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .profile)
                completionBlock(false, errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    func callSetPasswordAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.POST(endPoint: APIEndPoint.setPassword, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(json, success: { _, jsonData in
                
                completionBlock(true, [])
                
            }, failure: { errors in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .profile)
                completionBlock(false, errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
}
