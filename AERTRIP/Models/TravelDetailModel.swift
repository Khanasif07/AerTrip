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
        self.id = json["id"].stringValue
        self.label = json["label"].stringValue
        self.salutation = json["salutation"].stringValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.dob = json["dob"].stringValue
        self.doa = json["doa"].stringValue
        self.passportNumber = json["passport_number"].stringValue
        self.passportCountry = json["passport_country"].stringValue
        self.passportIssueDate = json["passport_issue_date"].stringValue
        self.passportExpiryDate = json["passport_expiry_date"].stringValue
        self.profileImage = json["profile_image"].stringValue
        self.imageSource = json["image_source"].stringValue
        self.notes = json["notes"].stringValue
        self.passportCountryName = json["passport_country_name"].stringValue
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
        self.label = json["label"].stringValue
        self.line1 = json["line1"].stringValue
        self.line2 = json["line2"].stringValue
        self.line3 = json["line3"].stringValue
        self.city = json["city"].stringValue
        self.state = json["state"].stringValue
        self.country = json["country"].stringValue
        self.postalCode = json["postal_code"].stringValue
        self.countryName = json["country_name"].stringValue
        
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
        self.type = json["type"].stringValue
        self.label = json["label"].stringValue
        self.value = json["value"].stringValue
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
        self.type = json["type"].stringValue
        self.label = json["label"].stringValue
        self.value = json["value"].stringValue
        self.isd = json["isd"].stringValue
        self.mobileFormatted = json["mobile_formatted"].stringValue
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
        self.type = json["type"].stringValue
        self.label = json["label"].stringValue
        self.value = json["value"].stringValue
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
        self.value = json["value"].stringValue
        self.name = json["name"].stringValue
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
        self.value = json["value"].stringValue
        self.name = json["name"].stringValue
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
        self.number = json["number"].stringValue
        self.airlineCode = json["airline_code"].stringValue
        self.airlineName = json["airline_name"].stringValue
        self.logoUrl = json["logo_url"].stringValue
    }
    
    
    static func retunsFrequentFlyerArray(jsonArr:[JSON]) -> [FrequentFlyer] {
        var frequentFlyer = [FrequentFlyer]()
        for element in jsonArr {
            frequentFlyer.append(FrequentFlyer(json: element))
        }
        return frequentFlyer
    }
}




