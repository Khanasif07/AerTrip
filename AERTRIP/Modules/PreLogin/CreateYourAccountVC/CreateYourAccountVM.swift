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
            return false
        } else if self.email.checkInvalidity(.Email) {
            return false
        } else {
            return true
        }
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
