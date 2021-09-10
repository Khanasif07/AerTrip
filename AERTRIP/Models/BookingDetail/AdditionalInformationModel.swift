//
//  AdditionalInformationModel.swift
//  AERTRIP
//
//  Created by apple on 17/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct AdditionalInformation {
    var webCheckins: [String] = []
    var directions: [Direction] = []
    var contactInfo: ContactInfo?
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["web_checkin"] as? [String] {
            webCheckins = obj
        }
        
        if let obj = json["directions"] as? [JSONDictionary] {
            directions = Direction.getModels(json: obj)
        }
        
        if let obj = json["contact_info"] as? JSONDictionary {
            contactInfo = ContactInfo(json: obj)
        }
    }
}

struct ContactInfo {
    var aertrip: [Aertrip] = []
    var airlines: [BookingAirline] = []
    var airport: [BookingAirport] = []
    var hotel : [Hotel] = []
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["aertrip"] as? [JSONDictionary] {
            aertrip = Aertrip.getModels(json: obj)
        }
        
        if let obj = json["airlines"] as? [JSONDictionary] {
            airlines = BookingAirline.getBookingAirline(json: obj)
        }
        
        if let obj = json["airports"] as? [JSONDictionary] {
            airport = BookingAirport.getModel(json: obj)
        }
        
        if let obj = json["hotel"] as? [JSONDictionary] {
            hotel = Hotel.getModel(json: obj)
        }
    }
}

struct Aertrip {
    var key: String = ""
    var value: String = ""
    var role: String = ""
    var email: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["key"] {
            key = "\(obj)".removeNull
        }
        if let obj = json["value"] {
            value = "\(obj)".removeNull
        }
        if let obj = json["role"] {
            role = "\(obj)".removeNull
        }
        if let obj = json["email"] {
            email = "\(obj)".removeNull
        }
    }
    
    static func getModels(json: [JSONDictionary]) -> [Aertrip] {
        return json.map { Aertrip(json: $0) }
    }
}

// Airline Details for Additional Informations

struct BookingAirline {
    var airlineCode: String = ""
    var airlineName: String = ""
    var phone: String = ""
    var email: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["al_code"] {
            airlineCode = "\(obj)".removeNull
        }
        if let obj = json["al_name"] {
            airlineName = "\(obj)".removeNull
        }
        
        if let obj = json["phone"] {
            phone = "\(obj)".removeNull
        }
        
        if let obj = json["email"] {
            email = "\(obj)".removeNull
        }
    }
    
    static func getBookingAirline(json: [JSONDictionary])-> [BookingAirline]{
        var bookingAirline = [BookingAirline]()
        bookingAirline.removeAll()
        for jsn in json{
            if let phone = jsn[APIKeys.phone.rawValue] as? String , !phone.isEmpty{
                let phoneNumArr = phone.components(separatedBy: "/").filter{!$0.isEmpty}
                if phoneNumArr.count == 1{
                    bookingAirline.append(BookingAirline(json: jsn))
                }else{
                    for (index, value) in phoneNumArr.enumerated(){
                        var bkingAirline = BookingAirline(json: jsn)
                        bkingAirline.phone = value.removeLeadingTrailingWhitespaces
                        if index != 0{
                            bkingAirline.airlineCode = ""
                            bkingAirline.airlineName = ""
                        }
                        bookingAirline.append(bkingAirline)
                    }
                }
            }
        }
        return bookingAirline
    }
    
    static func getModels(json: [JSONDictionary]) -> [BookingAirline] {
        return json.map { BookingAirline(json: $0) }
    }
}

struct BookingAirport {
    var ataCode: String = ""
    var city: String = ""
    var countryCode: String = ""
    var phone: String = ""
    var email: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["iata_code"] {
            ataCode = "\(obj)".removeNull
        }
        
        if let obj = json["city"] {
            city = "\(obj)".removeNull
        }
        
        if let obj = json["country_code"] {
            countryCode = "\(obj)".removeNull
        }
        
        if let obj = json["phone"] {
            phone = "\(obj)".removeNull
        }
        
        if let obj = json["email"] {
            email = "\(obj)".removeNull
        }
    }
    

    
    static func getModel(json: [JSONDictionary]) -> [BookingAirport] {
        return json.map { BookingAirport(json: $0) }
    }
}

// Model for Using hotel

struct Hotel  {
    
    var email: String = ""
    var web: String = ""
    var phone: String = ""
    var countryCode: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    
    init(json: JSONDictionary) {
        if let obj = json["emai"] {
            self.email = "\(obj)".removeNull
        }
        if let obj = json["web"] {
            self.web = "\(obj)".removeNull
        }
        
        if let obj = json["phone"] {
            self.phone = "\(obj)".removeNull
        }
        if let obj = json["country_code"] {
            self.countryCode = "\(obj)".removeNull
        }
    }
    
    static func getModel(json: [JSONDictionary]) -> [Hotel] {
        return json.map { Hotel(json: $0) }
    }
}

