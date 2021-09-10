//
//  RecentSearchModel.swift
//  AERTRIP
//
//  Created by Appinventiv on 21/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RecentSearchObject {
    
    let totalLegs : Int
    let origin : String
    let adult : Int
    var infant : Int
    let child : Int
    let tripType : String
    let destination : String
    let depart : String
    let cabinclass : String
    
    
    init(json : JSON) {
        totalLegs = json[APIKeys.totalLegs.rawValue].intValue
        origin = json[APIKeys.origin.rawValue].stringValue
        adult = json[APIKeys.adult.rawValue].intValue
        infant = json[APIKeys.infant.rawValue].intValue
        child = json[APIKeys.child.rawValue].intValue
        tripType = json[APIKeys.tripTypes.rawValue].stringValue
        destination = json[APIKeys.destination.rawValue].stringValue
        depart = json[APIKeys.depart.rawValue].stringValue
        cabinclass = json[APIKeys.cabinclass.rawValue].stringValue
    }
    
    
}
