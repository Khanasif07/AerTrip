//
//  FlightFromToSelectionViewModel.swift
//  Aertrip
//
//  Created by Hrishikesh Devhare on 17/12/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

import Foundation
import UIKit


@objc enum AirportSelectionMode : Int {
    case SingleLegJournery
    case MultiCityJourney
    case BulkBookingJourney
}

@objc enum JourneyType: Int {
    case domestic
    case international
}

 class AirportSelectionVM : NSObject
{
    @objc var isFrom : Bool
    @objc weak var delegate : AirportSelctionHandler?
    @objc var fromFlightArray : NSMutableArray?
    @objc var toFlightArray : NSMutableArray?
    @objc var airportSelectionMode : AirportSelectionMode
    @objc var journeyType: JourneyType = .domestic
    @objc var airlineNum : String?
 
    @objc init(isFrom:Bool , delegateHandler : AirportSelctionHandler , fromArray:NSMutableArray? , toArray : NSMutableArray? , airportSelectionMode : AirportSelectionMode) {
        
        self.isFrom = isFrom
        self.delegate = delegateHandler
        self.fromFlightArray = fromArray
        self.toFlightArray =  toArray
        self.airportSelectionMode = airportSelectionMode
        
    }
    
    @objc func onDoneButtonTapped() {
        self.delegate?.flight?(fromSource: self.fromFlightArray, toDestination: self.toFlightArray, airlineNum:airlineNum)
        let dict:NSMutableDictionary = [:]
        dict["OriginSelecteAiport"] = ((self.fromFlightArray as? [AirportSearch] ?? []).map{$0.iata})
        dict["DestinationSelecteAiport"] = ((self.toFlightArray as? [AirportSearch] ?? []).map{$0.iata})
        self.logEvent(name: "24", value: dict)
    }
}

///Log firebase evets
@objc extension AirportSelectionVM{
    
    @objc func logEvent(name:String, value:NSDictionary){
        
        var val = JSONDictionary()
        if let newValue = value as? JSONDictionary{
            val = newValue
        }else{
            val = [:]
        }
        FirebaseEventLogs.shared.logAirportSelectionEvents(name, isForFrom: self.isFrom, dictValue: val)
    }
    
}
