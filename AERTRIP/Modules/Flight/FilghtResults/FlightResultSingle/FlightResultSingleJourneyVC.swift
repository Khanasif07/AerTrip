//
//  FilghtResultSingleJourneyVC.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit
import MessageUI


@objc protocol BridgeProtocol {
    func access()
}

class FlightResultSingleJourneyVC: UIViewController,  flightDetailsPinFlightDelegate , GroupedFlightCellDelegate, GetSharableUrlDelegate {
   
    
    
    //MARK:- Outlets
    var bannerView : ResultHeaderView?
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var pinnedFlightsOptionsView : UIView!
    @IBOutlet weak var switchView: ATSwitcher!
    @IBOutlet weak var unpinnedAllButton: UIButton!
    @IBOutlet weak var emailPinnedFlights: UIButton!
    @IBOutlet weak var sharePinnedFilghts: UIButton!
    @IBOutlet weak var switchGradientView: UIView!
    @IBOutlet weak var resultsTableViewTop: NSLayoutConstraint!
    
    //MARK:- Properties
    var noResultScreen : NoResultsScreenViewController?
    
    //    var sortedArray: [Journey]!
    
    var visualEffectViewHeight : CGFloat {
        return statusBarHeight + 88.0
    }
    
    var statusBarHeight : CGFloat {
        return UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
    }
    
