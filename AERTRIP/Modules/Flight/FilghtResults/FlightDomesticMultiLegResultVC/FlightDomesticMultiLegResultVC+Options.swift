//
//  FlightDomesticMultiLegResultVC+Options.swift
//  AERTRIP
//
//  Created by Appinventiv on 27/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import MessageUI


extension FlightDomesticMultiLegResultVC : MFMailComposeViewControllerDelegate {
       
    func setPinnedFlightAt(flightKey : String , indexPath : IndexPath , isPinned : Bool , tableIndex : Int ) {
        
         var journeyArray = self.viewModel.results[tableIndex].journeyArray
      
        guard let journeyIndex = journeyArray.firstIndex(where: {
            $0.fk == flightKey
        }) else {
            return
        }
        
        let journeyToToggle = journeyArray[journeyIndex]
        journeyToToggle.isPinned = isPinned
        journeyArray[journeyIndex] = journeyToToggle
        self.viewModel.results[tableIndex].journeyArray = journeyArray
        
        if isPinned {
        showPinnedFlightsOption(true)
        self.viewModel.results[tableIndex].currentPinnedJourneys.append(journeyToToggle)

        } else {
            
            let containsPinnedFlight = self.viewModel.results.reduce(false) { $0 || $1.containsPinnedFlight }
            
//            showPinnedFlightSwitch(containsPinnedFlight)
            
            if !containsPinnedFlight {
                viewModel.resultsTableStates = viewModel.stateBeforePinnedFlight
                for index in 0 ..< self.viewModel.numberOfLegs {
                    // Removal of ErrorScreen if pinned flights were 0
                    if let errorView = self.baseScrollView.viewWithTag( 500 + index) {
                        if journeyArray.count > 0 {
                            errorView.removeFromSuperview()
                        }
                    }
                    // updating UITableview state
                    self.updateUIForTableviewAt(index)
                }
                switchView.isOn = false
                showPinnedFlightsOption(containsPinnedFlight)

//                hidePinnedFlightOptions(true)
            }
            
            if let index = self.viewModel.results[tableIndex].currentPinnedJourneys.firstIndex(where: { (obj) -> Bool in
                    obj.id == journeyArray[journeyIndex].id
            }){
                    self.viewModel.results[tableIndex].currentPinnedJourneys.remove(at: index)
            }
        }
        
        self.viewModel.setPinnedFlights(tableIndex: tableIndex)

        var isAnyFlightPinned = false
        for index in 0 ..< self.viewModel.numberOfLegs {
            let legArray = self.viewModel.results[index]
             let journeyArray = legArray.journeyArray
                
                for j in 0 ..<  journeyArray.count {
                    let journey = journeyArray[j]

                    if let isJPinned = journey.isPinned{
                        if isJPinned {
                            isAnyFlightPinned = true
                        }
                    }
                }
        
        }
                
        if !isAnyFlightPinned{
            showPinnedFlightsOption(false)
        }
        
        //Updating pinned flight indicator in tableview Cell after pin / unpin action
        guard let tableview = self.baseScrollView.viewWithTag(1000 + tableIndex) as? UITableView  else { return }
        guard let cell = tableview.cellForRow(at: indexPath) as? DomesticMultiLegCell else { return }
        cell.setPinnedFlight()
        
        delay(seconds: 0.5) {
            tableview.reloadData()
        }

    }
    
    func performUnpinnedAllAction() {
           viewModel.resultsTableStates  = viewModel.stateBeforePinnedFlight
           
           for index in 0 ..< self.viewModel.numberOfLegs {
               
               // unpinning of all flights in array
               var legArray = self.viewModel.results[index]
                var journeyArray = legArray.journeyArray
                   
                   for j in 0 ..<  journeyArray.count {
                       let journey = journeyArray[j]
                       journey.isPinned = false
                       journeyArray[j] = journey
                   }
                   
                   legArray.journeyArray = journeyArray
                   self.viewModel.results[index] = legArray
                   
                   // Removal of ErrorScreen if pinned flights were 0
                   if let errorView = self.baseScrollView.viewWithTag( 500 + index) {
                       if journeyArray.count > 0 {
                           errorView.removeFromSuperview()
                       }
                   }
               
               // updating UITableview state
               self.updateUIForTableviewAt(index)
               
           }
           
           self.setPinedSwitchState(isOn: false)
           
            hideOrShowPinnedButtons(show : false)

        self.showPinnedFlightsOption(false)
        
//           showPinnedFlightSwitch(switchView.isOn)
        
           self.setTotalFare()
           self.checkForOverlappingFlights()
       }
       
           //MARK:- Emailing Pinned Flights
       func showEmailViewController(body : String) {
           if MFMailComposeViewController.canSendMail() {
               let composeVC = MFMailComposeViewController()
               composeVC.mailComposeDelegate = self
               // Configure the fields of the interface.
               composeVC.setSubject("Checkout these great flights I pinned on Aertrip!")
               composeVC.setMessageBody(body, isHTML: true)
               self.present(composeVC, animated: true, completion: nil)
           }
       }
    
