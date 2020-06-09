//
//  Traveller.swift
//  AERTRIP
//
//  Created by apple on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct TravellerModel {
    var id: Int
    var label: String
    var salutation: String
    var firstName: String
    var lastName: String
    var dob: String
    var profileImage: String
    var nationality = ""
    var passportNumber = ""
    var passportExpiryDate: String = ""
    var ffp:[FFP]?
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    var jsonDict: [String: Any] {
        return ["id": self.id,
                "label": self.label,
                "salutation": self.salutation,
                "first_name": self.firstName,
                "last_name": self.lastName,
                "dob": self.dob,
                "profile_img": self.profileImage]
    }
    
    var fullName: String {
        if !self.firstName.isEmpty {
            let final = "\(self.firstName) \(self.lastName)"
            return final
        }
        else {
            return self.lastName
        }
    }
    
    var contact: ATContact {
        var contact = ATContact(json: [:])
        contact.id = "\(self.id)"
        contact.salutation = self.salutation
        contact.firstName = self.firstName
        contact.lastName = self.lastName
        contact.dob = self.dob
        contact.profilePicture = self.profileImage
        contact.nationality = self.nationality
        contact.passportNumber = self.passportNumber
        contact.passportExpiryDate = self.passportExpiryDate
        contact.ffp = self.ffp
        return contact
    }
    
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.label = json["label"].stringValue.removeNull
        self.salutation = json["salutation"].stringValue.removeNull
        self.firstName = json["first_name"].stringValue.removeNull
        self.lastName = json["last_name"].stringValue.removeNull
        self.dob = json["dob"].stringValue.removeNull
        self.profileImage = json["profile_img"].stringValue.removeNull
        nationality = json["passport_country"].stringValue.removeNull
        passportNumber = json["passport_number"].stringValue.removeNull
        passportExpiryDate = json["passport_expiry_date"].stringValue.removeNull
        ffp = json["ffp"].arrayValue.map{FFP($0)}
    }
    
    static func models(jsonArr: [JSON]) -> [TravellerModel] {
        var traveller = [TravellerModel]()
        for element in jsonArr {
            traveller.append(TravellerModel(json: element))
        }
        return traveller
    }
    
    static func models(json: JSON) -> [TravellerModel] {
        var travellers = [TravellerModel]()
        
        let keyArr: [String] = Array(json.dictionaryValue.keys)
        for key in keyArr {
            if var temp = json[key].dictionaryObject {
                temp["id"] = key
                travellers.append(TravellerModel(json: JSON(temp)))
            }
        }
        
        return travellers
    }
    
    static func filterByGroups(json: JSON) -> [String: Any] {
        var travellers: [String: Any] = [:]
        let travellersArray = models(json: json)
        travellers["Friends"] = travellersArray.filter { $0.label == "Friends" }
        travellers["Other"] = travellersArray.filter { $0.label == "Other" || $0.label.isEmpty }
        return travellers
    }
    
    static func filterByLetters(json: JSON) -> [String: Any] {
        let travellers: [String: Any] = [:]
        
        return travellers
    }
}

struct FFP{
    
    var ffNumber:String
    var airlineCode:String
    var passengerId:String
    var ffpName:String?
    init(_ json: JSON = JSON()){
        
        ffNumber = json["ff_number"].stringValue
        airlineCode = json["airline_code"].stringValue
        passengerId = json["passenger_id"].stringValue
        ffpName = json["ffpName"].string
    }
}
