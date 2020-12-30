//
//  OTPVarificationVM.swift
//  AERTRIP
//
//  Created by Appinventiv  on 28/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol OTPVarificationVMDelegate: NSObjectProtocol {
    func getSendOTPResponse()
    func comoletedValidation(_ isSucess: Bool)
}

enum OTPVerificationType{
    case walletOtp
    case phoneNumberChangeOtp
    case passwordChnage
    case none
}


class OTPVarificationVM{
    
    var itId = ""
    var varificationType: OTPVerificationType = .none
    var preSelectedCountry: PKCountryModel?
    var isdCode = ""
    var mobile = ""
    var maxMNS = 10
    var minMNS = 10
    weak var delegate: OTPVarificationVMDelegate?
    
    enum CurrenState{
        case otpToOldNumber
        case enterNewNumber
        case otpForNewNumnber
    }
    var state : CurrenState = .otpToOldNumber
    
    func sendOtpToUser(){
        APICaller.shared.sendOTPOnMobile {[weak self] (success, error) in
            guard let self = self else {return}
            self.delegate?.getSendOTPResponse()
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
            self.delegate?.getSendOTPResponse()
            if !success{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .otp)
            }
        }
    }
    
    func validateOTPForMobile(with otp:String){
        let param = ["otp" : otp]
        APICaller.shared.validateOTPForMobile(params: param) {[weak self] (success, error) in
            guard let self = self else {return}
            self.delegate?.comoletedValidation((success))
            if !success{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .otp)
            }
        }
    }
    
    func cancelValidation(){
        APICaller.shared.cancelValidationAPI(params: [:]) {(success, error) in}
    }
    
}
