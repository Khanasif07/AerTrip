//
//  AirlinesFilter.swift
//  Aertrip
//
//  Created by  hrishikesh on 08/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


struct  Airline : Hashable {
    let name : String
    var isSelected : Bool
    let code : String
    var iconImageURL : String {
        
        return "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/" + self.code.uppercased() + ".png"
    }
    
    init(name : String , code : String , isSelected : Bool = false) {
        
        self.name = name
        self.code = code
        self.isSelected = isSelected
        
    }
}


struct AirlineLegFilter {
    
    let multiAl : Int
    var allAirlinesSelected : Bool = false
    var hideMultipleAirline : Bool = false
    var airlinesArray  : [Airline]
    let leg : Leg

    
    init(leg : Leg , airlinesArray : [Airline] , multiAl : Int) {

        self.airlinesArray = airlinesArray.sorted(by: {$0.name < $1.name})
        self.leg = leg
        self.multiAl = multiAl
    }
    
}
