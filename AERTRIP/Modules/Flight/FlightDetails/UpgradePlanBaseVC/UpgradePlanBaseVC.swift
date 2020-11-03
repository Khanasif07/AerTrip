//
//  UpgradePlanBaseVC.swift
//  Aertrip
//
//  Created by Monika Sonawane on 01/10/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//


import UIKit
import Parchment

class UpgradePlanBaseVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIScrollViewDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var journeyNameView: UIView!
    @IBOutlet weak var blurViewTop: NSLayoutConstraint!
    @IBOutlet weak var blurViewBottom: NSLayoutConstraint!
    @IBOutlet weak var grabberView: UIView!
    @IBOutlet weak var dataDisplayView: UIView!
    @IBOutlet weak var dataDisplayViewTop: NSLayoutConstraint!
    @IBOutlet weak var dataDisplayViewBottom: NSLayoutConstraint!
    @IBOutlet weak var journeyNameDisplayView: UIView!
    @IBOutlet weak var journeyNameDisplayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var journeyPageControl: UIPageControl!
    @IBOutlet weak var planDisplayView: UIView!
    @IBOutlet weak var planDisplayViewTop: NSLayoutConstraint!
    @IBOutlet weak var planCollectionView: UICollectionView!
    @IBOutlet weak var planCollectionViewBottom: NSLayoutConstraint!
    @IBOutlet weak var noDataFoundView: UIView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    //MARK:- Variable Declaration
    var oldJourney: [Journey]!
    var updatedJourneyArray: [Journey]!
    var journeyCombo: [CombinationJourney]!
    
    var taxesResult : [String : String]!
    var headerSegmentView: HMSegmentedControl!
    
    var sid = ""
    var fk = ""
    var fare = ""
    var selectedPlanIndex = -1
    var isNewSubPoint = false
    
    var thisWidth = 0
    var selectedLocationIndex = 0
    //    var upgardeResult = NSArray()
    var apiResp = [NSArray]()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    let cellScale : CGFloat = 0.92
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    var selectedJourneyFK = [String]()
    
    let fareBreakupVC = FareBreakupVC(nibName: "FareBreakupVC", bundle: nil)
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    let clearCache = ClearCache()
    var selectedFareName = ""
    var selectedFareAmount = -1
    var isFirstJourneyHasFareResp = false
    var newTestDict = [[String:NSArray]]()
    var isCallForFirstTime = false
    var selectButtonTitle = "Select"
    var isNewPlanSelected = false
    var selectedPlanFare = [Int]()
    //    var isCellAnimated = false
    var isInitialJourneySelected = true
    
    fileprivate var parchmentView : PagingViewController?
    var allTabsStr = [""]
    
    
    //MARK:- Initialise Views
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        clearCache.checkTimeAndClearUpgradeDataCache()
        self.planDisplayView.isHidden = true
        self.noDataFoundView.isHidden = true
        
        grabberView.layer.cornerRadius = 2
        
        planCollectionView.register( UINib(nibName: "PlansCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "plansCell")
        
        journeyPageControl.hidesForSinglePage = true
        journeyPageControl.currentPage = 0
        
        setupFarebreakupView()
        setupNoDataFoundView()
        
        DispatchQueue.main.async {
            if self.oldJourney != nil{
                self.updatedJourneyArray = self.oldJourney
                self.allTabsStr.removeAll()
            }
            
            
            if self.updatedJourneyArray != nil{
                self.setupDisplayView()

                self.updatedJourneyArray = self.updatedJourneyArray.filter(){$0.airlinesSubString != "AirAsia India"}

                for i in 0..<self.updatedJourneyArray.count{
                                        
                    self.selectedPlanFare.append(self.updatedJourneyArray[i].farepr)
                    self.apiResp.append(NSArray())
                    
                    let flight = self.updatedJourneyArray![i]
                    let jouneyText = flight.ap[0] + " → " + flight.ap[1]
                    self.allTabsStr.append(jouneyText)
                    self.parchmentView?.reloadData()
                    self.parchmentView?.reloadMenu()
                }
                
                if self.updatedJourneyArray.count < 2{
                    self.journeyNameDisplayView.isHidden = true
                    self.journeyNameDisplayViewHeight.constant = 0
                }else{
                    self.journeyNameDisplayView.isHidden = false
                    self.journeyNameDisplayViewHeight.constant = 51
                }
                
                if self.appdelegate.upgradeDataMutableArray.count == 0{
                    for i in 0..<self.updatedJourneyArray.count{
                        self.callAPIWithLoadingIndicator(selectedIndex: i, isAPICallForFirstTime: true)
                    }
                }else{
                    self.getDataFromCache()
                    self.displayBrandedFaresFromResp(selectedIndexFK: self.updatedJourneyArray[0].fk, selectedIndex: 0)
                }
                
                self.selectedFareName = ((self.updatedJourneyArray[0].leg.first?.flights.first?.fbn)?.lowercased())!
                self.selectedFareAmount = self.updatedJourneyArray[0].farepr
                
                self.setupParchmentPageController()
            }
        }
    }
    
    
    func setupNoDataFoundView(){
        let attributedString = NSMutableAttributedString(string: "Oops!\nOther Fares not found for this flight", attributes: [
//            .font: UIFont(name: "SourceSansPro-Regular", size: 18.0)!,
            .font: AppFonts.Regular.withSize(18),
            .foregroundColor: UIColor.white])
        
//        attributedString.addAttribute(.font, value: UIFont(name: "SourceSansPro-Regular", size: 22.0)!, range: NSRange(location: 0, length: 5))
  
        
        attributedString.addAttribute(.font, value: AppFonts.Regular.withSize(22), range: NSRange(location: 0, length: 5))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        noDataFoundLabel.attributedText = attributedString

    }
    
    private func setupParchmentPageController(){
        
        self.parchmentView = PagingViewController()
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 75, height: 50)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 12), insets: UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0))
        self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.6,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        self.parchmentView?.font = UIFont(name: "SourceSansPro-Regular", size: 16.0)!
