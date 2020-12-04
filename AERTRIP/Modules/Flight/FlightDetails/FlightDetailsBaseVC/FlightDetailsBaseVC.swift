//
//  FlightDetailsBaseVC.swift
//  FlightDetails
//
//  Created by Monika Sonawane on 11/09/19.
//  Copyright © 2019 Monika Sonawane. All rights reserved.
//

protocol flightDetailsPinFlightDelegate : AnyObject {
    func reloadRowFromFlightDetails(fk:String,isPinned:Bool,isPinnedButtonClicked:Bool)
    func updateRefundStatusIfPending(fk:String)
}

protocol getBaggageDimentionsDelegate :AnyObject{
    func getBaggageDimentions(baggage:[[JSONDictionary]],sender:UIButton)
}

protocol getFareRulesDelegate:AnyObject {
    func getFareRulesData(fareRules:[JSONDictionary])
}

protocol getArrivalPerformanceDelegate:AnyObject {
    func getArrivalPerformanceData(flight:FlightDetail)
}

import UIKit
import Parchment

class FlightDetailsBaseVC: BaseVC {
    
    //MARK:- Outlets
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var displayViewBottom: NSLayoutConstraint!
    @IBOutlet weak var newTitleDisplayView: UIView!
    @IBOutlet weak var displayViewTop: NSLayoutConstraint!
    @IBOutlet weak var grabberView: UIView!
    @IBOutlet weak var dataDisplayView: UIView!
    
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var addToTripButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var addToTripIndicator: UIActivityIndicatorView!
    
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
    
    fileprivate var parchmentView : PagingViewController?
    var allTabsStr = ["Flight Info", "Baggage", "Fare Info"]
    private var currentIndex: Int = 0
    var allChildVCs = [UIViewController]()
    
    var isForCheckOut = false
    var viewModel = FlightDetailsVM()
    var intFareBreakup:IntFareBreakupVC?
    var fareBreakup:FareBreakupVC?
    var navigationContronller: UINavigationController?
    var innerControllerBottomConstraint: CGFloat = 0.0
    var flightSearchResultVM: FlightSearchResultVM?
    
    let getSharableLink = GetSharableUrl()
    var isConditionReverced = false
    var appliedFilterLegIndex = -1
    private var parchmentLoaded = false
    
    //MARK:- Initial Display
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        backgroundViewForFareBreakup.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        backgroundViewForFareBreakup.tag = 1002
        self.view.addSubview(backgroundViewForFareBreakup)
        grabberView.layer.cornerRadius = 2
        
        self.navigationController?.navigationBar.isHidden = true
        
        if isInternational || !(needToAddFareBreakup){
            self.setFlightDetailsForInternational()
        }else{
            self.setFlightDetailsForDomestic()
        }
        
        getSharableLink.delegate = self
        
        setupInitialViews()
        setupParchmentPageController()
        self.setupViewModel()
        self.manageLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        clearCache.checkTimeAndClearUpgradeDataCache()
        clearCache.checkTimeAndClearFlightPerformanceResultCache(journey: journey)
        clearCache.checkTimeAndClearFlightBaggageResultCache()
        let presentationStyle = presentingViewController?.modalPresentationStyle
        
        if presentationStyle == .overFullScreen {
            statusBarStyle = .darkContent
        } else {
            statusBarStyle = .lightContent
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarStyle = .darkContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !parchmentLoaded {
            DispatchQueue.delay(1) {
                self.parchmentLoaded = true
            }
            self.parchmentView?.view.frame = self.displayView.bounds
            self.parchmentView?.view.frame.size.height = self.dataDisplayView.height - innerControllerBottomConstraint
            self.parchmentView?.loadViewIfNeeded()
        }
    }
    
    //MARK:- Initialise Views
    func setupInitialViews()
    {
        if needToAddFareBreakup{
            if !(self.isInternational){
                setupFarebreakupView()
            }else{
                setFareBreakupForInt()
            }
        }else{
            self.displayViewBottom.constant = 0
        }
        initialDisplayView()
    }
    
