//
//  IntFlightResultDisplayGroup.swift
//  Aertrip
//
//  Created by Rishabh on 20/04/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation

class IntFlightResultDisplayGroup {
    
    /// Only for checking if user has initiated application of filter
    /// For filters with multiple checks only
    internal var initiatedFilters:  [Int: Set<FlightResultDisplayGroup.InitiatedFilters>] = [:]
    
    /// For checking if any of the sub filter is applied
    var appliedSubFilters: [Int: Set<FlightResultDisplayGroup.InitiatedFilters>] = [:]
    
    let index : Int
    weak var delegate : FlightResultViewModelDelegate?
    var workItems = [DispatchWorkItem]()
    var flightsResults  =  IntMultiCityAndReturnWSResponse.Results(JSON())
    var cooperateFareResults : [IntMultiCityAndReturnWSResponse.Results.J]?
    var resultsFromTPorRiReceived = false
    var InputJourneyArray = [IntMultiCityAndReturnWSResponse.Results.J]()
    var processedJourneyArray = [IntMultiCityAndReturnWSResponse.Results.J]()
    var sortOrder : Sort = .Smart
    var userSelectedFilters : [IntMultiCityAndReturnWSResponse.Results.F] = []
    var inputFilter : [IntMultiCityAndReturnWSResponse.Results.F] = []
    private var numberOfLegs = 0
    internal var isReturnJourney = false
    
    internal var isAPIResponseUpdated = false
    
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
    