    func returnEmailView(view: String) {
          DispatchQueue.main.async {
            self.emailPinnedFlights.setImage(UIImage(named: "EmailPinned"), for: .normal)
            self.emailPinnedFlights.displayLoadingIndicator(false)

//          self.showEmailViewController(body : view)
            
          
            if view.lowercased() == "pinned template data not found"{
                  AppToast.default.showToastMessage(message: view)
              }else{
                  self.showEmailViewController(body : view)
              }
          
          }
      }
      
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
         controller.dismiss(animated: true, completion: nil)
     }
    
    func addToTrip(journey : Journey)
    {
        AppFlowManager.default.proccessIfUserLoggedInForFlight(verifyingFor: .loginVerificationForCheckout,presentViewController: true, vc: self, checkoutType: .none) { [weak self](isGuest) in
            guard let self = self else {return}
            AppFlowManager.default.removeLoginConfirmationScreenFromStack()
            self.presentedViewController?.dismiss(animated: false, completion: nil)
            guard !isGuest else {
                return
            }
            AppFlowManager.default.selectTrip(nil, tripType: .hotel) { [weak self] (trip, details)  in
                delay(seconds: 0.3, completion: { [weak self] in
                    guard let self = self else {return}
                    self.addToTripApiCall(with: journey, trip: trip)
                })
            }
        }
    }
//    {
//           let tripListVC = TripListVC(nibName: "TripListVC", bundle: nil)
//           tripListVC.journey = [journey]
//           tripListVC.modalPresentationStyle = .overCurrentContext
//           self.present(tripListVC, animated: true, completion: nil)
//       }
       
    func addToTripApiCall(with journey: Journey, trip: TripModel){
        self.viewModel.addToTrip(with: journey, trip: trip) {[weak self] (success, alreadyAdded) in
            if success{
                let message:String
                if alreadyAdded{
                    message = LocalizedString.flightHasAlreadyBeenSavedToTrip.localized
                }else{
                    let tripName = (trip.isDefault) ? LocalizedString.Default.localized.lowercased() : "\(trip.name)"
                    message = "Journey has been added to \(tripName) trip"
                }
                AppToast.default.showToastMessage(message: message, onViewController: self)
            }
        }
        
    }
    
    
//     fileprivate func setTotalFare() {
//        if let selectedJourneys = self.getSelectedJourneyForAllLegs() {
//
//            if selectedJourneys.count == self.viewModel.numberOfLegs {
//                ShowFareBreakupView()
//                let containsPinnedFlight = self.viewModel.results.reduce(false) { $0 || $1.containsPinnedFlight }
//                showPinnedFlightSwitch(containsPinnedFlight)
//            }
//        }
//        else {
//            hideFareBreakupView()
//        }
//    }
    
}

extension FlightDomesticMultiLegResultVC: ATSwitcherChangeValueDelegate {
    
    func switcherDidChangeValue(switcher: ATSwitcher, value: Bool) {
        
        if value {
            
            self.unpinnedAllButton.isHidden = false
            self.emailPinnedFlights.isHidden = false
            self.sharePinnedFilghts.isHidden = false
            self.animateButton()
            
            
            viewModel.stateBeforePinnedFlight = viewModel.resultsTableStates
            viewModel.resultsTableStates = Array(repeating: .showPinnedFlights, count: self.viewModel.numberOfLegs)
           
            for subView in self.baseScrollView.subviews {
                    if let tableview = subView as? UITableView {
                        let index = tableview.tag - 1000
                        let count = self.viewModel.results[index].pinnedFlights.count
                        
                        if count > 0 {
                            tableview.reloadData()
                            tableview.tableFooterView = nil
                            
                            let indexPath = IndexPath(row: 0, section: 0)
                            tableview.scrollToRow(at: indexPath, at: .top, animated: true)
                            tableview.selectRow(at: indexPath , animated: false, scrollPosition: .none)
                            self.updateSelectedJourney(index: index)
                        } else {
                            addErrorScreenAtIndex(index: index , forFilteredResults: false, isForPinned: true)
                            self.viewModel.results[index].selectedJourney = nil
                            self.journeyHeaderViewArray[index].isHidden = true
                            self.setTableViewHeaderFor(tableView: tableview)
                        }
                        
                    }
                }
            
            self.baseScrollView.setContentOffset(.zero, animated: true)

            
        } else {
            self.hidePinnedButtons(withAnimation: true)
         
    
            viewModel.stateBeforePinnedFlight.enumerated().forEach { (index, value) in
                if value == .showPinnedFlights{
                    viewModel.resultsTableStates[index] = .showRegularResults
                } else {
                    viewModel.resultsTableStates[index] = value
                }
            }
            
//            viewModel.resultsTableStates = viewModel.stateBeforePinnedFlight
              
            for index in 0 ..< self.viewModel.numberOfLegs {
                if let errorView = self.baseScrollView.viewWithTag( 500 + index) {
                    errorView.removeFromSuperview()
                }
                self.updateUIForTableviewAt(index)
            }
        }
        
        self.viewModel.isPinnedOn = value
      
        self.setTotalFare()
       
        let containsPinnedFlight = self.viewModel.results.reduce(false) { $0 || $1.containsPinnedFlight }
        
        self.showPinnedFlightsOption(containsPinnedFlight)
        self.checkForOverlappingFlights()

    }
    
    func hideOrShowPinnedButtons(show : Bool){
        if show {
            self.showPinnedButtons(withAnimation : true)
        } else {
            self.hidePinnedButtons(withAnimation : true)
        }
    }
    
        func showPinnedFlightsOption(_ show  : Bool) {
              manageSwitchContainer(isHidden: !show)
              
        }
    
}
