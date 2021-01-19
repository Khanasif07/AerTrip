//
//  FlightInternationalMultiLegResultVC+Options.swift
//  Aertrip
//
//  Created by Appinventiv on 25/04/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation
import MessageUI

extension IntMCAndReturnVC {
    
     func setPinnedFlightAt(_ flightKey: String , isPinned : Bool) {
       
       var curJourneyArr = [IntMultiCityAndReturnDisplay]()
        
        if viewModel.resultTableState == .showRegularResults {
            curJourneyArr = viewModel.results.suggestedJourneyArray
        } else {
            curJourneyArr = viewModel.results.allJourneys
        }
        
       guard let index = curJourneyArr.firstIndex(where: {
            
            for journey in $0.journeyArray {
                if journey.fk == flightKey {
//                   print("index...\(index)")
                    return true
                }
            }
            return false
        }) else {
            return
        }
            
       let displayArray = curJourneyArr[index]
        
        guard let journeyArrayIndex = displayArray.journeyArray.firstIndex(where : {
            $0.fk == flightKey
        }) else {
            return
        }
        
        displayArray.journeyArray[journeyArrayIndex].isPinned = isPinned
        curJourneyArr[index] = displayArray
        
       
        if isPinned {
            showPinnedFlightsOption(true)
       self.viewModel.results.currentPinnedJourneys.append(displayArray.journeyArray[journeyArrayIndex])

        } else {
           
           let containesPinnedFlight = viewModel.results.allJourneys.reduce(curJourneyArr[0].containsPinnedFlight) { $0 || $1.containsPinnedFlight }
            showPinnedFlightsOption(containesPinnedFlight)
            
            if !containesPinnedFlight {
               viewModel.resultTableState = stateBeforePinnedFlight
                hidePinnedFlightOptions(true)
                switchView.isOn = false
            }
           
           if let index = self.viewModel.results.currentPinnedJourneys.firstIndex(where: { (obj) -> Bool in
               obj.id == displayArray.journeyArray[journeyArrayIndex].id
           }){
               self.viewModel.results.currentPinnedJourneys.remove(at: index)
           }
        }
        
        self.viewModel.setPinnedFlights()
        self.resultsTableView.reloadData()
        showFooterView()
        
    }
    
    func showPinnedFlightsOption(_ show  : Bool) {
          manageSwitchContainer(isHidden: !show)

//          let offsetFromBottom = show ? -22 : 70
//          self.pinnedFlightOptionsTop.constant = CGFloat(offsetFromBottom)
//
//          UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
//              self.view.layoutIfNeeded()
//          }, completion: nil)
          
      }
}

extension IntMCAndReturnVC: ATSwitcherChangeValueDelegate {
    
    func switcherDidChangeValue(switcher: ATSwitcher, value: Bool) {
//        self.viewModel.isFavouriteOn = value
//        self.viewModel.loadSaveData()
      
        if value {
            
            self.unpinnedAllButton.isHidden = false
            self.emailPinnedFlights.isHidden = false
            self.sharePinnedFilghts.isHidden = false
            self.animateButton()
            
            stateBeforePinnedFlight = viewModel.resultTableState
            viewModel.resultTableState = .showPinnedFlights
            resultsTableView.tableFooterView = nil
            if viewModel.results.pinnedFlights.isEmpty {
                showNoFilteredResults()
            }
            
        } else {
            self.hideFavsButtons(isAnimated: true)
            
            if stateBeforePinnedFlight == .showPinnedFlights{
                stateBeforePinnedFlight = .showRegularResults
            }
            
           viewModel.resultTableState = stateBeforePinnedFlight
            
            showFooterView()
            self.noResultScreen?.view.removeFromSuperview()
            self.noResultScreen?.removeFromParent()
            self.noResultScreen = nil
            
        }
        
//        hidePinnedFlightOptions(!value)
        resultsTableView.reloadData()
        resultsTableView.setContentOffset(.zero, animated: false)
        showBluredHeaderViewCompleted()
        
//        tableViewVertical.setContentOffset(CGPoint(x: 0, y: -topContentSpace), animated: false)
        //showBluredHeaderViewCompleted()
    }
}


@available(iOS 13.0, *) extension IntMCAndReturnVC : UIContextMenuInteractionDelegate {

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            var fk : String = ""
            var isPinned = false
            let locationInTableView = interaction.location(in:self.resultsTableView)
            var currentJourney = IntMultiCityAndReturnWSResponse.Results.J(JSON())
            
            if let indexPath = self.resultsTableView.indexPathForRow(at: locationInTableView) {
                
                if self.viewModel.resultTableState == .showPinnedFlights {
                    
                    let journeyArray = self.viewModel.results.pinnedFlights
                    currentJourney = journeyArray[indexPath.row]
                    fk = currentJourney.fk
               
                }else{
                    
                    var arrayForDisplay = self.viewModel.results.suggestedJourneyArray
                        
                    if self.viewModel.resultTableState == .showExpensiveFlights {
                            arrayForDisplay = self.viewModel.results.journeyArray
                        }
                        
                        let journey = arrayForDisplay[indexPath.row].first
                        
                        fk = journey.fk
                        
                        isPinned = !journey.isPinned
                        
                        currentJourney = journey
                        
                }
            }
            
