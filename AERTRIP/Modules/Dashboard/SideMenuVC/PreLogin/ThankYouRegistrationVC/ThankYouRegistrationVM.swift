//
//  ThankYouRegistrationVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 05/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

protocol ThankYouRegistrationVMDelegate: class {
    
    func willApiCall()
    func didGetSuccess()
    func didGetFail(errors: ErrorCodes)
}

class ThankYouRegistrationVM {
    
    enum VerifyRegistrasion {
        case setPassword, resetPassword, deeplinkSetPassword, deeplinkResetPassword
    }
    
    weak var delegate: ThankYouRegistrationVMDelegate?
    var email = ""
    var refId = ""
    var token = ""
    var type: VerifyRegistrasion = .setPassword
}

//MARK:- Extension Webservices
//MARK:-
extension ThankYouRegistrationVM {
    
    func webserviceForGetRegistrationData() {
        
        var params = JSONDictionary()
        
        if self.type == .deeplinkSetPassword {
            
            params[APIKeys.ref.rawValue]  = self.refId
        } else {
            params[APIKeys.key.rawValue]    = self.refId
            params[APIKeys.token.rawValue]  = self.token
        }
        
        
        self.delegate?.willApiCall()
        APICaller.shared.callVerifyRegistrationApi(type: self.type, params: params, loader: true, completionBlock: {(success, errors) in
            
            if success {
                self.delegate?.didGetSuccess()
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .login)
                self.delegate?.didGetFail(errors: errors)
            }
        })
        
    }
}
