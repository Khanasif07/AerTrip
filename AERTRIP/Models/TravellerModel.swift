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
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.label = json["label"].stringValue
        self.salutation = json["salutation"].stringValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.dob = json["dob"].stringValue
    }
    
    static func retunsTravellerArray(jsonArr: [JSON]) -> [TravellerModel] {
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
          var travellers : [String:Any] = [:]
        
        return travellers
    }
}
