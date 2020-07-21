//
//  FlightInfoVC.swift
//  FlightDetails
//
//  Created by Monika Sonawane on 11/09/19.
//  Copyright © 2019 Monika Sonawane. All rights reserved.
//

protocol getSelectedAmenitiesDelegate: class {
    func getSelectedAmenities(amenitiesData:[String:String], index:Int)
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

final class FlightInfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate, getSelectedAmenitiesDelegate, UIScrollViewDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var flightInfoTableView: UITableView!
    @IBOutlet weak var flightInfoTableViewBottom: NSLayoutConstraint!
    
    //MARK:- Variable Declaration
    weak var delegate : flightDetailsBaggageDelegate?

    var flightInfoDelegate : flightInfoViewDisplayDelegate?
    var journey: [Journey]!
    var titleString : NSAttributedString!
    var airportDetailsResult : [String : AirportDetailsWS]!
    var airlineDetailsResult : [String : AirlineMasterWS]!
    
    var flightsResults  =  FlightsResults()
    
    //    var amenitiesData = ["DirecTV", "Free Wi-Fi", "Personal televisions", "Open and closed suite", "The airline meal"]
    var baggageData = [NSDictionary]()
    var isChangeOfAirport = false
    var sid = ""
    var isTableviewScrolledDown = false
    let clearCache = ClearCache()
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedIndex : IndexPath!
    var selectedJourneyFK = [String]()
    var fewSeatsLeftViewHeight = 0
    var isInternational = false//For International results.

    
    //MARK:- Initial Display Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearCache.checkTimeAndClearFlightPerformanceResultCache(journey: journey)
        clearCache.checkTimeAndClearFlightBaggageResultCache()
        
        getFlightsInfo()
        flightInfoTableView.estimatedRowHeight = UITableView.automaticDimension
        flightInfoTableView.alwaysBounceVertical = true
        
