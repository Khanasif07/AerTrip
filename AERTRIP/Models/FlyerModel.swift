//
//  FlyerModel.swift
//  AERTRIP
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

struct FlyerModel {
    var iata: String
    var label:String
    var logoUrl:String
    var value:String
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json:JSON) {
        self.iata = json["iata"].stringValue
        self.label = json["label"].stringValue
        self.logoUrl = json["logo_url"].stringValue
        self.value = json["value"].stringValue
        
      
        
    }
    
    static func retunsFlyerArray(jsonArr:[JSON]) -> [FlyerModel] {
        var flyer = [FlyerModel]()
        for element in jsonArr {
            flyer.append(FlyerModel(json: element))
        }
        return flyer
    }
    
    
}
