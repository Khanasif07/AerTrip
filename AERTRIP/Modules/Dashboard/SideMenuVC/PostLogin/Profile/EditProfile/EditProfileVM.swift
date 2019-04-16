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
    func willCallDeleteTravellerAPI()
    func deleteTravellerAPISuccess()
    func deleteTravellerAPIFailure()
}

class EditProfileVM {
    
    enum UsingFor {
        case travellerList
        case addNewTravellerList
        case viewProfile
    }
    weak var delegate: EditProfileVMDelegate?
    
    var profilePicture = ""
    var salutation = ""
    var firstName = ""
    var lastName = ""
    var label = "me"
    var email: [Email] = []
    var mobile: [Mobile] = []
    var social: [Social] = []
    var addresses: [Address] = []
    var dob = ""
    var doa = ""
    var notes = ""
    var passportNumber = ""
    var passportCountryCode = ""
    var passportCountryName = ""
    var passportIssueDate = ""
    var passportExpiryDate = ""
    var seat = ""
    var meal = ""
    var frequentFlyer: [FrequentFlyer] = []
    var filePath: String = ""
    var imageSource = ""
    var defaultAirlines: [FlyerModel] = []
    
    // drop down keys
    var emailTypes: [String] = []
    var mobileTypes: [String] = []
    var addressTypes: [String] = []
    var salutationTypes: [String] = ["Mrs", "Mr", "Mast", "Miss", "Ms"]
    var socialTypes: [String] = []
    var travelData: TravelDetailModel? {
        didSet {
            self.firstName = travelData?.firstName ?? ""
            self.lastName = travelData?.lastName ?? ""
        }
    }
    
    // preferences
    var seatPreferences = [String: String]()
    var mealPreferences = [String: String]()
    
    var countries = [String: String]()
    var currentlyUsinfFor: UsingFor = .viewProfile
    var paxId: String {
        return self.travelData?.id ?? ""
    }
    