    var filteredJourneyArray = [IntMultiCityAndReturnWSResponse.Results.J]() {
        didSet {
            
            if isReturnJourney {
                var showReturnDepartSame = false
                if let _ = filteredJourneyArray.first(where: { $0.legsWithDetail[0].ap.first != $0.legsWithDetail[1].ap.last || $0.legsWithDetail[0].ap.last != $0.legsWithDetail[1].ap.first }) {
                    showReturnDepartSame = true
                }
                delegate?.showDepartReturnSame(showReturnDepartSame)
            }
            
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
    init(index : Int, numberOfLegs: Int) {
        self.index = index
        self.numberOfLegs = numberOfLegs
    }
    
    //MARK:- Private Methods
    
    
    /// Processing On merged results for following
    /// * Finding minimum fare
    /// * Finding minimum duration
    /// * Calculation of human score
    /// * Assigning group id for similar flights
    fileprivate func processingOnCombinedSearchResult() {
        if flightsResults.j.count > 0 {
            InputJourneyArray = flightsResults.j
            
            let minFare = findJourneyWithCheapestFare()
            let minDuration = findJourneyWithFastestDuration()
            
            processedJourneyArray = calculateHumanScore(minFare: Float(minFare), minDuration: minDuration, processedJourneyArray)
            
            processedJourneyArray = groupSimilarFlights(processedJourneyArray)
            
            for index in 0..<self.numberOfLegs{
                applyFilters(index: index, isAPIResponseUpdated: true)
            }
            
        
        }
    }
    
    private func mergeFilters(_ flightsArray: [IntMultiCityAndReturnWSResponse.Flight]) {
        flightsArray.forEach { (flight) in
            
            if inputFilter.isEmpty {
                inputFilter = flight.results.f
                userSelectedFilters = flight.results.f
                for count in 0..<flight.results.f.count {
                    initiatedFilters[count] = []
                    appliedSubFilters[count] = []
                }
            } else {
                let latestFilterArr = flight.results.f
                inputFilter = inputFilter.enumerated().map({ (index, filterElement) in
                    let latestFilter = latestFilterArr[index]
                    var newFilter = filterElement
                    newFilter.multiAl = [newFilter.multiAl, latestFilter.multiAl].max() ?? 0
                    
                    latestFilter.cityapn.fr.forEach { (key, val) in
                        newFilter.cityapn.fr[key] = Array(Set(val + (latestFilter.cityapn.fr[key] ?? [])))
                    }
                    latestFilter.cityapn.to.forEach { (key, val) in
                        newFilter.cityapn.to[key] = Array(Set(val + (latestFilter.cityapn.to[key] ?? [])))
                    }
                    newFilter.fares = Array(Set(newFilter.fares + latestFilter.fares))
                    latestFilter.fq.forEach { (key, val) in
                        newFilter.fq[key] = val
                    }
                    newFilter.pr.minPrice = [newFilter.pr.minPrice, latestFilter.pr.minPrice].min() ?? 0
                    newFilter.pr.maxPrice = [newFilter.pr.maxPrice,
                        latestFilter.pr.maxPrice].max() ?? 0
                    newFilter.eq = Array(Set(newFilter.eq + latestFilter.eq))
                    newFilter.vcode = Array(Set(newFilter.vcode + latestFilter.vcode))
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
                    
                    newFilter.lott.minTime = compareAndGetDate(.orderedAscending, d1: newFilter.lott.minTime ?? "", d2: latestFilter.lott.minTime ?? "")
                    newFilter.lott.maxTime = compareAndGetDate(.orderedDescending, d1: newFilter.lott.maxTime ?? "", d2: latestFilter.lott.maxTime ?? "")
                    
                    newFilter.originTz.min = compareAndGetDate(.orderedAscending, d1: newFilter.originTz.min, d2: latestFilter.originTz.min)
                    newFilter.originTz.max = compareAndGetDate(.orderedDescending, d1: newFilter.originTz.max, d2: latestFilter.originTz.max)
                    
                    newFilter.destinationTz.min = compareAndGetDate(.orderedAscending, d1: newFilter.destinationTz.min, d2: latestFilter.destinationTz.min)
                    newFilter.destinationTz.max = compareAndGetDate(.orderedDescending, d1: newFilter.destinationTz.max, d2: latestFilter.destinationTz.max)
                    
                    newFilter.ap = Array(Set(newFilter.ap + latestFilter.ap))
                    
                    latestFilter.cityAp.forEach { (dict) in
                        newFilter.cityAp[dict.key] = Array(Set((newFilter.cityAp[dict.key] ?? []) + dict.value))
                    }
                    
                    return newFilter
                })
//                userSelectedFilters = inputFilter
            }
        }
    }
    
    internal func compareAndGetDate(_ type: ComparisonResult, d1: String, d2: String) -> String {
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
    
    fileprivate func mergeFlightResults(_ flightsArray  : [IntMultiCityAndReturnWSResponse.Flight] )
    {
        
        
        var currentJourneyArray = [IntMultiCityAndReturnWSResponse.Results.J]()
        
        flightsArray.forEach { (flight) in
            
            let currentResult = flight.results
//                        let vendor = flight.vcode
            
            var newJourneyArray = currentResult.setAirlinesToJourney(currentResult.j, airlineMasterTable: currentResult.alMaster)
            
            newJourneyArray = newJourneyArray.map{
                
                var journey = $0
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
            
            var modifiedJourney = journey
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
            var modifiedJourney = journey
            
            if modifiedJourney.duration == fastestJourney.duration {
                modifiedJourney.isFastest = true
            }
            else {
                modifiedJourney.isFastest = false
            }
            return modifiedJourney
        })
        
        // Minimum leg duration calculation start
        let sectionsPerJourney = processedJourneyArray.map { $0.leg.count }
        let maxSections = sectionsPerJourney.max() ?? 0
        
        // for removing journeys with insufficient data
        processedJourneyArray = processedJourneyArray.compactMap { (journey) -> IntMultiCityAndReturnWSResponse.Results.J? in
            if journey.leg.count == numberOfLegs {
                return journey
            } else {
                return nil
            }
        } // completed
        
        var minDurationForSection = [Int:Int]()
        for index in 0..<maxSections {
            let legs = processedJourneyArray.compactMap { (journey) -> IntMultiCityAndReturnWSResponse.Results.Ldet? in
                if journey.legsWithDetail.indices.contains(index) {
                    return journey.legsWithDetail[index]
                }
                return nil
            }
            let minDuration = legs.min(by: { $0.duration < $1.duration })?.duration
            minDurationForSection[index] = minDuration ?? 0
        }
        
        for index in 0..<maxSections {
            processedJourneyArray = processedJourneyArray.map ({ (journey) in
                var newJourney = journey
                if newJourney.legsWithDetail.indices.contains(index) {
                    newJourney.legsWithDetail[index].isFastest = journey.legsWithDetail[index].duration == minDurationForSection[index]
                }
                return newJourney
            })
        }
        // Minimum leg duration calculation end
        
        return fastestJourney.duration
        
    }
    
    
    fileprivate func groupSimilarFlights(_ journey : [IntMultiCityAndReturnWSResponse.Results.J] ) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        
        // Grouping of flights having same fare , Airline , number of stops and destination airport
//        let groupedFlights = Dictionary(grouping: journey, by: { String($0.farepr) + $0.al.first! + $0.stp + $0.ap.last! })
        // Added by Rishabh
        let groupedFlights = Dictionary(grouping: journey, by: { String($0.farepr) + $0.al.first! + $0.ap.first! + $0.ap.last! })
                
        var modifiedJourneyArray = [IntMultiCityAndReturnWSResponse.Results.J]()
        var index = 0
        
        for (_ , journeyArray) in groupedFlights {
            
            if journeyArray.count == 1 && index != 0 {
                index += 1
                
                var modifiedJourney = journeyArray.first!
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
                        var modifiedJourney = journey
                        modifiedJourney.groupID = index
                        modifiedJourneyArray.append(modifiedJourney)
                        
                        continue
                    }
                    
                    if ( minDuration * 1.2) >= Double(journey.duration) {
                        
                        var modifiedJourney = journey
                        modifiedJourney.groupID = index
                        modifiedJourneyArray.append(modifiedJourney)
                    }
                    else {
                        index += 1
                        minDuration = Double(journey.duration)
                        
                        var modifiedJourney = journey
                        modifiedJourney.groupID = index
                        modifiedJourneyArray.append(modifiedJourney)
                        
                    }
                }
            }
        }
        
        return modifiedJourneyArray
    }
    
