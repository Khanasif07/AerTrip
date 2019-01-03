//
//  EditProfileVM.swift
//  AERTRIP
//
//  Created by apple on 24/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

protocol EditProfileVMDelegate: class {
    func willGetDetail()
    func getSuccess(_ addresses: [String], _ emails: [String], _ mobiles: [String], _ salutations: [String], _ socials: [String])
    func getPreferenceListSuccess(_ seatPreferences: [String: String], _ mealPreferences: [String: String])
    func getCountryListSuccess(_ countryList: [String: String])
    func getFail(errors: ErrorCodes)
    func getSuccess()
    func getDefaultAirlineSuccess(_ data: [FlyerModel])
    func willApiCall()
}

class EditProfileVM {
    weak var delegate: EditProfileVMDelegate?
    
    var profilePicutre = ""
    var salutation = ""
    var firstName = ""
    var lastName = ""
    var emailDefault = ""
    var email: [Email] = []
    var mobile: [Mobile] = []
    var social: [Social] = []
    var address: [Address] = []
    var dob = ""
    var doa = ""
    var notes = ""
    var passportNumber = ""
    var passportCountry = ""
    var passportIssueDate = ""
    var passportExpiryDate = ""
    var seat: Seat?
    var meal: Meal?
    
    func isValidateData(vc: UIViewController) -> Bool {
//        if self.email.isEmpty {
//
//            AppToast.default.showToastMessage(message: LocalizedString.Enter_email_address.localized, vc: vc)
//            return false
//
//        } else if self.email.checkInvalidity(.Email) {
//
//            AppToast.default.showToastMessage(message: LocalizedString.Enter_valid_email_address.localized, vc: vc)
//            return false
//
//        } else if self.password.isEmpty {
//
//            AppToast.default.showToastMessage(message: LocalizedString.Enter_password.localized, vc: vc)
//            return false
//
//        } else if self.password.checkInvalidity(.Password) {
//
//            AppToast.default.showToastMessage(message: LocalizedString.Enter_valid_Password.localized, vc: vc)
//            return false
//        }
        return true
    }
    
    func webserviceForGetDropDownkeys() {
        self.delegate?.willGetDetail()
        
        APICaller.shared.callGetDropDownKeysApi { success, addresses, emails, mobiles, salutations, socials, errorCode in
            if success {
                self.delegate?.getSuccess(addresses, emails, mobiles, salutations, socials)
            } else {
                self.delegate?.getFail(errors: errorCode)
                debugPrint(errorCode)
            }
        }
    }
    
    func webserviceForGetPreferenceList() {
        self.delegate?.willGetDetail()
        
        APICaller.shared.callGetPreferencesListApi { success, seatPreferences, mealPreferences, errorCode in
            if success {
                self.delegate?.getPreferenceListSuccess(seatPreferences, mealPreferences)
            } else {
                self.delegate?.getFail(errors: errorCode)
                debugPrint(errorCode)
            }
        }
    }
    
    func webserviceForGetCountryList() {
        self.delegate?.willGetDetail()
        
        APICaller.shared.callGetCountriesListApi { success, countries, errorCode in
            if success {
                self.delegate?.getCountryListSuccess(countries)
                
            } else {
                self.delegate?.getFail(errors: errorCode)
                debugPrint(errorCode)
            }
        }
    }
    
    func webserviceForGetDefaultAirlines() {
        self.delegate?.willGetDetail()
        
        APICaller.shared.getDefaultAirlines(completionBlock: { success, data, errorCode in
            
            if success {
                self.delegate?.getDefaultAirlineSuccess(data)
            } else {
                self.delegate?.getFail(errors: errorCode)
                debugPrint(errorCode)
            }
        })
    }
    
    func webserviceForSaveProfile() {
        
        var params = JSONDictionary()
        
        params[APIKeys.salutation.rawValue] = salutation
        params[APIKeys.firstName.rawValue] = firstName
        params[APIKeys.lastName.rawValue] = lastName
        params[APIKeys.id.rawValue] = AppUserDefaults.value(forKey: .userId)

        
        var emailDictArr = [String:Any]()
        for (idx, emailObj) in self.email.enumerated() {
            emailDictArr["\(idx)"] = emailObj.jsonDict
        }
        
        var mobileDictArr = [String:Any]()
        for (idx, mobileObj) in self.mobile.enumerated() {
            mobileDictArr["\(idx)"] = mobileObj.jsonDict
        }
        
        var socialDictArr = [String:Any]()
        for (idx, socialObj) in self.social.enumerated() {
            socialDictArr["\(idx)"] = socialObj.jsonDict
        }
        
        let contact: [String: Any] = ["email": emailDictArr, "mobile": mobileDictArr, "social": socialDictArr]
        
        
        
//        let contact: [String: Any] = ["email": self.email, "mobile": self.mobile, "social": self.social]
        

        params[APIKeys.contact.rawValue] = contact
        
        self.delegate?.willApiCall()
        APICaller.shared.callSaveProfileAPI(params: params, loader: true, completionBlock: { success, errors in
            
            if success {
                self.delegate?.getSuccess()
            } else {
                self.delegate?.getFail(errors: errors)
            }
        })
    }
}
