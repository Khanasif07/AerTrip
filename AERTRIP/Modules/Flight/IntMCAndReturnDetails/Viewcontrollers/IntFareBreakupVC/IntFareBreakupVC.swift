//
//  IntFareBreakupVC.swift
//  Aertrip
//
//  Created by Apple  on 22.04.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

protocol JourneyDetailsTapDelegate: NSObjectProtocol {
    func tappedDetailsButton()
    func updateHeight(to height: CGFloat)
}


class IntFareBreakupVC: BaseVC {
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

    @IBOutlet weak var strikeOutAmountLabel: UILabel!
    @IBOutlet weak var strikeOutAmountLabelTrailing: NSLayoutConstraint!
    @IBOutlet weak var bookingAmountLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bookingInfoArrowImg: UIImageView!
    
    @IBOutlet weak var bookButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var bookingView: UIView!
    @IBOutlet weak var bookingDataDisplayView: UIView!
    @IBOutlet weak var bookingDataDisplayViewHeight: NSLayoutConstraint!
   
    @IBOutlet weak var bookingTitleAndDateView: UIView!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var bookingTitleLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var bookingtitleAndDateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bookingTitleAndDateStack: UIStackView!
    @IBOutlet weak var BookingTitleStackTrailing: NSLayoutConstraint!
    @IBOutlet weak var bookingTitleStackTopContraint: NSLayoutConstraint!
    @IBOutlet weak var bookingTitleStackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var deviderView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    
    
    //MARK:- Variable Declaration
    var taxesResult : [String : String]!
    var intFlights : [IntFlightDetail]?
    var journey: [IntJourney]!
    var journeyCombo: [CombinationJourney]!

    var taxesData : IntTaxes?
    var taxesDetails : [String:Int] = [String:Int]()
    var taxAndFeesData = [JSONDictionary]()
    var taxAndFeesDataDict = [taxStruct]()
    
    var isTaxesSectionHidden = true
    var isInfoViewHidden = false
    var isUpgradePlanScreenVisible = false
    var isFewSeatsLeftViewVisible = false
    var isFromFlightDetails = false
    var isCheckoutDetails = false
    var bookFlightObject = BookFlightObject()
    var intAirportDetailsResult : [String : IntAirportDetailsWS]!
    var intAirlineDetailsResult : [String : IntAirlineMasterWS]!
    var journeyTitle:NSAttributedString?
    var journeyDate:String?
    var sid = ""
    var fromScreen = ""
    var isFareBreakupExpanded = false
    var isBackgroundVisible = false
    var isHideUpgradeOption = true
    var selectedJourneyFK = [String]()
    var fewSeatsLeftViewHeightFromFlightDetails = 0
    var isForSelectionAndCheckout:Bool = false
    var heightForBookingTitleView:CGFloat{
        if self.isForSelectionAndCheckout{
            if self.bookFlightObject.flightSearchType == MULTI_CITY{
                return 60.0
            }else{
                return 44.0
            }
        }else{
            return 0.0
        }
    }
    
    weak var delegate: FareBreakupVCDelegate?
    weak var detailsDelegate: JourneyDetailsTapDelegate?
    
    
    //Added for addons
    var addonsData = [String:Int]()
    var isAddonsExpend = true
    var bookButtonTitle = "Book"
    
    //MARK:- Initialise Views
    override func viewDidLoad(){
        super.viewDidLoad()
        self.baseFareTableview.delegate = self
        self.baseFareTableview.dataSource = self
        setupBookingTitleDateView()
        baseFareTableview.register(UINib(nibName: "FareBreakupTableViewCell", bundle: nil), forCellReuseIdentifier: "FareBreakupCell")
        baseFareTableview.register(UINib(nibName: "BaseFareTableViewCell", bundle: nil), forCellReuseIdentifier: "BaseFareCell")
        
        backgroundDisplayView.backgroundColor = .clear
        remainingSeatsCountLabel.layer.cornerRadius = remainingSeatsCountLabel.frame.width/2
        initialDisplayView()
        taxesDataDisplay()
        self.setupUpgradeButton(isHidden: self.isHideUpgradeOption)
        //        setupSwipeDownGuesture()
        self.manageLoader()
//        if fromScreen == "upgradePlan" {
//            infoLabel.isHidden = true
//            bookingInfoArrowImg.isHidden = true
//        }else{
            infoLabel.isHidden = false
            bookingInfoArrowImg.isHidden = false
//        }
    }
    
