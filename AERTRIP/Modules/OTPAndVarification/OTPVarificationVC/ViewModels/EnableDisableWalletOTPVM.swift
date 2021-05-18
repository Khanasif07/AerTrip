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
    func showErrorState(with errorState: ValidationState)
    func showErrorMessage(with errorState: ValidationState)
}

enum ValidationState{
    case password(success: Bool, msgString:String)
    case phoneOtp(success: Bool, msgString:String)
    case emailOtp(success: Bool, msgString:String)
}

enum SentOPTAPIType{
    case phone
    case email
    case both
    case passwordValidation
}

class EnableDisableWalletOTPVM {
    
    struct UserCredential {
        var password = ""
        var phoneOtp = ""
        var emailOtp = ""
        
    }
    var details = UserCredential()
    weak var delegate: EnableDisableWalletOTPVMDelegate?
    
    private var isValidPassword: ValidationState{
        if self.details.password.isEmpty{
            let state = ValidationState.password(success: false, msgString: LocalizedString.enterAccountPasswordMsg.localized)
            self.delegate?.showErrorState(with: state)
            self.logEvent(with: .invalidPasswordFormat)
            return(state)
        }
        if !(self.details.password.isValidPasswordCharacterCount){
            let state = ValidationState.password(success: false, msgString: LocalizedString.passwordCharacterCount.localized)
            self.delegate?.showErrorState(with: state)
            self.logEvent(with: .invalidPasswordFormat)
            return(state)
        }
        return(.password(success: true, msgString: ""))
    }
    
    private var isValidMobileOtp: ValidationState{
        if self.details.phoneOtp.isEmpty{
            let state = ValidationState.phoneOtp(success: false, msgString: LocalizedString.enterMobileOtpMsg.localized)
            self.delegate?.showErrorState(with: state)
            self.logEvent(with: .incorrectMobOtp)
            return(state)
        }
        return(.phoneOtp(success: true, msgString: ""))
    }
    
    private var isValidEmailOtp: ValidationState{
        if self.details.emailOtp.isEmpty{
            let state = ValidationState.emailOtp(success: false, msgString: LocalizedString.enterEmailOtpMsg.localized)
            self.delegate?.showErrorState(with: state)
            self.logEvent(with: .incorrectEmailOtp)
            return(state)
        }
        return(.emailOtp(success: true, msgString: ""))
    }
    
    func validate() {
        self.errorState()
        self.showMessage()
    }
    
    
    private func errorState(){
        _ = self.isValidPassword
        if (UserInfo.loggedInUser?.isWalletEnable ?? true){
            _ = self.isValidMobileOtp
            _ = self.isValidEmailOtp
        }
        
    }
    
    private func showMessage() {
        
        if case  ValidationState.password(let succes, _) = self.isValidPassword{
            //display msg
            if !succes{
                self.delegate?.showErrorMessage(with: self.isValidPassword)
                return
            }
        }
        if (UserInfo.loggedInUser?.isWalletEnable ?? true){
            if case  ValidationState.phoneOtp(let succes, _) = self.isValidMobileOtp{
                //display msg
                if !succes{
                    self.delegate?.showErrorMessage(with: self.isValidMobileOtp)
                    return
                }
            }
            if case  ValidationState.emailOtp(let succes, _) = self.isValidEmailOtp{
                //display msg
                if !succes{
                    self.delegate?.showErrorMessage(with: self.isValidEmailOtp)
                    return
                }
            }
            self.logEvent(with: .enterPasswordAndContinue)
            let dict : JSONDictionary = [
                "passcode" : self.details.password,
                "mobile_otp" : self.details.phoneOtp,
                "email_otp" : self.details.emailOtp
            ]
            self.validatePassword(with: dict)
        }else{
            let dict : JSONDictionary = ["passcode" : self.details.password]
            self.sendOTPValidation(params: dict, type: .passwordValidation)
        }
    }
    
    
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
        APICaller.shared.validateEnableDisableWalletOtp(params: param) {[weak self] (success, error) in
            guard let self = self else {return}
            self.delegate?.comoletedValidation((success))
            if !success{
                self.logEventForError(with: error)
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .otp)
            }
        }
    }
    
    func cancelValidation(){
        APICaller.shared.cancelEnableDisableWalletOtp(params: [:]) {(success, error) in}
    }
    
    
}

///Analytics
extension EnableDisableWalletOTPVM{
    enum EventLogType{
        case viewPassword, hidePassword, incorrectPassword,generateOtpForMob
        case incorrectMobOtp, generateOtpForEmail, incorrectEmailOtp
        case enterPasswordAndContinue, enableDisableOtp
    }

    fileprivate func logEventForError(with errors:ErrorCodes){
        if errors.contains(24) || errors.contains(27){
            self.logEvent(with: .incorrectMobOtp)
        }else if errors.contains(25) || errors.contains(26){
            self.logEvent(with: .incorrectEmailOtp)
        }else if errors.contains(28){
            self.logEvent(with: .invalidPasswordFormat)
        }
    }
    
    func logEvent(with eventType: FirebaseEventLogs.EventsTypeName){
        FirebaseEventLogs.shared.logEnableDisableWalletEvents(with: eventType, isEnabled: !(UserInfo.loggedInUser?.isWalletEnable ?? true))
    }
    
}
