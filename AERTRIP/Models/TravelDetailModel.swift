//
//  TravelDetailModel.swift
//  AERTRIP
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

struct TravelDetailModel {
    
    var address: [Address]
    var contact: Contact
    var preferences: Preferences
    var id: String = ""
    var label: String = ""
    var salutation: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var dob: String = ""
    var doa: String = ""
    var passportNumber: String = ""
    var passportCountry: String = ""
    var passportIssueDate: String = ""
    var passportExpiryDate: String = ""
    var profileImage: String = ""
    var imageSource: String = ""
    var notes: String = ""
    var passportCountryName: String = ""
    var frequestFlyer : [FrequentFlyer]
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        self.address = Address.retunsAddressArray(jsonArr: json["address"].arrayValue)
        self.contact = Contact(json: json["contact"])
        self.preferences = Preferences(json: json["preferences"])
        self.id = json["id"].stringValue.removeNull
        self.label = json["label"].stringValue.removeNull
        self.salutation = json["salutation"].stringValue.removeNull
        self.firstName = json["first_name"].stringValue.removeNull
        self.lastName = json["last_name"].stringValue.removeNull
        self.dob = json["dob"].stringValue.removeNull
        self.doa = json["doa"].stringValue.removeNull
        self.passportNumber = json["passport_number"].stringValue.removeNull
        self.passportCountry = json["passport_country"].stringValue.removeNull
        self.passportIssueDate = json["passport_issue_date"].stringValue.removeNull
        self.passportExpiryDate = json["passport_expiry_date"].stringValue.removeNull
        self.profileImage = json["profile_image"].stringValue.removeNull
        self.imageSource = json["image_source"].stringValue.removeNull
        self.notes = json["notes"].stringValue.removeNull
        self.passportCountryName = json["passport_country_name"].stringValue.removeNull
        self.frequestFlyer = FrequentFlyer.retunsFrequentFlyerArray(jsonArr: json["ff"].arrayValue)
    }
}

struct Address {
    var id: Int = 0
    var label: String = ""
    var line1: String = ""
    var line2: String = ""
    var line3: String = ""
    var city: String = ""
    var state: String = ""
    var country: String = ""
    var postalCode: String = ""
    var countryName:String = ""
    
    var jsonDict: [String:Any] {
        return ["id":self.id,
                "label":self.label,
                "line1":self.line1,
                "line2":self.line2,
                "line3":self.line3,
                "city":self.city,
                "state":self.state,
                "country":self.country,
                "postal_code":self.postalCode,
                "country_name":self.countryName
        ]
    }
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json:JSON) {
        self.id = json["id"].intValue
        self.label = json["label"].stringValue.removeNull
        self.line1 = json["line1"].stringValue.removeNull
        self.line2 = json["line2"].stringValue.removeNull
        self.line3 = json["line3"].stringValue.removeNull
        self.city = json["city"].stringValue.removeNull
        self.state = json["state"].stringValue.removeNull
        self.country = json["country"].stringValue.removeNull
        self.postalCode = json["postal_code"].stringValue.removeNull
        self.countryName = json["country_name"].stringValue.removeNull
        
    }
    
    static func retunsAddressArray(jsonArr:[JSON]) -> [Address] {
        var address = [Address]()
        for element in jsonArr {
            address.append(Address(json: element))
        }
        return address
    }
    
}

struct Contact {
    var email: [Email]
    var mobile: [Mobile]
    var social: [Social]
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        self.email = Email.retunsEmailArray(jsonArr: json["email"].arrayValue)
        self.mobile = Mobile.retunsMobileArray(jsonArr: json["mobile"].arrayValue)
        self.social = Social.retunsSocialArray(jsonArr: json["social"].arrayValue)
    }
    
    mutating func add(email: Email) {
        if !self.email.contains(where: { (eml) -> Bool in
            eml.value.lowercased() == email.value.lowercased()
        }) {
            
            if email.label.lowercased() == LocalizedString.Default.localized.lowercased() {
                self.email.insert(email, at: 0)
            }
            else {
                self.email.append(email)
            }
        }
    }
    
    mutating func add(mobile: Mobile) {
        if !self.mobile.contains(where: { (mbl) -> Bool in
            mbl.value.lowercased() == mobile.value.lowercased()
        }) {
            
            if mobile.label.lowercased() == LocalizedString.Default.localized.lowercased() {
                self.mobile.insert(mobile, at: 0)
            }
            else {
                self.mobile.append(mobile)
            }
        }
    }
    
    mutating func add(social: Social) {
        
        self.social.append(social)
    }
}

