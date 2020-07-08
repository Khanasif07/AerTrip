//
//  FlightDetailsBaseVC.swift
//  FlightDetails
//
//  Created by Monika Sonawane on 11/09/19.
//  Copyright © 2019 Monika Sonawane. All rights reserved.
//

protocol flightDetailsPinFlightDelegate : AnyObject {
    func reloadRowFromFlightDetails(fk:String,isPinned:Bool)
}

import UIKit
//import HMSegmentedControl

class FlightDetailsBaseVC: UIViewController, UIScrollViewDelegate, flightDetailsSmartIconsDelegate, FareBreakupVCDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var displayViewBottom: NSLayoutConstraint!
    @IBOutlet weak var newTitleDisplayView: UIView!
    @IBOutlet weak var displayViewTop: NSLayoutConstraint!
    @IBOutlet weak var grabberView: UIView!
    @IBOutlet weak var displayScrollView: UIScrollView!
    @IBOutlet weak var dataDisplayView: UIView!
    
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var addToTripButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    //MARK:- Variable Declaration
    var journeyGroup: JourneyOnewayDisplay!
    var journey: [Journey]!
    var journeyCombo: [CombinationJourney]!

    var titleString : NSAttributedString!
    var journeyArray : [JourneyOnewayDisplay]!
    var airportDetailsResult : [String : AirportDetailsWS]!
    var airlineDetailsResult : [String : AirlineMasterWS]!
    var flightPerformanceResult : [flightPerformaceResponse]? = [flightPerformaceResponse]()
    var taxesResult : [String : String]!
    
    weak var delegate : flightDetailsPinFlightDelegate?
    var airlineData:[String:String]?
    var flights : [FlightDetail]?
    var sid = ""
    var bookFlightObject = BookFlightObject()
    var selectedIndex : IndexPath?
    var isJourneyPinned = false
    var isFSRVisible = false
    var labelPositionisLeft = true
    var headerSegmentView: HMSegmentedControl!
    var selectedJourneyFK = [String]()
    let clearCache = ClearCache()
    var backgroundViewForFareBreakup = UIView()
    var journeyTitle:NSAttributedString?
    var journeyDate:String?
    //attributes for international retrun and multicity
    var isInternational = false//For International results.
    var intAirportDetailsResult : [String : IntAirportDetailsWS]!
    var intAirlineDetailsResult : [String : IntAirlineMasterWS]!
    var intJourney: [IntJourney]!
    var intFlights : [IntFlightDetail]?
    var needToAddFareBreakup = true
    weak var refundDelegate:UpdateRefundStatusDelegate?
    var isForCheckOut = false
    var viewModel = FlightDetailsVM()
    var intFareBreakup:IntFareBreakupVC?
    var fareBreakup:FareBreakupVC?
    
    //MARK:- Initial Display
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        backgroundViewForFareBreakup.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.view.addSubview(backgroundViewForFareBreakup)
        grabberView.layer.cornerRadius = 2
        
        self.navigationController?.navigationBar.isHidden = true

        if isInternational || !(needToAddFareBreakup){
            self.setFlightDetailsForInternational()
        }else{
           self.setFlightDetailsForDomestic()
        }
        setupInitialViews()
        setupSegmentView()
        self.setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        clearCache.checkTimeAndClearUpgradeDataCache()
        clearCache.checkTimeAndClearFlightPerformanceResultCache(journey: journey)
        clearCache.checkTimeAndClearFlightBaggageResultCache()
    }
    
    //MARK:- Initialise Views
    func setupInitialViews()
    {
        setupScrollView()
        initialDisplayView()
        if needToAddFareBreakup{
            if !(self.isInternational){
                setupFarebreakupView()
            }else{
                setFareBreakupForInt()
            }
        }else{
            self.displayViewBottom.constant = 0
        }
        setupSwipeDownGuesture()
    }
    
    func setupScrollView()
    {
        displayScrollView.delegate = self
        displayScrollView.bounces = false
        displayScrollView.isPagingEnabled = true
        displayScrollView.alwaysBounceHorizontal = false
        displayScrollView.alwaysBounceVertical = false
        displayScrollView.showsVerticalScrollIndicator = false
        displayScrollView.showsHorizontalScrollIndicator = false
        displayScrollView.contentSize = CGSize( width: (3 * UIScreen.main.bounds.size.width), height:0)
        self.displayScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func initialDisplayView(){
        if isInternational || !(needToAddFareBreakup){
            addIntFlightInfoVC()
            addIntBaggageVC()
            addIntFareInfo()
        }else{
            addFlightInfoVC()
            addBaggageVC()
            addFareInfoVC()
        }
        
    }
    
    func setupFarebreakupView(){        
        let fareBreakupVC = FareBreakupVC(nibName: "FareBreakupVC", bundle: nil)
        fareBreakupVC.isFewSeatsLeftViewVisible = true
        fareBreakupVC.taxesResult = taxesResult
        fareBreakupVC.journey = self.journey
        fareBreakupVC.flights = flights
        fareBreakupVC.delegate = self
        fareBreakupVC.sid = sid
        if isFSRVisible == true{
            fareBreakupVC.fewSeatsLeftViewHeightFromFlightDetails = 40
        }else{
            fareBreakupVC.fewSeatsLeftViewHeightFromFlightDetails = 0
        }
        fareBreakupVC.isFromFlightDetails = true
        fareBreakupVC.selectedJourneyFK = selectedJourneyFK
        fareBreakupVC.flightAdultCount = bookFlightObject.flightAdultCount
        fareBreakupVC.flightChildrenCount = bookFlightObject.flightChildrenCount
        fareBreakupVC.flightInfantCount = bookFlightObject.flightInfantCount
        fareBreakupVC.journeyCombo = journeyCombo
        fareBreakupVC.view.autoresizingMask = []
        self.view.addSubview(fareBreakupVC.view)
        self.addChild(fareBreakupVC)
        fareBreakupVC.didMove(toParent: self)
        self.fareBreakup = fareBreakupVC
    }
    
    func setupSwipeDownGuesture(){
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(panGestureRecognizerHandler(_:)))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    
    //MARK:- initialDisplayViews
    
    func addFlightInfoVC(){
        let bottomInset = ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!)
        
        let storyboard = UIStoryboard(name: "FlightInfoVC", bundle: nil)
        let flightInfoVC:FlightInfoVC =
            storyboard.instantiateViewController(withIdentifier: "FlightInfoVC") as!
        FlightInfoVC
        flightInfoVC.sid = sid
        flightInfoVC.titleString = titleString
        flightInfoVC.journey = journey
        if isFSRVisible == true{
            flightInfoVC.fewSeatsLeftViewHeight = 40
        }else{
            flightInfoVC.fewSeatsLeftViewHeight = 0
        }
        flightInfoVC.selectedIndex = selectedIndex
        flightInfoVC.airportDetailsResult = airportDetailsResult
        flightInfoVC.airlineDetailsResult = airlineDetailsResult
        flightInfoVC.selectedJourneyFK = selectedJourneyFK
        flightInfoVC.view.frame = CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.size.width, height :self.displayScrollView.frame.height-CGFloat(bottomInset))
        flightInfoVC.view.autoresizingMask = []
        self.displayScrollView.addSubview(flightInfoVC.view)
        self.addChild(flightInfoVC)
        flightInfoVC.didMove(toParent: self)
    }
    
    func addBaggageVC(){
        let bottomInset = ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!)
        
        let baggageVC = BaggageVC(nibName: "BaggageVC", bundle: nil)
        baggageVC.journey = journey
        baggageVC.sid = sid
        if isFSRVisible == true{
            baggageVC.fewSeatsLeftViewHeight = 40
        }else{
            baggageVC.fewSeatsLeftViewHeight = 0
        }
        
        baggageVC.airportDetailsResult = airportDetailsResult
        baggageVC.view.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height :self.displayScrollView.frame.height-CGFloat(bottomInset))
        baggageVC.view.autoresizingMask = []
        self.displayScrollView.addSubview(baggageVC.view)
        self.addChild(baggageVC)
        baggageVC.didMove(toParent: self)
    }
    
    func addFareInfoVC(){
        let bottomInset = ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!)
        
        let fareInfoVc = FareInfoVC(nibName: "FareInfoVC", bundle: nil)
        fareInfoVc.journey = journey
        fareInfoVc.flights = flights
        fareInfoVc.sid = sid
        if isFSRVisible == true{
            fareInfoVc.fewSeatsLeftViewHeight = 40
        }else{
            fareInfoVc.fewSeatsLeftViewHeight = 0
        }
        fareInfoVc.delegate = self
        fareInfoVc.selectedIndex = selectedIndex
        fareInfoVc.flightAdultCount = bookFlightObject.flightAdultCount
        fareInfoVc.flightChildrenCount = bookFlightObject.flightChildrenCount
        fareInfoVc.flightInfantCount = bookFlightObject.flightInfantCount
        fareInfoVc.airportDetailsResult = airportDetailsResult
        fareInfoVc.view.frame = CGRect(x: UIScreen.main.bounds.size.width * 2, y: 0, width: UIScreen.main.bounds.size.width, height :self.displayScrollView.frame.height-CGFloat(bottomInset))
        fareInfoVc.view.autoresizingMask = []
        self.displayScrollView.addSubview(fareInfoVc.view)
        self.addChild(fareInfoVc)
        fareInfoVc.didMove(toParent: self)
    }
    
    
    // MARK:- Scrollview Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNum = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        headerSegmentView.setSelectedSegmentIndex(UInt(pageNum), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNum = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        headerSegmentView.setSelectedSegmentIndex(UInt(pageNum), animated: true)
    }
    
    //MARK:- DisplaySelectedSegmentData
    
    func displaySelectedSegmentData(selectedSegment:Int)
    {
        switch selectedSegment
        {
        case 0:
            self.displayScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            break
            
        case 1:
            self.displayScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.size.width, y: 0), animated: true)
            break
            
        case 2:
            self.displayScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.size.width*2, y: 0), animated: true)
            break
            
        case 3:
            self.displayScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.size.width*3, y: 0), animated: true)
            break
            
        default:
            self.displayScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            break
        }
    }
    
    //MARK:- HMSegmentedControl SegmentView UI Methods
    
    func setupSegmentView(){
        
        self.headerSegmentView = HMSegmentedControl()
        
        self.headerSegmentView.sectionTitles = ["Flight Info", "Baggage", "Fare Info"]
        self.headerSegmentView.selectedSegmentIndex = 0
        
        self.headerSegmentView.selectionIndicatorLocation = .down;
        self.headerSegmentView.selectionIndicatorHeight = 2
        self.headerSegmentView.selectionIndicatorColor = .AertripColor
        self.headerSegmentView.shouldAnimateUserSelection = true
        //self.headerSegmentView.dec
        
        self.headerSegmentView.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black , NSAttributedString.Key.font : UIFont(name:"SourceSansPro-Regular" , size: 16)! ]
        self.headerSegmentView.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black , NSAttributedString.Key.font : UIFont(name:"SourceSansPro-Semibold" , size: 16)!]
        self.headerSegmentView.addTarget(self, action: #selector(headerSegmentChanged), for: .valueChanged)
        
        self.newTitleDisplayView.addSubview(self.headerSegmentView)
        headerSegmentView.snp.makeConstraints { (make) in
            make.left.equalTo(self.newTitleDisplayView).offset(0)
            make.bottom.equalTo(self.newTitleDisplayView).offset(0)
            make.trailing.equalTo(self.newTitleDisplayView).offset(0)
            make.top.equalTo(self.newTitleDisplayView).offset(0)
        }
    }
    
    @IBAction func headerSegmentChanged(_ sender: HMSegmentedControl) {
        displaySelectedSegmentData(selectedSegment: self.headerSegmentView.selectedSegmentIndex)
    }
    
    
    func reloadSmartIconsAtIndexPath() {
        self.delegate?.reloadRowFromFlightDetails(fk: journey.first!.fk, isPinned: false)
    }

    //MARK:- Button Actions
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        guard !self.needToAddFareBreakup else {
            return
        }
                let touchPoint = sender.location(in: view?.window)
                var initialTouchPoint = CGPoint.zero
        
                switch sender.state {
                case .began:
                    initialTouchPoint = touchPoint
                case .changed:
                    if touchPoint.y > (initialTouchPoint.y + 20) {
                        view.frame.origin.y = (touchPoint.y - initialTouchPoint.y) - 20
                    }
                case .ended, .cancelled:
                    if touchPoint.y - initialTouchPoint.y > 200 {
//                        dismiss(animated: true, completion: nil)
                        UIView.animate(withDuration: 0.2, animations: {
                            self.view.frame.origin.y = UIScreen.height
                        }) { _ in
                            (self.parent as? PassengersSelectionVC)?.detailsBaseVC = nil
                            self.willMove(toParent: nil)
                            self.view.removeFromSuperview()
                            self.removeFromParent()
                        }
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
    
    @IBAction func closeButtonClicked(_ sender: Any)
    {
        if needToAddFareBreakup{
            self.dismiss(animated: true, completion: nil)
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.view.frame.origin.y = UIScreen.height
            }) { _ in
                (self.parent as? PassengersSelectionVC)?.detailsBaseVC = nil
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
        
    }
    
    @IBAction func pinButtonClicked(_ sender: Any)
    {
        pinButton.isHighlighted = false
        pinButton.showsTouchWhenHighlighted = false
        
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0, 1.5, 1.0]
        animation.keyTimes = [0, 0.5, 1]
        animation.duration = 0.2
        pinButton.layer.add(animation, forKey: "pulse")
        
        var isPinned = false
        if !isInternational{
            var fk = [String]()
            if journey != nil{
                for i in 0...journey.count-1{
                    fk.append(journey[i].fk)
                    if journey[i].isPinned == true{
                        journey[i].isPinned = false
                        isPinned = false
                        pinButton.setImage(UIImage(named: "pinGreen"), for: .normal)
                    }else{
                        journey[i].isPinned = true
                        isPinned = true
                        pinButton.setImage(UIImage(named: "FilledpinGreen"), for: .normal)
                    }
                }
            }
            
            self.delegate?.reloadRowFromFlightDetails(fk: journey.first!.fk, isPinned: isPinned)
        }else{
            if let journey = self.intJourney?.first{
                if journey.isPinned{
                    pinButton.setImage(UIImage(named: "pinGreen"), for: .normal)
                }else{
                    pinButton.setImage(UIImage(named: "FilledpinGreen"), for: .normal)
                }
                var newJourney = journey
                newJourney.isPinned = !journey.isPinned
                self.intJourney[0] = newJourney
                self.delegate?.reloadRowFromFlightDetails(fk: journey.fk, isPinned: !journey.isPinned)
            }
        }
    }
    
    @IBAction func addToTripButtonClicked(_ sender: Any){
        if !isInternational{
            let tripListVC = TripListVC(nibName: "TripListVC", bundle: nil)
            tripListVC.view.frame = self.view.frame
            tripListVC.journey = self.journey
            tripListVC.modalPresentationStyle = .overCurrentContext
            self.present(tripListVC, animated: true, completion: nil)
        }else{
            
        }
        
    }
    
    @IBAction func shareButtonClicked(_ sender: Any){
        guard !isInternational else {return}
        let flightAdultCount = bookFlightObject.flightAdultCount
        let flightChildrenCount = bookFlightObject.flightChildrenCount
        let flightInfantCount = bookFlightObject.flightInfantCount
        
        let isDomestic = bookFlightObject.isDomestic
        
        let cc = journey.first?.cc
        var trip_type = ""
        
        var origin = ""
        var destination = ""
        var departureDate = ""
        var returnDate = ""
        
        if journey.count == 1{
            origin.append("origin=\(journey[0].ap[0])&")
            destination.append("destination=\(journey[0].ap[1])&")
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let showDate = inputFormatter.date(from: journey[0].ad)
            inputFormatter.dateFormat = "dd-MM-yyyy"
            let newAd = inputFormatter.string(from: showDate!)
            
            departureDate.append("depart=\(newAd)&")
            
            returnDate.append("return=&")
        }else{
            for i in 0..<journey.count{
                origin.append("origin[\(i)]=\(journey[i].ap[0])&")
                destination.append("destination[\(i)]=\(journey[i].ap[1])&")
                
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd"
                let showDate = inputFormatter.date(from: journey[i].ad)
                inputFormatter.dateFormat = "dd-MM-yyyy"
                let newAd = inputFormatter.string(from: showDate!)
                
                departureDate.append("depart[\(i)]=\(newAd)&")
                
                
                inputFormatter.dateFormat = "yyyy-MM-dd"
                let showDate1 = inputFormatter.date(from: journey[i].dd)
                inputFormatter.dateFormat = "dd-MM-yyyy"
                let newDd = inputFormatter.string(from: showDate1!)
                
                returnDate.append("return[\(i)]=\(newDd)&")
            }
        }
        
        if journey.count == 1{
            trip_type = "single"
        }else if journey.count > 2{
            trip_type = "multi"
        }else{
            trip_type = "return"
        }
        
        if trip_type == "return"{
            origin.append("origin=\(journey[0].ap[0])&")
            destination.append("destination=\(journey[0].ap[1])&")
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let showDate = inputFormatter.date(from: journey[0].ad)
            inputFormatter.dateFormat = "dd-MM-yyyy"
            let newAd = inputFormatter.string(from: showDate!)
            
            departureDate.append("depart=\(newAd)&")
            
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let showDate1 = inputFormatter.date(from: journey[1].dd)
            inputFormatter.dateFormat = "dd-MM-yyyy"
            let newDd = inputFormatter.string(from: showDate1!)
            
            returnDate.append("return=\(newDd)&")
        }
        
        var pinnedFlightFK = ""
        
        for i in 0..<journey.count{
            if i == journey.count-1{
                pinnedFlightFK.append("PF[\(i)]=\(journey[i].fk)")
            }else{
                pinnedFlightFK.append("PF[\(i)]=\(journey[i].fk)&")
            }
        }
        
        let postData = NSMutableData()
        print("https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(flightAdultCount)&child=\(flightChildrenCount)&infant=\(flightInfantCount)&\(origin)\(destination)\(departureDate)\(returnDate)cabinclass=\(cc!)&pType=flight&isDomestic=\(isDomestic)&\(pinnedFlightFK)")
        
        let parameters = [
            [
                "name": "u",
                "value": "https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(flightAdultCount)&child=\(flightChildrenCount)&infant=\(flightInfantCount)&\(origin)\(destination)\(departureDate)\(returnDate)cabinclass=\(cc!)&pType=flight&isDomestic=\(isDomestic)&\(pinnedFlightFK)"
            ]
        ]
        
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        
        var body = ""
        let _: NSError? = nil
        for param in parameters {
            let paramName = param["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let filename = param["fileName"] {
                let contentType = param["content-type"]!
                let fileContent = try! String(contentsOfFile: filename, encoding: String.Encoding.utf8)
                body += "; filename=\"\(filename)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent
            } else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }
        
        postData.append(body.data(using: String.Encoding.utf8)!)
        
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .getShareUrl(postData: postData as Data) , completionHandler: {    (data) in
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject] {
//                        print("result= ", result)
                        
                        if result["success"] as? Bool == true{
                            if let link = (result["data"] as? NSDictionary)?.value(forKey: "u") as? String{
                                
                                
                                let textToShare = [ link ]
                                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                                activityViewController.popoverPresentationController?.sourceView = self.view
                                
                                self.present(activityViewController, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }catch{
            }
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    
    func infoButtonTapped(isViewExpanded: Bool)
    {
        if isViewExpanded == true{
            backgroundViewForFareBreakup.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.backgroundViewForFareBreakup.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.2)
            })
        }else{
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.backgroundViewForFareBreakup.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
            },completion: { _ in
                self.backgroundViewForFareBreakup.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            })
        }
    }
    
    func bookButtonTapped(journeyCombo: [CombinationJourney]?){
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        guard !self.isForCheckOut else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        if self.viewModel.journeyType == .domestic || self.intJourney == nil{
            self.fareBreakup?.hideShowLoader(isHidden: false)
            self.setupViewModel()
        }else{
            self.intFareBreakup?.hideShowLoader(isHidden: false)
        }
        AppFlowManager.default.proccessIfUserLoggedInForFlight(verifyingFor: .loginVerificationForCheckout,presentViewController: true, vc: self) { [weak self](isGuest) in
            guard let self = self else {return}
            let vc = PassengersSelectionVC.instantiate(fromAppStoryboard: .PassengersSelection)
            vc.viewModel.taxesResult = self.taxesResult
            vc.viewModel.intJourney = self.intJourney
            vc.viewModel.intFlights = self.intFlights
            vc.viewModel.selectedJourneyFK = self.selectedJourneyFK
            vc.viewModel.sid = self.sid
            vc.viewModel.intAirportDetailsResult = self.intAirportDetailsResult
            vc.viewModel.intAirlineDetailsResult = self.intAirlineDetailsResult
            vc.viewModel.bookingObject = self.bookFlightObject
            vc.viewModel.journeyTitle = self.journeyTitle
            vc.viewModel.journeyDate = self.journeyDate
            vc.viewModel.journey = self.journey
//            self.pushToPassenserSelectionVC(vc)
            AppFlowManager.default.removeLoginConfirmationScreenFromStack()
            self.pushToPassenserSelectionVC(vc)
//            AppGlobals.shared.stopLoading()
        }
    }


    func pushToPassenserSelectionVC(_ vc: PassengersSelectionVC){
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        self.view.isUserInteractionEnabled = false
        self.viewModel.fetchConfirmationData(){[weak self] success, errorCodes in
            guard let self = self else {return}
            self.view.isUserInteractionEnabled = true
            if self.viewModel.journeyType == .domestic || self.intJourney == nil{
                self.fareBreakup?.hideShowLoader(isHidden: true)
            }else{
                self.intFareBreakup?.hideShowLoader(isHidden: true)
            }
            if success{
                if #available(iOS 13.0, *) {
                    self.isModalInPresentation = false
                }
                DispatchQueue.main.async{
                    vc.viewModel.newItineraryData = self.viewModel.itineraryData
                    if let nav = AppFlowManager.default.currentNavigation{
                        nav.pushViewController(vc, animated: true)
                    }else{
                        let nav = UINavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .overFullScreen
                        nav.modalPresentationCapturesStatusBarAppearance = true
                        self.present(nav, animated: true, completion: nil)
                    }
                }
            }else{
                AppGlobals.shared.showErrorOnToastView(withErrors: errorCodes, fromModule: .flights)
            }
        }
    }
    
    func tapUpgradeButton(){
        let vc = IndUpgradeFlightVC.instantiate(fromAppStoryboard:.InternationalReturnAndMulticityDetails)
        vc.taxesResult = self.taxesResult
        vc.selectedJourneyFK = selectedJourneyFK
        vc.journey = self.intJourney
        vc.sid = self.sid
        vc.fare = "\(self.intJourney?.first?.farepr ?? 0)"
        vc.bookFlightObject = self.bookFlightObject
        vc.intAirportDetailsResult = self.intAirportDetailsResult
        vc.intAirlineDetailsResult = self.intAirlineDetailsResult
        vc.intFlights = self.intFlights
        vc.journeyTitle = self.journeyTitle
        vc.journeyDate = self.journeyDate
        vc.fewSeatsLeftViewHeight = isFSRVisible ? 40 : 0
        self.present(vc, animated: true, completion: nil)
    }
}

