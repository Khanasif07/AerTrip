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
    @objc var delegate : AirportSelctionHandler
    @objc var fromFlightArray : NSMutableArray?
    @objc var toFlightArray : NSMutableArray?
    @objc var airportSelectionMode : AirportSelectionMode
    @objc var journeyType: JourneyType = .domestic
 
    @objc init(isFrom:Bool , delegateHandler : AirportSelctionHandler , fromArray:NSMutableArray? , toArray : NSMutableArray? , airportSelectionMode : AirportSelectionMode) {
        
        self.isFrom = isFrom
        self.delegate = delegateHandler
        self.fromFlightArray = fromArray
        self.toFlightArray =  toArray
        self.airportSelectionMode = airportSelectionMode
        
    }
    
    @objc func onDoneButtonTapped() {
        self.delegate.flight!(fromSource: self.fromFlightArray, toDestination: self.toFlightArray)
        
    }
}
