//
//  IndUpgradeFlightVC.swift
//  AERTRIP
//
//  Created by Apple  on 22.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class IndUpgradeFlightVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    @IBOutlet weak var grabberView: UIView!
    @IBOutlet weak var upgradeYourFlightLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var journeyPageControl: UIPageControl!
    @IBOutlet weak var planCollectionView: UICollectionView!
    @IBOutlet weak var planCollectionViewBottom: NSLayoutConstraint!
    @IBOutlet weak var noDataFoundView: UIView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    //MARK:- Variable Declaration
    var journey: [IntJourney]!
    //    var journeyCombo: [CombinationJourney]!
    var viewModel = FlightDetailsVM()
    
    var taxesResult : [String : String]!
    var sid = ""
    var fk = ""
    var fare = ""
    var selectedPlanIndex = -1
    var isNewSubPoint = false
    
    var selectedLocationIndex = 0
    var upgardeResult = NSArray()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    let cellScale : CGFloat = 0.92
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    var selectedJourneyFK = [String]()
    
    var fareBreakupVC:IntFareBreakupVC?
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    let clearCache = ClearCache()
    var fewSeatsLeftViewHeight = 0
    var selectedFareName = ""
    var isFirstJourneyHasFareResp = false
    var bookFlightObject = BookFlightObject()
    
    var intAirportDetailsResult : [String : IntAirportDetailsWS]!
    var intAirlineDetailsResult : [String : IntAirlineMasterWS]!
    var journeyTitle:NSAttributedString?
    var journeyDate:String?
    var intFlights : [IntFlightDetail]?
    var selectedJourney = IntJourney(jsonData: JSON())
    
    //MARK:- Initialise Views
    override func viewDidLoad(){
        super.viewDidLoad()
        self.setupViewModel()
        self.planCollectionView.delegate = self
        self.planCollectionView.dataSource = self
        clearCache.checkTimeAndClearUpgradeDataCache()
        
        self.planCollectionView.isHidden = true
        self.noDataFoundView.isHidden = true
        self.setupViewModel()
        grabberView.layer.cornerRadius = 2
        
        planCollectionView.register( UINib(nibName: "PlansCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "plansCell")
        
        journeyPageControl.numberOfPages = upgardeResult.count
        journeyPageControl.hidesForSinglePage = true
        journeyPageControl.currentPage = 0
        self.selectedJourney = self.journey?.first ?? IntJourney(JSON())
        setupFarebreakupView()
        setupDisplayView()
        
        DispatchQueue.main.async {
            if self.journey != nil{
                
                if self.appdelegate.upgradeDataMutableArray.count == 0{
                    self.actInd.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                    self.actInd.style = UIActivityIndicatorView.Style.white
                    self.view.addSubview(self.actInd)
                    self.actInd.startAnimating()
                    
                    for i in 0..<self.journey.count{
                        self.callAPIForUpgrade(sid: self.sid, fk: self.journey[i].fk, fare: "\(self.journey[i].farepr)")
                    }
                }else{
                    for i in 0..<self.appdelegate.upgradeDataMutableArray.count{
                        if let ass = self.appdelegate.upgradeDataMutableArray[i] as? NSDictionary
                        {
                            let index = ass.value(forKey: "selectedJourneyFK") as! String
                            if self.journey.first!.fk == index{
                                let upgradeArray = ass.value(forKey: "upgradeArray") as! NSArray
                                self.upgardeResult = upgradeArray
                                self.selectedFareName = (self.journey.first?.legsWithDetail.first?.flightsWithDetails.first?.fbn ?? "").lowercased()
                                self.planCollectionView.isHidden = false
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
                            self.callAPIForUpgrade(sid: self.sid, fk: self.journey[i].fk, fare: "\(self.journey[i].farepr)")
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
        
        selectedFareName = ((journey?.first?.legsWithDetail.first?.flightsWithDetails.first?.fbn ?? "" ).lowercased())
    }
    
    override func viewDidLayoutSubviews()
    {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        let colorOne = UIColor(displayP3Red: ( 0.0 / 255.0), green: ( 204.0 / 255.0), blue: ( 153 / 255.0), alpha: 1.0)
        let colorTwo = UIColor(displayP3Red: (41.0/255.0), green: ( 176.0 / 255.0) , blue: ( 182 / 255.0), alpha: 1.0)
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setupFarebreakupView(){
        let fareBreakupVC = IntFareBreakupVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
        fareBreakupVC.taxesResult = taxesResult
        fareBreakupVC.journey = self.journey
        fareBreakupVC.sid = sid
        fareBreakupVC.isFromFlightDetails = true
        fareBreakupVC.fromScreen = "upgradePlan"
        fareBreakupVC.isUpgradePlanScreenVisible = true
        fareBreakupVC.delegate = self
        fareBreakupVC.bookFlightObject = self.bookFlightObject
        fareBreakupVC.fewSeatsLeftViewHeightFromFlightDetails = fewSeatsLeftViewHeight
        fareBreakupVC.view.autoresizingMask = []
        self.view.addSubview(fareBreakupVC.view)
        self.addChild(fareBreakupVC)
        fareBreakupVC.didMove(toParent: self)
        self.fareBreakupVC = fareBreakupVC
    }
    
    func setupDisplayView(){
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScale)
        guard self.journey != nil else {return}
        //            let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        if fewSeatsLeftViewHeight == 40{
            self.planCollectionViewBottom.constant = 90
        }else{
            self.planCollectionViewBottom.constant = 50 //+ bottomInset
        }
        if let layout = self.planCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.itemSize = CGSize(width: cellWidth, height: self.planCollectionView.frame.height)
            planCollectionView.contentInset = UIEdgeInsets(top: 0 , left: 16.0, bottom: 0, right: 16)
            planCollectionView.decelerationRate = .init(rawValue: 0.5)
            
        }
    }
    
    
    func setupSwipeDownGuesture(){
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(panGestureRecognizerHandler(_:)))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK:- CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return upgardeResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plansCell", for: indexPath) as! PlansCollectionViewCell
        
        if upgardeResult.count > 0{
            if !cell.isAnimated {
                UIView.animate(withDuration: 0.5, delay: 0.5 * Double(indexPath.row), usingSpringWithDamping: 1.5, initialSpringVelocity: 0.5, options: indexPath.row % 2 == 0 ? .transitionFlipFromLeft : .transitionFlipFromRight, animations: {
                    
                    self.viewSlideInFromRight(toLeft: cell)
                    
                }, completion: { (done) in
                    cell.isAnimated = true
                })
            }
            
            var titleVal = ""
            let bc = ((upgardeResult[indexPath.row] as AnyObject).value(forKey: "bc") as? [[String]] ?? []).flatMap{$0}
            let title = ((upgardeResult[indexPath.row] as AnyObject).value(forKey: "title") as? [[String]] ?? []).flatMap{$0}
            if title.count != 0{
                for (index, name) in title.enumerated(){
                    var newbc = ""
                    if bc.count < index{
                        newbc = bc.first ?? ""
                    }else{
                        newbc = bc[index]
                    }
                    let val = name + " (\(newbc))"
                    if !titleVal.contains(val){
                        if index == title.count - 1{
                            titleVal += " \(val)"
                        }else if index == 0{
                            titleVal += "\(val),"
                        }else{
                             titleVal += " \(val),"
                        }
                    }
                }
            }else{
                let className = ((upgardeResult[indexPath.row] as AnyObject).value(forKey: "class") as? [[String]] ?? []).flatMap{$0}
                for (index, name) in className.enumerated(){
                    var newbc = ""
                    if bc.count < index{
                        newbc = bc.first ?? ""
                    }else{
                        newbc = bc[index]
                    }
                    let val = name + " (\(newbc))"
                    if !titleVal.contains(val){
                        if index == className.count - 1{
                            titleVal += " \(val)"
                        }else if index == 0{
                            titleVal += "\(val),"
                        }else{
                            titleVal += " \(val),"
                        }
                    }
                }
                
            }
            if titleVal.last == ","{
                titleVal.removeLast()
            }
            cell.titleLabel.text = titleVal
            cell.titleLabel.numberOfLines = 2
            
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
                                    }else if displayString.contains(find: " · "){
                                        displayString = displayString.replacingOccurrences(of: " · ", with: "\n•   ")
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
            
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width * cellScale, height: collectionView.height)
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
            if let layout = self.planCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
                let cellWidthIncludingSpaces = layout.itemSize.width + layout.minimumLineSpacing
                
                var offset = targetContentOffset.pointee
                let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpaces
                let roundedIndex = round(index)
                
                offset = CGPoint(x: roundedIndex * cellWidthIncludingSpaces - scrollView.contentInset.left, y: scrollView.contentInset.top)
                targetContentOffset.pointee = offset
                
            }
        }
    }
    
    //MARK:- Button Action
    @objc func selectPlanButtonClicked(_ sender:UIButton)
    {
        let fareTypeName = (upgardeResult[sender.tag] as AnyObject).value(forKey: "FareTypeName") as? NSArray
        selectedFareName = ((fareTypeName?[0] as? NSArray)?.firstObject as! String).lowercased()
        if let flightDetails = ((upgardeResult[sender.tag] as AnyObject).value(forKey: "flight_result")){
            let json = JSON(flightDetails)
            self.selectedJourney = IntJourney(jsonData: json)
            
        }
        selectedPlanIndex = sender.tag
        if let farepr = (upgardeResult[sender.tag] as AnyObject).value(forKey: "farepr") as? Int
        {
            self.selectedJourney.farepr = farepr
            let price = getPrice(price: Double(farepr))
            fareBreakupVC?.bookingAmountLabel.text = price
            
        }
        
        planCollectionView.reloadData()
    }
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        
    }
    
    @IBAction func closeButtonClicked(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Call API
    func callAPIForUpgrade(sid: String, fk: String, fare: String){
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .upgradeAPIResult(sid: sid, fk: fk, oldFare: fare), completionHandler: {[weak self] (data) in
            guard let self = self else {return}
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
                                        
                                        self.displayFaresForSelectedIndex(selectedIndex: 0)
                                        
                                        
                                    }else{
                                        self.actInd.stopAnimating()
                                        
                                        self.planCollectionView.isHidden = true
                                        self.noDataFoundView.isHidden = false
                                    }
                                }else{
                                    self.actInd.stopAnimating()
                                    
                                    self.planCollectionView.isHidden = true
                                    self.noDataFoundView.isHidden = false
                                }
                            }else{
                                self.actInd.stopAnimating()
                                
                                self.planCollectionView.isHidden = true
                                self.noDataFoundView.isHidden = false
                            }
                        }else{
                            self.actInd.stopAnimating()
                            
                            self.planCollectionView.isHidden = true
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
            self.planCollectionView.isHidden = true
            self.journeyPageControl.isHidden = true
            
            self.actInd.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            self.actInd.style = UIActivityIndicatorView.Style.white
            self.view.addSubview(self.actInd)
            self.actInd.startAnimating()
            
            callAPIForUpgrade(sid: sid, fk: journey[selectedIndex].fk, fare: "\(journey[selectedIndex].farepr)")
            
            selectedLocationIndex = selectedIndex
            //            journeyNameCollectionView.reloadData()
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
                        selectedFareName = (journey?.first?.legsWithDetail.first?.flightsWithDetails.first?.fbn ?? "").lowercased()
                        self.planCollectionView.isHidden = false
                        self.noDataFoundView.isHidden = true
                        self.journeyPageControl.numberOfPages = self.upgardeResult.count
                        self.planCollectionView.contentSize = .zero
                        viewSlideInFromRight(toLeft: self.planCollectionView)
                        self.planCollectionView.reloadData()
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


extension IndUpgradeFlightVC : FareBreakupVCDelegate{
    func tapUpgradeButton() {
        
    }
    
        func bookButtonTapped(journeyCombo: [CombinationJourney]?){
            self.setupViewModel()
            if #available(iOS 13.0, *) {
                self.isModalInPresentation = true
            }
            AppFlowManager.default.proccessIfUserLoggedInForFlight(verifyingFor: .loginVerificationForCheckout,presentViewController: true, vc: self) { [weak self](isGuest) in
                guard let self = self else {return}
                self.fareBreakupVC?.hideShowLoader(isHidden: false)
                let vc = PassengersSelectionVC.instantiate(fromAppStoryboard: .PassengersSelection)
                vc.viewModel.taxesResult = self.taxesResult
                vc.viewModel.sid = self.sid
                vc.viewModel.intAirportDetailsResult = self.intAirportDetailsResult
                vc.viewModel.intAirlineDetailsResult = self.intAirlineDetailsResult
                vc.viewModel.bookingObject = self.bookFlightObject
                vc.viewModel.journeyTitle = self.journeyTitle
                vc.viewModel.journeyDate = self.journeyDate
                AppFlowManager.default.removeLoginConfirmationScreenFromStack()
                self.pushToPassenserSelectionVC(vc)
            }
        }


        func pushToPassenserSelectionVC(_ vc: PassengersSelectionVC){
            self.presentedViewController?.dismiss(animated: false, completion: nil)
            self.view.isUserInteractionEnabled = false
            if self.viewModel.intJourney?.count != 0{
                self.viewModel.intJourney?[0] = self.selectedJourney
            }
                
            self.viewModel.fetchConfirmationData(){[weak self] success, errorCodes in
                guard let self = self else {return}
                self.view.isUserInteractionEnabled = true
                self.fareBreakupVC?.hideShowLoader(isHidden: true)
                if success{
                    DispatchQueue.main.async{
                        if #available(iOS 13.0, *) {
                            self.isModalInPresentation = false
                        }
                        vc.viewModel.newItineraryData = self.viewModel.itineraryData
                        if let nav = AppFlowManager.default.currentNavigation{
                            nav.pushViewController(vc, animated: true)
                        }else{
                            let nav = UINavigationController(rootViewController: vc)
                            nav.modalPresentationStyle = .fullScreen
                            nav.modalPresentationCapturesStatusBarAppearance = true
                            self.present(nav, animated: true, completion: nil)
                        }
                    }
                }else{
                    AppGlobals.shared.showErrorOnToastView(withErrors: errorCodes, fromModule: .hotelsSearch)
                }
                
            }
        }

        
        func infoButtonTapped(isViewExpanded: Bool) {
            
        }
        
        
        func setupViewModel(){
            self.viewModel.sid = self.sid
            self.viewModel.journey = []
            self.viewModel.intJourney = self.journey
            self.viewModel.journeyType = (self.bookFlightObject.isDomestic) ? .domestic : .international
        }
        
        
        
    }
