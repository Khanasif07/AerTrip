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
                
                return getSingleJourneyCell(indexPath: indexPath ,journey:  arrayForDisplay[indexPath.row].journeyArray.first)

            } else{
             
                return getGroupedFlightCell(indexPath: indexPath, journey: arrayForDisplay[indexPath.row])

            }
            
        }
    }
    
    //MARK:- Methods to get different types of cells
    func getTemplateCell () -> UITableViewCell {
        
        if let cell =  resultsTableView.dequeueReusableCell(withIdentifier: "SingleJourneyTemplateCell") {
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func getSingleJourneyCell (indexPath : IndexPath , journey : Journey?  ) -> UITableViewCell {
        
        if let cell =  resultsTableView.dequeueReusableCell(withIdentifier: "SingleJourneyResultTableViewCell") as? SingleJourneyResultTableViewCell{
            
            if #available(iOS 13, *) {
                if cell.baseView.interactions.isEmpty{
                    let interaction = UIContextMenuInteraction(delegate: self)
                    cell.baseView.addInteraction(interaction)
                }
            }
            
            cell.selectionStyle = .none
            cell.setTitlesFrom( journey : journey)
            if let logoArray = journey?.airlineLogoArray {
                
                switch logoArray.count {
                    
                case 1 :
                    
                    cell.logoTwo.isHidden = true
                    cell.logoThree.isHidden = true
                    setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                case 2 :
                    
                    cell.logoThree.isHidden = true
                    setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                    setImageto(imageView: cell.logoTwo, url:logoArray[1] , index:  indexPath.row)
                    
                case 3 :
                    setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                    setImageto(imageView: cell.logoTwo, url:logoArray[1] , index:  indexPath.row)
                    setImageto(imageView: cell.logoThree, url:logoArray[2] , index:  indexPath.row)
                    
                default:
                    break
                }
            }
            return cell
        }
        assertionFailure("Failed to create SingleJourneyResultTableViewCell cell ")
        
        return UITableViewCell()
    }
    
    
    func getGroupedFlightCell( indexPath : IndexPath , journey : JourneyOnewayDisplay  ) -> UITableViewCell {
        
        if #available(iOS 13.0, *) {
            if let cell =  resultsTableView.dequeueReusableCell(withIdentifier: "GroupedFlightCell") as? GroupedFlightCell {
                cell.selectionStyle = .none
                cell.delegate = self
                cell.setVaulesFrom(journey: journey)
                cell.buttonTapped = {
                    self.reloadTableCell(indexPath)
                }
                return cell
            }
        } else {
            // Fallback on earlier versions
        }
        assertionFailure("Failed to create GroupedFlightCell ")
        
        return UITableViewCell()
    }
    
    func reloadTableCell(_ indexPath: IndexPath){
        
        DispatchQueue.main.async {
            self.resultsTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
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