            return self.makeMenusFor(journey : currentJourney ,fk : fk , markPinned : isPinned)
        }
    }
    
    func makeMenusFor(journey : IntMultiCityAndReturnWSResponse.Results.J ,  fk: String , markPinned : Bool) -> UIMenu {
         
             let pinTitle : String
             pinTitle = markPinned ? "Pin" : "Unpin"
 
             let pin = UIAction(title:  pinTitle , image: UIImage(systemName: "pin" ), identifier: nil) { (action) in
             
                  self.setPinnedFlightAt(fk, isPinned: markPinned)
             }
             let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil) {[weak self] (action) in
                 guard let strongSelf = self else { return }
                 strongSelf.shareJourney(journey: [journey])
             }
             let addToTrip = UIAction(title: "Add To Trip", image: UIImage(systemName: "map" ), identifier: nil) { (action) in
                 
                   self.addToTrip(journey: journey)
             }
             
             // Create and return a UIMenu with all of the actions as children
             return UIMenu(title: "", children: [pin, share, addToTrip])
     }
     

     func performUnpinnedAllAction() {
        for i in 0 ..< viewModel.results.journeyArray.count {
               
            let journeyGroup = viewModel.results.journeyArray[i]
               let newJourneyGroup = journeyGroup
               newJourneyGroup.journeyArray = journeyGroup.journeyArray.map{
                var journey = $0
                   journey.isPinned = false
                   return journey
               }
               
            viewModel.results.journeyArray[i] = newJourneyGroup
           }
                   
        self.applySorting(sortOrder: self.viewModel.sortOrder, isConditionReverced: self.viewModel.isConditionReverced, legIndex: self.viewModel.prevLegIndex) {
            
        }
        
           switchView.isOn = false
           hidePinnedFlightOptions(true)
          viewModel.resultTableState = stateBeforePinnedFlight
           
           showPinnedFlightsOption(false)
           resultsTableView.reloadData()
           showFooterView()
           
           resultsTableView.setContentOffset(.zero, animated: true)
       }
    
    
   
    
    func shareJourney(journey : [IntMultiCityAndReturnWSResponse.Results.J])
    {
        self.sharePinnedFilghts.setImage(UIImage(named: "OvHotelResult"), for: .normal)
        sharePinnedFilghts.displayLoadingIndicator(true)

        let flightAdultCount = bookFlightObject.flightAdultCount
        let flightChildrenCount = bookFlightObject.flightChildrenCount
        let flightInfantCount = bookFlightObject.flightInfantCount
        let isDomestic = bookFlightObject.isDomestic
        var valStr = generateCommonString(for: journey, flightObject: bookFlightObject)
        
        
        let filterStr = self.getSharableLink.getAppliedFiltersForSharingIntJourney(legs: self.flightSearchResultVM?.intFlightLegs ?? [],isConditionReverced: viewModel.isConditionReverced,appliedFilterLegIndex: viewModel.appliedFilterLegIndex)
        valStr.append(filterStr)
        
        self.getSharableLink.getUrl(adult: "\(flightAdultCount)", child: "\(flightChildrenCount)", infant: "\(flightInfantCount)",isDomestic: isDomestic, isInternational: true, journeyArray: [], valString: valStr, trip_type: "",filterString: filterStr,searchParam: [:])
        
    }
    
    func generateCommonString(for journey: [IntMultiCityAndReturnWSResponse.Results.J],flightObject:BookFlightObject)-> String{
        
        
        let tripType = (flightObject.flightSearchType == RETURN_JOURNEY) ? "return" : "multi"
        var valueString = "\(AppKeys.baseUrl)flights?trip_type=\(tripType)&"

        // Adding Passanger Count
        let flightAdultCount = flightObject.flightAdultCount
        let flightChildrenCount = flightObject.flightChildrenCount
        let flightInfantCount = flightObject.flightInfantCount
        valueString += "adult=\(flightAdultCount)&child=\(flightChildrenCount)&infant=\(flightInfantCount)"
        guard let firstJourney = journey.first else { return ""}
        var origin = ""
        var destination = ""
        var dprtDate = ""
        var rtrnDate = ""
        var cabinclass = firstJourney.cc
        if (flightObject.flightSearchType == RETURN_JOURNEY){
            if let searchParam = (self.parent as? FlightResultBaseViewController)?.flightSearchParameters{
                origin += "&origin=\(searchParam["origin"] ?? "")"
                destination += "&destination=\(searchParam["destination"] ?? "")"
                dprtDate += "&depart=\(searchParam["depart"] ?? "")"
                rtrnDate += "&return=\(searchParam["return"] ?? "")"
            }else{

                origin += "&origin=\(firstJourney.legsWithDetail.first?.originIATACode ?? "")"
                destination += "&destination=\(firstJourney.legsWithDetail.first?.destinationIATACode ?? "")"
                dprtDate += "&depart=\(self.converDateFormate(dateStr:firstJourney.legsWithDetail.first?.dd ?? ""))"
                rtrnDate = "&return=\(self.converDateFormate(dateStr:firstJourney.legsWithDetail.last?.dd ?? ""))"
            }
        }else{
            if let searchParam = (self.parent as? FlightResultBaseViewController)?.flightSearchParameters{

                
                let departKey = searchParam.keys// as NSArray
                var departKeyArray = [String]()
                for key in departKey{
                    if (key as AnyObject).contains("depart"){
                        departKeyArray.append(key )
                    }
                }

//                let departKey = (searchParam.allKeys as? [String] ?? []).map{$0.contains("depart")}
                cabinclass = searchParam["cabinclass"] as? String ?? cabinclass
//                for i in 0..<departKey.count{
                for i in 0..<departKeyArray.count{
                    let key = "%5B\(i)%5D"
                    origin += "&origin\(key)=\(searchParam["origin[\(i)]"] ?? "")"
                    destination += "&destination\(key)=\(searchParam["destination[\(i)]"] ?? "")"
                    dprtDate += "&depart\(key)=\(searchParam["depart[\(i)]"] ?? "")"
                    if (rtrnDate == ""){
                        rtrnDate = "&return=\(self.converDateFormate(dateStr:firstJourney.legsWithDetail[i].ad))"
                    }
                }
            }else{
                for i in 0..<firstJourney.legsWithDetail.count{
                    let key = "%5B\(i)%5D"
                    origin += "&origin\(key)=\(firstJourney.legsWithDetail[i].originIATACode)"
                    destination += "&destination\(key)=\(firstJourney.legsWithDetail[i].destinationIATACode)"
                    dprtDate += "&depart\(key)=\(self.converDateFormate(dateStr:firstJourney.legsWithDetail[i].dd))"
                    if (rtrnDate == ""){
                        rtrnDate = "&return=\(self.converDateFormate(dateStr:firstJourney.legsWithDetail[i].ad))"
                    }
                }
            }
        }
        valueString += origin
        valueString += destination
        valueString += dprtDate
        valueString += rtrnDate
        let isDomestic = false
        valueString = valueString + "&cabinclass=\(cabinclass)&pType=flight&isDomestic=\(isDomestic)"
        
        for i in 0 ..< journey.count {
            let tempJourney = journey[i]
            valueString = valueString + "&PF[\(i)]=\(tempJourney.fk)"
        }
        
        return valueString

    }

    func converDateFormate(dateStr: String)-> String{
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateStr) else {return ""}
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
    
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
}



