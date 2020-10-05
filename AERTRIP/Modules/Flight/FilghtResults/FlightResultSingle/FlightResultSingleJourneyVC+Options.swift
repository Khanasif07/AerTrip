//
//  FlightResultSingleJourneyVC+Options.swift
//  AERTRIP
//
//  Created by Appinventiv on 04/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import MessageUI

extension FlightResultSingleJourneyVC {
    
    func setPinnedFlightAt(_ flightKey: String , isPinned : Bool) {
        
        var curJourneyArr = [JourneyOnewayDisplay]()
        
        if viewModel.resultTableState == .showRegularResults {
            curJourneyArr = viewModel.results.suggestedJourneyArray
        } else {
            curJourneyArr = viewModel.results.allJourneys
        }
                
        guard let index = curJourneyArr.firstIndex(where: {
            
            for journey in $0.journeyArray {
                if journey.fk == flightKey {
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
            
            self.viewModel.results.currentPinnedJourneys = self.viewModel.results.currentPinnedJourneys.removeDuplicates()

            
        } else {
            
            let containesPinnedFlight = viewModel.results.allJourneys.reduce(curJourneyArr[0].containsPinnedFlight) { $0 || $1.containsPinnedFlight }
           
            showPinnedFlightsOption(containesPinnedFlight)
            
            if !containesPinnedFlight {
                viewModel.resultTableState = self.viewModel.stateBeforePinnedFlight
                hideOrShowPinnedButtons(show : false)
                switchView.isOn = false
            }
            
            if let index = self.viewModel.results.currentPinnedJourneys.firstIndex(where: { (obj) -> Bool in
                obj.id == displayArray.journeyArray[journeyArrayIndex].id
            }){
                self.viewModel.results.currentPinnedJourneys.remove(at: index)
            }
        }
        
        self.viewModel.setPinnedFlights()
        resultsTableView.tableFooterView?.isHidden = true
        self.resultsTableView.reloadData()
        delay(seconds: 0.5) {
            self.resultsTableView.tableFooterView?.isHidden = false
        }
        showFooterView()
    }
    

    
}

extension FlightResultSingleJourneyVC: ATSwitcherChangeValueDelegate {
    
    func switcherDidChangeValue(switcher: ATSwitcher, value: Bool) {
        
        if value {
            
            self.unpinnedAllButton.isHidden = false
            self.emailPinnedFlights.isHidden = false
            self.sharePinnedFilghts.isHidden = false
            self.animateButton()
            
            viewModel.stateBeforePinnedFlight = viewModel.resultTableState
            viewModel.resultTableState = .showPinnedFlights
            resultsTableView.tableFooterView = nil
            if viewModel.results.pinnedFlights.isEmpty {
                showNoFilteredResults()
            }
            
        } else {
            self.hidePinnedButtons(withAnimation: true)
            if viewModel.stateBeforePinnedFlight == ResultTableViewState.showPinnedFlights{
                viewModel.resultTableState = ResultTableViewState.showRegularResults
            }else {
                viewModel.resultTableState = viewModel.stateBeforePinnedFlight
            }
            showFooterView()
        }
        
        //        hidePinnedFlightOptions(!value)
        resultsTableView.reloadData()
        resultsTableView.setContentOffset(.zero, animated: false)
        showBluredHeaderViewCompleted()
        
        //        tableViewVertical.setContentOffset(CGPoint(x: 0, y: -topContentSpace), animated: false)
        //showBluredHeaderViewCompleted()
    }
    
    //    func switchTogggled(switcher: ATSwitcher, value: Bool, shouldaddNoDataView : Bool = true){
    //
    //    }
    
    
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

extension FlightResultSingleJourneyVC {
    
}

@available(iOS 13.0, *) extension FlightResultSingleJourneyVC : UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            var fk : String?
            var isPinned = false
            let locationInTableView = interaction.location(in: self.resultsTableView)
            var currentJourney  : Journey?
            
            if let indexPath = self.resultsTableView.indexPathForRow(at: locationInTableView) {
                
                if self.viewModel.resultTableState == .showPinnedFlights {
                    //                    let journeyArray = self.results.pinnedFlights
                    let journeyArray = self.viewModel.results.pinnedFlights
                    currentJourney = journeyArray[indexPath.row]
                    fk = currentJourney?.fk
                }else {
                    
                    var arrayForDisplay = self.viewModel.results.suggestedJourneyArray
                    
                    if self.viewModel.resultTableState == .showExpensiveFlights{
                        arrayForDisplay = self.viewModel.results.journeyArray
                    }
                    
                    let journey = arrayForDisplay[indexPath.row].first
                    
                    fk = journey.fk
                    
                    isPinned = !(journey.isPinned ?? false)
                    
                    currentJourney = journey
                    
                }
            }
            
            return self.makeMenusFor(journey : currentJourney ,fk : fk , markPinned : isPinned)
        }
    }
    
    func makeMenusFor(journey : Journey? ,  fk: String? , markPinned : Bool) -> UIMenu {
        
        guard let currentJourney = journey else {
            return UIMenu(title: "", children: [])
        }
        
            let pinTitle : String = markPinned ? "Pin" : "Unpin"
            
            let pin = UIAction(title:  pinTitle , image: UIImage(systemName: "pin" ), identifier: nil) { (action) in
                guard let flightKey = fk else {
                    return
                }
                self.setPinnedFlightAt(flightKey, isPinned: markPinned)
            }
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil) {[weak self] (action) in
                
                guard let strongSelf = self else { return }
                guard let strongJourney = journey else { return }
                strongSelf.shareJourney(journey: [strongJourney])
                
            }
            
            let addToTrip = UIAction(title: "Add To Trip" , image: UIImage(systemName: "map" ), identifier: nil) { (action) in
                
                self.addToTrip(journey: currentJourney)
            }
            
            // Create and return a UIMenu with all of the actions as children
            return UIMenu(title: "", children: [pin, share, addToTrip])
    
    }
    
