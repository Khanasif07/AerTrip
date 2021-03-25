//
//  IntFlightInfoVC.swift
//  Aertrip
//
//  Created by Apple  on 02.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit
import Parchment

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
    
    var baggageData = [JSONDictionary]()
    var isChangeOfAirport = false
    var sid = ""
    var isTableviewScrolledDown = false
    let clearCache = ClearCache()
    let appdelegate = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
    var selectedIndex : IndexPath!
    var selectedJourneyFK = [String]()
    var fewSeatsLeftViewHeight = 0
    let viewModel = FlightDetailsInfoVM()


    //MARK:- Initial Display Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.journey = clearCache.checkTimeAndClearIntFlightPerformanceResultCache(journey: journey)
        clearCache.checkTimeAndClearFlightBaggageResultCache()
        self.viewModel.delegate = self
        getFlightsInfo()
        flightInfoTableView.estimatedRowHeight = UITableView.automaticDimension
        flightInfoTableView.alwaysBounceVertical = true
        
        flightInfoTableView.register(UINib(nibName: "FlightDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "FlightDetailsCell")
        flightInfoTableView.register(UINib(nibName: "LayoverViewTableViewCell", bundle: nil), forCellReuseIdentifier: "LayoverViewCell")
        flightInfoTableView.register(UINib(nibName: "ChangeAirportTableViewCell", bundle: nil), forCellReuseIdentifier: "ChangeAirportCell")
        
        flightInfoTableView.sectionFooterHeight = .zero
        flightInfoTableViewBottom.constant = 0.0
        self.flightInfoTableView.contentInset = UIEdgeInsets(top: -0.5, left: 0, bottom: 0, right: 0)
        flightInfoTableView.showsVerticalScrollIndicator = true
        
        FirebaseAnalyticsController.shared.logEvent(name: "FlightDetailsIntFlightInfo", params: ["ScreenName":"FlightDetailsFlightInfo", "ScreenClass":"IntFlightInfoVC"])

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13, *) {
//            UIApplication.shared.statusBarStyle = .lightContent
//            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if #available(iOS 13, *) {
//            UIApplication.shared.statusBarStyle = .default
//            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    //MARK:- Get Flight Info
    
    func getFlightsInfo(){
        if let legs = self.journey?.legsWithDetail{
            for j in 0..<legs.count{

                if appdelegate.flightBaggageMutableArray.count == 0{
                    self.viewModel.callAPIforBaggageInfo(sid: sid, fk: journey?.fk ?? "")
                }else{
                    for i in 0..<self.appdelegate.flightBaggageMutableArray.count{
                        if let baggageArray = self.appdelegate.flightBaggageMutableArray[i] as? JSONDictionary
                        {
                            let selectedIndex = baggageArray["selectedJourneyFK"] as? [String] ?? []
                            if self.selectedJourneyFK == selectedIndex{
                                let baggageDataResponse = baggageArray["BaggageDataResponse"] as? [JSONDictionary] ?? []
                                self.baggageData = baggageDataResponse
                            }
                        }
                    }

                    if self.baggageData.count == 0{
                        self.viewModel.callAPIforBaggageInfo(sid: sid, fk: journey?.fk ?? "")
                    }
                }

                let allFlights = legs[j].flightsWithDetails
                    for k in 0..<allFlights.count{
                        let flight = allFlights[k]

                        if flight.ontimePerformanceDataStoringTime == nil{
                            self.viewModel.callAPIforFlightsOnTimePerformace(origin: flight.fr, destination: flight.to, airline: flight.al, flight_number: flight.fn, index: [j,k], FFK:flight.ffk)
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
            guard let changeAirportCell = tableView.dequeueReusableCell(withIdentifier: "ChangeAirportCell") as? ChangeAirportTableViewCell else {return UITableViewCell()}
            changeAirportCell.titleLabel.text = "Change of Airport"
               
            let myMutableString = NSMutableAttributedString(string: "While changing airports, re-checking baggage and going back through security may be necessary. Ensure you have ample time between transfers. Kindly check all terms regarding connection, baggage transfer, visas, etc. with the airlines directly before booking this itinerary.")//. While changing airports While changing airports.")
           
//            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.clear, range: NSRange(location:273,length:49))
            changeAirportCell.dataLabel.attributedText = myMutableString
        
            return changeAirportCell
        }else{
            let count = legs[indexPath.section].flightsWithDetails.count
            if count > 0{
                if indexPath.row % 2 == 0{
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlightDetailsCell") as? FlightDetailsTableViewCell else {return  UITableViewCell()}
                    
                    var index = 0
                    if indexPath.row > 0{
                        index = indexPath.row/2
                    }else{
                        index = indexPath.row
                    }
                    
                    var flight = legs[indexPath.section].flightsWithDetails[index]
                    var amenitiesData = [String]()
                    
                    //let bgWeight = flight.bg?["ADT"]?.weight
                    if baggageData.count > 0{
                        if index < baggageData.count{
                            if let bgData = baggageData[index]["bg"] as? JSONDictionary{
                                if let adtBaggage = bgData["ADT"] as? JSONDictionary{
                                    if let weight = adtBaggage["weight"] as? String, let pieces = adtBaggage["pieces"] as? String{
                                        if pieces != "" && pieces != "-9" && pieces != "-1" && pieces != "0 pc" && pieces != "0"{
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
                            if let cbgData = baggageData[index]["cbg"] as? JSONDictionary{
                                if let adtCabinBaggage = cbgData["ADT"] as? JSONDictionary{
                                    if let weight = adtCabinBaggage["weight"] as? String, let pieces = adtCabinBaggage["pieces"] as? String
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
                            cell.amenitiesCollectionView.reloadData()
                            cell.amenitiesDisplayViewHeight.constant = 90
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
                    
                    
                    let logoURL = AppKeys.airlineMasterBaseUrl + flight.al.uppercased() + ".png"
                    cell.setAirlineImage(with: logoURL)
                    
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
                    var cc = flight.cc
                    
                    if cc.lowercased() == "premium economy"{
                        cc = "Premium E"
                    }

                    if bc != ""{
                        bc =  " (" + bc + ")"
                        if flight.ccChg == 1{
                            cell.classLabel.text = ""

                            let str = flight.al + " - " + flight.fn + "・" + " " + cc + bc + " "
                        
                            cell.classNameLabel.attributedText = cell.addAttributsForRange(str, coloredString: (" " + flight.cc + bc + " "), color: AppColors.lightYellow)
                            cell.classNameLabel.textColor = UIColor.black
                        }else{
                            cell.classLabel.text = ""
                            
                            let str = flight.al + " - " + flight.fn + "・" + "" + cc + bc + " "
                            cell.classNameLabel.attributedText = cell.addAttributsForRange(str, coloredString: flight.cc, color: UIColor.clear)
                            cell.classNameLabel.textColor = AppColors.themeGray40
                        }
                    }else{
                        let str  = flight.al + " - " + flight.fn + "・" + cc
                        cell.classNameLabel.text = str
                        cell.classNameLabel.textColor = AppColors.themeGray40
                    }
                    
                    cell.arrivalAirportLabel.text = flight.to
                    cell.arrivalTimeLabel.text = flight.at
                    cell.departureTimeLbl.text = flight.dt
                    
                    if flight.isDepartureAirportChange == true
                    {
                        cell.setDepartureAirportLabel(str: " \(flight.fr).")
                    }else{
                        cell.departureAirportLabel.attributedText = nil
                        cell.departureAirportLabel.text = flight.fr
                    }
                    
                    if flight.isArrivalAirportChange == true{
                        cell.arrivalAirportLabel.attributedText = cell.addAttributsForRange(" \(flight.to) ", coloredString: " \(flight.to) ", color: AppColors.lightYellow)
                    }else{
                        cell.arrivalAirportLabel.attributedText = cell.addAttributsForRange(flight.to, coloredString: flight.to, color: AppColors.clear)
                    }
                    
                    cell.arrivalPerformaceButton.isUserInteractionEnabled = false
                    cell.onArrivalPerformanceLabel.text = ""
                    cell.onArrivalPerformanceView.isHidden = true
                    cell.onArrivalPerformanceViewWidth.constant = 0
                    
                    if flight.ontimePerformanceDataStoringTime != nil{
                        if Double(flight.ontimePerformance ?? 0) > 90.0{
                            cell.onArrivalPerformanceLabel.textColor = AppColors.themeGreen
                        }else{
                            cell.onArrivalPerformanceLabel.textColor = UIColor.black
                        }
                        
                        
                        var viewWidth : CGFloat = 0
                        var ontimeText = ""
                        if isSEDevice{
                            viewWidth = 65.0
                            ontimeText = "%  On-time"
                        }else{
                            viewWidth = 87.0
                            ontimeText = "% On-time"
                        }
                        
                        cell.onArrivalPerformanceLabel.text = "\(flight.ontimePerformance ?? 0)\(ontimeText)"
                        cell.onArrivalPerformanceViewWidth.constant = viewWidth
                        cell.arrivalPerformaceButton.isUserInteractionEnabled = true
                        cell.onArrivalPerformanceView.isHidden = false
                        
                        let onTimePerformanceInPercent = flight.ontimePerformance ?? 0
                        let delayedPerformanceInPercent = flight.latePerformance ?? 0
                        let cancelledPerformanceInPercent = flight.cancelledPerformance ?? 0
                        
                        cell.onTimePerformanceSubViewWidth.constant = CGFloat(onTimePerformanceInPercent * Int(cell.onArrivalPerformanceViewWidth.constant/viewWidth))
                        cell.delayedPerformanceSubViewWidth.constant = CGFloat(delayedPerformanceInPercent * Int(cell.onArrivalPerformanceViewWidth.constant/viewWidth))
                        cell.cancelledPerformanceSubViewWidth.constant = CGFloat(cancelledPerformanceInPercent * Int(cell.onArrivalPerformanceViewWidth.constant/viewWidth))
                    }
                    
                    cell.arrivalPerformaceButton.tag = (indexPath.section*100)+index
                    cell.arrivalPerformaceButton.addTarget(self, action: #selector(flightArrivalPerfomaceButtonClicked(_:)), for: .touchUpInside)
                    
                    if flight.oc != flight.al{
                        cell.operatorLabel.text = "Operated by \(flight.oc)"
                    }else{
                        cell.operatorLabel.text = ""
                    }
                    
                    if flight.eqQuality == 1{
                        cell.equipmentsLabel.attributedText = cell.addAttributsForRange("⭑ " + flight.eq, coloredString: "⭑", color: AppColors.themeGray60, isForground: true)
                    }else{
                        cell.equipmentsLabel.text = flight.eq
                    }
                    if (flight.isArrivalDateChange ?? false){
                        let str = "  "+cell.dateConverter(dateStr: flight.ad)+"  "
                        cell.arrivalDateLabel.attributedText = cell.addAttributsForRange(str, coloredString: str, color: AppColors.lightYellow)
                    }else{
                        cell.arrivalDateLabel.attributedText = nil
                        cell.arrivalDateLabel.text = cell.dateConverter(dateStr: flight.ad)
                    }
                    
                    if (flight.isDepartureDateChange ?? false){
                        
                        let str = "  "+cell.dateConverter(dateStr: flight.dd)+" ."
                        let str1 = "  "+cell.dateConverter(dateStr: flight.dd)+" "
                        
                        cell.setDepartureDate(str:str,str1:str1)
                    }else{
                        cell.departureDateLabel.attributedText = nil
                        cell.departureDateLabel.text = cell.dateConverter(dateStr: flight.dd)
                    }
                    
                    if flight.atm != ""{
                        if flight.isArrivalTerminalChange == true{
                            cell.arrivalTerminalLabel.attributedText = cell.addAttributsForRange(" \(flight.atm) ", coloredString: " \(flight.atm) ", color: AppColors.lightYellow)
                        }else{
                            cell.arrivalTerminalLabel.attributedText = cell.addAttributsForRange(flight.atm, coloredString: flight.atm, color: AppColors.clear)
                        }
                    }
                    
                    if flight.dtm != ""{
                        if flight.isDepartureTerminalChange == true
                        {
                            cell.departureTerminalLabel.attributedText = cell.addAttributsForRange(" \(flight.dtm) ", coloredString: " \(flight.dtm) ", color: AppColors.lightYellow)
                        }else{
                            cell.departureTerminalLabel.attributedText = cell.addAttributsForRange(flight.dtm, coloredString: flight.dtm, color: AppColors.clear)
                        }
                    }
                    
                    if let arrivalAirportDetails = airportDetailsResult[flight.to]{
                        
                        let main_string = arrivalAirportDetails.n + "\n" + arrivalAirportDetails.c + ", " + arrivalAirportDetails.cn
                        let string_to_color = arrivalAirportDetails.c + ", " + arrivalAirportDetails.cn
                        cell.arrivalAirportAddressLabel.attributedText = cell.addAttributsForRange(main_string, coloredString: string_to_color, color: AppColors.themeBlack, isForground: true)
                    }else{
                        cell.arrivalAirportAddressLabel.text = ""
                    }
                    
                    if let departureAirportDetails = airportDetailsResult[flight.fr]{
                        let main_string1 = departureAirportDetails.n + "\n" + departureAirportDetails.c + ", " + departureAirportDetails.cn
                        let string_to_color1 = departureAirportDetails.c + ", " + departureAirportDetails.cn
                        cell.departureAirportAddressLabel.attributedText = cell.addAttributsForRange(main_string1, coloredString: string_to_color1, color: AppColors.themeBlack, isForground: true)
                    }else{
                        cell.departureAirportAddressLabel.text = ""
                    }
                    
                    
                    if indexPath.row == 0{
                        let ap = legs[indexPath.section].ap
                        let departureAirportDetails = airportDetailsResult[ap[0]]
                        let arrivalAirportDetails = airportDetailsResult[ap[1]]
                        
                        if departureAirportDetails != nil && arrivalAirportDetails != nil{
                            cell.journeyTitle = departureAirportDetails!.c + " → " + arrivalAirportDetails!.c
                        }else if departureAirportDetails != nil{
                            cell.journeyTitle = departureAirportDetails!.c
                        }else if arrivalAirportDetails != nil{
                            cell.journeyTitle = arrivalAirportDetails?.c ?? ""
                        }else{
                            cell.journeyTitle = ""
                        }
                    }else{
                        cell.journeyTitle = ""
                    }

                    cell.setJourneyTitle()
                    
                    cell.count = count
                    cell.halt = flight.halt
                    cell.durationTitle = legs[indexPath.section].durationTitle
                    cell.ovgtf = flight.ovgtf
                    cell.travellingTiming = getTravellingTiming(duration: flight.ft)
                    cell.setTravellingTime()

                    
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
                    
                    if indexPath.row == 0{
                        cell.topSeperatorViewHeight.constant = 0.5
                        cell.topSeperatorView.isHidden = false

                    }else{
                        cell.topSeperatorViewHeight.constant = 0
                        cell.topSeperatorView.isHidden = true

                    }
                    
                    return cell
                }else{
                    guard let layoverCell = tableView.dequeueReusableCell(withIdentifier: "LayoverViewCell") as? LayoverViewTableViewCell else {return UITableViewCell()}
                    
                    var index = 0
                    if indexPath.row > 0{
                        index = (indexPath.row - 1)/2
                    }else{
                        index = indexPath.row
                    }
                    
                    let flight = legs[indexPath.section].flightsWithDetails[index]
                    
                    if airportDetailsResult != nil{
                        
                        var layoverCityName = ""
                        if let arrivalAirportDetails = airportDetailsResult[flight.to]{
                            layoverCityName = arrivalAirportDetails.c
                        }
                        
                        layoverCell.layoverCityName = layoverCityName
                        layoverCell.ovgtlo = flight.ovgtlo
                    }
                    var layoverTime =  ""
                    let lott = legs[indexPath.section].lott
                    if lott.count > 0{
                        if index < lott.count{
                            layoverTime = getTravellingTiming(duration: lott[index])
                        }
                    }
                    
                    layoverCell.layoverTime = layoverTime
                    layoverCell.llo = flight.llo
                    layoverCell.slo = flight.slo
                    layoverCell.isArrivalAirportChange = flight.isArrivalAirportChange ?? false
                    layoverCell.isArrivalTerminalChange = flight.isArrivalTerminalChange ?? false

                    layoverCell.layoverLabel.attributedText = layoverCell.getLayoverString()
                    
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
    
    func getAttributedTitle(with str: String, subTitle: String) -> NSAttributedString{
        let main_string111 = " \(str) \n Via \(subTitle) "
        let string_to_color111 = " Via \(subTitle) "
        
        let arrivalAirportRange = (main_string111 as NSString).range(of: string_to_color111)
        let haltAtAttributedString = NSMutableAttributedString(string:main_string111)
        haltAtAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: arrivalAirportRange)
        haltAtAttributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0), range: arrivalAirportRange)
        return haltAtAttributedString
    }
    
    
    //MARK:- Set Image
    func setImageFromPath(urlPath : String  , to imageView : UIImageView){
        imageView.setImageWithUrl(urlPath, placeholder: UIImage(), showIndicator: false)//resourceFor(urlPath: urlPath)
    }
    
    func getSelectedAmenities(amenitiesData:[String:String], index:Int, cellIndexPath: IndexPath){
        (self.parent?.parent as? PagingViewController)?.select(index: 1)
    }
    
    //MARK:- Button Actions
    @objc func flightArrivalPerfomaceButtonClicked(_ sender:UIButton){
        
        FirebaseAnalyticsController.shared.logEvent(name: "FlightDetailsIntFlightInfoOnTimePerformanceClicked", params: ["ScreenName":"FlightDetailsFlightInfo", "ScreenClass":"IntFlightInfoVC"])

        let arrivalPerformanceView = ArrivalPerformaceVC(nibName: "ArrivalPerformaceVC", bundle: nil)
        
        let section = sender.tag / 100
        let row = sender.tag % 100
        
        if let flight = journey?.legsWithDetail[section].flightsWithDetails[row]{
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
//    func callAPIforFlightsOnTimePerformace(origin: String, destination: String, airline: String, flight_number: String, index:[Int],FFK:String, count:Int = 3){
//        guard count > 0 else {return}
//        let param = ["origin": origin,"destination":destination,"airline":airline,"flight_number":flight_number]
//        APICaller.shared.getFlightPerformanceData(params: param){[weak self](prData, error) in
//            guard let self = self else {return}
//            if let data = prData{
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                DispatchQueue.main.async {
//                    if var currentParsedResponse = parse(data: data, into: flightPerformaceResponse.self, with:decoder) {
//
//                        if currentParsedResponse.success == true{
//                            currentParsedResponse.data?.delayIndex?.index = index
//
//                            let date = Date()
//                            let calendar = Calendar.current
//                            let hour = calendar.component(.hour, from: date)
//                            let minutes = calendar.component(.minute, from: date)
//                            let seconds = calendar.component(.second, from: date)
//                            guard let flight = self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]] else {return}
//
//                            if flight.ffk == FFK{
//                                self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].ontimePerformance = Int((currentParsedResponse.data?.delayIndex?.ontime) ?? "0")
//
//                                self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].latePerformance = Int((currentParsedResponse.data?.delayIndex?.late) ?? "0")
//
//                                self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].cancelledPerformance = Int((currentParsedResponse.data?.delayIndex?.cancelled) ?? "0")
//
//                                self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].observationCount = Int((currentParsedResponse.data?.delayIndex?.observationCount) ?? "0")
//
//                                self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].averageDelay = Int((currentParsedResponse.data?.delayIndex?.averageDelay) ?? "0")
//                                self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].ontimePerformanceDataStoringTime = "\(hour):\(minutes):\(seconds)"
//                            }
//
//                            self.flightInfoTableView.reloadData()
//                        }
//                    }
//                }
//            }else{
//                self.callAPIforFlightsOnTimePerformace(origin: origin, destination: destination, airline: airline, flight_number: flight_number, index:index, FFK:FFK,count:count - 1)
//            }
//        }
//    }
    
//    func callAPIforBaggageInfo(sid:String, fk:String, count:Int = 3){
//
//        let param = [APIKeys.sid.rawValue:sid, "fk[]":fk]
//        APICaller.shared.getFlightbaggageDetails(params: param) {[weak self] (data, error) in
//            guard let self = self , let bgData = data else {
//                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
//                return
//            }
//            let keys = bgData.keys
//            if keys.count > 0{
//                for key in keys{
//                    if let datas = bgData["\(key)"] as? JSONDictionary{
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
//    }
}


extension IntFlightInfoVC : FlightInfoVMDelegate{
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
            guard let flight = self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]] else {return}
            if flight.ffk == fkk{
                self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].ontimePerformance = Int((currentParsedResponse.ontime) ?? "0")
                
                self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].latePerformance = Int((currentParsedResponse.late) ?? "0")
                
                self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].cancelledPerformance = Int((currentParsedResponse.cancelled) ?? "0")
                
                self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].observationCount = Int((currentParsedResponse.observationCount) ?? "0")
                
                self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].averageDelay = Int((currentParsedResponse.averageDelay) ?? "0")
                self.journey?.legsWithDetail[index[0]].flightsWithDetails[index[1]].ontimePerformanceDataStoringTime = "\(hour):\(minutes):\(seconds)"
            }
            self.flightInfoTableView.reloadData()
        
    }
    
    
    
    
}
