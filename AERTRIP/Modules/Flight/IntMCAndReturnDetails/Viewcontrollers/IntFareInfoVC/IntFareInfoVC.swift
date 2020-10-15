//
//  IntFareInfoVC.swift
//  Aertrip
//
//  Created by Apple  on 09.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

protocol  UpdateRefundStatusDelegate : NSObjectProtocol{
    func updateRefundStatus(for fk:String, rfd:Int, rsc:Int)
}

class IntFareInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    //MARK:- Outlets
    @IBOutlet weak var fareInfoTableView: UITableView!
    @IBOutlet weak var fareInfoTableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var progressBar: UIProgressView!
    
    //MARK:- Variable Declaration
    weak var delegate : flightDetailsSmartIconsDelegate?
    var fareRulesDelegate : getFareRulesDelegate?

    var journey = [IntJourney]()
    var flights : [IntFlightDetail]?
    var airportDetailsResult : [String : IntAirportDetailsWS]!
    var sid = ""
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    var cellDataHeight = 0
    var showAccordingTolegs = false
    var fareInfoData = [JSONDictionary]()
    var fareRulesData = [JSONDictionary]()
    weak var refundDelegate:UpdateRefundStatusDelegate?
    var rafFees = [[String:Int]]()
    var updatedFareInfo:IntFlightFareInfoResponse?
    var isTableViewReloaded = false
    var fewSeatsLeftViewHeight = 0
    var selectedIndex : IndexPath?
    var isAPIFailed = false
    var isIndicatorHidden = true
    //Indicator:---
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
//        setLoader()
        
        progressBar.progress = 0.25
        progressBar.tintColor = .AertripColor

        self.fareInfoTableView.backgroundColor = AppColors.themeGray04
        fareInfoTableView.register(UINib(nibName: "IntFareInfoCell", bundle: nil), forCellReuseIdentifier: "IntFareInfoCell")
        fareInfoTableView.register(UINib(nibName: "ChangeAirportTableViewCell", bundle: nil), forCellReuseIdentifier: "ChangeAirportCell")
        fareInfoTableView.register(UINib(nibName: "IntCombineFareInfoCell", bundle: nil), forCellReuseIdentifier: "IntCombineFareInfoCell")
        fareInfoTableView.alwaysBounceVertical = true
        self.fareInfoTableView.separatorStyle = .none
        self.fareInfoTableViewBottom.constant = 0.0
        guard let journey = self.journey.first else {return}
        if journey.legsWithDetail.first?.fcp == 0
        {
            self.progressBar.isHidden = true

            var fareInfo = IntFareInfo(JSON())
            fareInfo.cp = journey.fare.cancellationCharges
            fareInfo.rscp = journey.fare.reschedulingCharges
            self.updatedFareInfo = IntFlightFareInfoResponse(JSON())
            updatedFareInfo?.updatedFareInfo = [fareInfo]
            self.showAccordingTolegs = (self.updatedFareInfo?.updatedFareInfo.first?.cp.details.spcFee["ADT"]?.feeDetail.values.count == self.journey.first?.legsWithDetail.count)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
             self.fareInfoTableView.reloadData()
            }
            DispatchQueue.main.async {
                self.fareInfoTableView.reloadData()
            }
        }else{
            self.progressBar.isHidden = false

            self.getFareInfoAPICall(sid: self.sid, fk: journey.fk)
        }
        self.getFareRulesAPICall(sid: self.sid, fk: journey.fk)
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
        isIndicatorHidden = false
        indicator.frame = CGRect(x: 0, y: 200, width: 40, height: 40)
        indicator.center.x = self.view.center.x
        indicator.center.y = self.view.center.y-150
        if !self.view.contains(indicator){
            self.view.addSubview(indicator)
        }
        indicator.startAnimating()
    }
    
    func removeIndicator(){
        DispatchQueue.main.async {
            self.isIndicatorHidden = true
            self.indicator.removeFromSuperview()
            self.indicator.stopAnimating()
        }
    }
    
    //MARK:- Tableview Methods
    func numberOfSections(in tableView: UITableView) -> Int{
        if self.showAccordingTolegs{
            return (self.journey.first?.legsWithDetail.count ?? 0) + 1
        }else{
            return 2
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.showAccordingTolegs{
            if section == (self.journey.first?.legsWithDetail.count ?? 0){
                return 1
            }else{
                return 2
            }
        }else{
            if section == 1{
                return 1
            }else{
                return 2
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if self.showAccordingTolegs{
            if indexPath.section == self.journey.first?.legsWithDetail.count{
                return getNoteCell()
            }else{
                if indexPath.row == 0{
                    return self.getFareInfoWithLegs(at: indexPath)
                }else{
                    return getCombineFareWithLegs(at: indexPath)
                }
            }
        }else{
            if indexPath.section == 1{
                return getNoteCell()
            }else{
                if indexPath.row == 0{
                    return self.getFareInfoCellWithJourney(with: indexPath)
                }else if indexPath.row == 2 {
                    return self.getChangeAirportCell()
                }else{
                    return getCombineFareInfoWithJourney(with: indexPath)
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
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
    
    //MARK:- API Call
    func getFareInfoAPICall(sid: String, fk: String, count:Int = 3){
        guard count > 0 else {
            isAPIFailed = true
            DispatchQueue.main.async {
                self.fareInfoTableView.reloadData()
            }
            return
        }
        let webservice = WebAPIService()
//        self.addIndicator()
        webservice.executeAPI(apiServive: .fareInfoResult(sid: sid, fk: fk), completionHandler: {[weak self](data) in
            guard let self = self else {return}
            self.removeIndicator()
            guard let json = try? JSON(data: data) else {return}
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            DispatchQueue.main.async {
                if let currentParsedResponse = parse(data: data, into: updatedFareInfoStruct.self, with:decoder) {
                    if currentParsedResponse.success == true{
                        self.updatedFareInfo = IntFlightFareInfoResponse(json)
                        self.showAccordingTolegs = (self.updatedFareInfo?.updatedFareInfo.first?.cp.details.spcFee["ADT"]?.feeDetail.values.count == self.journey.first?.legsWithDetail.count)
                        
                        let num = 0.75/Float(self.journey.count)
                        self.progressBar.progress = Float(num+self.progressBar.progress)
                        
                        if self.progressBar.progress == 1.0{
                            self.progressBar.isHidden = true
                        }
                        
                        self.fareInfoTableView.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                         self.fareInfoTableView.reloadData()
                        }
                        DispatchQueue.main.async {
                            self.fareInfoTableView.reloadData()
                        }
                        let rfd = (currentParsedResponse.data.values.first?.rfd ?? 0)
                        let rsc = currentParsedResponse.data.values.first?.rsc ?? 0
                        self.refundDelegate?.updateRefundStatus(for: self.journey.first!.fk, rfd: rfd, rsc:rsc)
                    }
                }
            }
        } , failureHandler : {[weak self](error ) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.removeIndicator()
                self.getFareInfoAPICall(sid: sid, fk: fk, count:count-1)
            }
            print(error)
        })
    }
    
    func getFareRulesAPICall(sid: String, fk: String, count:Int = 3){
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .fareRulesResult(sid: sid, fk: fk), completionHandler: {[weak self](data) in
            guard let self = self else {return}
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject] {
                        
                        if let data = result["data"] as? JSONDictionary {
                            
                            let keys = data.keys
                            if let datas = data[keys.first ?? ""] as? JSONDictionary{
                                self.fareRulesData.insert(datas, at: 0)
                            }
                            self.fareInfoTableView.reloadData()
                        }
                    }
                }
            }catch{
                
            }
        } , failureHandler : {[weak self] (error ) in
            guard let self = self else {return}
            self.getFareRulesAPICall(sid: sid, fk: fk,count:count-1)
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
        let font = AppFonts.SemiBold.withSize(16)//UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
        let fontSuper = AppFonts.Regular.withSize(14)//UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
        
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font])
        let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper])
        
        let attString2:NSMutableAttributedString = NSMutableAttributedString(string: str3, attributes: [.font:font])
        let attString3:NSMutableAttributedString = NSMutableAttributedString(string: str4, attributes: [.font:fontSuper])
        
        attString.append(attString1)
        attString.append(attString2)
        attString.append(attString3)
        
        attString.addAttributes([NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black], range: NSRange(location: 0, length: attString.string.count))
        let stl = NSMutableParagraphStyle()
        stl.alignment = .left
        stl.headIndent = 15
        stl.paragraphSpacingBefore = 3
        attString.addAttributes([.paragraphStyle: stl], range: NSString(string:(str1 + str2 + str3 + str4)).range(of: str3))
        return attString
    }
}
//MARK:- Cell For single ADT object.
extension IntFareInfoVC{
    