    func performUnpinnedAllAction() {
        for i in 0 ..< viewModel.results.allJourneys.count {
            
            let journeyGroup = viewModel.results.journeyArray[i]
            let newJourneyGroup = journeyGroup
            newJourneyGroup.journeyArray = journeyGroup.journeyArray.map{
                let journey = $0
                journey.isPinned = false
                return journey
            }
            
            viewModel.results.journeyArray[i] = newJourneyGroup
        }
        
        self.setPinedSwitchState(isOn: false)
        hideOrShowPinnedButtons(show : false)

        viewModel.resultTableState = viewModel.stateBeforePinnedFlight
        showPinnedFlightsOption(false)
        resultsTableView.reloadData()
        showFooterView()
        resultsTableView.setContentOffset(.zero, animated: true)
    }
    
 
    
    func shareJourney(journey : [Journey]) {
        
        self.sharePinnedFilghts.setImage(nil, for: .normal)
        sharePinnedFilghts.displayLoadingIndicator(true)

        let flightAdultCount = self.viewModel.bookFlightObject.flightAdultCount
        let flightChildrenCount = self.viewModel.bookFlightObject.flightChildrenCount
        let flightInfantCount = self.viewModel.bookFlightObject.flightInfantCount
        let isDomestic = self.viewModel.bookFlightObject.isDomestic
        
        let filterStr = getSharableLink.getAppliedFiltersForSharingDomesticJourney(legs: self.flightSearchResultVM?.flightLegs ?? [])
        
        self.getSharableLink.getUrl(adult: "\(flightAdultCount)", child: "\(flightChildrenCount)", infant: "\(flightInfantCount)",isDomestic: isDomestic, isInternational: false, journeyArray: journey, valString: "", trip_type: "single",filterString: filterStr)
        
    }
}

extension FlightResultSingleJourneyVC : MFMailComposeViewControllerDelegate {
    
