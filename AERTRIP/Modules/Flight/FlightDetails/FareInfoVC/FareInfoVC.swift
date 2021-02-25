//
//  FareInfo.swift
//  Aertrip
//
//  Created by Monika Sonawane on 27/12/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//
protocol flightDetailsSmartIconsDelegate : AnyObject {
    func reloadSmartIconsAtIndexPath()
    func updateRefundStatusIfPending()
}


import UIKit

class FareInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    //MARK:- Outlets
    @IBOutlet weak var fareInfoTableView: UITableView!
    @IBOutlet weak var fareInfoTableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //MARK:- Variable Declaration
    weak var delegate : flightDetailsSmartIconsDelegate?
    weak var fareRulesDelegate : getFareRulesDelegate?
    
    var journey: [Journey]!
    var flights : [FlightDetail]?
    var airportDetailsResult : [String : AirportDetailsWS]!
    var sid = ""
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    var cellDataHeight = 0
    var initialFCPArray = [Int]()
    var apiCallCount = 0
    
    var isReturnJourney = false
    var fareInfoData = [JSONDictionary]()
    var fareRulesData = [JSONDictionary]()
    
    var combineAirlineCancellationFees = [[[String:[String:[cancellationSlabStruct]]]]]()
    var combineAirlineReschedulingFees = [[[String:[String:[cancellationSlabStruct]]]]]()
    
    var rafFees = [[String:[String:Int]]]()
    
    var updatedFareInfo = [updatedFareInfoDataStruct]()
    
    var fewSeatsLeftViewHeight = 0
    var selectedIndex : IndexPath?
    var isProgressBarHidden = false
    var isAPICalled = false
    
    let viewModel = FlightFareInfoVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.progress = 0.25
        progressBar.tintColor = .AertripColor
        progressBar.isHidden = true
        self.setLoader()
        self.viewModel.delegate = self
        self.addIndicator()
        fareInfoTableView.register(UINib(nibName: "FareInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "FareInfoCell")
        fareInfoTableView.register(UINib(nibName: "ChangeAirportTableViewCell", bundle: nil), forCellReuseIdentifier: "ChangeAirportCell")
        fareInfoTableView.register(UINib(nibName: "CombineFareInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "CombineFareInfoCell")
        fareInfoTableView.alwaysBounceVertical = true
        self.fareInfoTableViewBottom.constant = 0.0
        fareInfoTableView.showsVerticalScrollIndicator = true
        
        if journey != nil{
            if journey.count > 1{
                isReturnJourney = true
            }else{
                isReturnJourney = false
            }
            
            flights?.removeAll()
            for i in 0..<journey.count{
                
                if journey[i].leg[0].fcp == 1{
                    self.isAPICalled = true
                    self.viewModel.getFareInfoAPICall(sid: self.sid, fk: self.journey[i].fk, index:i)
                    self.initialFCPArray.append(1)
                }else{
                    self.apiCallCount += 1
                    self.initialFCPArray.append(0)
                    self.progressBar.isHidden = true
                    isProgressBarHidden = true
                    isAPICalled = false
                }
                
                let fare = self.journey[i].rfdPlcy
                
                let airlineCancellationData = fare.cp.getAirlineCancellationDataForAllFlights()
                combineAirlineCancellationFees.append(airlineCancellationData)
                
                let airlineReschedulingData = fare.rscp.getAirlineReschedulingDataForAllFlights()
                combineAirlineReschedulingFees.append(airlineReschedulingData)
                
                self.viewModel.getFareRulesAPICall(sid: self.sid, fk: self.journey[i].fk, index: i)
                
                if let flight = journey[i].leg.first?.flights{
                    flights?.append(flight.first!)
                }
            }
            if self.apiCallCount == self.journey.count{
                self.confirmDelegate()
            }
            self.fareInfoTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
             self.fareInfoTableView.reloadData()
            }
            DispatchQueue.main.async {
                self.fareInfoTableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.fareInfoTableView.layoutIfNeeded()
    }
    
    
    private func setLoader(){
        if #available(iOS 13.0, *) {
            indicator.style = .large
        } else {
             indicator.style = .whiteLarge
        }
        indicator.hidesWhenStopped = true
        indicator.tintColor = AppColors.themeGreen
        indicator.color = AppColors.themeGreen
    }
    
    private func addIndicator() {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func removeIndicator(){
        DispatchQueue.main.async {
            self.indicator.isHidden = true
            self.indicator.stopAnimating()
        }
    }
    
    
    func confirmDelegate(){
        self.fareInfoTableView.delegate = self
        self.fareInfoTableView.dataSource = self
        self.removeIndicator()
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
            guard let changeAirportCell = tableView.dequeueReusableCell(withIdentifier: "ChangeAirportCell") as? ChangeAirportTableViewCell else {return UITableViewCell()}
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
                    guard let fareInfoCell = tableView.dequeueReusableCell(withIdentifier: "FareInfoCell") as? FareInfoTableViewCell else{return UITableViewCell()}
                                        
                    let isFareRulesButtonVisible = fareInfoCell.setupFareRulesButton(fareRulesData: fareRulesData, index: indexPath.section)
                    
                    if isFareRulesButtonVisible {
                        fareInfoCell.fareRulesButton.tag = indexPath.section
                        fareInfoCell.fareRulesButton.addTarget(self, action: #selector(fareRulesButtonClicked(_:)), for: .touchUpInside)

                    }
                    
                    fareInfoCell.setupTitle(flight: flights![indexPath.row], journey: journey, index: indexPath.section,airportDetailsResult: airportDetailsResult)

                    
                    fareInfoCell.bottomSeparatorLabel.isHidden = true
 
                    if indexPath.section != 0{
                        fareInfoCell.topSeperatorLabel.isHidden = false
                        fareInfoCell.topSeperatorLabelHeight.constant = 0.5
                    }else{
                        fareInfoCell.topSeperatorLabel.isHidden = true
                        fareInfoCell.topSeperatorLabelHeight.constant = 0
                    }
                    return fareInfoCell
                }else if indexPath.row == 2 {
                    guard let changeAirportCell = tableView.dequeueReusableCell(withIdentifier: "ChangeAirportCell") as? ChangeAirportTableViewCell else{return UITableViewCell()}
                    changeAirportCell.titleLabel.text = ""
                    changeAirportCell.titleLabelHeight.constant = 0
                    changeAirportCell.dataLabelTop.constant = 0
                    
                    changeAirportCell.dataLabel.attributedText = getAttributedNote()
                    changeAirportCell.topSeperatorLabelLeading.constant = 0
                    changeAirportCell.bottomStrokeHeight.constant = 0.7
                    changeAirportCell.seperatorBottom.constant = 35
                    return changeAirportCell
                }else{
                    guard let fareInfoCell = tableView.dequeueReusableCell(withIdentifier: "CombineFareInfoCell") as? CombineFareInfoTableViewCell else{return UITableViewCell()}
                    
                    fareInfoCell.journey = journey
                    fareInfoCell.flightAdultCount = flightAdultCount
                    fareInfoCell.flightChildrenCount = flightChildrenCount
                    fareInfoCell.flightInfantCount = flightInfantCount
                    fareInfoCell.indexOfCell = indexPath.section
                    
                    if self.initialFCPArray[indexPath.section] == 1{
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
                        
                        
                        let airlineCancellationData = journey[indexPath.section].rfdPlcy.cp.getAirlineCancellationDataForAllFlights()
                        fareInfoCell.airlineCancellationFees = airlineCancellationData
                        
                        let aertripCancellationData = journey[indexPath.section].rfdPlcy.cp.getAertripCancellationDataForAllFlights()
                        fareInfoCell.aertripCancellationFees = aertripCancellationData
                        
                        let airlineReschedulingData = journey[indexPath.section].rfdPlcy.rscp.getAirlineReschedulingDataForAllFlights()
                        fareInfoCell.airlineReschedulingFees = airlineReschedulingData
                        
                        let aertripReschedulingData = journey[indexPath.section].rfdPlcy.rscp.getAertripReschedulingDataForAllFlights()
                        fareInfoCell.aertripReschedulingFees = aertripReschedulingData
                        
                        fareInfoCell.combineAirlineCancellationFees = combineAirlineCancellationFees
                        fareInfoCell.combineAirlineReschedulingFees = combineAirlineReschedulingFees
                        
                        let rafFeesData = journey[indexPath.section].rfdPlcy.cp.RAF
                        
                        fareInfoCell.rafFees = rafFeesData
                    }
                    
                    fareInfoCell.combineFareTableView.reloadData()
                    fareInfoCell.layoutSubviews()
                    fareInfoCell.layoutIfNeeded()
                    let height = fareInfoCell.combineFareTableView.contentSize.height
                    if fareInfoCell.isNoInfoViewVisible{
                        fareInfoCell.tableViewHeight.constant = (height < 170) ? 170 : height
                    }else{
                        fareInfoCell.tableViewHeight.constant = height
                    }
                    fareInfoCell.layoutSubviews()
                    fareInfoCell.layoutIfNeeded()
                    fareInfoCell.combineFareTableView.reloadData()
                    
                    return fareInfoCell
                }
            }else{
                if indexPath.row == 0{
                    guard let fareInfoCell = tableView.dequeueReusableCell(withIdentifier: "FareInfoCell") as? FareInfoTableViewCell else{return UITableViewCell()}
                                        
                    let isFareRulesButtonVisible = fareInfoCell.setupFareRulesButton(fareRulesData: fareRulesData, index: indexPath.section)
                    
                    if isFareRulesButtonVisible {
                        fareInfoCell.fareRulesButton.tag = indexPath.section
                        fareInfoCell.fareRulesButton.addTarget(self, action: #selector(fareRulesButtonClicked(_:)), for: .touchUpInside)

                    }

                    fareInfoCell.setupTitle(flight: flights![indexPath.row], journey: journey, index: indexPath.section, airportDetailsResult: airportDetailsResult)
                    
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
                    guard let fareInfoCell = tableView.dequeueReusableCell(withIdentifier: "CombineFareInfoCell") as? CombineFareInfoTableViewCell else{return UITableViewCell()}
                    
                    fareInfoCell.journey = journey
                    fareInfoCell.flightAdultCount = flightAdultCount
                    fareInfoCell.flightChildrenCount = flightChildrenCount
                    fareInfoCell.flightInfantCount = flightInfantCount
                    fareInfoCell.indexOfCell = indexPath.section
                    
                    if initialFCPArray[indexPath.section] == 1{
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
                        
                        let airlineCancellationData = journey[indexPath.section].rfdPlcy.cp.getAirlineCancellationDataForAllFlights()
                        
                        fareInfoCell.airlineCancellationFees = airlineCancellationData
                        
                        let aertripCancellationData = journey[indexPath.section].rfdPlcy.cp.getAertripCancellationDataForAllFlights()
                        fareInfoCell.aertripCancellationFees = aertripCancellationData
                        
                        let airlineReschedulingData = journey[indexPath.section].rfdPlcy.rscp.getAirlineReschedulingDataForAllFlights()
                        fareInfoCell.airlineReschedulingFees = airlineReschedulingData
                        
                        let aertripReschedulingData = journey[indexPath.section].rfdPlcy.rscp.getAertripReschedulingDataForAllFlights()
                        fareInfoCell.aertripReschedulingFees = aertripReschedulingData
                        
                        fareInfoCell.combineAirlineCancellationFees = combineAirlineCancellationFees
                        fareInfoCell.combineAirlineReschedulingFees = combineAirlineReschedulingFees
                        
                        let rafFeesData = journey[indexPath.section].rfdPlcy.cp.RAF
                        
                        fareInfoCell.rafFees = rafFeesData
                    }
                                        
                    fareInfoCell.combineFareTableView.reloadData()
                    fareInfoCell.layoutSubviews()
                    fareInfoCell.layoutIfNeeded()
                    let height = fareInfoCell.combineFareTableView.contentSize.height
                    if fareInfoCell.isNoInfoViewVisible{
                        fareInfoCell.tableViewHeight.constant = (height < 170) ? 170 : height
                    }else{
                        fareInfoCell.tableViewHeight.constant = height
                    }
                    
                    fareInfoCell.layoutSubviews()
                    fareInfoCell.layoutIfNeeded()
                    fareInfoCell.combineFareTableView.reloadData()
                    
                    return fareInfoCell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        if let cell = fareInfoTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? FareInfoTableViewCell {
            cell.topSeperatorLabel.isHidden = isHidden
            cell.topSeperatorLabelHeight.constant = CGFloat(viewHeight)
        }
    }
    
    func calculateTableHeight(table: UITableView)-> CGFloat{
        var height: CGFloat = 0
        for i in 0..<table.numberOfSections{
            height += table.headerView(forSection: i)?.height ?? 0
            height += table.footerView(forSection: i)?.height ?? 0
            if table.numberOfRows(inSection: i) > 0{
                for j in 0..<table.numberOfRows(inSection: i){
                    height += table.rectForRow(at: IndexPath(row: j, section: i)).height
                }
            }
        }
        return height
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
        
        let font:UIFont = AppFonts.SemiBold.withSize(16)
        let fontSuper:UIFont = AppFonts.Regular.withSize(14)

        let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font])
        let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper])
        
        let attString2:NSMutableAttributedString = NSMutableAttributedString(string: str3, attributes: [.font:font])
        let attString3:NSMutableAttributedString = NSMutableAttributedString(string: str4, attributes: [.font:fontSuper])
        
        attString.append(attString1)
        attString.append(attString2)
        attString.append(attString3)
        
        attString.addAttributes([NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black], range: NSRange(location: 0, length: attString.string.count))
        
        return attString
    }
}


extension FareInfoVC : FlightFareInfoVMDelegate{
    func flightFareInfoData(data: Data, index:Int) {
//        self.removeIndicator()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        DispatchQueue.main.async {
            if let currentParsedResponse = parse(data: data, into: updatedFareInfoStruct.self, with:decoder) {

                if currentParsedResponse.success == true {
                    self.updatedFareInfo.append(currentParsedResponse.data.first!.value)

                    let num = 0.75/Float(self.journey.count)
                    self.progressBar.progress = Float(num+self.progressBar.progress)

                    if self.progressBar.progress == 1.0{
                        self.progressBar.isHidden = true
                    }
                    self.apiCallCount += 1
                    if self.apiCallCount == self.journey.count{
                        self.confirmDelegate()
                    }
                    self.fareInfoTableView.reloadData()

                    if self.journey[index].smartIconArray.contains("refundStatusPending"){
                        self.journey[index].leg[0].fcp = 0
                        let rfd = currentParsedResponse.data.first?.value.rfd ?? 0
                        let rsc = currentParsedResponse.data.first?.value.rsc ?? 0

                        self.journey[index].rfdPlcy.rfd.keys.forEach { (key) in
                            self.journey[index].rfdPlcy.rfd[key] = rfd
                        }

                        self.delegate?.updateRefundStatusIfPending()
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                     self.fareInfoTableView.reloadData()
                    }
                    DispatchQueue.main.async {
                        self.fareInfoTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func flightFareRules(data: JSONDictionary, index: Int) {
        let keys = data.keys
        if keys.count > 0{
            for key in keys{

                if let datas = data["\(key)"] as? JSONDictionary{
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

