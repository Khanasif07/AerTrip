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
    
    var profilePicture = ""
    var salutation = ""
    var firstName = ""
    var lastName = ""
    var emailDefault = ""
    var email: [Email] = []
    var mobile: [Mobile] = []
    var social: [Social] = []
    var addresses: [Address] = []
    var dob = ""
    var doa = ""
    var notes = ""
    var passportNumber = ""
    var passportCountry = ""
    var passportCountryName = ""
    var passportIssueDate = ""
    var passportExpiryDate = ""
    var seat = ""
    var meal = ""
    var frequentFlyer: [FrequentFlyer] = []
    var filePath: String = ""
    var imageSource = ""
    
    func isValidateData(vc: UIViewController) -> Bool {
        if self.salutation == LocalizedString.Title.rawValue {
            AppToast.default.showToastMessage(message: LocalizedString.PleaseSelectSalutation.localized, vc: vc)
            return false
        } else if self.firstName.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterFirstName.localized, vc: vc)
            return false
        } else if self.lastName.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterLastName.localized, vc: vc)
            return false
        } else if self.email.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.Enter_email_address.localized, vc: vc)
            return false
            
        } else if self.email.count > 0 {
            for (index, _) in self.email.enumerated() {
                if index > 0 {
                    if self.email[index - 1].value == self.email[index].value {
                        AppToast.default.showToastMessage(message: "All email should be unique", vc: vc)
                        return false
                    }
                }
            }
        } else if self.mobile.count > 0 {
            for (index, _) in self.mobile.enumerated() {
                if index > 0 {
                    if self.mobile[index - 1].value == self.mobile[index].value {
                        AppToast.default.showToastMessage(message: "All mobile should be unique", vc: vc)
                        return false
                    }
                }
            }
            return true
        }
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
        params[APIKeys.dob.rawValue] = dob
        params[APIKeys.doa.rawValue] = doa
        params[APIKeys.passportNumber.rawValue] = passportNumber
        params[APIKeys.passportCountryName.rawValue] = passportCountryName
        params[APIKeys.passportCountry.rawValue] = passportCountry
        params[APIKeys.passportIssueDate.rawValue] = passportIssueDate
        params[APIKeys.passportExpiryDate.rawValue] = passportExpiryDate
        
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
        
        var addressDictArr = [String:Any]()
        for (idx, addressObj) in self.addresses.enumerated() {
            addressDictArr["\(idx)"] = addressObj.jsonDict
        }
        
        var frequentFlyerDictArr = [String:Any]()
        for (idx,frequentFlyerObj) in self.frequentFlyer.enumerated(){
            frequentFlyerDictArr["\(idx)"] = frequentFlyerObj.jsonDict
        }
        
        params[APIKeys.id.rawValue] = UserInfo.loggedInUser?.userId
        
        let contact: [String: Any] = ["email": emailDictArr, "mobile": mobileDictArr, "social": socialDictArr]
        params[APIKeys.contact.rawValue] = contact // AppGlobals.shared.json(from: contact)
        params[APIKeys.address.rawValue] = addressDictArr
        params[APIKeys.ff.rawValue] = frequentFlyerDictArr
        
        params[APIKeys.seatPreference.rawValue] = seat
        params[APIKeys.mealPreference.rawValue] = meal
        
        if self.profilePicture.contains("https://") {
            params[APIKeys.profileImage.rawValue] = self.profilePicture
        }
        
        params[APIKeys.imageSource.rawValue] = imageSource
        
        self.delegate?.willApiCall()
        APICaller.shared.callSaveProfileAPI(params: params, filePath: filePath, loader: true, completionBlock: { success, errors in
            
            if success {
                self.delegate?.getSuccess()
            } else {
                self.delegate?.getFail(errors: errors)
            }
        })
    }
}
