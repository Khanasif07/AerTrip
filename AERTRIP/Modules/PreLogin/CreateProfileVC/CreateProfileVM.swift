//
//  CreateProfileVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 07/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

class CreateProfileVM {
    
    let salutation = ["Mr", "Mis"]
    var userData   = UserModel()
    var isValidateData : Bool {
        
        if self.userData.salutation.isEmpty {
            
            AppGlobals.shared.showWarning(message: "Please select salutation")
            return false
        } else if self.userData.firstName.isEmpty {
            
            AppGlobals.shared.showWarning(message: "Please enter first name")
            return false
        } else if self.userData.lastName.isEmpty {
            
            AppGlobals.shared.showWarning(message: "Please enter last name")
            return false
        } else if self.userData.country.isEmpty {
            
            AppGlobals.shared.showWarning(message: "Please select country")
            return false
        } else if self.userData.mobile.isEmpty {
            
            AppGlobals.shared.showWarning(message: "please enter mobile number")
            return false
        }
        
        return true
    }
}

//MARK:- Extension Webservices
//MARK:-
extension CreateProfileVM {
    
    func webserviceForUpdateProfile() {
        
        var params = JSONDictionary()
        
        params[APIKeys.ref.rawValue]        = ""
        params[APIKeys.email.rawValue]      = self.userData.email
        params[APIKeys.password.rawValue]   = self.userData.password
        params[APIKeys.firstName.rawValue]  = self.userData.firstName
        params[APIKeys.lastName.rawValue]   = self.userData.lastName
        params[APIKeys.isd.rawValue]        = self.userData.isd
        params[APIKeys.country.rawValue]    = self.userData.country
        params[APIKeys.salutation.rawValue] = self.userData.salutation
        
        APICaller.shared.callUpdatePasswordAPI(params: params, loader: true, completionBlock: {(success, data) in
            
            printDebug(data)
            //            AppFlowManager.default.moveToRegistrationSuccefullyVC(email: self.email)
        })
        
    }
}