extension IntMCAndReturnVC : MFMailComposeViewControllerDelegate{
        
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}


extension IntMCAndReturnVC{
    
    func updatePriceWhenGoneup(_ fk: String, changeResult: ChangeResult) {
           
           var curJourneyArr = [IntMultiCityAndReturnDisplay]()
            
            if viewModel.resultTableState == .showRegularResults {
                curJourneyArr = viewModel.results.suggestedJourneyArray
            } else {
                curJourneyArr = viewModel.results.allJourneys
            }
            
           guard let index = curJourneyArr.firstIndex(where: {
                
                for journey in $0.journeyArray {
                    if journey.fk == fk {
    //                   print("index...\(index)")
                        return true
                    }
                }
                return false
            }) else {
                return
            }
                
           let displayArray = curJourneyArr[index]
            
            guard let journeyArrayIndex = displayArray.journeyArray.firstIndex(where : {
                $0.fk == fk
            }) else {
                return
            }
            
        displayArray.journeyArray[journeyArrayIndex].farepr = changeResult.farepr
        displayArray.journeyArray[journeyArrayIndex].fare = changeResult.fare
            curJourneyArr[index] = displayArray
            self.resultsTableView.reloadData()
            showFooterView()
            
        }
    
}

extension IntMCAndReturnVC{
    
    
    func addToTrip(journey : IntJourney) {
        AppFlowManager.default.proccessIfUserLoggedInForFlight(verifyingFor: .loginVerificationForCheckout,presentViewController: true, vc: self) { [weak self](isGuest) in
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
    
    
    func addToTripApiCall(with journey: IntJourney, trip: TripModel){
        self.viewModel.addToTrip(with: journey, trip: trip) {[weak self] (success, alreadyAdded) in
            if success{
                let message:String
                if alreadyAdded{
                    message = LocalizedString.flightHasAlreadyBeenSavedToTrip.localized
                }else{
                    let tripName = (trip.isDefault) ? LocalizedString.Default.localized.lowercased() : "\(trip.name)"
                    message = "journey has been added to \(tripName) trip"
                }
                AppToast.default.showToastMessage(message: message, onViewController: self)
            }
        }
        
    }
    
    
}
