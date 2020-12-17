//
//  AirlinesFilterVM.swift
//  AERTRIP
//
//  Created by Rishabh on 15/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol AirlineFilterDelegate : FilterDelegate {
    func allAirlinesSelected(_ status: Bool)
    func hideMultiAirlineItineraryUpdated(_ filter: AirlineLegFilter )
    func airlineFilterUpdated(_ filter : AirlineLegFilter)
}

class AirlinesFilterVM {
    
    var currentSelectedMultiCityIndex = 0
    var showMultiAirlineItineraryUI = true
    var showingForReturnJourney = false
    var airlinesFilterArray = [ AirlineLegFilter]()
    var currentSelectedAirlineFilter : AirlineLegFilter!
    var allAirlineSelectedByUserInteraction = false
    var isIntReturnOrMCJourney = false
    weak var delegate : AirlineFilterDelegate?
    
    func resetFilter() {
        currentSelectedAirlineFilter.airlinesArray = currentSelectedAirlineFilter.airlinesArray.map{
            var airline = $0
            airline.isSelected = false
            return airline
        }
        showMultiAirlineItineraryUI = currentSelectedAirlineFilter.multiAl == 0 ? false : true
        if isIntReturnOrMCJourney {
            showMultiAirlineItineraryUI = airlinesFilterArray.map { $0.multiAl }.reduce(0, +) > 0
        }
        currentSelectedAirlineFilter.allAirlinesSelected = false
        currentSelectedAirlineFilter.hideMultipleAirline = false
        allAirlineSelectedByUserInteraction = false
    }
}
