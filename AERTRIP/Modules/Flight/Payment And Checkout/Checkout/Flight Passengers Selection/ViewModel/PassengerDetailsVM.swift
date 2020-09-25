
//
//  PassengerDetailsVM.swift
//  Aertrip
//
//  Created by Apple  on 07.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation

class PassengerDetailsVM {
    var passengerList:[ATContact]{
        GuestDetailsVM.shared.guests.first ?? []
    }
    var journeyType:JourneyType = .domestic
    var indexPath = IndexPath()
    var editinIndexPath:IndexPath?
    var searchText = ""
    var keyboardHeight: CGFloat = 0.0
    var isAllPaxInfoRequired = false
    var lastJourneyDate = Date()
    var journeyEndDate = Date()
    var currentIndex = 0{
        didSet{
            self.indexPath = IndexPath(row: 0, section: currentIndex)
        }
    }
    var isKeyboardVisible = false
    
    func updatePassengerInfoWith(_ object:ATContact, at index:Int){
        
        let numberInRoom = GuestDetailsVM.shared.guests[0][index].numberInRoom
        let type = GuestDetailsVM.shared.guests[0][index].passengerType
        let meal = GuestDetailsVM.shared.guests[0][index].mealPreference
        let ff = GuestDetailsVM.shared.guests[0][index].frequentFlyer
        let code = object.countryCode
        GuestDetailsVM.shared.guests[0][index] = object
        /*
        if let country = GuestDetailsVM.shared.countries?[code]{
            GuestDetailsVM.shared.guests[0][index].nationality = country
        }else if let countryCode = GuestDetailsVM.shared.countries?.someKey(forValue: code){
            GuestDetailsVM.shared.guests[0][index].nationality = code
            GuestDetailsVM.shared.guests[0][index].countryCode = countryCode
        }else{
            GuestDetailsVM.shared.guests[0][index].nationality = ""
            GuestDetailsVM.shared.guests[0][index].countryCode = ""
        }
         */
        let prevSelectedCountry = PKCountryPicker.default.getCountryData(forISOCode: code.isEmpty ? "IN" : code )
        if let country = prevSelectedCountry{
            GuestDetailsVM.shared.guests[0][index].nationality = country.countryEnglishName
            GuestDetailsVM.shared.guests[0][index].countryCode = country.ISOCode
        }
        GuestDetailsVM.shared.guests[0][index].passengerType = type
        GuestDetailsVM.shared.guests[0][index].numberInRoom = numberInRoom
        GuestDetailsVM.shared.guests[0][index].mealPreference = meal
        GuestDetailsVM.shared.guests[0][index].frequentFlyer = ff
        
    }
    
    
    
//    func validationForPassenger()->(success:Bool, msg:String){
//
//        for contact in GuestDetailsVM.shared.guests[0]{
//            if contact.firstName.removeAllWhitespaces.isEmpty{
//                return (false, "Please fill passenger first name")
//            } else if contact.firstName.count < 3 {
//                return (false, "Passenger first name should have atleast 3 character")
//            } else if !contact.firstName.isName {
//                return (false, "Passenger first name should not have any numeric or special character")
//            }else if contact.lastName.removeAllWhitespaces.isEmpty {
//                return (false, "Please fill passenger last name")
//            }else if  contact.lastName.count < 3 {
//                return (false, "Passenger first last should have atleast 3 character")
//            }else if !contact.lastName.isName {
//                return (false, "Passenger last name should not have any numeric or special character")
//            }else if contact.salutation.isEmpty{
//                return (false, "Please fill all passenger gender details")
//            }
//            if isAllPaxInfoRequired && contact.passengerType == .Adult{
//                if contact.isd.isEmpty{
//                    return (false, "Please fill the passenger contact details")
//                }else if (contact.contact.isEmpty || self.getOnlyIntiger(contact.contact).count < contact.minContactLimit || self.getOnlyIntiger(contact.contact).count > contact.maxContactLimit){
//                    return (false, "Please fill the passenger contact details")
//                }else if !(contact.emailLabel.checkValidity(.Email)){
//                    return (false, "Please fill the passenger contact details")
//                }
//            }
//            if self.journeyType == .domestic{
//                if contact.passengerType == .infant{
//                    return (!(contact.dob.isEmpty), "Please fill passenger Date of birth detail")
//                }
//            }else{
//                if contact.dob.isEmpty {
//                    return (false, "Please fill the passenger Date of birth detail")
//                }else if contact.nationality.isEmpty  {
//                    return (false, "Please fill the passenger nationality details")
//                }else if  contact.passportNumber.isEmpty || contact.passportExpiryDate.isEmpty{
//                    return (false, "Please fill all the passenger passport details")
//                }
//            }
//        }
//        return (true, "")
//    }
    
    
    func validationForPassenger()->(success:Bool, msg:String){
        
        for contact in GuestDetailsVM.shared.guests[0]{
            if !contact.firstName.removeAllWhitespaces.isEmpty{
                if contact.firstName.count < 3 {
                    return (false, "Passenger first name should have atleast 3 character")
                } else if !contact.firstName.isName {
                    return (false, "Passenger first name should not have any numeric or special character")
                }
            }else if !contact.lastName.removeAllWhitespaces.isEmpty {
                if  contact.lastName.count < 3 {
                    return (false, "Passenger first last should have atleast 3 character")
                }else if !contact.lastName.isName {
                    return (false, "Passenger last name should not have any numeric or special character")
                }
            }
            if isAllPaxInfoRequired && contact.passengerType == .Adult{
                if contact.isd.isEmpty{
                    return (false, "Please fill the passenger contact details")
                }else if ((!contact.contact.isEmpty) && self.getOnlyIntiger(contact.contact).count < contact.minContactLimit || self.getOnlyIntiger(contact.contact).count > contact.maxContactLimit){
                    return (false, "Please fill the passenger contact details")
                }else if ((!contact.emailLabel.isEmpty) && !(contact.emailLabel.checkValidity(.Email))){
                    return (false, "Please fill the passenger contact details")
                }
            }
        }
        return (true, "")
    }
    
    
    private func getOnlyIntiger(_ str: String)->String{
        let newStr = str.lowercased()
        let okayChars = Set("1234567890")
        return newStr.filter {okayChars.contains($0) }
    }
    
}
