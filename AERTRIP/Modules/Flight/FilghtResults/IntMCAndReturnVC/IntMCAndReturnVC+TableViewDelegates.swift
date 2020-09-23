//
//  FlightInternationalMultiLegResultVC+TableViewDelegates.swift
//  Aertrip
//
//  Created by Appinventiv on 24/04/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation

//MARK:- Tableview DataSource , Delegate Methods
extension IntMCAndReturnVC : UITableViewDataSource , UITableViewDelegate {
    
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
            
        }else if viewModel.resultTableState == .showNoResults {
            return 0
        }else {
            return viewModel.results.suggestedJourneyArray.count

        }
    }
    
    func getnumberOfRowsWhenExpanded(section: Int) -> Int {
     //   return section == 0 ? results.suggestedJourneyArray.count  :  results.expensiveJourneyArray.count
        return 0
    }
    
    func getNumberOfRowsWhenNotExpanded(section : Int) -> Int{
            return viewModel.results.suggestedJourneyArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.resultTableState == .showTemplateResults ? UITableView.automaticDimension  : getRowHeight(indexPath: indexPath)
//        return UITableView.automaticDimension
    }
    
    func getRowHeight(indexPath: IndexPath)  -> CGFloat  {
        
        if viewModel.resultTableState == .showPinnedFlights {
            let arrayForDisplay = viewModel.results.pinnedFlights
            if arrayForDisplay.isEmpty { return 0 }
            let legsHeight = (arrayForDisplay.first?.legsWithDetail.count ?? 0) * 66
            return CGFloat(44 + legsHeight + 16)
        }
        
        var arrayForDisplay = viewModel.results.suggestedJourneyArray
              
        if viewModel.resultTableState == .showExpensiveFlights { arrayForDisplay = viewModel.results.allJourneys }
      
        if arrayForDisplay.isEmpty { return 0 }
       
        let legsHeight = (arrayForDisplay[indexPath.row].journeyArray.first?.legsWithDetail.count ?? 0) * 66
        var moreOptionsHeight : Int = 0
            
        moreOptionsHeight = arrayForDisplay[indexPath.row].journeyArray.count > 1 ? 45 : 0
        
        return CGFloat(44 + moreOptionsHeight + legsHeight + 16)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.resultTableState == .showTemplateResults {
            return getTemplateCell()
        } else if viewModel.resultTableState == .showPinnedFlights {
            let journey = viewModel.results.pinnedFlights[indexPath.row]
            return getSingleJourneyCell(indexPath: indexPath ,journey: IntMultiCityAndReturnDisplay([journey]) )
        }else{
            var arrayForDisplay = viewModel.results.suggestedJourneyArray
            if viewModel.resultTableState == .showExpensiveFlights {
                arrayForDisplay = viewModel.results.allJourneys } else {
                arrayForDisplay = viewModel.results.suggestedJourneyArray
            }
            return getSingleJourneyCell(indexPath: indexPath ,journey: arrayForDisplay[indexPath.row])
        }
    }
    
    func getSingleJourneyCell (indexPath : IndexPath , journey : IntMultiCityAndReturnDisplay) -> UITableViewCell {
        
        guard let cell =  resultsTableView.dequeueReusableCell(withIdentifier: "InternationalReturnTableViewCell") as? InternationalReturnTableViewCell else {
            return UITableViewCell() }
        if #available(iOS 13, *) {
            if cell.baseView.interactions.isEmpty{
                let interaction = UIContextMenuInteraction(delegate: self)
                cell.baseView.addInteraction(interaction)
            }
        }
        cell.multiFlightsTableView.isUserInteractionEnabled = false
        cell.numberOfInnerCells = self.numberOfLegs
        cell.populateData(journey: journey, indexPath: indexPath)
        cell.samePriceOptionButton.addTarget(self, action: #selector(samePriceOptionButtonTapped), for: UIControl.Event.touchUpInside)
                
        return cell
    }
    
    @objc func samePriceOptionButtonTapped(sender : UIButton){
        guard let indexPath = self.resultsTableView.indexPath(forItem: sender), let cell = self.resultsTableView.cellForRow(at: indexPath) as? InternationalReturnTableViewCell else { return }
        let vc = IntMCAndReturnDetailsVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
        vc.viewModel.taxesResult = self.taxesResult
        vc.viewModel.headerArray = self.headerTitles
        vc.viewModel.numberOfLegs = self.headerTitles.count
        vc.viewModel.largeTitle = cell.samePriceOptionsLabel.text ?? ""
        vc.selectionDelegate = self
        vc.viewModel.bookFlightObject = self.bookFlightObject
        vc.viewModel.sid = self.sid
        vc.refundDelegate = self
        vc.viewModel.airlineDetailsResult = self.airlineDetailsResult
        vc.viewModel.airportDetailsResult = self.airportDetailsResult
        vc.pinnedDelegate = self
        var groupId = 0
        if viewModel.resultTableState == .showPinnedFlights {
            let journeyArray = viewModel.results.pinnedFlights
            let currentJourney = journeyArray[indexPath.row]
            vc.viewModel.showJourneyId = currentJourney.id
            vc.viewModel.internationalDataArray = journeyArray
            groupId = currentJourney.groupID ?? 0
            
        } else {
                var arrayForDisplay = viewModel.results.suggestedJourneyArray
                if viewModel.resultTableState == .showExpensiveFlights {
                    arrayForDisplay = viewModel.results.allJourneys
                }
                
                let journey = arrayForDisplay[indexPath.row].first
                vc.viewModel.showJourneyId = journey.id
                vc.viewModel.internationalDataArray = arrayForDisplay[indexPath.row].journeyArray
            groupId = journey.groupID ?? 0
        }
        
        vc.onJourneySelect = { [weak self] journeyId in
            self?.performOnJourneyChange(journeyId, groupId)
        }
        
        self.parent?.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func performOnJourneyChange(_ journeyId: String,_ groupId: Int) {
        
        DispatchQueue.global(qos: .background).async(execute: {
            self.searchAndUpdateCurrentJourneyArray(self.viewModel.results.suggestedJourneyArray, journeyId, groupId, .showRegularResults)
            self.searchAndUpdateCurrentJourneyArray(self.viewModel.results.allJourneys, journeyId, groupId, .showExpensiveFlights)
        })
    }
    
    private func searchAndUpdateCurrentJourneyArray(_ curJourneyArr: [IntMultiCityAndReturnDisplay],_ journeyId: String,_ groupId: Int,_ state: ResultTableViewState) {
        guard let jArrayIndex = curJourneyArr.firstIndex(where: { (returnDisplay) in
            returnDisplay.first.groupID == groupId
            }) else { return }
        
        var jArr = curJourneyArr[jArrayIndex].journeyArray
        if let jIndex = jArr.firstIndex(where: { $0.id == journeyId }) {
            let journey = jArr[jIndex]
            jArr.remove(at: jIndex)
            jArr.insert(journey, at: 0)
        }
        if state == .showRegularResults {
             self.viewModel.results.suggestedJourneyArray[jArrayIndex].journeyArray = jArr
            
        } else if state == .showExpensiveFlights {
            self.viewModel.results.allJourneys[jArrayIndex].journeyArray = jArr
        }
        DispatchQueue.main.async(execute: {
            self.resultsTableView.reloadData()
        })
    }
    
    //MARK:- Methods to get different types of cells
    func getTemplateCell() -> UITableViewCell {
        if let cell =  resultsTableView.dequeueReusableCell(withIdentifier: "InternationalReturnTemplateTableViewCell") as? InternationalReturnTemplateTableViewCell {
            cell.numberOfLegs = self.numberOfLegs
            cell.selectionStyle = .none
            cell.populateData()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let vc = SelectOtherAdonsContainerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
//        self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc = AddOnVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
//        self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc = BagageContainerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc = MealsContainerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
        if let journeyCell = tableView.cellForRow(at: indexPath) as? InternationalReturnTableViewCell {
            let curJourney = journeyCell.currentJourney
            let vc = FlightDetailsBaseVC.instantiate(fromAppStoryboard: .FlightDetailsBaseVC)
            vc.delegate = self
            vc.isInternational = true
            vc.bookFlightObject = self.bookFlightObject
            vc.taxesResult = self.taxesResult
            vc.refundDelegate = self
            vc.sid = self.sid
            vc.intJourney = [curJourney]
            vc.intAirportDetailsResult = self.airportDetailsResult
            vc.intAirlineDetailsResult = self.airlineDetailsResult
            vc.selectedJourneyFK = [curJourney.fk]
            vc.journeyTitle = self.titleString
            vc.journeyDate = self.subtitleString
            vc.flightSearchResultVM = self.flightSearchResultVM
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension IntMCAndReturnVC: UpdateSelectedJourneyDelegate {
    
    func selectedJourney(journeyId: String) {
        
    }
}