//        self.parchmentView?.selectedFont = UIFont(name: "SourceSansPro-Semibold", size: 16.0)!
        
        self.parchmentView?.font = AppFonts.Regular.withSize(16)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16)

        self.parchmentView?.indicatorColor = .white//UIColor.AertripColor
        self.parchmentView?.selectedTextColor = .white // .black
        self.parchmentView?.textColor = .white
        self.parchmentView?.collectionView.backgroundColor = UIColor.clear
        self.journeyNameView.addSubview(self.parchmentView!.view)
        
        if allTabsStr.count > 3{
            self.parchmentView?.collectionView.isScrollEnabled = true
        }else{
            self.parchmentView?.collectionView.isScrollEnabled = false
        }
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: 0)
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
    }
    
    func setupFarebreakupView(){
        fareBreakupVC.taxesResult = taxesResult
        fareBreakupVC.journey = self.oldJourney
        fareBreakupVC.sid = sid
        fareBreakupVC.journeyCombo = journeyCombo
        fareBreakupVC.isFromFlightDetails = true
        fareBreakupVC.fromScreen = "upgradePlan"
        fareBreakupVC.isUpgradePlanScreenVisible = true
        fareBreakupVC.flightAdultCount = flightAdultCount
        fareBreakupVC.flightChildrenCount = flightChildrenCount
        fareBreakupVC.flightInfantCount = flightInfantCount
        self.view.addSubview(fareBreakupVC.view)
        self.addChild(fareBreakupVC)
        fareBreakupVC.didMove(toParent: self)
    }
    
    func setupDisplayView(){
        let screenSize = UIScreen.main.bounds.size
        var screenHeight = 0
        let cellWidth = floor(screenSize.width * cellScale)
        
        switch UIScreen.main.bounds.height{
        case 568: //iPhone SE | 5S
            var viewHeight = 0
            if updatedJourneyArray.count == 1{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                    viewHeight = 115
                }else{
                    self.planDisplayViewTop.constant = 15
                    viewHeight = 130
                }
                
                self.planCollectionViewBottom.constant = 0
                screenHeight = Int(screenSize.height - CGFloat(viewHeight) +  self.journeyNameDisplayViewHeight.constant)
                
            }else{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                }else{
                    self.planDisplayViewTop.constant = 15
                }
                
                self.planCollectionViewBottom.constant = 0//CGFloat(self.fewSeatsLeftViewHeight)
                screenHeight = Int(screenSize.height - 235 +  self.journeyNameDisplayViewHeight.constant)
            }
            
            break
            
        case 667: //iPhone 8 | 6 | 6s | 7
            if updatedJourneyArray.count == 1{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                }else{
                    self.planDisplayViewTop.constant = 15
                }
                
                self.planCollectionViewBottom.constant = 10
                screenHeight = Int(screenSize.height - planDisplayViewTop.constant - 130 +  self.journeyNameDisplayViewHeight.constant)
                
            }else{
                self.planDisplayViewTop.constant = 15
                
                self.planCollectionViewBottom.constant = 10
                screenHeight = Int(screenSize.height - 245 +  self.journeyNameDisplayViewHeight.constant)
            }
            
            break
            
        case 736: //iPhone 6 Plus | 8 plus | 6s plus | 7 Plus
            if updatedJourneyArray.count == 1{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                }else{
                    self.planDisplayViewTop.constant = 15
                }
                
                self.planCollectionViewBottom.constant = 0//CGFloat(self.fewSeatsLeftViewHeight)
                screenHeight = Int(screenSize.height - 140 +  self.journeyNameDisplayViewHeight.constant)
            }else{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                }else{
                    self.planDisplayViewTop.constant = 15
                }
                
                self.planCollectionViewBottom.constant = 0//CGFloat(self.fewSeatsLeftViewHeight)
                screenHeight = Int(screenSize.height - 240 +  self.journeyNameDisplayViewHeight.constant)
            }
            
            break
            
        case 812: //11 Pro | X | Xs
            if updatedJourneyArray.count == 1{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                }else{
                    self.planDisplayViewTop.constant = 15
                }
                
                self.planCollectionViewBottom.constant = 0//CGFloat(self.fewSeatsLeftViewHeight)
                screenHeight = Int(screenSize.height - 180 +  self.journeyNameDisplayViewHeight.constant)
            }else{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                }else{
                    self.planDisplayViewTop.constant = 15
                }
                
                self.planCollectionViewBottom.constant = 25//CGFloat(25 + self.fewSeatsLeftViewHeight)
                screenHeight = Int(screenSize.height - 280 +  self.journeyNameDisplayViewHeight.constant)
            }
            break
            
        case 896: //11 & 11 Pro Max & Xs Max & Xr
            if updatedJourneyArray.count == 1{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                }else{
                    self.planDisplayViewTop.constant = 15
                }
                
                self.planCollectionViewBottom.constant = 40//CGFloat(self.fewSeatsLeftViewHeight)
                screenHeight = Int(screenSize.height - 190 +  self.journeyNameDisplayViewHeight.constant)
            }else{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                }else{
                    self.planDisplayViewTop.constant = 10
                }
                
                self.planCollectionViewBottom.constant = 40 //CGFloat(40 + self.fewSeatsLeftViewHeight)
                screenHeight = Int(screenSize.height - 290 +  self.journeyNameDisplayViewHeight.constant)
            }
            break
            
        default :
            break
        }
        
        let layout = self.planCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: CGFloat(screenHeight))
        planCollectionView.contentInset = UIEdgeInsets(top: 0 , left: 16.0, bottom: 0, right: 16)
        planCollectionView.decelerationRate = .init(rawValue: 0.5)
    }
    
    
    //MARK:- CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if apiResp.count > 0{
            return apiResp[selectedLocationIndex].count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plansCell", for: indexPath) as! PlansCollectionViewCell
        
        if updatedJourneyArray.first?.fsr == 0{
            cell.dataDisplayViewBottom.constant = 50
        }else{
            cell.dataDisplayViewBottom.constant = 80
        }
        
        let upgardeResult = apiResp[selectedLocationIndex]
        
        if upgardeResult.count > 0{
            if !cell.isAnimated {
                UIView.animate(withDuration: 0.5, delay: 0.5 * Double(indexPath.row), usingSpringWithDamping: 1.5, initialSpringVelocity: 0.5, options: indexPath.row % 2 == 0 ? .transitionFlipFromLeft : .transitionFlipFromRight, animations: {
                    
                    self.viewSlideInFromRight(toLeft: cell)
                    
                }, completion: { (done) in
                    cell.isAnimated = true
                })
            }
            
            var titleVal = ""
            
            if let title = (upgardeResult[indexPath.row] as AnyObject).value(forKey: "title") as? NSArray{
                if title.count > 0{
                    if let ttl = title[0] as? NSArray{
                        if ttl.count > 0{
                            titleVal = (ttl[0] as! String)
                        }else{
                            titleVal = ""
                        }
                    }else if title[0] as? String != nil{
                        titleVal = (title[0] as! String)
                    }else{
                        titleVal = ""
                    }
                }else{
                    titleVal = ""
                }
            }else{
                titleVal = ""
            }
            
            if titleVal == ""{
                if let className = (upgardeResult[indexPath.row] as AnyObject).value(forKey: "class") as? NSArray{
                    if className.count > 0{
                        if let name = className[0] as? NSArray{
                            if name.count > 0{
                                titleVal = name[0] as! String
                            }
                        }
                    }
                }
            }
            
            if let bc = (upgardeResult[indexPath.row] as AnyObject).value(forKey: "bc") as? NSArray{
                if bc.count > 0{
                    if let bc1 = bc[0] as? NSArray{
                        if bc1.count > 0 {
                            titleVal = titleVal + " (" + (bc1[0] as! String) + ")"
                        }else{
                            titleVal = "\(titleVal)"
                        }
                    }else if bc[0] as? String != nil{
                        titleVal = titleVal + " (" + (bc[0] as! String) + ")"
                    }else{
                        titleVal = "\(titleVal)"
                    }
                }else{
                    titleVal = "\(titleVal)"
                }
            }else{
                titleVal = "\(titleVal)"
            }
            
            cell.titleLabel.text = titleVal
            
            if let description = (upgardeResult[indexPath.row] as AnyObject).value(forKey: "description") as? NSArray{
                if description.count > 0{
                    if let description1 = description[0] as? NSArray{
                        if description1.count > 0 {
                            if let desc = (description1[0] as? String)
                            {
                                if var displayString = desc.getAttributedString?.string{
                                    if displayString.contains(find: "\t•\t"){
                                        displayString = displayString.replacingOccurrences(of: "\t•\t", with: "•   ")
                                    }else if displayString.contains(find: " • "){
                                        displayString = displayString.replacingOccurrences(of: " • ", with: "\n•   ")
                                    }
                                    
                                    let attributedStr = NSMutableAttributedString(string: displayString)
                                    
                                    var checkMarkImgName = ""
                                    
                                    let farepr = (upgardeResult[indexPath.row] as AnyObject).value(forKey: "farepr") as! Int
                                    cell.selectButtonClick.tag = indexPath.row
                                    cell.selectButtonClick.addTarget(self, action: #selector(selectPlanButtonClicked), for: .touchUpInside)
                                    
                                    let fareTypeName = (upgardeResult[indexPath.row] as AnyObject).value(forKey: "FareTypeName") as? NSArray
                                    if let fareName = (fareTypeName?[0] as? NSArray)?.firstObject as? String
                                    {
                                        if selectedFareName == ""{
                                            if updatedJourneyArray[selectedLocationIndex].farepr == farepr{
                                                selectedPlanIndex = indexPath.row
                                                cell.newPriceLabel.text = getPrice(price: Double(farepr))
                                                
                                                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                                                    cell.priceLabel.alpha = 0.0
                                                }, completion: { (void) in
                                                    cell.priceLabel.text = ""
                                                })
                                                
                                                cell.selectButton.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                                                cell.selectButton.setTitleColor(UIColor.white, for: .normal)
                                                cell.selectButton.setTitle("Selected", for: .normal)
                                                checkMarkImgName = "Green_Copy.png"
                                                selectButtonTitle = "Selected"
                                            }else if isNewPlanSelected == true && updatedJourneyArray[selectedLocationIndex].farepr == farepr
                                            {
                                                selectedPlanIndex = indexPath.row
                                                cell.newPriceLabel.text = getPrice(price: Double(farepr))
                                                
                                                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                                                    cell.priceLabel.alpha = 0.0
                                                }, completion: { (void) in
                                                    cell.priceLabel.text = ""
                                                })
                                                
                                                cell.selectButton.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                                                cell.selectButton.setTitleColor(UIColor.white, for: .normal)
                                                cell.selectButton.setTitle("Selected", for: .normal)
                                                checkMarkImgName = "Green_Copy.png"
                                                selectButtonTitle = "Selected"
                                            }else{
                                                var newFare = 0
                                                if selectedPlanIndex >= 0{
                                                    newFare = (upgardeResult[selectedPlanIndex] as AnyObject).value(forKey: "farepr") as! Int
                                                }else{
                                                    newFare = updatedJourneyArray[selectedLocationIndex].farepr
                                                }
                                                
                                                cell.priceLabel.alpha = 1.0
                                                cell.priceLabel.text = getPrice(price: Double(farepr))
                                                let calculatedAmount = farepr - newFare
                                                
                                                if calculatedAmount == 0{
                                                    cell.newPriceLabel.text = getPrice(price: Double(farepr))
                                                    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                                                        cell.priceLabel.alpha = 0.0
                                                    }, completion: { (void) in
                                                        cell.priceLabel.text = ""
                                                    })
                                                }else{
                                                    if getPrice(price: Double(calculatedAmount)).contains(find: "-")
                                                    {
                                                        cell.newPriceLabel.text = "- "+getPrice(price: Double(calculatedAmount)).replacingOccurrences(of: "-", with: "")
                                                    }else{
                                                        cell.newPriceLabel.text = "+ "+getPrice(price: Double(calculatedAmount))
                                                    }
                                                }
                                                
                                                cell.selectButton.backgroundColor = UIColor(displayP3Red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
                                                cell.selectButton.setTitleColor(UIColor(displayP3Red: 0.0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1.0), for: .normal)
                                                cell.selectButton.setTitle("Select", for: .normal)
                                                checkMarkImgName = "blackCheckmark.png"
                                                selectButtonTitle = "Select"
                                            }
                                        }else{
                                            if selectedFareName == fareName.lowercased() && updatedJourneyArray[selectedLocationIndex].farepr == farepr
                                            {
                                                selectedPlanIndex = indexPath.row
                                                cell.newPriceLabel.text = getPrice(price: Double(farepr))
                                                
                                                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                                                    cell.priceLabel.alpha = 0.0
                                                }, completion: { (void) in
                                                    cell.priceLabel.text = ""
                                                })
                                                
                                                cell.selectButton.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                                                cell.selectButton.setTitleColor(UIColor.white, for: .normal)
                                                cell.selectButton.setTitle("Selected", for: .normal)
                                                checkMarkImgName = "Green_Copy.png"
                                                selectButtonTitle = "Selected"
                                            }else if isNewPlanSelected == true && selectedFareName == fareName.lowercased()
                                            {
                                                selectedPlanIndex = indexPath.row
                                                cell.newPriceLabel.text = getPrice(price: Double(farepr))
                                                
                                                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                                                    cell.priceLabel.alpha = 0.0
                                                }, completion: { (void) in
                                                    cell.priceLabel.text = ""
                                                })
                                                
                                                cell.selectButton.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                                                cell.selectButton.setTitleColor(UIColor.white, for: .normal)
                                                cell.selectButton.setTitle("Selected", for: .normal)
                                                checkMarkImgName = "Green_Copy.png"
                                                selectButtonTitle = "Selected"
                                            }else{
                                                var newFare = 0
                                                if selectedPlanIndex >= 0{
                                                    newFare = (upgardeResult[selectedPlanIndex] as AnyObject).value(forKey: "farepr") as! Int
                                                }else{
                                                    newFare = updatedJourneyArray[selectedLocationIndex].farepr
                                                }
                                                
                                                cell.priceLabel.alpha = 1.0
                                                cell.priceLabel.text = getPrice(price: Double(farepr))
                                                let calculatedAmount = farepr - newFare
                                                
                                                if calculatedAmount == 0{
                                                    cell.newPriceLabel.text = getPrice(price: Double(farepr))
                                                    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                                                        cell.priceLabel.alpha = 0.0
                                                    }, completion: { (void) in
                                                        cell.priceLabel.text = ""
                                                    })
                                                }else{
                                                    if getPrice(price: Double(calculatedAmount)).contains(find: "-")
                                                    {
                                                        cell.newPriceLabel.text = "- "+getPrice(price: Double(calculatedAmount)).replacingOccurrences(of: "-", with: "")
                                                    }else{
                                                        cell.newPriceLabel.text = "+ "+getPrice(price: Double(calculatedAmount))
                                                    }
                                                }
                                                
                                                cell.selectButton.backgroundColor = UIColor(displayP3Red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
                                                cell.selectButton.setTitleColor(UIColor(displayP3Red: 0.0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1.0), for: .normal)
                                                cell.selectButton.setTitle("Select", for: .normal)
                                                checkMarkImgName = "blackCheckmark.png"
                                                selectButtonTitle = "Select"
                                            }
                                        }
                                    }
                                    
                                    let image1Attachment = NSTextAttachment()
                                    image1Attachment.image = UIImage(named: checkMarkImgName)
                                    
                                    let image1String = NSAttributedString(attachment: image1Attachment)
                                    
                                    let mutableAttributedString = attributedStr.mutableCopy()
                                    let mutableString = (mutableAttributedString as AnyObject).mutableString
                                    
                                    while mutableString!.contains("•"){
                                        let rangeOfStringToBeReplaced = mutableString!.range(of: "•")
                                        (mutableAttributedString as AnyObject).replaceCharacters(in: rangeOfStringToBeReplaced, with: image1String)
                                    }
                                    
                                    while mutableString!.contains("◦") {
                                        isNewSubPoint = true
                                        let rangeOfStringToBeReplaced = mutableString!.range(of: "◦")
                                        (mutableAttributedString as AnyObject).replaceCharacters(in: rangeOfStringToBeReplaced, with: "－")
                                    }
                                    
                                    let updatedStr = NSMutableAttributedString(attributedString: mutableAttributedString as! NSAttributedString)
                                    
                                    let style = NSMutableParagraphStyle()
                                    style.alignment = .left
                                    if isNewSubPoint == true{
                                        style.headIndent = 56
                                    }else{
                                        style.headIndent = 25
                                    }
                                    style.paragraphSpacingBefore = 12
                                    
                                    let range = (displayString as NSString).range(of: displayString)
                                    
