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
    var isSavedButtonTapped = false
    
    
    func isValidateData(vc: UIViewController) -> Bool {
        var flag = true
        
        if self.firstName.removeAllWhiteSpacesAndNewLines.isEmpty {
            self.logEventsForFirebase(with: .PressCTAWithoutEnteringFirstName)
            AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterFirstName.localized)
            flag = false
        }
        else if self.lastName.removeAllWhiteSpacesAndNewLines.isEmpty {
            self.logEventsForFirebase(with: .PressCTAWithoutEnteringLastName)
                AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterLastName.localized)
                flag = false
        }
        else if self.salutation.isEmpty {
            self.logEventsForFirebase(with: .PressCTAwithoutSelectingGender)
            AppToast.default.showToastMessage(message: LocalizedString.PleaseSelectSalutation.localized)
            flag = false
        }
        else if !(self.email.first?.value.removeAllWhiteSpacesAndNewLines.isEmpty ?? true) {
            let emailValArr = self.email.map { $0.value }
            let emailValSet = Set(emailValArr)
            self.checkEmailDuplicacy()
            if emailValArr.count != emailValSet.count {
                AppToast.default.showToastMessage(message: LocalizedString.Email_ID_already_exists.localized)
                flag = false
            }
            for email in self.email {
                if email.value.isEmpty {
                    continue
                }
                if !email.value.checkValidity(.Email) {
                    AppToast.default.showToastMessage(message: LocalizedString.Enter_valid_email_address.localized)
                    self.logEventsForFirebase(with: .EnterIncorrectEmail)
                    flag = false
                    break
                }
            }
        }else if !self.passportIssueDate.removeAllWhiteSpacesAndNewLines.isEmpty || !self.passportExpiryDate.removeAllWhiteSpacesAndNewLines.isEmpty {
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
        
        if !self.mobile.isEmpty {
//            var isValid = true
            
            let mobileValArr = self.mobile.map { $0.valueWithISD }
            let mobileValSet = Set(mobileValArr)
            self.checkMobileDuplicacy()
            if mobileValArr.count != mobileValSet.count {
                AppToast.default.showToastMessage(message: LocalizedString.Phone_number_already_exists.localized)
                flag = false
            }
            
            for (_, mob) in self.mobile.enumerated() {
                
                if mob.value.count < mob.minValidation {
                    if mob.isd == "+91" {
                        AppToast.default.showToastMessage(message: LocalizedString.EnterValidMobileNumber.localized)
                        flag = false
                    } else {
                        if mob.minValidation != mob.maxValidation {
                            AppToast.default.showToastMessage(message: LocalizedString.EnterValidMobileNumber.localized)
                            flag = false
                        }
                    }
                }
                                
            }
        }
        
        if !self.social.isEmpty{
            if self.checkDuplicateSocial(){
            AppToast.default.showToastMessage(message: "Social account already exists")
              flag = false
            }
        }
        
        if !self.addresses.isEmpty{
            if self.checkDuplicateAddress(){
            AppToast.default.showToastMessage(message: "Address is already exists")
              flag = false
            }
        }
        
        if !self.frequentFlyer.isEmpty {
            let ff = self.frequentFlyer.map({"\($0.airlineCode)\($0.number)".removeAllWhitespaces}).filter{!$0.isEmpty}
            
            let ffSet = Set(ff)
            if ffSet.count != ff.count {
                AppToast.default.showToastMessage(message: LocalizedString.frequentFlyerAlreadyExists.localized)
                flag = false
            }
            
            for (index, _) in self.frequentFlyer.enumerated() {
//                if index > 0 {
//                    if self.frequentFlyer[index - 1].airlineName == self.frequentFlyer[index].airlineName {
//                        AppToast.default.showToastMessage(message: "All frequent flyer should be unique")
//                        flag = false
//                    }
//                }
                self.checkFFDuplicacy()
                if !self.frequentFlyer[index].airlineName.removeAllWhiteSpacesAndNewLines.isEmpty, self.frequentFlyer[index].airlineName != LocalizedString.SelectAirline.localized, self.frequentFlyer[index].number.removeAllWhiteSpacesAndNewLines.isEmpty {
                    AppToast.default.showToastMessage(message: LocalizedString.EnterAirlineNumberForAllFrequentFlyer.localized)
                    flag = false
                }
                else if (self.frequentFlyer[index].airlineName.removeAllWhiteSpacesAndNewLines.isEmpty || self.frequentFlyer[index].airlineName == LocalizedString.SelectAirline.localized), !self.frequentFlyer[index].number.removeAllWhiteSpacesAndNewLines.isEmpty {
                    AppToast.default.showToastMessage(message: LocalizedString.SelectAirlineForAllFrequentFlyer.localized)
                    flag = false
                }
            }
        }
        
        return flag
    }
    
    
    func checkEmailDuplicacy(){
        var values = [String]()
        for i in 0..<self.email.count{
            self.email[i].isDuplicate = values.contains(self.email[i].value)
            values.append(self.email[i].value)
        }
    }
    
    func checkMobileDuplicacy(){
        var values = [String]()
        for i in 0..<self.mobile.count{
            self.mobile[i].isDuplicate = values.contains(self.mobile[i].valueWithISD)
            values.append(self.mobile[i].valueWithISD)
        }
    }
    
    func checkFFDuplicacy(){
        var values = [String]()
        for i in 0..<self.frequentFlyer.count{
            let val = "\(self.frequentFlyer[i].airlineCode)\(self.frequentFlyer[i].number)"
            self.frequentFlyer[i].isDuplicate = (values.contains(val) && !val.isEmpty)
            values.append(val)
        }
    }
    
    func checkDuplicateSocial()-> Bool{
        var values = [String]()
        var isDuplicate = false
        for i in 0..<self.social.count{
            let val = (self.social[i].value.isEmpty) ?  "" : "\(self.social[i].label)\(self.social[i].value)".lowercased()
            self.social[i].isDuplicate = (values.contains(val) && !val.isEmpty)
            if (values.contains(val) && !val.isEmpty){
                isDuplicate = true
            }
            values.append(val)
        }
        return isDuplicate
    }
        
    func checkDuplicateAddress()-> Bool{
        var values = [String]()
        var isDuplicate = false
        for i in 0..<self.addresses.count{
            let add = "\(self.addresses[i].line1)\(self.addresses[i].line2)\(self.addresses[i].city)\(self.addresses[i].state)\(self.addresses[i].postalCode)".removeAllWhitespaces
            let val = (add.isEmpty) ?  "" : "\(self.addresses[i].label)\(add)\(self.addresses[i].countryName)".lowercased()
            self.addresses[i].isDuplicate = (values.contains(val) && !val.isEmpty)
            if (values.contains(val) && !val.isEmpty){
                isDuplicate = true
            }
            values.append(val)
        }
        return isDuplicate
    }
    
    func webserviceForGetDropDownkeys() {
        self.delegate?.willGetDetail()
        
        APICaller.shared.callGetDropDownKeysApi { success, addresses, emails, mobiles, salutations, socials, errorCode in
            if success {
                self.delegate?.getSuccess(addresses, emails, mobiles, salutations, socials)
            } else {
                self.delegate?.getFail(errors: errorCode)
                printDebug(errorCode)
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
                printDebug(errorCode)
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
//                debugPrint(errorCode)
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
                printDebug(errorCode)
            }
        })
    }
    
    func webserviceForSaveProfile() {
        var params = JSONDictionary()
        self.logForInFoAndPersonalEvents()
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
            if mobileObj.label.localized != LocalizedString.Default.localized{
                for key in Array(mobileObj.jsonDict.keys) {
                    params["contact[mobile][\(idx)][\(key)]"] = mobileObj.jsonDict[key]
                }
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
        
        if !seat.isEmpty, seat != LocalizedString.Select.localized {
            params[APIKeys.seatPreference.rawValue] = seat
        }

        if !meal.isEmpty, meal != LocalizedString.Select.localized, let mealCode = self.mealPreferences.someKey(forValue: meal) {
            params[APIKeys.mealPreference.rawValue] = mealCode
        }
        params[APIKeys.notes.rawValue] = notes
        params[APIKeys.imageSource.rawValue] = imageSource
        
        if self.filePath.isEmpty {
            params[APIKeys.profileImage.rawValue] = self.profilePicture
            self.logEventsForFirebase(with: .EditPhoto)
        } else {
            params[APIKeys.profileImage.rawValue] = ""
        }
        
        if self.profilePicture.contains("https://") {
            params[APIKeys.profileImage.rawValue] = self.profilePicture
        }
        
        self.delegate?.willApiCall()
        APICaller.shared.callSaveProfileAPI(params: params, filePath: self.filePath, loader: false, completionBlock: { success, errors in
            
            if success {
                self.delegate?.getSuccess()
            } else {
                self.delegate?.getFail(errors: errors)
            }
        })
    }
    
    func callDeleteTravellerAPI() {
        var params = JSONDictionary()
        
        params["pax_ids[0]"] = self.paxId
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


///Logs Firebase events
extension EditProfileVM {
    
    func logForInFoAndPersonalEvents(){
        if (self.travelData?.dob.isEmpty ?? false) && (!dob.isEmpty){
            self.logEventsForFirebase(with: .EnterDOB)
        }else if (self.travelData?.dob != dob) && (dob != LocalizedString.Select.localized){
            self.logEventsForFirebase(with: .EditDOB)
        }
        if (self.travelData?.doa.isEmpty ?? false) && (!doa.isEmpty){
            self.logEventsForFirebase(with: .EnterAnniversary)
        }else if (self.travelData?.doa != doa) && (doa != LocalizedString.Select.localized){
            self.logEventsForFirebase(with: .EditAnniversary)
        }
        if (self.travelData?.notes.isEmpty ?? false) && (!notes.isEmpty){
            self.logEventsForFirebase(with: .EnterNotes)
        }else if (self.travelData?.notes != notes){
            self.logEventsForFirebase(with: .EditNotes)
        }
        if (self.travelData?.passportNumber.isEmpty ?? false) && (!passportNumber.isEmpty){
            self.logEventsForFirebase(with: .EnterPassportNumber)
        }else if (self.travelData?.passportNumber != passportNumber){
            self.logEventsForFirebase(with: .EditPassportNumber)
        }
        if (self.travelData?.passportIssueDate.isEmpty ?? false) && (!passportIssueDate.isEmpty){
            self.logEventsForFirebase(with: .EnterIssueDate)
        }else if (self.travelData?.passportIssueDate != passportIssueDate) && (passportIssueDate != LocalizedString.Select.localized){
            self.logEventsForFirebase(with: .EditIssueDate)
        }
        if (self.travelData?.passportCountry.isEmpty ?? false) && (!passportCountryCode.isEmpty){
            self.logEventsForFirebase(with: .EnterIssueCountry)
        }else if (self.travelData?.passportCountry != passportCountryCode) && (passportCountryCode != LocalizedString.Select.localized){
            self.logEventsForFirebase(with: .EditIssueCountry)
        }
        if (self.travelData?.passportExpiryDate.isEmpty ?? false) && (!passportExpiryDate.isEmpty){
            self.logEventsForFirebase(with: .EnterExpiryDate)
        }else if (self.travelData?.passportExpiryDate != passportExpiryDate) && (passportExpiryDate != LocalizedString.Select.localized){
            self.logEventsForFirebase(with: .EditExpiryDate)
        }
        
        if !meal.isEmpty, meal != LocalizedString.Select.localized, let mealCode = self.mealPreferences.someKey(forValue: meal) {
            if (self.travelData?.preferences.meal.value.isEmpty ?? true){
                self.logEventsForFirebase(with: .SetMealPreference)
            }else if self.travelData?.preferences.meal.value != mealCode{
                self.logEventsForFirebase(with: .EditMealPreference)
            }
        }
        
        if self.frequentFlyer.count > (self.travelData?.frequestFlyer.count ?? 0){
            if self.travelData?.frequestFlyer.count == 0{
                for ff in self.frequentFlyer{
                    self.logEventsForFirebase(with: .AddFF, value: ff.airlineName)
                }
            }else{
                for ff in self.frequentFlyer{
                    if self.travelData?.frequestFlyer.first(where: {$0.airlineCode == ff.airlineCode}) == nil{
                        if ff.id == 0{
                            self.logEventsForFirebase(with: .AddFF, value: ff.airlineName)
                        }else{
                            self.logEventsForFirebase(with: .EditFF)
                        }
                    }else if let _ = self.travelData?.frequestFlyer.first(where: {(($0.airlineCode == ff.airlineCode) && $0.number != ff.number)}){
                        self.logEventsForFirebase(with: .EditFF)
                    }
                    
                }
            }
        }else{
            for ff in self.frequentFlyer{
                if self.travelData?.frequestFlyer.first(where: {$0.airlineCode == ff.airlineCode}) == nil{
                    if ff.id == 0{
                        self.logEventsForFirebase(with: .AddFF, value: ff.airlineName)
                    }else{
                        self.logEventsForFirebase(with: .EditFF)
                    }
                }else if let _ = self.travelData?.frequestFlyer.first(where: {(($0.airlineCode == ff.airlineCode) && $0.number != ff.number)}){
                    self.logEventsForFirebase(with: .EditFF)
                }
                
            }
        }
        
    }
    
    
    
    func logEventsForFirebase(with event: FirebaseEventLogs.EventsTypeName, value: String? = nil){
        var type = "editMain"
        if (self.travelData?.id == UserInfo.loggedInUser?.paxId){
            type = "editMain"
        }else{
            if (self.travelData?.id.isEmpty ?? false){
                type = "add"
            }else {
                type = "edit"
            }
        }
        FirebaseEventLogs.shared.logEditMainTravellerEvents(with: event, value: value, key: type)
    }
}
