//
//  IntCombineFareInfoCell.swift
//  Aertrip
//
//  Created by Apple  on 11.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

typealias IntFeeDetails = IntMultiCityAndReturnWSResponse.Results.J.Fare.SubFares.Details.Fee.FeeDetail

class IntCombineFareInfoCell: UITableViewCell {
    @IBOutlet weak var combineFareTableView: UITableView!
    @IBOutlet weak var noInfoView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var nonRefundableLabel: UILabel!//Non-refundable
    @IBOutlet weak var nonReschedulableLabel: UILabel!//Non-reschedulable
    @IBOutlet weak var messageLabel: UILabel!//*Cancellation Information is currently not available online. This itinerary may be non-reschedulable
    @IBOutlet weak var nonRefundableImgTop: NSLayoutConstraint!
    @IBOutlet weak var nonRefundableImgHeight: NSLayoutConstraint!
    @IBOutlet weak var nonRefundableImgBottom: NSLayoutConstraint!
    @IBOutlet weak var nonReschedulableImgHeight: NSLayoutConstraint!
    @IBOutlet weak var nonReschedulableImgBottom: NSLayoutConstraint!
    @IBOutlet weak var messageBottom: NSLayoutConstraint!

    var intAirlineCancellationFees = [String:IntTaxes.SubFares.Details.Fee]()
    var intAertripCancellationFees = [String:IntTaxes.SubFares.Details.Fee]()
    var intAirlineReschedulingFees = [String:IntTaxes.SubFares.Details.Fee]()
    var intAertripReschedulingFees = [String:IntTaxes.SubFares.Details.Fee]()
    
    
    var rafFees = [String:Any]()
    var journey: [IntJourney]!
    var legsCount  = 0
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    var withApi = false
    var count = 0
    var isNoInfoViewVisible = false
    var indexOfCell = 0
    var isFromPassangerDetails = false

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        combineFareTableView.register(UINib(nibName: "PerSlabFareInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "PerSlabFareInfoCell")
        combineFareTableView.estimatedRowHeight = 85
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        self.combineFareTableView.layoutIfNeeded()
    }
    
    func setConstraint(isHidden: Bool){
        if isHidden{
            nonRefundableImgTop.constant = 0
            nonRefundableImgHeight.constant = 0
            nonRefundableImgBottom.constant = 0
            nonReschedulableImgHeight.constant = 0
            nonReschedulableImgBottom.constant = 0
            messageBottom.constant = 0
            nonRefundableLabel.text = ""
            nonReschedulableLabel.text = ""
            messageLabel.text = ""
        }else{
            nonRefundableImgTop.constant = 16
            nonRefundableImgHeight.constant = 20
            nonRefundableImgBottom.constant = 16
            nonReschedulableImgHeight.constant = 20
            nonReschedulableImgBottom.constant = 26
            messageBottom.constant = 16
            nonRefundableLabel.text = "Non-refundable"
            nonReschedulableLabel.text = "Non-reschedulable"
            messageLabel.text = "*Cancellation Information is currently not available online. This itinerary may be non-reschedulable"
        }
    }
    
}

extension IntCombineFareInfoCell:UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return getNumberOfRowWithoutApi(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        return self.getCellWithoutApi(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    //
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        if section == 1{
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55))
            footerView.backgroundColor = .white
            
            let innerView = UIView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height:45))
            innerView.backgroundColor = UIColor(displayP3Red: (246.0/255.0), green: (246.0/255.0), blue: (246.0/255.0), alpha: 1.0)
            footerView.addSubview(innerView)
            
            
//            let seperatorView = UIView(frame:CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 0.6))
//            seperatorView.backgroundColor = UIColor(displayP3Red: (204.0/255.0), green: (204.0/255.0), blue: (204.0/255.0), alpha: 1.0)
            
            let seperatorView = ATDividerView()
            seperatorView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 0.5)            
            footerView.addSubview(seperatorView)
            
            return (getNumberOfRowWithoutApi(section) != 0) ? footerView : nil
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if section == 1{
            
            return (getNumberOfRowWithoutApi(section) != 0) ? 55 : CGFloat.leastNonzeroMagnitude
        }else{
            return CGFloat.leastNonzeroMagnitude
        }
    }
    //
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
                tableView.layoutIfNeeded()
                tableView.layoutSubviews()
                tableView.setNeedsDisplay()
    }
    
    func minutesToHoursMinutes (seconds : Int) -> (Int) {
        return (seconds / 3600)
    }
    
    //MARK:- Format Price