//                                    updatedStr.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Regular", size: 16.0)! , range: range)
                                    
                                    updatedStr.addAttribute(NSAttributedString.Key.font, value: AppFonts.Regular.withSize(16) , range: range)
                                    updatedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
                                    
                                    cell.txtView.attributedText = updatedStr
                                    cell.txtView.layoutIfNeeded()
                                }
                            }
                        }
                    }
                }
            }
            
            //Display Few Seats Left view
            if let flightResults = (upgardeResult[indexPath.row] as AnyObject).value(forKey: "flight_result") as? JSONDictionary{
                
                let remainingSeats = flightResults["seats"] as? String
                
                if let fsr = flightResults["fsr"] as? Int{
                    if fsr == 1 && remainingSeats != nil{
                        
                        cell.fewSeatsLeftView.isHidden = false
                        cell.fewSeatsLeftViewHeight.constant = 35
                        if Int(remainingSeats!)! > 1{
                            cell.fewSeatsLeftLabel.text = "Seats left at this price. Hurry up!"
                        }else{
                            cell.fewSeatsLeftLabel.text = "Seat left at this price. Hurry up!"
                        }
                    }else{
                        cell.fewSeatsLeftView.isHidden = true
                        cell.fewSeatsLeftViewHeight.constant = 0
                    }
                }else if let fsr = flightResults["fsr"] as? String {
                    if fsr == "1" && remainingSeats != nil{
                        
                        cell.fewSeatsLeftView.isHidden = false
                        cell.fewSeatsLeftViewHeight.constant = 35
                        if Int(remainingSeats!)! > 1{
                            cell.fewSeatsLeftLabel.text = "Seats left at this price. Hurry up!"
                        }else{
                            cell.fewSeatsLeftLabel.text = "Seat left at this price. Hurry up!"
                        }
                    }else{
                        cell.fewSeatsLeftView.isHidden = true
                        cell.fewSeatsLeftViewHeight.constant = 0
                    }
                }else{
                    cell.fewSeatsLeftView.isHidden = true
                    cell.fewSeatsLeftViewHeight.constant = 0
                }
            }else{
                cell.fewSeatsLeftView.isHidden = true
                cell.fewSeatsLeftViewHeight.constant = 0
            }
        }
        return cell
    }
    
    func viewSlideInFromRight(toLeft views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition.init()
        transition?.duration = 0.4
        transition?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition?.type = CATransitionType.push
        transition?.subtype = CATransitionSubtype.fromRight
        views.layer.add(transition!, forKey: nil)
    }
    
    //MARK:- Scroll View Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView == planCollectionView{
            let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
            if let ip = planCollectionView.indexPathForItem(at: center) {
                self.journeyPageControl.currentPage = ip.row
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        if scrollView == planCollectionView{
            let layout = self.planCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidthIncludingSpaces = layout.itemSize.width + layout.minimumLineSpacing
            
            var offset = targetContentOffset.pointee
            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpaces
            let roundedIndex = round(index)
            
            offset = CGPoint(x: roundedIndex * cellWidthIncludingSpaces - scrollView.contentInset.left, y: scrollView.contentInset.top)
            targetContentOffset.pointee = offset
        }
    }
    
    //MARK:- Button Action
    @objc func selectPlanButtonClicked(_ sender:UIButton)
    {
        var dict = JSONDictionary()
        if selectedPlanIndex != sender.tag{
            let upgardeResult = apiResp[selectedLocationIndex]
            dict = (upgardeResult[sender.tag] as AnyObject).value(forKey: "fare") as! JSONDictionary
            if let fareTypeName = (upgardeResult[sender.tag] as AnyObject).value(forKey: "FareTypeName") as? NSArray
            {
                if fareTypeName.count > 0{
                    selectedFareName = ((fareTypeName[0] as? NSArray)?.firstObject as! String).lowercased()
                    
                    isNewPlanSelected = true
                    selectedPlanIndex = sender.tag
                    if let farepr = (upgardeResult[sender.tag] as AnyObject).value(forKey: "farepr") as? Int
                    {
                        selectedPlanFare[selectedLocationIndex] = farepr
                        selectedFareAmount = farepr
                    }
                    
                    planCollectionView.reloadData()
                }
            }
        }
        
        
        var totalFareVal = 0
        for i in 0..<selectedPlanFare.count{
            totalFareVal += selectedPlanFare[i]
        }
        
        let price = getPrice(price: Double(totalFareVal))
        fareBreakupVC.bookingAmountLabel.text = price
        
//        
//        fareBreakupVC.fareBreakupFromUpgrade = dict
//        fareBreakupVC.createTaxesDict()
    }
    
    @IBAction func closeButtonClicked(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Call API
    func callAPIForUpgrade(sid: String, fk: String, fare: String, journeyObj:Journey, index:Int)
    {
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .upgradeAPIResult(sid: sid, fk: fk, oldFare: fare), completionHandler: { (data) in
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject] {
                        if result["success"] as? Bool == true{
                            if let data = result["data"] as? JSONDictionary {
                                
                                if let other_fares = data["other_fares"] as? NSArray{
                                    
                                    if other_fares.count > 0
                                    {
                                        var fareArray = NSArray()
                                        if other_fares.count > 1{
                                            fareArray = other_fares
                                        }else{
                                            fareArray = other_fares[0] as! NSArray
                                        }
                                        
                                        var storedFKArray = [String]()
                                        
                                        for i in 0..<self.newTestDict.count{
                                            let dict = self.newTestDict[i] as [String:NSArray]
                                            if dict.count > 0{
                                                let storedFK = dict.first!.key
                                                storedFKArray.append(storedFK)
                                            }
                                        }
                                        
                                        if !storedFKArray.contains(fk){
                                            let newDict = [fk:fareArray]
                                            self.newTestDict.append(newDict)
                                        }
                                        
                                        var cachedFKArray = [String]()
                                        
                                        for i in 0..<self.appdelegate.upgradeDataMutableArray.count{
                                            if let ass = self.appdelegate.upgradeDataMutableArray[i] as? JSONDictionary
                                            {
                                                let index = ass["selectedJourneyFK"] as? String ?? ""
                                                cachedFKArray.append(index)
                                            }
                                        }
                                        
                                        if !cachedFKArray.contains(fk){
                                            let date = Date()
                                            let calendar = Calendar.current
                                            let hour = calendar.component(.hour, from: date)
                                            let minutes = calendar.component(.minute, from: date)
                                            let seconds = calendar.component(.second, from: date)
                                            
                                            let arr = ["Time" : "\(hour):\(minutes):\(seconds)",
                                                "selectedJourneyFK" : fk,
                                                "upgradeArray":fareArray] as JSONDictionary
                                            
                                            self.appdelegate.upgradeDataMutableArray.add(arr)
                                        }
                                    }else{
                                        var storedFKArray = [String]()
                                        
                                        for i in 0..<self.newTestDict.count{
                                            let dict = self.newTestDict[i] as [String:NSArray]
                                            if dict.count > 0{
                                                let storedFK = dict.first!.key
                                                storedFKArray.append(storedFK)
                                            }
                                        }
                                        
                                        if !storedFKArray.contains(fk){
                                            let newDict = [fk:NSArray()]
                                            self.newTestDict.append(newDict)
                                        }
                                    }
                                }else{
                                    var storedFKArray = [String]()
                                    
                                    for i in 0..<self.newTestDict.count{
                                        let dict = self.newTestDict[i] as [String:NSArray]
                                        let storedFK = dict.first!.key
                                        storedFKArray.append(storedFK)
                                    }
                                    
                                    if !storedFKArray.contains(fk){
                                        let newDict = [fk:NSArray()]
                                        self.newTestDict.append(newDict)
                                    }
                                }
                            }else{
                                var storedFKArray = [String]()
                                
                                for i in 0..<self.newTestDict.count{
                                    let dict = self.newTestDict[i] as [String:NSArray]
                                    let storedFK = dict.first!.key
                                    storedFKArray.append(storedFK)
                                }
                                
                                if !storedFKArray.contains(fk){
                                    let newDict = [fk:NSArray()]
                                    self.newTestDict.append(newDict)
                                }
                            }
                        }else{
                            var storedFKArray = [String]()
                            
                            for i in 0..<self.newTestDict.count{
                                let dict = self.newTestDict[i] as [String:NSArray]
                                let storedFK = dict.first!.key
                                storedFKArray.append(storedFK)
                            }
                            
                            if !storedFKArray.contains(fk){
                                let newDict = [fk:NSArray()]
                                self.newTestDict.append(newDict)
                            }
                        }
                    }
                    
                    self.displayBrandedFaresFromResp(selectedIndexFK: fk, selectedIndex: index)
                }
            }catch{
            }
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    func displayLoadingIndicator(){
        self.actInd.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        self.actInd.style = UIActivityIndicatorView.Style.white
        self.view.addSubview(self.actInd)
        self.actInd.startAnimating()
    }
    
    func callAPIWithLoadingIndicator(selectedIndex:Int, isAPICallForFirstTime:Bool)
    {
        displayLoadingIndicator()
        callAPIForUpgrade(sid: sid, fk: updatedJourneyArray[selectedIndex].fk, fare: "\(updatedJourneyArray[selectedIndex].farepr)", journeyObj: updatedJourneyArray[selectedIndex], index: selectedIndex)
    }
    
    func displayBrandedFaresFromResp(selectedIndexFK:String, selectedIndex:Int)
    {
        self.actInd.stopAnimating()
        
        if newTestDict.count > 0{
            var valArray = NSArray()
            
            for i in 0..<newTestDict.count{
                let dict = newTestDict[i] as [String:NSArray]
                let storedFK = dict.first?.key
                
                if storedFK == selectedIndexFK{
                    valArray = dict.first!.value
                }
            }
            
            if valArray.count > 0{
                apiResp.insert(valArray, at: selectedIndex)
                selectedFareName = (updatedJourneyArray[selectedLocationIndex].leg.first?.flights.first?.fbn)!.lowercased()
                selectedFareAmount = updatedJourneyArray[selectedLocationIndex].farepr
                self.planDisplayView.isHidden = false
                self.noDataFoundView.isHidden = true
                self.journeyPageControl.numberOfPages = valArray.count
                self.planCollectionView.contentSize = .zero
                viewSlideInFromRight(toLeft: self.planCollectionView)
                setupDisplayView()
                self.planCollectionView.reloadData()
            }else{
                self.journeyPageControl.numberOfPages = 0
                
                self.planDisplayView.isHidden = true
                self.noDataFoundView.isHidden = true
                
                if isCallForFirstTime == false{
                    callAPIWithLoadingIndicator(selectedIndex: selectedIndex, isAPICallForFirstTime: true)
                    isCallForFirstTime = true
                }else{
                    if selectedLocationIndex == selectedIndex{
                        self.noDataFoundView.isHidden = false
                    }
                }
            }
        }else{
            self.journeyPageControl.numberOfPages = 0
            
            self.planDisplayView.isHidden = true
            self.noDataFoundView.isHidden = true
            
            if isCallForFirstTime == false{
                callAPIWithLoadingIndicator(selectedIndex: selectedIndex, isAPICallForFirstTime: true)
                isCallForFirstTime = true
            }else{
                if selectedLocationIndex == selectedIndex{
                    self.noDataFoundView.isHidden = false
                }
            }
        }
    }
    
    func getDataFromCache(){
        for i in 0..<self.appdelegate.upgradeDataMutableArray.count{
            if let ass = self.appdelegate.upgradeDataMutableArray[i] as? JSONDictionary
            {
                let storedFK = ass["selectedJourneyFK"] as! String
                
                let storedUpgradeArray = ass["upgradeArray"] as! NSArray
                
                let newDict = [storedFK:storedUpgradeArray]
                self.newTestDict.append(newDict)
            }
        }
    }
    
    //MARK:- Format Price
    func getPrice(price:Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_IN")
        var result = formatter.string(from: NSNumber(value: price))
        
        if result!.contains(find: ".00"){
            result = result?.replacingOccurrences(of: ".00", with: "", options: .caseInsensitive, range: Range(NSRange(location:result!.count-3,length:3), in: result!) )
        }
        return result!
    }
    
}

