//
//  IntCombineFareInfoCell.swift
//  Aertrip
//
//  Created by Apple  on 11.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class IntCombineFareInfoCell: UITableViewCell {
    @IBOutlet weak var combineFareTableView: UITableView!
    @IBOutlet weak var noInfoView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var intAirlineCancellationFees = [String:IntTaxes.SubFares.Details.Fee]()
    var intAertripCancellationFees = [String:IntTaxes.SubFares.Details.Fee]()
    var intAirlineReschedulingFees = [String:IntTaxes.SubFares.Details.Fee]()
    var intAertripReschedulingFees = [String:IntTaxes.SubFares.Details.Fee]()
    
    
    var rafFees = [String:Int]()
    var journey: [IntJourney]!
    var legsCount  = 0
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    var withApi = false
    var count = 0
    var isNoInfoViewVisible = false
    var indexOfCell = 0
    
    weak var cellHeightDelegate:cellHeightDelegate?
    
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
            
            
            let seperatorView = UIView(frame:CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 0.6))
            seperatorView.backgroundColor = UIColor(displayP3Red: (204.0/255.0), green: (204.0/255.0), blue: (204.0/255.0), alpha: 1.0)
            footerView.addSubview(seperatorView)
            
            return footerView
        }else{
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if section == 1{
            return 55
        }else{
            return 0
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
    func getPrice(price:Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_IN")
        if var result = formatter.string(from: NSNumber(value: price)){
            if result.contains(find: ".00"){
                result = result.replacingOccurrences(of: ".00", with: "", options: .caseInsensitive, range: Range(NSRange(location:result.count-3,length:3), in: result) )
            }
            return result
        }else{
            return "\(price)"
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
            slabCell.titleLabel.text = "Cancellation Fee"
            slabCell.titleView.isHidden = false
            slabCell.titleViewHeight.constant = 40
        }else if indexPath.section == 1 && indexPath.row == 0{
            slabCell.topSeperatorLabelTop.constant = 12
            slabCell.topSeperatorLabelBottom.constant = 8
            slabCell.topSeperatorLabel.isHidden = false
            slabCell.titleLabel.text = "Rescheduling Fee"
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
        
        if indexPath.section == 0{
            if let adtAirlineCancellationSlab = intAirlineCancellationFees["ADT"]?.feeDetail.map({$0.1})[indexOfCell]
            {
                let adtAertripCancellationSlab = intAertripCancellationFees["ADT"]?.feeDetail.values.first
                
                var aertripValue = 0
                
                if indexPath.row < (adtAertripCancellationSlab?.count ?? 0){
                    aertripValue = adtAertripCancellationSlab?[indexPath.row].value ?? 0
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
                        }else if airlineValue == 0{
                            slabCell.statusLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                            slabCell.statusLabel.text = "Free Cancellation"
                        }else{
                            slabCell.statusLabel.textColor = .black
                            let adtRafVal = rafFees["ADT"] ?? 0
                            let displayValue = getPrice(price: Double(airlineValue + adtRafVal))

                            slabCell.statusLabel.text = displayValue + " + ₹ " + String(aertripValue)
                        }
                    }else{
                        if airlineValue == -9{
                            slabCell.perAdultAmountLabel.textColor = .black
                            slabCell.perAdultAmountLabel.text = "NA"
                        }else if airlineValue == -1{
                            slabCell.perAdultAmountLabel.textColor = .black
                            slabCell.perAdultAmountLabel.text = "Non-refundable"
                        }else if airlineValue == 0{
                            slabCell.perAdultAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                            slabCell.perAdultAmountLabel.text = "Free Cancellation"
                        }else{
                            slabCell.perAdultAmountLabel.textColor = .black
                            let adtRafVal = rafFees["ADT"] ?? 0
                            let displayValue = getPrice(price: Double(airlineValue + adtRafVal))
                            
                            slabCell.perAdultAmountLabel.text = displayValue + " + ₹ " + String(aertripValue)
                        }
                    }
                }else{
                    slabCell.perAdultAmountLabel.text = "NA"
                }
            }
            
            if let chdAirlineCancellationSlab = intAirlineCancellationFees["CHD"]?.feeDetail.map({$0.1})[indexOfCell]
            {
                let chdAertripCancellationSlab = intAertripCancellationFees["CHD"]?.feeDetail.values.first
                
                var aertripValue = 0
                
                if indexPath.row < (chdAertripCancellationSlab?.count ?? 0){
                    aertripValue = chdAertripCancellationSlab?[indexPath.row].value ?? 0
                }
                
                if indexPath.row < chdAirlineCancellationSlab.count{
                    let value = chdAirlineCancellationSlab[indexPath.row].value
                    
                    if value == -9{
                        slabCell.perChildAmountLabel.textColor = .black
                        slabCell.perChildAmountLabel.text = "NA"
                    }else if value == -1{
                        slabCell.perChildAmountLabel.textColor = .black
                        slabCell.perChildAmountLabel.text = "Non-refundable"
                    }else if value == 0{
                        slabCell.perChildAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        slabCell.perChildAmountLabel.text = "Free Cancellation"
                    }else{
                        slabCell.perChildAmountLabel.textColor = .black
                        let chdRafVal = rafFees["CHD"]
                        let displayValue = getPrice(price: Double(value + (chdRafVal ?? 0)))
                        
                        slabCell.perChildAmountLabel.text = displayValue + " + ₹ " +  String(aertripValue)
                    }
                }else{
                    slabCell.perChildAmountLabel.text = "NA"
                }
            }
            
            if let infAirlineCancellationSlab = intAirlineCancellationFees["INF"]?.feeDetail.map({$0.1})[indexOfCell]
            {
                let infAertripCancellationSlab = intAertripCancellationFees["INF"]?.feeDetail.values.first
                
                var aertripValue = 0
                
                if indexPath.row < (infAertripCancellationSlab?.count ?? 0){
                    aertripValue = infAertripCancellationSlab?[indexPath.row].value ?? 0
                }
                
                if indexPath.row < infAirlineCancellationSlab.count{
                    let value = infAirlineCancellationSlab[indexPath.row].value
                    
                    if value == -9{
                        slabCell.perInfantAmountLabel.textColor = .black
                        slabCell.perInfantAmountLabel.text = "NA"
                    }else if value == -1{
                        slabCell.perInfantAmountLabel.textColor = .black
                        slabCell.perInfantAmountLabel.text = "Non-refundable"
                    }else if value == 0{
                        slabCell.perInfantAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        slabCell.perInfantAmountLabel.text = "Free Cancellation"
                    }else{
                        slabCell.perInfantAmountLabel.textColor = .black
                        let chdRafVal = rafFees["INF"]
                        let displayValue = getPrice(price: Double(value + (chdRafVal ?? 0)))
                        slabCell.perInfantAmountLabel.text = displayValue + " + ₹ " +  String(aertripValue)
                    }
                }else{
                    slabCell.perInfantAmountLabel.text = "NA"
                }
            }
        }else{
            if let adtAirlineReschedulingSlab = intAirlineReschedulingFees["ADT"]?.feeDetail.map({$0.1})[indexOfCell]
            {
                let adtAertripReschedulingSlab = intAertripReschedulingFees["ADT"]?.feeDetail.values.first
                
                var aertripValue = 0
                
                if indexPath.row < (adtAertripReschedulingSlab?.count ?? 0){
                    aertripValue = adtAertripReschedulingSlab?[indexPath.row].value ?? 0
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
                        }else if value == 0{
                            slabCell.statusLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                            slabCell.statusLabel.text = "Free Rescheduling"
                        }else{
                            slabCell.statusLabel.textColor = .black
                            
                            let displayValue = getPrice(price: Double(value))
                            slabCell.statusLabel.text = displayValue + " + ₹ " +  String(aertripValue)
                        }
                    }else{
                        if value == -9{
                            slabCell.perAdultAmountLabel.textColor = .black
                            slabCell.perAdultAmountLabel.text = "NA"
                        }else if value == -1{
                            slabCell.perAdultAmountLabel.textColor = .black
                            slabCell.perAdultAmountLabel.text = "Not Permitted"
                        }else if value == 0{
                            slabCell.perAdultAmountLabel.textColor =  UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                            slabCell.perAdultAmountLabel.text = "Free Rescheduling"
                        }else{
                            slabCell.perAdultAmountLabel.textColor = .black
                            
                            let displayValue = getPrice(price: Double(value))
                            
                            slabCell.perAdultAmountLabel.text = displayValue + " + ₹ " +  String(aertripValue)
                        }
                    }
                }else{
                    slabCell.perAdultAmountLabel.text = "NA"
                }
            }
            
            if let chdAirlineReschedulingSlab = intAirlineReschedulingFees["CHD"]?.feeDetail.map({$0.1})[indexOfCell]
            {
                let chdAertripReschedulingSlab = intAertripReschedulingFees["CHD"]?.feeDetail.values.first
                
                var aertripValue = 0
                
                if indexPath.row < (chdAertripReschedulingSlab?.count ?? 0){
                    aertripValue = chdAertripReschedulingSlab?[indexPath.row].value ?? 0
                }
                
                if indexPath.row < chdAirlineReschedulingSlab.count{
                    let value = chdAirlineReschedulingSlab[indexPath.row].value
                    
                    if value == -9{
                        slabCell.perChildAmountLabel.textColor = .black
                        slabCell.perChildAmountLabel.text = "NA"
                    }else if value == -1{
                        slabCell.perChildAmountLabel.textColor = .black
                        slabCell.perChildAmountLabel.text = "Not Permitted"
                    }else if value == 0{
                        slabCell.perChildAmountLabel.textColor =  UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        slabCell.perChildAmountLabel.text = "Free Rescheduling"
                    }else{
                        slabCell.perChildAmountLabel.textColor = .black
                        
                        let displayValue = getPrice(price: Double(value))
                        
                        slabCell.perChildAmountLabel.text = displayValue + " + ₹ " +  String(aertripValue)
                    }
                }else{
                    slabCell.perChildAmountLabel.text = "NA"
                }
            }
            
            if let infAirlineReschedulingSlab = intAirlineReschedulingFees["INF"]?.feeDetail.map({$0.1})[indexOfCell]
            {
                let infAertripReschedulingSlab = intAertripReschedulingFees["INF"]?.feeDetail.values.first
                
                var aertripValue = 0
                
                if indexPath.row < (infAertripReschedulingSlab?.count ?? 0){
                    aertripValue = infAertripReschedulingSlab?[indexPath.row].value ?? 0
                    
                }
                if indexPath.row < infAirlineReschedulingSlab.count{
                    let value = infAirlineReschedulingSlab[indexPath.row].value
                    
                    if value == -9{
                        slabCell.perInfantAmountLabel.textColor = .black
                        slabCell.perInfantAmountLabel.text = "NA"
                    }else if value == -1{
                        slabCell.perInfantAmountLabel.textColor = .black
                        slabCell.perInfantAmountLabel.text = "Not Permitted"
                    }else if value == 0{
                        slabCell.perInfantAmountLabel.textColor =  UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        slabCell.perInfantAmountLabel.text = "Free Rescheduling"
                    }else{
                        slabCell.perInfantAmountLabel.textColor = .black
                        let displayValue = getPrice(price: Double(value))
                        
                        slabCell.perInfantAmountLabel.text = displayValue + " + ₹ " +  String(aertripValue)
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
