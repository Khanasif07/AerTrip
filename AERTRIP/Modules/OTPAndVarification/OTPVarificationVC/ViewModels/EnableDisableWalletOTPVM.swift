//
//  EnableDisableWalletOTPVM.swift
//  AERTRIP
//
//  Created by Appinventiv  on 31/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol EnableDisableWalletOTPVMDelegate: NSObjectProtocol {
    func getSendOTPResponse(_ isSucess: Bool, type:SentOPTAPIType)
    func comoletedValidation(_ isSucess: Bool)
}

enum SentOPTAPIType{
    case phone
    case email
    case both
    case passwordValidation
}

class EnableDisableWalletOTPVM {
    
    weak var delegate: EnableDisableWalletOTPVMDelegate?
    
    func sendOTPValidation(params: JSONDictionary, type: SentOPTAPIType){
        APICaller.shared.enableDisableWalletOtp(params: params) {[weak self] (success, error) in
            guard let self = self else {return}
            self.delegate?.getSendOTPResponse((success), type: type)
            if !success{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .otp)
            }
        }
    }
    
    
    func validatePassword(with param: JSONDictionary){
//        let param = ["passcode" : passcode]
        APICaller.shared.validateEnableDisableWalletOtp(params: param) {[weak self] (success, error) in
            guard let self = self else {return}
            self.delegate?.comoletedValidation((success))
            if !success{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .otp)
            }
        }
    }
    
    func cancelValidation(isForUpdate: Bool){
        APICaller.shared.cancelEnableDisableWalletOtp(params: [:]) {(success, error) in}
    }
    
    
}