struct Email {
    var id: Int = 0
    var type: String = ""
    var label: String = ""
    var value: String = ""
    
    var jsonDict: [String:Any] {
        return ["id":self.id,
                "type":self.type,
                "label":self.label,
                "value":self.value]
    }
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.type = json["type"].stringValue.removeNull
        self.label = json["label"].stringValue.removeNull
        self.value = json["value"].stringValue.removeNull
    }
    
    static func retunsEmailArray(jsonArr:[JSON]) -> [Email] {
        var email = [Email]()
        for element in jsonArr {
            email.append(Email(json: element))
            
        }
        return email
    }
    
    
}

struct Mobile {
    var id: Int = 0
    var type: String = ""
    var label: String = ""
    var value: String = ""
    var isd: String = ""
    var isValide: Bool = false
    var mobileFormatted: String = ""
    
    var jsonDict: [String:Any] {
        return ["id":self.id,
                "type":self.type,
                "label":self.label,
                "value":self.value,
                "isd":self.isd,
                "mobileFormatted" : self.mobileFormatted]
    }
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.type = json["type"].stringValue.removeNull
        self.label = json["label"].stringValue.removeNull
        self.value = json["value"].stringValue.removeNull
        if let obj = json["isd"].string?.removeNull, !obj.isEmpty {
            self.isd = obj.contains("+") ? obj : "+\(obj)"
        }
        self.mobileFormatted = json["mobile_formatted"].stringValue.removeNull
    }
    
    static func retunsMobileArray(jsonArr:[JSON]) -> [Mobile] {
        var mobile = [Mobile]()
        for element in jsonArr {
            var obj = Mobile(json: element)
            obj.isValide = true
            mobile.append(obj)
        }
        return mobile
    }
}

struct Social {
    var id : Int = 0
    var type : String = ""
    var label : String = ""
    var value : String = ""
    
    var jsonDict: [String:Any] {
        return ["id":self.id,
                "type":self.type,
                "label":self.label,
                "value":self.value]
    }
    
    init () {
        let json = JSON()
        self.init(json:json)
    }
    
    init(json : JSON) {
        //        self.jsonDict = json.dictionaryObject ?? [:]
        self.id = json["id"].intValue
        self.type = json["type"].stringValue.removeNull
        self.label = json["label"].stringValue.removeNull
        self.value = json["value"].stringValue.removeNull
    }
    
    static func retunsSocialArray(jsonArr:[JSON]) -> [Social] {
        var social = [Social]()
        for element in jsonArr {
            social.append(Social(json: element))
        }
        return social
    }
    
}

struct Preferences {
    var seat: Seat
    var meal: Meal
    
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        self.seat = Seat(json: json["seat"])
        self.meal = Meal(json: json["meal"])
    }
}

struct Seat {
    var value: String = ""
    var name: String = ""
    
    var jsonDict: [String:Any] {
        return ["value":self.value,
                "name":self.name
        ]
    }
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        self.value = json["value"].stringValue.removeNull
        self.name = json["name"].stringValue.removeNull
    }
}

struct Meal {
    var value: String = ""
    var name: String = ""
    
    var jsonDict: [String:Any] {
        return ["value":self.value,
                "name":self.name
        ]
    }
    
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        self.value = json["value"].stringValue.removeNull
        self.name = json["name"].stringValue.removeNull
    }
}

struct FrequentFlyer {
    var id : Int = 0
    var number :String = ""
    var airlineCode : String = ""
    var airlineName : String = ""
    var logoUrl : String = ""
    
    
    var jsonDict: [String:Any] {
        return ["id":self.id,
                "number":self.number,
                "airline_code":self.airlineCode,
                "airline_name":self.airlineName,
                "logo_url":self.logoUrl]
    }
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.number = json["number"].stringValue.removeNull
        self.airlineCode = json["airline_code"].stringValue.removeNull
        self.airlineName = json["airline_name"].stringValue.removeNull
        self.logoUrl = json["logo_url"].stringValue.removeNull
    }
    
    
    static func retunsFrequentFlyerArray(jsonArr:[JSON]) -> [FrequentFlyer] {
        var frequentFlyer = [FrequentFlyer]()
        for element in jsonArr {
            frequentFlyer.append(FrequentFlyer(json: element))
        }
        return frequentFlyer
    }
}




