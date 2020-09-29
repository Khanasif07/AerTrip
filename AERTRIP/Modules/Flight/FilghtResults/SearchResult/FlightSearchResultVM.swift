//
//  FlightSearchResult.swift
//  Aertrip
//
//  Created by  hrishikesh on 18/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


protocol FlightResultViewModelDelegate : class {
    func webserviceProgressUpdated(progress : Float)
    func updatedResponseReceivedAt( index: Int , filterApplied : Bool, isAPIResponseUpdated: Bool)
    func showNoResultScreenAt(index : Int)
    func showNoFilteredResultsAt(index : Int)
    func filtersApplied(_ isApplied :  Bool )
    func applySorting(sortOrder : Sort, isConditionReverced : Bool, legIndex : Int)
    func showDepartReturnSame(_ show: Bool)
}

extension FlightResultViewModelDelegate {
    func showDepartReturnSame(_ show: Bool) { }
    func applySorting(sortOrder : Sort, isConditionReverced : Bool, legIndex : Int) { }
}


@objc class FlightSearchResultVM  : NSObject {
    
    //MARK:- Search properties
    weak var delegate : FlightResultViewModelDelegate?
    let bookFlightObject : BookFlightObject
    let displayGroups : [Int]
    var flightLegs = [FlightResultDisplayGroup]()
    var intFlightLegs = [IntFlightResultDisplayGroup]()
    var comboResults = [CombinationJourney]()
    var isIntMCOrReturnJourney = false
    var numberOfLegs = 0
    let sid : String
    //MARK:- Dispatch Framework related properties
    let dispatchGroup = DispatchGroup()
    let dispatchQueue = DispatchQueue.global()
    private var workItems = [DispatchWorkItem]()

    var flightSearchParametersFromDeepLink = JSONDictionary()
    
    func cancelAllWebserviceCalls() {
        
        for workItem in workItems {
            workItem.cancel()
        }
        workItems.removeAll()
    }
    
    func executeWorkItemFor(displayGroup : Int , withDelay : Bool) {

        let workItem = DispatchWorkItem{
            self.callResultAPIFor(displayGroup)
        }
        
        workItems.append(workItem)
       
        if withDelay {
            dispatchQueue.asyncAfter(deadline: .now() + 2.0,  execute: workItem)
        }
        else {
            dispatchQueue.async(execute: workItem)
        }
        
    }
    
    
    //MARK:- Computed Properties
    var titleString : NSAttributedString {
        
        return bookFlightObject.titleString
    }
    
    var subTitleString : String {
        return bookFlightObject.subTitleString
    }
    
    var flightSearchType : FlightSearchType {
        return bookFlightObject.flightSearchType
    }

    var isDomestic : Bool {
        return bookFlightObject.isDomestic
    }
    
    var containsJourneyResuls : Bool {
        if isIntMCOrReturnJourney {
            let resultsCount =  intFlightLegs.reduce( 0 ) { $0 + $1.processedJourneyArray.count }
            return resultsCount > 0 ? true : false
        }
        
        let resultsCount =  flightLegs.reduce( 0 ) { $0 + $1.processedJourneyArray.count }
        return resultsCount > 0 ? true : false
    }
    
    var filterSummaryTitle  : String  {
        
        var filterArrayCount  = 0
        var totalCount = 0
        
        if isIntMCOrReturnJourney {
            for flightLeg in intFlightLegs {
                filterArrayCount += flightLeg.filteredJourneyArray.count
                totalCount += flightLeg.processedJourneyArray.count
            }
            
        } else {
        
            for flightLeg in flightLegs {
                filterArrayCount += flightLeg.filteredJourneyArray.count
                totalCount += flightLeg.processedJourneyArray.count
            }
        }
       
        return String(filterArrayCount) + " of " + String(totalCount) + " Results"
    }
    
    
    var flightResultArray : [FlightsResults] {
                
        let resultsArray = flightLegs.map{ return $0.flightsResults }
        return resultsArray
    }
    