    func initialDisplayView(){
        if isInternational || !(needToAddFareBreakup){
            allChildVCs.append(addIntFlightInfoVC())
            allChildVCs.append(addIntBaggageVC())
            allChildVCs.append(addIntFareInfo())
        }else{
            allChildVCs.append(addFlightInfoVC())
            allChildVCs.append(addBaggageVC())
            allChildVCs.append(addFareInfoVC())
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
        fareBreakupVC.bookingObject = bookFlightObject
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
        let bottomSpecing = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        self.innerControllerBottomConstraint = (fareBreakupVC.view.frame.height - bottomSpecing)
    }
    
    private func setupParchmentPageController(){
        
        self.parchmentView = PagingViewController()
        self.parchmentView?.menuItemSpacing = (self.view.frame.width - 340) / 3
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 100, height: 49)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0))
        self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        self.parchmentView?.font = UIFont(name: "SourceSansPro-Regular", size: 16.0)!
//        self.parchmentView?.selectedFont = UIFont(name: "SourceSansPro-Semibold", size: 16.0)!
        
        self.parchmentView?.font = AppFonts.Regular.withSize(16)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16)
        self.parchmentView?.indicatorColor = UIColor.AertripColor
        self.parchmentView?.selectedTextColor = .black
        self.parchmentView?.menuBackgroundColor = .white
        self.dataDisplayView.addSubview(self.parchmentView!.view)
        
        self.parchmentView?.collectionView.isScrollEnabled = false
        self.parchmentView?.collectionView.clipsToBounds = true
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: 0)
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
    }
    
    
    //MARK:- View Controllers to be added as child view controllers
    
    func addFlightInfoVC() -> UIViewController {
        
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
        return flightInfoVC
    }
    
    func addBaggageVC() -> UIViewController{
        
        let baggageVC = BaggageVC(nibName: "BaggageVC", bundle: nil)
        baggageVC.journey = journey
        baggageVC.dimensionDelegate = self
        baggageVC.sid = sid
        if isFSRVisible == true{
            baggageVC.fewSeatsLeftViewHeight = 40
        }else{
            baggageVC.fewSeatsLeftViewHeight = 0
        }
        
        baggageVC.airportDetailsResult = airportDetailsResult
        return baggageVC
    }
    
    func addFareInfoVC() -> UIViewController{
        
        let fareInfoVc = FareInfoVC(nibName: "FareInfoVC", bundle: nil)
        fareInfoVc.fareRulesDelegate = self
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
        return fareInfoVc
    }
    
    //MARK:- Button Actions
    
    @IBAction func closeButtonClicked(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
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
            
            self.delegate?.reloadRowFromFlightDetails(fk: journey.first?.fk ?? "", isPinned: isPinned, isPinnedButtonClicked: true)
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
                self.delegate?.reloadRowFromFlightDetails(fk: journey.fk, isPinned: !journey.isPinned, isPinnedButtonClicked: true)
            }
        }
    }
    
    @IBAction func addToTripButtonClicked(_ sender: Any){
        self.addToTrip()
    }
    
    // Monika
    @IBAction func shareButtonClicked(_ sender: UIButton)
    {
        shareButton.setImage(nil, for: .normal)
        sender.displayLoadingIndicator(true)
        
        if isInternational{
            let intVC = IntMCAndReturnVC()
            let flightAdultCount = bookFlightObject.flightAdultCount
            let flightChildrenCount = bookFlightObject.flightChildrenCount
            let flightInfantCount = bookFlightObject.flightInfantCount
            let isDomestic = bookFlightObject.isDomestic
            var valStr = ""
            if #available(iOS 13.0, *) {
                valStr = intVC.generateCommonString(for: intJourney, flightObject: self.bookFlightObject)
            }
            
            let filterStr = self.getSharableLink.getAppliedFiltersForSharingIntJourney(legs: self.flightSearchResultVM?.intFlightLegs ?? [],isConditionReverced: isConditionReverced,appliedFilterLegIndex: appliedFilterLegIndex)
            valStr.append(filterStr)
            
            self.getSharableLink.getUrl(adult: "\(flightAdultCount)", child: "\(flightChildrenCount)", infant: "\(flightInfantCount)",isDomestic: isDomestic, isInternational: true, journeyArray: [], valString: valStr, trip_type: "",filterString: filterStr,searchParam: flightSearchResultVM?.flightSearchParametersFromDeepLink)
        }else{
            let flightAdultCount = bookFlightObject.flightAdultCount
            let flightChildrenCount = bookFlightObject.flightChildrenCount
            let flightInfantCount = bookFlightObject.flightInfantCount
            
            let isDomestic = bookFlightObject.isDomestic
            
            let filterStr = getSharableLink.getAppliedFiltersForSharingDomesticJourney(legs: self.flightSearchResultVM?.flightLegs ?? [],isConditionReverced:isConditionReverced)
            
            var tripType = ""
            if self.bookFlightObject.flightSearchType == SINGLE_JOURNEY{
                tripType = "single"
            }else if self.bookFlightObject.flightSearchType == RETURN_JOURNEY{
                tripType = "return"
            }else{
                tripType = "multi"
            }
            
            self.getSharableLink.getUrl(adult: "\(flightAdultCount)", child: "\(flightChildrenCount)", infant: "\(flightInfantCount)",isDomestic: isDomestic, isInternational: false, journeyArray: journey, valString: "", trip_type: tripType,filterString: filterStr,searchParam: flightSearchResultVM?.flightSearchParametersFromDeepLink)
        }
    }
}