    func getNoteCell()->UITableViewCell{
        
        let changeAirportCell = self.fareInfoTableView.dequeueReusableCell(withIdentifier: "ChangeAirportCell") as! ChangeAirportTableViewCell
        changeAirportCell.titleLabel.text = ""
        changeAirportCell.titleLabelHeight.constant = 0
        changeAirportCell.dataLabelTop.constant = 0
        
        changeAirportCell.dataLabel.attributedText = getAttributedNote()
        changeAirportCell.seperatorBottom.constant = 35
        changeAirportCell.bottomStrokeHeight.constant = 0.7
        return changeAirportCell
        
    }
    
    
    func getFareInfoCellWithJourney(with indexPath:IndexPath)->UITableViewCell{
        let fareInfoCell = fareInfoTableView.dequeueReusableCell(withIdentifier: "IntFareInfoCell") as! IntFareInfoCell
        
        let isFareRulesButtonVisible = fareInfoCell.setupFareRulesButton(fareRulesData: fareRulesData, index: indexPath.section)
        
        if isFareRulesButtonVisible {
            fareInfoCell.fareRulesButton.tag = indexPath.section
            fareInfoCell.fareRulesButton.addTarget(self, action: #selector(fareRulesButtonClicked(_:)), for: .touchUpInside)

        }

        
        let allflight = (self.journey.flatMap{$0.legsWithDetail}).flatMap{$0.flightsWithDetails}//flights![indexPath.row]
        var displayTitle = ""
        for flight in allflight {
            let cc = flight.cc
            let fbn = flight.fbn
            var bc = flight.bc
            bc =  (bc != "") ? " (" + bc + ")" : ""
            if fbn != ""{
                if !displayTitle.contains(find: fbn.capitalized + bc){
                    bc += (flight.ffk == (allflight.last?.ffk ?? "")) ? " " : ", "
                    displayTitle += fbn.capitalized + bc
                }
            }else{
                if !displayTitle.contains(find: cc.capitalized + bc){
                    bc += (flight.ffk == (allflight.last?.ffk ?? "")) ? " " : ", "
                    displayTitle += cc.capitalized + bc
                }
            }
        }
        if displayTitle.suffix(2) == ", "{
            displayTitle.removeLast(2)
        }
        let location = displayTitle
        fareInfoCell.titleLabel.text = location
        fareInfoCell.bottomSeparatorLabel.isHidden = true
        fareInfoCell.bottomSeparatorLabelLeading.constant = 16
        if indexPath.section != 0{
            fareInfoCell.topSeperatorLabel.isHidden = false
            fareInfoCell.topSeperatorLabelHeight.constant = 0.5
        }else{
            fareInfoCell.topSeperatorLabel.isHidden = true
            fareInfoCell.topSeperatorLabelHeight.constant = 0
        }
        fareInfoCell.titleLabelTop.constant = 16
        fareInfoCell.carrierImgView.isHidden = true
        fareInfoCell.journeyNameLabel.isHidden = true
        fareInfoCell.journeyNameDividerLabel.isHidden = true

        return fareInfoCell
    }
    
    func getChangeAirportCell()-> UITableViewCell{
        let changeAirportCell = fareInfoTableView.dequeueReusableCell(withIdentifier: "ChangeAirportCell") as! ChangeAirportTableViewCell
        changeAirportCell.titleLabel.text = ""
        changeAirportCell.titleLabelHeight.constant = 0
        changeAirportCell.dataLabelTop.constant = 0
        changeAirportCell.dataLabel.attributedText = getAttributedNote()
        changeAirportCell.topSeperatorLabelLeading.constant = 16
        changeAirportCell.topSeperatorLabelTop.constant = 12
        changeAirportCell.seperatorBottom.constant = 35
        return changeAirportCell

    }
    
    
    func getCombineFareInfoWithJourney(with indexPath: IndexPath)-> UITableViewCell
    {
        let fareInfoCell = fareInfoTableView.dequeueReusableCell(withIdentifier: "IntCombineFareInfoCell") as! IntCombineFareInfoCell
        
        fareInfoCell.journey = journey
        fareInfoCell.legsCount = 1
        fareInfoCell.flightAdultCount = flightAdultCount
        fareInfoCell.flightChildrenCount = flightChildrenCount
        fareInfoCell.flightInfantCount = flightInfantCount
        fareInfoCell.indexOfCell = indexPath.section
        
        if journey.count > 0{
            if journey[indexPath.section].legsWithDetail.first?.fcp == 1{
                fareInfoCell.withApi = true
                if (updatedFareInfo?.updatedFareInfo.count ?? 0) > 0{
                    fareInfoCell.isNoInfoViewVisible = false
                    fareInfoCell.combineFareTableView.isHidden = false
                    fareInfoCell.noInfoView.isHidden = true
                    
                    let airlineCancellationData = updatedFareInfo?.updatedFareInfo.first?.cp.details.spcFee
                    
                    fareInfoCell.intAirlineCancellationFees = airlineCancellationData ?? [:]
                    
                    let aertripCancellationData = updatedFareInfo?.updatedFareInfo.first?.cp.details.sucFee
                    fareInfoCell.intAertripCancellationFees = aertripCancellationData ?? [:]
                    
                    let airlineReschedulingData = updatedFareInfo?.updatedFareInfo.first?.rscp.details.spcFee
                    fareInfoCell.intAirlineReschedulingFees = airlineReschedulingData ?? [:]
                    
                    let aertripReschedulingData = updatedFareInfo?.updatedFareInfo.first?.rscp.details.sucFee
                    fareInfoCell.intAertripReschedulingFees = aertripReschedulingData ?? [:]
                    let rafFeesData = updatedFareInfo?.updatedFareInfo.first?.cp.details.raf
                    fareInfoCell.rafFees = rafFeesData ?? [:]
                    fareInfoCell.isNoInfoViewVisible = false

                    
                }else{
//                    if progressBar.isHidden{
                        fareInfoCell.isNoInfoViewVisible = true
                        fareInfoCell.combineFareTableView.isHidden = true
                        fareInfoCell.noInfoView.isHidden = false
//                    }else{
//                        fareInfoCell.isNoInfoViewVisible = false
//                        fareInfoCell.combineFareTableView.isHidden = false
//                        fareInfoCell.noInfoView.isHidden = true
//                    }
                }
            }else{
                fareInfoCell.withApi = false
                let airlineCancellationData = journey[indexPath.section].fare.cancellationCharges.details.spcFee
                fareInfoCell.intAirlineCancellationFees = airlineCancellationData
                
                let aertripCancellationData = journey[indexPath.section].fare.cancellationCharges.details.sucFee
                fareInfoCell.intAertripCancellationFees = aertripCancellationData
                
                let airlineReschedulingData = journey[indexPath.section].fare.reschedulingCharges.details.spcFee
                fareInfoCell.intAirlineReschedulingFees = airlineReschedulingData
                
                let aertripReschedulingData = journey[indexPath.section].fare.reschedulingCharges.details.sucFee
                fareInfoCell.intAertripReschedulingFees = aertripReschedulingData
                
                let rafFeesData = journey[indexPath.section].fare.cancellationCharges.details.raf
                
                fareInfoCell.rafFees = rafFeesData
            }
        }
        
        fareInfoCell.combineFareTableView.reloadData()
        fareInfoCell.layoutSubviews()
        fareInfoCell.layoutIfNeeded()
        let height = fareInfoCell.combineFareTableView.contentSize.height
        if (fareInfoCell.isNoInfoViewVisible){
            fareInfoCell.setConstraint(isHidden: false)
            fareInfoCell.tableViewHeight.constant = (height < 170) ? 170 : height
            
        }else{
            fareInfoCell.setConstraint(isHidden: true)
            if height < 20{
                fareInfoCell.tableViewHeight.constant = 0
            }else{
                fareInfoCell.tableViewHeight.constant = height
            }
        }
        fareInfoCell.layoutSubviews()
        fareInfoCell.layoutIfNeeded()
        fareInfoCell.combineFareTableView.reloadData()
        return fareInfoCell
    }
}

//MARK:- Cell For Multiple ADT object.
extension IntFareInfoVC{
    
