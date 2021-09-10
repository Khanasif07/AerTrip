//
//  SecureYourAccountVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 06/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

protocol SecureYourAccountVMDelegate: class {
    func willCallApi()
    func getSuccess()
    func getFail(errors: ErrorCodes)
}

class SecureYourAccountVM {
    
    enum SecureAccount {
        case setPassword, resetPasswod
    }
    
    weak var delegate: SecureYourAccountVMDelegate?
    var isPasswordType: SecureAccount = .setPassword
    var email = ""
    var password = ""
    var hashKey  = ""
    var token    = ""
    var isFirstTime = true
}

//MARK:- Extension Webservices
//MARK:-
extension SecureYourAccountVM {
    
    func webserviceForUpdatePassword() {
        
        var params = JSONDictionary()
        
        params[APIKeys.hash_key.rawValue]  = self.hashKey
        params[APIKeys.password.rawValue]  = self.password
        params[APIKeys.token.rawValue]     = self.token
        params[APIKeys.email.rawValue]     = self.email
        
        self.delegate?.willCallApi()
        APICaller.shared.callUpdatePasswordAPI(params: params, loader: true, completionBlock: {(success, data, errors) in
            
            if success {
                self.delegate?.getSuccess()
                self.logEvent(with: .enterPasswordAndContinue)
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .login)
                self.delegate?.getFail(errors: errors)
                if errors.contains(126){
                    self.logEvent(with: .UsedAPreviouslyUsedPassword)
                }
            }
        })
        
    }
}


///firebase event logs

extension SecureYourAccountVM{
    
    
    func logEvent(with event: FirebaseEventLogs.EventsTypeName){
        switch isPasswordType{
        case .resetPasswod:
                FirebaseEventLogs.shared.logResetPasswordEvents(with: event)
        case .setPassword:
            switch  event {
            case .UsedAPreviouslyUsedPassword: break
            default: FirebaseEventLogs.shared.logSecureYourAccountEvents(with: event)
            }
        }
    }
    
}
    