//MARK:- Paging VC methods

extension FlightDetailsBaseVC: PagingViewControllerDataSource , PagingViewControllerDelegate, PagingViewControllerSizeDelegate
{
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title:  self.allTabsStr[index])
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return self.allTabsStr.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController
    {
        return self.allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat
    {
        if isSEDevice{
            return 112
        }else{
            return 120
        }
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool){
        
        let pagingIndexItem = pagingItem as! PagingIndexItem
        self.currentIndex = pagingIndexItem.index
    }
}

//MARK:- customs functions to make resulable for international return.
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
        let bottomSpecing = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        self.innerControllerBottomConstraint = (vc.view.frame.height - bottomSpecing)
    }
    
    func addIntFlightInfoVC() -> UIViewController {
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
        return vc
    }
    
    func addIntBaggageVC() -> UIViewController {
        
        let vc = IntFlightBaggageInfoVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
        vc.journey = self.intJourney?.first
        vc.sid = sid
        if isFSRVisible == true{
            vc.fewSeatsLeftViewHeight = 40
        }else{
            vc.fewSeatsLeftViewHeight = 0
        }
        vc.dimensionDelegate = self
        vc.isForDomestic = (self.bookFlightObject.isDomestic)
        vc.airportDetailsResult = intAirportDetailsResult
        return vc
    }
    
    func addIntFareInfo() -> UIViewController {
        
        let vc = IntFareInfoVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
        vc.journey = [self.intJourney.first!]
        vc.sid = sid
        if isFSRVisible == true{
            vc.fewSeatsLeftViewHeight = 40
        }else{
            vc.fewSeatsLeftViewHeight = 0
        }
        vc.delegate = self
        vc.fareRulesDelegate = self
        vc.selectedIndex = selectedIndex
        vc.refundDelegate = refundDelegate
        vc.flightAdultCount = bookFlightObject.flightAdultCount
        vc.flightChildrenCount = bookFlightObject.flightChildrenCount
        vc.flightInfantCount = bookFlightObject.flightInfantCount
        vc.airportDetailsResult = self.intAirportDetailsResult
        return vc
    }
    
    func setupViewModel(){
        self.viewModel.sid = self.sid
        self.viewModel.journey = self.journey
        self.viewModel.intJourney = self.intJourney
        self.viewModel.journeyType = (self.bookFlightObject.isDomestic) ? .domestic : .international
    }
}

//MARK:- FlightDetailsVMDelegate

extension FlightDetailsBaseVC : FlightDetailsVMDelegate, TripCancelDelegate{
    func manageLoader() {
        self.addToTripIndicator.style = .gray
        self.addToTripIndicator.color = AppColors.themeGreen
        self.addToTripIndicator.startAnimating()
        self.viewModel.delegate = self
        self.hideShowLoader(isHidden:true)
    }
    
    func hideShowLoader(isHidden:Bool){
        DispatchQueue.main.async {
            if isHidden{
                self.addToTripIndicator.stopAnimating()
            }else{
                self.addToTripIndicator.startAnimating()
            }
            self.view.isUserInteractionEnabled = isHidden
            self.addToTripButton.isHidden = !isHidden
        }
    }
    
    func addToTrip(){
        AppFlowManager.default.proccessIfUserLoggedInForFlight(verifyingFor: .loginVerificationForCheckout,presentViewController: true, vc: self) { [weak self](isGuest) in
            guard let self = self else {return}
            AppFlowManager.default.removeLoginConfirmationScreenFromStack()
            self.presentedViewController?.dismiss(animated: false, completion: nil)
            guard !isGuest else {
                self.hideShowLoader(isHidden: true)
                return
            }
            self.hideShowLoader(isHidden: false)
            AppFlowManager.default.selectTrip(nil, tripType: .flight, cancelDelegate: self) { [weak self] (trip, details)  in
                delay(seconds: 0.3, completion: { [weak self] in
                    guard let self = self else {return}
                    self.viewModel.selectedTrip = trip
                    self.viewModel.addToTrip()
                })
            }
        }
    }
    
