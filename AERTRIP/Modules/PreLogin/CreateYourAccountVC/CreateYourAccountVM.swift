//
//  CreateYourAccountVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 05/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

protocol CreateYourAccountVMDelegate: class {
    func willLogin()
    func didLoginSuccess(email: String)
    func didLoginFail(errors: ErrorCodes)
}

class CreateYourAccountVM {
    
    weak var delegate: CreateYourAccountVMDelegate?
    var email = ""
    var isEnableRegisterButton: Bool {
       
        if self.email.isEmpty {
            return false
        } else if self.email.checkInvalidity(.Email) {
            return false
        }
        return true
    }
    
    func isValidEmail(vc: UIViewController) -> Bool {
        
        if self.email.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.Enter_email_address.localized, vc: vc)
            return false
        } else if self.email.checkInvalidity(.Email) {
            AppToast.default.showToastMessage(message: LocalizedString.Enter_valid_email_address.localized, vc: vc)
            return false
        }
        return true
    }
}

//MARK:- Extension Webservices
//MARK:-
extension CreateYourAccountVM {
    
    func webserviceForCreateAccount() {
        
        var params = JSONDictionary()
        
        params[APIKeys.email.rawValue]  = self.email
        
        self.delegate?.willLogin()
        APICaller.shared.callRegisterNewUserAPI(params: params, loader: true, completionBlock: {(success, email, errors) in
            
            if success {
                self.delegate?.didLoginSuccess(email: email)
            }
            else {
                self.delegate?.didLoginFail(errors: errors)
            }
        })
        
    }
}