        flightInfoTableView.register(UINib(nibName: "FlightDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "FlightDetailsCell")
        flightInfoTableView.register(UINib(nibName: "LayoverViewTableViewCell", bundle: nil), forCellReuseIdentifier: "LayoverViewCell")
        flightInfoTableView.register(UINib(nibName: "ChangeAirportTableViewCell", bundle: nil), forCellReuseIdentifier: "ChangeAirportCell")
        

        //        flightInfoTableView.sectionFooterHeight = .zero

        switch UIScreen.main.bounds.height{
                case 568: //iPhone SE | 5S
                    flightInfoTableViewBottom.constant = CGFloat(310 + fewSeatsLeftViewHeight)
                    break
                    
                case 667: //iPhone 8 | 6 | 6s | 7
                    flightInfoTableViewBottom.constant = CGFloat(210 + fewSeatsLeftViewHeight)
                    break
                    
                case 736: //iPhone 6 Plus | 8 plus | 6s plus | 7 Plus
                    flightInfoTableViewBottom.constant = CGFloat(145 + fewSeatsLeftViewHeight)
                    break
                    
                case 812: //11 Pro | X | Xs
                    flightInfoTableViewBottom.constant = CGFloat(98 + fewSeatsLeftViewHeight)
                    break
                    
                case 896: //11 & 11 Pro Max & Xs Max & Xr
                    flightInfoTableViewBottom.constant = CGFloat(20 + fewSeatsLeftViewHeight)
                    break
                    
                default :
                    break
                }
    }
    
    //MARK:- Get Flight Info
    
    func getFlightsInfo()
    {
        if journey != nil{
            for j in 0..<journey.count{
                
                if appdelegate.flightBaggageMutableArray.count == 0{
                    callAPIforBaggageInfo(sid: sid, fk: journey[j].fk)
                }else{
                    for i in 0..<self.appdelegate.flightBaggageMutableArray.count{
                        if let baggageArray = self.appdelegate.flightBaggageMutableArray[i] as? NSDictionary
                        {
                            let selectedIndex = baggageArray.value(forKey: "selectedJourneyFK") as! [String]
                            if self.selectedJourneyFK == selectedIndex{
                                let baggageDataResponse = baggageArray.value(forKey: "BaggageDataResponse") as! [NSDictionary]
                                self.baggageData = baggageDataResponse
                            }
                        }
                    }
                    
                    if self.baggageData.count == 0{
                        callAPIforBaggageInfo(sid: sid, fk: journey[j].fk)
                    }
                }
                
                if let allFlights = journey[j].leg.first?.flights{
                    for k in 0..<allFlights.count{
                        let flight = allFlights[k]
                        
                        if flight.ontimePerformanceDataStoringTime == nil{
                            callAPIforFlightsOnTimePerformace(origin: flight.fr, destination: flight.to, airline: flight.al, flight_number: flight.fn, index: [j,k], FFK:flight.ffk)
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
                        }else{
                            journey[j].leg[0].flights[k].isDepartureTerminalChange = false
                            journey[j].leg[0].flights[k].isArrivalTerminalChange = false
                            
                            journey[j].leg[0].flights[k].isDepartureAirportChange = false
                            journey[j].leg[0].flights[k].isArrivalAirportChange = false
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
            let changeAirportCell = tableView.dequeueReusableCell(withIdentifier: "ChangeAirportCell") as! ChangeAirportTableViewCell
            changeAirportCell.titleLabel.text = "Change of Airport"
            changeAirportCell.dataLabel.text = "While changing airports, re-checking baggage and going back through security may be necessary. Ensure you have ample time between transfers. Kindly check all terms regarding connection, baggage transfer, visas, etc. with the airlines directly before booking this itinerary."
            return changeAirportCell
        }else{
            let count = journey[indexPath.section].leg.first?.flights.count
            if count! > 0{
                if indexPath.row % 2 == 0{
                    let flightDetailsCell = tableView.dequeueReusableCell(withIdentifier: "FlightDetailsCell") as! FlightDetailsTableViewCell
                    
                    var index = 0
                    if indexPath.row > 0{
                        if indexPath.row <= count!{
                            index = indexPath.row-1
                        }else{
                            index = indexPath.row-2
                        }
                    }else{
                        index = indexPath.row
                    }
                    
                    if let flight = journey[indexPath.section].leg.first?.flights[index]{
                        var amenitiesData = [String]()
                        
                        if let bgWeight = flight.bg?["ADT"]?.weight, let bgPieces = flight.bg?["ADT"]?.pieces
                        {
                            if bgPieces != "" && bgPieces != "-9" && bgPieces != "-1" && bgPieces != "0 pc" && bgPieces != "0"
                            {
                                amenitiesData.append("Check-in Baggage \n(\(bgPieces))")
                            }else{
                                if bgWeight != "" && bgWeight != "-9" && bgWeight != "-1" && bgWeight != "0 kg"{
                                    amenitiesData.append("Check-in Baggage \n(\(bgWeight))")
                                }
                            }
                        }
                        
                        
                        if baggageData.count > 0{
                            if index < baggageData.count{
                                if amenitiesData.count == 0{
                                    if let bgData = baggageData[index].value(forKey: "bg") as? NSDictionary{
                                        if let adtBaggage = bgData.value(forKey: "ADT") as? NSDictionary{
                                            if let weight = adtBaggage.value(forKey: "weight") as? String, let pieces = adtBaggage.value(forKey: "pieces") as? String
                                            {
                                                self.journey[indexPath.section].leg[0].flights[index].bg = ["ADT":baggageStruct.init(weight: weight, pieces: pieces, note: "")]
                                                
                                                self.delegate?.reloadBaggageSuperScriptAtIndexPath()
                                             
                                                if pieces != "" && pieces != "-9" && pieces != "-1" && pieces != "0 pc" && pieces != "0"
                                                {
                                                    amenitiesData.append("Check-in Baggage \n(\(pieces))")
                                                }else{
                                                    if weight != "" && weight != "-9" && weight != "-1" && weight != "0 kg"{
                                                        amenitiesData.append("Check-in Baggage \n(\(weight))")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                
                                if let cbgData = baggageData[index].value(forKey: "cbg") as? NSDictionary{
                                    if let adtCabinBaggage = cbgData.value(forKey: "ADT") as? NSDictionary{
                                        if let weight = adtCabinBaggage.value(forKey: "weight") as? String, let pieces = adtCabinBaggage.value(forKey: "pieces") as? String
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
                        
                        let logoURL = "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/" + flight.al.uppercased() + ".png"
                        setImageFromPath(urlPath : logoURL , to: flightDetailsCell.airlineImageView)
                        
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
                            bc =  " (" + bc + ")"
                            if flight.ccChg == 1{
                                flightDetailsCell.classLabel.text = flight.al + " - " + flight.fn + "・"
                                let main_string11 = " " + flight.cc + bc + " "
                                let string_to_color11 = " " + flight.cc + bc + " "
                                
                                let range = (main_string11 as NSString).range(of: string_to_color11)
                                
                                let attribute = NSMutableAttributedString.init(string: main_string11)
                                attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0) , range: range)
                                flightDetailsCell.classNameLabel.attributedText = attribute
                                flightDetailsCell.classNameLabel.textColor = UIColor.black
                            }else{
                                flightDetailsCell.classLabel.text = flight.al + " - " + flight.fn + "・"
                                
                                let main_string11 = " " + flight.cc + bc + " "
                                let string_to_color11 = flight.cc
                                
                                let range = (main_string11 as NSString).range(of: string_to_color11)
                                
                                let attribute = NSMutableAttributedString.init(string: main_string11)
                                attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear , range: range)
                                flightDetailsCell.classNameLabel.attributedText = attribute
                                flightDetailsCell.classNameLabel.textColor = UIColor(displayP3Red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                            }
                        }else{
                            flightDetailsCell.classLabel.text = flight.al + " - " + flight.fn + "・"
                            flightDetailsCell.classNameLabel.text = flight.cc
                            flightDetailsCell.classNameLabel.textColor = UIColor(displayP3Red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                        }
                        
                        flightDetailsCell.arrivalAirportLabel.text = flight.to
                        flightDetailsCell.arrivalTimeLabel.text = flight.at
                        
                        flightDetailsCell.departureAirportLabel.text = flight.fr
                        flightDetailsCell.departureTimeLbl.text = flight.dt
                        
                        if flight.isDepartureAirportChange == true{
                            let departureAirport = "  \(flight.fr)  "
                            let departureAirportRange = (departureAirport as NSString).range(of: "  \(flight.fr)  ")
                            let departureAirportAttributedString = NSMutableAttributedString(string:departureAirport)
                            departureAirportAttributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0), range: departureAirportRange)
                            flightDetailsCell.departureAirportLabel.attributedText = departureAirportAttributedString
                        }else{
                            let main_string11 = flight.fr
                            let string_to_color11 = flight.fr
                            
                            let range = (main_string11 as NSString).range(of: string_to_color11)
                            
                            let attribute = NSMutableAttributedString.init(string: main_string11)
                            attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear , range: range)
                            flightDetailsCell.departureAirportLabel.attributedText = attribute
                        }
                        
                        if flight.isArrivalAirportChange == true{
                            let arrivalAirport = "  \(flight.to)  "
                            let arrivalAirportRange = (arrivalAirport as NSString).range(of: "  \(flight.to)  ")
                            let arrivalAirportAttributedString = NSMutableAttributedString(string:arrivalAirport)
                            arrivalAirportAttributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0), range: arrivalAirportRange)
                            flightDetailsCell.arrivalAirportLabel.attributedText = arrivalAirportAttributedString
                        }else{
                            let main_string11 = flight.to
                            let string_to_color11 = flight.to
                            
                            let range = (main_string11 as NSString).range(of: string_to_color11)
                            
                            let attribute = NSMutableAttributedString.init(string: main_string11)
                            attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear , range: range)
                            flightDetailsCell.arrivalAirportLabel.attributedText = attribute
                        }
                        
                        let font = UIFont(name: "SourceSansPro-Regular", size: 14)
                        let fontAttributes = [NSAttributedString.Key.font: font]
                        let myText = flightDetailsCell.classNameLabel.text
                        let size = (myText! as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
                        flightDetailsCell.classNameLabelWidth.constant = size.width
                        
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
                            
                            flightDetailsCell.onArrivalPerformanceLabel.text = "\(flight.ontimePerformance!)% On-time"
                            
                            flightDetailsCell.onArrivalPerformanceView.isHidden = false
                            flightDetailsCell.onArrivalPerformanceViewWidth.constant = 100
                            
                            let onTimePerformanceInPercent = flight.ontimePerformance!
                            let delayedPerformanceInPercent = flight.latePerformance!
                            let cancelledPerformanceInPercent = flight.cancelledPerformance!
                            
                            flightDetailsCell.onTimePerformanceSubViewWidth.constant = CGFloat(onTimePerformanceInPercent * Int(flightDetailsCell.onArrivalPerformanceViewWidth.constant/100))
                            flightDetailsCell.delayedPerformanceSubViewWidth.constant = CGFloat(delayedPerformanceInPercent * Int(flightDetailsCell.onArrivalPerformanceViewWidth.constant/100))
                            flightDetailsCell.cancelledPerformanceSubViewWidth.constant = CGFloat(cancelledPerformanceInPercent * Int(flightDetailsCell.onArrivalPerformanceViewWidth.constant/100))
                        }
                        
                        flightDetailsCell.arrivalPerformaceButton.tag = (indexPath.section*100)+index
                        flightDetailsCell.arrivalPerformaceButton.addTarget(self, action: #selector(flightArrivalPerfomaceButtonClicked(_:)), for: .touchUpInside)
                        
                        if flight.oc != flight.al{
                            flightDetailsCell.operatorLabel.text = "Operated by \(flight.oc!)"
                        }else{
                            flightDetailsCell.operatorLabel.text = ""
                        }
                        
                        if flight.eqQuality == 1{
                            let main_string11 = "⭑ " + flight.eq!
                            let string_to_color11 = "⭑"
                            let range = (main_string11 as NSString).range(of: string_to_color11)
                            
                            let attribute = NSMutableAttributedString.init(string: main_string11)
                            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(displayP3Red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0), range: range)
                            flightDetailsCell.equipmentsLabel.attributedText = attribute
                        }else{
                            flightDetailsCell.equipmentsLabel.text = flight.eq
                        }
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let arrivalDate = dateFormatter.date(from: flight.ad)
                        let departureDate = dateFormatter.date(from: flight.dd)
                        
                        dateFormatter.dateFormat = "E, d MMM yyyy"
                        
                        
                        let arrivalDateString = dateFormatter.string(from: arrivalDate!)
                        let departureDateString = dateFormatter.string(from: departureDate!)

                        if arrivalDateString != departureDateString{
                            let string_to_color111 = "  \(arrivalDateString)  "
                            
                            let arrivalAirportRange = (string_to_color111 as NSString).range(of: string_to_color111)
                            let haltAtAttributedString = NSMutableAttributedString(string:string_to_color111)
                            haltAtAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: arrivalAirportRange)
                            haltAtAttributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0), range: arrivalAirportRange)
                            
                            flightDetailsCell.arrivalDateLabel.attributedText = haltAtAttributedString

                        }else{
//                            flightDetailsCell.arrivalDateLabel.text = arrivalDateString
//                            flightDetailsCell.arrivalDateLabel.backgroundColor = .clear
                            
                             let string_to_color111 = "\(arrivalDateString)"
                             
                             let arrivalAirportRange = (string_to_color111 as NSString).range(of: string_to_color111)
                             let haltAtAttributedString = NSMutableAttributedString(string:string_to_color111)
                             haltAtAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: arrivalAirportRange)
                            haltAtAttributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: arrivalAirportRange)
                             
                             flightDetailsCell.arrivalDateLabel.attributedText = haltAtAttributedString

                        }
                        
                        
                        flightDetailsCell.departureDateLabel.text = departureDateString
                        
                        flightDetailsCell.arrivalTerminalLabel.text = flight.atm
                        flightDetailsCell.departureTerminalLabel.text = flight.dtm
                        
                        if flight.atm != ""{
                            if flight.isArrivalTerminalChange == true{
                                
                                let main_string11 = "  \(flight.atm)  "
                                let string_to_color11 = "  \(flight.atm)  "
                                
                                let range = (main_string11 as NSString).range(of: string_to_color11)
                                
                                let attribute = NSMutableAttributedString.init(string: main_string11)
                                attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0) , range: range)
                                flightDetailsCell.arrivalTerminalLabel.attributedText = attribute
                            }else{
                                let main_string11 = flight.atm
                                let string_to_color11 = flight.atm
                                
                                let range = (main_string11 as NSString).range(of: string_to_color11)
                                
                                let attribute = NSMutableAttributedString.init(string: main_string11)
                                attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: range)
                                flightDetailsCell.arrivalTerminalLabel.attributedText = attribute
                            }
                        }
                        
                        if flight.dtm != ""{
                            if flight.isDepartureTerminalChange == true
                            {
                                let main_string111 = "  \(flight.dtm)  "
                                let string_to_color111 = "  \(flight.dtm)  "
                                
                                let range1 = (main_string111 as NSString).range(of: string_to_color111)
                                let attribute1 = NSMutableAttributedString.init(string: main_string111)
                                attribute1.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0) , range: range1)
                                flightDetailsCell.departureTerminalLabel.attributedText = attribute1
                            }else{
                                let main_string111 = flight.dtm
                                let string_to_color111 = flight.dtm
                                
                                let range1 = (main_string111 as NSString).range(of: string_to_color111)
                                
                                let attribute1 = NSMutableAttributedString.init(string: main_string111)
                                attribute1.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear , range: range1)
                                flightDetailsCell.departureTerminalLabel.attributedText = attribute1
                            }
                        }
                        
                        if let arrivalAirportDetails = airportDetailsResult[flight.to]{
                            
                            let main_string = arrivalAirportDetails.n! + "\n" + arrivalAirportDetails.c! + ", " + arrivalAirportDetails.cn!
                            let string_to_color = arrivalAirportDetails.c! + ", " + arrivalAirportDetails.cn!
                            
                            let range = (main_string as NSString).range(of: string_to_color)
                            
                            let attribute = NSMutableAttributedString.init(string: main_string)
                            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
                            flightDetailsCell.arrivalAirportAddressLabel.attributedText = attribute
                        }else{
                            flightDetailsCell.arrivalAirportAddressLabel.text = ""
                        }
                        
                        if let departureAirportDetails = airportDetailsResult[flight.fr]{
                            let main_string1 = departureAirportDetails.n! + "\n" + departureAirportDetails.c! + ", " + departureAirportDetails.cn!
                            let string_to_color1 = departureAirportDetails.c! + ", " + departureAirportDetails.cn!
                            
                            let range1 = (main_string1 as NSString).range(of: string_to_color1)
                            
                            let attribute1 = NSMutableAttributedString.init(string: main_string1)
                            attribute1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range1)
                            flightDetailsCell.departureAirportAddressLabel.attributedText = attribute1
                        }else{
                            flightDetailsCell.departureAirportAddressLabel.text = ""
                        }
                        
