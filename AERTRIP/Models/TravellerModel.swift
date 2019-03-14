//
//  Traveller.swift
//  AERTRIP
//
//  Created by apple on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct TravellerModel {
    var id:String
    var label: String
    var salutation: String
    var firstName: String
    var lastName: String
    var dob: String
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    var jsonDict: [String:Any] {
        return ["id": self.id,
                "label": self.label,
                "salutation": self.salutation,
                "first_name": self.firstName,
                "last_name": self.lastName,
                "dob": self.dob]
    }
    
    init(json: JSON) {
        self.id = json["id"].stringValue.removeNull
        self.label = json["label"].stringValue.removeNull
        self.salutation = json["salutation"].stringValue.removeNull
        self.firstName = json["first_name"].stringValue.removeNull
        self.lastName = json["last_name"].stringValue.removeNull
        self.dob = json["dob"].stringValue.removeNull
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
        
        let keyArr : [String] = Array(json.dictionaryValue.keys)
        for key in keyArr {
            if var temp =  json[key].dictionaryObject {
                temp["id"] = key
                travellers.append(TravellerModel(json: JSON(temp)))
            }
        }
        
        return travellers
    }
    
    static func filterByGroups(json:JSON) -> [String:Any] {
        var travellers : [String:Any] = [:]
        let travellersArray = models(json: json)
        travellers["Friends"] = travellersArray.filter { $0.label == "Friends"}
        travellers["Other"] = travellersArray.filter { $0.label == "Other" || $0.label.isEmpty}
        return travellers
        
    }
    
    static func filterByLetters(json:JSON) -> [String:Any] {
        let travellers : [String:Any] = [:]
        
        return travellers
    }
}