    func addTripCancelled(){
        self.hideShowLoader(isHidden: true)
    }
    
    func willGetAddToTrip() {
        self.hideShowLoader(isHidden: false)
    }
    
    func getResponseForAddToTrip(success: Bool, alreadyAdded: Bool) {
        self.hideShowLoader(isHidden: true)
        if success{
            let message:String
            if alreadyAdded{
                message = LocalizedString.flightHasAlreadyBeenSavedToTrip.localized
            }else{
                let tripName = (self.viewModel.selectedTrip?.isDefault ?? false) ? LocalizedString.Default.localized.lowercased() : "\(self.viewModel.selectedTrip?.name ?? "")"
                message = "journey has been added to \(tripName) trip"
            }
            AppToast.default.showToastMessage(message: message, onViewController: self)
        }
    }
}

//MARK:- Smart Icons Delegate
extension FlightDetailsBaseVC : flightDetailsSmartIconsDelegate{
    
    func updateRefundStatusIfPending() {
        self.delegate?.updateRefundStatusIfPending(fk: journey.first?.fk ?? "")
    }
    
    func reloadSmartIconsAtIndexPath() {
        self.delegate?.reloadRowFromFlightDetails(fk: journey.first!.fk, isPinned: false, isPinnedButtonClicked:false)
    }
}

//MARK:- Fare Breakup Delegate
extension FlightDetailsBaseVC : FareBreakupVCDelegate
{
    func bookButtonTapped(journeyCombo: [CombinationJourney]?){
        guard !self.isForCheckOut else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        AppFlowManager.default.proccessIfUserLoggedInForFlight(verifyingFor: .loginVerificationForCheckout,presentViewController: true, vc: self) { [weak self](isGuest) in
            guard let self = self else {return}
            if #available(iOS 13.0, *) {
                self.isModalInPresentation = true
            }
            if self.viewModel.journeyType == .domestic || self.intJourney == nil{
                self.fareBreakup?.hideShowLoader(isHidden: false)
                self.setupViewModel()
            }else{
                self.intFareBreakup?.hideShowLoader(isHidden: false)
            }
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
        (UIApplication.shared.delegate as? AppDelegate)?.window?.isUserInteractionEnabled = false
        self.viewModel.fetchConfirmationData(){[weak self] success, errorCodes in
            guard let self = self else {return}
            self.view.isUserInteractionEnabled = true
            (UIApplication.shared.delegate as? AppDelegate)?.window?.isUserInteractionEnabled = true
            if #available(iOS 13.0, *) {
                self.isModalInPresentation = false
            }
            if self.viewModel.journeyType == .domestic || self.intJourney == nil{
                self.fareBreakup?.hideShowLoader(isHidden: true)
            }else{
                self.intFareBreakup?.hideShowLoader(isHidden: true)
            }
            if success{
                DispatchQueue.main.async{[weak self] in
                    guard let self = self else {return}
                    vc.viewModel.newItineraryData = self.viewModel.itineraryData
                    if let nav = AppFlowManager.default.currentNavigation{
                        nav.pushViewController(vc, animated: true)
                    }else{
                        self.navigationContronller = UINavigationController(rootViewController: vc)
                        self.navigationContronller?.modalPresentationStyle = .overFullScreen
                        self.navigationContronller?.modalPresentationCapturesStatusBarAppearance = true
                        vc.dismissController = {[weak self] in
                            self?.navigationContronller = nil
                        }
                        guard let nav = self.navigationContronller else {return}
                        self.present(nav, animated: true, completion: nil)
                    }
                }
            }else{
                AppGlobals.shared.showErrorOnToastView(withErrors: errorCodes, fromModule: .flightConfirmation)
            }
        }
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
    
