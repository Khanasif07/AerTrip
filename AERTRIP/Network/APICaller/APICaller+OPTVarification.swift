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
        AppNetworking.POST(endPoint: .sendOtp,success: {[weak self] data in
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
    
    
    func validateOTP(params: JSONDictionary, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .validateOtp, parameters: params) {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, data) in
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
    
    
    func validateOTPForMobile(params: JSONDictionary, isForUpdate: Bool, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ){
        let endPoint:APIEndPoint = (isForUpdate) ? .validateOtpForMobile : .validateOtpForSetMobile
        AppNetworking.POST(endPoint: endPoint, parameters: params) {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, data) in
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
    
    func cancelValidationAPI(params: JSONDictionary, isForUpdate: Bool, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ){
        let endPoint:APIEndPoint = (isForUpdate) ? .validateOtpForMobile : .validateOtpForSetMobile
        AppNetworking.POST(endPoint: .cancelOtpValidation, parameters: params) {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, data) in
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
    
    
    func validatePassword(params: JSONDictionary, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .setUserMobileCheck,parameters: params,success: {[weak self] data in
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
    
    func sendOTPOnMobileForSet(params: JSONDictionary, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .setUserMobile,parameters: params,success: {[weak self] data in
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
