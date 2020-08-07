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
    }
    else {
       
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
    
     func hidePinnedFlightOptions( _ hide : Bool){
        //*******************Haptic Feedback code********************
           let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
           selectionFeedbackGenerator.selectionChanged()
        //*******************Haptic Feedback code********************

        print("hide=\(hide)")
        if hide{
            
            //true - hideOption
            
            UIView.animate(withDuration: TimeInterval(0.4), delay: 0, options: .curveEaseOut, animations: { [weak self] in
                self?.showPinnedSwitch.isUserInteractionEnabled = false

                   self?.unpinnedAllButton.alpha = 0.0
                   self?.emailPinnedFlights.alpha = 0.0
                   self?.sharePinnedFilghts.alpha = 0.0
                   self?.unpinnedAllButton.transform = CGAffineTransform(translationX: 0, y: 0)
                   self?.emailPinnedFlights.transform = CGAffineTransform(translationX: 0, y: 0)
                   self?.sharePinnedFilghts.transform = CGAffineTransform(translationX: 0, y: 0)
                   }, completion: { [weak self] (success)
            in
                       self?.unpinnedAllButton.isHidden = true
                       self?.emailPinnedFlights.isHidden = true
                       self?.sharePinnedFilghts.isHidden = true
                       self?.unpinnedAllButton.alpha = 1.0
                       self?.emailPinnedFlights.alpha = 1.0
                       self?.sharePinnedFilghts.alpha = 1.0
                    self?.showPinnedSwitch.isUserInteractionEnabled = true
               })
        }else{
            //false - showOption
            self.unpinnedAllButton.alpha = 0.0
            self.emailPinnedFlights.alpha = 0.0
            self.sharePinnedFilghts.alpha = 0.0
            UIView.animate(withDuration: TimeInterval(0.4), delay: 0, options: [.curveEaseOut, ], animations: { [weak self] in
                self?.showPinnedSwitch.isUserInteractionEnabled = false

                self?.unpinnedAllButton.isHidden = false
                self?.emailPinnedFlights.isHidden = false
                self?.sharePinnedFilghts.isHidden = false

                self?.unpinnedAllButton.alpha = 1.0
                self?.emailPinnedFlights.alpha = 1.0
                self?.sharePinnedFilghts.alpha = 1.0
                self?.unpinnedAllButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self?.emailPinnedFlights.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self?.sharePinnedFilghts.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self?.emailPinnedFlights.transform = CGAffineTransform(translationX: 60, y: 0)
                self?.sharePinnedFilghts.transform = CGAffineTransform(translationX: 114, y: 0)
                self?.unpinnedAllButton.transform = CGAffineTransform(translationX: 168, y: 0)
                }, completion: { [weak self] (success)
                    in
                    self?.showPinnedSwitch.isUserInteractionEnabled = true
            })
        }
    }


func showPinnedFlightsOption(_ show  : Bool)
{
    let offsetFromBottom = show ? 60.0 + self.view.safeAreaInsets.bottom : 0
    self.pinnedFlightOptionsTop.constant = CGFloat(offsetFromBottom)
    
    UIView.animate(withDuration: 0.6, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
        self.view.layoutIfNeeded()
    }, completion: nil)
  }
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
                        
                    if self.viewModel.resultTableState == .showExpensiveFlights {
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
    
    func makeMenusFor(journey : Journey? ,  fk: String? , markPinned : Bool) -> UIMenu
    {
        if let currentJourney = journey {
         let pinTitle : String
        pinTitle = markPinned ? "Pin" : "Unpin"
            
            let pin = UIAction(title:  pinTitle , image: UIImage(systemName: "pin" ), identifier: nil) { (action) in
                guard let flightKey = fk else {
                    return
                }
                self.setPinnedFlightAt(flightKey, isPinned: markPinned)
            }
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil) {[weak self] (action) in
                
                guard let strongSelf = self else { return }
                guard let strongJourney = journey else { return }
                strongSelf.shareJourney(journey: strongJourney)
                
            }
            let addToTrip = UIAction(title: "Add To Trip", image: UIImage(systemName: "map" ), identifier: nil) { (action) in
                
                self.addToTrip(journey: currentJourney)
            }
            
            // Create and return a UIMenu with all of the actions as children
            return UIMenu(title: "", children: [pin, share, addToTrip])
        }
        
        return UIMenu(title: "", children: [])
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
        
        showPinnedSwitch.isOn = false
        hidePinnedFlightOptions(true)
        viewModel.resultTableState = stateBeforePinnedFlight
        showPinnedFlightsOption(false)
        resultsTableView.reloadData()
        showFooterView()
        resultsTableView.setContentOffset(.zero, animated: true)
    }
    
    func shareJourney(journey : Journey) {
         
        if #available(iOS 13.0, *) {

        guard let postData = generatePostData(for: [journey]) else { return }
        
        executeWebServiceForShare(with: postData as Data, onCompletion:{ (link)  in
            
            DispatchQueue.main.async {
                let textToShare = [ link ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        })
        }
    }
}

extension FlightResultSingleJourneyVC : MFMailComposeViewControllerDelegate {
    
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
          
          let flightAdultCount = bookFlightObject.flightAdultCount
           let flightChildrenCount = bookFlightObject.flightChildrenCount
           let flightInfantCount = bookFlightObject.flightInfantCount
           let isDomestic = bookFlightObject.isDomestic
           
          guard let firstJourney = journey.first else { return nil}
          
           let cc = firstJourney.cc
           let ap = firstJourney.ap
           
           let trip_type = "single"
           
          let inputFormatter = DateFormatter()
          inputFormatter.dateFormat = "dd-MM-yyyy"
          let departDate = inputFormatter.string(from: bookFlightObject.onwardDate)
           
          var valueString = "https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(flightAdultCount)&child=\(flightChildrenCount)&infant=\(flightInfantCount)&origin=\(ap[0])&destination=\(ap[1])&depart=\(departDate)&cabinclass=\(cc)&pType=flight&isDomestic=\(isDomestic)"
          
          
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
          
      func percentEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return string
          .addingPercentEncoding(withAllowedCharacters: characterSet)!
          .replacingOccurrences(of: " ", with: "+")
          .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
      }
      
      func generatePostData( for journey : [Journey] ) -> NSData? {
          
          
          let flightAdultCount = bookFlightObject.flightAdultCount
          let flightChildrenCount = bookFlightObject.flightChildrenCount
          let flightInfantCount = bookFlightObject.flightInfantCount
          let isDomestic = bookFlightObject.isDomestic
          
          guard let firstJourney = journey.first else { return nil}
          
          let cc = firstJourney.cc
          let ap = firstJourney.ap
          
          let trip_type = "single"
          
          let inputFormatter = DateFormatter()
          inputFormatter.dateFormat = "dd-MM-yyyy"
          let departDate = inputFormatter.string(from: bookFlightObject.onwardDate)
           
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
