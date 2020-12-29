//
//  APICaller+OPTVarification.swift
//  AERTRIP
//
//  Created by Appinventiv  on 28/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller{
    
    func sendOTPOnMobile(completionBlock: @escaping(_ data: JSONDictionary?, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.GET(endPoint: .sendOtp,success: {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, baggageData) in
                completionBlock(data[APIKeys.data.rawValue].dictionaryObject, [])
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
    
    
    func validateOTP(params: JSONDictionary, completionBlock: @escaping(_ data: JSONDictionary?, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .validateOtp, parameters: params) {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, baggageData) in
                completionBlock(data[APIKeys.data.rawValue].dictionaryObject, [])
            } failure: { (errorCode) in
                completionBlock(nil, errorCode)
            }
        } failure: { (error) in
        }
    }
    
    
    func sendOTPOnMobileForUpdate(params: JSONDictionary, completionBlock: @escaping(_ data: JSONDictionary?, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .sendOtpForMobile,parameters: params,success: {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, baggageData) in
                completionBlock(data[APIKeys.data.rawValue].dictionaryObject, [])
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
    
    
    func validateOTPForMobile(params: JSONDictionary, completionBlock: @escaping(_ data: JSONDictionary?, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .validateOtpForMobile, parameters: params) {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, baggageData) in
                completionBlock(data[APIKeys.data.rawValue].dictionaryObject, [])
            } failure: { (errorCode) in
                completionBlock(nil, errorCode)
            }
        } failure: { (error) in
        }
    }
    
}
