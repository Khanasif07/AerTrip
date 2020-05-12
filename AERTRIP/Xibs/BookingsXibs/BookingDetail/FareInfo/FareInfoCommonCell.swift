//
//  FareInfoCommonCell.swift
//  AERTRIP
//
//  Created by Admin on 11/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class FareInfoCommonCell: ATTableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var slabTimeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var perAdultLabel: UILabel!
    @IBOutlet weak var perAdultAmountLabel: UILabel!
    @IBOutlet weak var perChildLabel: UILabel!
    @IBOutlet weak var perChildAmountLabel: UILabel!
    @IBOutlet weak var perInfantLabel: UILabel!
    @IBOutlet weak var perInfantAmountLabel: UILabel!
    
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var isForPassenger : Bool = false
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureView() {
        
    }
    
    
    func configureForCancelation(model: BookingFeeDetail, indexPath: IndexPath) {
        
        if let adtAirlineCancellationSlab = model.aerlineCanCharges?.adult
        {
            let adtAertripCancellationSlab = model.aertripCanCharges?.adult
            
            var aertripValue = 0
            
            //            if indexPath.row < adtAertripCancellationSlab!.count{
            aertripValue = model.aertripCanCharges?.adult ?? 0
            //            }
            
            if indexPath.row < adtAirlineCancellationSlab.count{
                let airlineValue = adtAirlineCancellationSlab[indexPath.row].value!
                
                if let sla = adtAirlineCancellationSlab[indexPath.row].from, let slab = adtAirlineCancellationSlab[indexPath.row].to{
                    
                    let slaInHours = sla.hoursFrom(slab)
                    
                    let totalSlab = slaInHours //slaInHours + slab
                    let strTotalSlab = String(totalSlab).replacingOccurrences(of: "-", with: "")
                    
                    if indexPath.row > 0{
                        if let prevSla = adtAirlineCancellationSlab[indexPath.row-1].from, let prevSlab = adtAirlineCancellationSlab[indexPath.row-1].to {
                            
                            let prevSlaInHours = prevSla.hoursFrom(prevSlab) //minutesToHoursMinutes(seconds: prevSla!)
                            let prevTotalSlab = prevSlaInHours //prevSlab! + prevSlaInHours
                            
                            let strPrevTotalSlab = String(prevTotalSlab).replacingOccurrences(of: "-", with: "")
                            
                            if prevTotalSlab == 0 && totalSlab == 0{
                                 self.slabTimeLabel.text = "\(strTotalSlab) hour"
                            }else{
                                 self.slabTimeLabel.text = "\(strTotalSlab) - \(strPrevTotalSlab) hours"
                            }
                        }
                    }else{
                        if strTotalSlab == "0"{
                            self.slabTimeLabel.text = "\(strTotalSlab) hour"
                        }else if strTotalSlab == "1"{
                            self.slabTimeLabel.text = "\(strTotalSlab) hour or earlier"
                        }else{
                            self.slabTimeLabel.text = "\(strTotalSlab) hours or earlier"
                        }
                    }
                }
                
                if flightAdultCount > 0 && flightChildrenCount == 0 && flightInfantCount == 0{
                    self.statusLabel.isHidden = false
                    if airlineValue == -9{
                        self.statusLabel.textColor = .black
                        self.statusLabel.text = "NA"
                    }else if airlineValue == -1{
                        self.statusLabel.textColor = .black
                        self.statusLabel.text = "Non-refundable"
                    }else if airlineValue == 0{
                        self.statusLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        self.statusLabel.text = "Free Cancellation"
                    }else{
                        self.statusLabel.textColor = .black
                        let adtRafVal = model.aertripCanCharges?.adult ?? 0 //rafFees["ADT"]
                        let displayValue = Double(airlineValue + adtRafVal)
                        
                        
                        self.statusLabel.text = String(displayValue) + " + ₹ " + String(aertripValue)
                    }
                }else{
                    if airlineValue == -9{
                        self.perAdultAmountLabel.textColor = .black
                        self.perAdultAmountLabel.text = "NA"
                    }else if airlineValue == -1{
                        self.perAdultAmountLabel.textColor = .black
                        self.perAdultAmountLabel.text = "Non-refundable"
                    }else if airlineValue == 0{
                        self.perAdultAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        self.perAdultAmountLabel.text = "Free Cancellation"
                    }else{
                        self.perAdultAmountLabel.textColor = .black
                        let adtRafVal = model.aertripCanCharges?.adult ?? 0 //rafFees["ADT"]
                        let displayValue = Double(airlineValue + adtRafVal)
                        
                        self.perAdultAmountLabel.text = String(displayValue) + " + ₹ " + String(aertripValue)
                    }
                }
            }else{
                self.perAdultAmountLabel.text = "NA"
            }
        }
        
        if let chdAirlineCancellationSlab = model.aerlineCanCharges?.child
        {
            let chdAertripCancellationSlab = model.aertripCanCharges?.child
            
            var aertripValue = 0
            
//            if indexPath.row < chdAertripCancellationSlab!.count{
                aertripValue = model.aertripCanCharges?.adult ?? 0
//            }
            
            if indexPath.row < chdAirlineCancellationSlab.count{
                let value = chdAirlineCancellationSlab[indexPath.row].value
                
                if value == -9{
                    self.perChildAmountLabel.textColor = .black
                    self.perChildAmountLabel.text = "NA"
                }else if value == -1{
                    self.perChildAmountLabel.textColor = .black
                    self.perChildAmountLabel.text = "Non-refundable"
                }else if value == 0{
                    self.perChildAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                    self.perChildAmountLabel.text = "Free Cancellation"
                }else{
                    self.perChildAmountLabel.textColor = .black
                    let chdRafVal = model.aertripCanCharges?.child ?? 0 //rafFees["CHD"]
                    let displayValue = Double(value! + chdRafVal)
                    
                    self.perChildAmountLabel.text = String(displayValue) + " + ₹ " +  String(aertripValue)
                }
            }else{
                self.perChildAmountLabel.text = "NA"
            }
        }
        
        if let infAirlineCancellationSlab = model.aerlineCanCharges?.infant
        {
            let infAertripCancellationSlab = model.aertripCanCharges?.infant
            
            var aertripValue = 0
            
//            if indexPath.row < infAertripCancellationSlab!.count{
                aertripValue = model.aertripCanCharges?.infant ?? 0
//            }
            
            if indexPath.row < infAirlineCancellationSlab.count{
                let value = infAirlineCancellationSlab[indexPath.row].value
                
                if value == -9{
                    self.perInfantAmountLabel.textColor = .black
                    self.perInfantAmountLabel.text = "NA"
                }else if value == -1{
                    self.perInfantAmountLabel.textColor = .black
                    self.perInfantAmountLabel.text = "Non-refundable"
                }else if value == 0{
                    self.perInfantAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                    self.perInfantAmountLabel.text = "Free Cancellation"
                }else{
                    self.perInfantAmountLabel.textColor = .black
                    let chdRafVal = model.aertripCanCharges?.infant ?? 0 //rafFees["INF"]
                    let displayValue = Double(value! + chdRafVal)
                    self.perInfantAmountLabel.text = String(displayValue) + " + ₹ " +  String(aertripValue)
                }
            }else{
                self.perInfantAmountLabel.text = "NA"
            }
        }
    }
    
    
    func configureForRescheduling(model: BookingFeeDetail, indexPath: IndexPath) {
        if let adtAirlineReschedulingSlab = model.aerlineResCharges?.adult
        {
            let adtAertripReschedulingSlab = model.aertripResCharges?.adult
            
            var aertripValue = 0
            
//            if indexPath.row < adtAertripReschedulingSlab!.count{
                aertripValue = model.aertripResCharges?.adult ?? 0
//            }
            
            if indexPath.row < adtAirlineReschedulingSlab.count{
                if let sla = adtAirlineReschedulingSlab[indexPath.row].from, let slab = adtAirlineReschedulingSlab[indexPath.row].to{
                    
                    let slaInHours = sla.hoursFrom(slab)
                    
                    let totalSlab = slaInHours //slaInHours + slab
                    
                    let strTotalSlab = String(totalSlab).replacingOccurrences(of: "-", with: "")
                    
                    if indexPath.row > 0{
                        if let prevSla = adtAirlineReschedulingSlab[indexPath.row-1].from, let prevSlab = adtAirlineReschedulingSlab[indexPath.row-1].to {
                        
                        let prevSlaInHours = prevSla.hoursFrom(prevSlab) //minutesToHoursMinutes(seconds: prevSla!)
                        let prevTotalSlab = prevSlaInHours //prevSlab! + prevSlaInHours
                        
                        let strPrevTotalSlab = String(prevTotalSlab).replacingOccurrences(of: "-", with: "")
                        
                        if prevTotalSlab == 0 && totalSlab == 0{
                            self.slabTimeLabel.text = "\(strTotalSlab) hour"
                        }else{
                            self.slabTimeLabel.text = "\(strTotalSlab) - \(strPrevTotalSlab) hours"
                        }
                        }
                    }else{
                        if strTotalSlab == "0"{
                            self.slabTimeLabel.text = "\(strTotalSlab) hour"
                        }else if strTotalSlab == "1"{
                            self.slabTimeLabel.text = "\(strTotalSlab) hour or earlier"
                        }else{
                            self.slabTimeLabel.text = "\(strTotalSlab) hours or earlier"
                        }
                    }
                }
                
                let value = adtAirlineReschedulingSlab[indexPath.row].value
                
                if flightAdultCount > 0 && flightChildrenCount == 0 && flightInfantCount == 0{
                    self.statusLabel.isHidden = false
                    if value == -9{
                        self.statusLabel.textColor = .black
                        self.statusLabel.text = "NA"
                    }else if value == -1{
                        self.statusLabel.textColor = .black
                        self.statusLabel.text = "Not Permitted"
                    }else if value == 0{
                        self.statusLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        self.statusLabel.text = "Free Rescheduling"
                    }else{
                        self.statusLabel.textColor = .black
                        
                        let displayValue = Double(value!)
                        self.statusLabel.text = String(displayValue) + " + ₹ " +  String(aertripValue)
                    }
                }else{
                    if value == -9{
                        self.perAdultAmountLabel.textColor = .black
                        self.perAdultAmountLabel.text = "NA"
                    }else if value == -1{
                        self.perAdultAmountLabel.textColor = .black
                        self.perAdultAmountLabel.text = "Not Permitted"
                    }else if value == 0{
                        self.perAdultAmountLabel.textColor =  UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        self.perAdultAmountLabel.text = "Free Rescheduling"
                    }else{
                        self.perAdultAmountLabel.textColor = .black
                        
                        let displayValue = Double(value!)
                        
                        self.perAdultAmountLabel.text = String(displayValue) + " + ₹ " +  String(aertripValue)
                    }
                }
            }else{
                self.perAdultAmountLabel.text = "NA"
            }
        }
        
        if let chdAirlineReschedulingSlab = model.aerlineResCharges?.child
        {
            let chdAertripReschedulingSlab = model.aertripResCharges?.child
            
            var aertripValue = 0
            
//            if indexPath.row < chdAertripReschedulingSlab!.count{
                aertripValue = model.aertripResCharges?.child ?? 0
//            }
            
            if indexPath.row < chdAirlineReschedulingSlab.count{
                let value = chdAirlineReschedulingSlab[indexPath.row].value
                
                if value == -9{
                    self.perChildAmountLabel.textColor = .black
                    self.perChildAmountLabel.text = "NA"
                }else if value == -1{
                    self.perChildAmountLabel.textColor = .black
                    self.perChildAmountLabel.text = "Not Permitted"
                }else if value == 0{
                    self.perChildAmountLabel.textColor =  UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                    self.perChildAmountLabel.text = "Free Rescheduling"
                }else{
                    self.perChildAmountLabel.textColor = .black
                    
                    let displayValue = Double(value!)
                    
                    self.perChildAmountLabel.text = String(displayValue) + " + ₹ " +  String(aertripValue)
                }
            }else{
                self.perChildAmountLabel.text = "NA"
            }
        }
        
        if let infAirlineReschedulingSlab = model.aerlineResCharges?.infant
        {
            let infAertripReschedulingSlab = model.aertripResCharges?.infant
            
            var aertripValue = 0
            
//            if indexPath.row < infAertripReschedulingSlab!.count{
                aertripValue = model.aertripResCharges?.infant ?? 0
                
//            }
            if indexPath.row < infAirlineReschedulingSlab.count{
                let value = infAirlineReschedulingSlab[indexPath.row].value
                
                if value == -9{
                    self.perInfantAmountLabel.textColor = .black
                    self.perInfantAmountLabel.text = "NA"
                }else if value == -1{
                    self.perInfantAmountLabel.textColor = .black
                    self.perInfantAmountLabel.text = "Not Permitted"
                }else if value == 0{
                    self.perInfantAmountLabel.textColor =  UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                    self.perInfantAmountLabel.text = "Free Rescheduling"
                }else{
                    self.perInfantAmountLabel.textColor = .black
                    let displayValue = Double(value!)
                    
                    self.perInfantAmountLabel.text = String(displayValue) + " + ₹ " +  String(aertripValue)
                }
            }else{
                self.perInfantAmountLabel.text = "NA"
            }
        }
    }
}
