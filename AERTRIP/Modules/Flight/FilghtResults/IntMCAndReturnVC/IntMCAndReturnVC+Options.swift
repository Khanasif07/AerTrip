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
                showPinnedSwitch.isOn = false
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
          
          let offsetFromBottom = show ? -22 : 70
          self.pinnedFlightOptionsTop.constant = CGFloat(offsetFromBottom)
          
          UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
              self.view.layoutIfNeeded()
          }, completion: nil)
          
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
                 strongSelf.shareJourney(journey: journey)
             }
             let addToTrip = UIAction(title: "Add To Trip", image: UIImage(systemName: "map" ), identifier: nil) { (action) in
                 
                   self.addToTrip(journey: journey)
             }
             
             // Create and return a UIMenu with all of the actions as children
             return UIMenu(title: "", children: [pin, share, addToTrip])
     }
     

     
 
     func performUnpinnedAllAction() {
        for i in 0 ..< viewModel.results.allJourneys.count {
               
            let journeyGroup = viewModel.results.journeyArray[i]
               let newJourneyGroup = journeyGroup
               newJourneyGroup.journeyArray = journeyGroup.journeyArray.map{
                var journey = $0
                   journey.isPinned = false
                   return journey
               }
               
            viewModel.results.journeyArray[i] = newJourneyGroup
           }
           
           showPinnedSwitch.isOn = false
           hidePinnedFlightOptions(true)
          viewModel.resultTableState = stateBeforePinnedFlight
           
           showPinnedFlightsOption(false)
           resultsTableView.reloadData()
           showFooterView()
           
           resultsTableView.setContentOffset(.zero, animated: true)
       }
    
    func shareJourney(journey : IntMultiCityAndReturnWSResponse.Results.J) {
             
            guard let postData = generatePostData(for: [journey]) else { return }
            
            executeWebServiceForShare(with: postData as Data, onCompletion:{ (link)  in
                
                DispatchQueue.main.async {
                        let textToShare = [ "Checkout my favourite flights on Aertrip!\n\(link)" ]
                        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView = self.view
                        self.present(activityViewController, animated: true, completion: nil)
                }
            })
        }
    
    func generateCommonString(for journey: [IntMultiCityAndReturnWSResponse.Results.J])-> String{
        
        
        let tripType = (self.bookFlightObject.flightSearchType == RETURN_JOURNEY) ? "return" : "multi"
        var valueString = "https://beta.aertrip.com/flights?trip_type=\(tripType)&"
        
        // Adding Passanger Count
        let flightAdultCount = bookFlightObject.flightAdultCount
        let flightChildrenCount = bookFlightObject.flightChildrenCount
        let flightInfantCount = bookFlightObject.flightInfantCount
        valueString += "adult=\(flightAdultCount)&child=\(flightChildrenCount)&infant=\(flightInfantCount)"
        guard let firstJourney = journey.first else { return ""}
        var origin = ""
        var destination = ""
        var dprtDate = ""
        var rtrnDate = ""
        var cabinclass = firstJourney.cc
        if (self.bookFlightObject.flightSearchType == RETURN_JOURNEY){
            if let searchParam = (self.parent as? FlightResultBaseViewController)?.flightSearchParameters as? [String: Any]{
                origin += "&origin=\(searchParam["origin"] ?? "")"
                destination += "&destination=\(searchParam["destination"] ?? "")"
                dprtDate += "&depart=\(searchParam["depart"] ?? "")"
                rtrnDate += "&return=\(searchParam["return"] ?? "")"
            }else{
                
                origin += "&origin=\(firstJourney.legsWithDetail.first?.originIATACode ?? "")"
                destination += "&destination=\(firstJourney.legsWithDetail.first?.destinationIATACode ?? "")"
                dprtDate += "&depart=\(self.converDateFormate(dateStr:firstJourney.legsWithDetail.first?.dd ?? ""))"
                rtrnDate = "&return=\(self.converDateFormate(dateStr:firstJourney.legsWithDetail.last?.ad ?? ""))"
            }
        }else{
            if let searchParam = (self.parent as? FlightResultBaseViewController)?.flightSearchParameters{
                
                let departKey = (searchParam.allKeys as? [String] ?? []).map{$0.contains("depart")}
                cabinclass = searchParam["cabinclass"] as? String ?? cabinclass
                for i in 0..<departKey.count{
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
        return valueString
        
    }
    
        
    func generatePostData( for journey : [IntMultiCityAndReturnWSResponse.Results.J] ) -> NSData? {
        
        var valueString  = self.generateCommonString(for: journey)
        let postData = NSMutableData()
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
        
        func addToTrip(journey : IntMultiCityAndReturnWSResponse.Results.J) {
    //            let tripListVC = TripListVC(nibName: "TripListVC", bundle: nil)
    //            tripListVC.journey = [journey]
    //            tripListVC.modalPresentationStyle = .overCurrentContext
    //            self.present(tripListVC, animated: true, completion: nil)
        }
    
    func generatePostDataForEmail( for journey : [IntMultiCityAndReturnWSResponse.Results.J] ) -> Data? {
        var valueString  = self.generateCommonString(for: journey)
        for i in 0 ..< journey.count {
            let tempJourney = journey[i]
            valueString = valueString + "&PF[\(i)]=\(tempJourney.fk)"
        }
        var parameters = [ "u": valueString , "sid": bookFlightObject.sid ]
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
    
}


extension IntMCAndReturnVC : MFMailComposeViewControllerDelegate{
        
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
