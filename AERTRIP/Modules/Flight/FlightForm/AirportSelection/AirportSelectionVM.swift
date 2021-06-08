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
       
    }

    @objc func getSelectedAirportsString()->NSString{
        let origin = ((self.fromFlightArray as? [AirportSearch] ?? []).map{$0.iata ?? ""}).joined(separator: ",")
        let dest = ((self.toFlightArray as? [AirportSearch] ?? []).map{$0.iata ?? ""}).joined(separator: ",")
        return NSString(string:"OriginAirport:\(origin),DestinationAirport:\(dest)")
    }
    
    
}

///Log firebase evets
@objc extension AirportSelectionVM{
    
    @objc func logEvent(name:String, value:String){
        FirebaseEventLogs.shared.logAirportSelectionEvents(name, isForFrom: self.isFrom, dictValue: value)
    }
    
}