    func getFareInfoWithLegs(at indexPath:IndexPath)-> UITableViewCell{
        guard let legs = self.journey.first?.legsWithDetail else {return UITableViewCell()}
        let fareInfoCell = self.fareInfoTableView.dequeueReusableCell(withIdentifier: "IntFareInfoCell") as! IntFareInfoCell
//        if self.fareRulesData.count > 0{
//            let data = (self.fareRulesData.count > indexPath.section) ? [self.fareRulesData[indexPath.section]] :  [self.fareRulesData[0]]
//            let val = data.first ?? [:]
//            if val.count > 0{
//
//                let vall = val.allValues
//                if vall.count > 0{
//                    if !(vall[0] as? String ?? "").isEmpty{
//
//                        fareInfoCell.fareRulesButton.isHidden = false
//                        fareInfoCell.fareRulesButton.isUserInteractionEnabled = true
//
//                        fareInfoCell.fareRulesButton.tag = indexPath.section
//                        fareInfoCell.fareRulesButton.addTarget(self, action: #selector(fareRulesButtonClicked(_:)), for: .touchUpInside)
//
//                    }
//                }
//            }
//        }else{
//            fareInfoCell.fareRulesButton.isHidden = true
//            fareInfoCell.fareRulesButton.isUserInteractionEnabled = false
//        }
        
        let isFareRulesButtonVisible = fareInfoCell.setupFareRulesButton(fareRulesData: fareRulesData, index: indexPath.section)
        
        if isFareRulesButtonVisible {
            fareInfoCell.fareRulesButton.tag = indexPath.section
            fareInfoCell.fareRulesButton.addTarget(self, action: #selector(fareRulesButtonClicked(_:)), for: .touchUpInside)

        }

        
        let allflight = legs.flatMap{$0.flightsWithDetails}//flights![indexPath.row]
        var displayTitle = ""
        for flight in allflight {
            let cc = flight.cc
            let fbn = flight.fbn
            var bc = flight.bc
            bc =  (bc != "") ? " (" + bc + ")" : ""
            if fbn != ""{
                if !displayTitle.contains(find: fbn.capitalized + bc){
                    bc += (flight.ffk == (allflight.last?.ffk ?? "")) ? " " : ", "
                    displayTitle += fbn.capitalized + bc
                }
            }else{
                if !displayTitle.contains(find: cc.capitalized + bc){
                    bc += (flight.ffk == (allflight.last?.ffk ?? "")) ? " " : ", "
                    displayTitle += cc.capitalized + bc
                }
            }
        }
        if displayTitle.suffix(2) == ", "{
            displayTitle.removeLast(2)
        }
        if legs.count > 0{
            var location = ""
            
            if legs.count == 1{
                location = displayTitle
                fareInfoCell.titleLabel.text = location
            }else{
                let ap = legs[indexPath.section].ap
                let departureAirportDetails = self.airportDetailsResult[ap[0]]
                let arrivalAirportDetails = self.airportDetailsResult[ap[1]]
                
//                if departureAirportDetails != nil && arrivalAirportDetails != nil{
//                    location = departureAirportDetails!.c + " → " + arrivalAirportDetails!.c + "\n" + displayTitle
//                }else if departureAirportDetails != nil{
//                    location = departureAirportDetails!.c + "\n" + displayTitle
//                }else if arrivalAirportDetails != nil{
//                    location = arrivalAirportDetails!.c + "\n" + displayTitle
//                }else{
//                    location = displayTitle
//                }
//
//                let completeText = NSMutableAttributedString(string: location)
//                let range1 = (location as NSString).range(of: displayTitle)
//
//                completeText.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Regular", size: 16.0)! , range: range1)
//                fareInfoCell.titleLabel.attributedText = completeText
                
                
                fareInfoCell.titleLabelTop.constant = 73.5
                fareInfoCell.carrierImgView.isHidden = false
                fareInfoCell.journeyNameLabel.isHidden = false
                fareInfoCell.journeyNameDividerLabel.isHidden = false

                if departureAirportDetails != nil && arrivalAirportDetails != nil{
                    location = departureAirportDetails!.c + " → " + arrivalAirportDetails!.c
                }else if departureAirportDetails != nil{
                    location = departureAirportDetails!.c
                }else if arrivalAirportDetails != nil{
                    location = arrivalAirportDetails!.c
                }else{
                    location = displayTitle
                }
                
                fareInfoCell.titleLabel.text = displayTitle
                fareInfoCell.journeyNameLabel.text = location
                
                let al = legs[indexPath.section].al.first ?? ""
                let logoURL = "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/" + al.uppercased() + ".png"
                fareInfoCell.setAirlineImage(with: logoURL)
                
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
    }
    
    
    func getCombineFareWithLegs(at indexPath:IndexPath)-> UITableViewCell{
        guard let legs = self.journey.first?.legsWithDetail else {return UITableViewCell()}
        let fareInfoCell = fareInfoTableView.dequeueReusableCell(withIdentifier: "IntCombineFareInfoCell") as! IntCombineFareInfoCell
        
        fareInfoCell.journey = journey
        fareInfoCell.legsCount = legs.count
        fareInfoCell.flightAdultCount = flightAdultCount
        fareInfoCell.flightChildrenCount = flightChildrenCount
        fareInfoCell.flightInfantCount = flightInfantCount
        fareInfoCell.indexOfCell = indexPath.section
        
        if legs.first?.fcp == 1{
            let infoCount = (updatedFareInfo?.updatedFareInfo.first?.cp.details.spcFee["ADT"]?.feeDetail.values.count ?? 0)
            if infoCount > 0
            {
                fareInfoCell.isNoInfoViewVisible = false
                fareInfoCell.combineFareTableView.isHidden = false
                fareInfoCell.noInfoView.isHidden = true
                
                var index = 0
                
                if journey.count != infoCount{
                    if indexPath.section > 0{
                        if indexPath.section > infoCount{
                            index = indexPath.section-1
                        }
                    }else{
                        index = indexPath.section
                    }
                }else{
                    index = indexPath.section
                }
                
                if index < infoCount{
                    let airlineCancellationData = updatedFareInfo?.updatedFareInfo.first?.cp.details.spcFee
                    
                    fareInfoCell.intAirlineCancellationFees = airlineCancellationData ?? [:]
                    
                    let aertripCancellationData = updatedFareInfo?.updatedFareInfo.first?.cp.details.sucFee
                    fareInfoCell.intAertripCancellationFees = aertripCancellationData ?? [:]
                    
                    let airlineReschedulingData = updatedFareInfo?.updatedFareInfo.first?.rscp.details.spcFee
                    fareInfoCell.intAirlineReschedulingFees = airlineReschedulingData ?? [:]
                    
                    let aertripReschedulingData = updatedFareInfo?.updatedFareInfo.first?.rscp.details.sucFee
                    fareInfoCell.intAertripReschedulingFees = aertripReschedulingData ?? [:]
                    
                    
                    let rafFeesData = updatedFareInfo?.updatedFareInfo.first?.cp.details.raf
                    
                    fareInfoCell.rafFees = rafFeesData ?? [:]
                }
                fareInfoCell.combineFareTableView.reloadData()
            }else{
                fareInfoCell.isNoInfoViewVisible = true
                fareInfoCell.combineFareTableView.isHidden = true
                fareInfoCell.noInfoView.isHidden = false
            }
        }else{
            fareInfoCell.withApi = false
            let airlineCancellationData = journey.first!.fare.cancellationCharges.details.spcFee
            fareInfoCell.intAirlineCancellationFees = airlineCancellationData
            
            let aertripCancellationData = journey.first!.fare.cancellationCharges.details.sucFee
            fareInfoCell.intAertripCancellationFees = aertripCancellationData
            
            let airlineReschedulingData = journey.first!.fare.reschedulingCharges.details.spcFee
            fareInfoCell.intAirlineReschedulingFees = airlineReschedulingData
            
            let aertripReschedulingData = journey.first!.fare.reschedulingCharges.details.sucFee
            fareInfoCell.intAertripReschedulingFees = aertripReschedulingData
            
            let rafFeesData = journey.first!.fare.cancellationCharges.details.raf
            
            fareInfoCell.rafFees = rafFeesData
        }
        fareInfoCell.combineFareTableView.reloadData()
        fareInfoCell.layoutSubviews()
        fareInfoCell.layoutIfNeeded()
        let height = (fareInfoCell.combineFareTableView.contentSize.height)
        if (fareInfoCell.isNoInfoViewVisible){
            fareInfoCell.setConstraint(isHidden: false)
            fareInfoCell.tableViewHeight.constant = (height < 170) ? 170 : height
            
        }else{
            if height < 20{
                fareInfoCell.tableViewHeight.constant = 0
            }else{
                fareInfoCell.tableViewHeight.constant = height
            }
            fareInfoCell.setConstraint(isHidden: true)
        }
        fareInfoCell.layoutSubviews()
        fareInfoCell.layoutIfNeeded()
        fareInfoCell.combineFareTableView.reloadData()
        return fareInfoCell
    }
    
}
