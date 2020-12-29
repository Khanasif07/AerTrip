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
    func comoletedValidation()
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
    weak var delegate: OTPVarificationVMDelegate?
    
    func sendOtpToUser(){
        APICaller.shared.sendOTPOnMobile {[weak self] (data, error) in
            guard let self = self else {return}
            self.delegate?.getSendOTPResponse()
            print(data ?? [:])
        }
    }
    
    func validateOTP(with otp:String){
        let param = ["" : otp, APIKeys.it_id.rawValue: self.itId]
        APICaller.shared.validateOTP(params: param) {[weak self] (success, error) in
            guard let self = self else {return}
            print(success ?? [:])
        }
        
    }
    
    
    
}
