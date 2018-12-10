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
    var isValidateData: Bool {
        
        if self.email.isEmpty {
            AppGlobals.shared.showError(message: LocalizedString.Enter_email_address.localized)
            return false
        } else if self.email.checkInvalidity(.Email) {
            AppGlobals.shared.showError(message: LocalizedString.Enter_valid_email_address.localized)
            return false
        } else if self.password.isEmpty {
            AppGlobals.shared.showError(message: LocalizedString.Enter_password.localized)
            return false
        } else if self.password.checkInvalidity(.Password) {
            AppGlobals.shared.showError(message: LocalizedString.Enter_valid_Password.localized)
            return false
        }
        return true
    }
    
    func webserviceForLogin() {
        
        var params = JSONDictionary()
        
        params[APIKeys.loginid.rawValue]     = email
        params[APIKeys.password.rawValue]    = password
        params[APIKeys.isGuestUser.rawValue]  = false
        
        APICaller.shared.callLoginAPI(params: params, loader: true, completionBlock: {(success, data) in
            
            printDebug(data)
        })
        
    }
}

