//
//  UpgradePlanBaseVC.swift
//  Aertrip
//
//  Created by Monika Sonawane on 01/10/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//


import UIKit

class UpgradePlanBaseVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIScrollViewDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var blurViewTop: NSLayoutConstraint!
    @IBOutlet weak var blurViewBottom: NSLayoutConstraint!
    @IBOutlet weak var grabberView: UIView!
    @IBOutlet weak var dataDisplayView: UIView!
    @IBOutlet weak var dataDisplayViewTop: NSLayoutConstraint!
    @IBOutlet weak var dataDisplayViewBottom: NSLayoutConstraint!
    @IBOutlet weak var journeyNameDisplayView: UIView!
    @IBOutlet weak var journeyNameDisplayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var journeyNameCollectionView: UICollectionView!
    @IBOutlet weak var journeyPageControl: UIPageControl!
    @IBOutlet weak var planDisplayView: UIView!
    @IBOutlet weak var planDisplayViewTop: NSLayoutConstraint!
    @IBOutlet weak var planCollectionView: UICollectionView!
    @IBOutlet weak var planCollectionViewBottom: NSLayoutConstraint!
    @IBOutlet weak var noDataFoundView: UIView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    //MARK:- Variable Declaration
    var journey: [Journey]!
    var journeyCombo: [CombinationJourney]!
    
    var taxesResult : [String : String]!
    
    var sid = ""
    var fk = ""
    var fare = ""
    var selectedPlanIndex = -1
    var isNewSubPoint = false
    
    var thisWidth = 0
    var selectedLocationIndex = 0
    var upgardeResult = NSArray()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    let cellScale : CGFloat = 0.92
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    var selectedJourneyFK = [String]()
    
    let fareBreakupVC = FareBreakupVC(nibName: "FareBreakupVC", bundle: nil)
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    let clearCache = ClearCache()
    var fewSeatsLeftViewHeight = 0
    var selectedFareName = ""
    var isFirstJourneyHasFareResp = false
    
    var selectedFks = [String]()//To check upgrade fare flow
    var selectedFarepr = [Int]()//To check upgrade fare flow
    
    //MARK:- Initialise Views
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //-------------------------To check coperate flow---------------------------------------
        self.selectedFks = self.journey?.map{$0.fk} ?? []
        self.selectedFarepr = self.journey?.map{$0.farepr} ?? []
        //--------------------------------------------------------------------------------------
        clearCache.checkTimeAndClearUpgradeDataCache()
        
        self.planDisplayView.isHidden = true
        self.noDataFoundView.isHidden = true
        
        grabberView.layer.cornerRadius = 2
        
        journeyNameCollectionView.register( UINib(nibName: "JourneyNameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "JourneyNameCell")
        planCollectionView.register( UINib(nibName: "PlansCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "plansCell")
        
        journeyPageControl.numberOfPages = upgardeResult.count
        journeyPageControl.hidesForSinglePage = true
        journeyPageControl.currentPage = 0
        
        setupFarebreakupView()
        setupSwipeDownGuesture()
        setupDisplayView()
        
        DispatchQueue.main.async {
            if self.journey != nil{
                //                for i in 0..<self.journey.count{
                //                    self.selectedFareName = (self.journey[i].leg.first?.flights.first?.fbn)!.lowercased()
                //                }
                if self.journey.count < 2{
                    self.journeyNameDisplayView.isHidden = true
                    self.journeyNameDisplayViewHeight.constant = 0
                }else{
                    self.journeyNameDisplayView.isHidden = false
                    self.journeyNameDisplayViewHeight.constant = 51
                }
                
                if self.appdelegate.upgradeDataMutableArray.count == 0{
                    self.actInd.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                    self.actInd.style = UIActivityIndicatorView.Style.white
                    self.view.addSubview(self.actInd)
                    self.actInd.startAnimating()
                    
                    for i in 0..<self.journey.count{
                        self.callAPIForUpgrade(sid: self.sid, fk: self.journey[i].fk, fare: "\(self.journey[i].farepr)", journeyObj: self.journey[i], index: i)
                    }
                }else{
                    for i in 0..<self.appdelegate.upgradeDataMutableArray.count{
                        if let ass = self.appdelegate.upgradeDataMutableArray[i] as? NSDictionary
                        {
                            let index = ass.value(forKey: "selectedJourneyFK") as! String
                            if self.journey.first!.fk == index{
                                let upgradeArray = ass.value(forKey: "upgradeArray") as! NSArray
                                self.upgardeResult = upgradeArray
                                self.selectedFareName = (self.journey.first!.leg.first?.flights.first?.fbn)!.lowercased()
                                self.planDisplayView.isHidden = false
                                self.noDataFoundView.isHidden = true
                                self.journeyPageControl.numberOfPages = self.upgardeResult.count
                                self.planCollectionView.contentSize = .zero
                                for i in 0..<self.upgardeResult.count{
                                    let fareTypeName = (self.upgardeResult[i] as AnyObject).value(forKey: "FareTypeName") as? NSArray
                                    if let fareName = (fareTypeName?[0] as? NSArray)?.firstObject as? String
                                    {
                                        if fareName.lowercased() == self.selectedFareName{
                                            self.selectedPlanIndex = i
                                        }
                                    }
                                }
                                self.setupDisplayView()
                                self.planCollectionView.reloadData()
                            }
                        }
                    }
                    
                    if self.upgardeResult.count == 0{
                        self.actInd.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                        self.actInd.style = UIActivityIndicatorView.Style.white
                        self.view.addSubview(self.actInd)
                        self.actInd.startAnimating()
                        
                        for i in 0..<self.journey.count{
                            self.callAPIForUpgrade(sid: self.sid, fk: self.journey[i].fk, fare: "\(self.journey[i].farepr)", journeyObj: self.journey[i], index: i)
                        }
                    }
                }
            }
        }
        
        let attributedString = NSMutableAttributedString(string: "Oops!\nOther Fares not found for this flight", attributes: [
            .font: UIFont(name: "SourceSansPro-Regular", size: 18.0)!,
            .foregroundColor: UIColor.white])
        
        attributedString.addAttribute(.font, value: UIFont(name: "SourceSansPro-Regular", size: 22.0)!, range: NSRange(location: 0, length: 5))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        noDataFoundLabel.attributedText = attributedString
        
        for i in 0..<self.journey.count{
            if self.journey[i].fsr == 1{
                self.fewSeatsLeftViewHeight = 40
            }
        }
        
        selectedFareName = ((journey[0].leg.first?.flights.first?.fbn)?.lowercased())!
    }
    
    override func viewDidLayoutSubviews()
    {
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
    
    func setupFarebreakupView(){
        fareBreakupVC.taxesResult = taxesResult
        fareBreakupVC.journey = self.journey
        fareBreakupVC.sid = sid
        fareBreakupVC.journeyCombo = journeyCombo
        fareBreakupVC.isFromFlightDetails = true
        fareBreakupVC.fromScreen = "upgradePlan"
        fareBreakupVC.isUpgradePlanScreenVisible = true
        fareBreakupVC.flightAdultCount = flightAdultCount
        fareBreakupVC.flightChildrenCount = flightChildrenCount
        fareBreakupVC.flightInfantCount = flightInfantCount
        fareBreakupVC.fewSeatsLeftViewHeightFromFlightDetails = fewSeatsLeftViewHeight
        self.view.addSubview(fareBreakupVC.view)
        self.addChild(fareBreakupVC)
        fareBreakupVC.didMove(toParent: self)
    }
    
    func setupDisplayView(){
        let screenSize = UIScreen.main.bounds.size
        var screenHeight = 0
        let cellWidth = floor(screenSize.width * cellScale)
        guard let journey = self.journey else {return}
        switch UIScreen.main.bounds.height{
        case 568: //iPhone SE | 5S
            var viewHeight = 0
            if journey.count == 1{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                    viewHeight = 115
                }else{
                    self.planDisplayViewTop.constant = 15
                    viewHeight = 130
                }
                
                if fewSeatsLeftViewHeight == 40{
                    self.planCollectionViewBottom.constant = 15
                    screenHeight = Int(screenSize.height - 150 +  self.journeyNameDisplayViewHeight.constant)
                }else{
                    self.planCollectionViewBottom.constant = 0
                    screenHeight = Int(screenSize.height - CGFloat(viewHeight) +  self.journeyNameDisplayViewHeight.constant)
                }
            }else{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                }else{
                    self.planDisplayViewTop.constant = 15
                }
                
                if fewSeatsLeftViewHeight == 40{
                    self.planCollectionViewBottom.constant = 25
                    screenHeight = Int(screenSize.height - 260 +  self.journeyNameDisplayViewHeight.constant)
                }else{
                    self.planCollectionViewBottom.constant = CGFloat(self.fewSeatsLeftViewHeight)
                    screenHeight = Int(screenSize.height - 235 +  self.journeyNameDisplayViewHeight.constant)
                }
            }
            
            break
            
        case 667: //iPhone 8 | 6 | 6s | 7
            if journey.count == 1{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                }else{
                    self.planDisplayViewTop.constant = 15
                }
                
                if fewSeatsLeftViewHeight == 40{
                    self.planCollectionViewBottom.constant = CGFloat(self.fewSeatsLeftViewHeight-15)
                    screenHeight = Int(screenSize.height - 155 +  self.journeyNameDisplayViewHeight.constant)
                }else{
                    self.planCollectionViewBottom.constant = 10
                    screenHeight = Int(screenSize.height - planDisplayViewTop.constant - 130 +  self.journeyNameDisplayViewHeight.constant)
                }
            }else{
                self.planDisplayViewTop.constant = 15
                
                if fewSeatsLeftViewHeight == 40{
                    self.planCollectionViewBottom.constant = 25
                    screenHeight = Int(screenSize.height - 260 +  self.journeyNameDisplayViewHeight.constant)
                }else{
                    self.planCollectionViewBottom.constant = 10
                    screenHeight = Int(screenSize.height - 245 +  self.journeyNameDisplayViewHeight.constant)
                }
            }
            break
            
        case 736: //iPhone 6 Plus | 8 plus | 6s plus | 7 Plus
            if journey.count == 1{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                }else{
                    self.planDisplayViewTop.constant = 15
                }
                
                if fewSeatsLeftViewHeight == 40{
                    self.planCollectionViewBottom.constant = 15
                    screenHeight = Int(screenSize.height - 150 +  self.journeyNameDisplayViewHeight.constant)
                }else{
                    self.planCollectionViewBottom.constant = CGFloat(self.fewSeatsLeftViewHeight)
                    screenHeight = Int(screenSize.height - 140 +  self.journeyNameDisplayViewHeight.constant)
                }
            }else{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                }else{
                    self.planDisplayViewTop.constant = 15
                }
                
                if fewSeatsLeftViewHeight == 40{
                    self.planCollectionViewBottom.constant = 25
                    screenHeight = Int(screenSize.height - 260 +  self.journeyNameDisplayViewHeight.constant)
                }else{
                    self.planCollectionViewBottom.constant = CGFloat(self.fewSeatsLeftViewHeight)
                    screenHeight = Int(screenSize.height - 240 +  self.journeyNameDisplayViewHeight.constant)
                }
            }
            
            break
            
        case 812: //11 Pro | X | Xs
            if journey.count == 1{
                var viewHeight = 0
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                    viewHeight = 180
                }else{
                    self.planDisplayViewTop.constant = 15
                    viewHeight = 200
                }
                
                if fewSeatsLeftViewHeight == 40{
                    self.planCollectionViewBottom.constant = CGFloat(10 + self.fewSeatsLeftViewHeight)
                    screenHeight = Int(screenSize.height - CGFloat(viewHeight) +  self.journeyNameDisplayViewHeight.constant)
                }else{
                    self.planCollectionViewBottom.constant = CGFloat(self.fewSeatsLeftViewHeight)
                    screenHeight = Int(screenSize.height - 180 +  self.journeyNameDisplayViewHeight.constant)
                }
            }else{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                }else{
                    self.planDisplayViewTop.constant = 15
                }
                
                if fewSeatsLeftViewHeight == 40{
                    self.planCollectionViewBottom.constant = CGFloat(15 + self.fewSeatsLeftViewHeight)
                    screenHeight = Int(screenSize.height - 300 +  self.journeyNameDisplayViewHeight.constant)
                }else{
                    self.planCollectionViewBottom.constant = CGFloat(25 + self.fewSeatsLeftViewHeight)
                    screenHeight = Int(screenSize.height - 280 +  self.journeyNameDisplayViewHeight.constant)
                }
            }
            break
            
        case 896: //11 & 11 Pro Max & Xs Max & Xr
            if journey.count == 1{
                var viewHeight = 0
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                    viewHeight = 180
                }else{
                    self.planDisplayViewTop.constant = 15
                    viewHeight = 200
                }
                
                if fewSeatsLeftViewHeight == 40{
                    self.planCollectionViewBottom.constant = CGFloat(10 + self.fewSeatsLeftViewHeight)//25
                    screenHeight = Int(screenSize.height - CGFloat(viewHeight) +  self.journeyNameDisplayViewHeight.constant)
                }else{
                    self.planCollectionViewBottom.constant = CGFloat(self.fewSeatsLeftViewHeight)
                    screenHeight = Int(screenSize.height - 180 +  self.journeyNameDisplayViewHeight.constant)
                }
            }else{
                if self.journeyPageControl.isHidden == true{
                    self.planDisplayViewTop.constant = 0
                }else{
                    self.planDisplayViewTop.constant = 15
                }
                
                if fewSeatsLeftViewHeight == 40{
                    self.planCollectionViewBottom.constant = CGFloat(50 + self.fewSeatsLeftViewHeight)
                    screenHeight = Int(screenSize.height - 340 +  self.journeyNameDisplayViewHeight.constant)//240)
                }else{
                    self.planCollectionViewBottom.constant = CGFloat(40 + self.fewSeatsLeftViewHeight)
                    screenHeight = Int(screenSize.height - 290 +  self.journeyNameDisplayViewHeight.constant)
                }
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
    
    
    func setupSwipeDownGuesture(){
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(panGestureRecognizerHandler(_:)))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK:- CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == journeyNameCollectionView
        {
            if journey != nil{
                return journey!.count
            }else{
                return 0
            }
        }else{
            return upgardeResult.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == journeyNameCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JourneyNameCell", for: indexPath) as! JourneyNameCollectionViewCell
            
            if journey!.count > 0{
                let flight = journey![indexPath.row]
                
                cell.journeyNameLabel.text = flight.ap[0] + " → " + flight.ap[1]
            }else{
                cell.journeyNameLabel.text = ""
            }
            
            if indexPath.row == selectedLocationIndex{
                cell.journeyNameHighlightingView.isHidden = false
                cell.journeyNameHighlightingViewHeight.constant = 2
            }else{
                cell.journeyNameHighlightingView.isHidden = true
                cell.journeyNameHighlightingViewHeight.constant = 0
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plansCell", for: indexPath) as! PlansCollectionViewCell
            
            if journey.first?.fsr == 0{
                cell.dataDisplayViewBottom.constant = 50
            }else{
                cell.dataDisplayViewBottom.constant = 80
            }
            
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
                                        if let fareName = (fareTypeName?[0] as? NSArray)?.firstObject as? String{
                                            if selectedFareName == fareName.lowercased(){
                                                selectedPlanIndex = indexPath.row
                                                cell.newPriceLabel.text = getPrice(price: Double(farepr))
                                                
                                                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                                                    cell.priceLabel.alpha = 0.0
                                                }, completion: { (void) in
                                                    cell.priceLabel.text = ""
                                                })
                                                
                                                cell.selectButton.backgroundColor = UIColor.init(displayP3Red: 0.0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                                                cell.selectButton.setTitleColor(UIColor.white, for: .normal)
                                                cell.selectButton.setTitle("Selected", for: .normal)
                                                checkMarkImgName = "Green_Copy.png"
                                            }else{
                                                var newFare = 0
                                                if selectedPlanIndex >= 0{
                                                    newFare = (upgardeResult[selectedPlanIndex] as AnyObject).value(forKey: "farepr") as! Int
                                                }
                                                
                                                cell.priceLabel.alpha = 1.0
                                                cell.priceLabel.text = getPrice(price: Double(farepr))
                                                let calculatedAmount = farepr - newFare
                                                
//                                                print("calculatedAmount= ", calculatedAmount)
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
                                                
                                                cell.selectButton.backgroundColor = UIColor.init(displayP3Red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
                                                cell.selectButton.setTitleColor(UIColor.init(displayP3Red: 0.0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1.0), for: .normal)
                                                cell.selectButton.setTitle("Select", for: .normal)
                                                
                                                checkMarkImgName = "blackCheckmark.png"
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
                                        
                                        updatedStr.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Regular", size: 16.0)! , range: range)
                                        updatedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
                                        
                                        cell.txtView.attributedText = updatedStr
                                        cell.txtView.layoutIfNeeded()
                                    }
                                }
                            }
                        }
                    }
                }
                
                //                if let farepr = (upgardeResult[indexPath.row] as AnyObject).value(forKey: "farepr") as? Int{
                //
                //                    cell.selectButtonClick.tag = indexPath.row
                //                    cell.selectButtonClick.addTarget(self, action: #selector(selectPlanButtonClicked), for: .touchUpInside)
                //
                //                    let newFare = (upgardeResult[indexPath.row] as AnyObject).value(forKey: "farepr") as? Int
                //
                //                    print("selectedPlanIndex= ", selectedPlanIndex)
                //                    print("indexPath.row= ", indexPath.row)
                //
                //                    if selectedPlanIndex == indexPath.row
                //                    {
                //                        cell.newPriceLabel.text = getPrice(price: Double(farepr))
                //
                //                        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                //                            cell.priceLabel.alpha = 0.0
                //                        }, completion: { (void) in
                //                            cell.priceLabel.text = ""
                //                        })
                //                    }else{
                //                        cell.priceLabel.alpha = 1.0
                //                        cell.priceLabel.text = getPrice(price: Double(farepr))
                //
                //                        let calculatedAmount = farepr - newFare!
                //
                //                        if calculatedAmount == 0{
                //                            cell.newPriceLabel.text = getPrice(price: Double(farepr))
                //                            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                //                                cell.priceLabel.alpha = 0.0
                //                            }, completion: { (void) in
                //                                cell.priceLabel.text = ""
                //                            })
                //                        }else{
                //                            if getPrice(price: Double(calculatedAmount)).contains(find: "-")
                //                            {
                //                                cell.newPriceLabel.text = "- "+getPrice(price: Double(calculatedAmount)).replacingOccurrences(of: "-", with: "")
                //                            }else{
                //                                cell.newPriceLabel.text = "+ "+getPrice(price: Double(calculatedAmount))
                //                            }
                //                        }
                //                    }
                //                }else{
                //                    cell.priceLabelLeading.constant = 0
                //                    cell.newPriceLabel.text = ""
                //                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == journeyNameCollectionView
        {
            var storedFKArray = [String]()
            if selectedLocationIndex != indexPath.row
            {
                self.displayFaresForSelectedIndex(selectedIndex: indexPath.row)
            }
//                {
//
//                for i in 0..<self.appdelegate.upgradeDataMutableArray.count{
//                    if let ass = self.appdelegate.upgradeDataMutableArray[i] as? NSDictionary
//                    {
//                        let index = ass.value(forKey: "selectedJourneyFK") as! String
//                        storedFKArray.append(index)
//                    }
//                }
//
//                if !storedFKArray.contains(self.journey[indexPath.row].fk){
//                    self.noDataFoundView.isHidden = true
//                    self.planDisplayView.isHidden = true
//                    self.journeyPageControl.isHidden = true
//
//                    self.actInd.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
//                    self.actInd.style = UIActivityIndicatorView.Style.white
//                    self.view.addSubview(self.actInd)
//                    self.actInd.startAnimating()
//
//                    callAPIForUpgrade(sid: sid, fk: journey[indexPath.row].fk, fare: "\(journey[indexPath.row].farepr)", journeyObj: journey[indexPath.row], index: indexPath.row)
//
//                    selectedLocationIndex = indexPath.row
//                    journeyNameCollectionView.reloadData()
//                }else{
//                    for i in 0..<self.appdelegate.upgradeDataMutableArray.count{
//                        if let ass = self.appdelegate.upgradeDataMutableArray[i] as? NSDictionary
//                        {
//                            let index = ass.value(forKey: "selectedJourneyFK") as! String
//                            if self.journey[indexPath.row].fk == index{
//                                let upgradeArray = ass.value(forKey: "upgradeArray") as! NSArray
//                                self.upgardeResult = upgradeArray
//                                selectedPlanIndex = indexPath.row
//                                selectedLocationIndex = indexPath.row
//                                selectedFareName = (journey[indexPath.row].leg.first?.flights.first?.fbn)!.lowercased()
//                                self.planDisplayView.isHidden = false
//                                self.noDataFoundView.isHidden = true
//                                self.journeyPageControl.numberOfPages = self.upgardeResult.count
//                                self.planCollectionView.contentSize = .zero
//                                viewSlideInFromRight(toLeft: self.planCollectionView)
//                                self.planCollectionView.reloadData()
//                                journeyNameCollectionView.reloadData()
//                            }
//                        }
//                    }
//                }
//            }
        }
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
        let fareTypeName = (upgardeResult[sender.tag] as AnyObject).value(forKey: "FareTypeName") as? NSArray
        selectedFareName = ((fareTypeName?[0] as? NSArray)?.firstObject as! String).lowercased()
        //-------------------------To check coperate flow---------------------------------------
        self.selectedFks[self.selectedLocationIndex] = (upgardeResult[sender.tag] as AnyObject).value(forKey:"fk") as? String ?? ""
        self.selectedFarepr[self.selectedLocationIndex] = (upgardeResult[sender.tag] as AnyObject).value(forKey:"farepr") as? Int ?? 0
        //-------------------------To check coperate flow---------------------------------------
        selectedPlanIndex = sender.tag
        if let farepr = (upgardeResult[sender.tag] as AnyObject).value(forKey: "farepr") as? Int
        {
            let price = getPrice(price: Double(farepr))
            fareBreakupVC.bookingAmountLabel.text = price
        }
        
        planCollectionView.reloadData()
    }
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        //    let touchPoint = sender.location(in: view?.window)
        //    var initialTouchPoint = CGPoint.zero
        //
        //    switch sender.state {
        //    case .began:
        //        initialTouchPoint = touchPoint
        //    case .changed:
        //        if touchPoint.y > initialTouchPoint.y {
        //            view.frame.origin.y = touchPoint.y - initialTouchPoint.y
        //        }
        //    case .ended, .cancelled:
        //        if touchPoint.y - initialTouchPoint.y > 200 {
        //            dismiss(animated: true, completion: nil)
        //        } else {
        //            UIView.animate(withDuration: 0.2, animations: {
        //                self.view.frame = CGRect(x: 0,
        //                                         y: 0,
        //                                         width: self.view.frame.size.width,
        //                                         height: self.view.frame.size.height)
        //            })
        //        }
        //    case .failed, .possible:
        //        break
        //
        //    default:break
        //    }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any){
        //-------------------------To check coperate flow---------------------------------------
        for (index, fk) in self.selectedFks.enumerated(){
            self.journey?[index].fk = fk
            self.journey?[index].farepr = self.selectedFarepr[index]
        }
        //---------------------------------------------------------------------------------------
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.blurView.alpha = 0
            self.dataDisplayViewBottom.constant = -(self.dataDisplayView.bounds.size.height);
            self.dataDisplayViewTop.constant = (self.dataDisplayView.bounds.size.height);
            self.view.layoutIfNeeded()
        }, completion: { (void) in
            self.dismiss(animated: true, completion: nil)
        })
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
                            if let data = result["data"] as? NSDictionary {
                                self.upgardeResult = NSArray()

                                if let other_fares = data.value(forKey: "other_fares") as? NSArray{
                                    
                                    if other_fares.count > 0
                                    {
                                        self.actInd.stopAnimating()
                                        
                                        var fareArray = NSArray()
                                        if other_fares.count > 1{
                                            fareArray = other_fares
                                        }else{
                                            fareArray = other_fares[0] as! NSArray
                                        }
                                        
                                        let date = Date()
                                        let calendar = Calendar.current
                                        let hour = calendar.component(.hour, from: date)
                                        let minutes = calendar.component(.minute, from: date)
                                        let seconds = calendar.component(.second, from: date)
                                        
                                        let arr = ["Time" : "\(hour):\(minutes):\(seconds)",
                                            "selectedJourneyFK" : fk,
                                            "upgradeArray":fareArray] as NSDictionary
                                        
                                        self.appdelegate.upgradeDataMutableArray.add(arr)
                                        
                                        if index == 0{
                                            self.displayFaresForSelectedIndex(selectedIndex: index)
                                        }
                                        
                                    }else{
                                        self.actInd.stopAnimating()
                                        
                                        self.planDisplayView.isHidden = true
                                        self.noDataFoundView.isHidden = false
                                    }
                                }else{
                                    self.actInd.stopAnimating()
                                    
                                    self.planDisplayView.isHidden = true
                                    self.noDataFoundView.isHidden = false
                                }
                            }else{
                                self.actInd.stopAnimating()
                                
                                self.planDisplayView.isHidden = true
                                self.noDataFoundView.isHidden = false
                            }
                        }else{
                            self.actInd.stopAnimating()
                            
                            self.planDisplayView.isHidden = true
                            self.noDataFoundView.isHidden = false
                        }
                    }
                }
            }catch{
            }
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    
    func displayFaresForSelectedIndex(selectedIndex:Int){
        var storedFKArray = [String]()

        for i in 0..<self.appdelegate.upgradeDataMutableArray.count{
            if let ass = self.appdelegate.upgradeDataMutableArray[i] as? NSDictionary
            {
                let index = ass.value(forKey: "selectedJourneyFK") as! String
                storedFKArray.append(index)
            }
        }
        
        if !storedFKArray.contains(self.journey[selectedIndex].fk){
            self.noDataFoundView.isHidden = true
            self.planDisplayView.isHidden = true
            self.journeyPageControl.isHidden = true
            
            self.actInd.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            self.actInd.style = UIActivityIndicatorView.Style.white
            self.view.addSubview(self.actInd)
            self.actInd.startAnimating()
            
            callAPIForUpgrade(sid: sid, fk: journey[selectedIndex].fk, fare: "\(journey[selectedIndex].farepr)", journeyObj: journey[selectedIndex], index: selectedIndex)
            
            selectedLocationIndex = selectedIndex
            journeyNameCollectionView.reloadData()
        }else{
            for i in 0..<self.appdelegate.upgradeDataMutableArray.count{
                if let ass = self.appdelegate.upgradeDataMutableArray[i] as? NSDictionary
                {
                    let index = ass.value(forKey: "selectedJourneyFK") as! String
                    if self.journey[selectedIndex].fk == index{
                        let upgradeArray = ass.value(forKey: "upgradeArray") as! NSArray
                        self.upgardeResult = upgradeArray
                        selectedPlanIndex = selectedIndex
                        selectedLocationIndex = selectedIndex
                        selectedFareName = (journey[selectedIndex].leg.first?.flights.first?.fbn)!.lowercased()
                        self.planDisplayView.isHidden = false
                        self.noDataFoundView.isHidden = true
                        self.journeyPageControl.numberOfPages = self.upgardeResult.count
                        self.planCollectionView.contentSize = .zero
                        viewSlideInFromRight(toLeft: self.planCollectionView)
                        self.planCollectionView.reloadData()
                        journeyNameCollectionView.reloadData()
                    }
                }
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
