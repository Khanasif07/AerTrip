//
//  FlightResultSingleJourneyVC+TableViewDelegates.swift
//  AERTRIP
//
//  Created by Appinventiv on 30/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

//MARK:- Tableview DataSource , Delegate Methods
extension FlightResultSingleJourneyVC : UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch viewModel.resultTableState {
         case .showPinnedFlights, .showTemplateResults , .showNoResults, .showRegularResults:
             return 1
         case .showExpensiveFlights :
                 return 1
         }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewModel.resultTableState == .showTemplateResults {
            return 6
        }
        
        if viewModel.resultTableState == .showPinnedFlights {
            return viewModel.results.pinnedFlights.count
        }
        
         if viewModel.resultTableState == .showExpensiveFlights {
            
            return viewModel.results.allJourneys.count
            
        }else{
            return viewModel.results.suggestedJourneyArray.count
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.resultTableState == .showTemplateResults {
                   return getTemplateCell()
        } else if viewModel.resultTableState == .showPinnedFlights {
            let journey = viewModel.results.pinnedFlights[indexPath.row]
            return getSingleJourneyCell(indexPath: indexPath ,journey: journey )
        }else{
            
            var arrayForDisplay = viewModel.results.suggestedJourneyArray
            
            if viewModel.resultTableState == .showExpensiveFlights {
                arrayForDisplay = viewModel.results.allJourneys }
            else {
                arrayForDisplay = viewModel.results.suggestedJourneyArray
            }
            
            if arrayForDisplay[indexPath.row].cellType == .singleJourneyCell {
                
                return getSingleJourneyCell(indexPath: indexPath ,journey: arrayForDisplay[indexPath.row].first )

            } else{
             
                return getGroupedFlightCell(indexPath: indexPath, journey: arrayForDisplay[indexPath.row])

            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if viewModel.resultTableState == .showTemplateResults {
            return
        }
        
        guard let journeyCell = tableView.cellForRow(at: indexPath) as? SingleJourneyResultTableViewCell, let currentJourney = journeyCell.currentJourney  else {
            return
        }
        
        navigateToFlightDetailFor(journey: currentJourney, selectedIndex: indexPath)

     
        
        
        
     //   if (tableView.cellForRow(at: indexPath) as? SingleJourneyResultTableViewCell) != nil {
   
//            if viewModel.resultTableState == .showPinnedFlights {
//                let journeyArray = pinnedFlightsArray
//                let currentJourney = journeyArray[indexPath.row]
//                navigateToFlightDetailFor(journey: currentJourney, selectedIndex: indexPath)
//                return
//            }
//
//            if viewModel.sortOrder == .Smart || viewModel.sortOrder == .Price || viewModel.sortOrder == .PriceHighToLow {
//                var arrayForDisplay = viewModel.results.suggestedJourneyArray
//
//                if viewModel.resultTableState == .showExpensiveFlights && indexPath.section == 1 {
//                    arrayForDisplay = viewModel.results.expensiveJourneyArray
//                }
//
//                 let journey = arrayForDisplay[indexPath.row]
//                    navigateToFlightDetailFor(journey:  journey.first, selectedIndex: indexPath)
//
//            }else {
//                let currentJourney =  self.sortedArray[indexPath.row]
//                navigateToFlightDetailFor(journey: currentJourney, selectedIndex: indexPath)
//            }
    //    }
    }
}
