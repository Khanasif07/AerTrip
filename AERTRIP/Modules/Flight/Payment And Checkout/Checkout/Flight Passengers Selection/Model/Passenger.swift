//
//  Passenger.swift
//  Aertrip
//
//  Created by Apple  on 07.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation

enum PassengerGender{
    case male,female
}

enum PassengerType:String{
    case adult, child, infant
}

struct Passenger {
    var title = ""
    var fName = ""
    var lName = ""
    var gender:PassengerGender?
    var dob:Date?
    var dobString = ""
    var nationality = ""
    var passportNumber = ""
    var passportExpiryDate: Date?
    var passengerType:PassengerType = .adult
    var isMoreOptionTapped = false
    var mealPreference = [MealPreference]()
    var frequentFlyer = [FrequentFlyer]()
    var age:Int{
        guard let dob = self.dob else {
            return 0
        }
        let dateComponent = Calendar.current.dateComponents([.year], from: dob, to: Date())
        return dateComponent.year ?? 0
    }
}

struct  MealPreference {
    var journeyTitle = ""
    var mealPreference = ""
    var preferenceCode = ""
    var airlineLogo = ""
    var preference:[String:String] = [:]
}

