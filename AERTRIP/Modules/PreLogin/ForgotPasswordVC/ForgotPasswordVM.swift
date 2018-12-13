//
//  ForgotPasswordVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 07/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordVM  {
    
    var email = ""
    var isValidateForContinueButtonSelection: Bool {
        
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
extension ForgotPasswordVM {
    
    func webserviceForForgotPassword(_ sender: ATButton) {
        
        var params = JSONDictionary()
        
        params[APIKeys.email.rawValue]  = self.email
        
        APICaller.shared.callForgotPasswordAPI(params: params, loader: true, completionBlock: {(success, data) in
            
            sender.isLoading = false
            printDebug(data)
//            AppFlowManager.default.moveToRegistrationSuccefullyVC(email: self.email)
        })
        
    }
}
