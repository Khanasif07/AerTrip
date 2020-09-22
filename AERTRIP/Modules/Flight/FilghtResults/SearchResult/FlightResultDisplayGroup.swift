//
//  FlightResultDisplayGroup.swift
//  Aertrip
//
//  Created by  hrishikesh on 12/08/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class FlightResultDisplayGroup {
    
    /// Only for checking if user has initiated application of filter
    /// For filters with multiple checks only
    enum InitiatedFilters {
        case tripDuration
        case layoverDuration
        case departureTime
        case arrivalTime
    }
    internal var initiatedFilters: Set<InitiatedFilters> = []
    
    /// For checking if any of the sub filter is applied
    var appliedSubFilters: Set<InitiatedFilters> = []
    
    let index : Int
    weak var delegate : FlightResultViewModelDelegate?
    var workItems = [DispatchWorkItem]()
    var flightsResults  =  FlightsResults()
    var cooperateFareResults : [Journey]?
    var resultsFromTPorRiReceived = false
    var InputJourneyArray = [Journey]()
    var processedJourneyArray = [Journey]()
    var sortOrder : Sort = .Smart
    var userSelectedFilters : FiltersWS?
    var inputFilter : FiltersWS?
    var updatedFilterResultCount = 0
    
    private var filterUpdatedFromDeepLink = false
    
    internal var isAPIResponseUpdated = false

    //MARK:- Computed Properties
    var appliedFilters = Set<Filters>() {
        didSet{
            let filterApplied =  appliedFilters.count > 0 || UIFilters.count > 0
            self.delegate?.filtersApplied(filterApplied)
            
            /// Removes applied sub filters if main filter is removed
            if !appliedFilters.contains(.Times) {
                appliedSubFilters.remove(.arrivalTime)
                appliedSubFilters.remove(.departureTime)
            } else if !appliedFilters.contains(.Duration) {
                appliedSubFilters.remove(.tripDuration)
                appliedSubFilters.remove(.layoverDuration)
            }
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
                self.delegate?.updatedResponseReceivedAt(index: self.index , filterApplied:filterApplied, isAPIResponseUpdated: self.isAPIResponseUpdated)
                
                if self.filteredJourneyArray.count == 0 {
                    self.delegate?.showNoFilteredResultsAt(index: self.index )
                }
                self.isAPIResponseUpdated = false
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
            applyFilters(isAPIResponseUpdated: true)
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
    
    func workingOnReceived( flightsArray: [Flights] ,searchType : FlightSearchType, flightSearchParam: JSONDictionary) {
        mergeFlightResults( flightsArray)
        mergeFilters(flightsArray)
        updateUserFiltersFromDeepLink(flightSearchParam)
        processingOnCombinedSearchResult(searchType : searchType)
    }
    
    private func updateUserFiltersFromDeepLink(_ flightSearchParam: JSONDictionary) {
        
        guard !filterUpdatedFromDeepLink else { return }
        filterUpdatedFromDeepLink = true
        
        if let stop = flightSearchParam["filters[\(self.index)][stp][0]"] as? String{
            self.appliedFilters.insert(.stops)
            self.userSelectedFilters?.stp = [stop]
        }
        
        if let al = flightSearchParam["filters[\(self.index)][al][0]"] as? String{
            self.appliedFilters.insert(.Airlines)
            self.userSelectedFilters?.al = [al]
        }
        
        if let ar_dt = flightSearchParam["filters[\(self.index)][ar_dt][0]"] as? String{
            self.appliedFilters.insert(.Times)
            self.appliedSubFilters.insert(.arrivalTime)
            self.userSelectedFilters?.arDt.earliest = ar_dt
        }
        
        if let ar_dt = flightSearchParam["filters[\(self.index)][ar_dt][1]"] as? String{
            self.appliedFilters.insert(.Times)
            self.appliedSubFilters.insert(.arrivalTime)
            self.userSelectedFilters?.arDt.latest = ar_dt
        }
        
        if let dep_dt = flightSearchParam["filters[\(self.index)][dep_dt][0]"] as? String{
            self.appliedFilters.insert(.Times)
            self.appliedSubFilters.insert(.departureTime)
            self.userSelectedFilters?.depDt.earliest = dep_dt
        }
        
        if let dep_dt = flightSearchParam["filters[\(self.index)][dep_dt][1]"] as? String{
            self.appliedFilters.insert(.Times)
            self.appliedSubFilters.insert(.departureTime)
            self.userSelectedFilters?.depDt.latest = dep_dt
        }
        
        if let loap = flightSearchParam["filters[\(self.index)][loap][0]"] as? String{
            self.appliedFilters.insert(.Airport)
            self.UIFilters.insert(.layoverAirports)
            self.userSelectedFilters?.loap = [loap]
        }
        
        if let pr = flightSearchParam["filters[\(self.index)][pr][0]"] as? String{
            self.appliedFilters.insert(.Price)
            self.userSelectedFilters?.pr.minPrice = Int(pr) ?? 0
        }
        
        if let pr = flightSearchParam["filters[\(self.index)][pr][1]"] as? String{
            self.appliedFilters.insert(.Price)
            self.userSelectedFilters?.pr.maxPrice = Int(pr) ?? 0
        }
    }
    
    private func mergeFilters(_ flightsArray  : [Flights]) {
        flightsArray.forEach { (flight) in
            print("flight filters count: \(flight.results.f.count)")
            if inputFilter == nil {
                inputFilter = flight.results.f.last
                userSelectedFilters = flight.results.f.last
            } else {
                guard let latestFilter = flight.results.f.last, var newFilter = inputFilter else { return }
                
                newFilter.multiAl = [(newFilter.multiAl ?? 0), (latestFilter.multiAl ?? 0)].max() ?? 0
                
                latestFilter.cityapN.fr.forEach { (key, val) in
                    newFilter.cityapN.fr[key] = Array(Set(val + (latestFilter.cityapN.fr[key] ?? [])))
                }
                latestFilter.cityapN.to.forEach { (key, val) in
                    newFilter.cityapN.to[key] = Array(Set(val + (latestFilter.cityapN.to[key] ?? [])))
                }
                newFilter.fares = Array(Set(newFilter.fares + latestFilter.fares))
                latestFilter.fq.forEach { (key, val) in
                    newFilter.fq[key] = val
                }
                newFilter.pr.minPrice = [newFilter.pr.minPrice, latestFilter.pr.minPrice].min() ?? 0
                newFilter.pr.maxPrice = [newFilter.pr.maxPrice,
                    latestFilter.pr.maxPrice].max() ?? 0
                newFilter.stp = Array(Set(newFilter.stp + latestFilter.stp))
                newFilter.al = Array(Set(newFilter.al + latestFilter.al))
                newFilter.depDt.earliest = compareAndGetDate(.orderedAscending, d1: newFilter.depDt.earliest, d2: latestFilter.depDt.earliest)
                newFilter.depDt.latest = compareAndGetDate(.orderedDescending, d1: newFilter.depDt.latest, d2: latestFilter.depDt.latest)
                
                newFilter.arDt.earliest = compareAndGetDate(.orderedAscending, d1: newFilter.arDt.earliest, d2: latestFilter.arDt.earliest)
                newFilter.arDt.latest = compareAndGetDate(.orderedDescending, d1: newFilter.arDt.latest, d2: latestFilter.arDt.latest)
                
                newFilter.dt.earliest = compareAndGetDate(.orderedAscending, d1: newFilter.dt.earliest, d2: latestFilter.dt.earliest)
                newFilter.dt.latest = compareAndGetDate(.orderedDescending, d1: newFilter.dt.latest, d2: latestFilter.dt.latest)
                
                newFilter.at.earliest = compareAndGetDate(.orderedAscending, d1: newFilter.at.earliest, d2: latestFilter.at.earliest)
                newFilter.at.latest = compareAndGetDate(.orderedDescending, d1: newFilter.at.latest, d2: latestFilter.at.latest)
                
                newFilter.tt.minTime = compareAndGetDate(.orderedAscending, d1: newFilter.tt.minTime ?? "", d2: latestFilter.tt.minTime ?? "")
                newFilter.tt.maxTime = compareAndGetDate(.orderedDescending, d1: newFilter.tt.maxTime ?? "", d2: latestFilter.tt.maxTime ?? "")
                
                newFilter.loap = Array(Set(newFilter.loap + latestFilter.loap))
                
                if newFilter.lott != nil {
                    newFilter.lott!.minTime = compareAndGetDate(.orderedAscending, d1: newFilter.lott?.minTime ?? "0", d2: latestFilter.lott?.minTime ?? "0")
                    newFilter.lott!.maxTime = compareAndGetDate(.orderedDescending, d1: newFilter.lott?.maxTime ?? "0", d2: latestFilter.lott?.maxTime ?? "0")

                }
                                
                newFilter.originTz.min = compareAndGetDate(.orderedAscending, d1: newFilter.originTz.min, d2: latestFilter.originTz.min)
                newFilter.originTz.max = compareAndGetDate(.orderedDescending, d1: newFilter.originTz.max, d2: latestFilter.originTz.max)
                
                newFilter.destinationTz.min = compareAndGetDate(.orderedAscending, d1: newFilter.destinationTz.min, d2: latestFilter.destinationTz.min)
                newFilter.destinationTz.max = compareAndGetDate(.orderedDescending, d1: newFilter.destinationTz.max, d2: latestFilter.destinationTz.max)
                
                newFilter.ap = Array(Set(newFilter.ap + latestFilter.ap))
                
                latestFilter.cityap.forEach { (dict) in
                    newFilter.cityap[dict.key] = Array(Set((newFilter.cityap[dict.key] ?? []) + dict.value))
                }
                inputFilter = newFilter
            }
        }
    }
    
    private func compareAndGetDate(_ type: ComparisonResult, d1: String, d2: String) -> String {
        if type == .orderedAscending {
            if let _ = Int(d1) {
                return (Int(d1) ?? 0) < (Int(d2) ?? 0) ? d1 : d2
            } else {
                return d1.compare(d2) == .orderedAscending ? d1 : d2
            }
            
        } else if type == .orderedDescending {
            if let _ = Int(d1) {
                return (Int(d1) ?? 0) > (Int(d2) ?? 0) ? d1 : d2
            } else {
                return d1.compare(d2) == .orderedDescending ? d1 : d2
            }
        }
        return d1
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

