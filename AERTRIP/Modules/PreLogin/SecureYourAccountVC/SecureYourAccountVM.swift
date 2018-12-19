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
    
    var delegate: SecureYourAccountVMDelegate?
    var isPasswordType: SecureAccount = .setPassword
    var password = ""
    var isFirstTime = true
}

//MARK:- Extension Webservices
//MARK:-
extension SecureYourAccountVM {
    
    func webserviceForUpdatePassword() {
        
        var params = JSONDictionary()
        
        params[APIKeys.password.rawValue]  = self.password
        
        self.delegate?.willCallApi()
        APICaller.shared.callUpdatePasswordAPI(params: params, loader: true, completionBlock: {(success, data, errors) in
            
            if success {
                self.delegate?.getSuccess()
            }
            else {
                self.delegate?.getFail(errors: errors)
            }
        })
        
    }
}
