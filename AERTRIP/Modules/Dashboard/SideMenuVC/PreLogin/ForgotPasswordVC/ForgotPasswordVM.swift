//
//  ForgotPasswordVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 07/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

protocol ForgotPasswordVMDelegate: class {
    func willLogin()
    func didLoginSuccess(email: String)
    func didLoginFail(errors: ErrorCodes)
}

class ForgotPasswordVM  {
    
    weak var delegate: ForgotPasswordVMDelegate?
    var email = ""
    var isFirstTime = true
    var isValidateForContinueButtonSelection: Bool {
        
        if self.email.isEmpty {
            return false
        }
        else if self.email.checkInvalidity(.Email) {
            return false
        }
        return true
    }
    
    func isValidEmail(vc: UIViewController) -> Bool {
        
        if self.email.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.Enter_email_address.localized)
            return false
        } else if self.email.checkInvalidity(.Email) {
            AppToast.default.showToastMessage(message: LocalizedString.Enter_valid_email_address.localized)
            return false
        }
        return true
    }
}

//MARK:- Extension Webservices
//MARK:-
extension ForgotPasswordVM {
    
    func webserviceForForgotPassword(_ sender: ATButton) {
        
        var params = JSONDictionary()
        
        params[APIKeys.email.rawValue]  = self.email
        
        self.delegate?.willLogin()
        APICaller.shared.callForgotPasswordAPI(params: params, loader: true, completionBlock: {(success, email, errors) in
            
            if success {
                self.delegate?.didLoginSuccess(email: email)
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .login)
                self.delegate?.didLoginFail(errors: errors)
            }
        })
        
    }
}