//Marks:- customs functions to make resulable for international return.
extension FlightDetailsBaseVC{
    
    func setFlightDetailsForDomestic(){
        if journey != nil{
            flights = journey.first?.leg.first?.flights
            for i in 0...journey.count-1{
                if (journey[i].isPinned ?? false){
                    pinButton.setImage(UIImage(named: "FilledpinGreen"), for: .normal)
                }else{
                    pinButton.setImage(UIImage(named: "pinGreen"), for: .normal)
                }
                if journey[i].fsr == 1{
                    isFSRVisible = true
                }
            }
        }
    }
    
    func setFlightDetailsForInternational(){
        if let journey = self.intJourney?.first{
            
            for legs in journey.legsWithDetail{
                self.intFlights?.append(contentsOf: legs.flightsWithDetails)
            }
            let img = (journey.isPinned) ? UIImage(named: "FilledpinGreen") : UIImage(named: "pinGreen")
             pinButton.setImage(img, for: .normal)
            isFSRVisible = (journey.fsr == 1)
        }
    }
    
    func setFareBreakupForInt(){
        let vc = IntFareBreakupVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
        if isForCheckOut{
            vc.isHideUpgradeOption = true
            vc.isCheckoutDetails = true
        }else{
            vc.isHideUpgradeOption = !(self.intJourney?.first?.otherFares ?? false)
        }
        vc.isFewSeatsLeftViewVisible = true
        vc.taxesResult = taxesResult
        vc.journey = self.intJourney
        vc.intFlights = intFlights
        vc.delegate = self
        vc.sid = sid
        if isFSRVisible == true{
            vc.fewSeatsLeftViewHeightFromFlightDetails = 40
        }else{
            vc.fewSeatsLeftViewHeightFromFlightDetails = 0
        }
        vc.isFromFlightDetails = true
        vc.selectedJourneyFK = selectedJourneyFK
        vc.bookFlightObject = bookFlightObject
        vc.journeyCombo = journeyCombo
        vc.intAirportDetailsResult = self.intAirportDetailsResult
        vc.intAirlineDetailsResult = self.intAirlineDetailsResult
        vc.bookFlightObject = self.bookFlightObject
        vc.journeyTitle = self.journeyTitle
        vc.journeyDate = self.journeyDate
        vc.view.autoresizingMask = []
        self.view.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
        self.intFareBreakup = vc
    }
    
