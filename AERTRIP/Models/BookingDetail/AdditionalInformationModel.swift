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
    var airlines: [Airline] = []
    var airport: [Airport] = []
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["aertrip"] as? [JSONDictionary] {
            aertrip = Aertrip.getModels(json: obj)
        }
        
        if let obj = json["airlines"] as? [JSONDictionary] {
            airlines = Airline.getModels(json: obj)
        }
        
        if let obj = json["airports"] as? [JSONDictionary] {
            airport = Airport.getModel(json: obj)
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

struct Airline {
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
    
    static func getModels(json: [JSONDictionary]) -> [Airline] {
        return json.map { Airline(json: $0) }
    }
}

struct Airport {
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
    
    static func getModel(json: [JSONDictionary]) -> [Airport] {
        return json.map { Airport(json: $0) }
    }
}