    func tapUpgradeButton(){
        let vc = UpgradePlanContrainerVC.instantiate(fromAppStoryboard:.InternationalReturnAndMulticityDetails)
        vc.viewModel.oldIntJourney = self.intJourney
        vc.viewModel.sid = self.sid
        vc.viewModel.isInternational = true
        vc.viewModel.selectedJourneyFK = selectedJourneyFK
        vc.viewModel.flightAdultCount = self.bookFlightObject.flightAdultCount
        vc.viewModel.flightChildrenCount = self.bookFlightObject.flightAdultCount
        vc.viewModel.flightInfantCount = self.bookFlightObject.flightAdultCount
        vc.viewModel.bookingObject = self.bookFlightObject
        vc.viewModel.taxesResult = self.taxesResult
        self.present(vc, animated: true, completion: nil)
    }
}


//MARK:- Baggage Delegate
extension FlightDetailsBaseVC : flightDetailsBaggageDelegate
{
    func reloadBaggageSuperScriptAtIndexPath() {
        self.delegate?.reloadRowFromFlightDetails(fk: journey.first!.fk, isPinned: false,isPinnedButtonClicked:false)
    }
}

//MARK:- Baggage Dimentions Delegate
extension FlightDetailsBaseVC : getBaggageDimentionsDelegate
{
    //Present Baggage Dimensions screen
    func getBaggageDimentions(baggage: [[JSONDictionary]], sender: UIButton) {
        let baggageDimensionVC = BaggageDimensionsVC(nibName: "BaggageDimensionsVC", bundle: nil)
        
        let section = sender.tag / 100
        let row = sender.tag % 100
        if let baggageData = baggage[section][row]["baggageData"] as? JSONDictionary{
            if let cbgData = baggageData["cbg"] as? JSONDictionary{
                if let adtCabinBaggage = cbgData["ADT"] as? JSONDictionary{
                    if let weight = adtCabinBaggage["weight"] as? String{
                        baggageDimensionVC.weight = weight
                    }
                    if let dimension = adtCabinBaggage["dimension"]as? JSONDictionary{
                        if let cm = dimension["cm"] as? JSONDictionary{
                            baggageDimensionVC.dimensions = cm
                        }
                        
                        if let inch = dimension["in"] as? JSONDictionary{
                            baggageDimensionVC.dimensions_inch = inch
                        }
                    }
                    
                    if let note = adtCabinBaggage["note"] as? String{
                        baggageDimensionVC.note = note
                    }
                }
            }
        }
        
        self.present(baggageDimensionVC, animated: true, completion: nil)
    }
}

//MARK:- Fare Rules Delegate
extension FlightDetailsBaseVC : getFareRulesDelegate
{
    //Present Fare Rules Screen
    func getFareRulesData(fareRules: [JSONDictionary]) {
        let fareRulesVC = FareRulesVC(nibName: "FareRulesVC", bundle: nil)
        fareRulesVC.fareRulesData = fareRules
        self.present(fareRulesVC, animated: true, completion: nil)
    }
}

//MARK:- GetSharableUrlDelegate

extension FlightDetailsBaseVC : GetSharableUrlDelegate
{
    func returnSharableUrl(url: String)
    {
        shareButton.setImage(UIImage(named: "ShareGreen"), for: .normal)
        shareButton.displayLoadingIndicator(false)
        
        if url == "No Data"{
            AertripToastView.toast(in: self.view, withText: "Something went wrong. Please try again.")
        }else{
            let textToShare = [ "Checkout my favourite flights on Aertrip!\n\(url)" ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func returnEmailView(view: String) {}
}

//MARK:- Arrival Performance Delegate
extension FlightDetailsBaseVC : getArrivalPerformanceDelegate
{
    func getArrivalPerformanceData(flight:FlightDetail)
    {
        let arrivalPerformanceView = ArrivalPerformaceVC(nibName: "ArrivalPerformaceVC", bundle: nil)
        
        if flight.ontimePerformanceDataStoringTime != nil{
            
            arrivalPerformanceView.observationCount = "\(flight.observationCount!)"
            arrivalPerformanceView.averageDelay = "\(flight.averageDelay!)"
            
            arrivalPerformanceView.cancelledPerformanceInPercent = flight.cancelledPerformance!
            arrivalPerformanceView.delayedPerformanceInPercent = flight.latePerformance!
            arrivalPerformanceView.onTimePerformanceInPercent = flight.ontimePerformance!
            
            arrivalPerformanceView.view.frame = self.view.bounds
            self.view.addSubview(arrivalPerformanceView.view)
            self.addChild(arrivalPerformanceView)
            arrivalPerformanceView.willMove(toParent: self)
        }
    }
}
