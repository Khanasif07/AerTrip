//
//  CreateYourAccountVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 05/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

class CreateYourAccountVM {
    
    var email = ""
    var isValidEmail: Bool {
        
        if self.email.isEmpty {
            AppGlobals.shared.showError(message: LocalizedString.Enter_email_address.localized)
            return false
        } else if self.email.checkInvalidity(.Email) {
            AppGlobals.shared.showError(message: LocalizedString.Enter_valid_email_address.localized)
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
        
        APICaller.shared.callRegisterNewUserAPI(params: params, loader: true, completionBlock: {(success, data) in
            
            printDebug(data)
            AppFlowManager.default.moveToRegistrationSuccefullyVC(email: self.email)
        })
        
    }
}