    func returnSharableUrl(url: String)
    {
        sharePinnedFilghts.displayLoadingIndicator(false)
        self.sharePinnedFilghts.setImage(UIImage(named: "SharePinned"), for: .normal)

        if url == "No Data"{
            AertripToastView.toast(in: self.view, withText: "Something went wrong. Please try again.")
        }else{
            let textToShare = [ "Checkout my favourite flights on Aertrip!\n\(url)" ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}



extension FlightResultSingleJourneyVC {
    
    //MARK:- Sharing Journey
    func executeWebServiceForShare(with postData: Data , onCompletion:@escaping (String) -> ()) {
        let webservice = WebAPIService()
        
        webservice.executeAPI(apiServive: .getShareUrl(postData: postData ) , completionHandler: {    (data) in
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let currentParsedResponse = parse(data: data, into: getPinnedURLResponse.self, with:decoder) {
                let data = currentParsedResponse.data
                if let link = data["u"] {
                    onCompletion(link)
                }
            }
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    func executeWebServiceForEmail(with postData: Data , onCompletion:@escaping (String) -> ()) {
        let webservice = WebAPIService()
        
        webservice.executeAPI(apiServive: .getEmailUrl(postData: postData ) , completionHandler: {    (receivedData) in
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let currentParsedResponse = parse(data: receivedData, into: getPinnedURLResponse.self, with:decoder) {
                let data = currentParsedResponse.data
                if let view = data["view"] {
                    onCompletion(view)
                }
            }
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    
    func generatePostDataForEmail( for journey : [Journey] ) -> Data? {
        
        let flightAdultCount = self.viewModel.bookFlightObject.flightAdultCount
        let flightChildrenCount = self.viewModel.bookFlightObject.flightChildrenCount
        let flightInfantCount = self.viewModel.bookFlightObject.flightInfantCount
        let isDomestic = self.viewModel.bookFlightObject.isDomestic
        
        guard let firstJourney = journey.first else { return nil}
        
        let cc = firstJourney.cc
        let ap = firstJourney.ap
        
        let trip_type = "single"
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let departDate = inputFormatter.string(from: self.viewModel.bookFlightObject.onwardDate)
        
        var valueString = "https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(flightAdultCount)&child=\(flightChildrenCount)&infant=\(flightInfantCount)&origin=\(ap[0])&destination=\(ap[1])&depart=\(departDate)&cabinclass=\(cc)&pType=flight&isDomestic=\(isDomestic)"
        
        
        for i in 0 ..< journey.count {
            let tempJourney = journey[i]
            valueString = valueString + "&PF[\(i)]=\(tempJourney.fk)"
        }
        
        var parameters = [ "u": valueString , "sid": self.viewModel.bookFlightObject.sid ]
        
        
        let fkArray = journey.map{ $0.fk }
        
        for i in 0 ..< fkArray.count {
            let key = "fk%5B\(i)%5D"
            parameters[key] = fkArray[i]
        }
        
        
        let parameterArray = parameters.map { (arg) -> String in
            let (key, value) = arg
            
            let percentEscapeString = self.percentEscapeString(value!)
            return "\(key)=\(percentEscapeString)"
        }
        
        let data = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
        return data
    }
    
    func percentEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    func generatePostData( for journey : [Journey] ) -> NSData? {
        
        
        let flightAdultCount = self.viewModel.bookFlightObject.flightAdultCount
        let flightChildrenCount = self.viewModel.bookFlightObject.flightChildrenCount
        let flightInfantCount = self.viewModel.bookFlightObject.flightInfantCount
        let isDomestic = self.viewModel.bookFlightObject.isDomestic
        
        guard let firstJourney = journey.first else { return nil}
        
        let cc = firstJourney.cc
        let ap = firstJourney.ap
        
        let trip_type = "single"
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let departDate = inputFormatter.string(from: self.viewModel.bookFlightObject.onwardDate)
        
        let postData = NSMutableData()
        
        var valueString = "https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(flightAdultCount)&child=\(flightChildrenCount)&infant=\(flightInfantCount)&origin=\(ap[0])&destination=\(ap[1])&depart=\(departDate)&cabinclass=\(cc)&pType=flight&isDomestic=\(isDomestic)"
        
        for i in 0 ..< journey.count {
            let tempJourney = journey[i]
            valueString = valueString + "&PF[\(i)]=\(tempJourney.fk)"
        }
        
        let parameters = [
            [
                "name": "u",
                "value": valueString
            ]
        ]
        
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        
        var body = ""
        let _: NSError? = nil
        for param in parameters {
            let paramName = param["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let filename = param["fileName"] {
                let contentType = param["content-type"]!
                let fileContent = try! String(contentsOfFile: filename, encoding: String.Encoding.utf8)
                body += "; filename=\"\(filename)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent
            } else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }
        
        
        guard let bodyData = body.data(using: String.Encoding.utf8) else { return nil }
        postData.append(bodyData)
        
        return postData
    }
    
}


extension FlightResultSingleJourneyVC {
    
    func updatePriceWhenGoneup(_ fk: String , changeResult : ChangeResult) {
        
        var curJourneyArr = [JourneyOnewayDisplay]()
               
               if viewModel.resultTableState == .showRegularResults {
                   curJourneyArr = viewModel.results.suggestedJourneyArray
               } else {
                   curJourneyArr = viewModel.results.allJourneys
               }
        
        print(curJourneyArr.count)
        
           guard let index = curJourneyArr.firstIndex(where: {
                    
                    for journey in $0.journeyArray {
                        if journey.fk == fk {
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
        displayArray.journeyArray[journeyArrayIndex].fare.BF.value = changeResult.fare.bf.value
        displayArray.journeyArray[journeyArrayIndex].fare.taxes.value = changeResult.fare.taxes.value
        displayArray.journeyArray[journeyArrayIndex].fare.taxes.details = changeResult.fare.taxes.details
        displayArray.journeyArray[journeyArrayIndex].fare.totalPayableNow.value = changeResult.fare.totalPayableNow.value
        curJourneyArr[index] = displayArray
        
        resultsTableView.tableFooterView?.isHidden = true
        self.resultsTableView.reloadData()
        delay(seconds: 0.5) {
            self.resultsTableView.tableFooterView?.isHidden = false
        }
        showFooterView()
    }
    
}