    var flightLegsAppliedFilters: AppliedAndUIFilters {
        var filters = AppliedAndUIFilters()
        var appliedFilters = flightLegs.map { $0.appliedFilters }
        let uiFilters = flightLegs.map { $0.UIFilters }
        let appliedSubFilters = flightLegs.map { $0.appliedSubFilters }
        
        var containsAirport = false, containsQuality = false
        for uiFilter in uiFilters {
            if uiFilter.contains(.layoverAirports) || uiFilter.contains(.originAirports) || uiFilter.contains(.destinationAirports) {
                containsAirport = true
                break
            }
        }
        for uiFilter in uiFilters {
            if uiFilter.contains(.hideOvernight) || uiFilter.contains(.hideOvernightLayover) {
                containsQuality = true
                break
            }
        }
        if containsAirport {
            appliedFilters[0].insert(.Airport)
        }
        if containsQuality {
            appliedFilters[0].insert(.Quality)
        }
        
        filters.appliedFilters = appliedFilters
        filters.uiFilters = uiFilters
        filters.appliedSubFilters = appliedSubFilters
        return filters
    }
    
    var intFlightLegsAppliedFilters: AppliedAndUIFilters {
        var filters = AppliedAndUIFilters()
        var appliedFilters = intFlightLegs.map { $0.appliedFilters }
        let uiFilters = intFlightLegs.map { $0.UIFilters }
        let appliedSubFilters = intFlightLegs[0].appliedSubFilters.map { $0.value }
        
        var containsAirport = false, containsQuality = false
        for uiFilter in uiFilters {
            if uiFilter.contains(.layoverAirports) || uiFilter.contains(.originAirports) || uiFilter.contains(.destinationAirports) ||
                uiFilter.contains(.originDestinationSelectedForReturnJourney) {
                containsAirport = true
                break
            }
        }
        for uiFilter in uiFilters {
            if uiFilter.contains(.hideOvernight) || uiFilter.contains(.hideOvernightLayover) {
                containsQuality = true
                break
            }
        }
        if containsAirport {
            appliedFilters[0].insert(.Airport)
        }
        if containsQuality {
            appliedFilters[0].insert(.Quality)
        }
        
        filters.appliedFilters = appliedFilters
        filters.uiFilters = uiFilters
        filters.appliedSubFilters = appliedSubFilters
        return filters
    }
    
    
    var intFlightResultArray : [IntMultiCityAndReturnWSResponse.Results] {
                
        let resultsArray = intFlightLegs.map{ return $0.flightsResults }
        return resultsArray
    }
    
    //MARK:- Methods
    
    @objc  init(displayGroups : [Int], sid : String , bookFlightObject : BookFlightObject, isInternationalJourney: Bool, numberOfLegs: Int, flightSearchParameters: NSDictionary) {
        self.displayGroups = displayGroups
        self.sid = sid
        self.bookFlightObject = bookFlightObject
        self.isIntMCOrReturnJourney = isInternationalJourney
        self.numberOfLegs = numberOfLegs
        
        var flightSearchParamsDict = JSONDictionary()
        
        flightSearchParameters.forEach {
            if let key = $0.key as? String {
                flightSearchParamsDict[key] = $0.value
            }
        }
        
        self.flightSearchParametersFromDeepLink = flightSearchParamsDict
    }
    