//    func getPrice(price:Double) -> String{
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.maximumFractionDigits = 2
//        formatter.locale = Locale(identifier: "en_IN")
//        if var result = formatter.string(from: NSNumber(value: price)){
//            if result.contains(find: ".00"){
//                result = result.replacingOccurrences(of: ".00", with: "", options: .caseInsensitive, range: Range(NSRange(location:result.count-3,length:3), in: result) )
//            }
//            return result
//        }else{
//            return "\(price)"
//        }
//
//
//    }
    
    
    func getPrice(price:Double) -> NSMutableAttributedString{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_IN")
        if let result = formatter.string(from: NSNumber(value: price)){
//            let fontSize = 16
//            let fontSizeSuper = 12
//
//            let displayFont = AppFonts.SemiBold.rawValue
//            let displayFontSuper = AppFonts.SemiBold.rawValue
            
//            let font:UIFont? = UIFont(name: displayFont, size:CGFloat(fontSize))
//            let fontSuper:UIFont? = UIFont(name: displayFontSuper, size:CGFloat(fontSizeSuper))

            
            let font:UIFont = AppFonts.SemiBold.withSize(16)
            let fontSuper:UIFont = AppFonts.SemiBold.withSize(12)
            let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font])
            attString.setAttributes([.font:fontSuper,.baselineOffset:6], range: NSRange(location:result.count-3,length:3))
            if attString.string.contains(find: ".00"){
                attString.mutableString.replaceOccurrences(of: ".00", with: "", options: .caseInsensitive, range: NSRange(location:result.count-3,length:3))
            }
            return attString
        }else{
            return NSMutableAttributedString(string: "\(price)")
        }
        
       
    }
}


