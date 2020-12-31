//
//  OTPVarificationVM.swift
//  AERTRIP
//
//  Created by Appinventiv  on 28/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol OTPVarificationVMDelegate: NSObjectProtocol {
    func getSendOTPResponse(_ isSucess: Bool)
    func comoletedValidation(_ isSucess: Bool)
}

enum OTPVerificationType{
    case walletOtp
    case phoneNumberChangeOtp
    case passwordChnage
    case setMobileNumber
    case none
}


class OTPVarificationVM{
    
    var itId = ""
    var varificationType: OTPVerificationType = .none
    var preSelectedCountry: PKCountryModel?
    var isdCode = "+91"
    var mobile = ""
    var maxMNS = 10
    var minMNS = 10
    weak var delegate: OTPVarificationVMDelegate?
    
    enum CurrenState{
        case otpToOldNumber//verify password in case of set mobile.
        case enterNewNumber
        case otpForNewNumnber
    }
    var state : CurrenState = .otpToOldNumber
    
    func sendOtpToUser(){
        APICaller.shared.sendOTPOnMobile {[weak self] (success, error) in
            guard let self = self else {return}
            self.delegate?.getSendOTPResponse(success)
            if !success{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .otp)
            }
        }
    }
    
    func validateOTP(with otp:String){
        let param = ["otp" : otp, APIKeys.it_id.rawValue: self.itId]
        APICaller.shared.validateOTP(params: param) {[weak self] (success, error) in
            guard let self = self else {return}
            self.delegate?.comoletedValidation(success)
            if !success{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .otp)
            }
        }
        
    }
    
    func sendOTPForNumberChange(on mobile: String, isd: String, isNeedParam: Bool){
        var param:JSONDictionary = [:]
        if isNeedParam{
            param = ["mobile":mobile, "isd": isd]
        }
        APICaller.shared.sendOTPOnMobileForUpdate(params: param){[weak self] (success, error) in
            guard let self = self else {return}
            if isNeedParam{
                self.state = .otpForNewNumnber
            }else{
                self.state = .otpToOldNumber
            }
            self.delegate?.getSendOTPResponse(success)
            if !success{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .otp)
            }
        }
    }
    
    func validateOTPForMobile(with otp:String, isForUpdate: Bool){
        let param = ["otp" : otp]
        APICaller.shared.validateOTPForMobile(params: param, isForUpdate: isForUpdate) {[weak self] (success, error) in
            guard let self = self else {return}
            self.delegate?.comoletedValidation((success))
            if !success{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .otp)
            }
        }
    }
    
    
    func validatePassword(with passcode: String){
        let param = ["passcode" : passcode]
        APICaller.shared.validatePassword(params: param) {[weak self] (success, error) in
            guard let self = self else {return}
            if success{
                self.state = .enterNewNumber
            }
            self.delegate?.comoletedValidation((success))
            if !success{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .otp)
            }
        }
    }
    
    func setMobileNumber(){
        let param:JSONDictionary = ["mobile":self.mobile, "isd": self.isdCode]
        APICaller.shared.sendOTPOnMobileForSet(params: param) {[weak self] (success, error) in
            guard let self = self else {return}
            if success{
                self.state = .otpForNewNumnber
            }
            self.delegate?.getSendOTPResponse(success)
            if !success{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .otp)
            }
        }
    }
    
    func cancelValidation(isForUpdate: Bool){
        APICaller.shared.cancelValidationAPI(params: [:], isForUpdate: isForUpdate) {(success, error) in}
    }
    
}
