//
//  APICaller+OPTVarification.swift
//  AERTRIP
//
//  Created by Appinventiv  on 28/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller{
    
    func sendOTPOnMobile(completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.GET(endPoint: .sendOtp,success: {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, baggageData) in
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
    
    
    func validateOTP(params: JSONDictionary, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .validateOtp, parameters: params) {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, baggageData) in
                completionBlock(true, [])
            } failure: { (errorCode) in
                completionBlock(false, errorCode)
            }
        } failure: { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.default.message)
                completionBlock(false, [])
            }
        }
    }
    
    
    func sendOTPOnMobileForUpdate(params: JSONDictionary, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .sendOtpForMobile,parameters: params,success: {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, baggageData) in
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
    
    
    func validateOTPForMobile(params: JSONDictionary, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .validateOtpForMobile, parameters: params) {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, baggageData) in
                completionBlock(true, [])
            } failure: { (errorCode) in
                completionBlock(false, errorCode)
            }
        } failure: { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.default.message)
                completionBlock(false, [])
            }
        }
    }
    
    func cancelValidationAPI(params: JSONDictionary, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .cancelOtpValidation, parameters: params) {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, baggageData) in
                completionBlock(true, [])
            } failure: { (errorCode) in
                completionBlock(false, errorCode)
            }
        } failure: { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.default.message)
                completionBlock(false, [])
            }
        }
    }
    
}
