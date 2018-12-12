//
//  ViewController.swift
//  AERTRIP
//
//  Created by Pramod Kumar on 03/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class LoginVM {

    var email    = ""
    var password = ""
    var isLoginButtonEnable: Bool {
        
        if self.email.isEmpty {
            return false
        } else if self.email.checkInvalidity(.Email) {
            return false
        } else if self.password.isEmpty {
            return false
        } else if self.password.checkInvalidity(.Password) {
           return false
        }
        return true
    }
    
    func isValidateData(vc: UIViewController) -> Bool {
        
        if self.email.isEmpty {
            
            AppToast.showToastMessage(message: LocalizedString.Enter_email_address.localized, vc: vc)
            return false
            
        } else if self.email.checkInvalidity(.Email) {
            
            AppToast.showToastMessage(message: LocalizedString.Enter_valid_email_address.localized, vc: vc)
            return false
            
        } else if self.password.isEmpty {
            
            AppToast.showToastMessage(message: LocalizedString.Enter_password.localized, vc: vc)
            return false
            
        } else if self.password.checkInvalidity(.Password) {
            
            AppToast.showToastMessage(message: LocalizedString.Enter_valid_Password.localized, vc: vc)
            return false
        }
        return true
    }
    
    func webserviceForLogin(_ sender: ATButton) {
        
        var params = JSONDictionary()
        
        params[APIKeys.loginid.rawValue]     = email
        params[APIKeys.password.rawValue]    = password
        params[APIKeys.isGuestUser.rawValue]  = false
        
        APICaller.shared.callLoginAPI(params: params, loader: true, completionBlock: {(success, data) in
            
            sender.isLoading = false
            printDebug(data)
        })
        
    }
}

