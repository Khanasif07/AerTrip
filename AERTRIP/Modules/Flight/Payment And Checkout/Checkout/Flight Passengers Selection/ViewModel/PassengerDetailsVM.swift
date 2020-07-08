
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
    var currentIndex = 0{
        didSet{
            self.indexPath = IndexPath(row: 0, section: currentIndex)
        }
    }
    
    func updatePassengerInfoWith(_ object:ATContact, at index:Int){
        
        let numberInRoom = GuestDetailsVM.shared.guests[0][index].numberInRoom
        let type = GuestDetailsVM.shared.guests[0][index].passengerType
        let meal = GuestDetailsVM.shared.guests[0][index].mealPreference
        let ff = GuestDetailsVM.shared.guests[0][index].frequentFlyer
        let code = object.countryCode
        GuestDetailsVM.shared.guests[0][index] = object
        if let country = GuestDetailsVM.shared.countries?[code]{
            GuestDetailsVM.shared.guests[0][index].nationality = country
        }else if let countryCode = GuestDetailsVM.shared.countries?.someKey(forValue: code){
            GuestDetailsVM.shared.guests[0][index].nationality = code
            GuestDetailsVM.shared.guests[0][index].countryCode = countryCode
        }else{
            GuestDetailsVM.shared.guests[0][index].nationality = ""
            GuestDetailsVM.shared.guests[0][index].countryCode = ""
        }
        GuestDetailsVM.shared.guests[0][index].passengerType = type
        GuestDetailsVM.shared.guests[0][index].numberInRoom = numberInRoom
        GuestDetailsVM.shared.guests[0][index].mealPreference = meal
        GuestDetailsVM.shared.guests[0][index].frequentFlyer = ff
        
    }
    
    
}
