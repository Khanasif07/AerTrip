//
//  IntFlightSearchResultVM.swift
//  Aertrip
//
//  Created by Rishabh on 21/04/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

@objc class IntFlightSearchResultVM  : NSObject {
    
    //MARK:- Search properties
    weak var delegate : FlightResultViewModelDelegate?
    let bookFlightObject : BookFlightObject
    let displayGroups : [Int]
    var intFlightLegs = [IntFlightResultDisplayGroup]()
    var isInternationalJourney = false
    let sid : String
    //MARK:- Dispatch Framework related properties
    let dispatchGroup = DispatchGroup()
    let dispatchQueue = DispatchQueue.global()
    private var workItems = [DispatchWorkItem]()
    
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
        
        let resultsCount =  intFlightLegs.reduce( 0 ) { $0 + $1.processedJourneyArray.count }
        return resultsCount > 0 ? true : false
    }
    
    var filterSummaryTitle  : String  {
        
        var filterArrayCount  = 0
        var totalCount = 0
        
        for flightLeg in intFlightLegs {
            filterArrayCount += flightLeg.filteredJourneyArray.count
            totalCount += flightLeg.processedJourneyArray.count
        }
       
        return String(filterArrayCount) + " of " + String(totalCount) + " Results"
    }
    
    var flightResultArray : [IntMultiCityAndReturnWSResponse.Results] {
                
        let resultsArray = intFlightLegs.map{ return $0.flightsResults }
        return resultsArray
    }
    
    //MARK:- Methods
    
    @objc  init(displayGroups : [Int], sid : String , bookFlightObject : BookFlightObject, isInternationalJourney: Bool) {
        self.displayGroups = displayGroups
        self.sid = sid
        self.bookFlightObject = bookFlightObject
        self.isInternationalJourney = isInternationalJourney
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

        for flightLeg in intFlightLegs {
            
           appliedFilters = appliedFilters.union(flightLeg.appliedFilters)
           UIFilters = UIFilters.union(flightLeg.UIFilters)

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
                if   UIFilters.contains(.originAirports) ||
                     UIFilters.contains(.destinationAirports) ||
                     UIFilters.contains(.layoverAirports)  {
                    titleString.append(dotString)
                }
            }
            
            filterTitles.append(titleString)
        }
        return  filterTitles
    }
    
    func getSortOrder() -> Sort {
        // returning sort order of 0th element as same order is applied to all legs
        return intFlightLegs[0].getSortOrder()
    }
    
    func getOnewayJourneyDisplayArray() ->[IntMultiCityAndReturnWSResponse.Results.J]
    {
        let displayArray = intFlightLegs[0].getOnewayJourneyDisplayArray()
        return displayArray
    }
    
    func getOnewayAirportArray() -> [String : IntMultiCityAndReturnWSResponse.Results.Apdet]
    {
        let displayArray = intFlightLegs[0].getAirportDetailsArray()
        return displayArray
    }
    
    func getAllAirportsArray() -> [String : IntMultiCityAndReturnWSResponse.Results.Apdet]{
        var displayAirportArray = [String : IntMultiCityAndReturnWSResponse.Results.Apdet]()

        for flightLeg in intFlightLegs{
            
            for (airportCode , airport) in flightLeg.getAirportDetailsArray() {
                displayAirportArray[airportCode] = airport
            }
        }

        return displayAirportArray
    }
    
    func getAirlineDetailsArray() -> [String : IntMultiCityAndReturnWSResponse.Results.ALMaster]
    {
        let displayArray = intFlightLegs[0].getAirlineDetailsArray()
        return displayArray
    }
    
    func getJourneyDisplayArrayFor(index: Int)-> [IntMultiCityAndReturnWSResponse.Results.J]
    {
        return intFlightLegs[index].getJourneyDisplayArray()
    }
    
    func getTaxesDetailsArray() -> [String : String]
    {
        let displayArray = intFlightLegs[0].getTaxesDetailsArray()
        return displayArray
    }
    
    // Initiate Calling webservice for flight result for all display groups
    @objc func initiateResultWebService (){
       
        for displayGroup in self.displayGroups.sorted() {
            
            if isInternationalJourney {
                let flightLeg = IntFlightResultDisplayGroup(index: displayGroup - 1)
                flightLeg.delegate = self.delegate
                self.intFlightLegs.append(flightLeg)
            }
            self.executeWorkItemFor(displayGroup: displayGroup , withDelay: false )
        }
        
    }
    
    @objc fileprivate func callResultAPIFor(_ displayGroup : Int) {
        
        
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .flightSearchResult(sid: self.sid, display_group_id: "\(displayGroup)"), completionHandler: { [weak self]    (data) in
            guard let self = self else { return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if self.isInternationalJourney {
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    let response = IntMultiCityAndReturnWSResponse(JSON(json))
                    self.handleInternationalReturnAndMultiCityWS(response: response, displayGroup: displayGroup)
                }
                
            }
            
            } , failureHandler : { (error ) in
                
                print(error)
            })
    }
    
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
            return
        }
        
        workingOnReceived(flightsArray: flightsArray, displayGroup: displayGroup)
        
        if (progress == 100 || done ) {
            
            for flightLeg in intFlightLegs {
                
                if flightLeg.processedJourneyArray.count == 0 {
                    self.delegate?.showNoResultScreenAt(index: flightLeg.index)
                }
            }
        }
    }
    
    fileprivate func workingOnReceived( flightsArray: [IntMultiCityAndReturnWSResponse.Flight] , displayGroup : Int) {

            intFlightLegs[(displayGroup - 1)].workingOnReceived(flightsArray: flightsArray ,searchType : bookFlightObject.flightSearchType)

    
    }
}
