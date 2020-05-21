//
//  FareBreakupVC.swift
//  Aertrip
//
//  Created by Monika Sonawane on 27/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

struct taxStruct {
    var name : String
    var taxVal : Int
}

protocol FareBreakupVCDelegate : AnyObject  {
    func bookButtonTapped(journeyCombo:[CombinationJourney]?)
    func infoButtonTapped(isViewExpanded:Bool)
}

class FareBreakupVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //MARK:- Outlets
    @IBOutlet weak var backgroundDisplayView: UIView!
    @IBOutlet weak var fareDataDisplayView: UIView!
    @IBOutlet weak var fareDataDisplayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fareDataDisplayViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var baseFareTableview: UITableView!
    @IBOutlet weak var baseFareTableviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var remainingSeatsCountLabel: UILabel!
    @IBOutlet weak var fewSeatsLeftLabel: UILabel!
    @IBOutlet weak var fewSeatsLeftView: UIView!
    @IBOutlet weak var fewSeatsLeftViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var totalPayableView: UIView!
    @IBOutlet weak var totalPayableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var totalPayableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalPayableAmountLabel: UILabel!
    
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var upgradeButtonWidth: NSLayoutConstraint!
    
    @IBOutlet weak var strikeOutAmountLabel: UILabel!
    @IBOutlet weak var strikeOutAmountLabelTrailing: NSLayoutConstraint!
    @IBOutlet weak var bookingAmountLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bookingInfoArrowImg: UIImageView!
    
    @IBOutlet weak var bookButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var bookingView: UIView!
    @IBOutlet weak var bookingDataDisplayView: UIView!
    @IBOutlet weak var bookingDataDisplayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dividerView: UIView!
    
    //MARK:- Variable Declaration
    var taxesResult : [String : String]!
    var flights : [FlightDetail]?
    var journey: [Journey]!
    var journeyCombo: [CombinationJourney]!

    var taxesData : Taxes?
    var taxesDetails : [String:Int] = [String:Int]()
    var taxAndFeesData = [NSDictionary]()
    var taxAndFeesDataDict = [taxStruct]()
    
    var isTaxesSectionHidden = true
    var isInfoViewHidden = false
    var isUpgradePlanScreenVisible = false
    var isFewSeatsLeftViewVisible = false
    var isFromFlightDetails = false
    
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    var sid = ""
    var fromScreen = ""
    var isFareBreakupExpanded = false
    var isBackgroundVisible = false
    var selectedJourneyFK = [String]()
    var fewSeatsLeftViewHeightFromFlightDetails = 0
    
    weak var delegate: FareBreakupVCDelegate?
    
    //MARK:- Initialise Views
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.parent?.view.isUserInteractionEnabled = false
        baseFareTableview.register(UINib(nibName: "FareBreakupTableViewCell", bundle: nil), forCellReuseIdentifier: "FareBreakupCell")
        baseFareTableview.register(UINib(nibName: "BaseFareTableViewCell", bundle: nil), forCellReuseIdentifier: "BaseFareCell")
        
        backgroundDisplayView.backgroundColor = .clear
        remainingSeatsCountLabel.layer.cornerRadius = remainingSeatsCountLabel.frame.width/2
        initialDisplayView()
        taxesDataDisplay()
        
        //        setupSwipeDownGuesture()
        
        if fromScreen == "upgradePlan" {
            infoLabel.isHidden = true
            bookingInfoArrowImg.isHidden = true
        }else{
            infoLabel.isHidden = false
            bookingInfoArrowImg.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        if fromScreen == "upgradePlanCollapse"
        {
            if let subLayers = bookingDataDisplayView.layer.sublayers{
                if subLayers.count > 0{
                    for layer in subLayers {
                        if layer.name == "bookingGradient" {
                            layer.removeFromSuperlayer()
                        }
                    }
                }
            }
            
            fromScreen = "upgradePlan"
        }else if fromScreen == "upgradePlan" {
            self.view.backgroundColor = UIColor.clear
        }else{
            bookingDataDisplayView.frame.size.width = self.view.frame.width
            
            if isFareBreakupExpanded == false{
                
                UIView.animate(withDuration: 0.2, delay: 0.1, options: [.curveEaseOut], animations: {
                    let gradient = CAGradientLayer()
                    gradient.frame = self.fareDataDisplayView.bounds
                    let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
                    gradient.frame.size.height = self.fareDataDisplayView.frame.height+bottomInset!
                    
                    gradient.startPoint = CGPoint(x: 0, y: 1)
                    gradient.endPoint = CGPoint(x: 1, y: 1)
                    let colorOne = UIColor(displayP3Red: ( 0.0 / 255.0), green: ( 204.0 / 255.0), blue: ( 153 / 255.0), alpha: 1.0)
                    let colorTwo = UIColor(displayP3Red: (41.0/255.0), green: ( 176.0 / 255.0) , blue: ( 182 / 255.0), alpha: 1.0)
                    gradient.colors = [colorTwo.cgColor, colorOne.cgColor]
                    gradient.name = "bookingGradient"
                    self.fareDataDisplayView.layer.insertSublayer(gradient, at: 0)
                })
                
            }else{
                if let subLayers = fareDataDisplayView.layer.sublayers{
                    if subLayers.count > 0{
                        for layer in subLayers {
                            if layer.name == "bookingGradient" {
                                layer.removeFromSuperlayer()
                            }
                        }
                    }
                }
                
                fareDataDisplayView.backgroundColor = .white
                let gradient = CAGradientLayer()
                gradient.frame = bookingDataDisplayView.bounds
                gradient.frame.size.height = bookingDataDisplayView.frame.height
                
                gradient.startPoint = CGPoint(x: 0, y: 1)
                gradient.endPoint = CGPoint(x: 1, y: 1)
                let colorOne = UIColor(displayP3Red: ( 0.0 / 255.0), green: ( 204.0 / 255.0), blue: ( 153 / 255.0), alpha: 1.0)
                let colorTwo = UIColor(displayP3Red: (41.0/255.0), green: ( 176.0 / 255.0) , blue: ( 182 / 255.0), alpha: 1.0)
                gradient.colors = [colorTwo.cgColor, colorOne.cgColor]
                gradient.name = "fareGradient"
                bookingDataDisplayView.layer.insertSublayer(gradient, at: 0)
            }
        }
    }
    
    func taxesDataDisplay(){
        if journeyCombo != nil{
            taxAndFeesData.removeAll()
            taxesDetails.removeAll()
            taxAndFeesDataDict.removeAll()
            for i in 0...journeyCombo.count-1{
                taxesData = journeyCombo[i].fare
                
                taxesDetails = (taxesData?.taxes.details)!
                
                for (_, value) in taxesDetails.enumerated() {
                    let newObj = taxStruct.init(name: taxesResult[value.key]!, taxVal: value.value)
                    taxAndFeesDataDict.append(newObj)
                }
            }
            
            let newDict = Dictionary(grouping: taxAndFeesDataDict) { $0.name }
            
            for ( key , _ ) in newDict {
                
                let dataArray = newDict[key]
                
                var newTaxVal = 0
                for i in 0..<dataArray!.count{
                    newTaxVal += (dataArray?[i].taxVal)!
                }
                
                let newArr = ["name" : key,
                              "value":newTaxVal] as NSDictionary
                taxAndFeesData.append(newArr)
                
            }
            
            
            let totalFare = journeyCombo.reduce(0) { $0 + $1.farepr }
            
            let price = displayPriceInFormat(price: Double(totalFare), fromOption : "totalAmount")
            totalPayableAmountLabel.attributedText = price
            
            let price1 = displayPriceInFormat(price: Double(totalFare), fromOption : "BookingAmount")
            bookingAmountLabel.attributedText = price1
            
            
            let journey_totalFare = journey.reduce(0) { $0 + $1.farepr }
            let journey_price = displayPriceInFormat(price: Double(journey_totalFare), fromOption : "strikeOutPrice")
                
            journey_price.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, journey_price.length))
            
            journey_price.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.white, range: NSMakeRange(0, journey_price.length))
            
            strikeOutAmountLabel.attributedText = journey_price
            strikeOutAmountLabelTrailing.constant = 8
            
            baseFareTableview.reloadData()
        }else{
            if journey != nil{
                taxAndFeesData.removeAll()
                taxesDetails.removeAll()
                taxAndFeesDataDict.removeAll()
                for i in 0...journey.count-1{
                    taxesData = journey[i].fare
                    
                    taxesDetails = (taxesData?.taxes.details)!
                    
                    for (_, value) in taxesDetails.enumerated() {
                        let newObj = taxStruct.init(name: taxesResult[value.key]!, taxVal: value.value)
                        taxAndFeesDataDict.append(newObj)
                    }
                }
                
                let newDict = Dictionary(grouping: taxAndFeesDataDict) { $0.name }
                
                for ( key , _ ) in newDict {
                    
                    let dataArray = newDict[key]
                    
                    var newTaxVal = 0
                    for i in 0..<dataArray!.count{
                        newTaxVal += (dataArray?[i].taxVal)!
                    }
                    
                    let newArr = ["name" : key,
                                  "value":newTaxVal] as NSDictionary
                    taxAndFeesData.append(newArr)
                    
                }
                
                
                let totalFare = journey.reduce(0) { $0 + $1.farepr }
                
                let price = displayPriceInFormat(price: Double(totalFare), fromOption : "totalAmount")
                totalPayableAmountLabel.attributedText = price
                
                let price1 = displayPriceInFormat(price: Double(totalFare), fromOption : "BookingAmount")
                bookingAmountLabel.attributedText = price1
                
                baseFareTableview.reloadData()
            }
        }

        
        if isUpgradePlanScreenVisible == false{
            upgradeButton.isHidden = false
            upgradeButtonWidth.constant = 32
            bookButtonTrailing.constant = 44
        }else{
            upgradeButton.isHidden = true
            upgradeButtonWidth.constant = 0
            bookButtonTrailing.constant = 16
        }
    }
    
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
            
            if flightAdultCount == 0{
                fareBreakupCell.adultCountDisplayView.isHidden = true
                fareBreakupCell.adultCountDisplayViewWidth.constant = 0
                fareBreakupCell.adultCountLabel.text = ""
            }else{
                fareBreakupCell.adultCountDisplayView.isHidden = false
                fareBreakupCell.adultCountDisplayViewWidth.constant = 25
                fareBreakupCell.adultCountLabel.text = "\(flightAdultCount)"
            }
            
            if flightChildrenCount == 0{
                fareBreakupCell.childrenCountDisplayView.isHidden = true
                fareBreakupCell.childrenCountDisplayViewWidth.constant = 0
                fareBreakupCell.childrenCountLabel.text = ""
            }else{
                fareBreakupCell.childrenCountDisplayView.isHidden = false
                fareBreakupCell.childrenCountDisplayViewWidth.constant = 35
                fareBreakupCell.childrenCountLabel.text = "\(flightChildrenCount)"
            }
            
            if flightInfantCount == 0{
                fareBreakupCell.infantCountDisplayView.isHidden = true
                fareBreakupCell.infantCountDisplayViewWidth.constant = 0
                fareBreakupCell.infantCountLabel.text = ""
            }else{
                fareBreakupCell.infantCountDisplayView.isHidden = false
                fareBreakupCell.infantCountDisplayViewWidth.constant = 35
                fareBreakupCell.infantCountLabel.text = "\(flightInfantCount)"
            }
            
            return fareBreakupCell
            
        case 1:
            let baseFareCell = tableView.dequeueReusableCell(withIdentifier: "BaseFareCell") as! BaseFareTableViewCell
            baseFareCell.selectionStyle = .none
            
            baseFareCell.titleLabelLeading.constant = 16
            
            baseFareCell.titleLabel.text = "Base Fare"
            if taxesData != nil{
                var amount = 0
                if journeyCombo != nil{
                    amount = journeyCombo.reduce(0) { $0 + $1.fare.BF.value }
                }else{
                    amount = journey.reduce(0) { $0 + $1.fare.BF.value }
                }
                
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
                    if journeyCombo != nil{
                        amount = journeyCombo.reduce(0) { $0 + $1.fare.taxes.value }
                    }else{
                        amount = journey.reduce(0) { $0 + $1.fare.taxes.value }
                    }
                    
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
//                    print("taxAndFeesData[\(indexPath.row-1)]=", taxAndFeesData[indexPath.row-1])
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
            // Display few seats left view if fsr != 0
            for i in 0...journey.count-1{
                if journey[i].fsr == 1{
                    isFSR = true
                    if i < journey.count{
                        if i > 0{
                            let i1 = Int(journey[i].seats!)
                            if i+1 < journey.count{
                                if journey[i+1].seats != nil{
                                    let i2 = Int(journey[i+1].seats!)
                                    
                                    if i1 != nil && i2 != nil{
                                        let minVal = min(i1!, i2!)
                                        remainingSeats = "\(minVal)"
                                    }
                                }
                            }else{
                                remainingSeats = "\(i1!)"
                            }
                        }else{
                            remainingSeats = journey[i].seats!
                        }
                    }
                }
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
            
            self.fareDataDisplayViewHeight.constant = 85 + CGFloat(bottomInset!)
            self.bookingDataDisplayViewHeight.constant = 50 + CGFloat(bottomInset!)
        }else{
            fewSeatsLeftView.isHidden = true
            fewSeatsLeftViewHeight.constant = 0
            
            self.fareDataDisplayViewHeight.constant = 50 + CGFloat(bottomInset!)
            self.bookingDataDisplayViewHeight.constant = 50 + CGFloat(bottomInset!)
        }
        
        self.totalPayableViewBottom.constant = bottomInset!
        self.fareDataDisplayViewBottom.constant = bottomInset!
        self.totalPayableView.isHidden = true
        self.totalPayableViewHeight.constant = 0
        self.baseFareTableview.isHidden = true
        self.baseFareTableviewHeight.constant = 0
        
        let viewHeight = self.bookingDataDisplayViewHeight.constant + self.fewSeatsLeftViewHeight.constant
        
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
    
    func displayCollapseView()
    {
        self.isBackgroundVisible = false
        let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
        let screenSize = UIScreen.main.bounds
        
        if fromScreen == "upgradePlanExpand"{
            fromScreen = "upgradePlanCollapse"
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            
//            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
//                self.view.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
//            })
            if self.journey != nil{
                // Display few seats left view if fsr != 0
                var isFSR = false
                for i in 0...self.journey.count-1{
                    if self.journey[i].fsr == 1{
                        isFSR = true
                    }
                }
                
                if isFSR == true{
                    self.fewSeatsLeftView.isHidden = false
                    self.fewSeatsLeftViewHeight.constant = 35
                    
                    self.fareDataDisplayViewHeight.constant = 85 + CGFloat(bottomInset!)
                    self.bookingDataDisplayViewHeight.constant = 50 + CGFloat(bottomInset!)
                }else{
                    self.fewSeatsLeftView.isHidden = true
                    self.fewSeatsLeftViewHeight.constant = 0
                    
                    self.fareDataDisplayViewHeight.constant = 50 + CGFloat(bottomInset!)
                    self.bookingDataDisplayViewHeight.constant = 50 + CGFloat(bottomInset!)
                }
            }
            
            self.totalPayableViewBottom.constant = bottomInset!
            if self.isFromFlightDetails == true{
                self.fareDataDisplayViewBottom.constant = bottomInset!//0
            }else{
                self.fareDataDisplayViewBottom.constant = 0
            }
            self.totalPayableView.isHidden = true
            self.totalPayableViewHeight.constant = 0
            self.baseFareTableview.isHidden = true
            self.baseFareTableviewHeight.constant = 0
            
            
            self.view.layoutSubviews()
            self.view.setNeedsLayout()
        },completion: { _ in
            let viewHeight = self.bookingDataDisplayViewHeight.constant + self.fewSeatsLeftViewHeight.constant
            
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
                self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight-CGFloat(bottomInset!), width: screenSize.width, height:viewHeight + CGFloat(bottomInset!))
            }
        })
    }
    
    func displayExpandedView(fromSelection:String)
    {
        var sectionHeight = 0
        if fromSelection == "info"{
            isTaxesSectionHidden = true
            baseFareTableview.reloadData()
        }

        if isTaxesSectionHidden == true{
            baseFareTableview.bounces = false
            baseFareTableview.alwaysBounceVertical = false
            sectionHeight = self.baseFareTableview.numberOfSections * 34
        }else{
            baseFareTableview.bounces = true
            baseFareTableview.alwaysBounceVertical = true
            sectionHeight = self.baseFareTableview.numberOfSections * 37
        }

        var cellHeight = 0

        if self.baseFareTableview.numberOfRows(inSection: 2) == 2{
            cellHeight = 24
        }else{
            let cellsCount = self.baseFareTableview.numberOfRows(inSection: 2)
            cellHeight = (cellsCount-2) * 24
        }

        var totalHeight = 0
        let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom

        if isTaxesSectionHidden == false{
            totalHeight = sectionHeight + cellHeight + Int(bottomInset!) + 17
        }else{
            totalHeight = sectionHeight + Int(bottomInset!)
        }

        if totalHeight > 404{
            totalHeight = 404
        }

        if self.journey != nil{
            // Display few seats left view if fsr != 0
            var isFSR = false
            for i in 0...self.journey.count-1{
                if self.journey[i].fsr == 1{
                    isFSR = true
                }
            }

            if isFSR == true{
                self.fewSeatsLeftView.isHidden = false
                self.fewSeatsLeftViewHeight.constant = 35

                if bottomInset == 0{
                    self.fareDataDisplayViewHeight.constant = CGFloat(totalHeight+143)
                }else{
                    self.fareDataDisplayViewHeight.constant = CGFloat(totalHeight+110+Int(bottomInset!))
                }
            }else{
                self.fewSeatsLeftView.isHidden = true
                self.fewSeatsLeftViewHeight.constant = 0

                if bottomInset == 0{
                    self.fareDataDisplayViewHeight.constant = CGFloat(totalHeight+108)
                }else{
                    self.fareDataDisplayViewHeight.constant = CGFloat(totalHeight+75+Int(bottomInset!))
                }
            }
        }

        self.bookingDataDisplayViewHeight.constant = 50
        self.totalPayableView.isHidden = false
        self.totalPayableViewHeight.constant = 50
        self.totalPayableViewBottom.constant = bottomInset!
        self.baseFareTableview.isHidden = false
        self.baseFareTableviewHeight.constant = 50
        self.fareDataDisplayViewBottom.constant = 40

        switch UIScreen.main.bounds.height{
        case 568: //iPhone SE | 5S
            if isFromFlightDetails == true{
                if #available(iOS 13.0, *) {
                    self.fareDataDisplayViewBottom.constant = 40
                }else{
                    self.fareDataDisplayViewBottom.constant = 0
                }
            }else{
                self.fareDataDisplayViewBottom.constant = 0
            }
            break

        case 667: //iPhone 8 | 6 | 6s | 7
            if isFromFlightDetails == true{
                if #available(iOS 13.0, *) {
                    self.fareDataDisplayViewBottom.constant = 40
                }else{
                    self.fareDataDisplayViewBottom.constant = 0
                }
            }else{
                self.fareDataDisplayViewBottom.constant = 0
            }
            break

        case 736: //iPhone 6 Plus | 8 plus | 6s plus | 7 Plus
            if isFromFlightDetails == true{
                if #available(iOS 13.0, *) {
                    self.fareDataDisplayViewBottom.constant = 40
                }else{
                    self.fareDataDisplayViewBottom.constant = 0
                }
            }else{
                self.fareDataDisplayViewBottom.constant = 0
            }
            break

        case 812: //11 Pro | X | Xs
            if isFromFlightDetails == true{
                if #available(iOS 13.0, *) {
                    self.fareDataDisplayViewBottom.constant = 50
                }else{
                    self.fareDataDisplayViewBottom.constant = 0
                }
            }else{
                self.fareDataDisplayViewBottom.constant = 0
            }
            break

        case 896: //11 & 11 Pro Max & Xs Max & Xr
            if isFromFlightDetails == true{
                if #available(iOS 13.0, *) {
                    self.fareDataDisplayViewBottom.constant = 55
                }else{
                    self.fareDataDisplayViewBottom.constant = 0
                }
            }else{
                self.fareDataDisplayViewBottom.constant = 0
            }
            break

        default :
            self.fareDataDisplayViewBottom.constant = 0
            break
        }

        self.bookingInfoArrowImg.image = UIImage(named: "down.png")
        if self.isBackgroundVisible == false{
            self.view.backgroundColor = .clear
            self.isBackgroundVisible = true
        }

        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height)

            self.view.layoutSubviews()
            self.view.setNeedsLayout()
        })
    }
    
    //MARK:- Guesture
    func setupSwipeDownGuesture(){
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(panGestureRecognizerHandler(_:)))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch: UITouch? = touches.first
        if touch?.view == backgroundDisplayView {
            infoButtonTapped()
        }
    }
    
    //MARK:- Button Action
    @IBAction func upgradeButtonClicked(_ sender: Any)
    {
        let upgradePlanBaseVC = UpgradePlanBaseVC(nibName: "UpgradePlanBaseVC", bundle: nil)
        upgradePlanBaseVC.taxesResult = self.taxesResult
        upgradePlanBaseVC.selectedJourneyFK = selectedJourneyFK
        upgradePlanBaseVC.journey = self.journey
        upgradePlanBaseVC.journeyCombo = self.journeyCombo
        upgradePlanBaseVC.sid = self.sid
        upgradePlanBaseVC.fare = bookingAmountLabel.text!
        upgradePlanBaseVC.flightAdultCount = flightAdultCount
        upgradePlanBaseVC.flightChildrenCount = flightChildrenCount
        upgradePlanBaseVC.flightInfantCount = flightInfantCount
        upgradePlanBaseVC.fewSeatsLeftViewHeight = fewSeatsLeftViewHeightFromFlightDetails
        self.present(upgradePlanBaseVC, animated: true, completion: nil)
    }
    
    @IBAction func bookButtonClicked(_ sender: Any) {
        self.delegate?.bookButtonTapped(journeyCombo:journeyCombo)
    }
    
    @IBAction func infoButtonClicked(_ sender: Any)
    {
        infoButtonTapped()
    }
    
    @objc func infoButtonTapped(){
        if fromScreen != "upgradePlan"{

            if isInfoViewHidden == false
            {
                self.isFareBreakupExpanded = true
                displayExpandedView(fromSelection: "info")
                self.delegate?.infoButtonTapped(isViewExpanded: true)

            }else{
                self.isFareBreakupExpanded = false
                displayCollapseView()
                self.bookingInfoArrowImg.image = UIImage(named: "up.png")
                self.delegate?.infoButtonTapped(isViewExpanded: false)

            }
            
            isInfoViewHidden = !isInfoViewHidden

        }
    }
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view?.window)
        var initialTouchPoint = CGPoint.zero
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                view.frame.origin.y = touchPoint.y - initialTouchPoint.y
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 200 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        case .failed, .possible:
            break
            
        default:break
        }
    }
    
    //MARK:- Price Formatting
    func displayPriceInFormat(price:Double, fromOption:String) -> NSMutableAttributedString{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_IN")
        let result = formatter.string(from: NSNumber(value: price))
        
        var fontSize = 10
        var fontSizeSuper = 10
        
        var displayFont = "SourceSansPro-Regular"
        var displayFontSuper = "SourceSansPro-Regular"
        
        if fromOption == "FareAmount"{
            fontSize = 16
            fontSizeSuper = 10
            
            displayFont = "SourceSansPro-Regular"
            displayFontSuper = "SourceSansPro-Regular"
        }else if fromOption == "BookingAmount"{
            fontSize = 18
            fontSizeSuper = 12
            
            displayFont = "SourceSansPro-SemiBold"
            displayFontSuper = "SourceSansPro-SemiBold"
        }else if fromOption == "totalAmount"{
            fontSize = 20
            fontSizeSuper = 14
            
            displayFont = "SourceSansPro-SemiBold"
            displayFontSuper = "SourceSansPro-SemiBold"
        }else if fromOption == "strikeOutPrice"{
            fontSize = 12
            fontSizeSuper = 10
            
            displayFont = "SourceSansPro-Regular"
            displayFontSuper = "SourceSansPro-Regular"

        }
        
        let font:UIFont? = UIFont(name: displayFont, size:CGFloat(fontSize))
        let fontSuper:UIFont? = UIFont(name: displayFontSuper, size:CGFloat(fontSizeSuper))
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: result!, attributes: [.font:font!])
        attString.setAttributes([.font:fontSuper!,.baselineOffset:7], range: NSRange(location:result!.count-3,length:3))
        if attString.string.contains(find: ".00"){
            attString.mutableString.replaceOccurrences(of: ".00", with: "", options: .caseInsensitive, range: NSRange(location:result!.count-3,length:3))
        }
        return attString
    }
}