//
//  AddonsMaster.swift
//  AERTRIP
//
//  Created by Apple  on 27.05.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

struct AddonsMaster {
    var legs:[String:AddonsLeg]
    init(_ json:JSON = JSON()){
        legs = Dictionary(uniqueKeysWithValues: json["legs"].map { ($0.0, AddonsLeg($0.1)) })
    }
}

struct AddonsLeg{
    var legId:String
    var flight:[AddonsFlight]
    var preference:AddonsPreference
    var iic:Bool
    var freeMealSeat:Int?
    var freeSeat:Int?
    
    init(_ json:JSON = JSON()){
        legId = json["leg_id"].stringValue
        flight = json["flights"].arrayValue.map{AddonsFlight($0)}
        preference = AddonsPreference(json["preferences"])
        iic = json["iic"].boolValue
        freeMealSeat = json["free_meal_seat"].int
        freeSeat = json["free_seat"].int
    }
    
}
struct AddonsFlight{
    var flightId:String
    var meal:AddonsDetails
    var bags:AddonsDetails
    var special:AddonsDetails
    var ssrName:[String:addonsSsr]
    var frequenFlyer:[String:AddonsFFDetails]
    var isfrequentFlyer:Bool
    init(_ json:JSON = JSON()){
        flightId = json["flight_id"].stringValue
        meal = AddonsDetails(json["meal"])
        bags = AddonsDetails(json["bags"])
        special = AddonsDetails(json["special"])
        ssrName = Dictionary(uniqueKeysWithValues: json["ssr_name"].map { ($0.0, addonsSsr($0.1)) })
        frequenFlyer = Dictionary(uniqueKeysWithValues: json["frequent_flyer"].map { ($0.0, AddonsFFDetails($0.1)) })
        isfrequentFlyer = json["is_frequent_flyer"].boolValue
    }
    
}
struct AddonsDetails{
    var adt:[String:Int]
    var chd:[String:Int]
    var inf:[String:Int]
    init(_ json:JSON = JSON()){
        adt = json["ADT"].dictionaryObject as? [String:Int] ?? [:]
        chd = json["CHD"].dictionaryObject as? [String:Int] ?? [:]
        inf = json["INF"].dictionaryObject as? [String:Int] ?? [:]
    }
}

struct addonsSsr{
    var code:String
    var name:String
    var isReadOnly:Int
    init(_ json:JSON = JSON()){
        code = json["code"].stringValue
        name = json["name"].stringValue
        isReadOnly = json["is_readonly"].intValue
    }
}

struct AddonsPreference{
    var meal:[String:String]
    var seat:[String:String]
    init(_ json:JSON = JSON()){
        meal = Dictionary(uniqueKeysWithValues: json["meal"].map{ ($0.0, $0.1.stringValue)})
        seat = Dictionary(uniqueKeysWithValues: json["seat"].map{ ($0.0, $0.1.stringValue)})
    }
}

struct AddonsFFDetails{
    var value:[String:[String]]
    init(_ json:JSON = JSON()){
        value = Dictionary(uniqueKeysWithValues: json.map { ($0.0, $0.1.arrayObject as? [String] ?? []) })
    }
}
