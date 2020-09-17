//
//  FlightDomesticMultiLegResultVC+DataReceivingFlow.swift
//  AERTRIP
//
//  Created by Appinventiv on 27/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension FlightDomesticMultiLegResultVC {
    
        func updatewithArray(index : Int , updatedArray : [Journey] , sortOrder : Sort) {
            
    //        for j in updatedArray{
    //            let flightNum = j.leg.first!.flights.first!.al + j.leg.first!.flights.first!.fn
    //            if flightNum.uppercased() == airlineCode.uppercased(){
    //                j.isPinned = true
    //            }
    //        }
            
            if viewModel.resultsTableStates[index] == .showTemplateResults {
                viewModel.resultsTableStates[index] = .showRegularResults
            }
            
            self.flightSearchResultVM.flightLegs[index].updatedFilterResultCount = 0

         let modifiedResult = updatedArray

            DispatchQueue.global(qos: .userInteractive).async {

                self.viewModel.results[index].sort = sortOrder
                self.viewModel.sortOrder = sortOrder
                
                self.viewModel.results[index].currentPinnedJourneys.forEach { (pinedJourney) in
                               if let resultIndex = updatedArray.firstIndex(where: { (resultJourney) -> Bool in
                                   return pinedJourney.id == resultJourney.id
                               }){
                                   modifiedResult[resultIndex].isPinned = true
                               }
                           }
                
                self.viewModel.results[index].journeyArray = modifiedResult
                
//                self.viewModel.setPinnedFlights(tableIndex: index)
                
                self.applySorting(sortOrder: self.viewModel.sortOrder, isConditionReverced: self.viewModel.isConditionReverced, legIndex: index, completion: {
                    DispatchQueue.main.async {
                    self.animateTableBanner(index: index , updatedArray: updatedArray, sortOrder: sortOrder)
                        
//                        if (self.viewModel.resultTableState[index] == .showPinnedFlights) ||
//                            (self.viewModel.results.suggestedJourneyArray.isEmpty) ||
//                            (self.viewModel.results.suggestedJourneyArray.count == self.viewModel.results.journeyArray.count) {
//                            self.resultsTableView.tableFooterView = nil
//                        }
                        
                    NotificationCenter.default.post(name:NSNotification.Name("updateFilterScreenText"), object: nil)
                    }
                })
            }
        }
    
    func applySorting(sortOrder : Sort, isConditionReverced : Bool, legIndex : Int, shouldReload : Bool = false, completion : (()-> Void)){
//        previousRequest?.cancel()
        self.viewModel.sortOrder = sortOrder
        self.viewModel.isConditionReverced = isConditionReverced
        self.viewModel.prevLegIndex = legIndex
//        self.viewModel.setPinnedFlights(tableIndex: legIndex)

        self.viewModel.applySorting(tableIndex: legIndex, sortOrder: sortOrder, isConditionReverced: isConditionReverced, legIndex: legIndex)
                
        let newRequest = DispatchWorkItem {
            if shouldReload {
                guard let tableView = self.baseScrollView.viewWithTag( 1000 + legIndex) as? UITableView else { return }
                tableView.reloadData()
            }
        }
        
        completion()
//        previousRequest = newRequest
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: newRequest)
    }
    
    
    //MARK:- Additional UI Methods
       func animateTableBanner(index : Int , updatedArray : [Journey] , sortOrder :Sort)  {
           if bannerView?.isHidden == false {
               guard let headerView = bannerView  else { return }
               
               var rect = headerView.frame
               baseScrollViewTop.constant = 0
               
               UIView.animate(withDuration: 1.0 , animations: {
                   let y = rect.origin.y - rect.size.height - 20
                   rect.origin.y = y
                   headerView.frame = rect
                   self.view.layoutIfNeeded()
                   
                   for subview in self.baseScrollView.subviews {
                       if let tableView = subview as? UITableView {
                           let width = UIScreen.main.bounds.size.width / 2.0
                           let headerRect = CGRect(x: 0, y: 0, width: width, height: 138.0)
                           tableView.tableHeaderView = UIView(frame: headerRect)
                       }
                   }
                   
               }) { (bool) in
                   self.baseScrollView.setContentOffset(CGPoint(x: 0, y: 0) , animated: false)
                   self.bannerView?.isHidden = true
                   self.updateUI(index: index, updatedArray : updatedArray, sortOrder: sortOrder)
               }
           }
           else {
               self.updateUI(index: index , updatedArray: updatedArray, sortOrder: sortOrder)
           }
       }
       
          func updateUI(index : Int , updatedArray : [Journey] , sortOrder : Sort) {
           
               let currentState =  viewModel.resultsTableStates[index]
               if currentState == .showTemplateResults || currentState == .showNoResults {
                   if updatedArray.count == 0 {
                       return
                   }
                
                   viewModel.resultsTableStates[index] = .showRegularResults
               
            }
           
               DispatchQueue.main.async {
                   if let errorView = self.baseScrollView.viewWithTag( 500 + index) {
                       if updatedArray.count > 0 {
                           errorView.removeFromSuperview()
                       }
                   }
                       self.updateUIForTableviewAt(index)
                       

               }
           }
    
     func updateUIForTableviewAt(_ index: Int) {
            DispatchQueue.main.async {
                guard let tableView = self.baseScrollView.viewWithTag( 1000 + index) as? UITableView else { return }
//                let selectedIndex = tableView.indexPathForSelectedRow
//                tableView.reloadData()

                    // setting up header for table view
                    let width = UIScreen.main.bounds.size.width / 2.0
                    let headerRect = CGRect(x: 0, y: 0, width: width, height: 138.0)
                    tableView.tableHeaderView = UIView(frame: headerRect)

                    //selecting tableview cell
//                    if (selectedIndex != nil) {
//                        tableView.selectRow(at:selectedIndex, animated: false, scrollPosition: .none)
//                    }
//
//                    let indexPath : IndexPath
//                    if (self.viewModel.results[index].suggestedJourneyArray.count > 0 ) {
//                        indexPath = IndexPath(row: 0, section: 0)
//                        tableView.selectRow(at: indexPath , animated: false, scrollPosition: .none)
//                        self.hideHeaderCellAt(index: index)
//                    } else  {
//                        if (self.viewModel.results[index].allJourneys.count > 0 ){
//                            indexPath = IndexPath(row: 0, section: 0)
//                            tableView.selectRow(at: indexPath , animated: false, scrollPosition: .none)
//                            self.hideHeaderCellAt(index: index)
//                        }
//                        else {
//                            print("Into Else else")
//                        }
//                    }
//
                
//                if self.viewModel.results[index].selectedJourney == nil{
//                    self.viewModel.results[index].selectedJourney = self.viewModel.results[index].suggestedJourneyArray.first
//
//                }
            
                    tableView.isScrollEnabled = true
                
                ///............
                
                //setting footer for table view
                
                if self.viewModel.results[index].suggestedJourneyArray.isEmpty && (self.viewModel.resultsTableStates[index] != .showPinnedFlights  ) { self.viewModel.resultsTableStates[index] = .showExpensiveFlights
                }
                
                 if self.viewModel.resultsTableStates[index] == .showPinnedFlights{
                    tableView.tableFooterView = nil
                 } else if self.viewModel.resultsTableStates[index] == .showExpensiveFlights{
                    
                    if self.viewModel.results[index].suggestedJourneyArray.count != 0{
                        self.setExpandedStateFooterAt(index: index)
                    }else{
                        tableView.tableFooterView = nil
                    }
                
                 }else {
                    
                    if self.viewModel.results[index].suggestedJourneyArray.count == 0{
                        
                        self.tappedOnGroupedFooterView(UITapGestureRecognizer())
                        tableView.tableFooterView = nil

                    }else{
                        self.setGroupedFooterViewAt(index: index)
                    }
                    
                }
                
//                self.viewModel.setSelectedJourney(tableIndex: index, journeyIndex: 0)
                
                self.viewModel.selectFlightsInInitialFlow(tableIndex: index)
                
                self.checkForOverlappingFlights(shouldDisplayToast: false)
                
                tableView.isScrollEnabled = true
                tableView.scrollsToTop = true
                tableView.reloadData()
                

                
    //            if self.viewModel.resultsTableStates[index] == .showExpensiveFlights {
    //                self.setExpandedStateFooterAt(index: index)
    //            }else if self.viewModel.resultsTableStates[index] != .showPinnedFlights{
    //                if self.results[index].suggestedJourneyArray.count == 0{
    //                    let invisibleView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    //                    invisibleView.tag = index
    //                    let tap = UITapGestureRecognizer()
    //                    invisibleView.addGestureRecognizer(tap)
    //                    self.tappedOnGroupedFooterView(tap)
    //
    //                    if let tableView = self.baseScrollView.viewWithTag( 1000 + index) as? UITableView {
    //                        tableView.tableFooterView = nil
    //                    }
    //                }else{
    //                    self.setGroupedFooterViewAt(index: index)
    //                }
    //            }
                
                self.setTotalFare()
            }
        }
    
    
    
    
    
    
}