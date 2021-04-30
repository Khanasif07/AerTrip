//
//  CombineFareInfoTableViewCell.swift
//  Aertrip
//
//  Created by Monika Sonawane on 27/12/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class CombineFareInfoTableViewCell: UITableViewCell
{
    @IBOutlet weak var combineFareTableView: UITableView!
    @IBOutlet weak var noInfoView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!

    var airlineCancellationFees = [[String:[String:[cancellationSlabStruct]]]]()
    var aertripCancellationFees = [[String:[String:[sucfeeValueStruct]]]]()
    
    var airlineReschedulingFees = [[String:[String:[cancellationSlabStruct]]]]()
    var aertripReschedulingFees = [[String:[String:[sucfeeValueStruct]]]]()
    
    var rafFees = [String:[String:Double]]()
    
    var combineAirlineCancellationFees = [[[String:[String:[cancellationSlabStruct]]]]]()
    var combineAirlineReschedulingFees = [[[String:[String:[cancellationSlabStruct]]]]]()
    
    var journey: [Journey]!
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    
    var count = 0
    var isNoInfoViewVisible = false
    var indexOfCell = 0
        
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
        super.layoutSubviews()
        self.combineFareTableView.layoutIfNeeded()
    }

}

extension CombineFareInfoTableViewCell:UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if section == 0{
            if airlineCancellationFees.count > 0{
                if let airlineCancellationSlabCount = airlineCancellationFees[0]["ADT"]!.values.first?.count
                {
                    return airlineCancellationSlabCount
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }else{
            if airlineReschedulingFees.count > 0{
                if let airlineReschedulingSlabCount = airlineReschedulingFees[0]["ADT"]!.values.first?.count{
                    return airlineReschedulingSlabCount
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
        guard let slabCell = tableView.dequeueReusableCell(withIdentifier: "PerSlabFareInfoCell") as? PerSlabFareInfoTableViewCell else{return UITableViewCell()}
        
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
        
        if indexPath.section == 0{
            if let adtAirlineCancellationSlab = airlineCancellationFees[0]["ADT"]?.values.first
            {
                let adtAertripCancellationSlab = aertripCancellationFees[0]["ADT"]?.values.first ?? []
                
                var aertripValue: Double = 0
                
                if indexPath.row < adtAertripCancellationSlab.count{
                    aertripValue = adtAertripCancellationSlab[indexPath.row].value ?? 0
                }else{
                    aertripValue = adtAertripCancellationSlab.first?.value ?? 0
                }
                
                if indexPath.row < adtAirlineCancellationSlab.count{
                    let airlineValue = adtAirlineCancellationSlab[indexPath.row].value ?? 0
                    
                    if let sla = adtAirlineCancellationSlab[indexPath.row].sla, let slab = adtAirlineCancellationSlab[indexPath.row].slab{
                        
                        let slaInHours = minutesToHoursMinutes(seconds: sla)
                        
                        let totalSlab = slaInHours + slab
                        let strTotalSlab = String(totalSlab).replacingOccurrences(of: "-", with: "")
                        
                        if indexPath.row > 0{
                            let prevSla = adtAirlineCancellationSlab[indexPath.row-1].sla ?? 0
                            let prevSlab = adtAirlineCancellationSlab[indexPath.row-1].slab ?? 0
                            
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
                    }
                    
                    if flightAdultCount > 0 && flightChildrenCount == 0 && flightInfantCount == 0{
                        slabCell.statusLabel.isHidden = false
                        if airlineValue == -9{
                            slabCell.statusLabel.textColor = .black
                            slabCell.statusLabel.text = "NA"
                        }else if airlineValue == -1{
                            slabCell.statusLabel.textColor = .black
                            slabCell.statusLabel.text = "Non-refundable"
                        }else if airlineValue == 0  && aertripValue == 0{
                            slabCell.statusLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                            slabCell.statusLabel.text = "Free Cancellation"
                        }else{
                            slabCell.statusLabel.textColor = .black
                            
                            
                            let adtRafVal = rafFees["ADT"]?.values.first ?? 0

                            if aertripValue > 0{
                                let displayValue = getPrice(price: Double(airlineValue + adtRafVal + aertripValue))
                                slabCell.statusLabel.attributedText = displayValue
                                
                            }else{
                                let displayValue = getPrice(price: Double(airlineValue + adtRafVal))
                                
                                let aertripFees = NSAttributedString(string: " + ")
                                displayValue.append(aertripFees)
                                
                                let atrrAertripValue = getPrice(price: Double(aertripValue))
                                displayValue.append(atrrAertripValue)
                                
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
                        }else if airlineValue == 0  && aertripValue == 0{
                            slabCell.perAdultAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                            slabCell.perAdultAmountLabel.text = "Free Cancellation"
                        }else{
                            slabCell.perAdultAmountLabel.textColor = .black
                            
                            if aertripValue > 0{
                                if let adtRafVal = rafFees["ADT"]?.values.first{
                                    let displayValue = getPrice(price: Double(airlineValue + adtRafVal + aertripValue))
                                    slabCell.perAdultAmountLabel.attributedText = displayValue
                                }

                            }else{
                                let adtRafVal = rafFees["ADT"]?.values.first ?? 0
                                
                                if aertripValue > 0{
                                    let displayValue = getPrice(price: Double(airlineValue + adtRafVal + aertripValue))
                                    slabCell.perAdultAmountLabel.attributedText = displayValue

                                }else{
                                    let displayValue = getPrice(price: Double(airlineValue + adtRafVal))
                                    
                                    let aertripFees = NSAttributedString(string: " + ")
                                    displayValue.append(aertripFees)
                                    
                                    let atrrAertripValue = getPrice(price: Double(aertripValue))
                                    
                                    displayValue.append(atrrAertripValue)

                                    slabCell.perAdultAmountLabel.attributedText = displayValue
                                }
                            }
                        }
                    }
                }else{
                    slabCell.perAdultAmountLabel.text = "NA"
                }
            }
            
            if let chdAirlineCancellationSlab = airlineCancellationFees[0]["CHD"]?.values.first
            {
                let chdAertripCancellationSlab = aertripCancellationFees[0]["CHD"]?.values.first ?? []
                
                var aertripValue: Double = 0
                
                if indexPath.row < chdAertripCancellationSlab.count{
                    aertripValue = chdAertripCancellationSlab[indexPath.row].value ?? 0
                }else{
                    aertripValue = chdAertripCancellationSlab.first?.value ?? 0
                }
                
                if indexPath.row < chdAirlineCancellationSlab.count{
                    let value = chdAirlineCancellationSlab[indexPath.row].value ?? 0
                    
                    if value == -9{
                        slabCell.perChildAmountLabel.textColor = .black
                        slabCell.perChildAmountLabel.text = "NA"
                    }else if value == -1{
                        slabCell.perChildAmountLabel.textColor = .black
                        slabCell.perChildAmountLabel.text = "Non-refundable"
                    }else if value == 0  && aertripValue == 0{
                        slabCell.perChildAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        slabCell.perChildAmountLabel.text = "Free Cancellation"
                    }else{
                        slabCell.perChildAmountLabel.textColor = .black
                        let chdRafVal = rafFees["CHD"]?.values.first ?? 0
                        
                        if aertripValue > 0{
                            let displayValue = getPrice(price: Double(value + chdRafVal + aertripValue))
                            slabCell.perChildAmountLabel.attributedText = displayValue
                        }else{
                            let displayValue = getPrice(price: Double(value + chdRafVal))
                            
                            let str = NSAttributedString(string: " + ")
                            displayValue.append(str)
                            
                            let atrrAertripValue = getPrice(price: Double(aertripValue))
                            displayValue.append(atrrAertripValue)

                            slabCell.perChildAmountLabel.attributedText = displayValue
                        }
                    }
                }else{
                    slabCell.perChildAmountLabel.text = "NA"
                }
            }
            
            if let infAirlineCancellationSlab = airlineCancellationFees[0]["INF"]?.values.first
            {
                let infAertripCancellationSlab = aertripCancellationFees[0]["INF"]?.values.first ?? []
                
                var aertripValue: Double = 0
                
                if indexPath.row < infAertripCancellationSlab.count{
                    aertripValue = infAertripCancellationSlab[indexPath.row].value ?? 0
                }else{
                    aertripValue = infAertripCancellationSlab.first?.value ?? 0
                }
                
                if indexPath.row < infAirlineCancellationSlab.count{
                    let value = infAirlineCancellationSlab[indexPath.row].value ?? 0
                    
                    if value == -9{
                        slabCell.perInfantAmountLabel.textColor = .black
                        slabCell.perInfantAmountLabel.text = "NA"
                    }else if value == -1{
                        slabCell.perInfantAmountLabel.textColor = .black
                        slabCell.perInfantAmountLabel.text = "Non-refundable"
                    }else if value == 0  && aertripValue == 0{
                        slabCell.perInfantAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        slabCell.perInfantAmountLabel.text = "Free Cancellation"
                    }else{
                        slabCell.perInfantAmountLabel.textColor = .black
                        let chdRafVal = rafFees["INF"]?.values.first ?? 0
                        
                        if aertripValue > 0{
                            let displayValue = getPrice(price: Double(value + chdRafVal + aertripValue))
                            slabCell.perInfantAmountLabel.attributedText = displayValue

                        }else{
                            let displayValue = getPrice(price: Double(value + chdRafVal))
     
                            let str = NSAttributedString(string: " + ")
                            displayValue.append(str)
                            
                            let atrrAertripValue = getPrice(price: Double(aertripValue))
                            displayValue.append(atrrAertripValue)

                            slabCell.perInfantAmountLabel.attributedText = displayValue
                        }
                    }
                }else{
                    slabCell.perInfantAmountLabel.text = "NA"
                }
            }
        }else{
            if let adtAirlineReschedulingSlab = airlineReschedulingFees[0]["ADT"]?.values.first
            {
                let adtAertripReschedulingSlab = aertripReschedulingFees[0]["ADT"]?.values.first ?? []
                
                var aertripValue: Double = 0
                
                if indexPath.row < adtAertripReschedulingSlab.count{
                    aertripValue = adtAertripReschedulingSlab[indexPath.row].value ?? 0
                }else{
                    aertripValue = adtAertripReschedulingSlab.first?.value ?? 0
                }
                
                if indexPath.row < adtAirlineReschedulingSlab.count{
                    if let sla = adtAirlineReschedulingSlab[indexPath.row].sla, let slab = adtAirlineReschedulingSlab[indexPath.row].slab{
                        
                        let slaInHours = minutesToHoursMinutes(seconds: sla)
                        
                        let totalSlab = slab + slaInHours
                        
                        let strTotalSlab = String(totalSlab).replacingOccurrences(of: "-", with: "")
                        
                        if indexPath.row > 0{
                            let prevSla = adtAirlineReschedulingSlab[indexPath.row-1].sla ?? 0
                            let prevSlab = adtAirlineReschedulingSlab[indexPath.row-1].slab ?? 0
                            
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
                    }
                    
                    let value = adtAirlineReschedulingSlab[indexPath.row].value ?? 0
                    
                    if flightAdultCount > 0 && flightChildrenCount == 0 && flightInfantCount == 0{
                        slabCell.statusLabel.isHidden = false
                        if value == -9{
                            slabCell.statusLabel.textColor = .black
                            slabCell.statusLabel.text = "NA"
                        }else if value == -1{
                            slabCell.statusLabel.textColor = .black
                            slabCell.statusLabel.text = "Not Permitted"
                        }else if value == 0  && aertripValue == 0{
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
                                
                                let atrrAertripValue = getPrice(price: Double(aertripValue))
                                displayValue.append(atrrAertripValue)

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
                        }else if value == 0  && aertripValue == 0{
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

                                let atrrAertripValue = getPrice(price: Double(aertripValue))
                                displayValue.append(atrrAertripValue)

                                slabCell.perAdultAmountLabel.attributedText = displayValue
                            }
                        }
                    }
                }else{
                    slabCell.perAdultAmountLabel.text = "NA"
                }
            }
            
            if let chdAirlineReschedulingSlab = airlineReschedulingFees[0]["CHD"]?.values.first
            {
                let chdAertripReschedulingSlab = aertripReschedulingFees[0]["CHD"]?.values.first ?? []
                
                var aertripValue: Double = 0
                
                if indexPath.row < chdAertripReschedulingSlab.count{
                    aertripValue = chdAertripReschedulingSlab[indexPath.row].value ?? 0
                }else{
                    aertripValue = chdAertripReschedulingSlab.first?.value ?? 0
                }
                
                if indexPath.row < chdAirlineReschedulingSlab.count{
                    let value = chdAirlineReschedulingSlab[indexPath.row].value ?? 0
                    
                    if value == -9{
                        slabCell.perChildAmountLabel.textColor = .black
                        slabCell.perChildAmountLabel.text = "NA"
                    }else if value == -1{
                        slabCell.perChildAmountLabel.textColor = .black
                        slabCell.perChildAmountLabel.text = "Not Permitted"
                    }else if value == 0  && aertripValue == 0{
                        slabCell.perChildAmountLabel.textColor =  UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        slabCell.perChildAmountLabel.text = "Free Rescheduling"
                    }else{
                        slabCell.perChildAmountLabel.textColor = .black

                        if aertripValue > 0{
                            let displayValue = getPrice(price: Double(value + aertripValue))
                            slabCell.perChildAmountLabel.attributedText = displayValue
                        }else{
                            let displayValue = getPrice(price: Double(value))

                            displayValue.append(NSAttributedString(string: " + "))
                            
                            let atrrAertripValue = getPrice(price: Double(aertripValue))
                            displayValue.append(atrrAertripValue)

                            slabCell.perChildAmountLabel.attributedText = displayValue
                        }

                    }
                }else{
                    slabCell.perChildAmountLabel.text = "NA"
                }
            }
            
            if let infAirlineReschedulingSlab = airlineReschedulingFees[0]["INF"]?.values.first
            {
                let infAertripReschedulingSlab = aertripReschedulingFees[0]["INF"]?.values.first ?? []
                
                var aertripValue: Double = 0
                
                if indexPath.row < infAertripReschedulingSlab.count{
                    aertripValue = infAertripReschedulingSlab[indexPath.row].value ?? 0
                }else{
                    aertripValue = infAertripReschedulingSlab.first?.value ?? 0
                }
                
                if indexPath.row < infAirlineReschedulingSlab.count{
                    let value = infAirlineReschedulingSlab[indexPath.row].value ?? 0
                    
                    if value == -9{
                        slabCell.perInfantAmountLabel.textColor = .black
                        slabCell.perInfantAmountLabel.text = "NA"
                    }else if value == -1{
                        slabCell.perInfantAmountLabel.textColor = .black
                        slabCell.perInfantAmountLabel.text = "Not Permitted"
                    }else if value == 0  && aertripValue == 0{
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
                            
                            let atrrAertripValue = getPrice(price: Double(aertripValue))
                            displayValue.append(atrrAertripValue)

                            slabCell.perInfantAmountLabel.attributedText = displayValue
                        }

                    }
                }else{
                    slabCell.perInfantAmountLabel.text = "NA"
                }
            }
        }
        
        if flightAdultCount > 0 && flightChildrenCount > 0 && flightInfantCount > 0
        {
            if slabCell.perAdultAmountLabel.text == slabCell.perChildAmountLabel.text && slabCell.perAdultAmountLabel.text == slabCell.perInfantAmountLabel.text
            {
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        if section == 1{
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55))
            footerView.backgroundColor = .white

            let innerView = UIView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height:45))
            innerView.backgroundColor = UIColor(displayP3Red: (246.0/255.0), green: (246.0/255.0), blue: (246.0/255.0), alpha: 1.0)
            footerView.addSubview(innerView)
            
            let seperatorView = ATDividerView()
            seperatorView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 0.5)
            
            footerView.addSubview(seperatorView)

            return footerView
        }else{
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if section == 1{
            return 60
        }else{
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
                tableView.layoutIfNeeded()
                tableView.layoutSubviews()
                tableView.setNeedsDisplay()
    }
    
    func minutesToHoursMinutes (seconds : Int) -> (Int) {
        return (seconds / 3600)
    }
    
    //MARK:- Format Price
//    func getPrice(price:Double) -> NSMutableAttributedString{
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.maximumFractionDigits = 2
//        formatter.locale = Locale(identifier: "en_IN")
//        if let result = formatter.string(from: NSNumber(value: price)){
//            let fontSize = 16
//            let fontSizeSuper = 12
//
//            let displayFont = AppFonts.SemiBold.rawValue
//            let displayFontSuper = AppFonts.SemiBold.rawValue
//
//
//            let font = UIFont(name: displayFont, size:CGFloat(fontSize))
//            let fontSuper = UIFont(name: displayFontSuper, size:CGFloat(fontSizeSuper))
//            let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font])
//            attString.setAttributes([.font:fontSuper,.baselineOffset:6], range: NSRange(location:result.count-3,length:3))
//            if attString.string.contains(find: ".00"){
//                attString.mutableString.replaceOccurrences(of: ".00", with: "", options: .caseInsensitive, range: NSRange(location:result.count-3,length:3))
//            }
//            return attString
//        }else{
//            return NSMutableAttributedString(string: "\(price)")
//        }
//    }
    
    
    
    func getPrice(price:Double) -> NSMutableAttributedString{
        return price.getConvertedCanllationAmount(using: AppFonts.SemiBold.withSize(16))
    }
    
    
}
