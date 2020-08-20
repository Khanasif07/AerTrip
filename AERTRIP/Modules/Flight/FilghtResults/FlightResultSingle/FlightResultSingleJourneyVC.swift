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

class FlightResultSingleJourneyVC: UIViewController,  flightDetailsPinFlightDelegate , GroupedFlightCellDelegate, getSharableUrlDelegate {
    
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

    
    //MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getSharableLink.delegate = self
        self.viewModel.results = OnewayJourneyResultsArray(sort: .Smart)
        setupTableView()
        setupPinnedFlightsOptionsView()
    }
    
    deinit {
        print("FlightResultSingleJourneyVC")
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
    
    fileprivate func animateTableHeader() {
        if bannerView?.isHidden == false {
            guard let headerView = bannerView  else { return }
            
            let rect = headerView.frame
            
            UIView.animate(withDuration: 1) {
                self.resultsTableViewTop.constant = 0
                self.view.layoutIfNeeded()
            }
            
            UIView.animate(withDuration: 1.0 , animations: {
                let y = rect.origin.y - rect.size.height - 20
                headerView.frame = CGRect(x: 0, y: y , width: UIScreen.main.bounds.size.width, height: 156)
                self.view.layoutIfNeeded()
                
            }) { (bool) in
                
                self.bannerView?.isHidden = true
                self.updateUI()
            }
        }
        else {
            self.updateUI()
        }
    }
    
    func updateUI() {
        let rect = self.resultsTableView.rectForRow(at: IndexPath(row: 0, section: 0))
        self.resultsTableView.scrollRectToVisible(rect, animated: true)
        
        if viewModel.resultTableState == .showPinnedFlights {
            resultsTableView.tableFooterView = nil
        }else if self.viewModel.resultTableState == .showExpensiveFlights {
            if self.viewModel.results.suggestedJourneyArray.count != 0{
                self.setExpandedStateFooter()
            }else{
                resultsTableView.tableFooterView = nil
            }
        }else {
            if self.viewModel.results.suggestedJourneyArray.count == 0{
                tappedOnGroupedFooterView(UITapGestureRecognizer())
                resultsTableView.tableFooterView = nil
            }else{
                self.setGroupedFooterView()
            }
        }
        
        self.resultsTableView.isScrollEnabled = true
        self.resultsTableView.scrollsToTop = true
        self.resultsTableView.reloadData()
    }
    
    func applySorting(sortOrder : Sort, isConditionReverced : Bool, legIndex : Int, shouldReload : Bool = false, completion : (()-> Void)){
        previousRequest?.cancel()
        self.viewModel.sortOrder = sortOrder
        self.viewModel.isConditionReverced = isConditionReverced
        self.viewModel.prevLegIndex = legIndex
        self.viewModel.setPinnedFlights(shouldApplySorting: true)
        self.viewModel.applySorting(sortOrder: sortOrder, isConditionReverced: isConditionReverced, legIndex: legIndex)
        
        let newRequest = DispatchWorkItem {
            if shouldReload {
                self.resultsTableView.reloadData()
            }
        }
        
        completion()
        previousRequest = newRequest
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newRequest)
    }
    
    func updateWithArray(_ results : [Journey] , sortOrder: Sort ) {
        
        if viewModel.resultTableState == .showTemplateResults {
            viewModel.resultTableState = .showRegularResults
        }
        
        let modifiedResult = results
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.viewModel.sortOrder = sortOrder
            self.viewModel.results.sort = sortOrder
            
            self.viewModel.results.currentPinnedJourneys.forEach { (pinedJourney) in
                if let resultIndex = results.firstIndex(where: { (resultJourney) -> Bool in
                    return pinedJourney.id == resultJourney.id
                }){
                    modifiedResult[resultIndex].isPinned = true
                }
            }
            
            let groupedArray =   self.viewModel.getOnewayDisplayArray(results: modifiedResult)
            self.viewModel.results.journeyArray = groupedArray
//            self.sortedArray = Array(self.viewModel.results.sortedArray)
            self.viewModel.setPinnedFlights(shouldApplySorting: true)

            self.applySorting(sortOrder: self.viewModel.sortOrder, isConditionReverced: self.viewModel.isConditionReverced, legIndex: self.viewModel.prevLegIndex, completion: {
                DispatchQueue.main.async {
                    self.animateTableHeader()
                    
                    if (self.viewModel.resultTableState == .showPinnedFlights) ||
                        (self.viewModel.results.suggestedJourneyArray.isEmpty) ||
                        (self.viewModel.results.suggestedJourneyArray.count == self.viewModel.results.journeyArray.count) {
                        self.resultsTableView.tableFooterView = nil
                    }
                    
                    if self.viewModel.resultTableState == .showPinnedFlights && self.viewModel.results.pinnedFlights.isEmpty {
                        self.showNoFilteredResults()
                    } else if modifiedResult.count > 0 {
                        self.noResultScreen?.view.removeFromSuperview()
                        self.noResultScreen?.removeFromParent()
                        self.noResultScreen = nil
                    }
                    
                    if !self.viewModel.airlineCode.isEmpty{
                        for journ in modifiedResult {
                            let flightNum = journ.leg.first!.flights.first!.al + journ.leg.first!.flights.first!.fn
                            
                            if flightNum.uppercased() == self.viewModel.airlineCode.uppercased() {
                                
                                self.setPinnedFlightAt(journ.fk , isPinned: true)
                                self.switchView.isOn = true
                                self.switcherDidChangeValue(switcher: self.switchView, value: true)
                            }
                        }
                    }
                }
            })
        }
    }
    
    
    func getOnewayJourneyDisplayArray( results : [Journey] , sortingOrder:Sort) ->[JourneyOnewayDisplay]
    {
        var displayArray = [JourneyOnewayDisplay]()
        
        if (sortingOrder == .Smart || sortingOrder == .Price || sortingOrder == .PriceHighToLow || sortingOrder == .Duration || sortingOrder == .DurationLongestFirst) {
            
            if viewModel.resultTableState == .showExpensiveFlights {
                
                let combinedByGroupID = Dictionary(grouping: results, by: { $0.groupID })
                
                for (_ , journeyArray) in combinedByGroupID {
                    let journey = JourneyOnewayDisplay(journeyArray)
                    displayArray.append(journey)
                }
                
                if sortingOrder == .Smart {
                    displayArray = displayArray.sorted(by: { $0.computedHumanScore < $1.computedHumanScore })
                }
                else if sortingOrder == .Price{
                    displayArray = displayArray.sorted(by: { $0.fare < $1.fare })
                }else if sortingOrder == .PriceHighToLow{
                    displayArray = displayArray.sorted(by: { $0.fare > $1.fare })
                }
                //                else if sortingOrder == .Duration{
                //                    displayArray = displayArray.sorted(by: { $0.duration < $1.duration })
                //                }else{
                //                    displayArray = displayArray.sorted(by: { $0.duration > $1.duration })
                //                }
            }else {
                let combinedByGroupID = Dictionary(grouping: results, by: { $0.groupID })
                for (groupID , _) in combinedByGroupID {
                    
                    
                    if let groupedIDArray = combinedByGroupID[groupID] {
                        let combineByHumanScore = Dictionary(grouping: groupedIDArray, by: { $0.isAboveHumanScore })
                        
                        for (_ , grounpedByHumanScore) in combineByHumanScore {
                            let journey = JourneyOnewayDisplay(grounpedByHumanScore)
                            displayArray.append(journey)
                        }
                    }
                }
                
                if sortingOrder == .Smart {
                    displayArray = displayArray.sorted(by: { $0.computedHumanScore < $1.computedHumanScore })
                }
                else if sortingOrder == .Price{
                    displayArray = displayArray.sorted(by: { $0.fare < $1.fare })
                }else if sortingOrder == .PriceHighToLow{
                    displayArray = displayArray.sorted(by: { $0.fare > $1.fare })
                }
                //                else if sortingOrder == .Duration{
                //                    displayArray = displayArray.sorted(by: { $0.duration < $1.duration })
                //                }else{
                //                    displayArray = displayArray.sorted(by: { $0.duration > $1.duration })
                //                }
            }
        }else {
            for journey in results {
                displayArray.append(JourneyOnewayDisplay([journey]))
            }
            
            if sortingOrder == .Smart {
                displayArray = displayArray.sorted(by: { $0.computedHumanScore < $1.computedHumanScore })
            }else if sortingOrder == .Price {
                displayArray = displayArray.sorted(by: { $0.fare < $1.fare })
            }else if sortingOrder == .PriceHighToLow{
                displayArray = displayArray.sorted(by: { $0.fare > $1.fare })
            }
            //            else if sortingOrder == .Duration{
            //                displayArray = displayArray.sorted(by: { $0.duration < $1.duration })
            //            }else{
            //                displayArray = displayArray.sorted(by: { $0.duration > $1.duration })
            //            }
        }
        
        return displayArray
    }
    
    func updateAirportDetailsArray(_ results : [String : AirportDetailsWS])
    {
        self.viewModel.airportDetailsResult = results
    }
    
    func updateAirlinesDetailsArray(_ results : [String : AirlineMasterWS])
    {
        self.viewModel.airlineDetailsResult = results
    }
    
    func updateTaxesArray(_ results : [String : String])
    {
        self.viewModel.taxesResult = results
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
    
    
    func setupPinnedFlightsOptionsView()
    {
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
        
        //        manageSwitchContainer(isHidden: true)
        showPinnedFlightsOption(false)
        hidePinnedFlightOptions(true)
        
        addShadowTo(unpinnedAllButton)
        addShadowTo(emailPinnedFlights)
        addShadowTo(sharePinnedFilghts)
    }
    
    func addShadowTo(_ view : UIView)
    {
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
                rect.origin.y = -visualEffectViewHeight
                
                
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
            self.view.addSubview(self.bannerView!)
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 96))
            self.resultsTableView.tableHeaderView = headerView
            self.resultsTableView.isScrollEnabled = false
            self.resultsTableView.tableFooterView = nil
            
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
        
        hidePinnedFlightOptions(!sender.isOn)
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
    
    @IBAction func emailPinnedFlights(_ sender: Any) {
        
        guard let postData = generatePostDataForEmail(for: self.viewModel.results.pinnedFlights) else { return }
        executeWebServiceForEmail(with: postData as Data, onCompletion:{ (view)  in
            
            DispatchQueue.main.async {
                self.showEmailViewController(body : view)
            }
        })
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
    
    func reloadRowFromFlightDetails(fk: String, isPinned: Bool,isPinnedButtonClicked:Bool)
    {
        if isPinnedButtonClicked == true{
            setPinnedFlightAt(fk, isPinned: isPinned)
        }
        
        if let cell =  resultsTableView.dequeueReusableCell(withIdentifier: "SingleJourneyResultTableViewCell") as? SingleJourneyResultTableViewCell{
            
            cell.smartIconsArray = cell.currentJourney?.smartIconArray
            cell.smartIconCollectionView.reloadData()
        }
    }
    
    
    //MARK:- Scroll related methods
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.viewModel.scrollviewInitialYOffset = scrollView.contentOffset.y
    }
    
    fileprivate func hideHeaderBlurView(_ offsetDifference: CGFloat) {
        DispatchQueue.main.async {
            
            var yCordinate : CGFloat
            yCordinate = max (  -self.visualEffectViewHeight ,  -offsetDifference )
            yCordinate = min ( 0,  yCordinate)
            
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
                
                if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
                    var rect = blurEffectView.frame
                    let yCordinateOfView = rect.origin.y
                    if ( yCordinateOfView  > yCordinate ) {
                        rect.origin.y = yCordinate
                        blurEffectView.frame = rect
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
                    
                    var yCordinate = rect.origin.y + invertedOffset
                    yCordinate = min ( 0,  yCordinate)
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
    }
    
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
        //            var arrayForDisplay = viewModel.results.suggestedJourneyArray
        //
        //            if viewModel.resultTableState == .showExpensiveFlights && indexPath.section == 1 {
        //                arrayForDisplay = viewModel.results.expensiveJourneyArray
        //            }
        //
        //             let journey = arrayForDisplay[indexPath.row]
        //
        //                if journey.cellType == .singleJourneyCell {
        //                    addToTrip(journey: journey.first )
        //                }
        //                else {
        //                    addToTrip(journey: journey.first)
        //                }
        //
        //        }
        //        else {
        //            let currentJourney =  self.sortedArray[indexPath.row]
        //            addToTrip(journey: currentJourney)
        //        }
    }
    
    func addToTrip(journey : Journey) {
        let tripListVC = TripListVC(nibName: "TripListVC", bundle: nil)
        tripListVC.journey = [journey]
        tripListVC.modalPresentationStyle = .overCurrentContext
        self.present(tripListVC, animated: true, completion: nil)
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
    
    // Monika
    func returnEmailView(view: String) {
        
    }
    
    func navigateToFlightDetailFor(journey: Journey) {
        
    }
    
    
    //MARK:- Methods for naviagating to other View Controller
    
    func navigateToFlightDetailFor(journey : Journey, selectedIndex:IndexPath) {
        let storyboard = UIStoryboard(name: "FlightDetailsBaseVC", bundle: nil)
        let flightDetailsVC:FlightDetailsBaseVC =
            storyboard.instantiateViewController(withIdentifier: "FlightDetailsBaseVC") as! FlightDetailsBaseVC
        
        flightDetailsVC.delegate = self
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


