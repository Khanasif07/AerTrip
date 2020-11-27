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
    var recentSearch: NSDictionary?
    @objc var isSettingForWhatNext = false
    private override init(){
    }
    
    @objc var getSeatchDictionary: NSDictionary{
        if let whtNxt = self.whatNext {
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
                    "arrivalCity":whtNxt.arrivalCity,
                    "departCountryCode":whtNxt.departureCountryCode,
                    "departAirport":whtNxt.departAiports,
                    "arrivalCountryCode":whtNxt.arrivalCountryCode,
                    "arrivalAirpots":whtNxt.arrivalAirports] as NSMutableDictionary
        if whtNxt.tripType.lowercased() == "multi"{
            dict["originArr"] = whtNxt.originArr ?? []
            dict["destinationArr"] = whtNxt.destinationArr ?? []
            dict["departArr"] = whtNxt.departArr ?? []
            dict["departCityArr"] = whtNxt.departCityArr ?? []
            dict["arrivalCityArr"] = whtNxt.arrivalCityArr ?? []
            dict["arrivalCountryArr"] = whtNxt.arrivalCountryCodeArr ?? []
            dict["arrivalAirportsArr"] = whtNxt.arrivalAirportArr ?? []
            dict["departCountryArr"] = whtNxt.departureCountryCodeArr
            dict["departAirpotrsArr"] = whtNxt.departAiportArr
        }
        return dict
        } else if let recentsearch =  self.recentSearch{
            return recentsearch
        }
        return [:]
    }
    
    @objc func clearData(){
        self.recentSearch = nil
        self.whatNext = nil
        self.isSettingForWhatNext = false
    }
}
