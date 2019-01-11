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
    var label = "me"
    var defaultAirlines: [FlyerModel] = []
    
    // drop down keys
    var emailTypes: [String] = []
    var mobileTypes: [String] = []
    var addressTypes: [String] = []
    var salutationTypes: [String] = []
    var socialTypes: [String] = []
    
    // preferences
    var seatPreferences = [String: String]()
    var mealPreferences = [String: String]()
    
    var countries = [String: String]()
    var isFromTravellerList: Bool = false
    
    func isValidateData(vc: UIViewController) -> Bool {
        var flag = true
        
        if self.salutation == LocalizedString.Title.rawValue {
            AppToast.default.showToastMessage(message: LocalizedString.PleaseSelectSalutation.localized, vc: vc)
            flag = false
        } else if self.firstName.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterFirstName.localized, vc: vc)
            flag = false
        } else if self.lastName.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterLastName.localized, vc: vc)
            flag = false
        } else if !self.passportIssueDate.isEmpty || !self.passportExpiryDate.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = Date()
            if let currentDate = formatter.date(from: formatter.string(from: date)), let passportIssueDate = formatter.date(from: self.passportIssueDate), let passportExpiryDate = formatter.date(from: self.passportExpiryDate) {
                if passportIssueDate.compare(currentDate) == .orderedDescending {
                    AppToast.default.showToastMessage(message: LocalizedString.PassportIssueDateIsIncorrect.localized, vc: vc)
                    flag = false
                } else if passportExpiryDate.compare(currentDate) == .orderedAscending {
                    AppToast.default.showToastMessage(message: LocalizedString.PassportExpiryDateIsIncorrect.localized, vc: vc)
                    flag = false
                } else if passportIssueDate.compare(passportExpiryDate) == .orderedDescending {
                    AppToast.default.showToastMessage(message: LocalizedString.PassportIssueDateIsIncorrect.localized, vc: vc)
                    flag = false
                }
            }
            
        } else if !self.dob.isEmpty || !self.doa.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = Date()
            if let currentDate = formatter.date(from: formatter.string(from: date)), let dateOfBirth = formatter.date(from: self.dob), let dateOfAnniversary = formatter.date(from: self.doa) {
                if dateOfBirth.compare(currentDate) == .orderedDescending {
                    AppToast.default.showToastMessage(message: LocalizedString.DateOfBirthIsIncorrect.localized, vc: vc)
                    flag = false
                } else if dateOfAnniversary.compare(currentDate) == .orderedDescending {
                    AppToast.default.showToastMessage(message: LocalizedString.DateOfAnniversaryIsIncorrect.localized, vc: vc)
                    flag = false
                }
            }
            
        } else if !self.email.isEmpty {
            for (index, _) in self.email.enumerated() {
                if index > 0 {
                    if self.email[index - 1].value == self.email[index].value {
                        AppToast.default.showToastMessage(message: "All email should be unique", vc: vc)
                        flag = false
                    }
                }
            }
        } else if !self.mobile.isEmpty {
            var isValid = true
            for (index, _) in self.mobile.enumerated() {
                isValid = self.mobile[index].isValide
                if index > 0 {
                    if self.mobile[index - 1].value == self.mobile[index].value {
                        AppToast.default.showToastMessage(message: "All mobile should be unique", vc: vc)
                        flag = false
                    }
                }
            }
            
            if !isValid {
                AppToast.default.showToastMessage(message: "Please enter all valid contact numbers.", vc: vc)
                flag = false
            }
        }
        
        return flag
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
        
        // remove default email and mobile
        if let email = email.first,email.label == "Default" {
            self.email.removeFirst()
        }
        if let mobile = mobile.first,mobile.label == "Default" {
            self.mobile.removeFirst()
        }
        
        
            
        
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
        params[APIKeys.label.rawValue] = self.label
        
        var emailDictArr = [String: Any]()
        for (idx, emailObj) in self.email.enumerated() {
            emailDictArr["\(idx)"] = emailObj.jsonDict
        }
        
        var mobileDictArr = [String: Any]()
        for (idx, mobileObj) in self.mobile.enumerated() {
            mobileDictArr["\(idx)"] = mobileObj.jsonDict
        }
        
        var socialDictArr = [String: Any]()
        for (idx, socialObj) in self.social.enumerated() {
            socialDictArr["\(idx)"] = socialObj.jsonDict
        }
        
        var addressDictArr = [String: Any]()
        for (idx, addressObj) in self.addresses.enumerated() {
            addressDictArr["\(idx)"] = addressObj.jsonDict
        }
        
        var frequentFlyerDictArr = [String: Any]()
        for (idx, frequentFlyerObj) in self.frequentFlyer.enumerated() {
            frequentFlyerDictArr["\(idx)"] = frequentFlyerObj.jsonDict
        }
        
        if isFromTravellerList {
             params[APIKeys.id.rawValue] = 0
        } else {
             params[APIKeys.id.rawValue] = UserInfo.loggedInUser?.userId
        }
       
        
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
        APICaller.shared.callSaveProfileAPI(params: params, filePath: self.filePath, loader: true, completionBlock: { success, errors in
            
            if success {
                self.delegate?.getSuccess()
            } else {
                self.delegate?.getFail(errors: errors)
            }
        })
    }
}
