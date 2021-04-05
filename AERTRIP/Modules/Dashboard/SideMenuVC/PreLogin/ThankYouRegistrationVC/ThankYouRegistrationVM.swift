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
        APICaller.shared.callVerifyRegistrationApi(type: self.type, params: params, loader: true, completionBlock: {(success, errors, email) in
            
            if success {
                self.email = email
                self.delegate?.didGetSuccess()
            }
            else {
                if errors.contains(10){
                    self.logEvents(with: .UsedExpiredRegistrationLink)
                }
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .login)
                self.delegate?.didGetFail(errors: errors)
            }
        })
        
    }
    
    func webserviceForValidateFromToken() {
        
        var params = JSONDictionary()
        params[APIKeys.key.rawValue]    = self.refId
        params[APIKeys.token.rawValue]  = self.token
        params[APIKeys.request.rawValue]  = APIKeys.password_reset.rawValue

     
        self.delegate?.willApiCall()
        APICaller.shared.callValidateFromTokenApi(params: params, loader: true, completionBlock: {(success, errors, email) in
            
            if success {
                self.email = email
                self.delegate?.didGetSuccess()
            }
            else {
                if errors.contains(9){
                    self.logEvents(with: .UsedExpiredResetPasswordPink)
                }
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .login)
                self.delegate?.didGetFail(errors: errors)
            }
        })
        
    }
}

///Log firebase events
extension ThankYouRegistrationVM{
    
    func logEvents(with event: FirebaseEventLogs.EventsTypeName){
        switch type{
        case .setPassword:
            guard event == .OpenEmailApp else { return  }
            FirebaseEventLogs.shared.logThankYouForRegisteringEvents(with: event)
        case .resetPassword:
            guard event == .OpenEmailApp else { return  }
            FirebaseEventLogs.shared.logCheckForgotPasswordEmailEvents(with: event)
        case .deeplinkSetPassword,.deeplinkResetPassword:
            guard event != .OpenEmailApp else { return  }
            FirebaseEventLogs.shared.logTryVerifyingYourEmailAgainEvents(with: event)
        }
        
    }
}
