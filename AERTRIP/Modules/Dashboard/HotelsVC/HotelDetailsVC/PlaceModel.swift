//
//  PlaceModel.swift
//  AERTRIP
//
//  Created by Admin on 25/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct PlaceModel {
    
    var distanceText: String = ""
    var distanceValue: Int = 0
    var durationText: String = ""
    var durationValue: Int = 0
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.text.rawValue: self.distanceText,
                APIKeys.value.rawValue: self.distanceValue,
                APIKeys.text.rawValue: self.durationText,
                APIKeys.value.rawValue: self.durationValue]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.distance.rawValue] as? JSONDictionary {
            if let distanceText = obj[APIKeys.text.rawValue] {
                self.distanceText =  "\(distanceText)".removeNull
            }
            if let distanceValue = obj[APIKeys.value.rawValue] as? Int {
                self.distanceValue = distanceValue
            }
        }
        
        if let obj = json[APIKeys.duration.rawValue] as? JSONDictionary {
            if let durationText = obj[APIKeys.text.rawValue] {
                self.durationText =  "\(durationText)".removeNull
            }
            if let durationValue = obj[APIKeys.value.rawValue] as? Int {
                self.durationValue = durationValue
            }
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func placeInfo(response: JSONDictionary) -> PlaceModel {
        let placeData = PlaceModel(json: response)
        return placeData
    }

//    text : "5.7 km"
//    value : 5746
//    duration
//    text : "13 mins"
//    value : 804
    
}
