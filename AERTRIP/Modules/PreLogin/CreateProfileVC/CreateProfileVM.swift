//
//  CreateProfileVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 07/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

protocol CreateProfileVMDelegate: class {
    func willApiCall()
    func getSuccess()
    func getFail(errors: ErrorCodes)
}

class CreateProfileVM {
    
    weak var delegate: CreateProfileVMDelegate?
    let salutation = [LocalizedString.Mr.localized, LocalizedString.Mis.localized]
    var userData   = UserModel()
    var isFirstTime = true
    
    var isValidateForButtonEnable : Bool {
        
        if self.userData.salutation.isEmpty {
            return false
        } else if self.userData.firstName.isEmpty {
            return false
        } else if self.userData.lastName.isEmpty {
            return false
        } else if self.userData.country.isEmpty {
            return false
        } else if self.userData.mobile.isEmpty {
            return false
        }
        return true
    }
    
    var isValidateData : Bool {
        
        if self.userData.salutation.isEmpty {
            
            AppGlobals.shared.showWarning(message: LocalizedString.PleaseSelectSalutation.localized)
            return false
        } else if self.userData.firstName.isEmpty {
            
            AppGlobals.shared.showWarning(message: LocalizedString.PleaseEnterFirstName.localized)
            return false
        } else if self.userData.lastName.isEmpty {
            
            AppGlobals.shared.showWarning(message: LocalizedString.PleaseEnterLastName.localized)
            return false
        } else if self.userData.country.isEmpty {
            
            AppGlobals.shared.showWarning(message: LocalizedString.PleaseSelectCountry.localized)
            return false
        } else if self.userData.mobile.isEmpty {
            
            AppGlobals.shared.showWarning(message: LocalizedString.PleaseEnterMobileNumber.localized)
            return false
        }
        return true
    }
}

//MARK:- Extension Webservices
//MARK:-
extension CreateProfileVM {
    
    func webserviceForUpdateProfile(_ sender: ATButton) {
        
        var params = JSONDictionary()
        
        params[APIKeys.ref.rawValue]        = ""
        params[APIKeys.email.rawValue]      = self.userData.email
        params[APIKeys.password.rawValue]   = self.userData.password
        params[APIKeys.firstName.rawValue]  = self.userData.firstName
        params[APIKeys.lastName.rawValue]   = self.userData.lastName
        params[APIKeys.isd.rawValue]        = self.userData.isd
        params[APIKeys.country.rawValue]    = self.userData.country
        params[APIKeys.salutation.rawValue] = self.userData.salutation
        
        self.delegate?.willApiCall()
        APICaller.shared.callUpdateUserDetailAPI(params: params, loader: true, completionBlock: {(success, data, errors) in
            
            if success {
                self.delegate?.getSuccess()
            }
            else {
                self.delegate?.getFail(errors: errors)
            }
        })
        
    }
}
