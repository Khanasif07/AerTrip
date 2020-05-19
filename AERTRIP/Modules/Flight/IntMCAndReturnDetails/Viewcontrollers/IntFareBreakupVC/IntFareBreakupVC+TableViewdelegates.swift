//
//  IntFareBreakupVC+TableViewdelegates.swift
//  Aertrip
//
//  Created by Apple  on 22.04.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation

extension IntFareBreakupVC: UITableViewDelegate,UITableViewDataSource{
    
    //MARK:- TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 2{
            if taxAndFeesData.count > 0{
                return taxAndFeesData.count+1
            }else{
                return 0
            }
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch indexPath.section
        {
        case 0:
            let fareBreakupCell = tableView.dequeueReusableCell(withIdentifier: "FareBreakupCell") as! FareBreakupTableViewCell
            fareBreakupCell.selectionStyle = .none
            
            if self.bookFlightObject.flightAdultCount == 0{
                fareBreakupCell.adultCountDisplayView.isHidden = true
                fareBreakupCell.adultCountDisplayViewWidth.constant = 0
                fareBreakupCell.adultCountLabel.text = ""
            }else{
                fareBreakupCell.adultCountDisplayView.isHidden = false
                fareBreakupCell.adultCountDisplayViewWidth.constant = 25
                fareBreakupCell.adultCountLabel.text = "\(self.bookFlightObject.flightAdultCount)"
            }
            
            if self.bookFlightObject.flightChildrenCount == 0{
                fareBreakupCell.childrenCountDisplayView.isHidden = true
                fareBreakupCell.childrenCountDisplayViewWidth.constant = 0
                fareBreakupCell.childrenCountLabel.text = ""
            }else{
                fareBreakupCell.childrenCountDisplayView.isHidden = false
                fareBreakupCell.childrenCountDisplayViewWidth.constant = 35
                fareBreakupCell.childrenCountLabel.text = "\(self.bookFlightObject.flightChildrenCount)"
            }
            
            if self.bookFlightObject.flightInfantCount == 0{
                fareBreakupCell.infantCountDisplayView.isHidden = true
                fareBreakupCell.infantCountDisplayViewWidth.constant = 0
                fareBreakupCell.infantCountLabel.text = ""
            }else{
                fareBreakupCell.infantCountDisplayView.isHidden = false
                fareBreakupCell.infantCountDisplayViewWidth.constant = 35
                fareBreakupCell.infantCountLabel.text = "\(self.bookFlightObject.flightInfantCount)"
            }
            
            return fareBreakupCell
            
        case 1:
            let baseFareCell = tableView.dequeueReusableCell(withIdentifier: "BaseFareCell") as! BaseFareTableViewCell
            baseFareCell.selectionStyle = .none
            
            baseFareCell.titleLabelLeading.constant = 16
            
            baseFareCell.titleLabel.text = "Base Fare"
            if taxesData != nil{
                var amount = 0
//                if journeyCombo != nil{
//                    amount = journeyCombo.reduce(0) { $0 + $1.fare.BF.value }
//                }else{
                amount = journey.first?.fare.bf.value ?? 0
//                }
                
                let price = displayPriceInFormat(price: Double(amount), fromOption : "FareAmount")
                baseFareCell.amountLable.attributedText = price
            }else{
                baseFareCell.amountLable.text = ""
            }
            return baseFareCell
            
        case 2:
            if indexPath.row == 0{
                let baseFareCell = tableView.dequeueReusableCell(withIdentifier: "BaseFareCell") as! BaseFareTableViewCell
                baseFareCell.selectionStyle = .none
                
                
                if isTaxesSectionHidden == false{
                    baseFareCell.upArrowImg.image = UIImage(named: "upGray.png")
                }else{
                    baseFareCell.upArrowImg.image = UIImage(named: "downGray.png")
                }
                
                baseFareCell.titleLabelLeading.constant = 16
                
                baseFareCell.upArrowImg.isHidden = false
                baseFareCell.titleLabel.text = "Taxes and Fees"
                if taxesData != nil{
                    var amount = 0
                    amount = journey.first?.fare.taxes.value ?? 0
                    let price = displayPriceInFormat(price: Double(amount), fromOption : "FareAmount")
                    baseFareCell.amountLable.attributedText = price
                }else{
                    baseFareCell.amountLable.text = ""
                }
                baseFareCell.dataDisplayViewBottom.constant = 0
                
                return baseFareCell
            }else{
                let baseFareCell = tableView.dequeueReusableCell(withIdentifier: "BaseFareCell") as! BaseFareTableViewCell
                baseFareCell.selectionStyle = .none
                
                if isTaxesSectionHidden == false{
                    baseFareCell.isHidden = false
                }else{
                    baseFareCell.isHidden = true
                }
                
                baseFareCell.titleLabelLeading.constant = 31
                
                if taxAndFeesData.count > 0{
                    baseFareCell.titleLabel.text = (taxAndFeesData[indexPath.row-1].value(forKey: "name") as! String)
                    if (taxAndFeesData[indexPath.row-1].value(forKey: "value") as? Int) != nil{
                        let amount : Double = Double(taxAndFeesData[indexPath.row-1].value(forKey: "value")! as! Int)
                        
                        let price = displayPriceInFormat(price: amount, fromOption : "FareAmount")
                        baseFareCell.amountLable.attributedText = price
                    }else{
                        baseFareCell.amountLable.text = ""
                    }
                }else{
                    baseFareCell.titleLabel.text = ""
                    baseFareCell.amountLable.text = ""
                }
                
                
                if indexPath.row == taxAndFeesData.count{
                    //                    baseFareCell.dataDisplayViewBottom.constant = 15
                    baseFareCell.titleLabelYPosition.constant = -7
                }else{
                    //                    baseFareCell.dataDisplayViewBottom.constant = 0
                    baseFareCell.titleLabelYPosition.constant = 0
                }
                return baseFareCell
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.section
        {
        case 0:
            return 43
            
        case 1:
            return 25
            
        case 2 :
            if indexPath.row == 0{
                return 29
            }else{
                if isTaxesSectionHidden == false{
                    if indexPath.row == taxAndFeesData.count{
                        return 37
                    }else{
                        return 24
                    }
                }else{
                    return 0
                }
            }
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            isTaxesSectionHidden = !isTaxesSectionHidden
            displayExpandedView(fromSelection: "taxes")
            baseFareTableview.reloadData()
        }
    }
    
    func initialDisplayView()
    {
        let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
        let screenSize = UIScreen.main.bounds
        var isFSR = false
        var remainingSeats = ""
        
        if journey != nil{
            if journey.first?.fsr == 1{
                isFSR = true
                remainingSeats = journey.first?.seats ?? ""
            }
        }
        
        if isFSR == true && remainingSeats != ""{
            fewSeatsLeftView.isHidden = false
            fewSeatsLeftViewHeight.constant = 35
            
            remainingSeatsCountLabel.text = remainingSeats
            
            if Int(remainingSeats)! > 1{
                fewSeatsLeftLabel.text = "Seats left at this price. Hurry up!"
            }else{
                fewSeatsLeftLabel.text = "Seat left at this price. Hurry up!"
            }
            
            self.fareDataDisplayViewHeight.constant = 85 + CGFloat(bottomInset!) + self.heightForBookingTitleView
            self.bookingDataDisplayViewHeight.constant = 50 + CGFloat(bottomInset!)
        }else{
            fewSeatsLeftView.isHidden = true
            fewSeatsLeftViewHeight.constant = 0
            
            self.fareDataDisplayViewHeight.constant = 50 + CGFloat(bottomInset!) + self.heightForBookingTitleView
            self.bookingDataDisplayViewHeight.constant = 50 + CGFloat(bottomInset!)
        }
        
        self.totalPayableViewBottom.constant = bottomInset!
        self.fareDataDisplayViewBottom.constant = bottomInset!
        self.totalPayableView.isHidden = true
        self.totalPayableViewHeight.constant = 0
        self.baseFareTableview.isHidden = true
        self.baseFareTableviewHeight.constant = 0
        
        let viewHeight = self.bookingDataDisplayViewHeight.constant + self.fewSeatsLeftViewHeight.constant + self.heightForBookingTitleView
        
        if self.isFromFlightDetails == true{
            switch UIScreen.main.bounds.height{
            case 568: //iPhone SE | 5S
                if #available(iOS 13.0, *) {
                    self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight-40, width: screenSize.width, height:viewHeight + CGFloat(bottomInset!))
                }else{
                    self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight, width: screenSize.width, height:viewHeight + CGFloat(bottomInset!))
                }
                break
                
            case 667: //iPhone 8 | 6 | 6s | 7
                if #available(iOS 13.0, *) {
                    self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight-40, width: screenSize.width, height:viewHeight + CGFloat(bottomInset!))
                }else{
                    self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight, width: screenSize.width, height:viewHeight + CGFloat(bottomInset!))
                }
                break
                
            case 736: //iPhone 6 Plus | 8 plus | 6s plus | 7 Plus
                if #available(iOS 13.0, *) {
                    self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight-40, width: screenSize.width, height:viewHeight + CGFloat(bottomInset!))
                }else{
                    self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight, width: screenSize.width, height:viewHeight + CGFloat(bottomInset!))
                }
                break
                
            case 812: //11 Pro | X | Xs
                if #available(iOS 13.0, *) {
                    self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight - 55, width: screenSize.width, height:viewHeight + CGFloat(bottomInset!))
                }else{
                    self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight, width: screenSize.width, height:viewHeight + CGFloat(bottomInset!))
                }
                
                break
                
            case 896: //11 & 11 Pro Max & Xs Max & Xr
                if #available(iOS 13.0, *) {
                    self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight - 60, width: screenSize.width, height:viewHeight + CGFloat(bottomInset!))
                }else{
                    self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight, width: screenSize.width, height:viewHeight + CGFloat(bottomInset!))
                }
                
                break
                
            default :
                break
            }
        }else{
            self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight, width: screenSize.width, height:viewHeight + CGFloat(bottomInset!))
        }
    }
    
}
