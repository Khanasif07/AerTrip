//
//  FlightResultSingleJourneyVC+DataReceivingFlow.swift
//  AERTRIP
//
//  Created by Appinventiv on 20/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension FlightResultSingleJourneyVC {
    
    func updateWithArray(_ results : [Journey] , sortOrder: Sort ) {
        
        if viewModel.resultTableState == .showTemplateResults {
            viewModel.resultTableState = .showRegularResults
        }
        
//                var sharedUrlPF = ""
//                if ((self.flightSearchParameters?["PF[]"] as? String) != nil){
//                    sharedUrlPF = self.flightSearchParameters?["PF[]"] as? String ?? ""
//                }
//
//        printDebug("flightSearchParameters...\(self.flightSearchParameters)")
//
//                if sharedUrlPF != ""{
//                    for j in results{
//                        if j.fk == sharedUrlPF{
//                         //   j.isPinned = true
//                        }
//                    }
//                }
        
        let modifiedResult = results
        
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
            
            if !self.viewModel.airlineCode.isEmpty{
                
//                printDebug("self.viewModel.airlineCode...\(self.viewModel.airlineCode)")
                
                modifiedResult.enumerated().forEach { (ind,jour) in
                    
                    if let firstleg = jour.leg.first, let firstFlight = firstleg.flights.first {
                        
                        let flightNum = firstFlight.al + firstFlight.fn
                        
//                        printDebug("flightNum...\(flightNum)")
                        
                        if flightNum.uppercased() == self.viewModel.airlineCode.uppercased() {
                            
//                            printDebug("match...\(flightNum)....\(jour.airlinesSubString)")
                            
                            self.viewModel.results.currentPinnedJourneys.append(jour)
                            self.viewModel.results.currentPinnedJourneys = self.viewModel.results.currentPinnedJourneys.removeDuplicates()
                            self.viewModel.isSearchByAirlineCode = true
                            modifiedResult[ind].isPinned = true
                            
                        }
                    }
                }
            }
            
            
            
            
            if !self.viewModel.sharedFks.isEmpty {
                
                    modifiedResult.enumerated().forEach { (ind,jour) in
                                    
                        if self.viewModel.sharedFks.contains(jour.fk){
                            
                            self.viewModel.results.currentPinnedJourneys.append(jour)
                            self.viewModel.results.currentPinnedJourneys = self.viewModel.results.currentPinnedJourneys.removeDuplicates()
                            self.viewModel.isSharedFkmatched = true
                            modifiedResult[ind].isPinned = true
                            
                        }
                        
                }
                
            }
            

            let groupedArray =   self.viewModel.getOnewayDisplayArray(results: modifiedResult)
            self.viewModel.results.journeyArray = groupedArray
            //            self.viewModel.setPinnedFlights(shouldApplySorting: true)
            
            self.applySorting(sortOrder: self.viewModel.sortOrder, isConditionReverced: self.viewModel.isConditionReverced, legIndex: 0, completion: {
                DispatchQueue.main.async {
                    self.animateTableHeader()
                    
                    if (self.viewModel.resultTableState == .showPinnedFlights) ||
                        (self.viewModel.results.suggestedJourneyArray.isEmpty) ||
                        (self.viewModel.results.suggestedJourneyArray.count == self.viewModel.results.journeyArray.count) {
                        self.resultsTableView.tableFooterView = nil
                    }
                    
                    if self.viewModel.resultTableState == .showPinnedFlights && self.viewModel.results.pinnedFlights.isEmpty {
                        self.showNoFilteredResults()
                    } else if modifiedResult.count > 0 {
                        self.noResultScreen?.view.removeFromSuperview()
                        self.noResultScreen?.removeFromParent()
                        self.noResultScreen = nil
                    }
                    
                    if self.viewModel.isSearchByAirlineCode || self.viewModel.isSharedFkmatched {
                        delay(seconds: 1) {
                            self.switchView.isOn = true
                            self.switcherDidChangeValue(switcher: self.switchView, value: true)
                            self.showPinnedFlightsOption(true)
                        }
                    }
                    
                    
                    //
                    //                    if !self.viewModel.airlineCode.isEmpty{
                    //
                    //                        printDebug("self.viewModel.airlineCode...\(self.viewModel.airlineCode)")
                    //
                    //                        for journ in modifiedResult {
                    //                            let flightNum = journ.leg.first!.flights.first!.al + journ.leg.first!.flights.first!.fn
                    //
                    //                            printDebug("flightNum...\(flightNum)")
                    //
                    //                            if flightNum.uppercased() == self.viewModel.airlineCode.uppercased() {
                    //
                    //                                print("flightNum....matched\(flightNum.uppercased())")
                    //                                self.setPinnedFlightAt(journ.fk , isPinned: true)
                    //                                self.switchView.isOn = true
                    //                                self.switcherDidChangeValue(switcher: self.switchView, value: true)
                    //                            }
                    //                        }
                    //                    }
                }
            })
        }
    }
    
    
    func animateTableHeader() {
        if bannerView?.isHidden == false {
            guard let headerView = bannerView  else { return }
            
            let rect = headerView.frame
            
            UIView.animate(withDuration: 1) {
                self.resultsTableViewTop.constant = 0
                self.view.layoutIfNeeded()
            }
            
            UIView.animate(withDuration: 1.0 , animations: {
                let y = rect.origin.y - rect.size.height - 20
                headerView.frame = CGRect(x: 0, y: y , width: UIScreen.main.bounds.size.width, height: 156)
                self.view.layoutIfNeeded()
                
            }) { (bool) in
                
                self.bannerView?.isHidden = true
                self.updateUI()
            }
        } else {
            self.updateUI()
        }
    }
    
    func updateUI() {
        let rect = self.resultsTableView.rectForRow(at: IndexPath(row: 0, section: 0))
        self.resultsTableView.scrollRectToVisible(rect, animated: true)
        
        if self.viewModel.results.suggestedJourneyArray.isEmpty && viewModel.resultTableState != .showPinnedFlights { viewModel.resultTableState = .showExpensiveFlights
        }
        
        if viewModel.resultTableState == .showPinnedFlights {
            resultsTableView.tableFooterView = nil
        }else if self.viewModel.resultTableState == .showExpensiveFlights {
            if self.viewModel.results.suggestedJourneyArray.count != 0{
                self.setExpandedStateFooter()
            }else{
                resultsTableView.tableFooterView = nil
            }
        }else {
            if self.viewModel.results.suggestedJourneyArray.count == 0{
                tappedOnGroupedFooterView(UITapGestureRecognizer())
                resultsTableView.tableFooterView = nil
            }else{
                self.setGroupedFooterView()
            }
        }
        
        self.resultsTableView.isScrollEnabled = true
        self.resultsTableView.scrollsToTop = true
        self.resultsTableView.reloadData()
    }
    
    func applySorting(sortOrder : Sort, isConditionReverced : Bool, legIndex : Int, shouldReload : Bool = false, completion : (()-> Void)){
        previousRequest?.cancel()
        self.viewModel.sortOrder = sortOrder
        self.viewModel.isConditionReverced = isConditionReverced
        //  self.viewModel.prevLegIndex = legIndex
        
        self.viewModel.applySortingOnGroups(sortOrder: sortOrder, isConditionReverced: isConditionReverced, legIndex: legIndex)
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
    
    
    func updateAirportDetailsArray(_ results : [String : AirportDetailsWS]) {
        self.viewModel.airportDetailsResult = results
    }
    
    func updateAirlinesDetailsArray(_ results : [String : AirlineMasterWS]) {
        self.viewModel.airlineDetailsResult = results
    }
    
    func updateTaxesArray(_ results : [String : String]) {
        self.viewModel.taxesResult = results
    }
    
    
    
}