                        if indexPath.row == 0{
                            let ap = journey[indexPath.section].ap
                            let departureAirportDetails = airportDetailsResult[ap[0]]
                            let arrivalAirportDetails = airportDetailsResult[ap[1]]
                            
                            if departureAirportDetails != nil && arrivalAirportDetails != nil{
                                flightDetailsCell.titleLabel.text = departureAirportDetails!.c! + " → " + arrivalAirportDetails!.c!
                                flightDetailsCell.titleLabelHeight.constant = 25
                            }else if departureAirportDetails != nil{
                                flightDetailsCell.titleLabelHeight.constant = 25
                                flightDetailsCell.titleLabel.text = departureAirportDetails!.c!
                            }else if arrivalAirportDetails != nil{
                                flightDetailsCell.titleLabelHeight.constant = 25
                                flightDetailsCell.titleLabel.text = arrivalAirportDetails!.c!
                            }else{
                                flightDetailsCell.titleLabelHeight.constant = 0
                                flightDetailsCell.titleLabel.text = ""
                            }
                        }else{
                            flightDetailsCell.titleLabelHeight.constant = 0
                            flightDetailsCell.titleLabel.text = ""
                        }
                        
                        var travellingTime = NSAttributedString()
                        if count == 1{
                            if flight.halt != ""{
                                let main_string111 = "  \(journey.first!.durationTitle) \n   Via \(flight.halt)  ."
                                let string_to_color111 = "   Via \(flight.halt)  "
                                
                                let arrivalAirportRange = (main_string111 as NSString).range(of: string_to_color111)
                                let haltAtAttributedString = NSMutableAttributedString(string:main_string111)
                                haltAtAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.clear , range: (main_string111 as NSString).range(of: "."))

                                haltAtAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: arrivalAirportRange)
                                haltAtAttributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0), range: arrivalAirportRange)
                                haltAtAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Regular", size: 14.0)! , range: (main_string111 as NSString).range(of: main_string111))

                                travellingTime = haltAtAttributedString
                            }else{
                                travellingTime = NSAttributedString(string: journey.first!.durationTitle)
                            }
                        }else{
                            if flight.halt != ""{
                                let main_string111 = "\(getTravellingTiming(duration: flight.ft)) \n    Via \(flight.halt)  ."
                                let string_to_color111 = "   Via \(flight.halt)  "
                                
                                let arrivalAirportRange = (main_string111 as NSString).range(of: string_to_color111)
                                let haltAtAttributedString = NSMutableAttributedString(string:main_string111)
                                haltAtAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: arrivalAirportRange)
                                haltAtAttributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0), range: arrivalAirportRange)
                                haltAtAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.clear , range: (main_string111 as NSString).range(of: "."))
                                haltAtAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Regular", size: 14.0)! , range: (main_string111 as NSString).range(of: main_string111))

                                travellingTime = haltAtAttributedString
                            }else{
                                travellingTime = NSAttributedString(string:getTravellingTiming(duration: flight.ft))
                            }
                        }
                        
                        if flight.ovgtf == 1{
                            let displayText = NSMutableAttributedString(string: "  ")
                            displayText.append(travellingTime)
                            let completeText = NSMutableAttributedString(string: "")
                            
                            let imageAttachment =  NSTextAttachment()
                            
                            imageAttachment.image = UIImage(named:"overnight.png")
                            let imageOffsetY:CGFloat = -2.0;
                            imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 12, height: 12)
                            let attachmentString = NSAttributedString(attachment: imageAttachment)
                            completeText.append(attachmentString)
                            
                            completeText.append(displayText)
                            flightDetailsCell.travelingtimeLabel.attributedText = completeText
                        }else{
                            flightDetailsCell.travelingtimeLabel.attributedText = travellingTime
                        }
                        
                        let totalRow = tableView.numberOfRows(inSection: indexPath.section)
                        if totalRow == 1{
                            flightDetailsCell.bottomSeperatorView.isHidden = false
                            if journey[indexPath.section].fsr == 1{
                                flightDetailsCell.displayViewBottom.constant = 45
                            }else{
                                if indexPath.section == journey.count - 1{
                                    flightDetailsCell.displayViewBottom.constant = 60
                                }else{
                                    flightDetailsCell.displayViewBottom.constant = 40
                                }
                            }
                        }else if(indexPath.row == totalRow-1){
                            if journey[indexPath.section].fsr == 1{
                                flightDetailsCell.displayViewBottom.constant = 70
                            }else{
                                flightDetailsCell.displayViewBottom.constant = 65
                            }
                            flightDetailsCell.bottomSeperatorView.isHidden = false
                        }else{
                            flightDetailsCell.displayViewBottom.constant = 0
                            flightDetailsCell.bottomSeperatorView.isHidden = true
                        }
                        
                        if indexPath.section == 0 && indexPath.row == 0{
                            flightDetailsCell.topSeperatorViewHeight.constant = 0
                            flightDetailsCell.topSeperatorView.isHidden = true
                        }else if tableView.numberOfRows(inSection: indexPath.section) > 1{
                            if indexPath.row == 0{
                                flightDetailsCell.topSeperatorView.isHidden = false
                                flightDetailsCell.topSeperatorViewHeight.constant = 0.5
                            }else{
                                flightDetailsCell.topSeperatorView.isHidden = true
                                flightDetailsCell.topSeperatorViewHeight.constant = 0
                            }
                        }else{
                            flightDetailsCell.topSeperatorViewHeight.constant = 0.5
                            flightDetailsCell.topSeperatorView.isHidden = false
                        }
                    }
                    return flightDetailsCell
                }else{
                    let layoverCell = tableView.dequeueReusableCell(withIdentifier: "LayoverViewCell") as! LayoverViewTableViewCell
                    
                    var index = 0
                    if indexPath.row > 0{
                        if indexPath.row < count!{
                            index = indexPath.row-1
                        }else{
                            index = indexPath.row-2
                        }
                    }else{
                        index = indexPath.row
                    }
                    
                    if let flight = journey[indexPath.section].leg.first?.flights[index]{
                        var displayText = ""
                        var displayImgName = ""
                        
                        if airportDetailsResult != nil{
                            
                            var layoverCityName = ""
                            if let arrivalAirportDetails = airportDetailsResult[flight.to]{
                                layoverCityName = arrivalAirportDetails.c!
                            }
                            

                            if layoverCityName == "" || layoverCityName == " "{
                                displayText = "Layover  • "
                                displayImgName = ""
                            }else{
                                if flight.isArrivalAirportChange == true{
                                    displayText = "Change Airport in \(layoverCityName)  • "
                                    displayImgName = "redchangeAirport"
                                }else if flight.isArrivalTerminalChange == true{
                                    displayText = "Change Terminal in \(layoverCityName)  • "
                                    displayImgName = "changeOfTerminal"
                                }else if flight.ovgtlo == 1{
                                    displayText = "Overnight layover in \(layoverCityName)  • "
                                    displayImgName = "overnight"
                                }else {
                                    displayText = "Layover in \(layoverCityName)  • "
                                    displayImgName = ""
                                }
                            }
                            
                        }
                        
                        var layoverTime =  ""
                        if let lott = journey[indexPath.section].leg.first?.lott{
                            if lott.count > 0{
                                if index < lott.count{
                                    layoverTime = getTravellingTiming(duration: lott[index])
                                }
                            }
                        }
                        
                        displayText = displayText + " " + layoverTime
                        let completeText = NSMutableAttributedString(string: "")
                        
                        let imageAttachment =  NSTextAttachment()
                        if displayImgName != ""{
                            imageAttachment.image = UIImage(named:displayImgName)
                            let imageOffsetY:CGFloat = -4.0;
                            imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 16, height: 16)
                            let attachmentString = NSAttributedString(attachment: imageAttachment)
                            completeText.append(attachmentString)
                        }
                        let textAfterIcon = NSMutableAttributedString(string: displayText)
                        
                        if flight.llo == 1 || flight.slo == 1{
                            if flight.isArrivalAirportChange == true{
                                let range1 = (displayText as NSString).range(of: displayText)
                                
                                textAfterIcon.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range1)
                                textAfterIcon.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Semibold", size: 14.0)! , range: (displayText as NSString).range(of: layoverTime))
                            }else{
                                let range1 = (displayText as NSString).range(of: layoverTime)
                                
                                textAfterIcon.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range1)
                                textAfterIcon.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Semibold", size: 14.0)! , range: range1)
                            }
                        }else if flight.isArrivalAirportChange == true{
                            let range1 = (displayText as NSString).range(of: displayText)
                            
                            textAfterIcon.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range1)
                            textAfterIcon.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Semibold", size: 14.0)! , range: (displayText as NSString).range(of: layoverTime))
                        }else{
                            let range1 = (displayText as NSString).range(of: layoverTime)
                            
                            textAfterIcon.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range1)
                            textAfterIcon.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Semibold", size: 14.0)! , range: range1)
                        }
                        
                        completeText.append(NSMutableAttributedString(string: "  "))
                        completeText.append(textAfterIcon)
                        layoverCell.layoverLabel.textAlignment = .center;
                        layoverCell.layoverLabel.attributedText = completeText;
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
        var isHidden = false
        var viewHeight = 0.0
        if scrollView.contentOffset.y < 0{
            isHidden = false
            viewHeight = 0.5
        }else{
            isHidden = true
            viewHeight = 0
        }
        if let cell = flightInfoTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? FlightDetailsTableViewCell {
            cell.topSeperatorView.isHidden = isHidden
            cell.topSeperatorViewHeight.constant = CGFloat(viewHeight)
        }
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
    func setImageFromPath(urlPath : String  , to imageView : UIImageView)
    {
        guard  let urlobj = URL(string: urlPath) else { return }
        
        let urlRequest = URLRequest(url: urlobj)
        if let responseObj = URLCache.shared.cachedResponse(for: urlRequest) {
            
            let image = UIImage(data: responseObj.data)
            imageView.image = image
        }
    }
    
    func getSelectedAmenities(amenitiesData: [String : String], index: Int)
    {
    }
    
    //MARK:- Button Actions
    @objc func flightArrivalPerfomaceButtonClicked(_ sender:UIButton)
    {
        let arrivalPerformanceView = ArrivalPerformaceVC(nibName: "ArrivalPerformaceVC", bundle: nil)
        
        let section = sender.tag / 100
        let row = sender.tag % 100
        
        if let flight = journey[section].leg.first?.flights[row]{
            if flight.ontimePerformanceDataStoringTime != nil{
                flightInfoDelegate?.updateView()
                arrivalPerformanceView.observationCount = "\(flight.observationCount!)"
                arrivalPerformanceView.averageDelay = "\(flight.averageDelay!)"
                
                arrivalPerformanceView.cancelledPerformanceInPercent = flight.cancelledPerformance!
                arrivalPerformanceView.delayedPerformanceInPercent = flight.latePerformance!
                arrivalPerformanceView.onTimePerformanceInPercent = flight.ontimePerformance!
                
                arrivalPerformanceView.view.frame = self.parent!.view.bounds
                self.parent!.view.addSubview(arrivalPerformanceView.view)
                self.parent!.addChild(arrivalPerformanceView)
                arrivalPerformanceView.willMove(toParent: self)
            }
        }
    }
    
    //MARK:- API Call
    func callAPIforFlightsOnTimePerformace(origin: String, destination: String, airline: String, flight_number: String, index:[Int],FFK:String)
    {
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .flightPerformanceResult(origin: origin, destination: destination, airline: airline, flight_number: flight_number), completionHandler: {    (data) in
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            DispatchQueue.main.async {
                if var currentParsedResponse = parse(data: data, into: flightPerformaceResponse.self, with:decoder) {
                    
                    if currentParsedResponse.success == true{
                        currentParsedResponse.data?.delayIndex?.index = index
                        
                        let date = Date()
                        let calendar = Calendar.current
                        let hour = calendar.component(.hour, from: date)
                        let minutes = calendar.component(.minute, from: date)
                        let seconds = calendar.component(.second, from: date)
                        
                        if self.journey[index[0]].leg.first?.flights[index[1]].ffk == FFK{
                            self.journey[index[0]].leg[0].flights[index[1]].ontimePerformance = Int((currentParsedResponse.data?.delayIndex?.ontime)!)
                            
                            self.journey[index[0]].leg[0].flights[index[1]].latePerformance = Int((currentParsedResponse.data?.delayIndex?.late)!)
                            
                            self.journey[index[0]].leg[0].flights[index[1]].cancelledPerformance = Int((currentParsedResponse.data?.delayIndex?.cancelled)!)
                            
                            self.journey[index[0]].leg[0].flights[index[1]].observationCount = Int((currentParsedResponse.data?.delayIndex?.observationCount)!)
                            
                            self.journey[index[0]].leg[0].flights[index[1]].averageDelay = Int((currentParsedResponse.data?.delayIndex?.averageDelay)!)
                            
                            self.journey[index[0]].leg[0].flights[index[1]].ontimePerformanceDataStoringTime = "\(hour):\(minutes):\(seconds)"
                        }
                        
                        self.flightInfoTableView.reloadData()
                    }
                }
            }
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    func callAPIforBaggageInfo(sid:String, fk:String)
    {
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .baggageResult(sid: sid, fk: fk), completionHandler: {    (data) in
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject] {
                        if let data = result["data"] as? NSDictionary {
                            
                            let keys = data.allKeys
                            if keys.count > 0{
                                for j in 0...keys.count-1{
                                    let str = keys[j] as! String
                                    if let datas = data.value(forKey: str) as? NSDictionary
                                    {
                                        self.baggageData += [datas]
                                    }
                                }
                            }
                        }
                    }
                    
                    
//                    self.baggageData = self.baggageData.reversed()
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
                }
            }catch{
            }
        } , failureHandler : { (error ) in
            print(error)
        })
    }
}
