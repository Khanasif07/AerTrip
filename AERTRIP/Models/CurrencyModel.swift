//
//  CurrencyModel.swift
//  AERTRIP
//
//  Created by Admin on 25/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

struct CurrencyModel {
    var icon: String
    var group:String
    var display_format:String
    var textSuffix:Bool
    var name:String
    var cancellation_rate:String
    var rate:String
    var text:String
    var code:String

//    init() {
//        let json = JSON()
//        self.init(json: json)
//    }
    
    init(json:JSON, code: String) {
        self.icon = json["icon"].stringValue.removeNull
        self.group = json["group"].stringValue.removeNull
        self.display_format = json["display_format"].stringValue.removeNull
        self.textSuffix = json["textSuffix"].boolValue
        self.name = json["name"].stringValue.removeNull
        self.cancellation_rate = json["cancellation_rate"].stringValue.removeNull
        self.rate = json["rate"].stringValue.removeNull
        self.text = json["text"].stringValue.removeNull
        self.code = code
      
        
    }
    
    static func retunCurrencyModelArray(json: JSON) -> [CurrencyModel] {
        var array = [CurrencyModel]()
        let keys = json.dictionaryValue.keys
        for key in keys {
            array.append(CurrencyModel(json: json[key], code: key))
        }
        return array
    }
    
    /*
     "icon" : "icon icon_currency-usd",
     "group" : "Secondary",
     "display_format" : "million",
     "textSuffix" : false,
     "cancellation_rate" : "0.02035531",
     "name" : "Brunei Dollar",
     "rate" : "0.02031286",
     "text" : "B"
     */
}