//MARK:- Get Attributed String
extension String {
    var getAttributedString: NSMutableAttributedString? {
        let attrStr = try! NSMutableAttributedString(
            data: self.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ .documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        return attrStr
    }
}



extension UpgradePlanBaseVC: PagingViewControllerDataSource , PagingViewControllerDelegate, PagingViewControllerSizeDelegate
{
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.parchmentView?.view.frame = self.journeyNameView.bounds
        self.parchmentView?.loadViewIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.parchmentView?.view.frame = self.journeyNameView.bounds
        self.parchmentView?.loadViewIfNeeded()
        
        
        let gradient = CAGradientLayer()
        gradient.frame = dataDisplayView.bounds
        let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
        gradient.frame.size.height = dataDisplayView.frame.height+bottomInset!
        
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        let colorOne = UIColor(displayP3Red: ( 0.0 / 255.0), green: ( 204.0 / 255.0), blue: ( 153 / 255.0), alpha: 1.0)
        let colorTwo = UIColor(displayP3Red: (41.0/255.0), green: ( 176.0 / 255.0) , blue: ( 182 / 255.0), alpha: 1.0)
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        dataDisplayView.layer.insertSublayer(gradient, at: 0)
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        if allTabsStr.count > 0{
            return PagingIndexItem(index: index, title:  self.allTabsStr[index])
        }else{
            return PagingIndexItem(index: 0, title:  "")
        }
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return self.allTabsStr.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController
    {
        return UIViewController()
    }
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat
    {
        return 120.0
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool){
        
        let pagingIndexItem = pagingItem as! PagingIndexItem
        
        if selectedLocationIndex != pagingIndexItem.index
        {
            isInitialJourneySelected = false
            selectedLocationIndex = pagingIndexItem.index
            
            self.journeyPageControl.numberOfPages = 0
            self.planDisplayView.isHidden = true
            self.noDataFoundView.isHidden = true
            displayLoadingIndicator()
            
            isCallForFirstTime = false
            self.displayBrandedFaresFromResp(selectedIndexFK: self.updatedJourneyArray[pagingIndexItem.index].fk, selectedIndex: pagingIndexItem.index)
        }
    }
}