    func isValidateData(vc: UIViewController) -> Bool {
        var flag = true
        
        if self.salutation == LocalizedString.Title.rawValue {
            AppToast.default.showToastMessage(message: LocalizedString.PleaseSelectSalutation.localized)
            flag = false
        } else if self.firstName.removeAllWhiteSpacesAndNewLines.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterFirstName.localized)
            flag = false
        } else if self.lastName.removeAllWhiteSpacesAndNewLines.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterLastName.localized)
            flag = false
        } else if !self.passportIssueDate.removeAllWhiteSpacesAndNewLines.isEmpty || !self.passportExpiryDate.removeAllWhiteSpacesAndNewLines.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = Date()
            if let currentDate = formatter.date(from: formatter.string(from: date)), let passportIssueDate = formatter.date(from: self.passportIssueDate), let passportExpiryDate = formatter.date(from: self.passportExpiryDate) {
                if passportIssueDate.compare(currentDate) == .orderedDescending {
                    AppToast.default.showToastMessage(message: LocalizedString.PassportIssueDateIsIncorrect.localized)
                    flag = false
                } else if passportExpiryDate.compare(currentDate) == .orderedAscending {
                    AppToast.default.showToastMessage(message: LocalizedString.PassportExpiryDateIsIncorrect.localized)
                    flag = false
                } else if passportIssueDate.compare(passportExpiryDate) == .orderedDescending {
                    AppToast.default.showToastMessage(message: LocalizedString.PassportIssueDateIsIncorrect.localized)
                    flag = false
                }
            }
            
        }
        
        if !self.dob.removeAllWhiteSpacesAndNewLines.isEmpty || !self.doa.removeAllWhiteSpacesAndNewLines.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = Date()
            if let currentDate = formatter.date(from: formatter.string(from: date)), let dateOfBirth = formatter.date(from: self.dob), let dateOfAnniversary = formatter.date(from: self.doa) {
                if dateOfBirth.compare(currentDate) == .orderedDescending {
                    AppToast.default.showToastMessage(message: LocalizedString.DateOfBirthIsIncorrect.localized)
                    flag = false
                } else if dateOfAnniversary.compare(currentDate) == .orderedDescending {
                    AppToast.default.showToastMessage(message: LocalizedString.DateOfAnniversaryIsIncorrect.localized)
                    flag = false
                }
            }
            
        }
        
        if !self.email.isEmpty {
//            for (index, _) in self.email.enumerated() {
//                if index > 0 {
//                    if self.email[index - 1].value == self.email[index].value {
//                        AppToast.default.showToastMessage(message: "All email should be unique")
//                        flag = false
//                    }
//                }
//            }
        }
        
        if !self.mobile.isEmpty {
//            var isValid = true
//            for (index, _) in self.mobile.enumerated() {
//                isValid = self.mobile[index].isValide
//                if index > 0 {
//                    if self.mobile[index - 1].value == self.mobile[index].value && self.mobile[index - 1].isd == self.mobile[index].isd {
//                        AppToast.default.showToastMessage(message: "All mobile should be unique")
//                        flag = false
//                    }
//                }
//            }
            
//            if !isValid {
//                AppToast.default.showToastMessage(message: "Please enter all valid contact numbers.")
//                flag = false
//            }
        }
        if !self.frequentFlyer.isEmpty {
            for (index, _) in self.frequentFlyer.enumerated() {
//                if index > 0 {
//                    if self.frequentFlyer[index - 1].airlineName == self.frequentFlyer[index].airlineName {
//                        AppToast.default.showToastMessage(message: "All frequent flyer should be unique")
//                        flag = false
//                    }
//                }
                if !self.frequentFlyer[index].airlineName.removeAllWhiteSpacesAndNewLines.isEmpty, self.frequentFlyer[index].airlineName != LocalizedString.SelectAirline.localized, self.frequentFlyer[index].number.removeAllWhiteSpacesAndNewLines.isEmpty {
                    AppToast.default.showToastMessage(message: "Please enter the airline number for all frequent flyer.")
                    flag = false
                }
                else if (self.frequentFlyer[index].airlineName.removeAllWhiteSpacesAndNewLines.isEmpty || self.frequentFlyer[index].airlineName == LocalizedString.SelectAirline.localized), !self.frequentFlyer[index].number.removeAllWhiteSpacesAndNewLines.isEmpty {
                    AppToast.default.showToastMessage(message: "Please select the airline for all frequent flyer.")
                    flag = false
                }
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
        var _email = self.email
        let _mobile = self.mobile
        if let email = _email.first, email.label.lowercased() == LocalizedString.Default.localized.lowercased() {
            _email.removeFirst()
        }
        params[APIKeys.salutation.rawValue] = salutation
        params[APIKeys.firstName.rawValue] = firstName
        params[APIKeys.lastName.rawValue] = lastName
        params[APIKeys.dob.rawValue] = dob
        params[APIKeys.doa.rawValue] = doa
        params[APIKeys.passportNumber.rawValue] = passportNumber
        params[APIKeys.passportCountryName.rawValue] = passportCountryName
        params[APIKeys.passportCountry.rawValue] = passportCountryCode
        params[APIKeys.passportIssueDate.rawValue] = passportIssueDate
        params[APIKeys.passportExpiryDate.rawValue] = passportExpiryDate
        params[APIKeys.label.rawValue] = self.label
        
        if self.currentlyUsinfFor == .addNewTravellerList {
            params[APIKeys.id.rawValue] = ""
        } else {
            params[APIKeys.id.rawValue] = self.paxId
        }
        
        for (idx, emailObj) in _email.enumerated() {
            for key in Array(emailObj.jsonDict.keys) {
                params["contact[email][\(idx)][\(key)]"] = emailObj.jsonDict[key]
            }
        }
        
        for (idx, mobileObj) in _mobile.enumerated() {
            for key in Array(mobileObj.jsonDict.keys) {
                params["contact[mobile][\(idx)][\(key)]"] = mobileObj.jsonDict[key]
            }
        }
        
        for (idx, socialObj) in self.social.enumerated() {
            for key in Array(socialObj.jsonDict.keys) {
                params["contact[social][\(idx)][\(key)]"] = socialObj.jsonDict[key]
            }
        }
        
        for (idx, addressDictArr) in self.addresses.enumerated() {
            for key in Array(addressDictArr.jsonDict.keys) {
                params["address[\(idx)][\(key)]"] = addressDictArr.jsonDict[key]
            }
        }
        
        let finalFF = self.frequentFlyer.filter { (ff) -> Bool in
            !ff.airlineName.isEmpty && ff.airlineName != LocalizedString.SelectAirline.localized && !ff.number.isEmpty
        }
        for (idx, frequentFlyerObj) in finalFF.enumerated() {
            for key in Array(frequentFlyerObj.jsonDict.keys) {
                params["ff[\(idx)][\(key)]"] = frequentFlyerObj.jsonDict[key]
            }
        }
        
        if !seat.isEmpty, seat != LocalizedString.SelectSeatPreference.localized {
            params[APIKeys.seatPreference.rawValue] = seat
        }

        if !meal.isEmpty, meal != LocalizedString.SelectMealPreference.localized {
            params[APIKeys.mealPreference.rawValue] = meal
        }
        params[APIKeys.notes.rawValue] = notes
        params[APIKeys.imageSource.rawValue] = imageSource
        
        if self.filePath.isEmpty {
            params[APIKeys.profileImage.rawValue] = self.profilePicture
        } else {
            params[APIKeys.profileImage.rawValue] = ""
             params[APIKeys.imageSource.rawValue] = "aertrip"
        }
        
        if self.profilePicture.contains("https://") {
            params[APIKeys.profileImage.rawValue] = self.profilePicture
            params[APIKeys.imageSource.rawValue] = "aertrip"
        }
        
        self.delegate?.willApiCall()
        APICaller.shared.callSaveProfileAPI(params: params, filePath: self.filePath, loader: true, completionBlock: { success, errors in
            
            if success {
                self.delegate?.getSuccess()
            } else {
                self.delegate?.getFail(errors: errors)
            }
        })
    }
    
    func callDeleteTravellerAPI() {
        var params = JSONDictionary()
        
        params["pax_ids"] = self.paxId
        delegate?.willCallDeleteTravellerAPI()
        APICaller.shared.callDeleteTravellerAPI(params: params) { [weak self] success, _ in
            if success {
                self?.delegate?.deleteTravellerAPISuccess()
            } else {
                self?.delegate?.deleteTravellerAPIFailure()
            }
        }
    }
}
