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
    func getSalutationResponse(salutations: [String])
}

class CreateProfileVM {
    
    weak var delegate: CreateProfileVMDelegate?
    var salutation = [String]()
    var userData: UserInfo!
    var isFirstTime = true
    var isValidateForButtonEnable : Bool {
        
        if self.userData.salutation.isEmpty {
            return false
        } else if self.userData.firstName.isEmpty {
            return false
        } else if self.userData.lastName.isEmpty {
            return false
        } else if (self.userData.address?.country ?? "").isEmpty {
            return false
        } else if self.userData.mobile.isEmpty {
            return false
        } else if self.userData.mobile.count < self.userData.minContactLimit {
            return false
        }
        return true
    }
    
    var isValidateData : Bool {
        
        if self.userData.salutation.isEmpty {
            
            AppToast.default.showToastMessage(message: LocalizedString.PleaseSelectSalutation.localized)
            return false
        } else if self.userData.firstName.isEmpty {
            
            AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterFirstName.localized)
            return false
        } else if self.userData.lastName.isEmpty {
            
            AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterLastName.localized)
            return false
        } else if (self.userData.address?.country ?? "").isEmpty {
            
            AppToast.default.showToastMessage(message: LocalizedString.PleaseSelectCountry.localized)
            return false
        } else if self.userData.mobile.isEmpty {
            
            AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterMobileNumber.localized)
            return false
        }
        return true
    }
    
    init() {
        self.userData = UserInfo(withData: [:], userId: "")
        self.userData.address = UserInfo.Address(dict: [:])
    }
}

//MARK:- Extension Webservices
//MARK:-
extension CreateProfileVM {
    
    func webserviceForUpdateProfile() {
        
        var params = JSONDictionary()
        
        params[APIKeys.ref.rawValue]        = self.userData.paxId
        params[APIKeys.email.rawValue]      = self.userData.email
        params[APIKeys.password.rawValue]   = self.userData.password
        params[APIKeys.firstName.rawValue]  = self.userData.firstName
        params[APIKeys.lastName.rawValue]   = self.userData.lastName
        params[APIKeys.isd.rawValue]        = self.userData.isd
        params[APIKeys.country.rawValue]    = self.userData.address?.country
        params[APIKeys.salutation.rawValue] = self.userData.salutation
         params[APIKeys.mobile.rawValue]  = self.userData.mobile
        
        self.delegate?.willApiCall()
        APICaller.shared.callUpdateUserDetailAPI(params: params,  loader: true,  completionBlock: {(success, errors) in
            
            if success {
                self.delegate?.getSuccess()
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .login)
                self.delegate?.getFail(errors: errors)
            }
        })
        
    }
    
    func webserviceForGetSalutations() {
        
        APICaller.shared.callGetSalutationsApi(completionBlock: {(success, data, errors) in
            
            if success {
                self.delegate?.getSalutationResponse(salutations: data)
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .login)
                self.delegate?.getFail(errors: errors)
            }
        })
        
    }
}
