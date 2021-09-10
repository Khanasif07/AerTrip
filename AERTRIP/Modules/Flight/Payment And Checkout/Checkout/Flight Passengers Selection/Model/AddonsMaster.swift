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
        printDebug(json)
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
        flight = json["flights"].arrayValue.map{AddonsFlight($0, legId: json["leg_id"].stringValue)}
        preference = AddonsPreference(json["preferences"])
        iic = json["iic"].boolValue
        freeMealSeat = json["free_meal_seat"].int
        freeSeat = json["free_seat"].int
    }
}

struct AddonsFlight{
    var legId : String
    var flightId:String
    var meal:AddonsDetails
    var bags:AddonsDetails
    var special:AddonsDetails
    var ssrName:[String:AddonsSsr]
    var frequenFlyer:[String:AddonsFFDetails]
    var isfrequentFlyer:Bool
    var freeMeal : Bool = false
    var freeSeat : Bool = false
    var specialRequest : String = ""
    
    init(_ json:JSON = JSON(), legId : String){
        self.legId = legId
        ssrName = Dictionary(uniqueKeysWithValues: json["ssr_name"].map { ($0.0, AddonsSsr($0.1)) })
        frequenFlyer = Dictionary(uniqueKeysWithValues: json["frequent_flyer"].map { ($0.0, AddonsFFDetails($0.1)) })
        isfrequentFlyer = json["is_frequent_flyer"].boolValue
        flightId = json["flight_id"].stringValue
        meal = AddonsDetails(json["meals"], ssrName: ssrName)
        bags = AddonsDetails(json["bags"], ssrName: ssrName)
        special = AddonsDetails(json["special"], ssrName: ssrName)
    }
}

struct AddonsDetails{
//    var adt:[String:Int]
//    var chd:[String:Int]
//    var inf:[String:Int]
    
    var addonsArray : [AddonsDataCustom] = []
    
    init(){
        
    }
    
    init(_ json:JSON = JSON(), ssrName : [String:AddonsSsr]){
//        adt = json["ADT"].dictionaryObject as? [String:Int] ?? [:]
//        chd = json["CHD"].dictionaryObject as? [String:Int] ?? [:]
//        inf = json["INF"].dictionaryObject as? [String:Int] ?? [:]
//
        let adt = json["ADT"].dictionaryObject as? [String:Int] ?? [:]
        let chd = json["CHD"].dictionaryObject as? [String:Int] ?? [:]
        let inf = json["INF"].dictionaryObject as? [String:Int] ?? [:]
        
        adt.forEach { (key,value) in
            var adon = AddonsDataCustom(name: key, price: value.toDouble, ssrName: ssrName[key])
            adon.isAdult = true
            addonsArray.append(adon)
        }
        
        chd.forEach { (key,value) in
            if let indx = addonsArray.firstIndex(where: { (adon) -> Bool in
                adon.adonsName == key
            }){
                addonsArray[indx].isChild = true
            }else{
                var adon = AddonsDataCustom(name: key, price: value.toDouble, ssrName: ssrName[key])
                  adon.isChild = true
                  addonsArray.append(adon)
            }
        }
        
        inf.forEach { (key,value) in
               if let indx = addonsArray.firstIndex(where: { (adon) -> Bool in
                   adon.adonsName == key
               }){
                   addonsArray[indx].isInfant = true
               }else{
                var adon = AddonsDataCustom(name: key, price: value.toDouble, ssrName: ssrName[key])
                     adon.isInfant = true
                     addonsArray.append(adon)
               }
           }

       addonsArray = addonsArray.sorted { (a, b) -> Bool in
            return a.price < b.price
        }
        
    }
}

struct AddonsDataCustom {
    
    var adonsName : String = ""
    var addonDescription = ""
    var price : Double = 0
    var isAdult : Bool = false
    var isChild : Bool = false
    var isInfant : Bool = false
    var ssrName : AddonsSsr?
    var mealsSelectedFor : [ATContact] = []
    var bagageSelectedFor : [ATContact] = []
    var othersSelectedFor : [ATContact] = []
//    var autoSelectedFor : [String] = []
    var autoSelectedFor : String = ""
    var isInternational : Bool = false
    
    init() {
        
    }
    
    init(name : String, price : Double,ssrName : AddonsSsr?){
        self.adonsName = name
        self.price = price
        self.ssrName = ssrName
    }
}


struct AddonsSsr{
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