    var ApiProgress: UIProgressView!
    var previousRequest : DispatchWorkItem?
    let getSharableLink = GetSharableUrl()
    let viewModel = FlightResultSingleJourneyVM()
    var flightSearchResultVM: FlightSearchResultVM?
    
    
    //MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getSharableLink.delegate = self
        self.viewModel.results = OnewayJourneyResultsArray(sort: .Smart)
        setupTableView()
        setupPinnedFlightsOptionsView()
        self.viewModel.setSharedFks()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.emailPinnedFlights.setImage(UIImage(named: "EmailPinned"), for: .normal)
        self.emailPinnedFlights.displayLoadingIndicator(false)

    }
    
    deinit {
        printDebug("FlightResultSingleJourneyVC")
    }
    
    
    //MARK:- Additional UI Methods
    func showNoFilteredResults() {
        
        if self.children.count > 0{
            for vc in self.children{
                if vc as? NoResultsScreenViewController == nil{
                    let noResultScreenForFilter = NoResultsScreenViewController()
                    noResultScreenForFilter.delegate = self.parent as? NoResultScreenDelegate
                    self.view.addSubview(noResultScreenForFilter.view)
                    self.addChild(noResultScreenForFilter)
                    let frame = self.view.frame
                    noResultScreenForFilter.view.frame = frame
                    noResultScreenForFilter.noFilteredResults()
                    self.noResultScreen = noResultScreenForFilter
                }
            }
        }else{
            let noResultScreenForFilter = NoResultsScreenViewController()
            noResultScreenForFilter.delegate = self.parent as? NoResultScreenDelegate
            self.view.addSubview(noResultScreenForFilter.view)
            self.addChild(noResultScreenForFilter)
            let frame = self.view.frame
            noResultScreenForFilter.view.frame = frame
            noResultScreenForFilter.noFilteredResults()
            self.noResultScreen = noResultScreenForFilter
        }
    }
    
    fileprivate func setupTableView(){
        resultsTableView.register(UINib(nibName: "SingleJourneyResultTemplateCell", bundle: nil), forCellReuseIdentifier: "SingleJourneyTemplateCell")
        resultsTableView.register(UINib(nibName: "SingleJourneyResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SingleJourneyResultTableViewCell")
        resultsTableView.register(UINib(nibName: "GroupedFlightCell", bundle: nil), forCellReuseIdentifier: "GroupedFlightCell")
        resultsTableView.separatorStyle = .none
        resultsTableView.scrollsToTop = true
        resultsTableView.estimatedRowHeight  = 123
        resultsTableView.rowHeight = UITableView.automaticDimension
    }
    
    
    func setupPinnedFlightsOptionsView() {
        //        pinnedFlightOptionsTop.constant = 0
        
        switchView.delegate = self
        switchView.tintColor = UIColor.TWO_ZERO_FOUR_COLOR
        switchView.offTintColor = UIColor.TWO_THREE_ZERO_COLOR
        switchView.onTintColor = AppColors.themeGreen
        switchView.onThumbImage = #imageLiteral(resourceName: "pushpin")
        switchView.offThumbImage = #imageLiteral(resourceName: "pushpin-gray")
        switchView.setupUI()
        delay(seconds: 0.6) {
            self.switchView.isOn = false
        }
        
        showPinnedFlightsOption(false)
        
        hideOrShowPinnedButtons(show : false)
        
        addShadowTo(unpinnedAllButton)
        addShadowTo(emailPinnedFlights)
        addShadowTo(sharePinnedFilghts)
    }
    
    func addShadowTo(_ view : UIView) {
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 0.0, height: 4)
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
    }
    
    
    func updateApiProcess(progress:Float) {
        if progress > 0.25 {
            DispatchQueue.main.async {
                
                if self.ApiProgress.progress < progress {
                    self.ApiProgress.setProgress(progress, animated: true)
                }
                
                if progress >= 0.97 {
                    self.ApiProgress.isHidden = true
                }
            }
        }
    }
    
    
    fileprivate func snapToTopOrBottomOnSlowScrollDragging(_ scrollView: UIScrollView) {
        
        
        if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
            var rect = blurEffectView.frame
            let yCoordinate = rect.origin.y * ( -1 )
            
            // After dragging if blurEffectView is at top or bottom position , snapping animation is not required
            if yCoordinate == 0 || yCoordinate == ( -visualEffectViewHeight){
                return
            }
            
            // If blurEffectView yCoodinate is close to top of the screen
            if  ( yCoordinate > ( visualEffectViewHeight / 2.0 ) ){
                
                let progressBarrStopPositionValue : CGFloat = UIDevice.isIPhoneX ? 46 : 22

                rect.origin.y = -visualEffectViewHeight + progressBarrStopPositionValue

                
                if scrollView.contentOffset.y < 100 {
                    let zeroPoint = CGPoint(x: 0, y: 96.0)
                    scrollView.setContentOffset(zeroPoint, animated: true)
                }
            }
            else {  //If blurEffectView yCoodinate is close to fully visible state of blurView
                rect.origin.y = 0
            }
            
            // Animatioon to move the blurEffectView
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
                blurEffectView.frame = rect
            } ,completion: nil)
        }
    }
    
    //MARK:- Tableview Header View
    
    func addBannerTableHeaderView() {
        
        DispatchQueue.main.async {
            
            let rect = CGRect(x: 0, y: 81, width: UIScreen.main.bounds.size.width, height: 154)
            self.bannerView = ResultHeaderView(frame: rect)
            self.bannerView?.frame = rect
            self.bannerView?.lineView.isHidden = true
            self.view.addSubview(self.bannerView ?? UIView())
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 96))
            self.resultsTableView.tableHeaderView = headerView
            self.resultsTableView.isScrollEnabled = false
            self.resultsTableView.tableFooterView = nil
            
            self.resultsTableView.bringSubviewToFront(self.bannerView ?? UIView())
            
        }
    }
    
    func addPlaceholderTableHeaderView() {
        DispatchQueue.main.async {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 96))
            self.resultsTableView.tableHeaderView = headerView
        }
    }
    
    @IBAction func PinnedFlightSwitchToggled(_ sender: AertripSwitch) {
        
        if sender.isOn {
            self.viewModel.stateBeforePinnedFlight = viewModel.resultTableState
            viewModel.resultTableState = .showPinnedFlights
            resultsTableView.tableFooterView = nil
            if viewModel.results.pinnedFlights.isEmpty {
                showNoFilteredResults()
            }
        } else {
            viewModel.resultTableState = self.viewModel.stateBeforePinnedFlight
            showFooterView()
        }
        
        hideOrShowPinnedButtons(show : sender.isOn)
        resultsTableView.reloadData()
        resultsTableView.setContentOffset(.zero, animated: false)
        showBluredHeaderViewCompleted()
    }
    
    @IBAction func unpinnedAllTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Unpin All?", message: "This action will unpin all the pinned flights and cannot be undone.", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.AertripColor
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "Unpin all", style: .destructive, handler: { action in
            if #available(iOS 13.0, *) {
                self.performUnpinnedAllAction()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showEmailViewController(body : String) {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.setSubject("Checkout these great flights I pinned on Aertrip!")
            composeVC.setMessageBody(body, isHTML: true)
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func emailPinnedFlights(_ sender: Any)
    {
        emailPinnedFlights.setImage(UIImage(named: "OvHotelResult"), for: .normal)
        emailPinnedFlights.displayLoadingIndicator(true)

        if let _ = UserInfo.loggedInUserId{
            callAPIToGetMailTemplate()
        }else{
            AppFlowManager.default.proccessIfUserLoggedIn(verifyingFor: .loginFromEmailShare, completion: {_ in
                
                if let vc = self.parent{
                    AppFlowManager.default.popToViewController(vc, animated: true)
                }
                
                self.callAPIToGetMailTemplate()
            })
        }
    }
    
    
    func callAPIToGetMailTemplate(){
        let flightAdultCount = viewModel.bookFlightObject.flightAdultCount
        let flightChildrenCount = viewModel.bookFlightObject.flightChildrenCount
        let flightInfantCount = viewModel.bookFlightObject.flightInfantCount
        let isDomestic = viewModel.bookFlightObject.isDomestic

        self.getSharableLink.getUrlForMail(adult: "\(flightAdultCount)", child: "\(flightChildrenCount)", infant: "\(flightInfantCount)",isDomestic: isDomestic, sid: viewModel.sid, isInternational: false, journeyArray: self.viewModel.results.pinnedFlights, valString: "", trip_type: "single")
    }
    
    func returnEmailView(view: String)
    {
        DispatchQueue.main.async {
            
            self.emailPinnedFlights.setImage(UIImage(named: "EmailPinned"), for: .normal)
            self.emailPinnedFlights.displayLoadingIndicator(false)

            if #available(iOS 13.0, *) {
                if view == "Pinned template data not found"{
                    AppToast.default.showToastMessage(message: view)
                }else{
                    self.showEmailViewController(body : view)
                }
            }
        }
    }

    
    // Monika
    @IBAction func sharePinnedFlights(_ sender: Any) {
        if #available(iOS 13.0, *) {
            shareJourney(journey: self.viewModel.results.pinnedFlights)
        }
    }
    
    //MARK:- Additional Tableview methods
    func setImageto( imageView : UIImageView , url : String , index : Int ) {
        if let image = resultsTableView.resourceFor(urlPath: url , forView: index) {
            
            let resizedImage = image.resizeImage(24.0, opaque: false)
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage.roundedRectImageFromImage(image: resizedImage, imageSize: CGSize(width: 24.0, height: 24.0), cornerRadius: 2.0)
        }
        
    }

    
    func reloadRowAtIndex(indexPath: IndexPath , with journeyDisplay: JourneyOnewayDisplay ) {
        
        //        if indexPath.section == 0 {
        //            viewModel.results.suggestedJourneyArray[indexPath.row] = journeyDisplay
        //        }
        //        else {
        //            viewModel.results.expensiveJourneyArray[indexPath.row] = journeyDisplay
        //        }
        //
        //        let suggestedPinnedFlight = viewModel.results.suggestedJourneyArray.reduce(viewModel.results.suggestedJourneyArray[0].containsPinnedFlight) { $0 || $1.containsPinnedFlight }
        //
        //        var expensivePinnedFlight = false
        //        if viewModel.results.expensiveJourneyArray.count > 0 {
        //            expensivePinnedFlight  = viewModel.results.expensiveJourneyArray.reduce(viewModel.results.expensiveJourneyArray[0].containsPinnedFlight) { $0 || $1.containsPinnedFlight }
        //        }
        //        if !(suggestedPinnedFlight ||  expensivePinnedFlight) {
        //            showPinnedFlightsOption(false)
        //        }else {
        //            showPinnedFlightsOption(true)
        //        }
        //         self.resultsTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    func updateRefundStatusIfPending(fk: String) {
        
        
//        printDebug(fk)
        
        self.resultsTableView.reloadData()
        
    }
    
    func reloadRowFromFlightDetails(fk: String, isPinned: Bool,isPinnedButtonClicked:Bool) {
     
        if isPinnedButtonClicked == true{
            setPinnedFlightAt(fk, isPinned: isPinned, indexpath: nil)
        }
        

//        if let cell =  resultsTableView.dequeueReusableCell(withIdentifier: "SingleJourneyResultTableViewCell") as? SingleJourneyResultTableViewCell{
//
//            printDebug("journey.baggageSuperScript....updated..\(String(describing: cell.currentJourney?.leg.first?.fcp))")
//
//            cell.smartIconsArray = cell.currentJourney?.smartIconArray
//            cell.smartIconCollectionView.reloadData()
//        }
    }
    
    //MARK:- Scroll related methods
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.viewModel.scrollviewInitialYOffset = scrollView.contentOffset.y
    }
    
    fileprivate func hideHeaderBlurView(_ offsetDifference: CGFloat) {
        
        guard (self.parent as? FlightResultBaseViewController)?.doneButton == nil else {return}
        
        DispatchQueue.main.async {
            
            var yCordinate : CGFloat
            yCordinate = max (  -self.visualEffectViewHeight ,  -offsetDifference )
            yCordinate = min ( 0,  yCordinate)
            
            let progressBarrStopPositionValue : CGFloat = UIDevice.isIPhoneX ? 46 : 22
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
                
                if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
                    var rect = blurEffectView.frame
                    let yCordinateOfView = rect.origin.y
                    if ( yCordinateOfView  > yCordinate ) {
                        rect.origin.y = yCordinate
                        if ((blurEffectView.height + yCordinate) > progressBarrStopPositionValue) || (blurEffectView.origin.y > -86.0) {
                            blurEffectView.frame = rect
                        }
                    }
                }
            } ,completion: nil)
        }
    }
    
    fileprivate func revealBlurredHeaderView(_ invertedOffset: CGFloat) {
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut], animations: {
                
                if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
                    var rect = blurEffectView.frame
                    var yCordinate = invertedOffset - 86
                    yCordinate = min ( 0,  yCordinate)
                    if self.resultsTableView.contentOffset.y <= 0 || rect.origin.y == 0{
                        yCordinate = 0
                    }
                    rect.origin.y = yCordinate
                    blurEffectView.frame = rect
                }
            } ,completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentSize = scrollView.contentSize
        let scrollViewHeight = contentSize.height
        let viewHeight = self.view.frame.height
        
        if scrollViewHeight < (viewHeight + visualEffectViewHeight) {
            return
        }
        
        let contentOffset = scrollView.contentOffset
        let offsetDifference = contentOffset.y - self.viewModel.scrollviewInitialYOffset
        if offsetDifference > 0 {
            hideHeaderBlurView(offsetDifference)
        } else {
            let invertedOffset = -offsetDifference
            revealBlurredHeaderView(invertedOffset)
        }
        
        
