//
//  FlightWhatNextData.swift
//  AERTRIP
//
//  Created by Apple  on 24.07.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
 

@objc class FlightWhatNextData : NSObject{
    
    @objc static var shared = FlightWhatNextData()
    
    var whatNext:WhatNext?
    @objc var isSettingForWhatNext = false
    private override init(){
    }
    
    @objc var getSeatchDictionary: NSDictionary{
        guard let whtNxt = self.whatNext else {return [:]}
        let dict = ["origin":whtNxt.origin,
                    "destination":whtNxt.destination,
                    "depart": whtNxt.depart,
                    "return": whtNxt.returnDate,
                    "trip_type":whtNxt.tripType,
                    "adult":whtNxt.adult,
                    "child":whtNxt.child,
                    "infant": whtNxt.infant,
                    "cabinclass":whtNxt.cabinclass,
                    "departCity":whtNxt.departCity,
                    "arrivalCity":whtNxt.arrivalCity]
        return dict as NSDictionary
    }
    
    @objc func clearData(){
        self.whatNext = nil
        self.isSettingForWhatNext = false
    }
}
