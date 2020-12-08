//
//  IntMCAndReturnVC+DataReceivingFlow.swift
//  AERTRIP
//
//  Created by Admin on 24/09/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension IntMCAndReturnVC {
    
    
      func updateWithArray(_ results : [IntMultiCityAndReturnWSResponse.Results.J] , sortOrder: Sort ) {
            
            if viewModel.resultTableState == .showTemplateResults {
                viewModel.resultTableState = .showRegularResults
            }
            
            var modifiedResult = results
            
    //        for i in 0..<modifiedResult.count {
    //            var isFlightCodeSame = false
    //            for leg in modifiedResult[i].legsWithDetail{
    //                for flight in leg.flightsWithDetails{
    //                    let flightNum = flight.al + flight.fn
    //                    if flightNum.uppercased() == airlineCode.uppercased(){
    //                        isFlightCodeSame = true
    //                    }
    //                }
    //            }
    //
    //            if isFlightCodeSame == true{
    //                modifiedResult[i].isPinned = true
    //
    //            }
    //        }
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.viewModel.sortOrder = sortOrder
                self.viewModel.results.sort = sortOrder
                
                self.viewModel.results.currentPinnedJourneys.forEach { (pinedJourney) in
                    if let resultIndex = results.firstIndex(where: { (resultJourney) -> Bool in
                        return pinedJourney.id == resultJourney.id
                    }){
                        modifiedResult[resultIndex].isPinned = true
                    }
                }
                
                
                if !self.airlineCode.isEmpty{

                    modifiedResult.enumerated().forEach { (journInd,jour) in
                        
                        jour.legsWithDetail.enumerated().forEach { (legInd, leg) in
                            
                            leg.flightsWithDetails.enumerated().forEach { (fliInd,flight) in
                                
                                let flightNum = flight.al + flight.fn
                                                          
                                    if flightNum.uppercased() == self.airlineCode.uppercased(){
                                        
                                        self.viewModel.results.currentPinnedJourneys.append(jour)
                                        self.viewModel.results.currentPinnedJourneys = self.viewModel.results.currentPinnedJourneys.removeDuplicates()
                                        self.viewModel.isSearchByAirlineCode = true
                                        modifiedResult[journInd].isPinned = true
                                }
                            
                            }
                            
                        }
                        
                    }
                    
                }
                
                
                if !self.viewModel.sharedFks.isEmpty {
                          
                              modifiedResult.enumerated().forEach { (ind,jour) in
                                              
                                  if self.viewModel.sharedFks.contains(jour.fk){
                                      
                                        self.viewModel.results.currentPinnedJourneys.append(jour)
                                        self.viewModel.results.currentPinnedJourneys = self.viewModel.results.currentPinnedJourneys.removeDuplicates()
                                        self.viewModel.isSearchByAirlineCode = true
                                        modifiedResult[ind].isPinned = true
                                      
                                  }
                                  
                          }
                          
                      }
                
                
                
                let groupedArray =  self.viewModel.getInternationalDisplayArray(results: modifiedResult)
                self.viewModel.results.journeyArray = groupedArray
                self.sortedArray = Array(self.viewModel.results.sortedArray)
                self.viewModel.setPinnedFlights(shouldApplySorting: true)
                
                self.applySorting(sortOrder: self.viewModel.sortOrder, isConditionReverced: self.viewModel.isConditionReverced, legIndex: self.viewModel.prevLegIndex, completion: {
                    DispatchQueue.main.async {
                        self.animateTableHeader()
                        
                        if self.viewModel.resultTableState == .showPinnedFlights{
                            self.resultsTableView.tableFooterView = nil
                        }
                        
                        if self.viewModel.results.suggestedJourneyArray.isEmpty {
                            self.resultsTableView.tableFooterView = nil
                        }
                        
                        if self.viewModel.resultTableState == .showPinnedFlights && self.viewModel.results.pinnedFlights.isEmpty {
                            self.showNoFilteredResults()
                        } else if modifiedResult.count > 0 {
                            self.noResultScreen?.view.removeFromSuperview()
                            self.noResultScreen?.removeFromParent()
                            self.noResultScreen = nil
                        }
                        
                        if self.viewModel.isSearchByAirlineCode || self.viewModel.isSharedFkmatched  {
                    
                            delay(seconds: 1) {
                                self.switchView.isOn = true
                                self.switcherDidChangeValue(switcher: self.switchView, value: true)
                                self.showPinnedFlightsOption(true)
                            }
                            
                        }
                        
                        
                        
//                        if !self.airlineCode.isEmpty{
//
//                            for i in 0..<modifiedResult.count {
//                                  var isFlightCodeSame = false
//                                  for leg in modifiedResult[i].legsWithDetail{
//                                      for flight in leg.flightsWithDetails{
//                                          let flightNum = flight.al + flight.fn
//                                        if flightNum.uppercased() == self.airlineCode.uppercased(){
//                                              isFlightCodeSame = true
//                                          }
//                                      }
//                                  }
//
//                                  if isFlightCodeSame == true{
//    //                                  modifiedResult[i].isPinned = true
//                                    self.setPinnedFlightAt(modifiedResult[i].fk , isPinned: true)
//                                    self.switchView.isOn = true
//                                    self.switcherDidChangeValue(switcher: self.switchView, value: true)
//                                  }
//                              }
//                        }
                        
                    }
                })
            }
        }
        
        func applySorting(sortOrder : Sort, isConditionReverced : Bool, legIndex : Int, shouldReload : Bool = false, completion : (()-> Void)){
            previousRequest?.cancel()
            self.viewModel.sortOrder = sortOrder
            self.viewModel.isConditionReverced = isConditionReverced
            self.viewModel.prevLegIndex = legIndex
            self.viewModel.setPinnedFlights(shouldApplySorting: true)
            self.viewModel.applySorting(sortOrder: sortOrder, isConditionReverced: isConditionReverced, legIndex: legIndex)
           
                let newRequest = DispatchWorkItem {
                    if shouldReload {
                        self.resultsTableView.reloadData()
                    }
                }
            
            completion()
            previousRequest = newRequest
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: newRequest)
        }
        
        func updateAirportDetailsArray(_ results : [String : IntAirportDetailsWS]) {
            airportDetailsResult = results
        }
        
        func updateAirlinesDetailsArray(_ results : [String : IntAirlineMasterWS]) {
            airlineDetailsResult = results
        }
        
        func updateTaxesArray(_ results : [String : String]){
            self.taxesResult = results
        }
        
    
    
    
}
