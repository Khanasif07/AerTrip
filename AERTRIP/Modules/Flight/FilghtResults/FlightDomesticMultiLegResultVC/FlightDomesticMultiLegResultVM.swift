//
//  FlightDomesticMultiLegResultVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 20/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightDomesticMultiLegResultVM {

    var showPinnedFlights = false
    var numberOfLegs : Int = 0
    var resultsTableStates =  [ResultTableViewState]()
    var stateBeforePinnedFlight = [ResultTableViewState]()
    var taxesResult : [String : String] = [:]
    var airportDetailsResult : [String : AirportDetailsWS] = [:]
    var airlineDetailsResult : [String : AirlineMasterWS] = [:]
    var airlineCode = ""
    var results = [DomesticMultilegJourneyResultsArray]()
    var sortOrder = Sort.Smart

    
    init() {
        
    }
 
    
}