    override func viewDidLayoutSubviews(){
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
            
            bookingDataDisplayView.removeGredient()
            fromScreen = "upgradePlan"

        }else if fromScreen == "upgradePlan" {
            self.view.backgroundColor = .clear
            
            if isFareBreakupExpanded == true{
                self.fareDataDisplayView.backgroundColor = .white
//                let gradient = CAGradientLayer()
//                gradient.frame = bookingDataDisplayView.bounds
//                gradient.frame.size.height = bookingDataDisplayView.frame.height
//
//                gradient.startPoint = CGPoint(x: 0, y: 1)
//                gradient.endPoint = CGPoint(x: 1, y: 1)
//                let colorOne = UIColor(displayP3Red: ( 0.0 / 255.0), green: ( 204.0 / 255.0), blue: ( 153 / 255.0), alpha: 1.0)
//                let colorTwo = UIColor(displayP3Red: (41.0/255.0), green: ( 176.0 / 255.0) , blue: ( 182 / 255.0), alpha: 1.0)
//                gradient.colors = [colorTwo.cgColor, colorOne.cgColor]
//                gradient.name = "bookingGradient"
//                bookingDataDisplayView.layer.insertSublayer(gradient, at: 0)
                bookingDataDisplayView.addGredient(isVertical: false)
            }else{
//                self.fareDataDisplayView.backgroundColor = .clear
                /*
                if let subLayers = bookingDataDisplayView.layer.sublayers{
                    if subLayers.count > 0{
                        for layer in subLayers {
                            if layer.name == "bookingGradient" {
                                layer.removeFromSuperlayer()
                            }
                        }
                    }
                }
                */
//                bookingDataDisplayView.removeGredient()
            }
        }else{
            bookingDataDisplayView.frame.size.width = self.view.frame.width
            
            if isFareBreakupExpanded == false{
                
                UIView.animate(withDuration: 0.2, delay: 0.1, options: [.curveEaseOut], animations: {[weak self] in
                    guard let self = self else {return}
                    /*
                    let gradient = CAGradientLayer()
                    gradient.frame = self.fareDataDisplayView.bounds
                    let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
                    gradient.frame.size.height = self.fareDataDisplayView.frame.height+bottomInset
                    
                    gradient.startPoint = CGPoint(x: 0, y: 1)
                    gradient.endPoint = CGPoint(x: 1, y: 1)
                    let colorOne = AppColors.themeGreen
                    let colorTwo = UIColor(displayP3Red: (41.0/255.0), green: ( 176.0 / 255.0) , blue: ( 182 / 255.0), alpha: 1.0)
                    gradient.colors = [colorTwo.cgColor, colorOne.cgColor]
                    gradient.name = "bookingGradient"
                    self.fareDataDisplayView.layer.insertSublayer(gradient, at: 0)
 */
                    self.fareDataDisplayView.addGredient(isVertical: false)
                })
                
            }else{
                /*
                if let subLayers = fareDataDisplayView.layer.sublayers{
                    if subLayers.count > 0{
                        for layer in subLayers {
                            if layer.name == "bookingGradient" {
                                layer.removeFromSuperlayer()
                            }
                        }
                    }
                }
                */
                fareDataDisplayView.removeGredient()

                fareDataDisplayView.backgroundColor = .white
                /*
                let gradient = CAGradientLayer()
                gradient.frame = bookingDataDisplayView.bounds
                gradient.frame.size.height = bookingDataDisplayView.frame.height
                
                gradient.startPoint = CGPoint(x: 0, y: 1)
                gradient.endPoint = CGPoint(x: 1, y: 1)
                let colorOne = AppColors.themeGreen
                let colorTwo = UIColor(displayP3Red: (41.0/255.0), green: ( 176.0 / 255.0) , blue: ( 182 / 255.0), alpha: 1.0)
                gradient.colors = [colorTwo.cgColor, colorOne.cgColor]
                gradient.name = "fareGradient"
                bookingDataDisplayView.layer.insertSublayer(gradient, at: 0)
    */
                self.bookingDataDisplayView.addGredient(isVertical: false)
            }
        }
    }
    
    func setupBookingTitleDateView(){
        self.bookingtitleAndDateViewHeight.constant = self.heightForBookingTitleView
        if self.isForSelectionAndCheckout{
            self.bookButton.setTitle("Continue", for: .normal)
            self.bookButtonTitle = "Continue"
            self.bookingTitleAndDateView.isHidden = false
            self.detailsButton.setTitle("Details", for: .normal)
            self.detailsButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
            self.detailsButton.setTitleColor(AppColors.themeGreen, for: .normal)
            self.bookingTitleLabel.attributedText = self.getTitleToshow()//self.bookFlightObject.titleString
            self.bookingDateLabel.textColor = AppColors.themeGray60
            self.bookingDateLabel.font = AppFonts.Regular.withSize(18.0)
            self.bookingDateLabel.text = self.creaateDateTitle()
            if self.bookFlightObject.flightSearchType == MULTI_CITY{
                self.BookingTitleStackTrailing.constant = 30
                self.bookingTitleAndDateStack.axis = .vertical
                self.bookingTitleStackTopContraint.constant = 6
                self.bookingTitleStackBottomConstraint.constant = 6
            }else{
                self.BookingTitleStackTrailing.constant = 30.0
                self.bookingTitleAndDateStack.axis = .horizontal
                self.bookingTitleStackTopContraint.constant = 0
                self.bookingTitleStackBottomConstraint.constant = 0
            }
        }else{
            self.bookingTitleAndDateView.isHidden = true
            bookButtonTitle = "Book"
            if self.isCheckoutDetails{
                self.bookButton.setTitle("Continue", for: .normal)
                bookButtonTitle = "Continue"
            }
        }
    }
    
    private func creaateDateTitle()-> String{
        guard let date = self.bookFlightObject.subTitleString.components(separatedBy: " •").first else{return ""}
            return date
    }
    
    private func getTitleToshow()-> NSAttributedString{
        if let mutableStr = self.bookFlightObject.titleString.mutableCopy() as? NSMutableAttributedString{
            let comma = NSAttributedString.init(string: ", ", attributes: [.font:AppFonts.Regular.withSize(18), .foregroundColor: AppColors.themeBlack])
            if self.bookFlightObject.flightSearchType == MULTI_CITY{
                return mutableStr
            }else{
                mutableStr.append(comma)
                return mutableStr
            }
        }else{
            return self.bookFlightObject.titleString
        }
        
    }
    
    func setupUpgradeButton(isHidden: Bool){
        self.upgradeButton.isHidden = isHidden
        self.deviderView.isHidden = isHidden
        self.bookButtonTrailing.constant = (isHidden) ? 16 : 44
    }
    
    private func manageLoader() {
        self.indicator.style = .white
        self.indicator.color = AppColors.themeWhite
        self.indicator.startAnimating()
        self.hideShowLoader(isHidden:true)
    }
    
    func hideShowLoader(isHidden:Bool){
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {return}
            if isHidden{
                self.indicator.stopAnimating()
                self.bookButton.setTitle(self.bookButtonTitle, for: .normal)
            }else{
                self.bookButton.setTitle("", for: .normal)
                self.indicator.startAnimating()
            }
        }
    }
    
    func reloadData(){
        self.taxesDataDisplay()
    }
    
    @IBAction func tapDetailsBtn(_ sender: UIButton) {
        
        self.detailsDelegate?.tappedDetailsButton()
    }
    
    @IBAction func tappedUpgradeButton(_ sender: UIButton) {
        self.delegate?.tapUpgradeButton()
    }
    func setPassengerCount(){
    }
    
    func reloadDataForAddons(){
        self.taxesDataDisplay()
        self.baseFareTableview.reloadData()
    }
    
    func taxesDataDisplay(){
        if journey != nil{
            taxAndFeesData.removeAll()
            taxesDetails.removeAll()
            taxAndFeesDataDict.removeAll()
            taxesData = journey.first?.fare
            var sortOrderArray = [String]()
            taxesDetails = (taxesData?.taxes.details)!
            
            for val in (taxesData?.sortOrder ?? "").components(separatedBy: ","){
                sortOrderArray.append(taxesResult[val.removeAllWhitespaces] ?? "")
            }
            
            for (_, value) in taxesDetails.enumerated() {
                let newObj = taxStruct.init(name: taxesResult[value.key]!, taxVal: value.value)
                taxAndFeesDataDict.append(newObj)
            }
            let newDict = Dictionary(grouping: taxAndFeesDataDict) { $0.name }
            if sortOrderArray.isEmpty{
                for ( key , _ ) in newDict {
                    
                    let dataArray = newDict[key]
                    
                    var newTaxVal = 0
                    for i in 0..<dataArray!.count{
                        newTaxVal += (dataArray?[i].taxVal)!
                    }
                    
                    let newArr = ["name" : key,
                                  "value":newTaxVal] as JSONDictionary
                    taxAndFeesData.append(newArr)
                    
                }
            }else{
                for key in sortOrderArray {
                    
                    let dataArray = newDict[key]
                    
                    var newTaxVal = 0
                    for i in 0..<dataArray!.count{
                        newTaxVal += (dataArray?[i].taxVal)!
                    }
                    
                    let newArr = ["name" : key,
                                  "value":newTaxVal] as JSONDictionary
                    taxAndFeesData.append(newArr)
                    
                }
            }
            let addonsPrice = self.addonsData.reduce(0){$0 + $1.value}
            let totalFare = (journey.first?.farepr ?? 0) + addonsPrice
            
            let price = displayPriceInFormat(price: Double(totalFare), fromOption : "totalAmount")
            totalPayableAmountLabel.attributedText = price
            
            let price1 = displayPriceInFormat(price: Double(totalFare), fromOption : "BookingAmount")
            bookingAmountLabel.attributedText = price1
            
            baseFareTableview.reloadData()
            
        }
    }
    
    
    
    func displayCollapseView()
    {
        self.isBackgroundVisible = false
        let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        let screenSize = UIScreen.main.bounds
        
        if fromScreen == "upgradePlanExpand"{
            fromScreen = "upgradePlanCollapse"
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {[weak self] in
            guard let self = self else {return}
            
            if self.journey != nil{
                // Display few seats left view if fsr != 0
                if ((self.journey.first?.fsr ?? 0) == 1) && (self.fromScreen != "upgradePlan"){
                    self.fewSeatsLeftView.isHidden = false
                    self.fewSeatsLeftViewHeight.constant = 35
                    self.fareDataDisplayViewHeight.constant = 85 + CGFloat(bottomInset) + self.heightForBookingTitleView
                    self.bookingDataDisplayViewHeight.constant = 50 + CGFloat(bottomInset)
                }else{
                    self.fewSeatsLeftView.isHidden = true
                    self.fewSeatsLeftViewHeight.constant = 0
                    self.fareDataDisplayViewHeight.constant = 50 + CGFloat(bottomInset) + self.heightForBookingTitleView
                    self.bookingDataDisplayViewHeight.constant = 50 + CGFloat(bottomInset)
                }
            }
            
            self.totalPayableViewBottom.constant = bottomInset
            if self.isFromFlightDetails{
                self.fareDataDisplayViewBottom.constant = bottomInset//0
            }else{
                self.fareDataDisplayViewBottom.constant = 0
            }
            self.totalPayableView.isHidden = true
            self.totalPayableViewHeight.constant = 0
            self.baseFareTableview.isHidden = true
            self.baseFareTableviewHeight.constant = 0
            
            let viewHeight = self.bookingDataDisplayViewHeight.constant + self.fewSeatsLeftViewHeight.constant + self.heightForBookingTitleView
            
            if self.isFromFlightDetails{
                switch UIScreen.main.bounds.height{
                case 568: //iPhone SE | 5S
                    if #available(iOS 13.0, *) {
                        self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight-40, width: screenSize.width, height:viewHeight + CGFloat(bottomInset))
                    }else{
                        self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight, width: screenSize.width, height:viewHeight + CGFloat(bottomInset))
                    }
                    break
                    
                case 667: //iPhone 8 | 6 | 6s | 7
                    if #available(iOS 13.0, *) {
                        self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight-40, width: screenSize.width, height:viewHeight + CGFloat(bottomInset))
                    }else{
                        self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight, width: screenSize.width, height:viewHeight + CGFloat(bottomInset))
                    }
                    break
                    
                case 736: //iPhone 6 Plus | 8 plus | 6s plus | 7 Plus
                    if #available(iOS 13.0, *) {
                        self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight-40, width: screenSize.width, height:viewHeight + CGFloat(bottomInset))
                    }else{
                        self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight, width: screenSize.width, height:viewHeight + CGFloat(bottomInset))
                    }
                    break
                    
                case 812: //11 Pro | X | Xs
                    if #available(iOS 13.0, *) {
                        self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight - 54, width: screenSize.width, height:viewHeight + CGFloat(bottomInset))
                    }else{
                        self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight, width: screenSize.width, height:viewHeight + CGFloat(bottomInset))
                    }
                    break
                    
                case 896: //11 & 11 Pro Max & Xs Max & Xr
                    if #available(iOS 13.0, *) {
                        self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight - 54, width: screenSize.width, height:viewHeight + CGFloat(bottomInset))
                    }else{
                        self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight, width: screenSize.width, height:viewHeight + CGFloat(bottomInset))
                    }
                    break
                    
                default :
                    break
                }
            }else{
                self.view.frame = CGRect(x: 0, y: screenSize.height-viewHeight-CGFloat(bottomInset), width: screenSize.width, height:viewHeight + CGFloat(bottomInset))
            }
            self.view.layoutSubviews()
            self.view.setNeedsLayout()
        },completion:{_ in
            if self.fromScreen == "upgradePlan"{
                self.bookingDataDisplayView.removeGredient()
                self.fareDataDisplayView.backgroundColor = .clear
            }
        })
        
        if ((self.journey.first?.fsr ?? 0) == 1){
            self.detailsDelegate?.updateHeight(to: 85 + CGFloat(bottomInset) + self.heightForBookingTitleView)
        }else{
            self.detailsDelegate?.updateHeight(to: 50 + CGFloat(bottomInset) + self.heightForBookingTitleView)
        }
        
    }
    
    func displayExpandedView(fromSelection:String)
    {
        var sectionHeight = 0
        if fromSelection == "info"{
            isTaxesSectionHidden = true
            baseFareTableview.reloadData()
        }

        if isTaxesSectionHidden{
            baseFareTableview.bounces = false
            baseFareTableview.alwaysBounceVertical = false
            sectionHeight = self.baseFareTableview.numberOfSections * 34
        }else{
            baseFareTableview.bounces = true
            baseFareTableview.alwaysBounceVertical = true
            sectionHeight = self.baseFareTableview.numberOfSections * 37
        }

        var cellHeight = 0
        var totalAddonsCellHeight = 0
        var extraSpace = 17
        if self.baseFareTableview.numberOfRows(inSection: 2) == 2{
            cellHeight = 24
            extraSpace = -5
        }else{
            let cellsCount = self.baseFareTableview.numberOfRows(inSection: 2)
            cellHeight = (cellsCount-2) * 24
            if ((cellsCount-2) < 2){
                extraSpace = -5
            }
        }
        
        if self.addonsData.count != 0{
            if self.baseFareTableview.numberOfRows(inSection: 3) == 2{
                totalAddonsCellHeight = 24
            }else{
                let cellsCount = self.baseFareTableview.numberOfRows(inSection: 3)
                totalAddonsCellHeight = (cellsCount-2) * 24
            }
            extraSpace = 17
        }

        var totalHeight = 0
        let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        
        if !isTaxesSectionHidden{
            totalHeight = sectionHeight + cellHeight + Int(bottomInset) + extraSpace
        }else{
            totalHeight = sectionHeight + Int(bottomInset)
        }
        if !self.isAddonsExpend{
            totalHeight += totalAddonsCellHeight
        }
        let thresoldHeight = (addonsData.count == 0) ? 404 : 470
        if totalHeight > thresoldHeight{
            totalHeight = thresoldHeight
        }

        if self.journey != nil{
            // Display few seats left view if fsr != 0
            var isFSR = false
            for i in 0...self.journey.count-1{
                if self.journey[i].fsr == 1{
                    isFSR = true
                }
            }

            if isFSR == true && (self.fromScreen != "upgradePlan"){
                self.fewSeatsLeftView.isHidden = false
                self.fewSeatsLeftViewHeight.constant = 35

                if bottomInset == 0{
                    self.fareDataDisplayViewHeight.constant = CGFloat(totalHeight+143) + heightForBookingTitleView
                }else{
                    self.fareDataDisplayViewHeight.constant = CGFloat(totalHeight+110+Int(bottomInset)) + heightForBookingTitleView
                }
            }else{
                self.fewSeatsLeftView.isHidden = true
                self.fewSeatsLeftViewHeight.constant = 0

                if bottomInset == 0{
                    self.fareDataDisplayViewHeight.constant = CGFloat(totalHeight+108) + heightForBookingTitleView
                }else{
                    self.fareDataDisplayViewHeight.constant = CGFloat(totalHeight+75+Int(bottomInset)) + heightForBookingTitleView
                }
            }
        }

        self.bookingDataDisplayViewHeight.constant = 50
        self.totalPayableView.isHidden = false
        self.totalPayableViewHeight.constant = 50
        self.totalPayableViewBottom.constant = bottomInset
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
        let hightOfView = UIScreen.main.bounds.height//(!isForSelectionAndCheckout) ? UIScreen.main.bounds.height : self.fareDataDisplayViewHeight.constant
        let y = UIScreen.main.bounds.height - hightOfView
        self.detailsDelegate?.updateHeight(to: hightOfView)
        
//        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {[weak self] in
//            guard let self = self else {return}
//            self.view.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: hightOfView)
//
//            self.view.layoutSubviews()
//            self.view.setNeedsLayout()
//        })
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height)

            self.view.layoutIfNeeded()
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
    
    @IBAction func bookButtonClicked(_ sender: Any) {
        self.delegate?.bookButtonTapped(journeyCombo:journeyCombo)
    }
    
    @IBAction func infoButtonClicked(_ sender: Any)
    {
        infoButtonTapped()
    }
    
    @objc func infoButtonTapped(){
//        if fromScreen != "upgradePlan"{
            
            if !isInfoViewHidden{
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
            
//        }
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
        if let result = formatter.string(from: NSNumber(value: price)){
            var fontSize = 10
            var fontSizeSuper = 10

            var displayFont = AppFonts.Regular.rawValue
            var displayFontSuper = AppFonts.Regular.rawValue

            if fromOption == "FareAmount"{
                fontSize = 16
                fontSizeSuper = 10
                
                displayFont = AppFonts.Regular.rawValue
                displayFontSuper = AppFonts.Regular.rawValue
            }else if fromOption == "BookingAmount"{
                fontSize = 18
                fontSizeSuper = 12
                
                displayFont = AppFonts.SemiBold.rawValue
                displayFontSuper = AppFonts.SemiBold.rawValue
            }else if fromOption == "totalAmount"{
                fontSize = 20
                fontSizeSuper = 14
                
                displayFont = AppFonts.SemiBold.rawValue
                displayFontSuper = AppFonts.SemiBold.rawValue
            }else if fromOption == "strikeOutPrice"{
                fontSize = 12
                fontSizeSuper = 10
                
                displayFont = AppFonts.Regular.rawValue
                displayFontSuper = AppFonts.Regular.rawValue

            }
            
            let font:UIFont? = UIFont(name: displayFont, size:CGFloat(fontSize))
            let fontSuper:UIFont? = UIFont(name: displayFontSuper, size:CGFloat(fontSizeSuper))
            let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
            attString.setAttributes([.font:fontSuper!,.baselineOffset:7], range: NSRange(location:result.count-3,length:3))
            if attString.string.contains(find: ".00"){
                attString.mutableString.replaceOccurrences(of: ".00", with: "", options: .caseInsensitive, range: NSRange(location:result.count-3,length:3))
            }
            return attString
        }else{
            return NSMutableAttributedString(string: "\(price)")
        }
    }
}