    func addIntFlightInfoVC(){
        let bottomInset = ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!)
        
        let vc =
            IntFlightInfoVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
        vc.sid = sid
        vc.titleString = titleString
        vc.journey = intJourney?.first
        vc.airlineData = self.airlineData
        if isFSRVisible == true{
            vc.fewSeatsLeftViewHeight = 40
        }else{
            vc.fewSeatsLeftViewHeight = 0
        }
        vc.selectedIndex = selectedIndex
        vc.airportDetailsResult = intAirportDetailsResult
        vc.airlineDetailsResult = intAirlineDetailsResult
        vc.selectedJourneyFK = selectedJourneyFK
        vc.view.frame = CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.size.width, height :self.displayScrollView.frame.height-CGFloat(bottomInset))
        vc.view.autoresizingMask = []
        self.displayScrollView.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
    func addIntBaggageVC(){
        let bottomInset = ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!)
        
        let vc = IntFlightBaggageInfoVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
        vc.journey = self.intJourney?.first
        vc.sid = sid
        if isFSRVisible == true{
            vc.fewSeatsLeftViewHeight = 40
        }else{
            vc.fewSeatsLeftViewHeight = 0
        }
        vc.isForDomestic = (self.bookFlightObject.isDomestic)
        vc.airportDetailsResult = intAirportDetailsResult
        vc.view.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height :self.displayScrollView.frame.height-CGFloat(bottomInset))
        vc.view.autoresizingMask = []
        self.displayScrollView.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
    func addIntFareInfo(){
        let bottomInset = ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!)
        
        let vc = IntFareInfoVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
        vc.journey = [self.intJourney.first!]
//        fareInfoVc.flights =
        vc.sid = sid
        if isFSRVisible == true{
            vc.fewSeatsLeftViewHeight = 40
        }else{
            vc.fewSeatsLeftViewHeight = 0
        }
        vc.delegate = self
        vc.selectedIndex = selectedIndex
        vc.refundDelegate = refundDelegate
        vc.flightAdultCount = bookFlightObject.flightAdultCount
        vc.flightChildrenCount = bookFlightObject.flightChildrenCount
        vc.flightInfantCount = bookFlightObject.flightInfantCount
        vc.airportDetailsResult = self.intAirportDetailsResult
        vc.view.frame = CGRect(x: UIScreen.main.bounds.size.width * 2, y: 0, width: UIScreen.main.bounds.size.width, height :self.displayScrollView.frame.height-CGFloat(bottomInset))
        vc.view.autoresizingMask = []
        self.displayScrollView.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
    func setupViewModel(){
        self.viewModel.sid = self.sid
        self.viewModel.journey = self.journey
        self.viewModel.intJourney = self.intJourney
        self.viewModel.journeyType = (self.bookFlightObject.isDomestic) ? .domestic : .international
    }
}
