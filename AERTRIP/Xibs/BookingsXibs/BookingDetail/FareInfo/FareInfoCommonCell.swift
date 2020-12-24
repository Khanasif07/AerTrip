//
//  FareInfoCommonCell.swift
//  AERTRIP
//
//  Created by Admin on 11/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class FareInfoCommonCell: ATTableViewCell
{
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
    @IBOutlet weak var adultView: UIStackView!
    @IBOutlet weak var childView: UIStackView!
    @IBOutlet weak var infrantView: UIStackView!
    @IBOutlet weak var titleView: UIStackView!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var passengerStackView: UIStackView!
    
    // MARK: - Variables
    var isForPassenger : Bool = false
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    /// Setup Fonts
    override func setupFonts() {
        titleLabel.font = AppFonts.SemiBold.withSize(18)
        feeLabel.font = AppFonts.Regular.withSize(16)
        slabTimeLabel.font = AppFonts.Regular.withSize(16)
        statusLabel.font = AppFonts.SemiBold.withSize(16)
        perAdultLabel.font = AppFonts.Regular.withSize(16)
        perAdultAmountLabel.font = AppFonts.SemiBold.withSize(16)
        perChildLabel.font = AppFonts.Regular.withSize(16)
        perChildAmountLabel.font = AppFonts.SemiBold.withSize(16)
        perInfantLabel.font = AppFonts.Regular.withSize(16)
        perInfantAmountLabel.font = AppFonts.SemiBold.withSize(16)
    }
    
    /// Setup Colors
    override func setupColors() {
        titleLabel.textColor = AppColors.themeBlack
        feeLabel.textColor = AppColors.themeBlack
        slabTimeLabel.textColor = AppColors.themeBlack
        statusLabel.textColor = AppColors.themeBlack
        perAdultLabel.textColor = AppColors.themeGray60
        perAdultAmountLabel.textColor = AppColors.themeBlack
        perChildLabel.textColor = AppColors.themeGray60
        perChildAmountLabel.textColor = AppColors.themeBlack
        perInfantLabel.textColor = AppColors.themeGray60
        perInfantAmountLabel.textColor = AppColors.themeBlack
    }
    
    override func setupTexts() {
        perAdultLabel.text = LocalizedString.PerAdult.localized
        perChildLabel.text = LocalizedString.PerChild.localized
        perInfantLabel.text = LocalizedString.PerInfant.localized
        
        feeLabel.text = "Airline fee + Aertrip Fee"
        statusLabel.text = ""
    }
    
    private func resetView() {
        passengerStackView.isHidden = true
        adultView.isHidden = true
        childView.isHidden = true
        infrantView.isHidden = true
        statusLabel.text = ""
        dividerView.isHidden = true
    }
    
    func configureView(model: BookingFeeDetail, indexPath: IndexPath) {
        resetView()
        if indexPath.section == 0 && indexPath.row == 0{
            self.titleLabel.text = "Cancellation"
            self.titleView.isHidden = false
        }else if indexPath.section == 1 && indexPath.row == 0{
            self.titleLabel.text = "Rescheduling"
            self.titleView.isHidden = false
        }else{
            self.titleLabel.text = ""
            self.titleView.isHidden = true
        }
        
        if indexPath.section == 0 {
            configureForCancelation(model: model, indexPath: indexPath)
        } else {
            configureForRescheduling(model: model, indexPath: indexPath)
        }
    }
    
    func configureForCancelation(model: BookingFeeDetail, indexPath: IndexPath)
    {
        if let adtAirlineCancellationSlab = model.aerlineCanCharges?.adult
        {
            var aertripValue: Double = 0
            
            aertripValue = Double(model.aertripCanCharges?.adult ?? 0)
            
            if indexPath.row < adtAirlineCancellationSlab.count{
                let airlineValue = adtAirlineCancellationSlab[indexPath.row].value!
                
                if let sla = adtAirlineCancellationSlab[indexPath.row].fromHour, let slab = adtAirlineCancellationSlab[indexPath.row].toHour{
                    
                    let slaInHours = minutesToHoursMinutes(seconds: sla)
                    
                    let totalSlab = slaInHours + slab
                    let strTotalSlab = String(totalSlab).replacingOccurrences(of: "-", with: "")
                    
                    if indexPath.row > 0{
                        if let prevSla = adtAirlineCancellationSlab[indexPath.row-1].fromHour, let prevSlab = adtAirlineCancellationSlab[indexPath.row-1].toHour {
                            
                            let prevSlaInHours = minutesToHoursMinutes(seconds: prevSla)
                            let prevTotalSlab = prevSlab + prevSlaInHours
                            
                            let strPrevTotalSlab = String(prevTotalSlab).replacingOccurrences(of: "-", with: "")
                            
                            if prevTotalSlab == 0 && totalSlab == 0{
                                self.slabTimeLabel.text = "\(strTotalSlab) hrs"
                            }else{
                                self.slabTimeLabel.text = "\(strTotalSlab) - \(strPrevTotalSlab) hrs"
                            }
                        }
                    }else{
                        if strTotalSlab == "0"{
                            self.slabTimeLabel.text = "\(strTotalSlab) hrs"
                        }else if strTotalSlab == "1"{
                            self.slabTimeLabel.text = "\(strTotalSlab) hrs or earlier"
                        }else{
                            self.slabTimeLabel.text = "\(strTotalSlab) hrs or earlier"
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
                    }else if airlineValue == 0 && aertripValue == 0{
                        self.statusLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        self.statusLabel.text = "Free Cancellation"
                    }else{
                        self.statusLabel.textColor = .black
                        let adtRafVal = model.rafCanCharges?.adult ?? 0//model.aertripCanCharges?.adult ?? 0
                        let displayValue = Double(airlineValue + adtRafVal)
                        
                        self.statusLabel.attributedText = getFormatedPrice(flightPrice: displayValue, aertripPrice: aertripValue, font: self.statusLabel.font)
                    }
                }else{
                    if airlineValue == -9{
                        self.perAdultAmountLabel.textColor = .black
                        self.perAdultAmountLabel.text = "NA"
                    }else if airlineValue == -1{
                        self.perAdultAmountLabel.textColor = .black
                        self.perAdultAmountLabel.text = "Non-refundable"
                    }else if airlineValue == 0 && aertripValue == 0{
                        self.perAdultAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        self.perAdultAmountLabel.text = "Free Cancellation"
                    }else{
                        self.perAdultAmountLabel.textColor = .black
                        let adtRafVal = model.rafCanCharges?.adult ?? 0//model.aertripCanCharges?.adult ?? 0
                        let displayValue = Double(airlineValue + adtRafVal)
                        self.adultView.isHidden = false
                        self.perAdultAmountLabel.attributedText = getFormatedPrice(flightPrice: displayValue, aertripPrice: aertripValue, font: self.perAdultAmountLabel.font)
                    }
                }
            }else{
                self.perAdultAmountLabel.text = "NA"
            }
        }
        
        if let chdAirlineCancellationSlab = model.aerlineCanCharges?.child
        {
            var aertripValue: Double = 0
            
            aertripValue = Double(model.aertripCanCharges?.child ?? 0)
            
            if indexPath.row < chdAirlineCancellationSlab.count{
                let value = chdAirlineCancellationSlab[indexPath.row].value
                
                if value == -9{
                    self.perChildAmountLabel.textColor = .black
                    self.perChildAmountLabel.text = "NA"
                }else if value == -1{
                    self.perChildAmountLabel.textColor = .black
                    self.perChildAmountLabel.text = "Non-refundable"
                }else if value == 0 && aertripValue == 0{
                    self.perChildAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                    self.perChildAmountLabel.text = "Free Cancellation"
                }else{
                    self.perChildAmountLabel.textColor = .black
                    let chdRafVal = model.rafCanCharges?.child ?? 0//model.aertripCanCharges?.child ?? 0
                    let displayValue = Double(value! + chdRafVal)
                    self.childView.isHidden = false
                    self.perChildAmountLabel.attributedText = getFormatedPrice(flightPrice: displayValue, aertripPrice: aertripValue, font: self.perChildAmountLabel.font)
                }
            }else{
                self.perChildAmountLabel.text = "NA"
            }
        }
        
        if let infAirlineCancellationSlab = model.aerlineCanCharges?.infant
        {
            var aertripValue: Double = 0
            
            aertripValue = Double(model.aertripCanCharges?.infant ?? 0)
            
            if indexPath.row < infAirlineCancellationSlab.count{
                let value = infAirlineCancellationSlab[indexPath.row].value
                
                if value == -9{
                    self.perInfantAmountLabel.textColor = .black
                    self.perInfantAmountLabel.text = "NA"
                }else if value == -1{
                    self.perInfantAmountLabel.textColor = .black
                    self.perInfantAmountLabel.text = "Non-refundable"
                }else if value == 0 && aertripValue == 0{
                    self.perInfantAmountLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                    self.perInfantAmountLabel.text = "Free Cancellation"
                }else{
                    self.perInfantAmountLabel.textColor = .black
                    let chdRafVal = model.rafCanCharges?.infant ?? 0//model.aertripCanCharges?.infant ?? 0
                    let displayValue = Double(value! + chdRafVal)
                    self.infrantView.isHidden = false
                    self.perInfantAmountLabel.attributedText = getFormatedPrice(flightPrice: displayValue, aertripPrice: aertripValue, font: self.perInfantAmountLabel.font)
                }
            }else{
                self.perInfantAmountLabel.text = "NA"
            }
        }
        
        finalSetupOfCell()
    }
    
    func configureForRescheduling(model: BookingFeeDetail, indexPath: IndexPath) {
        if let adtAirlineReschedulingSlab = model.aerlineResCharges?.adult
        {
            var aertripValue: Double = 0
            
            aertripValue = Double(model.aertripResCharges?.adult ?? 0)
            
            if indexPath.row < adtAirlineReschedulingSlab.count{
                if let sla = adtAirlineReschedulingSlab[indexPath.row].fromHour, let slab = adtAirlineReschedulingSlab[indexPath.row].toHour{
                    
                    let slaInHours = minutesToHoursMinutes(seconds: sla) //sla.hrsFrom(slab)
                    
                    let totalSlab = slaInHours + slab
                    
                    let strTotalSlab = String(totalSlab).replacingOccurrences(of: "-", with: "")
                    
                    if indexPath.row > 0{
                        if let prevSla = adtAirlineReschedulingSlab[indexPath.row-1].fromHour, let prevSlab = adtAirlineReschedulingSlab[indexPath.row-1].toHour {
                            
                            let prevSlaInHours = minutesToHoursMinutes(seconds: prevSla)
                            let prevTotalSlab = prevSlab + prevSlaInHours
                            
                            let strPrevTotalSlab = String(prevTotalSlab).replacingOccurrences(of: "-", with: "")
                            
                            if prevTotalSlab == 0 && totalSlab == 0{
                                self.slabTimeLabel.text = "\(strTotalSlab) hrs"
                            }else{
                                self.slabTimeLabel.text = "\(strTotalSlab) - \(strPrevTotalSlab) hrs"
                            }
                        }
                    }else{
                        if strTotalSlab == "0"{
                            self.slabTimeLabel.text = "\(strTotalSlab) hrs"
                        }else if strTotalSlab == "1"{
                            self.slabTimeLabel.text = "\(strTotalSlab) hrs or earlier"
                        }else{
                            self.slabTimeLabel.text = "\(strTotalSlab) hrs or earlier"
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
                    }else if value == 0 && aertripValue == 0{
                        self.statusLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        self.statusLabel.text = "Free Rescheduling"
                    }else{
                        self.statusLabel.textColor = .black
                        let displayValue = Double(value!)
                        self.statusLabel.attributedText = getFormatedPrice(flightPrice: displayValue, aertripPrice: aertripValue, font: self.statusLabel.font)
                    }
                }else{
                    if value == -9{
                        self.perAdultAmountLabel.textColor = .black
                        self.perAdultAmountLabel.text = "NA"
                    }else if value == -1{
                        self.perAdultAmountLabel.textColor = .black
                        self.perAdultAmountLabel.text = "Not Permitted"
                    }else if value == 0 && aertripValue == 0{
                        self.perAdultAmountLabel.textColor =  UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                        self.perAdultAmountLabel.text = "Free Rescheduling"
                    }else{
                        self.perAdultAmountLabel.textColor = .black
                        
                        let displayValue = Double(value!)
                        
                        self.perAdultAmountLabel.attributedText = getFormatedPrice(flightPrice: displayValue, aertripPrice: aertripValue, font: self.perAdultAmountLabel.font)
                    }
                }
            }else{
                self.perAdultAmountLabel.text = "NA"
            }
        }
        
        if let chdAirlineReschedulingSlab = model.aerlineResCharges?.child
        {
            var aertripValue: Double = 0
            
            aertripValue = Double(model.aertripResCharges?.child ?? 0)
            
            if indexPath.row < chdAirlineReschedulingSlab.count{
                let value = chdAirlineReschedulingSlab[indexPath.row].value
                
                if value == -9{
                    self.perChildAmountLabel.textColor = .black
                    self.perChildAmountLabel.text = "NA"
                }else if value == -1{
                    self.perChildAmountLabel.textColor = .black
                    self.perChildAmountLabel.text = "Not Permitted"
                }else if value == 0 && aertripValue == 0{
                    self.perChildAmountLabel.textColor =  UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                    self.perChildAmountLabel.text = "Free Rescheduling"
                }else{
                    self.perChildAmountLabel.textColor = .black
                    
                    let displayValue = Double(value!)
                    
                    self.perChildAmountLabel.attributedText = getFormatedPrice(flightPrice: displayValue, aertripPrice: aertripValue, font: self.perChildAmountLabel.font)
                }
            }else{
                self.perChildAmountLabel.text = "NA"
            }
        }
        
        if let infAirlineReschedulingSlab = model.aerlineResCharges?.infant
        {            
            var aertripValue: Double = 0
            
            aertripValue = Double(model.aertripResCharges?.infant ?? 0)
            
            if indexPath.row < infAirlineReschedulingSlab.count{
                let value = infAirlineReschedulingSlab[indexPath.row].value
                
                if value == -9{
                    self.perInfantAmountLabel.textColor = .black
                    self.perInfantAmountLabel.text = "NA"
                }else if value == -1{
                    self.perInfantAmountLabel.textColor = .black
                    self.perInfantAmountLabel.text = "Not Permitted"
                }else if value == 0 && aertripValue == 0{
                    self.perInfantAmountLabel.textColor =  UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                    self.perInfantAmountLabel.text = "Free Rescheduling"
                }else{
                    self.perInfantAmountLabel.textColor = .black
                    let displayValue = Double(value!)
                    
                    self.perInfantAmountLabel.attributedText = getFormatedPrice(flightPrice: displayValue, aertripPrice: aertripValue, font: self.perInfantAmountLabel.font)
                }
            }else{
                self.perInfantAmountLabel.text = "NA"
            }
        }
        finalSetupOfCell()
    }
    
    func finalSetupOfCell() {
        
        if flightAdultCount > 0 && flightChildrenCount > 0 && flightInfantCount > 0{
            if self.perAdultAmountLabel.text == self.perChildAmountLabel.text && self.perAdultAmountLabel.text == self.perInfantAmountLabel.text{
                self.adultView.isHidden = true
                self.childView.isHidden = true
                self.infrantView.isHidden = true
                self.passengerStackView.isHidden = true
                self.statusLabel.isHidden = false
                self.statusLabel.textColor = .black
                self.statusLabel.text = self.perAdultAmountLabel.text
            }else{
                self.adultView.isHidden = false
                self.childView.isHidden = false
                self.infrantView.isHidden = false
                self.passengerStackView.isHidden = false
            }
        }else if flightAdultCount > 0 && flightChildrenCount > 0{
            self.adultView.isHidden = false
            self.childView.isHidden = false
            self.infrantView.isHidden = true
            self.passengerStackView.isHidden = false
        }else if flightAdultCount > 0 && flightInfantCount > 0{
            self.adultView.isHidden = false
            self.childView.isHidden = true
            self.infrantView.isHidden = false
            self.passengerStackView.isHidden = false
        }else if self.perAdultAmountLabel.text == "Non-refundable" &&
                    self.perChildAmountLabel.text == "Non-refundable" &&
                    self.perInfantAmountLabel.text == "Non-refundable" ||
                    self.perAdultAmountLabel.text == "Free Cancellation" &&
                    self.perChildAmountLabel.text == "Free Cancellation" &&
                    self.perInfantAmountLabel.text == "Free Cancellation" ||
                    self.perAdultAmountLabel.text == "Not Permitted" &&
                    self.perChildAmountLabel.text == "Not Permitted" &&
                    self.perInfantAmountLabel.text == "Not Permitted" ||
                    self.perAdultAmountLabel.text == "Free Rescheduling" &&
                    self.perChildAmountLabel.text == "Free Rescheduling" &&
                    self.perInfantAmountLabel.text == "Free Rescheduling"
        {
            self.adultView.isHidden = true
            self.childView.isHidden = true
            self.infrantView.isHidden = true
            self.passengerStackView.isHidden = true
            
            if self.perAdultAmountLabel.text == "Non-refundable"{
                self.statusLabel.textColor = .black
                self.statusLabel.text = "Non-refundable"
            }else if self.perAdultAmountLabel.text == "Not Permitted"{
                self.statusLabel.textColor = .black
                self.statusLabel.text = "Not Permitted"
            }else if self.perAdultAmountLabel.text == "Free Cancellation"{
                self.statusLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                self.statusLabel.text = "Free Cancellation"
            }else if self.perAdultAmountLabel.text == "Free Rescheduling"{
                self.statusLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                self.statusLabel.text = "Free Rescheduling"
            }else{
                self.statusLabel.text = ""
            }
        }else if flightAdultCount > 0 && flightChildrenCount == 0 && flightInfantCount == 0{
            self.adultView.isHidden = true
            self.childView.isHidden = true
            self.infrantView.isHidden = true
            self.passengerStackView.isHidden = true
        }else{
            self.adultView.isHidden = true
            self.childView.isHidden = true
            self.infrantView.isHidden = true
            self.passengerStackView.isHidden = true
        }
    }
    
    private func getFormatedPrice(flightPrice: Double, aertripPrice: Double, font: UIFont) -> NSMutableAttributedString
    {
        if aertripPrice > 0.0{
            let totalPrice = flightPrice + aertripPrice
            let price = totalPrice.amountInDelimeterWithSymbol.asStylizedPrice(using: font)
            
            let finalString = NSMutableAttributedString(attributedString: price)
            return finalString
        }else{
            let fPrice = flightPrice.amountInDelimeterWithSymbol.asStylizedPrice(using: font)
            let aPrice = aertripPrice.amountInDelimeterWithSymbol.asStylizedPrice(using: font)
            
            let finalString = NSMutableAttributedString(attributedString: fPrice)
            finalString.append(NSMutableAttributedString(string: " + "))
            finalString.append(aPrice)
            return finalString
        }
    }
    
    func minutesToHoursMinutes (seconds : Int) -> (Int) {
        return (seconds / 3600)
    }
}