    fileprivate func removeRedundantResults (_ currentJourneyArray : [IntMultiCityAndReturnWSResponse.Results.J] , newInputArray : [IntMultiCityAndReturnWSResponse.Results.J] , isDomestic : Bool) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        
        var mutableJourneyArray = currentJourneyArray
        var newjourneyArray = [IntMultiCityAndReturnWSResponse.Results.J]()
        
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
    fileprivate func updateCorpFaresFlagInResults(_ journey : [IntMultiCityAndReturnWSResponse.Results.J]) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        
        guard let corpFareResults = cooperateFareResults else { return journey }
        
        var modifiedArray = journey
        for coorporateJourney in corpFareResults {
            if let ofk = coorporateJourney.ofk {
                
                for index in 0 ..< journey.count {
                    
                    var currentJourney = journey[index]
                    
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
   fileprivate  func calculateHumanScore(minFare: Float  ,minDuration : Int    , _ journey : [IntMultiCityAndReturnWSResponse.Results.J] ) -> [IntMultiCityAndReturnWSResponse.Results.J] {
        
        
        var outputArray = journey.map { (journey) -> IntMultiCityAndReturnWSResponse.Results.J in
            
            var outputJourney = journey
            var points = Float(outputJourney.humaneScore)
            points += (journey.humanePrice.total / minFare) * 1200
            points += Float(journey.duration) / Float(minDuration) * 1000
            outputJourney.computedHumanScore = points
            return outputJourney
        }
        
        let minHumanScore = outputArray.min { (first, second) in first.computedHumanScore! < second.computedHumanScore! }
        
        
        // set property above human score threadshold bool
        
        outputArray = outputArray.map { (journey) -> IntMultiCityAndReturnWSResponse.Results.J in
            
            var outputJourney = journey
                        
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
    
    func workingOnReceived( flightsArray: [IntMultiCityAndReturnWSResponse.Flight] ,searchType : FlightSearchType) {
        isReturnJourney = searchType == RETURN_JOURNEY
        mergeFlightResults(flightsArray)
        mergeFilters(flightsArray)
        processingOnCombinedSearchResult()
    }

    
    func getOnewayJourneyDisplayArray() ->[IntMultiCityAndReturnWSResponse.Results.J]
    {
        return filteredJourneyArray
    }
    
    
    func getAirportDetailsArray() -> [String : IntMultiCityAndReturnWSResponse.Results.Apdet]{
        return flightsResults.apdet
    }
    
    func getAirlineDetailsArray() -> [String : IntMultiCityAndReturnWSResponse.Results.ALMaster]{
        return flightsResults.alMaster
    }
    
    func getTaxesDetailsArray() -> [String : String]{
        return flightsResults.taxes
    }

    func getJourneyDisplayArray() -> [IntMultiCityAndReturnWSResponse.Results.J] {
        return self.filteredJourneyArray
    }
    
    func getSortOrder() ->Sort {
        return sortOrder
    }
    
}
