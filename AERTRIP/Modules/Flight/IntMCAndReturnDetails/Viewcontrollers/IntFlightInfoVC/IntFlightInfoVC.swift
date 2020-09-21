//
//  IntFlightInfoVC.swift
//  Aertrip
//
//  Created by Apple  on 02.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class IntFlightInfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate, getSelectedAmenitiesDelegate, UIScrollViewDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var flightInfoTableView: UITableView!
    @IBOutlet weak var flightInfoTableViewBottom: NSLayoutConstraint!
    
    //MARK:- Variable Declaration
    
    var titleString : NSAttributedString!
    var airportDetailsResult : [String : IntAirportDetailsWS]!
    var airlineDetailsResult : [String : IntAirlineMasterWS]?
    var airlineData:[String:String]?
    var journey: IntJourney?

    
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


    //MARK:- Initial Display Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.journey = clearCache.checkTimeAndClearIntFlightPerformanceResultCache(journey: journey)
        clearCache.checkTimeAndClearFlightBaggageResultCache()
        
        getFlightsInfo()
        flightInfoTableView.estimatedRowHeight = UITableView.automaticDimension
        flightInfoTableView.alwaysBounceVertical = true
        
        flightInfoTableView.register(UINib(nibName: "FlightDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "FlightDetailsCell")
        flightInfoTableView.register(UINib(nibName: "LayoverViewTableViewCell", bundle: nil), forCellReuseIdentifier: "LayoverViewCell")
        flightInfoTableView.register(UINib(nibName: "ChangeAirportTableViewCell", bundle: nil), forCellReuseIdentifier: "ChangeAirportCell")
        
        flightInfoTableView.sectionFooterHeight = .zero
        flightInfoTableViewBottom.constant = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13, *) {
            UIApplication.shared.statusBarStyle = .lightContent
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if #available(iOS 13, *) {
            UIApplication.shared.statusBarStyle = .default
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    //MARK:- Get Flight Info
    
    func getFlightsInfo(){
        if let legs = self.journey?.legsWithDetail{
            for j in 0..<legs.count{

                if appdelegate.flightBaggageMutableArray.count == 0{
                    callAPIforBaggageInfo(sid: sid, fk: journey?.fk ?? "")
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
                        callAPIforBaggageInfo(sid: sid, fk: journey?.fk ?? "")
                    }
                }

                let allFlights = legs[j].flightsWithDetails
                    for k in 0..<allFlights.count{
                        let flight = allFlights[k]

                        if flight.ontimePerformanceDataStoringTime == nil{
                            callAPIforFlightsOnTimePerformace(origin: flight.fr, destination: flight.to, airline: flight.al, flight_number: flight.fn, index: [j,k], FFK:flight.ffk)
                        }

                        if k > 0{
                            let prevFlight = allFlights[k-1]

                            if flight.fr != prevFlight.to{
                                self.journey?.legsWithDetail[j].flightsWithDetails[k].isDepartureAirportChange = true
                                self.journey?.legsWithDetail[j].flightsWithDetails[k-1].isArrivalAirportChange = true

                                isChangeOfAirport = true
                            }else{
                                self.journey?.legsWithDetail[j].flightsWithDetails[k].isDepartureAirportChange = false
                                self.journey?.legsWithDetail[j].flightsWithDetails[k-1].isArrivalAirportChange = false
                            }

                            if isChangeOfAirport{
                                self.journey?.legsWithDetail[j].flightsWithDetails[k].isDepartureTerminalChange = false
                                self.journey?.legsWithDetail[j].flightsWithDetails[k - 1].isArrivalTerminalChange = false
                            }else{
                                if flight.dtm != prevFlight.atm{
                                    self.journey?.legsWithDetail[j].flightsWithDetails[k].isDepartureTerminalChange = true
                                    self.journey?.legsWithDetail[j].flightsWithDetails[k-1].isArrivalTerminalChange = true
                                }else{
                                    self.journey?.legsWithDetail[j].flightsWithDetails[k].isDepartureTerminalChange = false
                                    self.journey?.legsWithDetail[j].flightsWithDetails[k-1].isArrivalTerminalChange = false
                                }
                            }
                            if flight.dd != prevFlight.ad{
                                self.journey?.legsWithDetail[j].flightsWithDetails[k].isDepartureDateChange = true
                            }else{
                                self.journey?.legsWithDetail[j].flightsWithDetails[k].isDepartureDateChange = false
                            }
                            
                        }else{
                            self.journey?.legsWithDetail[j].flightsWithDetails[k].isDepartureTerminalChange = false
                            self.journey?.legsWithDetail[j].flightsWithDetails[k].isArrivalTerminalChange = false

                            self.journey?.legsWithDetail[j].flightsWithDetails[k].isDepartureAirportChange = false
                            self.journey?.legsWithDetail[j].flightsWithDetails[k].isArrivalAirportChange = false
                        }
                        
                        if flight.dd != flight.ad{
                            self.journey?.legsWithDetail[j].flightsWithDetails[k].isArrivalDateChange = true
                        }else{
                            self.journey?.legsWithDetail[j].flightsWithDetails[k].isArrivalDateChange = false
                        }
                    }
                
            }
        }
    }
    
    //MARK:- TableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int{
        if let journey =  self.journey{
            if isChangeOfAirport == true{
                return journey.legsWithDetail.count+1
            }else{
                return journey.legsWithDetail.count
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let journey =  self.journey{
            if isChangeOfAirport == true{
                if section == journey.legsWithDetail.count{
                    return 1
                }else{
                    var flightCount = journey.legsWithDetail[section].flightsWithDetails.count
                    
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
                }
            }else{
                var flightCount = journey.legsWithDetail[section].flightsWithDetails.count
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
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let legs = journey?.legsWithDetail else {return UITableViewCell()}
        if indexPath.section == legs.count{
            let changeAirportCell = tableView.dequeueReusableCell(withIdentifier: "ChangeAirportCell") as! ChangeAirportTableViewCell
            changeAirportCell.titleLabel.text = "Change of Airport"
            changeAirportCell.dataLabel.text = "While changing airports, re-checking baggage and going back through security may be necessary. Ensure you have ample time between transfers. Kindly check all terms regarding connection, baggage transfer, visas, etc. with the airlines directly before booking this itinerary."
            return changeAirportCell
        }else{
            let count = legs[indexPath.section].flightsWithDetails.count
            if count > 0{
                if indexPath.row % 2 == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FlightDetailsCell") as! FlightDetailsTableViewCell
                    
                    var index = 0
                    if indexPath.row > 0{
//                        if indexPath.row <= count{
                            index = indexPath.row/2//indexPath.row-1
//                        }else{
//                            index = indexPath.row-2
//                        }
                    }else{
                        index = indexPath.row
                    }
                    
                    let flight = legs[indexPath.section].flightsWithDetails[index]
                    var amenitiesData = [String]()
                    
                    //let bgWeight = flight.bg?["ADT"]?.weight
                    if baggageData.count > 0{
                        if index < baggageData.count{
                            if let bgData = baggageData[index].value(forKey: "bg") as? NSDictionary{
                                if let adtBaggage = bgData.value(forKey: "ADT") as? NSDictionary{
                                    if let weight = adtBaggage.value(forKey: "weight") as? String, let pieces = adtBaggage.value(forKey: "pieces") as? String{
                                        if pieces != "" && pieces != "-9" && pieces != "-1" && pieces != "0 pc" && pieces != "0"{
                                            amenitiesData.append("Check-in Baggage \n(\(pieces))")
                                        }else{
                                            if weight != "" && weight != "-9" && weight != "-1" && weight != "0 kg"{
                                                amenitiesData.append("Check-in Baggage \n(\(weight))")
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
                                            if pieces != "" && pieces != "-9" && pieces != "-1" && pieces != "0 pc" && pieces != "0"{
                                                
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
                            cell.amenitiesDelegate = self
                            cell.amenitiesData = amenitiesData
                            cell.amenitiesDisplayView.isHidden = false
                            cell.amenitiesDisplayViewHeight.constant = 100
                            cell.amenitiesCollectionView.reloadData()
                        }else{
                            cell.amenitiesDisplayView.isHidden = true
                            cell.amenitiesDisplayViewHeight.constant = 0
                        }
                    }else{
                        cell.amenitiesDisplayView.isHidden = true
                        cell.amenitiesDisplayViewHeight.constant = 0
                    }
                    
                    if let flightName = airlineDetailsResult?[flight.al]?.name{
                        cell.flightNameLabel.text = flightName
                    }else if let flightName = self.airlineData?[flight.al]{
                        cell.flightNameLabel.text = flightName
                    }else{
                        cell.flightNameLabel.text = ""
                    }
                    
                    
                    let logoURL = "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/" + flight.al.uppercased() + ".png"
                    setImageFromPath(urlPath : logoURL , to: cell.airlineImageView)
                    
                    if indexPath.row == 0{
                        let ap = legs[indexPath.section].ap
                        let departureAirportDetails = airportDetailsResult[ap[0]]
                        let arrivalAirportDetails = airportDetailsResult[ap[1]]
                        
                        if departureAirportDetails != nil && arrivalAirportDetails != nil{
                            cell.titleLabel.text = departureAirportDetails!.c + " → " + arrivalAirportDetails!.c
                            cell.titleLabelHeight.constant = 25
                        } else if departureAirportDetails != nil{
                            cell.titleLabelHeight.constant = 25
                            cell.titleLabel.text = departureAirportDetails?.c
                        }else if arrivalAirportDetails != nil{
                            cell.titleLabelHeight.constant = 25
                            cell.titleLabel.text = arrivalAirportDetails?.c
                        }else{
                            cell.titleLabelHeight.constant = 0
                            cell.titleLabel.text = ""
                        }
                    }else{
                        cell.titleLabel.text = ""
                        cell.titleLabelHeight.constant = 0
                    }
                    
                    cell.classNameLabel.clipsToBounds = true
                    cell.classNameLabel.layer.cornerRadius = 3
                    cell.classNameLabel.layer.masksToBounds = true
                    
                    var bc = flight.bc
                    if bc != ""{
                        bc =  " (" + bc + ")"
                        if flight.ccChg == 1{
                            cell.classLabel.text = flight.al + " - " + flight.fn + "・"
                            
                            cell.classNameLabel.attributedText = self.addAttributsForRange((" " + flight.cc + bc + " "), coloredString: (" " + flight.cc + bc + " "), color: AppColors.lightYellow)
                            cell.classNameLabel.textColor = UIColor.black
                        }else{
                            cell.classLabel.text = flight.al + " - " + flight.fn + "・"
                            
                            cell.classNameLabel.attributedText = self.addAttributsForRange(" " + flight.cc + bc + " ", coloredString: flight.cc, color: UIColor.clear)
                            cell.classNameLabel.textColor = AppColors.themeGray40
                        }
                    }else{
                        cell.classLabel.text = flight.al + " - " + flight.fn + "・"
                        cell.classNameLabel.text = flight.cc
                        cell.classNameLabel.textColor = AppColors.themeGray40
                    }
                    cell.arrivalAirportLabel.text = flight.to
                    cell.arrivalTimeLabel.text = flight.at
                    cell.departureAirportLabel.text = flight.fr
                    cell.departureTimeLbl.text = flight.dt
                    
                    if flight.isDepartureAirportChange == true{
                        let departureAirport = " \(flight.fr) "
                        cell.departureAirportLabel.attributedText = self.addAttributsForRange(departureAirport, coloredString: " \(flight.fr) ", color: AppColors.lightYellow)
                    }else{
                        cell.departureAirportLabel.attributedText = self.addAttributsForRange(flight.fr, coloredString: flight.fr, color: UIColor.clear)
                    }
                    
                    if flight.isArrivalAirportChange == true{
                        cell.arrivalAirportLabel.attributedText = self.addAttributsForRange(" \(flight.to) ", coloredString: " \(flight.to) ", color: AppColors.lightYellow)
                    }else{
                        cell.arrivalAirportLabel.attributedText = self.addAttributsForRange(flight.to, coloredString: flight.to, color: AppColors.clear)
                    }
                    let fontAttributes = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14)]
                    let myText = cell.classNameLabel.text
                    let size = (myText! as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
                    cell.classNameLabelWidth.constant = size.width
                    
                    cell.arrivalPerformaceButton.isUserInteractionEnabled = false
                    cell.onArrivalPerformanceLabel.text = ""
                    cell.onArrivalPerformanceView.isHidden = true
                    cell.onArrivalPerformanceViewWidth.constant = 0
                    
                    if flight.ontimePerformanceDataStoringTime != nil{
                        if Double(flight.ontimePerformance!) > 90.0{
                            cell.onArrivalPerformanceLabel.textColor = AppColors.themeGreen
                        }else{
                            cell.onArrivalPerformanceLabel.textColor = UIColor.black
                        }
                        
                        cell.arrivalPerformaceButton.isUserInteractionEnabled = true
                        
                        cell.onArrivalPerformanceLabel.text = "\(flight.ontimePerformance ?? 0)% On-time"
                        
                        cell.onArrivalPerformanceView.isHidden = false
                        cell.onArrivalPerformanceViewWidth.constant = 100
                        
                        let onTimePerformanceInPercent = flight.ontimePerformance
                        let delayedPerformanceInPercent = flight.latePerformance
                        let cancelledPerformanceInPercent = flight.cancelledPerformance
                        
                        cell.onTimePerformanceSubViewWidth.constant = CGFloat(onTimePerformanceInPercent! * Int(cell.onArrivalPerformanceViewWidth.constant/100))
                        cell.delayedPerformanceSubViewWidth.constant = CGFloat(delayedPerformanceInPercent! * Int(cell.onArrivalPerformanceViewWidth.constant/100))
                        cell.cancelledPerformanceSubViewWidth.constant = CGFloat(cancelledPerformanceInPercent! * Int(cell.onArrivalPerformanceViewWidth.constant/100))
                    }
                    
                    cell.arrivalPerformaceButton.tag = (indexPath.section*100)+index
                    cell.arrivalPerformaceButton.addTarget(self, action: #selector(flightArrivalPerfomaceButtonClicked(_:)), for: .touchUpInside)
                    
                    if flight.oc != flight.al{
                        cell.operatorLabel.text = "Operated by \(flight.oc)"
                    }else{
                        cell.operatorLabel.text = ""
                    }
                    
                    if flight.eqQuality == 1{
                        cell.equipmentsLabel.attributedText = self.addAttributsForRange("⭑ " + flight.eq, coloredString: "⭑", color: AppColors.themeGray60, isForground: true)
                    }else{
                        cell.equipmentsLabel.text = flight.eq
                    }
                    if (flight.isArrivalDateChange ?? false){
//                        let str = self.dateConverter(dateStr: flight.ad)
//                        cell.arrivalDateLabel.attributedText = self.addAttributsForRange(str, coloredString: str, color: AppColors.lightYellow)
                        
                        let str = "  "+self.dateConverter(dateStr: flight.ad)+"  "
                        cell.arrivalDateLabel.attributedText = self.addAttributsForRange(str, coloredString: str, color: AppColors.lightYellow)
                        
                        
                    }else{
                        cell.arrivalDateLabel.attributedText = nil
                        cell.arrivalDateLabel.text = self.dateConverter(dateStr: flight.ad)
                    }
                    
                    if (flight.isDepartureDateChange ?? false){
                        //                        let str = self.dateConverter(dateStr: flight.dd)
                        //                        cell.departureDateLabel.attributedText = self.addAttributsForRange(str, coloredString: str, color: AppColors.lightYellow)
                        
                        let str = "  "+self.dateConverter(dateStr: flight.dd)+" ."
                        let str1 = "  "+self.dateConverter(dateStr: flight.dd)+" "
                        
                        //                        cell.departureDateLabel.attributedText = self.addAttributsForRange(str, coloredString: str, color: AppColors.lightYellow)
                        
                        
                        
                        let deptDateRange = (str as NSString).range(of: str1)
                        let deptDateAttrStr = NSMutableAttributedString(string:str)
                        deptDateAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: deptDateRange)
                        deptDateAttrStr.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0), range: deptDateRange)
                        deptDateAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.clear , range: (str as NSString).range(of: "."))
                        cell.departureDateLabel.attributedText = deptDateAttrStr
                        
                        
                        
                    }else{
                        cell.departureDateLabel.attributedText = nil
                        cell.departureDateLabel.text = self.dateConverter(dateStr: flight.dd)
                    }
                    
                    cell.arrivalTerminalLabel.text = flight.atm
                    cell.departureTerminalLabel.text = flight.dtm
                    
                    if flight.atm != ""{
                        if flight.isArrivalTerminalChange == true{
                            cell.arrivalTerminalLabel.attributedText = self.addAttributsForRange(" \(flight.atm) ", coloredString: " \(flight.atm) ", color: AppColors.lightYellow)
                        }else{
                            cell.arrivalTerminalLabel.attributedText = self.addAttributsForRange(flight.atm, coloredString: flight.atm, color: AppColors.clear)
                        }
                    }
                    
                    if flight.dtm != ""{
                        if flight.isDepartureTerminalChange == true
                        {
                            cell.departureTerminalLabel.attributedText = self.addAttributsForRange(" \(flight.dtm) ", coloredString: " \(flight.dtm) ", color: AppColors.lightYellow)
                        }else{
                            cell.departureTerminalLabel.attributedText = self.addAttributsForRange(flight.dtm, coloredString: flight.dtm, color: AppColors.clear)
                        }
                    }
                    
                    if let arrivalAirportDetails = airportDetailsResult[flight.to]{
                        
                        let main_string = arrivalAirportDetails.n + "\n" + arrivalAirportDetails.c + ", " + arrivalAirportDetails.cn
                        let string_to_color = arrivalAirportDetails.c + ", " + arrivalAirportDetails.cn
                        cell.arrivalAirportAddressLabel.attributedText = self.addAttributsForRange(main_string, coloredString: string_to_color, color: AppColors.themeBlack, isForground: true)
                    }else{
                        cell.arrivalAirportAddressLabel.text = ""
                    }
                    
                    if let departureAirportDetails = airportDetailsResult[flight.fr]{
                        let main_string1 = departureAirportDetails.n + "\n" + departureAirportDetails.c + ", " + departureAirportDetails.cn
                        let string_to_color1 = departureAirportDetails.c + ", " + departureAirportDetails.cn
                        cell.departureAirportAddressLabel.attributedText = self.addAttributsForRange(main_string1, coloredString: string_to_color1, color: AppColors.themeBlack, isForground: true)
                    }else{
                        cell.departureAirportAddressLabel.text = ""
                    }
                    
                    if indexPath.row == 0{
                        let ap = legs[indexPath.section].ap
                        let departureAirportDetails = airportDetailsResult[ap[0]]
                        let arrivalAirportDetails = airportDetailsResult[ap[1]]
                        
                        if departureAirportDetails != nil && arrivalAirportDetails != nil{
                            cell.titleLabel.text = departureAirportDetails!.c + " → " + arrivalAirportDetails!.c
                            cell.titleLabelHeight.constant = 25
                        }else if departureAirportDetails != nil{
                            cell.titleLabelHeight.constant = 25
                            cell.titleLabel.text = departureAirportDetails!.c
                        }else if arrivalAirportDetails != nil{
                            cell.titleLabelHeight.constant = 25
                            cell.titleLabel.text = arrivalAirportDetails!.c
                        }else{
                            cell.titleLabelHeight.constant = 0
                            cell.titleLabel.text = ""
                        }
                    }else{
                        cell.titleLabelHeight.constant = 0
                        cell.titleLabel.text = ""
                    }
                    
                    var travellingTime = NSAttributedString()
                    if count == 1{
                        if flight.halt != ""{
                            travellingTime = self.getAttributedTitle(with: legs[indexPath.section].durationTitle, subTitle: flight.halt)
                        }else{
                            travellingTime = NSAttributedString(string: legs[indexPath.section].durationTitle)
                        }
                    }else{
                        if flight.halt != ""{
                            travellingTime = self.getAttributedTitle(with: getTravellingTiming(duration: flight.ft), subTitle: flight.halt)
                        }else{
                            travellingTime = NSAttributedString(string: getTravellingTiming(duration: flight.ft))
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
                        cell.travelingtimeLabel.attributedText = completeText
                    }else{
                        cell.travelingtimeLabel.attributedText = travellingTime
                    }
                    
                    let totalRow = tableView.numberOfRows(inSection: indexPath.section)
                    if totalRow == 1{
                        cell.bottomSeperatorView.isHidden = false
                        cell.displayViewBottom.constant = 35.0
                    }else if(indexPath.row == totalRow-1){
                        cell.displayViewBottom.constant = 35.0
                        cell.bottomSeperatorView.isHidden = false
                    }else{
                        cell.displayViewBottom.constant = 0
                        cell.bottomSeperatorView.isHidden = true
                    }
                    
                    if indexPath.section == 0 && indexPath.row == 0{
                        cell.topSeperatorViewHeight.constant = 0
                        cell.topSeperatorView.isHidden = true
                    }else if tableView.numberOfRows(inSection: indexPath.section) > 1{
                        cell.topSeperatorView.isHidden = !(indexPath.row == 0)
                        cell.topSeperatorViewHeight.constant = (indexPath.row == 0) ? 0.5 : 0
                    }else{
                        cell.topSeperatorViewHeight.constant = 0.5
                        cell.topSeperatorView.isHidden = false
                    }
                    return cell
                }else{
                    let layoverCell = tableView.dequeueReusableCell(withIdentifier: "LayoverViewCell") as! LayoverViewTableViewCell
                    
                    var index = 0
                    if indexPath.row > 0{
                        index = (indexPath.row - 1)/2//(indexPath.row < count) ? indexPath.row-1 : indexPath.row-2
                    }else{
                        index = indexPath.row
                    }
                    
                    let flight = legs[indexPath.section].flightsWithDetails[index]
                    var displayText = ""
                    var displayImgName = ""
                    
                    if airportDetailsResult != nil{
                        
                        var layoverCityName = ""
                        if let arrivalAirportDetails = airportDetailsResult[flight.to]{
                            layoverCityName = arrivalAirportDetails.c
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
                    let lott = legs[indexPath.section].lott
                    if lott.count > 0{
                        if index < lott.count{
                            layoverTime = getTravellingTiming(duration: lott[index])
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
                    let textAfterIcon = NSMutableAttributedString(string: displayText, attributes: [.font: AppFonts.Regular.withSize(14)])
                    
                    if flight.llo == 1 || flight.slo == 1{
                        if flight.isArrivalAirportChange == true{
                            let range1 = (displayText as NSString).range(of: displayText)
                            
                            textAfterIcon.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range1)
                            textAfterIcon.addAttribute(NSAttributedString.Key.font, value: AppFonts.SemiBold.withSize(14) , range: (displayText as NSString).range(of: layoverTime))
                        }else{
                            let range1 = (displayText as NSString).range(of: layoverTime)
                            
                            textAfterIcon.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range1)
                            textAfterIcon.addAttribute(NSAttributedString.Key.font, value: AppFonts.SemiBold.withSize(14), range: range1)
                        }
                    }
                    else if flight.isArrivalAirportChange == true{
                        let range1 = (displayText as NSString).range(of: displayText)
                        
                        textAfterIcon.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range1)
                        textAfterIcon.addAttribute(NSAttributedString.Key.font, value: AppFonts.SemiBold.withSize(14), range: (displayText as NSString).range(of: layoverTime))
                    }
                    else{
                        let range1 = (displayText as NSString).range(of: layoverTime)
                        
                        textAfterIcon.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range1)
                        textAfterIcon.addAttribute(NSAttributedString.Key.font, value: AppFonts.SemiBold.withSize(14), range: range1)
                    }
                    
                    completeText.append(NSMutableAttributedString(string: "  "))
                    completeText.append(textAfterIcon)
                    layoverCell.layoverLabel.textAlignment = .center;
                    layoverCell.layoverLabel.attributedText = completeText;
                    
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
    
    func getAttributedTitle(with str: String, subTitle: String) -> NSAttributedString{
        let main_string111 = " \(str) \n Via \(subTitle) "
        let string_to_color111 = " Via \(subTitle) "
        
        let arrivalAirportRange = (main_string111 as NSString).range(of: string_to_color111)
        let haltAtAttributedString = NSMutableAttributedString(string:main_string111)
        haltAtAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: arrivalAirportRange)
        haltAtAttributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0), range: arrivalAirportRange)
        return haltAtAttributedString
    }
    
    
    func addAttributsForRange(_ text: String, coloredString:String, color: UIColor, isForground:Bool = false)-> NSAttributedString{
        
        let range = (text as NSString).range(of: coloredString)
        let attribute = NSMutableAttributedString.init(string: text)
        if isForground{
             attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        }else{
             attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: color , range: range)
        }
       
        return attribute
    }
    
    
    func dateConverter(dateStr:String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateStr){
            dateFormatter.dateFormat = "E, d MMM yyyy"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    
    //MARK:- Set Image
    func setImageFromPath(urlPath : String  , to imageView : UIImageView){
        imageView.setImageWithUrl(urlPath, placeholder: UIImage(), showIndicator: false)//resourceFor(urlPath: urlPath)
//        guard  let urlobj = URL(string: urlPath) else { return }
//        let urlRequest = URLRequest(url: urlobj)
//        if let responseObj = URLCache.shared.cachedResponse(for: urlRequest) {
//            let image = UIImage(data: responseObj.data)
//            imageView.image = image
//        }
    }
    
    func getSelectedAmenities(amenitiesData: [String : String], index: Int)
    {
    }
    
    //MARK:- Button Actions
    @objc func flightArrivalPerfomaceButtonClicked(_ sender:UIButton){
        let arrivalPerformanceView = ArrivalPerformaceVC(nibName: "ArrivalPerformaceVC", bundle: nil)
        
        let section = sender.tag / 100
        let row = sender.tag % 100
        
        if let flight = journey?.legsWithDetail[section].flightsWithDetails[row]{
            if flight.ontimePerformanceDataStoringTime != nil{
                arrivalPerformanceView.observationCount = "\(flight.observationCount ?? 0)"
                arrivalPerformanceView.averageDelay = "\(flight.averageDelay ?? 0)"
                arrivalPerformanceView.cancelledPerformanceInPercent = flight.cancelledPerformance!
                arrivalPerformanceView.delayedPerformanceInPercent = flight.latePerformance!
                arrivalPerformanceView.onTimePerformanceInPercent = flight.ontimePerformance!
                arrivalPerformanceView.modalPresentationStyle = .overFullScreen
                self.present(arrivalPerformanceView, animated: false, completion: nil)
//                arrivalPerformanceView.view.frame = self.parent!.view.bounds
//                self.parent!.view.addSubview(arrivalPerformanceView.view)
//                self.parent!.addChild(arrivalPerformanceView)
//                arrivalPerformanceView.willMove(toParent: self)
            }
        }
    }
    
    //MARK:- API Call
    func callAPIforFlightsOnTimePerformace(origin: String, destination: String, airline: String, flight_number: String, index:[Int],FFK:String, count:Int = 3){
        guard count > 0 else {return}
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .flightPerformanceResult(origin: origin, destination: destination, airline: airline, flight_number: flight_number), completionHandler: {[weak self](data) in
            guard let self = self else {return}
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
                        guard let flight = self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]] else {return}
                        
                        if flight.ffk == FFK{
                            self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].ontimePerformance = Int((currentParsedResponse.data?.delayIndex?.ontime)!)
                            
                            self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].latePerformance = Int((currentParsedResponse.data?.delayIndex?.late)!)
                            
                            self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].cancelledPerformance = Int((currentParsedResponse.data?.delayIndex?.cancelled)!)
                            
                            self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].observationCount = Int((currentParsedResponse.data?.delayIndex?.observationCount)!)
                            
                            self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].averageDelay = Int((currentParsedResponse.data?.delayIndex?.averageDelay)!)
                            self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].ontimePerformanceDataStoringTime = "\(hour):\(minutes):\(seconds)"
                        }
                        
                        self.flightInfoTableView.reloadData()
                    }
                }
            }
        } , failureHandler : {[weak self](error ) in
            guard let self = self else {return}
            self.callAPIforFlightsOnTimePerformace(origin: origin, destination: destination, airline: airline, flight_number: flight_number, index:index, FFK:FFK,count:count - 1)
            print(error)
        })
    }
    
    func callAPIforBaggageInfo(sid:String, fk:String, count:Int = 3){
        guard count > 0 else {return}
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .baggageResult(sid: sid, fk: fk), completionHandler: {[weak self](data) in
            guard let self = self else {return}
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
                                    if let datas = data.value(forKey: str) as? NSDictionary{
                                        self.baggageData += [datas]
                                    }
                                }
                            }
                        }
                    }
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
        } , failureHandler : {[weak self](error ) in
            guard let self = self else {return}
            self.callAPIforBaggageInfo(sid:sid, fk:fk, count: count-1)
            print(error)
        })
    }
}