    func segmentTitles(showSelection : Bool , selectedIndex: Int) ->  [NSAttributedString]
    {
        var filterTitles = [NSAttributedString]()
        let titleAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.black , NSAttributedString.Key.font : UIFont(name:"SourceSansPro-Regular" , size: 16)! ]
        let selectedTitleAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.black , NSAttributedString.Key.font : UIFont(name:"SourceSansPro-Semibold" , size: 16)! ]
        let dotAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.AertripColor , NSAttributedString.Key.font : UIFont(name:"SourceSansPro-Regular" , size: 16)!]
        let dotString = NSAttributedString(string: " \u{2022}", attributes: dotAttributes)
        
        var appliedFilters = Set<Filters>()
        var UIFilters = Set<UIFilters>()

        if isIntMCOrReturnJourney {
            for flightLeg in intFlightLegs {
                
                appliedFilters = appliedFilters.union(flightLeg.appliedFilters)
                UIFilters = UIFilters.union(flightLeg.UIFilters)
                
            }
            
        } else {
            for flightLeg in flightLegs {
                
                appliedFilters = appliedFilters.union(flightLeg.appliedFilters)
                UIFilters = UIFilters.union(flightLeg.UIFilters)
                
            }
        }
        
        for filter in Filters.allCases {
            
            let titleString : NSMutableAttributedString
            
            if filter.rawValue == selectedIndex  && showSelection {
                titleString = NSMutableAttributedString(string: filter.title, attributes: selectedTitleAttributes)
            }
            else {
                titleString = NSMutableAttributedString(string: filter.title, attributes: titleAttributes)
            }
            
            if  appliedFilters.contains(filter) {
                titleString.append(dotString)
            }
            
            if filter == .Price && !appliedFilters.contains(.Price)
            {
                if  UIFilters.contains(.refundableFares){
                    titleString.append(dotString)
                }
            }
            
            if filter == .Airlines && !appliedFilters.contains(.Airlines) &&  UIFilters.contains(.hideMultiAirlineItinarery) {
                titleString.append(dotString)
            }
            
            if filter == .Quality {
                if   UIFilters.contains(.hideChangeAirport) ||
                     UIFilters.contains(.hideOvernight) ||
                     UIFilters.contains(.hideChangeAirport) ||
                     UIFilters.contains(.hideOvernightLayover) {
                    titleString.append(dotString)
                }
            }
            
            if filter == .Airport {
                if  UIFilters.contains(.originAirports) ||
                    UIFilters.contains(.destinationAirports) ||
                    UIFilters.contains(.layoverAirports) ||
                    UIFilters.contains(.originDestinationSame) ||
                    UIFilters.contains(.originDestinationSelectedForReturnJourney) {
                    
                    titleString.append(dotString)
                }
            }
            
            filterTitles.append(titleString)
        }
        return  filterTitles
    }
    
    func getSortOrder() -> Sort {
        // returning sort order of 0th element as same order is applied to all legs
        if isIntMCOrReturnJourney {
            return intFlightLegs[0].getSortOrder()
        }
        return flightLegs[0].getSortOrder()
    }
    
    func getOnewayJourneyDisplayArray() ->[Journey]
    {
        let displayArray = flightLegs[0].getOnewayJourneyDisplayArray()
        return displayArray
    }
    
    func getOnewayAirportArray() -> [String : AirportDetailsWS]
    {
        let displayArray = flightLegs[0].getAirportDetailsArray()
        return displayArray
    }
    
    func getAllAirportsArray() -> [String : AirportDetailsWS]{
        var displayAirportArray = [String : AirportDetailsWS]()

        for flightLeg in flightLegs{
            
            for (airportCode , airport) in flightLeg.getAirportDetailsArray() {
                displayAirportArray[airportCode] = airport
            }
        }

        return displayAirportArray
    }
    
    func getAllIntAirportsArray() -> [String : IntMultiCityAndReturnWSResponse.Results.Apdet]{
        var displayAirportArray = [String : IntMultiCityAndReturnWSResponse.Results.Apdet]()

        for flightLeg in intFlightLegs{
            
            for (airportCode , airport) in flightLeg.getAirportDetailsArray() {
                displayAirportArray[airportCode] = airport
            }
        }

        return displayAirportArray
    }
    
    func getAirlineDetailsArray() -> [String : AirlineMasterWS]
    {
        let displayArray = flightLegs[0].getAirlineDetailsArray()
        return displayArray
    }
    
    func getIntAirlineDetailsArray() -> [String : IntMultiCityAndReturnWSResponse.Results.ALMaster]
    {
        let displayArray = intFlightLegs[0].getAirlineDetailsArray()
        return displayArray
    }
    
    func getJourneyDisplayArrayFor(index: Int)-> [Journey]
    {
        return flightLegs[index].getJourneyDisplayArray()
    }
    
    func getIntJourneyDisplayArrayFor(index: Int)-> [IntMultiCityAndReturnWSResponse.Results.J]
    {
        return intFlightLegs[index].getJourneyDisplayArray()
    }
    
    func getTaxesDetailsArray() -> [String : String]
    {
        if isIntMCOrReturnJourney {
            return intFlightLegs[0].getTaxesDetailsArray()
        }
        let displayArray = flightLegs[0].getTaxesDetailsArray()
        return displayArray
    }
    
    // Initiate Calling webservice for flight result for all display groups
    @objc func initiateResultWebService (){
       
        for displayGroup in self.displayGroups.sorted() {
            
            if isIntMCOrReturnJourney {
                let flightLeg = IntFlightResultDisplayGroup(index: displayGroup - 1, numberOfLegs: numberOfLegs)
                flightLeg.delegate = self.delegate
                self.intFlightLegs.append(flightLeg)
            }
            
            let flightLeg = FlightResultDisplayGroup(index: (displayGroup - 1))
            flightLeg.delegate = self.delegate
            
            if displayGroup != 0 {
                self.flightLegs.append( flightLeg)
            }
            self.executeWorkItemFor(displayGroup: displayGroup , withDelay: false )
        }
        
    }
    
    @objc fileprivate func callResultAPIFor(_ displayGroup : Int) {
        
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .flightSearchResult(sid: self.sid, display_group_id: "\(displayGroup)"), completionHandler: { [weak self] (data) in
            guard let self = self else { return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if self.isIntMCOrReturnJourney {
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    let response = IntMultiCityAndReturnWSResponse(JSON(json))
                    self.handleInternationalReturnAndMultiCityWS(response: response, displayGroup: displayGroup)
                }
                
            } else {
                
                if displayGroup == 0 {
                    if let currentParsedResponse = parse(data: data, into: ComboFlightSearchWSResponse.self, with:decoder) {
                        self.handleComboWebService(response: currentParsedResponse, displayGroup: displayGroup)
                    }
                }
                else {
                    
                    if let currentParsedResponse = parse(data: data, into: FlightSearchWSResponse.self, with:decoder) {
                        self.handleWebService(response: currentParsedResponse, displayGroup: displayGroup)
                    }
                }
            }

            
            } , failureHandler : { (error ) in
                
                if self.isIntMCOrReturnJourney {
                    self.delegate?.webserviceProgressUpdated(progress: 100)
                    self.delegate?.showNoResultScreenAt(index: 0)
                }
                
                print(error)
            })
    }
    
    
    // Handling Web service response
    fileprivate func workingOnReceived( flightsArray: [Flights] , displayGroup : Int) {

        flightLegs[(displayGroup - 1)].workingOnReceived(flightsArray: flightsArray ,searchType : bookFlightObject.flightSearchType, flightSearchParam: flightSearchParametersFromDeepLink)

    }
    
    func handleWebService( response  : FlightSearchWSResponse , displayGroup : Int) {
     
        // updating webservice progess on progressbar
        let progress = response.data?.completed ?? 25
        self.delegate?.webserviceProgressUpdated(progress: Float( progress) / 100.0)
        
        guard let responseData = response.data else {
            self.executeWorkItemFor(displayGroup: displayGroup, withDelay: true)
            return
            
        }
        
        // if webservice progress is not 100 % , poll web services results
        let done = responseData.done ?? false
        
        if !done {
            // Polling for remaining flight results
            self.executeWorkItemFor(displayGroup: displayGroup, withDelay: true)
        }
        

        // Processing on received web service response
        guard let flightsArray = responseData.flights  else {
            return
        }
        if let taxSort = flightsArray.first?.results.taxSort,  !taxSort.isEmpty{
            self.bookFlightObject.taxSort = taxSort
        }
        if flightsArray.count == 0 {
            if (progress == 100 || done ) {
                
                for flightLeg in flightLegs {
                    
                    if flightLeg.processedJourneyArray.count == 0 {
                        self.delegate?.showNoResultScreenAt(index: flightLeg.index)
                    }
                }
                
            }
            return
        }
        
        workingOnReceived(flightsArray: flightsArray, displayGroup: displayGroup )

        
    }
    
    
    func handleComboWebService( response  : ComboFlightSearchWSResponse , displayGroup : Int) {
        
        // updating webservice progess on progressbar
        let progress = response.data?.completed ?? 25
        self.delegate?.webserviceProgressUpdated(progress: Float( progress) / 100.0)

        guard let responseData = response.data else {
            self.executeWorkItemFor(displayGroup: displayGroup, withDelay: true)
            return
        }
        
//        // if webservice progress is not 100 % , poll web services results
        let done = responseData.done ?? false

        if !done {
            // Polling for remaining flight results
            self.executeWorkItemFor(displayGroup: displayGroup, withDelay: true)
        }
        
        guard let flightsArray = responseData.flights  , flightsArray.count > 0 else {
            return
        }
        if let taxSort = flightsArray.first?.results.taxSort,  !taxSort.isEmpty{
            self.bookFlightObject.taxSort = taxSort
        }
        for comboflight in flightsArray {
            let compoJounrneys = comboflight.results.c
            comboResults.append(contentsOf: compoJounrneys)
        }
    }
}

