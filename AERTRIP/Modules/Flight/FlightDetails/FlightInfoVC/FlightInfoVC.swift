//
//  FlightInfoVC.swift
//  FlightDetails
//
//  Created by Monika Sonawane on 11/09/19.
//  Copyright © 2019 Monika Sonawane. All rights reserved.
//


import Parchment

protocol getSelectedAmenitiesDelegate: class {
    func getSelectedAmenities(amenitiesData:[String:String], index:Int, cellIndexPath: IndexPath)
}

protocol flightDetailsBaggageDelegate : AnyObject {
    func reloadBaggageSuperScriptAtIndexPath()
}


//MARK:- Codable
public struct flightPerformaceResponse : Codable
{
    var success : Bool?
    var data : flightPerformaceDelayIndexResponse?
}

public struct flightPerformaceDelayIndexResponse : Codable {
    var delayIndex : flightPerfomanceResultData?
}

public struct flightPerfomanceResultData : Codable {
    let ontime : String?
    var cancelled : String?
    let late : String?
    let averageDelay : String?
    let observationCount : String?
    var index:[Int]?
}

import UIKit

final class FlightInfoVC: BaseVC, UITableViewDataSource, UITableViewDelegate, getSelectedAmenitiesDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var flightInfoTableView: UITableView!
    @IBOutlet weak var flightInfoTableViewBottom: NSLayoutConstraint!
    
    //MARK:- Variable Declaration
    weak var delegate : flightDetailsBaggageDelegate?
    
    weak var arrivalPerformanceDelegate : getArrivalPerformanceDelegate?
    
    var journey: [Journey]!
    var titleString : NSAttributedString!
    var airportDetailsResult : [String : AirportDetailsWS]!
    var airlineDetailsResult : [String : AirlineMasterWS]!
    
    var flightsResults  =  FlightsResults()
    var baggageData = [JSONDictionary]()
    var isChangeOfAirport = false
    var sid = ""
    var isTableviewScrolledDown = false
    let clearCache = ClearCache()
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedIndex : IndexPath!
    var selectedJourneyFK = [String]()
    var fewSeatsLeftViewHeight = 0
    var isInternational = false//For International results.
    var viewModel = FlightDetailsInfoVM()
    
    //MARK:- Initial Display Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearCache.checkTimeAndClearFlightPerformanceResultCache(journey: &journey)
        clearCache.checkTimeAndClearFlightBaggageResultCache()
        
        getFlightsInfo()
        self.viewModel.delegate = self
        flightInfoTableView.estimatedRowHeight = UITableView.automaticDimension
        flightInfoTableView.alwaysBounceVertical = true
        
        flightInfoTableView.register(UINib(nibName: "FlightDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "FlightDetailsCell")
        flightInfoTableView.register(UINib(nibName: "LayoverViewTableViewCell", bundle: nil), forCellReuseIdentifier: "LayoverViewCell")
        flightInfoTableView.register(UINib(nibName: "ChangeAirportTableViewCell", bundle: nil), forCellReuseIdentifier: "ChangeAirportCell")
        self.flightInfoTableViewBottom.constant = 0.0
        self.flightInfoTableView.contentInset = UIEdgeInsets(top: -0.5, left: 0, bottom: 0, right: 0)
        flightInfoTableView.showsVerticalScrollIndicator = true
    }
    
    //MARK:- Get Flight Info
    
    func getFlightsInfo() {
        if journey != nil{
            for j in 0..<journey.count{
                
                if appdelegate.flightBaggageMutableArray.count == 0{
                    self.viewModel.callAPIforBaggageInfo(sid: sid, fk: journey[j].fk)
                }else{
                    for i in 0..<self.appdelegate.flightBaggageMutableArray.count{
                        if let baggageArray = self.appdelegate.flightBaggageMutableArray[i] as? JSONDictionary
                        {
                            let selectedIndex = baggageArray["selectedJourneyFK"] as! [String]
                            if self.selectedJourneyFK == selectedIndex{
                                let baggageDataResponse = baggageArray["BaggageDataResponse"] as! [JSONDictionary]
                                self.baggageData = baggageDataResponse
                            }
                        }
                    }
                    
                    if self.baggageData.count == 0{
                        self.viewModel.callAPIforBaggageInfo(sid: sid, fk: journey[j].fk)
                    }
                }
                
                if let allFlights = journey[j].leg.first?.flights{
                    for k in 0..<allFlights.count{
                        let flight = allFlights[k]
                        
                        if flight.ontimePerformanceDataStoringTime == nil{
                            self.viewModel.callAPIforFlightsOnTimePerformace(origin: flight.fr, destination: flight.to, airline: flight.al, flight_number: flight.fn, index: [j,k], FFK:flight.ffk)
                        }
                        
                        if k > 0{
                            let prevFlight = allFlights[k-1]
                            
                            if flight.fr != prevFlight.to{
                                journey[j].leg[0].flights[k].isDepartureAirportChange = true
                                journey[j].leg[0].flights[k-1].isArrivalAirportChange = true
                                
                                isChangeOfAirport = true
                            }else{
                                journey[j].leg[0].flights[k].isDepartureAirportChange = false
                                journey[j].leg[0].flights[k-1].isArrivalAirportChange = false
                            }
                            
                            if isChangeOfAirport == true{
                                journey[j].leg[0].flights[k].isDepartureTerminalChange = false
                                journey[j].leg[0].flights[k-1].isArrivalTerminalChange = false
                            }else{
                                if flight.dtm != prevFlight.atm
                                {
                                    journey[j].leg[0].flights[k].isDepartureTerminalChange = true
                                    journey[j].leg[0].flights[k-1].isArrivalTerminalChange = true
                                    
                                }else{
                                    journey[j].leg[0].flights[k].isDepartureTerminalChange = false
                                    journey[j].leg[0].flights[k-1].isArrivalTerminalChange = false
                                }
                            }
                            
                            
                            if flight.dd != prevFlight.ad{
                                journey[j].leg[0].flights[k].isDepartureDateChange = true
                            }else{
                                journey[j].leg[0].flights[k].isDepartureDateChange = false
                            }
                            
                        }else{
                            journey[j].leg[0].flights[k].isDepartureTerminalChange = false
                            journey[j].leg[0].flights[k].isArrivalTerminalChange = false
                            
                            journey[j].leg[0].flights[k].isDepartureAirportChange = false
                            journey[j].leg[0].flights[k].isArrivalAirportChange = false
                            
                            journey[j].leg[0].flights[k].isDepartureDateChange = false
                            
                        }
                    }
                }
            }
        }
    }
    
    //MARK:- TableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if journey != nil{
            if isChangeOfAirport == true{
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
        if isChangeOfAirport == true{
            if section == journey.count{
                return 1
            }else{
                if var flightCount = journey[section].leg.first?.flights.count
                {
                    if flightCount > 0{
                        if flightCount > 1{
                            flightCount = flightCount + flightCount-1
                            return flightCount
                        }else{
                            return flightCount
                        }
                    }else{
                        return 0
                    }
                }else{
                    return 0
                }
            }
        }else{
            if var flightCount = journey[section].leg.first?.flights.count{
                if flightCount > 0{
                    if flightCount > 1{
                        flightCount = flightCount + flightCount-1
                        return flightCount
                    }else{
                        return flightCount
                    }
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == journey.count{
            guard let changeAirportCell = tableView.dequeueReusableCell(withIdentifier: "ChangeAirportCell") as? ChangeAirportTableViewCell else { return UITableViewCell()}
            changeAirportCell.titleLabel.text = "Change of Airport"
            
            let myMutableString = NSMutableAttributedString(string: "While changing airports, re-checking baggage and going back through security may be necessary. Ensure you have ample time between transfers. Kindly check all terms regarding connection, baggage transfer, visas, etc. with the airlines directly before booking this itinerary.")
            
            changeAirportCell.dataLabel.attributedText = myMutableString
            
            return changeAirportCell
        }else{
            let count = journey[indexPath.section].leg.first?.flights.count ?? 0
            if count > 0{
                if indexPath.row % 2 == 0{
                    guard let flightDetailsCell = tableView.dequeueReusableCell(withIdentifier: "FlightDetailsCell") as? FlightDetailsTableViewCell else { return UITableViewCell()}
                    
                    var index = 0
                    if indexPath.row > 0{
                        index = indexPath.row/2
                    }else{
                        index = indexPath.row
                    }
                    
                    if let flight = journey[indexPath.section].leg.first?.flights[index] {
                        var amenitiesData = [String]()
                        
                        if let bgWeight = flight.bg?["ADT"]?.weight, let bgPieces = flight.bg?["ADT"]?.pieces {
                            if bgPieces != "" && bgPieces != "-9" && bgPieces != "-1" && bgPieces != "0 pc" && bgPieces != "0" {
                                if isSEDevice{
                                    amenitiesData.append("Check-in Baggage (\(bgPieces))")
                                }else{
                                    amenitiesData.append("Check-in Baggage \n(\(bgPieces))")
                                }
                            } else {
                                if bgWeight != "" && bgWeight != "-9" && bgWeight != "-1" && bgWeight != "0 kg"{
                                    if isSEDevice{
                                        amenitiesData.append("Check-in Baggage (\(bgWeight))")
                                    }else{
                                        amenitiesData.append("Check-in Baggage \n(\(bgWeight))")
                                    }
                                }
                            }
                        }
                        
                        if baggageData.count > 0{
                            if index < baggageData.count{
                                if amenitiesData.count == 0{
                                    if let bgData = baggageData[index]["bg"] as? JSONDictionary{
                                        if let adtBaggage = bgData["ADT"] as? JSONDictionary{
                                            if let weight = adtBaggage["weight"] as? String, let pieces = adtBaggage["pieces"] as? String
                                            {
                                                self.journey[indexPath.section].leg[0].flights[index].bg = ["ADT":baggageStruct.init(weight: weight, pieces: pieces, note: "")]
                                                
                                                self.delegate?.reloadBaggageSuperScriptAtIndexPath()
                                                
                                                if pieces != "" && pieces != "-9" && pieces != "-1" && pieces != "0 pc" && pieces != "0"
                                                {
                                                    if isSEDevice{
                                                        amenitiesData.append("Check-in Baggage (\(pieces))")
                                                    }else{
                                                        amenitiesData.append("Check-in Baggage \n(\(pieces))")
                                                    }
                                                }else{
                                                    if weight != "" && weight != "-9" && weight != "-1" && weight != "0 kg"{
                                                        if isSEDevice{
                                                            amenitiesData.append("Check-in Baggage (\(weight))")
                                                        }else{
                                                            amenitiesData.append("Check-in Baggage \n(\(weight))")
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                
                                if let cbgData = baggageData[index]["cbg"] as? JSONDictionary{
                                    if let adtCabinBaggage = cbgData["ADT"] as? JSONDictionary{
                                        if let weight = adtCabinBaggage["weight"] as? String, let pieces = adtCabinBaggage["pieces"] as? String
                                        {
                                            if weight != "" && weight != "-9" && weight != "-1" && weight != "0 kg"{
                                                amenitiesData.append("Cabbin Baggage \n(\(weight))")
                                            }else{
                                                if pieces != "" && pieces != "-9" && pieces != "-1" && pieces != "0 pc" && pieces != "0" && weight != "0 kg"{
                                                    
                                                    if pieces.containsIgnoringCase(find: "pc"){
                                                        amenitiesData.append("Cabbin Baggage \n(\(pieces))")
                                                    }else{
                                                        amenitiesData.append("Cabbin Baggage \n(\(pieces) pc)")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if amenitiesData.count > 0{
                                flightDetailsCell.amenitiesDelegate = self
                                
                                flightDetailsCell.amenitiesData = amenitiesData
                                flightDetailsCell.amenitiesDisplayView.isHidden = false
                                flightDetailsCell.amenitiesCollectionView.reloadData()
                                flightDetailsCell.amenitiesDisplayViewHeight.constant = 90
                                flightDetailsCell.amenitiesCollectionView.reloadData()
                            }else{
                                flightDetailsCell.amenitiesDisplayView.isHidden = true
                                flightDetailsCell.amenitiesDisplayViewHeight.constant = 0
                            }
                        }else{
                            flightDetailsCell.amenitiesDisplayView.isHidden = true
                            flightDetailsCell.amenitiesDisplayViewHeight.constant = 0
                        }
                        
                        let flightName = airlineDetailsResult[flight.al]?.name
                        flightDetailsCell.flightNameLabel.text = flightName
                        
                        let logoURL = AppKeys.airlineMasterBaseUrl + flight.al.uppercased() + ".png"
                        flightDetailsCell.setAirlineImage(with: logoURL)
                        
                        if indexPath.row == 0{
                            let ap = journey[indexPath.section].ap
                            let departureAirportDetails = airportDetailsResult[ap[0]]
                            let arrivalAirportDetails = airportDetailsResult[ap[1]]
                            
                            if departureAirportDetails != nil && arrivalAirportDetails != nil{
                                flightDetailsCell.titleLabel.text = departureAirportDetails!.c! + " → " + arrivalAirportDetails!.c!
                                flightDetailsCell.titleLabelHeight.constant = 25
                            } else if departureAirportDetails != nil{
                                flightDetailsCell.titleLabelHeight.constant = 25
                                flightDetailsCell.titleLabel.text = departureAirportDetails!.c
                            }else if arrivalAirportDetails != nil{
                                flightDetailsCell.titleLabelHeight.constant = 25
                                flightDetailsCell.titleLabel.text = arrivalAirportDetails!.c
                            }else{
                                flightDetailsCell.titleLabelHeight.constant = 0
                                flightDetailsCell.titleLabel.text = ""
                            }
                        }else{
                            flightDetailsCell.titleLabel.text = ""
                            flightDetailsCell.titleLabelHeight.constant = 0
                        }
                        
                        flightDetailsCell.classNameLabel.clipsToBounds = true
                        flightDetailsCell.classNameLabel.layer.cornerRadius = 3
                        flightDetailsCell.classNameLabel.layer.masksToBounds = true
                        
                        var bc = flight.bc
                        
                        if bc != ""{
                            bc = " (" + bc + ")"
                            if flight.ccChg == 1{
                                flightDetailsCell.classNameLabel.textColor = UIColor.black
                                flightDetailsCell.classLabel.text = ""
                                let lbl = flight.al + " - " + flight.fn + "・"
                                let lbl1 = " " + flight.cc + bc + " "
                                flightDetailsCell.classNameLabel.attributedText = flightDetailsCell.addAttributsForRange((lbl + lbl1), coloredString: (lbl1), color: AppColors.lightYellow)
                            }else{
                                flightDetailsCell.classNameLabel.textColor = AppColors.themeGray40
                                flightDetailsCell.classLabel.text = ""
                                if flight.cc == "Premium Economy"{
                                    let cc = "Premium E"
                                    let lbl = flight.al + " - " + flight.fn + "・" + "" + cc + bc + " "
                                    flightDetailsCell.classNameLabel.attributedText = flightDetailsCell.addAttributsForRange(lbl, coloredString: cc, color: UIColor.clear)
                                }else{
                                    let lbl = flight.al + " - " + flight.fn + "・" + "" + flight.cc + bc + " "
                                    flightDetailsCell.classNameLabel.attributedText = flightDetailsCell.addAttributsForRange(lbl, coloredString: flight.cc, color: UIColor.clear)
                                }
                            }
                        }else{
                            flightDetailsCell.classNameLabel.textColor = AppColors.themeGray40
                            flightDetailsCell.classLabel.text = ""
                            flightDetailsCell.classNameLabel.text = flight.al + " - " + flight.fn + "・" + flight.cc
                        }
                        
                        flightDetailsCell.arrivalAirportLabel.text = flight.to
                        flightDetailsCell.arrivalTimeLabel.text = flight.at
                        
                        flightDetailsCell.departureTimeLbl.text = flight.dt
                        
                        if flight.isDepartureAirportChange == true{
                            flightDetailsCell.setDepartureAirportLabel(str: " \(flight.fr).")
                        }else{
                            flightDetailsCell.departureAirportLabel.attributedText = nil
                            flightDetailsCell.departureAirportLabel.text = flight.fr
                        }
                        
                        if flight.isArrivalAirportChange == true{
                            flightDetailsCell.arrivalAirportLabel.attributedText = flightDetailsCell.addAttributsForRange(" \(flight.to) ", coloredString: " \(flight.to) ", color: AppColors.lightYellow)
                        }else{
                            flightDetailsCell.arrivalAirportLabel.attributedText = flightDetailsCell.addAttributsForRange(flight.to, coloredString: flight.to, color: AppColors.clear)
                        }
                        
                        flightDetailsCell.arrivalPerformaceButton.isUserInteractionEnabled = false
                        flightDetailsCell.onArrivalPerformanceLabel.text = ""
                        flightDetailsCell.onArrivalPerformanceView.isHidden = true
                        flightDetailsCell.onArrivalPerformanceViewWidth.constant = 0
                        
                        if flight.ontimePerformanceDataStoringTime != nil{
                            if Double(flight.ontimePerformance!) > 90.0{
                                flightDetailsCell.onArrivalPerformanceLabel.textColor = UIColor(displayP3Red: 0.0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                            }else{
                                flightDetailsCell.onArrivalPerformanceLabel.textColor = UIColor.black
                            }
                            
                            flightDetailsCell.arrivalPerformaceButton.isUserInteractionEnabled = true
                            flightDetailsCell.onArrivalPerformanceView.isHidden = false
                            
                            var viewWidth : CGFloat = 0
                            var ontimeText = ""
                            if isSEDevice{
                                viewWidth = 65.0
                                ontimeText = "%  On-time"
                            }else{
                                viewWidth = 87.0
                                ontimeText = "% On-time"
                            }
                            
                            flightDetailsCell.onArrivalPerformanceLabel.text = "\(flight.ontimePerformance ?? 0)\(ontimeText)"

                            flightDetailsCell.onArrivalPerformanceViewWidth.constant = viewWidth
                            
                            let onTimePerformanceInPercent = flight.ontimePerformance ?? 0
                            let delayedPerformanceInPercent = flight.latePerformance ?? 0
                            let cancelledPerformanceInPercent = flight.cancelledPerformance ?? 0
                            
                            flightDetailsCell.onTimePerformanceSubViewWidth.constant = CGFloat(onTimePerformanceInPercent * Int(flightDetailsCell.onArrivalPerformanceViewWidth.constant/viewWidth))
                            flightDetailsCell.delayedPerformanceSubViewWidth.constant = CGFloat(delayedPerformanceInPercent * Int(flightDetailsCell.onArrivalPerformanceViewWidth.constant/viewWidth))
                            flightDetailsCell.cancelledPerformanceSubViewWidth.constant = CGFloat(cancelledPerformanceInPercent * Int(flightDetailsCell.onArrivalPerformanceViewWidth.constant/viewWidth))
                        }
                        
                        flightDetailsCell.arrivalPerformaceButton.tag = (indexPath.section*100)+index
                        flightDetailsCell.arrivalPerformaceButton.addTarget(self, action: #selector(flightArrivalPerfomaceButtonClicked(_:)), for: .touchUpInside)
                        
                        if flight.oc != flight.al{
                            flightDetailsCell.operatorLabel.text = "Operated by \(flight.oc ?? "")"
                        }else{
                            flightDetailsCell.operatorLabel.text = ""
                        }
                        
                        if flight.eqQuality == 1{
                            flightDetailsCell.equipmentsLabel.attributedText = flightDetailsCell.addAttributsForRange("⭑ " + flight.eq!, coloredString: "⭑", color: AppColors.themeGray60, isForground: true)
                        }else{
                            flightDetailsCell.equipmentsLabel.text = flight.eq
                        }
                        
                        let arrivalDateString = flightDetailsCell.dateConverter(dateStr: flight.ad)
                        let departureDateString = flightDetailsCell.dateConverter(dateStr: flight.dd)
                        
                        if arrivalDateString != departureDateString{
                            let str = "  \(arrivalDateString)  "
                            
                            flightDetailsCell.arrivalDateLabel.attributedText = flightDetailsCell.addAttributsForRange(str, coloredString: str, color: AppColors.lightYellow)
                        }else{
                            flightDetailsCell.arrivalDateLabel.attributedText = nil
                            flightDetailsCell.arrivalDateLabel.text = "\(arrivalDateString)"
                        }
                        
                        if flight.isDepartureDateChange!{
                            flightDetailsCell.setDepartureDate(str:"  \(departureDateString) .",str1:"  \(departureDateString) ")
                        }else{
                            flightDetailsCell.departureDateLabel.attributedText = nil
                            flightDetailsCell.departureDateLabel.text = "\(departureDateString)"
                        }
                        
                        if flight.atm != ""{
                            if flight.isArrivalTerminalChange == true{
                                flightDetailsCell.arrivalTerminalLabel.attributedText = flightDetailsCell.addAttributsForRange(" \(flight.atm) ", coloredString: " \(flight.atm) ", color: AppColors.lightYellow)
                            }else{
                                flightDetailsCell.arrivalTerminalLabel.attributedText = flightDetailsCell.addAttributsForRange(flight.atm, coloredString: flight.atm, color: AppColors.clear)
                            }
                        }
                        
                        if flight.dtm != ""{
                            if flight.isDepartureTerminalChange == true
                            {
                                flightDetailsCell.departureTerminalLabel.attributedText = flightDetailsCell.addAttributsForRange(" \(flight.dtm) ", coloredString: " \(flight.dtm) ", color: AppColors.lightYellow)
                            }else{
                                flightDetailsCell.departureTerminalLabel.attributedText = flightDetailsCell.addAttributsForRange(flight.dtm, coloredString: flight.dtm, color: AppColors.clear)
                            }
                        }
                        
                        if let arrivalAirportDetails = airportDetailsResult[flight.to]
                        {
                            let main_string = arrivalAirportDetails.n! + "\n" + arrivalAirportDetails.c! + ", " + arrivalAirportDetails.cn!
                            let string_to_color = arrivalAirportDetails.c! + ", " + arrivalAirportDetails.cn!
                            
                            flightDetailsCell.arrivalAirportAddressLabel.attributedText = flightDetailsCell.addAttributsForRange(main_string, coloredString: string_to_color, color: AppColors.themeBlack, isForground: true)
                        }else{
                            flightDetailsCell.arrivalAirportAddressLabel.text = ""
                        }
                        
                        if let departureAirportDetails = airportDetailsResult[flight.fr]{
                            let main_string1 = departureAirportDetails.n! + "\n" + departureAirportDetails.c! + ", " + departureAirportDetails.cn!
                            let string_to_color1 = (departureAirportDetails.c ?? "") + ", " + (departureAirportDetails.cn ?? "")
                            
                            flightDetailsCell.departureAirportAddressLabel.attributedText = flightDetailsCell.addAttributsForRange(main_string1, coloredString: string_to_color1, color: AppColors.themeBlack, isForground: true)
                        }else{
                            flightDetailsCell.departureAirportAddressLabel.text = ""
                        }
                        
                        if indexPath.row == 0{
                            let ap = journey[indexPath.section].ap
                            let departureAirportDetails = airportDetailsResult[ap[0]]
                            let arrivalAirportDetails = airportDetailsResult[ap[1]]
                            
                            if departureAirportDetails != nil && arrivalAirportDetails != nil{
                                flightDetailsCell.journeyTitle = (departureAirportDetails!.c ?? "") + " → " + (arrivalAirportDetails!.c ?? "")
                            }else if departureAirportDetails != nil{
                                flightDetailsCell.journeyTitle = departureAirportDetails!.c ?? ""
                            }else if arrivalAirportDetails != nil{
                                flightDetailsCell.journeyTitle = arrivalAirportDetails!.c ?? ""
                            }else{
                                flightDetailsCell.journeyTitle = ""
                            }
                        }else{
                            flightDetailsCell.journeyTitle = ""
                        }
                        
                        flightDetailsCell.setJourneyTitle()
                        
                        flightDetailsCell.count = count
                        flightDetailsCell.halt = flight.halt
                        flightDetailsCell.durationTitle = journey.first?.durationTitle ?? ""
                        flightDetailsCell.ovgtf = flight.ovgtf
                        flightDetailsCell.travellingTiming = getTravellingTiming(duration: flight.ft)
                        flightDetailsCell.setTravellingTime()
                        
                        let totalRow = tableView.numberOfRows(inSection: indexPath.section)
                        if totalRow == 1{
                            flightDetailsCell.bottomSeperatorView.isHidden = false
                            flightDetailsCell.displayViewBottom.constant = 35
                        }else if(indexPath.row == totalRow-1){
                            flightDetailsCell.displayViewBottom.constant = 35
                            flightDetailsCell.bottomSeperatorView.isHidden = false
                        }else{
                            flightDetailsCell.displayViewBottom.constant = 0
                            flightDetailsCell.bottomSeperatorView.isHidden = true
                        }
                        
                        
                        
                        if indexPath.row == 0{
                            flightDetailsCell.topSeperatorViewHeight.constant = 0.5
                            flightDetailsCell.topSeperatorView.isHidden = false
                        }else{
                            flightDetailsCell.topSeperatorViewHeight.constant = 0.0
                            flightDetailsCell.topSeperatorView.isHidden = true
                        }
                    }
                    return flightDetailsCell
                }else{
                    guard let layoverCell = tableView.dequeueReusableCell(withIdentifier: "LayoverViewCell") as? LayoverViewTableViewCell else{return UITableViewCell()}
                    
                    var index = 0
                    if indexPath.row > 0{
                        index = (indexPath.row - 1)/2
                    }else{
                        index = indexPath.row
                    }
                    
                    if let flight = journey[indexPath.section].leg.first?.flights[index]{
                        
                        if airportDetailsResult != nil{
                            
                            var layoverCityName = ""
                            if let arrivalAirportDetails = airportDetailsResult[flight.to]{
                                layoverCityName = arrivalAirportDetails.c!
                            }
                            
                            layoverCell.layoverCityName = layoverCityName
                            layoverCell.ovgtlo = flight.ovgtlo
                        }
                        
                        var layoverTime =  ""
                        if let lott = journey[indexPath.section].leg.first?.lott{
                            if lott.count > 0{
                                if index < lott.count{
                                    layoverTime = getTravellingTiming(duration: lott[index])
                                }
                            }
                        }
                        
                        layoverCell.layoverTime = layoverTime
                        layoverCell.llo = flight.llo
                        layoverCell.slo = flight.slo
                        layoverCell.isArrivalAirportChange = flight.isArrivalAirportChange ?? false
                        layoverCell.isArrivalTerminalChange = flight.isArrivalTerminalChange ?? false
                        
                        layoverCell.layoverLabel.attributedText = layoverCell.getLayoverString()
                        
                    }
                    return layoverCell
                }
            }else{
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    //MARK:- Scrollview Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
    }
    
    //MARK:- Calculate Travelling Time
    func getTravellingTiming(duration:Int)->String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        
        guard let formattedString = formatter.string(from: TimeInterval(duration)) else { return "" }
        return formattedString
    }
    
    //MARK:- Set Image
    
    func getSelectedAmenities(amenitiesData: [String : String], index: Int, cellIndexPath: IndexPath){
        (self.parent?.parent as? PagingViewController)?.select(index: 1)
    }
    
    //MARK:- Button Actions
    @objc func flightArrivalPerfomaceButtonClicked(_ sender:UIButton)
    {
        let arrivalPerformanceView = ArrivalPerformaceVC(nibName: "ArrivalPerformaceVC", bundle: nil)
        
        let section = sender.tag / 100
        let row = sender.tag % 100
        
        if let flight = journey[section].leg.first?.flights[row]{
            if flight.ontimePerformanceDataStoringTime != nil{
                arrivalPerformanceView.observationCount = "\(flight.observationCount ?? 0)"
                arrivalPerformanceView.averageDelay = "\(flight.averageDelay ?? 0)"
                arrivalPerformanceView.cancelledPerformanceInPercent = flight.cancelledPerformance ?? 0
                arrivalPerformanceView.delayedPerformanceInPercent = flight.latePerformance ?? 0
                arrivalPerformanceView.onTimePerformanceInPercent = flight.ontimePerformance ?? 0
                arrivalPerformanceView.modalPresentationStyle = .overFullScreen
                self.present(arrivalPerformanceView, animated: false, completion: nil)
            }
        }
    }
    
    //MARK:- API Call
//    func callAPIforFlightsOnTimePerformace(origin: String, destination: String, airline: String, flight_number: String, index:[Int],FFK:String)
//    {
//        let param = ["origin": origin, "destination": destination, "airline":airline,"flight_number":flight_number]
//        APICaller.shared.getOnTimePerformanceDetails(params: param){[weak self] (data, error) in
//            guard let self = self , let performanceData = data else {return}
//
//            if let delay_index = performanceData["delay_index"] as? JSONDictionary
//            {
//                let date = Date()
//                let calendar = Calendar.current
//                let hour = calendar.component(.hour, from: date)
//                let minutes = calendar.component(.minute, from: date)
//                let seconds = calendar.component(.second, from: date)
//
//                if self.journey[index[0]].leg.first?.flights[index[1]].ffk == FFK{
//                    self.journey[index[0]].leg[0].flights[index[1]].ontimePerformance = Int((delay_index["ontime"] as? String) ?? "")
//                    self.journey[index[0]].leg[0].flights[index[1]].latePerformance = Int((delay_index["late"] as? String) ?? "")
//                    self.journey[index[0]].leg[0].flights[index[1]].cancelledPerformance = Int((delay_index["cancelled"] as? String) ?? "")
//                    self.journey[index[0]].leg[0].flights[index[1]].observationCount = Int((delay_index["observation_count"] as? String) ?? "")
//                    self.journey[index[0]].leg[0].flights[index[1]].averageDelay = Int((delay_index["average_delay"] as? String) ?? "")
//                    self.journey[index[0]].leg[0].flights[index[1]].ontimePerformanceDataStoringTime = "\(hour):\(minutes):\(seconds)"
//                }
//
//                self.flightInfoTableView.reloadData()
//            }
//        }
//    }
//    {
//        let webservice = WebAPIService()
//        webservice.executeAPI(apiServive: .flightPerformanceResult(origin: origin, destination: destination, airline: airline, flight_number: flight_number), completionHandler: {    (data) in
//
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//            DispatchQueue.main.async {
//                if var currentParsedResponse = parse(data: data, into: flightPerformaceResponse.self, with:decoder) {
//
//                    if currentParsedResponse.success == true{
//                        currentParsedResponse.data?.delayIndex?.index = index
//
//                        let date = Date()
//                        let calendar = Calendar.current
//                        let hour = calendar.component(.hour, from: date)
//                        let minutes = calendar.component(.minute, from: date)
//                        let seconds = calendar.component(.second, from: date)
//
//                        if self.journey[index[0]].leg.first?.flights[index[1]].ffk == FFK{
//                            self.journey[index[0]].leg[0].flights[index[1]].ontimePerformance = Int((currentParsedResponse.data?.delayIndex?.ontime) ?? "")
//
//                            self.journey[index[0]].leg[0].flights[index[1]].latePerformance = Int((currentParsedResponse.data?.delayIndex?.late) ?? "")
//
//                            self.journey[index[0]].leg[0].flights[index[1]].cancelledPerformance = Int((currentParsedResponse.data?.delayIndex?.cancelled) ?? "")
//
//                            self.journey[index[0]].leg[0].flights[index[1]].observationCount = Int((currentParsedResponse.data?.delayIndex?.observationCount) ?? "")
//
//                            self.journey[index[0]].leg[0].flights[index[1]].averageDelay = Int((currentParsedResponse.data?.delayIndex?.averageDelay) ?? "")
//
//                            self.journey[index[0]].leg[0].flights[index[1]].ontimePerformanceDataStoringTime = "\(hour):\(minutes):\(seconds)"
//                        }
//
//                        self.flightInfoTableView.reloadData()
//                    }
//                }
//            }
//        } , failureHandler : { (error ) in
//        })
//    }
    
//    func callAPIforBaggageInfo(sid:String, fk:String){
//
//        let param = ["sid": sid, "fk[]": fk]
//        APICaller.shared.getFlightbaggageDetails(params: param) {[weak self] (data, error) in
//            guard let self = self , let bgData = data else {
//                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
//                return
//            }
//            let keys = bgData.keys
//            if keys.count > 0{
//                for key in keys{
//                    if let datas = bgData["\(key)"] as? JSONDictionary
//                    {
//                        self.baggageData += [datas]
//                    }
//                }
//            }
//            let date = Date()
//            let calendar = Calendar.current
//            let hour = calendar.component(.hour, from: date)
//            let minutes = calendar.component(.minute, from: date)
//            let seconds = calendar.component(.second, from: date)
//
//            let newArr = ["Time":"\(hour):\(minutes):\(seconds)",
//                          "selectedJourneyFK":self.selectedJourneyFK,
//                          "BaggageDataResponse":self.baggageData] as [String : Any]
//            self.appdelegate.flightBaggageMutableArray.add(newArr)
//            self.flightInfoTableView.reloadData()
//            delay(seconds: 0.3) {
//                self.flightInfoTableView.reloadData()
//            }
//        }
        
//        let url = APIEndPoint.baseUrlPath.rawValue+APIEndPoint.flightDetails_Baggage.rawValue+"sid=\(sid)&fk[]=\(fk)"
//        AppNetworking.GET(endPoint: url, success: { [weak self] (data) in
//            guard let sSelf = self else {return}
//
//            if let data = data["data"].object as? JSONDictionary {
//
//                let keys = data.keys
//                if keys.count > 0{
//
//                    for key in keys{
//                        if let datas = data["\(key)"] as? JSONDictionary
//                        {
//                            sSelf.baggageData += [datas]
//                        }
//                    }
//                }
//            }
//
//            let date = Date()
//            let calendar = Calendar.current
//            let hour = calendar.component(.hour, from: date)
//            let minutes = calendar.component(.minute, from: date)
//            let seconds = calendar.component(.second, from: date)
//
//            let newArr = ["Time":"\(hour):\(minutes):\(seconds)",
//                          "selectedJourneyFK":sSelf.selectedJourneyFK,
//                          "BaggageDataResponse":sSelf.baggageData] as [String : Any]
//            sSelf.appdelegate.flightBaggageMutableArray.add(newArr)
//            sSelf.flightInfoTableView.reloadData()
//            delay(seconds: 0.3) {
//                sSelf.flightInfoTableView.reloadData()
//            }
//        }, failure: { (errors) in
//        })
    }
//    {
//        let webservice = WebAPIService()
//        webservice.executeAPI(apiServive: .baggageResult(sid: sid, fk: fk), completionHandler: {    (data) in
//
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//            do{
//                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
//
//                DispatchQueue.main.async {
//                    if let result = jsonResult as? [String: AnyObject] {
//                        if let data = result["data"] as? JSONDictionary {
//
//                            let keys = data.keys
//                            if keys.count > 0{
//
//                                for key in keys{
//                                    if let datas = data["\(key)"] as? JSONDictionary
//                                    {
//                                        self.baggageData += [datas]
//                                    }
//                                }
//                            }
//                        }
//                    }
//
//                    let date = Date()
//                    let calendar = Calendar.current
//                    let hour = calendar.component(.hour, from: date)
//                    let minutes = calendar.component(.minute, from: date)
//                    let seconds = calendar.component(.second, from: date)
//
//                    let newArr = ["Time":"\(hour):\(minutes):\(seconds)",
//                                  "selectedJourneyFK":self.selectedJourneyFK,
//                                  "BaggageDataResponse":self.baggageData] as [String : Any]
//                    self.appdelegate.flightBaggageMutableArray.add(newArr)
//                    self.flightInfoTableView.reloadData()
//                    delay(seconds: 0.3) {
//                        self.flightInfoTableView.reloadData()
//                    }
//                }
//            }catch{
//            }
//        } , failureHandler : { (error ) in
//        })
//    }
//}


extension FlightInfoVC : FlightInfoVMDelegate{
    func flightBaggageDetailsApiResponse(details: [JSONDictionary]) {
        self.baggageData += details
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let newArr = ["Time":"\(hour):\(minutes):\(seconds)",
                      "selectedJourneyFK":self.selectedJourneyFK,
                      "BaggageDataResponse":self.baggageData] as [String : Any]
        self.appdelegate.flightBaggageMutableArray.add(newArr)
        self.flightInfoTableView.reloadData()
        delay(seconds: 0.3) {
            self.flightInfoTableView.reloadData()
        }
        
    }
    
    func flightPerformance(performanceData: flightPerfomanceResultData, index: [Int], fkk:String) {
        
        var currentParsedResponse = performanceData
        
        currentParsedResponse.index = index
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        if self.journey[index[0]].leg.first?.flights[index[1]].ffk == fkk{
            self.journey[index[0]].leg[0].flights[index[1]].ontimePerformance = Int((currentParsedResponse.ontime) ?? "")
            
            self.journey[index[0]].leg[0].flights[index[1]].latePerformance = Int((currentParsedResponse.late) ?? "")
            
            self.journey[index[0]].leg[0].flights[index[1]].cancelledPerformance = Int((currentParsedResponse.cancelled) ?? "")
            
            self.journey[index[0]].leg[0].flights[index[1]].observationCount = Int((currentParsedResponse.observationCount) ?? "")
            
            self.journey[index[0]].leg[0].flights[index[1]].averageDelay = Int((currentParsedResponse.averageDelay) ?? "")
            
            self.journey[index[0]].leg[0].flights[index[1]].ontimePerformanceDataStoringTime = "\(hour):\(minutes):\(seconds)"
        }
        self.flightInfoTableView.reloadData()
        
    }
    
    
    
    
}
    
    
    

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