//        guard let content = self.viewModel.contentOffset else { return }
//
//        self.resultsTableView.setContentOffset(content, animated: false)
        
//        self.viewModel.contentOffset = nil

        
    }
    
    
//    func changeContentOfssetWithMainScrollView(with offset: CGFloat){
//        guard let blurView = self.navigationController?.view.viewWithTag(500) else  {return}
//        DispatchQueue.main.async {
//            var y = 88 - offset
//            y = (y < 0) ? y : 0
//            printDebug(y)
//            blurView.frame.origin.y = y//-self.resultsTableView.contentOffset.y
////            self.view.layoutIfNeeded()
//        }
//    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView){
        
        if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
            var rect = blurEffectView.frame
            rect.origin.y = 0
            // Animatioon to move the blurEffectView
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
                blurEffectView.frame = rect
            } ,completion: nil)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        snapToTopOrBottomOnSlowScrollDragging(scrollView)
        //        scrollviewInitialYOffset = 0.0
    }
    
    
    //MARK:-  Actions to be performed on Journey objects
    
    func addToTripFlightAt(_ indexPath : IndexPath){
        
        //        if viewModel.sortOrder == .Smart{
        var arrayForDisplay = viewModel.results.suggestedJourneyArray
        
        if viewModel.resultTableState == .showExpensiveFlights && indexPath.section == 1 {
            arrayForDisplay = viewModel.results.allJourneys
        }
        
        let journey = arrayForDisplay[indexPath.row]
        
        if journey.cellType == .singleJourneyCell {
            addToTrip(journey: journey.first )
        }
        else {
            addToTrip(journey: journey.first)
        }
        
        //        }
        //        else {
        //            let currentJourney =  self.sortedArray[indexPath.row]
        //            addToTrip(journey: currentJourney)
        //        }
    }
    
    //    func addToTrip(journey : Journey) {
    //        let tripListVC = TripListVC(nibName: "TripListVC", bundle: nil)
    //        tripListVC.journey = [journey]
    //        tripListVC.modalPresentationStyle = .overCurrentContext
    //        self.present(tripListVC, animated: true, completion: nil)
    //    }
    //
    
    func addToTrip(journey : Journey) {
        AppFlowManager.default.proccessIfUserLoggedInForFlight(verifyingFor: .loginVerificationForCheckout,presentViewController: true, vc: self) { [weak self](isGuest) in
            guard let self = self else {return}
            AppFlowManager.default.removeLoginConfirmationScreenFromStack()
            self.presentedViewController?.dismiss(animated: false, completion: nil)
            guard !isGuest else {
                return
            }
            AppFlowManager.default.selectTrip(nil, tripType: .hotel) { [weak self] (trip, details)  in
                delay(seconds: 0.3, completion: { [weak self] in
                    guard let self = self else {return}
                    self.addToTripApiCall(with: journey, trip: trip)
                })
            }
        }
    }
    
    
    func addToTripApiCall(with journey: Journey, trip: TripModel){
        self.viewModel.addToTrip(with: journey, trip: trip) {[weak self] (success, alreadyAdded) in
            if success{
                let message:String
                if alreadyAdded{
                    message = LocalizedString.flightHasAlreadyBeenSavedToTrip.localized
                }else{
                    let tripName = (trip.isDefault) ? LocalizedString.Default.localized.lowercased() : "\(trip.name)"
                    message = "journey has been added to \(tripName) trip"
                }
                AppToast.default.showToastMessage(message: message, onViewController: self)
            }
        }
        
    }
    
    
    func shareFlightAt(_ indexPath : IndexPath) {
        
        var journey : Journey?
        
        if self.viewModel.resultTableState == .showPinnedFlights {
            let journeyArray = self.viewModel.results.pinnedFlights
            journey = journeyArray[indexPath.row]
        }
        else {
            
            var arrayForDisplay = self.viewModel.results.suggestedJourneyArray
            
            if self.viewModel.resultTableState == .showExpensiveFlights {
                arrayForDisplay = self.viewModel.results.journeyArray
            }
            
            journey = arrayForDisplay[indexPath.row].first
            
        }
        
        guard let strongJourney = journey else { return }
        if #available(iOS 13.0, *) {
            shareJourney(journey: [strongJourney])
        } else {
            // Fallback on earlier versions
        }
    }
    
    func navigateToFlightDetailFor(journey: Journey) {
        
    }
    
    
    //MARK:- Methods for naviagating to other View Controller
    
    func navigateToFlightDetailFor(journey : Journey, selectedIndex:IndexPath) {
        let storyboard = UIStoryboard(name: "FlightDetailsBaseVC", bundle: nil)
        guard let flightDetailsVC:FlightDetailsBaseVC = storyboard.instantiateViewController(withIdentifier: "FlightDetailsBaseVC") as? FlightDetailsBaseVC else { return }
        flightDetailsVC.flightSearchResultVM = self.flightSearchResultVM
        flightDetailsVC.delegate = self
        flightDetailsVC.isConditionReverced = viewModel.isConditionReverced
        flightDetailsVC.bookFlightObject = self.viewModel.bookFlightObject
        flightDetailsVC.taxesResult = self.viewModel.taxesResult
        flightDetailsVC.sid = self.viewModel.sid
        flightDetailsVC.selectedIndex = selectedIndex
        flightDetailsVC.journey = [journey]
        flightDetailsVC.titleString = self.viewModel.titleString
        flightDetailsVC.airportDetailsResult = self.viewModel.airportDetailsResult
        flightDetailsVC.airlineDetailsResult = self.viewModel.airlineDetailsResult
        flightDetailsVC.selectedJourneyFK = [journey.fk]
        self.present(flightDetailsVC, animated: true, completion: nil)
    }
}