// MARK: International Return and Multicity
extension FlightSearchResultVM {
    func handleInternationalReturnAndMultiCityWS( response: IntMultiCityAndReturnWSResponse, displayGroup: Int) {
        
        // updating webservice progess on progressbar
        let progress = response.data?.completed ?? 25

        self.delegate?.webserviceProgressUpdated(progress: Float( progress) / 100.0)
        
        guard let responseData = response.data else {
            self.executeWorkItemFor(displayGroup: displayGroup, withDelay: true)
            return
            
        }
        
        // if webservice progress is not 100 % , poll web services results
        let done = responseData.done
        
        if !done {
            // Polling for remaining flight results
            self.executeWorkItemFor(displayGroup: displayGroup, withDelay: true)
        }
        
        
        // Processing on received web service response
        guard let flightsArray = responseData.flights  else {
            return
        }
        if flightsArray.count == 0 {
            checkForNoIntMCAndReturnResult(progress, done)
            return
        }
        
        workingOnReceived(flightsArray: flightsArray, displayGroup: displayGroup)
        checkForNoIntMCAndReturnResult(progress, done)
    }
    
    private func checkForNoIntMCAndReturnResult(_ progress: Int,_ done: Bool) {
        if (progress == 100 || done ) {
            for leg in intFlightLegs {
                if  leg.processedJourneyArray.count == 0 {
                    self.delegate?.showNoResultScreenAt(index: leg.index)
                }
            }
        }
    }
    
    fileprivate func workingOnReceived( flightsArray: [IntMultiCityAndReturnWSResponse.Flight] , displayGroup : Int) {
        intFlightLegs[(displayGroup - 1)].workingOnReceived(flightsArray: flightsArray ,searchType : bookFlightObject.flightSearchType, flightSearchParam: flightSearchParametersFromDeepLink)
    }
}

struct AppliedAndUIFilters {
    var uiFilters: [Set<UIFilters>] = []
    var appliedFilters: [Set<Filters>] = []
    var appliedSubFilters: [Set<FlightResultDisplayGroup.InitiatedFilters>] = []
}


// For Deep-linking/Aerin Filters
extension FlightSearchResultVM {
    func getUserSelectedFilters() -> [FiltersWS] {
        var userSelectedFilters = [FiltersWS]()
        self.flightLegs.forEach { (leg) in
            if let userAppliedFilter = leg.userSelectedFilters {
                userSelectedFilters.append(userAppliedFilter)
            }
        }
        return userSelectedFilters
    }
    
    func getIntUserSelectedFilters() -> [IntMultiCityAndReturnWSResponse.Results.F] {
        return self.intFlightLegs[0].userSelectedFilters
    }
}