extension IntCombineFareInfoCell{
    
    
    func getNumberOfRowWithoutApi(_ section:Int)-> Int{
        
        if section == 0{
            if intAirlineCancellationFees.count > 0{
                if let airlineCancellationSlabCount = intAirlineCancellationFees["ADT"]?.feeDetail.map({$0.1})[indexOfCell].count
                {
                    return airlineCancellationSlabCount
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }else{
            if intAirlineReschedulingFees.count > 0{
                if let airlineReschedulingSlabCount = intAirlineReschedulingFees["ADT"]?.feeDetail.map({$0.1})[indexOfCell].count{
                    return airlineReschedulingSlabCount
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }
    }
    
    
    func getCellWithoutApi(_ indexPath:IndexPath)->UITableViewCell{
        guard let slabCell = combineFareTableView.dequeueReusableCell(withIdentifier: "PerSlabFareInfoCell") as? PerSlabFareInfoTableViewCell else {return UITableViewCell()}
        
        if indexPath.section == 0 && indexPath.row == 0{
            slabCell.topSeperatorLabelTop.constant = 0
            slabCell.topSeperatorLabelBottom.constant = 10
            slabCell.topSeperatorLabel.isHidden = false
            slabCell.titleLabel.text = "Cancellation"
            slabCell.titleView.isHidden = false
            slabCell.titleViewHeight.constant = 40
        }else if indexPath.section == 1 && indexPath.row == 0{
            slabCell.topSeperatorLabelTop.constant = 12
            slabCell.topSeperatorLabelBottom.constant = 8
            slabCell.topSeperatorLabel.isHidden = false
            slabCell.titleLabel.text = "Rescheduling"
            slabCell.titleView.isHidden = false
            slabCell.titleViewHeight.constant = 40
        }else{
            slabCell.topSeperatorLabelBottom.constant = 0
            slabCell.topSeperatorLabelTop.constant = 0
            slabCell.topSeperatorLabel.isHidden = true
            slabCell.titleLabel.text = ""
            slabCell.titleView.isHidden = true
            slabCell.titleViewHeight.constant = 0
        }
        
        if indexPath.section == 0
        {
            let key = journey.first?.legsWithDetail[indexOfCell].lfk ?? ""
                
            var adtStatement : [IntFeeDetails]? = [IntFeeDetails]()
            if isFromPassangerDetails{
                adtStatement = intAirlineCancellationFees["ADT"]?.feeDetail[key]
            }else{
                adtStatement = intAirlineCancellationFees["ADT"]?.feeDetail.map({$0.1})[indexOfCell]
            }
            
            if let adtAirlineCancellationSlab = adtStatement//intAirlineCancellationFees["ADT"]?.feeDetail[key]
//            if let adtAirlineCancellationSlab = intAirlineCancellationFees["ADT"]?.feeDetail.map({$0.1})[indexOfCell]
            {
                
                var adtAertripCancellationSlab:[IntFeeDetails]? = []
                if let adtArtFee = intAertripCancellationFees["ADT"]?.feeDetail[key]{
                    adtAertripCancellationSlab = adtArtFee
                }else{
                    adtAertripCancellationSlab = intAertripCancellationFees["ADT"]?.feeDetail.values.first
                }
                
//                let adtAertripCancellationSlab = intAertripCancellationFees["ADT"]?.feeDetail.values.first
                
                var aertripValue: Double = 0
                
                if indexPath.row < (adtAertripCancellationSlab?.count ?? 0){
                    aertripValue = adtAertripCancellationSlab?[indexPath.row].value ?? 0
                }else if let firstValue  =  adtAertripCancellationSlab?.first, ((adtAertripCancellationSlab?.count ?? 0) == 1){
                    aertripValue = firstValue.value
                }
                
                if indexPath.row < adtAirlineCancellationSlab.count{
                    let airlineValue = adtAirlineCancellationSlab[indexPath.row].value
                    
                    let sla = adtAirlineCancellationSlab[indexPath.row].sla
                    let slab = adtAirlineCancellationSlab[indexPath.row].slab
                    
                    let slaInHours = minutesToHoursMinutes(seconds: sla)
                    
                    let totalSlab = slaInHours + slab
                    let strTotalSlab = String(totalSlab).replacingOccurrences(of: "-", with: "")
                    
                    if indexPath.row > 0{
                        let prevSla = adtAirlineCancellationSlab[indexPath.row-1].sla
                        let prevSlab = adtAirlineCancellationSlab[indexPath.row-1].slab
                        
                        let prevSlaInHours = minutesToHoursMinutes(seconds: prevSla)
                        let prevTotalSlab = prevSlab + prevSlaInHours
                        
                        let strPrevTotalSlab = String(prevTotalSlab).replacingOccurrences(of: "-", with: "")
                        
                        if prevTotalSlab == 0 && totalSlab == 0{
                            slabCell.slabTimeLabel.text = "\(strTotalSlab) hour"
                        }else{
                            slabCell.slabTimeLabel.text = "\(strTotalSlab) - \(strPrevTotalSlab) hours"
                        }
                    }else{
                        if strTotalSlab == "0"{
                            slabCell.slabTimeLabel.text = "\(strTotalSlab) hour"
                        }else if strTotalSlab == "1"{
                            slabCell.slabTimeLabel.text = "\(strTotalSlab) hour or earlier"
                        }else{
                            slabCell.slabTimeLabel.text = "\(strTotalSlab) hours or earlier"
                        }
                    }
                    
                    
                    if flightAdultCount > 0 && flightChildrenCount == 0 && flightInfantCount == 0{
                        slabCell.statusLabel.isHidden = false
                        if airlineValue == -9{
                            slabCell.statusLabel.textColor = .black
                            slabCell.statusLabel.text = "NA"
                        }else if airlineValue == -1{
                            slabCell.statusLabel.textColor = .black
                            slabCell.statusLabel.text = "Non-refundable"
                        }else if airlineValue == 0 && aertripValue == 0{
                            slabCell.statusLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                            slabCell.statusLabel.text = "Free Cancellation"
                        }else{
                            slabCell.statusLabel.textColor = .black
                            
                            var adtRafVal: Double =  0
                            if let fee = rafFees["ADT"] as? Double{
                                adtRafVal = fee
                            }else{
                                adtRafVal = (rafFees["ADT"] as? [String:Double])?.values.first ?? 0
                            }
                            ///RAF will only be considered when Airline fee is > 0, RAF is independent of Aertrip Fee
                            if !(airlineValue > 0){
                                adtRafVal = 0
                            }
                            
                            if aertripValue > 0{
                                let displayValue = getPrice(price: Double(airlineValue + adtRafVal + aertripValue))
                                slabCell.statusLabel.attributedText = displayValue
                            }else{
                                let displayValue = getPrice(price: Double(airlineValue + adtRafVal))

                                displayValue.append(NSAttributedString(string: " + "))
                                displayValue.append(getPrice(price: Double(aertripValue)))
                                slabCell.statusLabel.attributedText = displayValue
                            }
                        }
                    }else{
                        if airlineValue == -9{
                            slabCell.perAdultAmountLabel.textColor = .black
                            slabCell.perAdultAmountLabel.text = "NA"
                        }else if airlineValue == -1{
                            slabCell.perAdultAmountLabel.textColor = .black
                            slabCell.perAdultAmountLabel.text = "Non-refundable"
                        }else if airlineValue == 0 && aertripValue == 0{
                            slabCell.perAdultAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                            slabCell.perAdultAmountLabel.text = "Free Cancellation"
                        }else{
                            slabCell.perAdultAmountLabel.textColor = .black
                            var adtRafVal: Double =  0
                            if let fee = rafFees["ADT"] as? Double{
                                adtRafVal = fee
                            }else{
                                adtRafVal = (rafFees["ADT"] as? [String:Double])?.values.first ?? 0
                            }
                            
                            ///RAF will only be considered when Airline fee is > 0, RAF is independent of Aertrip Fee
                            if !(airlineValue > 0){
                                adtRafVal = 0
                            }

                            if aertripValue > 0{
                                let displayValue = getPrice(price: Double(airlineValue + adtRafVal + aertripValue))
                                slabCell.perAdultAmountLabel.attributedText = displayValue
                            }else{
                                let displayValue = getPrice(price: Double(airlineValue + adtRafVal))
                                displayValue.append(NSAttributedString(string: " + "))
                                displayValue.append(getPrice(price: Double(aertripValue)))
                                slabCell.perAdultAmountLabel.attributedText = displayValue
                            }
                        }
                    }
                }else{
                    slabCell.perAdultAmountLabel.text = "NA"
                }
            }
            
            
            var chdStatement : [IntMultiCityAndReturnWSResponse.Results.J.Fare.SubFares.Details.Fee.FeeDetail]? = [IntMultiCityAndReturnWSResponse.Results.J.Fare.SubFares.Details.Fee.FeeDetail]()
            if isFromPassangerDetails{
                chdStatement = intAirlineCancellationFees["CHD"]?.feeDetail[key]
            }else{
                chdStatement = intAirlineCancellationFees["CHD"]?.feeDetail.map({$0.1})[indexOfCell]
            }
            
            if let chdAirlineCancellationSlab = chdStatement //intAirlineCancellationFees["CHD"]?.feeDetail.map({$0.1})[indexOfCell]
            {
                
                var chdAertripCancellationSlab:[IntFeeDetails]? = []
                if let adtArtFee = intAertripCancellationFees["CHD"]?.feeDetail[key]{
                    chdAertripCancellationSlab = adtArtFee
                }else{
                    chdAertripCancellationSlab = intAertripCancellationFees["CHD"]?.feeDetail.values.first
                }
                
//                let chdAertripCancellationSlab = intAertripCancellationFees["CHD"]?.feeDetail.values.first
                
                var aertripValue: Double = 0
                
                if indexPath.row < (chdAertripCancellationSlab?.count ?? 0){
                    aertripValue = chdAertripCancellationSlab?[indexPath.row].value ?? 0
                }else if let firstValue  =  chdAertripCancellationSlab?.first, ((chdAertripCancellationSlab?.count ?? 0) == 1){
                    aertripValue = firstValue.value
                }
                
                if indexPath.row < chdAirlineCancellationSlab.count{
                    let value = chdAirlineCancellationSlab[indexPath.row].value
                    
                    if value == -9{
                        slabCell.perChildAmountLabel.textColor = .black
                        slabCell.perChildAmountLabel.text = "NA"
                    }else if value == -1{
                        slabCell.perChildAmountLabel.textColor = .black
                        slabCell.perChildAmountLabel.text = "Non-refundable"
                    }else if value == 0 && aertripValue == 0{
                        slabCell.perChildAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        slabCell.perChildAmountLabel.text = "Free Cancellation"
                    }else{
                        slabCell.perChildAmountLabel.textColor = .black
                        var chdRafVal: Double =  0
                        if let fee = rafFees["CHD"] as? Double{
                            chdRafVal = fee
                        }else{
                            chdRafVal = (rafFees["CHD"] as? [String:Double])?.values.first ?? 0
                        }
                        
                        ///RAF will only be considered when Airline fee is > 0, RAF is independent of Aertrip Fee
                        if !(chdRafVal > 0){
                            chdRafVal = 0
                        }

                        if aertripValue > 0 {
                            let displayValue = getPrice(price: Double(value + chdRafVal + aertripValue))
                            slabCell.perChildAmountLabel.attributedText = displayValue
                        }else{
                            let displayValue = getPrice(price: Double(value + chdRafVal))
                            displayValue.append(NSAttributedString(string: " + "))
                            displayValue.append(getPrice(price: Double(aertripValue)))
                            slabCell.perChildAmountLabel.attributedText = displayValue
                        }
                    }
                }else{
                    slabCell.perChildAmountLabel.text = "NA"
                }
            }
            
            
            var infStatement : [IntMultiCityAndReturnWSResponse.Results.J.Fare.SubFares.Details.Fee.FeeDetail]? = [IntMultiCityAndReturnWSResponse.Results.J.Fare.SubFares.Details.Fee.FeeDetail]()
            if isFromPassangerDetails{
                infStatement = intAirlineCancellationFees["INF"]?.feeDetail[key]
            }else{
                infStatement = intAirlineCancellationFees["INF"]?.feeDetail.map({$0.1})[indexOfCell]
            }
            
            if let infAirlineCancellationSlab = infStatement//intAirlineCancellationFees["INF"]?.feeDetail.map({$0.1})[indexOfCell]
            {
                
                var infAertripCancellationSlab:[IntFeeDetails]? = []
                if let adtArtFee = intAertripCancellationFees["INF"]?.feeDetail[key]{
                    infAertripCancellationSlab = adtArtFee
                }else{
                    infAertripCancellationSlab = intAertripCancellationFees["INF"]?.feeDetail.values.first
                }
                
//                let infAertripCancellationSlab = intAertripCancellationFees["INF"]?.feeDetail.values.first
                
                var aertripValue: Double = 0
                
                if indexPath.row < (infAertripCancellationSlab?.count ?? 0){
                    aertripValue = infAertripCancellationSlab?[indexPath.row].value ?? 0
                }else if let firstValue  =  infAertripCancellationSlab?.first, ((infAertripCancellationSlab?.count ?? 0) == 1){
                    aertripValue = firstValue.value
                }
                
                if indexPath.row < infAirlineCancellationSlab.count{
                    let value = infAirlineCancellationSlab[indexPath.row].value
                    
                    if value == -9{
                        slabCell.perInfantAmountLabel.textColor = .black
                        slabCell.perInfantAmountLabel.text = "NA"
                    }else if value == -1{
                        slabCell.perInfantAmountLabel.textColor = .black
                        slabCell.perInfantAmountLabel.text = "Non-refundable"
                    }else if value == 0 && aertripValue == 0{
                        slabCell.perInfantAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        slabCell.perInfantAmountLabel.text = "Free Cancellation"
                    }else{
                        slabCell.perInfantAmountLabel.textColor = .black
                        var iNFRafVal: Double =  0
                        if let fee = rafFees["INF"] as? Double{
                            iNFRafVal = fee
                        }else{
                            iNFRafVal = (rafFees["INF"] as? [String:Double])?.values.first ?? 0
                        }
                        ///RAF will only be considered when Airline fee is > 0, RAF is independent of Aertrip Fee
                        if !(iNFRafVal > 0){
                            iNFRafVal = 0
                        }
                        
                        if aertripValue > 0{
                            let displayValue = getPrice(price: Double(value + iNFRafVal + aertripValue))
                            slabCell.perInfantAmountLabel.attributedText = displayValue
                        }else{
                            let displayValue = getPrice(price: Double(value + iNFRafVal))
                            displayValue.append(NSAttributedString(string: " + "))
                            displayValue.append(getPrice(price: Double(aertripValue)))
                            slabCell.perInfantAmountLabel.attributedText = displayValue
                        }
                    }
                }else{
                    slabCell.perInfantAmountLabel.text = "NA"
                }
            }
        }else{
            let key = journey.first?.legsWithDetail[indexOfCell].lfk ?? ""

            var adtStatement : [IntMultiCityAndReturnWSResponse.Results.J.Fare.SubFares.Details.Fee.FeeDetail]? = [IntMultiCityAndReturnWSResponse.Results.J.Fare.SubFares.Details.Fee.FeeDetail]()
            if isFromPassangerDetails{
                adtStatement = intAirlineReschedulingFees["ADT"]?.feeDetail[key]
            }else{
                adtStatement = intAirlineReschedulingFees["ADT"]?.feeDetail.map({$0.1})[indexOfCell]
            }
            
            if let adtAirlineReschedulingSlab = adtStatement
            //intAirlineReschedulingFees["ADT"]?.feeDetail[key]
//            if let adtAirlineReschedulingSlab = intAirlineReschedulingFees["ADT"]?.feeDetail.map({$0.1})[indexOfCell]
            {
                
                var adtAertripReschedulingSlab:[IntFeeDetails]? = []
                if let adtArtFee = intAertripReschedulingFees["ADT"]?.feeDetail[key]{
                    adtAertripReschedulingSlab = adtArtFee
                }else{
                    adtAertripReschedulingSlab = intAertripReschedulingFees["ADT"]?.feeDetail.values.first
                }
                
                
//                let adtAertripReschedulingSlab = intAertripReschedulingFees["ADT"]?.feeDetail.values.first
                
                var aertripValue: Double = 0
                
                if indexPath.row < (adtAertripReschedulingSlab?.count ?? 0){
                    aertripValue = adtAertripReschedulingSlab?[indexPath.row].value ?? 0
                }else if let firstValue  =  adtAertripReschedulingSlab?.first, ((adtAertripReschedulingSlab?.count ?? 0) == 1){
                    aertripValue = firstValue.value
                }
                
                if indexPath.row < adtAirlineReschedulingSlab.count{
                    let sla = adtAirlineReschedulingSlab[indexPath.row].sla
                    let slab = adtAirlineReschedulingSlab[indexPath.row].slab
                    
                    let slaInHours = minutesToHoursMinutes(seconds: sla)
                    
                    let totalSlab = slab + slaInHours
                    
                    let strTotalSlab = String(totalSlab).replacingOccurrences(of: "-", with: "")
                    
                    if indexPath.row > 0{
                        let prevSla = adtAirlineReschedulingSlab[indexPath.row-1].sla
                        let prevSlab = adtAirlineReschedulingSlab[indexPath.row-1].slab
                        
                        let prevSlaInHours = minutesToHoursMinutes(seconds: prevSla)
                        let prevTotalSlab = prevSlaInHours + prevSlab
                        
                        let strPrevTotalSlab = String(prevTotalSlab).replacingOccurrences(of: "-", with: "")
                        
                        if prevTotalSlab == 0 && totalSlab == 0{
                            slabCell.slabTimeLabel.text = "\(strTotalSlab) hour"
                        }else{
                            slabCell.slabTimeLabel.text = "\(strTotalSlab) - \(strPrevTotalSlab) hours"
                        }
                    }else{
                        if strTotalSlab == "0"{
                            slabCell.slabTimeLabel.text = "\(strTotalSlab) hour"
                        }else if strTotalSlab == "1"{
                            slabCell.slabTimeLabel.text = "\(strTotalSlab) hour or earlier"
                        }else{
                            slabCell.slabTimeLabel.text = "\(strTotalSlab) hours or earlier"
                        }
                    }
                    
                    
                    let value = adtAirlineReschedulingSlab[indexPath.row].value
                    
                    if flightAdultCount > 0 && flightChildrenCount == 0 && flightInfantCount == 0{
                        slabCell.statusLabel.isHidden = false
                        if value == -9{
                            slabCell.statusLabel.textColor = .black
                            slabCell.statusLabel.text = "NA"
                        }else if value == -1{
                            slabCell.statusLabel.textColor = .black
                            slabCell.statusLabel.text = "Not Permitted"
                        }else if value == 0 && aertripValue == 0{
                            slabCell.statusLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                            slabCell.statusLabel.text = "Free Rescheduling"
                        }else{
                            slabCell.statusLabel.textColor = .black
                            
                            if aertripValue > 0{
                                let displayValue = getPrice(price: Double(value + aertripValue))
                                slabCell.statusLabel.attributedText = displayValue
                            }else{
                                let displayValue = getPrice(price: Double(value))
                                displayValue.append(NSAttributedString(string: " + "))
                                displayValue.append(getPrice(price: Double(aertripValue)))

                                slabCell.statusLabel.attributedText = displayValue
                            }

                        }
                    }else{
                        if value == -9{
                            slabCell.perAdultAmountLabel.textColor = .black
                            slabCell.perAdultAmountLabel.text = "NA"
                        }else if value == -1{
                            slabCell.perAdultAmountLabel.textColor = .black
                            slabCell.perAdultAmountLabel.text = "Not Permitted"
                        }else if value == 0 && aertripValue == 0{
                            slabCell.perAdultAmountLabel.textColor =  UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                            slabCell.perAdultAmountLabel.text = "Free Rescheduling"
                        }else{
                            slabCell.perAdultAmountLabel.textColor = .black
                            

                            if aertripValue > 0{
                                let displayValue = getPrice(price: Double(value + aertripValue))
                                slabCell.perAdultAmountLabel.attributedText = displayValue
                            }else{
                                let displayValue = getPrice(price: Double(value))
                                displayValue.append(NSAttributedString(string: " + "))
                                displayValue.append(getPrice(price: Double(aertripValue)))
                                slabCell.perAdultAmountLabel.attributedText = displayValue
                            }
                        }
                    }
                }else{
                    slabCell.perAdultAmountLabel.text = "NA"
                }
            }
            
            var chdStatement : [IntMultiCityAndReturnWSResponse.Results.J.Fare.SubFares.Details.Fee.FeeDetail]? = [IntMultiCityAndReturnWSResponse.Results.J.Fare.SubFares.Details.Fee.FeeDetail]()
            if isFromPassangerDetails{
                chdStatement = intAirlineReschedulingFees["CHD"]?.feeDetail[key]
            }else{
                chdStatement = intAirlineReschedulingFees["CHD"]?.feeDetail.map({$0.1})[indexOfCell]
            }
            
            if let chdAirlineReschedulingSlab = chdStatement //intAirlineReschedulingFees["CHD"]?.feeDetail.map({$0.1})[indexOfCell]
            {
                
                var chdAertripReschedulingSlab:[IntFeeDetails]? = []
                if let adtArtFee = intAertripReschedulingFees["CHD"]?.feeDetail[key]{
                    chdAertripReschedulingSlab = adtArtFee
                }else{
                    chdAertripReschedulingSlab = intAertripReschedulingFees["CHD"]?.feeDetail.values.first
                }
                
//                let chdAertripReschedulingSlab = intAertripReschedulingFees["CHD"]?.feeDetail.values.first
                
                var aertripValue: Double = 0
                
                if indexPath.row < (chdAertripReschedulingSlab?.count ?? 0){
                    aertripValue = chdAertripReschedulingSlab?[indexPath.row].value ?? 0
                }else if let firstValue  =  chdAertripReschedulingSlab?.first, ((chdAertripReschedulingSlab?.count ?? 0) == 1){
                    aertripValue = firstValue.value
                }
                
                if indexPath.row < chdAirlineReschedulingSlab.count{
                    let value = chdAirlineReschedulingSlab[indexPath.row].value
                    
                    if value == -9{
                        slabCell.perChildAmountLabel.textColor = .black
                        slabCell.perChildAmountLabel.text = "NA"
                    }else if value == -1{
                        slabCell.perChildAmountLabel.textColor = .black
                        slabCell.perChildAmountLabel.text = "Not Permitted"
                    }else if value == 0 && aertripValue == 0{
                        slabCell.perChildAmountLabel.textColor =  UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        slabCell.perChildAmountLabel.text = "Free Rescheduling"
                    }else{
                        slabCell.perChildAmountLabel.textColor = .black

                        if aertripValue > 0 {
                            let displayValue = getPrice(price: Double(value + aertripValue))
                            slabCell.perChildAmountLabel.attributedText = displayValue
                        }else{
                            let displayValue = getPrice(price: Double(value))
                            displayValue.append(NSAttributedString(string: " + "))
                            displayValue.append(getPrice(price: Double(aertripValue)))
                            slabCell.perChildAmountLabel.attributedText = displayValue
                        }
                    }
                }else{
                    slabCell.perChildAmountLabel.text = "NA"
                }
            }
            
            
            var infStatement : [IntMultiCityAndReturnWSResponse.Results.J.Fare.SubFares.Details.Fee.FeeDetail]? = [IntMultiCityAndReturnWSResponse.Results.J.Fare.SubFares.Details.Fee.FeeDetail]()
            if isFromPassangerDetails{
                infStatement = intAirlineReschedulingFees["INF"]?.feeDetail[key]
            }else{
                infStatement = intAirlineReschedulingFees["INF"]?.feeDetail.map({$0.1})[indexOfCell]
            }
            
            if let infAirlineReschedulingSlab = infStatement//intAirlineReschedulingFees["INF"]?.feeDetail.map({$0.1})[indexOfCell]
            {
                var infAertripReschedulingSlab:[IntFeeDetails]? = []
                if let adtArtFee = intAertripReschedulingFees["INF"]?.feeDetail[key]{
                    infAertripReschedulingSlab = adtArtFee
                }else{
                    infAertripReschedulingSlab = intAertripReschedulingFees["INF"]?.feeDetail.values.first
                }
                
//                let infAertripReschedulingSlab = intAertripReschedulingFees["INF"]?.feeDetail.values.first
                
                var aertripValue: Double = 0
                
                if indexPath.row < (infAertripReschedulingSlab?.count ?? 0){
                    aertripValue = infAertripReschedulingSlab?[indexPath.row].value ?? 0
                    
                }else if let firstValue  =  infAertripReschedulingSlab?.first, ((infAertripReschedulingSlab?.count ?? 0) == 1){
                    aertripValue = firstValue.value
                }
                
                if indexPath.row < infAirlineReschedulingSlab.count{
                    let value = infAirlineReschedulingSlab[indexPath.row].value
                    
                    if value == -9{
                        slabCell.perInfantAmountLabel.textColor = .black
                        slabCell.perInfantAmountLabel.text = "NA"
                    }else if value == -1{
                        slabCell.perInfantAmountLabel.textColor = .black
                        slabCell.perInfantAmountLabel.text = "Not Permitted"
                    }else if value == 0 && aertripValue == 0{
                        slabCell.perInfantAmountLabel.textColor =  UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        slabCell.perInfantAmountLabel.text = "Free Rescheduling"
                    }else{
                        slabCell.perInfantAmountLabel.textColor = .black
                        
                        if aertripValue > 0{
                            let displayValue = getPrice(price: Double(value + aertripValue))
                            slabCell.perInfantAmountLabel.attributedText = displayValue
                        }else{
                            let displayValue = getPrice(price: Double(value))
                            displayValue.append(NSAttributedString(string: " + "))
                            displayValue.append(getPrice(price: Double(aertripValue)))
                            slabCell.perInfantAmountLabel.attributedText = displayValue
                        }
                    }
                }else{
                    slabCell.perInfantAmountLabel.text = "NA"
                }
            }
        }
        
        if flightAdultCount > 0 && flightChildrenCount > 0 && flightInfantCount > 0{
            if slabCell.perAdultAmountLabel.text == slabCell.perChildAmountLabel.text && slabCell.perAdultAmountLabel.text == slabCell.perInfantAmountLabel.text{
                slabCell.slabDataDisplayViewHeight.constant = 40
                slabCell.perAdultDataDisplayViewHeight.constant = 0
                slabCell.perAdultDataDisplayView.isHidden = true
                
                slabCell.perChildDataDisplayViewHeight.constant = 0
                slabCell.perChildDataDisplayView.isHidden = true
                
                slabCell.perInfantDataDisplayViewHeight.constant = 0
                slabCell.perInfantDataDisplayView.isHidden = true
                
                slabCell.statusLabel.isHidden = false
                slabCell.statusLabel.textColor = .black
                slabCell.statusLabel.text = slabCell.perAdultAmountLabel.text
            }else{
                slabCell.slabDataDisplayViewHeight.constant = 140
                slabCell.perAdultDataDisplayViewHeight.constant = 31
                slabCell.perAdultDataDisplayView.isHidden = false
                
                slabCell.perChildDataDisplayViewHeight.constant = 31
                slabCell.perChildDataDisplayView.isHidden = false
                
                slabCell.perInfantDataDisplayViewHeight.constant = 30
                slabCell.perInfantDataDisplayView.isHidden = false
            }
        }else if flightAdultCount > 0 && flightChildrenCount > 0{
            slabCell.slabDataDisplayViewHeight.constant = 96
            slabCell.perAdultDataDisplayViewHeight.constant = 31
            slabCell.perAdultDataDisplayView.isHidden = false
            
            slabCell.perChildDataDisplayViewHeight.constant = 31
            slabCell.perChildDataDisplayView.isHidden = false
            
            slabCell.perInfantDataDisplayViewHeight.constant = 0
            slabCell.perInfantDataDisplayView.isHidden = true
        }else if flightAdultCount > 0 && flightInfantCount > 0{
            slabCell.slabDataDisplayViewHeight.constant = 96
            slabCell.perAdultDataDisplayViewHeight.constant = 31
            slabCell.perAdultDataDisplayView.isHidden = false
            
            slabCell.perChildDataDisplayViewHeight.constant = 0
            slabCell.perChildDataDisplayView.isHidden = true
            
            slabCell.perInfantDataDisplayViewHeight.constant = 31
            slabCell.perInfantDataDisplayView.isHidden = false
        }else if slabCell.perAdultAmountLabel.text == "Non-refundable" &&
            slabCell.perChildAmountLabel.text == "Non-refundable" &&
            slabCell.perInfantAmountLabel.text == "Non-refundable" ||
            slabCell.perAdultAmountLabel.text == "Free Cancellation" &&
            slabCell.perChildAmountLabel.text == "Free Cancellation" &&
            slabCell.perInfantAmountLabel.text == "Free Cancellation" ||
            slabCell.perAdultAmountLabel.text == "Not Permitted" &&
            slabCell.perChildAmountLabel.text == "Not Permitted" &&
            slabCell.perInfantAmountLabel.text == "Not Permitted" ||
            slabCell.perAdultAmountLabel.text == "Free Rescheduling" &&
            slabCell.perChildAmountLabel.text == "Free Rescheduling" &&
            slabCell.perInfantAmountLabel.text == "Free Rescheduling"
        {
            slabCell.slabDataDisplayViewHeight.constant = 0
            slabCell.perAdultDataDisplayViewHeight.constant = 0
            slabCell.perAdultDataDisplayView.isHidden = true
            
            slabCell.perChildDataDisplayViewHeight.constant = 0
            slabCell.perChildDataDisplayView.isHidden = true
            
            slabCell.perInfantDataDisplayViewHeight.constant = 0
            slabCell.perInfantDataDisplayView.isHidden = true
            
            if slabCell.perAdultAmountLabel.text == "Non-refundable"{
                slabCell.statusLabel.textColor = .black
                slabCell.statusLabel.text = "Non-refundable"
            }else if slabCell.perAdultAmountLabel.text == "Not Permitted"{
                slabCell.statusLabel.textColor = .black
                slabCell.statusLabel.text = "Not Permitted"
            }else if slabCell.perAdultAmountLabel.text == "Free Cancellation"{
                slabCell.statusLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                slabCell.statusLabel.text = "Free Cancellation"
            }else if slabCell.perAdultAmountLabel.text == "Free Rescheduling"{
                slabCell.statusLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                slabCell.statusLabel.text = "Free Rescheduling"
            }else{
                slabCell.statusLabel.text = ""
            }
        }else if flightAdultCount > 0 && flightChildrenCount == 0 && flightInfantCount == 0{
            slabCell.slabDataDisplayViewHeight.constant = 33
            slabCell.perAdultDataDisplayViewHeight.constant = 0
            slabCell.perAdultDataDisplayView.isHidden = true
            
            slabCell.perChildDataDisplayViewHeight.constant = 0
            slabCell.perChildDataDisplayView.isHidden = true
            
            slabCell.perInfantDataDisplayViewHeight.constant = 0
            slabCell.perInfantDataDisplayView.isHidden = true
        }else{
            slabCell.slabDataDisplayViewHeight.constant = 0
            slabCell.perAdultDataDisplayViewHeight.constant = 0
            slabCell.perAdultDataDisplayView.isHidden = true
            
            slabCell.perChildDataDisplayViewHeight.constant = 0
            slabCell.perChildDataDisplayView.isHidden = true
            
            slabCell.perInfantDataDisplayViewHeight.constant = 0
            slabCell.perInfantDataDisplayView.isHidden = true
        }
        
        self.combineFareTableView.layoutIfNeeded()
        return slabCell
    }
    
    
}
