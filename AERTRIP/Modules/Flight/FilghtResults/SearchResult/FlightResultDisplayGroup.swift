//
//  FlightResultDisplayGroup.swift
//  Aertrip
//
//  Created by  hrishikesh on 12/08/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class FlightResultDisplayGroup {
    let index : Int
    weak var delegate : FlightResultViewModelDelegate?
    var workItems = [DispatchWorkItem]()
    var flightsResults  =  FlightsResults()
    var cooperateFareResults : [Journey]?
    var resultsFromTPorRiReceived = false
    var InputJourneyArray = [Journey]()
    var processedJourneyArray = [Journey]()
    var sortOrder : Sort = .Smart
    var userSelectedFilters : FiltersWS!
    var inputFilter : FiltersWS!
    var updatedFilterResultCount = 0

    //MARK:- Computed Properties
    var appliedFilters = Set<Filters>() {
        didSet{
            let filterApplied =  appliedFilters.count > 0 || UIFilters.count > 0
            self.delegate?.filtersApplied(filterApplied)
        }
    }
    
    var UIFilters = Set<UIFilters>() {
        didSet {
            let filterApplied =  appliedFilters.count > 0 || UIFilters.count > 0
            self.delegate?.filtersApplied(filterApplied)
        }
    }
    
    var filteredJourneyArray = [Journey]() {
        didSet {
            
            DispatchQueue.main.async {
                
                let filterApplied =  self.appliedFilters.count > 0 || self.UIFilters.count > 0
                self.delegate?.updatedResponseReceivedAt(index: self.index , filterApplied:filterApplied)
                
                if self.filteredJourneyArray.count == 0 {
                    self.delegate?.showNoFilteredResultsAt(index: self.index )
                }
            }
        }
    }
    
    //MARK:- Initializer
    init(index : Int) {
        self.index = index
    }
    
    //MARK:- Private Methods
    
    /// Processing On merged results for following
    /// * Finding minimum fare
    /// * Finding minimum duration
    /// * Calculation of human score
    /// * Assigning group id for similar flights
    fileprivate func processingOnCombinedSearchResult( searchType : FlightSearchType) {
        if flightsResults.j.count > 0 {
            InputJourneyArray = flightsResults.j
            
            let minFare = findJourneyWithCheapestFare()
            let minDuration = findJourneyWithFastestDuration()
            
            processedJourneyArray = calculateHumanScore(minFare: Float(minFare), minDuration: minDuration, processedJourneyArray)
            
            if (searchType == SINGLE_JOURNEY  ) {
                processedJourneyArray = groupSimilarFlights(processedJourneyArray)
            }
            applyFilters()
        }
    }
    
    fileprivate func mergeFlightResults(_ flightsArray  : [Flights] )
    {
        
        
        var currentJourneyArray = [Journey]()
        
        flightsArray.forEach { (flight) in
            
            let currentResult = flight.results
            //            let vendor = flight.vcode
            
            var newJourneyArray = currentResult.setAirlinesToJourney(currentResult.j, airlineMasterTable: currentResult.alMaster)
            
            newJourneyArray = newJourneyArray.map{
                
                let journey = $0
                journey.isPinned = false
                return journey
            }
            currentJourneyArray.append(contentsOf: newJourneyArray)
        }
        
        
        if flightsResults.j.count == 0 {
            flightsResults.j = currentJourneyArray
        }
        else {
            flightsResults.j = removeRedundantResults(flightsResults.j, newInputArray: currentJourneyArray, isDomestic: true)
        }
        
        guard let lastFlight = flightsArray.last else { return }
        
        let lastFlightresults = lastFlight.results
        flightsResults.f = lastFlightresults.f
        flightsResults.apdet = lastFlightresults.apdet
        flightsResults.taxes = lastFlightresults.taxes
        flightsResults.aldet =  lastFlightresults.aldet
        flightsResults.alMaster = lastFlightresults.alMaster
        
        
    }

    fileprivate func findJourneyWithCheapestFare() -> Int {
        let minFareJourney = InputJourneyArray.min { (first, second) in first.farepr < second.farepr }
        
        guard let CheapestFareJourney = minFareJourney else {
            fatalError("Failed to find journey with cheapest Fare")
        }
        
        processedJourneyArray = InputJourneyArray.map({ (journey) in
            
            let modifiedJourney = journey
            if modifiedJourney.farepr == CheapestFareJourney.farepr {
                modifiedJourney.isCheapest = true
            }
            else {
                modifiedJourney.isCheapest = false
            }
            return modifiedJourney
        })
        
        return CheapestFareJourney.farepr
    }
    
    fileprivate func findJourneyWithFastestDuration() -> Int {
        let sortedByDuration = processedJourneyArray.min { (first, second) in first.duration < second.duration }
        
        guard let fastestJourney  = sortedByDuration else {
            
            assertionFailure("Failed to get flight with minimum duration")
            return -1
        }
        processedJourneyArray = processedJourneyArray.map({ (journey) in
            
            let modifiedJourney = journey
            if modifiedJourney.duration == fastestJourney.duration {
                modifiedJourney.isFastest = true
            }
            else {
                modifiedJourney.isFastest = false
            }
            return modifiedJourney
        })
        
        return fastestJourney.duration
        
    }
    
    fileprivate func groupSimilarFlights(_ journey : [Journey] ) -> [Journey] {
        
        // Grouping of flights having same fare , Airline , number of stops and destination airport
        let groupedFlights = Dictionary(grouping: journey, by: { String($0.farepr) + $0.al.first! + $0.stp + $0.ap.last!  })
        
        var modifiedJourneyArray = [Journey]()
        var index = 0
        
        for (_ , journeyArray) in groupedFlights {
            
            if journeyArray.count == 1 && index != 0 {
                index += 1
                
                let modifiedJourney = journeyArray.first!
                modifiedJourney.groupID = index
                modifiedJourneyArray.append(modifiedJourney)
            }
            else {
                
                let sortedByTime = journeyArray.sorted(by: { $0.duration < $1.duration })
                var minDuration = 0.0
                
                for journey in sortedByTime {
                    
                    if minDuration == 0 {
                        index += 1
                        minDuration = Double(journey.duration)
                        let modifiedJourney = journey
                        modifiedJourney.groupID = index
                        modifiedJourneyArray.append(modifiedJourney)
                        
                        continue
                    }
                    
                    if ( minDuration * 1.2) >= Double(journey.duration) {
                        
                        let modifiedJourney = journey
                        modifiedJourney.groupID = index
                        modifiedJourneyArray.append(modifiedJourney)
                    }
                    else {
                        index += 1
                        minDuration = Double(journey.duration)
                        
                        let modifiedJourney = journey
                        modifiedJourney.groupID = index
                        modifiedJourneyArray.append(modifiedJourney)
                        
                    }
                }
            }
        }
        
        return modifiedJourneyArray
    }
    
    fileprivate func removeRedundantResults (_ currentJourneyArray : [Journey] , newInputArray : [Journey] , isDomestic : Bool) -> [Journey] {
        
        var mutableJourneyArray = currentJourneyArray
        var newjourneyArray = [Journey]()
        
        for (_, newJourney) in newInputArray.enumerated() {
            var shouldReplace = false
            
            for i in 0 ..< currentJourneyArray.count {
                let journey = mutableJourneyArray[i]
                if newJourney == journey {
                    shouldReplace = true
                }
                
                if shouldReplace {
                    mutableJourneyArray[i] = newJourney
                    break
                }
            }
            
            if !shouldReplace {
                newjourneyArray.append(newJourney)
            }
        }
        
        mutableJourneyArray.append(contentsOf: newjourneyArray)
        
        return mutableJourneyArray
        
        
    }
    
    
    /// updateCorpFaresFlagInResults
    /// This method checks fk identifier of input array with ofk identifier of cooperateFareResults array.
    /// If matching pair of fk & ofk is found then 'hasCorporateFare' flag of corrosponding journey object from input array is updated.
    /// - Parameter journey: input Array of Journey to apply corporate fare flag
    /// - Returns: Array of Journey objects
    fileprivate func updateCorpFaresFlagInResults(_ journey : [Journey]) -> [Journey] {
        
        guard let corpFareResults = cooperateFareResults else { return journey }
        
        var modifiedArray = journey
        for coorporateJourney in corpFareResults {
            if let ofk = coorporateJourney.ofk {
                
                for index in 0 ..< journey.count {
                    
                    let currentJourney = journey[index]
                    
                    if currentJourney.fk.caseInsensitiveCompare(ofk) == .orderedSame {
                        
                        currentJourney.hasCorporateFare = true
                        modifiedArray[index] = currentJourney
                        break
                    }
                }
            }
        }
        
        return modifiedArray
    }
    
    
    
    ///  Calculation and applying of human score to journey array
    ///
    /// - Parameters:
    ///   - minFare: minimum fare value in input journey array
    ///   - minDuration: minimum duration value in input journey array
    ///   - journey: Array of journey
    /// - Returns: Array of Journey with updated human score
   fileprivate  func calculateHumanScore(minFare: Float  ,minDuration : Int    , _ journey : [Journey] ) -> [Journey] {
        
        
        var outputArray = journey.map { (journey) -> Journey in
            
            let outputJourney = journey
            var points = Float(outputJourney.humaneScore)
            points += (journey.humanePrice.total / minFare) * 1200
            points += Float(journey.duration) / Float(minDuration) * 1000
            outputJourney.computedHumanScore = points
            return outputJourney
        }
        
        let minHumanScore = outputArray.min { (first, second) in first.computedHumanScore! < second.computedHumanScore! }
        
        
        // set property above human score threadshold bool
        
        outputArray = outputArray.map { (journey) -> Journey in
            
            let outputJourney = journey
            
            if outputJourney.computedHumanScore! > ((minHumanScore?.computedHumanScore)! * 1.26) {
                outputJourney.isAboveHumanScore = true
            }
            else {
                outputJourney.isAboveHumanScore = false
            }
            return outputJourney
        }
        
        outputArray = outputArray.sorted(by: { $0.computedHumanScore!  < $1.computedHumanScore!  })
        
        return outputArray
    }
    
    
    
    //MARK:- Public Methods
    
    func workingOnReceived( flightsArray: [Flights] ,searchType : FlightSearchType) {
       
        mergeFlightResults( flightsArray)
        userSelectedFilters = flightsResults.f.last
        inputFilter = flightsResults.f.last
        processingOnCombinedSearchResult(searchType : searchType)
    }

    
    func getOnewayJourneyDisplayArray() ->[Journey]
    {
        return filteredJourneyArray
    }
    
    
    func getAirportDetailsArray() -> [String : AirportDetailsWS]{
        return flightsResults.apdet
    }
    
    func getAirlineDetailsArray() -> [String : AirlineMasterWS]{
        return flightsResults.alMaster
    }
    
    func getTaxesDetailsArray() -> [String : String]{
        return flightsResults.taxes
    }

    func getJourneyDisplayArray() -> [Journey] {
        return self.filteredJourneyArray
    }
    
    func getSortOrder() ->Sort {
        return sortOrder
    }
    
}

