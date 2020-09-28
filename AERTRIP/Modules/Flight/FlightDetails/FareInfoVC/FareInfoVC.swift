//
//  FareInfo.swift
//  Aertrip
//
//  Created by Monika Sonawane on 27/12/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//
protocol cellHeightDelegate : class {
    func getCellHeight(height:Int,section:Int)
}

protocol flightDetailsSmartIconsDelegate : AnyObject {
    func reloadSmartIconsAtIndexPath()
}


import UIKit

class FareInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, cellHeightDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var fareInfoTableView: UITableView!
    @IBOutlet weak var fareInfoTableViewBottom: NSLayoutConstraint!
    
    //MARK:- Variable Declaration
    weak var delegate : flightDetailsSmartIconsDelegate?
    var fareRulesDelegate : getFareRulesDelegate?
    
    var journey: [Journey]!
    var flights : [FlightDetail]?
    var airportDetailsResult : [String : AirportDetailsWS]!
    var sid = ""
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    var cellDataHeight = 0
    
    var isReturnJourney = false
    var fareInfoData = [NSDictionary]()
    var fareRulesData = [NSDictionary]()
    
    var combineAirlineCancellationFees = [[[String:[String:[cancellationSlabStruct]]]]]()
    var combineAirlineReschedulingFees = [[[String:[String:[cancellationSlabStruct]]]]]()
    
    var rafFees = [[String:[String:Int]]]()
    
    var updatedFareInfo = [updatedFareInfoDataStruct]()
    
    var rowHeight = 0
    var titleViewHeight = 0
    var isTableViewReloaded = false
    var fewSeatsLeftViewHeight = 0
    var selectedIndex : IndexPath?
    var indexFromDelegate = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fareInfoTableView.register(UINib(nibName: "FareInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "FareInfoCell")
        fareInfoTableView.register(UINib(nibName: "ChangeAirportTableViewCell", bundle: nil), forCellReuseIdentifier: "ChangeAirportCell")
        fareInfoTableView.register(UINib(nibName: "CombineFareInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "CombineFareInfoCell")
        fareInfoTableView.alwaysBounceVertical = true
        self.fareInfoTableViewBottom.constant = 0.0
        if journey != nil{
            if journey.count > 1{
                isReturnJourney = true
            }else{
                isReturnJourney = false
            }
            
            flights?.removeAll()
            for i in 0..<journey.count{
                
                if journey[i].leg[0].fcp == 1{
                    self.getFareInfoAPICall(sid: self.sid, fk: self.journey[i].fk,i:i)
                }
                
                let fare = self.journey[i].fare
                
                let airlineCancellationData = fare.cancellationCharges.details.getAirlineCancellationDataForAllFlights()
                combineAirlineCancellationFees.append(airlineCancellationData)
                
                let airlineReschedulingData = fare.reschedulingCharges.details.getAirlineReschedulingDataForAllFlights()
                combineAirlineReschedulingFees.append(airlineReschedulingData)
                
                self.getFareRulesAPICall(sid: self.sid, fk: self.journey[i].fk, index: i)
                
                if let flight = journey[i].leg.first?.flights{
                    flights?.append(flight.first!)
                }
            }
        }
    }
    
    //MARK:- Tableview Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if journey != nil{
            if isReturnJourney == true{
                return journey.count+1
            }else{
                return journey.count
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == journey.count{
            return 1
        }else {
            if journey.count == 1{
                return 3
            }else{
                return 2
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == journey.count {
            let changeAirportCell = tableView.dequeueReusableCell(withIdentifier: "ChangeAirportCell") as! ChangeAirportTableViewCell
            changeAirportCell.titleLabel.text = ""
            changeAirportCell.titleLabelHeight.constant = 0
            changeAirportCell.dataLabelTop.constant = 0
            
            changeAirportCell.dataLabel.attributedText = getAttributedNote()
            changeAirportCell.seperatorBottom.constant = 35
            changeAirportCell.bottomStrokeHeight.constant = 0.7
            return changeAirportCell
        }else{
            if journey.count == 1{
                if indexPath.row == 0{
                    let fareInfoCell = tableView.dequeueReusableCell(withIdentifier: "FareInfoCell") as! FareInfoTableViewCell
                    
                    if self.fareRulesData.count > 0{
                        if self.fareRulesData.count > indexPath.section{
                            let data = [self.fareRulesData[indexPath.section]]
                            let val = data[0]
                            if val.count > 0{
                                
                                let vall = val.allValues
                                if vall.count > 0{
                                    if vall[0] as? String != nil{
                                        if vall[0] as! String != ""
                                        {
                                            fareInfoCell.fareRulesButton.isHidden = false
                                            fareInfoCell.fareRulesButton.isUserInteractionEnabled = true
                                            
                                            fareInfoCell.fareRulesButton.tag = indexPath.section
                                            fareInfoCell.fareRulesButton.addTarget(self, action: #selector(fareRulesButtonClicked(_:)), for: .touchUpInside)
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        fareInfoCell.fareRulesButton.isHidden = true
                        fareInfoCell.fareRulesButton.isUserInteractionEnabled = false
                    }
                    
                    let flight = flights![indexPath.row]
                    let cc = flight.cc
                    let fbn = flight.fbn
                    var bc = flight.bc
                    if bc != ""{
                        bc =  " (" + bc + ")"
                    }
                    var displayTitle = ""
                    if fbn != ""{
                        displayTitle = fbn.capitalized + bc
                    }else{
                        displayTitle = cc.capitalized + bc
                    }
                    
                    if journey.count > 0{
                        var location = ""
                        
                        //                        if journey.count == 1{
                        //                            location = displayTitle
                        //                            fareInfoCell.titleLabel.text = location
                        //                        }else{
                        //                            let ap = self.journey[indexPath.section].ap
                        //                            let departureAirportDetails = self.airportDetailsResult[ap[0]]
                        //                            let arrivalAirportDetails = self.airportDetailsResult[ap[1]]
                        //
                        //                            if departureAirportDetails != nil && arrivalAirportDetails != nil{
                        //                                location = departureAirportDetails!.c! + " → " + arrivalAirportDetails!.c! + "\n" + displayTitle
                        //                            }else if departureAirportDetails != nil{
                        //                                location = departureAirportDetails!.c! + "\n" + displayTitle
                        //                            }else if arrivalAirportDetails != nil{
                        //                                location = arrivalAirportDetails!.c! + "\n" + displayTitle
                        //                            }else{
                        //                                location = displayTitle
                        //                            }
                        //
                        //                            let completeText = NSMutableAttributedString(string: location)
                        //                            let range1 = (location as NSString).range(of: displayTitle)
                        //
                        //                            completeText.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Regular", size: 16.0)! , range: range1)
                        //                            fareInfoCell.titleLabel.attributedText = completeText
                        //                        }
                        //
                        //                        if location.contains("\n"){
                        //                            fareInfoCell.titleViewHeight.constant = 76
                        //                            titleViewHeight = 76
                        //                        }else{
                        //                            titleViewHeight = 50
                        //                        }
                        
                        //                        fareInfoCell.fareRulesViewHeight.constant = 50
                        fareInfoCell.titleLabel.text = displayTitle
                        if journey.count == 1{
                            fareInfoCell.titleLabelTop.constant = 16
                            fareInfoCell.titleViewHeight.constant = 50
                            fareInfoCell.journeyNameLbl.isHidden = true
                            fareInfoCell.carrierImgView.isHidden = true
                            fareInfoCell.journeyNameSeperatorLabel.isHidden = true
                            
                            titleViewHeight = 50
                        }else{
                            fareInfoCell.titleLabelTop.constant = 73.5
                            fareInfoCell.titleViewHeight.constant = 100
                            fareInfoCell.journeyNameLbl.isHidden = false
                            fareInfoCell.carrierImgView.isHidden = false
                            fareInfoCell.journeyNameSeperatorLabel.isHidden = false
                            
                            
                            let ap = self.journey[indexPath.section].ap
                            let departureAirportDetails = self.airportDetailsResult[ap[0]]
                            let arrivalAirportDetails = self.airportDetailsResult[ap[1]]
                            
                            if departureAirportDetails != nil && arrivalAirportDetails != nil{
                                location = departureAirportDetails!.c! + " → " + arrivalAirportDetails!.c!
                            }else if departureAirportDetails != nil{
                                location = departureAirportDetails!.c!
                            }else if arrivalAirportDetails != nil{
                                location = arrivalAirportDetails!.c!
                            }else{
                                location = displayTitle
                            }
                            
                            fareInfoCell.journeyNameLbl.text = location
                            
                            let al = self.journey[indexPath.section].al.first ?? ""
                            
                            let logoURL = "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/" + al.uppercased() + ".png"
                            fareInfoCell.setAirlineImage(with: logoURL)
                            
                            titleViewHeight = 110
                        }
                    }
                    
                    fareInfoCell.bottomSeparatorLabel.isHidden = true
                    fareInfoCell.bottomSeparatorLabelLeading.constant = 16
                    
                    if indexPath.section != 0{
                        fareInfoCell.topSeperatorLabel.isHidden = false
                        fareInfoCell.topSeperatorLabelHeight.constant = 0.5
                    }else{
                        fareInfoCell.topSeperatorLabel.isHidden = true
                        fareInfoCell.topSeperatorLabelHeight.constant = 0
                    }
                    return fareInfoCell
                }else if indexPath.row == 2 {
                    let changeAirportCell = tableView.dequeueReusableCell(withIdentifier: "ChangeAirportCell") as! ChangeAirportTableViewCell
                    changeAirportCell.titleLabel.text = ""
                    changeAirportCell.titleLabelHeight.constant = 0
                    changeAirportCell.dataLabelTop.constant = 0
                    
                    changeAirportCell.dataLabel.attributedText = getAttributedNote()
                    changeAirportCell.topSeperatorLabelLeading.constant = 16
                    changeAirportCell.topSeperatorLabelTop.constant = 12
                    changeAirportCell.seperatorBottom.constant = 35
                    return changeAirportCell
                }else{
                    let fareInfoCell = tableView.dequeueReusableCell(withIdentifier: "CombineFareInfoCell") as! CombineFareInfoTableViewCell
                    
                    fareInfoCell.journey = journey
                    fareInfoCell.flightAdultCount = flightAdultCount
                    fareInfoCell.flightChildrenCount = flightChildrenCount
                    fareInfoCell.flightInfantCount = flightInfantCount
                    fareInfoCell.indexOfCell = indexPath.section
                    
                    if journey[indexPath.section].leg[0].fcp == 1{
                        if updatedFareInfo.count > 0 {
                            fareInfoCell.isNoInfoViewVisible = false
                            fareInfoCell.combineFareTableView.isHidden = false
                            fareInfoCell.noInfoView.isHidden = true
                            
                            let airlineCancellationData = updatedFareInfo[indexPath.section].cp.details.getAirlineCancellationDataForAllFlights()
                            
                            fareInfoCell.airlineCancellationFees = airlineCancellationData
                            
                            let aertripCancellationData = updatedFareInfo[indexPath.section].cp.details.getAertripCancellationDataForAllFlights()
                            fareInfoCell.aertripCancellationFees = aertripCancellationData
                            
                            let airlineReschedulingData = updatedFareInfo[indexPath.section].rscp.details.getAirlineReschedulingDataForAllFlights()
                            fareInfoCell.airlineReschedulingFees = airlineReschedulingData
                            
                            let aertripReschedulingData = updatedFareInfo[indexPath.section].rscp.details.getAertripReschedulingDataForAllFlights()
                            fareInfoCell.aertripReschedulingFees = aertripReschedulingData
                            
                            fareInfoCell.combineAirlineCancellationFees = combineAirlineCancellationFees
                            fareInfoCell.combineAirlineReschedulingFees = combineAirlineReschedulingFees
                            
                            let rafFeesData = updatedFareInfo[indexPath.section].cp.details.RAF
                            
                            fareInfoCell.rafFees = rafFeesData
                            fareInfoCell.combineFareTableView.reloadData()
                        }else{
                            fareInfoCell.isNoInfoViewVisible = true
                            fareInfoCell.combineFareTableView.isHidden = true
                            fareInfoCell.noInfoView.isHidden = false
                        }
                    }else{
                        let airlineCancellationData = journey[indexPath.section].fare.cancellationCharges.details.getAirlineCancellationDataForAllFlights()
                        fareInfoCell.airlineCancellationFees = airlineCancellationData
                        
                        let aertripCancellationData = journey[indexPath.section].fare.cancellationCharges.details.getAertripCancellationDataForAllFlights()
                        fareInfoCell.aertripCancellationFees = aertripCancellationData
                        
                        let airlineReschedulingData = journey[indexPath.section].fare.reschedulingCharges.details.getAirlineReschedulingDataForAllFlights()
                        fareInfoCell.airlineReschedulingFees = airlineReschedulingData
                        
                        let aertripReschedulingData = journey[indexPath.section].fare.reschedulingCharges.details.getAertripReschedulingDataForAllFlights()
                        fareInfoCell.aertripReschedulingFees = aertripReschedulingData
                        
                        fareInfoCell.combineAirlineCancellationFees = combineAirlineCancellationFees
                        fareInfoCell.combineAirlineReschedulingFees = combineAirlineReschedulingFees
                        
                        let rafFeesData = journey[indexPath.section].fare.cancellationCharges.details.RAF
                        
                        fareInfoCell.rafFees = rafFeesData
                    }
                    
                    fareInfoCell.cellHeightDelegate = self
                    tableView.layoutIfNeeded()
                    
                    return fareInfoCell
                }
            }else{
                if indexPath.row == 0{
                    let fareInfoCell = tableView.dequeueReusableCell(withIdentifier: "FareInfoCell") as! FareInfoTableViewCell
                    
                    if self.fareRulesData.count > 0{
                        if self.fareRulesData.count > indexPath.section{
                            let data = [self.fareRulesData[indexPath.section]]
                            let val = data[0]
                            if val.count > 0{
                                let vall = val.allValues
                                if vall.count > 0{
                                    if vall[0] as? String != nil{
                                        if vall[0] as! String != ""
                                        {
                                            fareInfoCell.fareRulesButton.isHidden = false
                                            fareInfoCell.fareRulesButton.isUserInteractionEnabled = true
                                            
                                            fareInfoCell.fareRulesButton.tag = indexPath.section
                                            fareInfoCell.fareRulesButton.addTarget(self, action: #selector(fareRulesButtonClicked(_:)), for: .touchUpInside)
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        fareInfoCell.fareRulesButton.isHidden = true
                        fareInfoCell.fareRulesButton.isUserInteractionEnabled = false
                    }
                    
                    let flight = flights![indexPath.row]
                    let cc = flight.cc
                    let fbn = flight.fbn
                    var bc = flight.bc
                    if bc != ""{
                        bc =  " (" + bc + ")"
                    }
                    var displayTitle = ""
                    if fbn != ""{
                        displayTitle = fbn.capitalized + bc
                    }else{
                        displayTitle = cc.capitalized + bc
                    }
                    
                    if journey.count > 0{
                        var location = ""
                        
                        //                        if journey.count == 1{
                        //                            location = displayTitle
                        //                            fareInfoCell.titleLabel.text = location
                        //                        }else{
                        //                            let ap = self.journey[indexPath.section].ap
                        //                            let departureAirportDetails = self.airportDetailsResult[ap[0]]
                        //                            let arrivalAirportDetails = self.airportDetailsResult[ap[1]]
                        //
                        //                            if departureAirportDetails != nil && arrivalAirportDetails != nil{
                        //                                location = departureAirportDetails!.c! + " → " + arrivalAirportDetails!.c! + "\n" + displayTitle
                        //                            }else if departureAirportDetails != nil{
                        //                                location = departureAirportDetails!.c! + "\n" + displayTitle
                        //                            }else if arrivalAirportDetails != nil{
                        //                                location = arrivalAirportDetails!.c! + "\n" + displayTitle
                        //                            }else{
                        //                                location = displayTitle
                        //                            }
                        //
                        //                            let completeText = NSMutableAttributedString(string: location)
                        //                            let range1 = (location as NSString).range(of: displayTitle)
                        //
                        //                            completeText.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Regular", size: 16.0)! , range: range1)
                        //                            fareInfoCell.titleLabel.attributedText = completeText
                        //                        }
                        //
                        //                        if location.contains("\n"){
                        //                            fareInfoCell.titleViewHeight.constant = 76
                        //                            titleViewHeight = 76
                        //                        }else{
                        //                            titleViewHeight = 50
                        //                        }
                        
                        
                        
                        fareInfoCell.titleLabel.text = displayTitle
                        
                        if journey.count == 1{
                            fareInfoCell.titleViewHeight.constant = 50
                            fareInfoCell.titleLabelTop.constant = 16
                            fareInfoCell.journeyNameLbl.isHidden = true
                            fareInfoCell.carrierImgView.isHidden = true
                            fareInfoCell.journeyNameSeperatorLabel.isHidden = true
                            
                            titleViewHeight = 50
                        }else{
                            fareInfoCell.titleViewHeight.constant = 100
                            fareInfoCell.titleLabelTop.constant = 73.5
                            fareInfoCell.journeyNameLbl.isHidden = false
                            fareInfoCell.carrierImgView.isHidden = false
                            fareInfoCell.journeyNameSeperatorLabel.isHidden = false
                            
                            let ap = self.journey[indexPath.section].ap
                            let departureAirportDetails = self.airportDetailsResult[ap[0]]
                            let arrivalAirportDetails = self.airportDetailsResult[ap[1]]
                            
                            if departureAirportDetails != nil && arrivalAirportDetails != nil{
                                location = departureAirportDetails!.c! + " → " + arrivalAirportDetails!.c!
                            }else if departureAirportDetails != nil{
                                location = departureAirportDetails!.c!
                            }else if arrivalAirportDetails != nil{
                                location = arrivalAirportDetails!.c!
                            }else{
                                location = displayTitle
                            }
                            
                            fareInfoCell.journeyNameLbl.text = location
                            
                            let al = self.journey[indexPath.section].al.first ?? ""
                            
                            let logoURL = "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/" + al.uppercased() + ".png"
                            fareInfoCell.setAirlineImage(with: logoURL)
                            
                            titleViewHeight = 110
                        }
                    }
                    
                    fareInfoCell.bottomSeparatorLabel.isHidden = true
                    
                    if indexPath.section != 0{
                        fareInfoCell.topSeperatorLabel.isHidden = false
                        fareInfoCell.topSeperatorLabelHeight.constant = 0.5
                    }else{
                        fareInfoCell.topSeperatorLabel.isHidden = true
                        fareInfoCell.topSeperatorLabelHeight.constant = 0
                    }
                    return fareInfoCell
                }else{
                    let fareInfoCell = tableView.dequeueReusableCell(withIdentifier: "CombineFareInfoCell") as! CombineFareInfoTableViewCell
                    
                    fareInfoCell.journey = journey
                    fareInfoCell.flightAdultCount = flightAdultCount
                    fareInfoCell.flightChildrenCount = flightChildrenCount
                    fareInfoCell.flightInfantCount = flightInfantCount
                    fareInfoCell.indexOfCell = indexPath.section
                    
                    if journey[indexPath.section].leg[0].fcp == 1{
                        if updatedFareInfo.count > 0
                        {
                            fareInfoCell.isNoInfoViewVisible = false
                            fareInfoCell.combineFareTableView.isHidden = false
                            fareInfoCell.noInfoView.isHidden = true
                            
                            var index = 0
                            
                            if journey.count != updatedFareInfo.count{
                                if indexPath.section > 0{
                                    if indexPath.section > updatedFareInfo.count{
                                        index = indexPath.section-1
                                    }
                                }else{
                                    index = indexPath.section
                                }
                            }else{
                                index = indexPath.section
                            }
                            
                            if index < updatedFareInfo.count{
                                let airlineCancellationData = updatedFareInfo[index].cp.details.getAirlineCancellationDataForAllFlights()
                                
                                fareInfoCell.airlineCancellationFees = airlineCancellationData
                                
                                let aertripCancellationData = updatedFareInfo[index].cp.details.getAertripCancellationDataForAllFlights()
                                fareInfoCell.aertripCancellationFees = aertripCancellationData
                                
                                let airlineReschedulingData = updatedFareInfo[index].rscp.details.getAirlineReschedulingDataForAllFlights()
                                fareInfoCell.airlineReschedulingFees = airlineReschedulingData
                                
                                let aertripReschedulingData = updatedFareInfo[index].rscp.details.getAertripReschedulingDataForAllFlights()
                                fareInfoCell.aertripReschedulingFees = aertripReschedulingData
                                
                                let rafFeesData = updatedFareInfo[index].cp.details.RAF
                                
                                fareInfoCell.rafFees = rafFeesData
                            }
                            
                            fareInfoCell.combineAirlineCancellationFees = combineAirlineCancellationFees
                            fareInfoCell.combineAirlineReschedulingFees = combineAirlineReschedulingFees
                            
                            fareInfoCell.combineFareTableView.reloadData()
                        }else{
                            fareInfoCell.isNoInfoViewVisible = true
                            fareInfoCell.combineFareTableView.isHidden = true
                            fareInfoCell.noInfoView.isHidden = false
                        }
                    }else{
                        
                        let airlineCancellationData = journey[indexPath.section].fare.cancellationCharges.details.getAirlineCancellationDataForAllFlights()
                        
                        fareInfoCell.airlineCancellationFees = airlineCancellationData
                        
                        let aertripCancellationData = journey[indexPath.section].fare.cancellationCharges.details.getAertripCancellationDataForAllFlights()
                        fareInfoCell.aertripCancellationFees = aertripCancellationData
                        
                        let airlineReschedulingData = journey[indexPath.section].fare.reschedulingCharges.details.getAirlineReschedulingDataForAllFlights()
                        fareInfoCell.airlineReschedulingFees = airlineReschedulingData
                        
                        let aertripReschedulingData = journey[indexPath.section].fare.reschedulingCharges.details.getAertripReschedulingDataForAllFlights()
                        fareInfoCell.aertripReschedulingFees = aertripReschedulingData
                        
                        fareInfoCell.combineAirlineCancellationFees = combineAirlineCancellationFees
                        fareInfoCell.combineAirlineReschedulingFees = combineAirlineReschedulingFees
                        
                        let rafFeesData = journey[indexPath.section].fare.cancellationCharges.details.RAF
                        
                        fareInfoCell.rafFees = rafFeesData
                    }
                    
                    fareInfoCell.cellHeightDelegate = self
                    
                    tableView.layoutIfNeeded()
                    
                    return fareInfoCell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == journey.count {
            return UITableView.automaticDimension
        }else{
            if journey.count == 1{
                if indexPath.row == 0{
                    return CGFloat(titleViewHeight)
                }else if indexPath.row == 2{
                    return UITableView.automaticDimension
                }else{
                    if rowHeight != 0{
                        return CGFloat(rowHeight)
                    }else{
                        return UITableView.automaticDimension
                    }
                }
            }else{
                if indexPath.row == 0{
                    return CGFloat(titleViewHeight)
                }else{
                    if rowHeight != 0{
                        return CGFloat(rowHeight)
                    }else{
                        return UITableView.automaticDimension
                    }
                }
            }
        }
    }
    
    func getCellHeight(height: Int,section:Int)
    {
        rowHeight = height
        indexFromDelegate = section
        fareInfoTableView.reloadData()
    }
    
    //MARK:- Scrollview Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        var isHidden = false
        var viewHeight = 0.0
        if scrollView.contentOffset.y < 0{
            isHidden = false
            viewHeight = 0.5
        }else{
            isHidden = true
            viewHeight = 0
        }
        if let cell = fareInfoTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? FareInfoTableViewCell {
            cell.topSeperatorLabel.isHidden = isHidden
            cell.topSeperatorLabelHeight.constant = CGFloat(viewHeight)
        }
    }
    
    //MARK:- API Call
    func getFareInfoAPICall(sid: String, fk: String,i:Int){
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .fareInfoResult(sid: sid, fk: fk), completionHandler: {    (data) in
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            DispatchQueue.main.async {
                if let currentParsedResponse = parse(data: data, into: updatedFareInfoStruct.self, with:decoder) {
                    
                    if currentParsedResponse.success == true{
                        
                        if self.journey[i].smartIconArray.contains("refundStatusPending")
                        {
                            self.journey[i].leg[0].fcp = 0
                            self.delegate?.reloadSmartIconsAtIndexPath()
                        }
                        
                        self.updatedFareInfo.append(currentParsedResponse.data.first!.value)
                        self.fareInfoTableView.reloadData()
                    }
                }
            }
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    func getFareRulesAPICall(sid: String, fk: String, index:Int)
    {
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .fareRulesResult(sid: sid, fk: fk), completionHandler: {    (data) in
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject] {
                        
                        if let data = result["data"] as? NSDictionary {
                            
                            let keys = data.allKeys
                            if keys.count > 0{
                                for i in 0...keys.count-1{
                                    let str = keys[i] as! String
                                    
                                    if let datas = data.value(forKey: str) as? NSDictionary{
                                        while self.fareRulesData.count <= index {
                                            self.fareRulesData.append([:])
                                        }
                                        
                                        self.fareRulesData[index] = datas
                                    }
                                }
                            }
                            self.fareInfoTableView.reloadData()
                        }
                    }
                }
            }catch{
                
            }
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    //MARK:- Button Action
    @objc func fareRulesButtonClicked(_ sender:UIButton)
    {
        if self.fareRulesData.count > 0{
            self.fareRulesDelegate?.getFareRulesData(fareRules: [self.fareRulesData[sender.tag]])
        }
    }
    
    func getAttributedNote() -> NSMutableAttributedString
    {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.headIndent = 15
        style.paragraphSpacingBefore = 16
        
        let str1 = "IMPORTANT".capitalized
        let str2 = "\n•    Above mentioned charges are per passenger per sector, applicable only on refundable fares.\n•    Total Cancellation Charges displayed above include Cancellation Fees, RAF & GST.\n•    Total Rescheduling Charges = Rescheduling Fees as above + Fare Difference + Differences in Taxes (if any).\n•    In case of no-show or if the ticket is not cancelled or amended within the stipulated time, no refund is applicable.\n•    Airlines do not accept cancellation/rescheduling requests 1-75 hours before departure the flight, depending on the airline, fare basis and booking fare policy. You must raise a request at least 2 hours before the airline request time.\n•    In case of restricted fares, no amendments and/or cancellation may be allowed.\n•    In case of combo fares or round-trip special fares or tickets booked under special discounted fares, cancellation of a partial journey may not be allowed. In certain cases, cancellation or amendment of future sectors may be allowed only if the previous sectors are flown."
        let str3 = "\n\nDISCLAIMER".capitalized
        let str4 = "\n•    Above mentioned charges are indicative, subject to currency fluctuations and can change without prior notice. They need to be re-confirmed before making any amendments or cancellation. Aertrip does not guarantee or warrant this information."
        let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
        let fontSuper:UIFont? = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
        
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font!])
        let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper!])
        
        let attString2:NSMutableAttributedString = NSMutableAttributedString(string: str3, attributes: [.font:font!])
        let attString3:NSMutableAttributedString = NSMutableAttributedString(string: str4, attributes: [.font:fontSuper!])
        
        attString.append(attString1)
        attString.append(attString2)
        attString.append(attString3)
        
        attString.addAttributes([NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black], range: NSRange(location: 0, length: attString.string.count))
        
        return attString
    }
}
