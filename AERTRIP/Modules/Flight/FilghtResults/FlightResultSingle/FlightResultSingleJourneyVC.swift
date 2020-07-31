//
//  FilghtResultSingleJourneyVC.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit
import MessageUI

class FlightResultSingleJourneyVC: UIViewController,  flightDetailsPinFlightDelegate , GroupedFlightCellDelegate , MFMailComposeViewControllerDelegate
{
    func navigateToFlightDetailFor(journey: Journey) {
        
    }
    
    //MARK:- Outlets
    var bannerView : ResultHeaderView?
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var pinnedFlightsOptionsView : UIView!
    @IBOutlet weak var showPinnedSwitch: AertripSwitch!
    @IBOutlet weak var unpinnedAllButton: UIButton!
    @IBOutlet weak var emailPinnedFlights: UIButton!
    @IBOutlet weak var sharePinnedFilghts: UIButton!
    @IBOutlet weak var pinnedFlightOptionsTop: NSLayoutConstraint!
    
    @IBOutlet weak var pinOptionsViewWidth: NSLayoutConstraint!
    @IBOutlet weak var unpinAllLeading: NSLayoutConstraint!
    @IBOutlet weak var emailPinnedLeading: NSLayoutConstraint!
    @IBOutlet weak var sharePinnedFlightLeading: NSLayoutConstraint!
    @IBOutlet weak var resultsTableViewTop: NSLayoutConstraint!
   
    var noResultScreen : NoResultsScreenViewController?
    //MARK:- State Properties
    var titleString : NSAttributedString!
    var subtitleString : String!
    var resultTableState  = ResultTableViewState.showTemplateResults
    var stateBeforePinnedFlight = ResultTableViewState.showRegularResults
    var results : OnewayJourneyResultsArray!
    var sortedArray: [Journey]!
    var airportDetailsResult : [String : AirportDetailsWS]!
    var airlineDetailsResult : [String : AirlineMasterWS]!
    var taxesResult : [String : String]!

    var sortedJourneyArray : [JourneyOnewayDisplay]!
    var airlineCode = ""

    var flightsResults  =  FlightsResults()
    var pinnedFlightsArray = [Journey]()
    var sid : String = ""
    var bookFlightObject = BookFlightObject()
    var visualEffectViewHeight : CGFloat {
        return statusBarHeight + 88.0
    }
    var statusBarHeight : CGFloat {
        return UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
    }
    var scrollviewInitialYOffset = CGFloat(0.0)
    var sortOrder = Sort.Smart
    var flightSearchResultVM  : FlightSearchResultVM!
    var tempResults = [Journey]()
    var userSelectedFilters = [FiltersWS]()
    var updatedApiProgress : Float = 0
    var apiProgress : Float = 0
    var ApiProgress: UIProgressView!
    

    //MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        ApiProgress = UIProgressView()
//        ApiProgress.progressTintColor = UIColor.AertripColor
//        ApiProgress.trackTintColor = .clear
//        ApiProgress.progress = 0.25
//        
//        ApiProgress.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 10.0)
//        self.resultsTableView.addSubview(ApiProgress)

        
        results = OnewayJourneyResultsArray(sort: .Smart)
        setupTableView()
        setupPinnedFlightsOptionsView()
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
            resultsTableViewTop.constant = 0
            
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
        
        if resultTableState == .showPinnedFlights {
            resultsTableView.tableFooterView = nil
        }else if self.resultTableState == .showExpensiveFlights {
            if results.suggestedJourneyArray.count != 0{
                self.setExpandedStateFooter()
            }else{
                resultsTableView.tableFooterView = nil
            }
        }else {
            if results.suggestedJourneyArray.count == 0{
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
    
    func updateWithArray(_ results : [Journey] , sortOrder: Sort )
    {
        tempResults = results
        
        if resultTableState == .showTemplateResults {
            resultTableState = .showRegularResults
        }
        
        
        for j in results{
            let flightNum = j.leg.first!.flights.first!.al + j.leg.first!.flights.first!.fn
            if flightNum.uppercased() == airlineCode.uppercased(){
                j.isPinned = true
                showPinnedFlightsOption(true)
            }
        }
        
        DispatchQueue.main.async
        {
            let appliedFilters = (self.flightSearchResultVM.flightLegs.first?.appliedFilters.count)!
            if appliedFilters > 0{
                if self.userSelectedFilters.count != 1 && self.updatedApiProgress < 0.95{
                    self.userSelectedFilters = [self.flightSearchResultVM.flightLegs.first!.userSelectedFilters]
                }
            }else{
                self.userSelectedFilters.removeAll()
            }

            if self.resultTableState == .showPinnedFlights{
                var newJourney = [Journey]()
                
                let inputJourneyArray = self.flightSearchResultVM.flightLegs.first!.InputJourneyArray
                for j in inputJourneyArray{
                    if j.isPinned!{
                        newJourney.append(j)
                        self.pinnedFlightsArray.append(j)
                    }
                }
                

                var journeyArray = [Journey]()
//                for flightLeg in self.flightSearchResultVM.flightLegs
//                {
//                    if appliedFilters > 0{
//                        journeyArray = flightLeg.applyStopsFilter(newJourney)
//                        journeyArray = flightLeg.applyPriceFilter(journeyArray)
//                        journeyArray = flightLeg.applyOriginFilter(journeyArray)
//                        journeyArray = flightLeg.applyAirlineFilter(journeyArray)
//                        journeyArray = flightLeg.applyLayoverFilter(journeyArray)
//                        journeyArray = flightLeg.applyDurationFilter(journeyArray)
//                        journeyArray = flightLeg.applyArrivalTimeFilter(journeyArray)
//                        journeyArray = flightLeg.applyDestinationFilter(journeyArray)
//                        journeyArray = flightLeg.applyDepartureTimeFilter(journeyArray)
//                        journeyArray = flightLeg.applyMultiItinaryAirlineFilter(journeyArray)
//                        journeyArray = flightLeg.applySortFilter(inputArray: journeyArray)
//
//                        flightLeg.updatedFilterResultCount = journeyArray.count
//                        print("updatedFilterResultCount=",flightLeg.updatedFilterResultCount)
//
//                    }else{
//                        journeyArray = newJourney
//                        flightLeg.updatedFilterResultCount = 0
//                    }
//
//
//                }

                if journeyArray.count > 0 {
                    self.pinnedFlightsArray = journeyArray
                    self.animateTableHeader()

                    self.noResultScreen?.view.removeFromSuperview()
                    self.noResultScreen?.removeFromParent()
                    self.noResultScreen = nil
                }else{
                    self.showNoFilteredResults()
                }
            }else{
                if appliedFilters > 0{
                    var journeyArray = [Journey]()
//                    for flightLeg in self.flightSearchResultVM.flightLegs
//                    {
//                        if self.userSelectedFilters.first != nil{
//                            flightLeg.userSelectedFilters = self.userSelectedFilters.first
//                        }
//                        
//                        if flightLeg.userSelectedFilters.stp.count == 0{
//                            flightLeg.appliedFilters.remove(.stops)
                            journeyArray = results
//                        }else{
//                            journeyArray = flightLeg.applyStopsFilter(results)
//                        }
//                        
//                        
//                        if flightLeg.appliedFilters.contains(.Airlines){
//                            journeyArray = flightLeg.applyAirlineFilter(journeyArray)
//                        }
//                        
//                        if flightLeg.appliedFilters.contains(.Price){
//                            journeyArray = flightLeg.applyPriceFilter(journeyArray)
//                        }
//
//                        if flightLeg.appliedFilters.contains(.Duration){
//                            journeyArray = flightLeg.applyDurationFilter(journeyArray)
//                        }
//                        
//                        
//                        if flightLeg.appliedFilters.contains(.Times){
//                            journeyArray = flightLeg.applyDepartureTimeFilter(journeyArray)
//                            journeyArray = flightLeg.applyArrivalTimeFilter(journeyArray)
//                        }
//                        
//                        
////                        journeyArray = flightLeg.applyOriginFilter(journeyArray)
////                        journeyArray = flightLeg.applyLayoverFilter(journeyArray)
////                        journeyArray = flightLeg.applyDestinationFilter(journeyArray)
////                        journeyArray = flightLeg.applyMultiItinaryAirlineFilter(journeyArray)
//
//                        if flightLeg.appliedFilters.contains(.sort){
//                            journeyArray = flightLeg.applySortFilter(inputArray: journeyArray)
//                        }
//
//                        flightLeg.updatedFilterResultCount = journeyArray.count
//                    }
//
//                                        
                    let groupedArray =  self.getOnewayJourneyDisplayArray(results: journeyArray, sortingOrder: sortOrder)
                    self.results.journeyArray = groupedArray
                    self.sortedArray = Array(self.results.sortedArray)

                }else{
                    let groupedArray =  self.getOnewayJourneyDisplayArray(results: results, sortingOrder: sortOrder)
                    self.results.journeyArray = groupedArray
                    self.sortedArray = Array(self.results.sortedArray)
                    
                    self.flightSearchResultVM.flightLegs.first?.updatedFilterResultCount = 0
                }
                self.results.sort = sortOrder
                self.sortOrder = sortOrder
                self.animateTableHeader()
                
                if results.count > 0 {
                    self.noResultScreen?.view.removeFromSuperview()
                    self.noResultScreen?.removeFromParent()
                    self.noResultScreen = nil
                }
            }
            NotificationCenter.default.post(name:NSNotification.Name("updateFilterScreenText"), object: nil)
        }
    }
    
    func getOnewayJourneyDisplayArray( results : [Journey] , sortingOrder:Sort) ->[JourneyOnewayDisplay]
    {
        var displayArray = [JourneyOnewayDisplay]()
        
        if (sortingOrder == .Smart || sortingOrder == .Price || sortingOrder == .PriceHighToLow || sortingOrder == .Duration || sortingOrder == .DurationLongestFirst) {
            
            if resultTableState == .showExpensiveFlights {
                
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
        airportDetailsResult = results
    }
    
    func updateAirlinesDetailsArray(_ results : [String : AirlineMasterWS])
    {
        airlineDetailsResult = results
    }
    
    func updateTaxesArray(_ results : [String : String])
    {
       taxesResult = results
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
        pinnedFlightOptionsTop.constant = 0
                
        showPinnedSwitch.tintColor = UIColor.TWO_ZERO_FOUR_COLOR
        showPinnedSwitch.offTintColor = UIColor.TWO_THREE_ZERO_COLOR
        showPinnedSwitch.isOn = false
        showPinnedSwitch.setupUI()
        
        hidePinnedFlightOptions(true)
        addShadowTo(unpinnedAllButton)
        addShadowTo(emailPinnedFlights)
        addShadowTo(sharePinnedFilghts)
    }
    
    func showPinnedFlightsOption(_ show  : Bool)
    {
        let offsetFromBottom = show ? 60.0 + self.view.safeAreaInsets.bottom : 0
        self.pinnedFlightOptionsTop.constant = CGFloat(offsetFromBottom)
        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
    
    fileprivate func hidePinnedFlightOptions( _ hide : Bool){
        //*******************Haptic Feedback code********************
           let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
           selectionFeedbackGenerator.selectionChanged()
        //*******************Haptic Feedback code********************

        print("hide=\(hide)")
        if hide{
            
            //true - hideOption
            
            UIView.animate(withDuration: TimeInterval(0.4), delay: 0, options: .curveEaseOut, animations: { [weak self] in
                self?.showPinnedSwitch.isUserInteractionEnabled = false

                   self?.unpinnedAllButton.alpha = 0.0
                   self?.emailPinnedFlights.alpha = 0.0
                   self?.sharePinnedFilghts.alpha = 0.0
                   self?.unpinnedAllButton.transform = CGAffineTransform(translationX: 0, y: 0)
                   self?.emailPinnedFlights.transform = CGAffineTransform(translationX: 0, y: 0)
                   self?.sharePinnedFilghts.transform = CGAffineTransform(translationX: 0, y: 0)
                   }, completion: { [weak self] (success)
            in
                       self?.unpinnedAllButton.isHidden = true
                       self?.emailPinnedFlights.isHidden = true
                       self?.sharePinnedFilghts.isHidden = true
                       self?.unpinnedAllButton.alpha = 1.0
                       self?.emailPinnedFlights.alpha = 1.0
                       self?.sharePinnedFilghts.alpha = 1.0
                    self?.showPinnedSwitch.isUserInteractionEnabled = true
               })
        }else{
            //false - showOption
            self.unpinnedAllButton.alpha = 0.0
            self.emailPinnedFlights.alpha = 0.0
            self.sharePinnedFilghts.alpha = 0.0
            UIView.animate(withDuration: TimeInterval(0.4), delay: 0, options: [.curveEaseOut, ], animations: { [weak self] in
                self?.showPinnedSwitch.isUserInteractionEnabled = false

                self?.unpinnedAllButton.isHidden = false
                self?.emailPinnedFlights.isHidden = false
                self?.sharePinnedFilghts.isHidden = false

                self?.unpinnedAllButton.alpha = 1.0
                self?.emailPinnedFlights.alpha = 1.0
                self?.sharePinnedFilghts.alpha = 1.0
                self?.unpinnedAllButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self?.emailPinnedFlights.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self?.sharePinnedFilghts.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self?.emailPinnedFlights.transform = CGAffineTransform(translationX: 60, y: 0)
                self?.sharePinnedFilghts.transform = CGAffineTransform(translationX: 114, y: 0)
                self?.unpinnedAllButton.transform = CGAffineTransform(translationX: 168, y: 0)
                }, completion: { [weak self] (success)
                    in
                    self?.showPinnedSwitch.isUserInteractionEnabled = true
            })
        }
    }
//    {
//        
//        //*******************Haptic Feedback code********************
//           let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
//           selectionFeedbackGenerator.selectionChanged()
//        //*******************Haptic Feedback code********************
//
//        
//        let optionViewWidth : CGFloat =  hide ? 50.0 : 212.0
//        let unpinButtonLeading : CGFloat = hide ? 0.0 : 60.0
//        let emailButton : CGFloat = hide ? 0.0 : 114.0
//        let shareButtonLeading : CGFloat =
//        hide ?  0.0 : 168.0
//        
//        if !hide {
//            self.emailPinnedFlights.isHidden = hide
//            self.unpinnedAllButton.isHidden = hide
//            self.sharePinnedFilghts.isHidden = hide
//        }
//        
//        pinOptionsViewWidth.constant = optionViewWidth
//        
//        unpinAllLeading.constant = unpinButtonLeading
//        emailPinnedLeading.constant = emailButton
//        sharePinnedFlightLeading.constant = shareButtonLeading
//        
//        UIView.animate(withDuration: 0.41, delay: 0.0 ,
//                       options: [.curveEaseOut]
//            , animations: {
//                
//                self.view.layoutIfNeeded()
//                
//        }) { (onCompletion) in
//            
//            if hide {
//                
//                self.emailPinnedFlights.isHidden = hide
//                self.unpinnedAllButton.isHidden = hide
//                self.sharePinnedFilghts.isHidden = hide
//            }
//        }
//    }
    
    
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
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 76))
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
    
    //MARK:- Tableview Footer View
    
    func showFooterView() {
        
        if resultTableState == .showPinnedFlights {
            resultsTableView.tableFooterView = nil
            return
        }
        
        if resultTableState == .showExpensiveFlights {
            setExpandedStateFooter()
        }
        else {
            setGroupedFooterView()
        }
    }
    
    func setGroupedFooterView()
    {
        if results.aboveHumanScoreCount == 0 {
            resultsTableView.tableFooterView = nil
            return
        }
        
        var numberOfView = 0
        
        switch  results.aboveHumanScoreCount {
        case 1:
            numberOfView = 1
        case 2 :
            numberOfView = 2
        default:
            numberOfView = 3
        }
        
        let height = 44.0 + 35.0 + CGFloat(numberOfView - 1) * 16.0
        let footerViewRect =  CGRect(x: 0, y: 0, width: resultsTableView.frame.width, height: height)
        let groupedFooterView = UIView(frame:footerViewRect)
        groupedFooterView.isUserInteractionEnabled = true
        
        let  tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnGroupedFooterView(_:)))
        tapGesture.numberOfTapsRequired = 1
        groupedFooterView.addGestureRecognizer(tapGesture)
        
        for count in 1...numberOfView {
            
            let baseView = createRepeatedFooterBaseView()
            baseView.frame = CGRect(x: (8 * count) ,y: (10 + 6 * count) ,width: (Int(groupedFooterView.frame.width) - (16 * count))  ,height:44)
            groupedFooterView.addSubview(baseView)
            groupedFooterView.sendSubviewToBack(baseView)
        }
        
        
        let titleLabel = UILabel(frame: CGRect(x:8,y: 16 ,width:groupedFooterView.frame.width - 16  ,height:44))
        titleLabel.textColor = UIColor.AertripColor
        titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 18.0)
        titleLabel.textAlignment = .center
        
        let count = results.aboveHumanScoreCount
        if count == 1 {
            titleLabel.text  = "Show 1 longer or expensive flight"
        }else {
            titleLabel.text  = "Show " + String(count) + " longer or expensive flights"
        }
        
        groupedFooterView.addSubview(titleLabel)
        
        
        if let footerView = resultsTableView.tableFooterView {
            
            for subview in footerView.subviews {
                subview.removeFromSuperview()
            }
            
            footerView.frame = footerViewRect
            footerView.addSubview(groupedFooterView)
        }
        else {
            
            let footerView = UIView(frame : footerViewRect)
            footerView.addSubview(groupedFooterView)
            resultsTableView.tableFooterView = footerView
        }
        
    }
    
    @objc func tappedOnGroupedFooterView(_ sender : UITapGestureRecognizer) {
        resultTableState = .showExpensiveFlights
        self.results.sort = sortOrder
        self.results.excludeExpensiveFlights = false
        let groupedArray =  self.getOnewayJourneyDisplayArray(results: self.results.sortedArray, sortingOrder: sortOrder)
        self.results.journeyArray = groupedArray
        self.sortedArray = Array(self.results.sortedArray)
        resultsTableView.reloadData()
        setExpandedStateFooter()
    }
    
    
    func setExpandedStateFooter() {
        
        let footerViewRect = CGRect(x: 0, y: 0, width: resultsTableView.frame.width, height: 95)
        let expandedFooterView = UIView(frame: footerViewRect)
        expandedFooterView.isUserInteractionEnabled = true
        
        let  tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnExpandedFooterView(_:)))
        tapGesture.numberOfTapsRequired = 1
        expandedFooterView.addGestureRecognizer(tapGesture)
        

        let baseView = createRepeatedFooterBaseView()
        baseView.frame = CGRect(x: 8,y: 16 ,width:expandedFooterView.frame.width - 16  ,height:44)

        expandedFooterView.addSubview(baseView)
 
        let titleLabel = UILabel(frame: CGRect(x:8,y: 16 ,width:expandedFooterView.frame.width - 16  ,height:44))
        titleLabel.textColor = UIColor.AertripColor
        titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 18)
        titleLabel.textAlignment = .center
        let count = results.aboveHumanScoreCount
        
        if count == 0 {
            resultsTableView.tableFooterView = nil
            return
        }
        
        

        titleLabel.text  = "Hide " + String(count) + " longer or expensive flights"
        expandedFooterView.addSubview(titleLabel)
        
        
        if let footerView = resultsTableView.tableFooterView {
            
            for subview in footerView.subviews {
                subview.removeFromSuperview()
            }
            
            footerView.frame = footerViewRect
            footerView.addSubview(expandedFooterView)
        }
        else {
            let footerView = UIView(frame : footerViewRect)
            footerView.addSubview(expandedFooterView)
            resultsTableView.tableFooterView = footerView
        }
    }
    
    
    func createRepeatedFooterBaseView() -> UIView {
        let baseView = UIView(frame: CGRect(x: 0 , y: 0, width: resultsTableView.frame.width, height: 44))
        baseView.backgroundColor = .white
        baseView.layer.cornerRadius = 5.0
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOpacity = 0.1
        baseView.layer.shadowRadius = 8.0
        baseView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        return baseView
    }
    
    
    @objc func tapOnExpandedFooterView(_ sender: UITapGestureRecognizer)
    {
        resultTableState = stateBeforePinnedFlight
        self.results.sort = sortOrder
        
        if self.results.belowThresholdHumanScore <= 0 {
            self.results.excludeExpensiveFlights = false
        }
        else {
            self.results.excludeExpensiveFlights = true
        }
        
        let groupedArray =  self.getOnewayJourneyDisplayArray(results: self.results.sortedArray, sortingOrder: sortOrder)
        self.results.journeyArray = groupedArray
        self.sortedArray = Array(self.results.sortedArray)
        
        if sortOrder == .Smart{
//            || sortOrder == .Price || sortOrder == .PriceHighToLow {
            resultsTableView.deleteSections(IndexSet(integer: 1), with: .fade)
        }
        else {
            resultsTableView.reloadData()
        }
        setGroupedFooterView()
        showBluredHeaderViewCompleted()
    }
    
    
    //MARK:- Target  methods
    fileprivate func showBluredHeaderViewCompleted() {
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut], animations: {
                
                if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
                    var rect = blurEffectView.frame
                    rect.origin.y = 0
                    blurEffectView.frame = rect
                }
            } ,completion: nil)
        }
    }
    
    @IBAction func PinnedFlightSwitchToggled(_ sender: AertripSwitch) {
        
        if sender.isOn {
            stateBeforePinnedFlight = resultTableState
            resultTableState = .showPinnedFlights
            resultsTableView.tableFooterView = nil
        }
        else {
            resultTableState = stateBeforePinnedFlight
            showFooterView()
        }
        
        hidePinnedFlightOptions(!sender.isOn)
        updateWithArray(tempResults, sortOrder: sortOrder)
        
        resultsTableView.reloadData()
        resultsTableView.setContentOffset(.zero, animated: false)
        showBluredHeaderViewCompleted()
        

    }
    
    fileprivate func performUnpinnedAllAction() {
        for i in 0 ..< results.journeyArray.count {
            
            let journeyGroup = results.journeyArray[i]
            let newJourneyGroup = journeyGroup
            newJourneyGroup.journeyArray = journeyGroup.journeyArray.map{
                let journey = $0
                journey.isPinned = false
                return journey
            }
            
            results.journeyArray[i] = newJourneyGroup
        }
        
        showPinnedSwitch.isOn = false
        hidePinnedFlightOptions(true)
        resultTableState = stateBeforePinnedFlight
        
        showPinnedFlightsOption(false)
        resultsTableView.reloadData()
        showFooterView()
        
        resultsTableView.setContentOffset(.zero, animated: true)
    }
    
    @IBAction func unpinnedAllTapped(_ sender: Any) {
        

        let alert = UIAlertController(title: "Unpin All?", message: "This action will unpin all the pinned flights and cannot be undone.", preferredStyle: .alert)

        alert.view.tintColor = UIColor.AertripColor
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
              }))
        alert.addAction(UIAlertAction(title: "Unpin all", style: .destructive, handler: { action in
            self.performUnpinnedAllAction()
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
        
//        guard let postData = generatePostDataForEmail(for: results.pinnedFlights) else { return }

        guard let postData = generatePostDataForEmail(for: pinnedFlightsArray) else { return }
        executeWebServiceForEmail(with: postData as Data, onCompletion:{ (view)  in
            
            DispatchQueue.main.async {
                self.showEmailViewController(body : view)
            }
        })
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sharePinnedFlights(_ sender: Any) {
        
        
//        guard let postData = generatePostData(for: results.pinnedFlights ) else { return }
        guard let postData = generatePostData(for: pinnedFlightsArray ) else { return }

        executeWebServiceForShare(with: postData as Data, onCompletion:{ (link)  in
            
            DispatchQueue.main.async {
                let textToShare = [ link ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
                
            }
        })
        
        
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
        
        if indexPath.section == 0 {
            results.suggestedJourneyArray[indexPath.row] = journeyDisplay
        }
        else {
            results.expensiveJourneyArray[indexPath.row] = journeyDisplay
        }
        
        let suggestedPinnedFlight = results.suggestedJourneyArray.reduce(results.suggestedJourneyArray[0].containsPinnedFlight) { $0 || $1.containsPinnedFlight }
        
        var expensivePinnedFlight = false
        if results.expensiveJourneyArray.count > 0 {
            expensivePinnedFlight  = results.expensiveJourneyArray.reduce(results.expensiveJourneyArray[0].containsPinnedFlight) { $0 || $1.containsPinnedFlight }
        }
        if !(suggestedPinnedFlight ||  expensivePinnedFlight) {
            showPinnedFlightsOption(false)
        }else {
            showPinnedFlightsOption(true)
        }
         self.resultsTableView.reloadRows(at: [indexPath], with: .none)
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
        
        scrollviewInitialYOffset = scrollView.contentOffset.y
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
        let offsetDifference = contentOffset.y - scrollviewInitialYOffset
        if offsetDifference > 0 {
            hideHeaderBlurView(offsetDifference)
        }
        else {
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
    //MARK:- Methods to get different types of cells
    func getTemplateCell () -> UITableViewCell {
        
        if let cell =  resultsTableView.dequeueReusableCell(withIdentifier: "SingleJourneyTemplateCell") {
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func getSingleJourneyCell (indexPath : IndexPath , journey : Journey  ) -> UITableViewCell {
        
        if let cell =  resultsTableView.dequeueReusableCell(withIdentifier: "SingleJourneyResultTableViewCell") as? SingleJourneyResultTableViewCell{
            
            if #available(iOS 13, *) {
                let interaction = UIContextMenuInteraction(delegate: self)
                cell.baseView.addInteraction(interaction)
            }
            
            cell.selectionStyle = .none
            cell.setTitlesFrom( journey : journey)
            if let logoArray = journey.airlineLogoArray {
                
                switch logoArray.count {
                case 1 :
                    cell.logoTwo.isHidden = true
                    cell.logoThree.isHidden = true
                    setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                case 2 :
                    cell.logoThree.isHidden = true
                    setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                    setImageto(imageView: cell.logoTwo, url:logoArray[1] , index:  indexPath.row)
                    
                case 3 :
                    setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                    setImageto(imageView: cell.logoTwo, url:logoArray[1] , index:  indexPath.row)
                    setImageto(imageView: cell.logoThree, url:logoArray[2] , index:  indexPath.row)
                default:
                    break
                }
            }
            return cell
        }
        assertionFailure("Failed to create SingleJourneyResultTableViewCell cell ")
        
        return UITableViewCell()
    }
    
    
    func getGroupedFlightCell( indexPath : IndexPath , journey : JourneyOnewayDisplay  ) -> UITableViewCell {
        
        if let cell =  resultsTableView.dequeueReusableCell(withIdentifier: "GroupedFlightCell") as? GroupedFlightCell {
            cell.selectionStyle = .none
            cell.delegate = self
            cell.setVaulesFrom(journey: journey)
            cell.buttonTapped = {
                self.reloadTableCell(indexPath)
            }
            return cell
        }
        assertionFailure("Failed to create GroupedFlightCell ")
        
        return UITableViewCell()
    }
    
    
    func reloadTableCell(_ indexPath: IndexPath){
        
        DispatchQueue.main.async {
            self.resultsTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    
    //MARK:-  Actions to be performed on Journey objects
    
    func addToTripFlightAt(_ indexPath : IndexPath){
        
        if sortOrder == .Smart{
//            || sortOrder == .Price || sortOrder == .PriceHighToLow{
            var arrayForDisplay = results.suggestedJourneyArray
            
            if resultTableState == .showExpensiveFlights && indexPath.section == 1 {
                arrayForDisplay = results.expensiveJourneyArray
            }
            
            if let journey = arrayForDisplay?[indexPath.row]  {
                
                if journey.cellType == .singleJourneyCell {
                    addToTrip(journey: journey.first )
                }
                else {
                    addToTrip(journey: journey.first)
                }
            }
        }
        else {
            let currentJourney =  self.sortedArray[indexPath.row]
            addToTrip(journey: currentJourney)
        }
    }
    
    func addToTrip(journey : Journey) {
            let tripListVC = TripListVC(nibName: "TripListVC", bundle: nil)
            tripListVC.journey = [journey]
            tripListVC.modalPresentationStyle = .overCurrentContext
            self.present(tripListVC, animated: true, completion: nil)
    }
    
    func shareFlightAt(_ indexPath : IndexPath) {
        
        var journey : Journey?
        
        if self.resultTableState == .showPinnedFlights {
            
//            let journeyArray = self.results.pinnedFlights
            let journeyArray = self.pinnedFlightsArray
            journey = journeyArray[indexPath.row]
        }
        else {
            
            if self.sortOrder == .Smart{
//                || self.sortOrder == .Price || self.sortOrder == .PriceHighToLow{
                var arrayForDisplay = self.results.suggestedJourneyArray
                
                if self.resultTableState == .showExpensiveFlights && indexPath.section == 1 {
                    arrayForDisplay = self.results.expensiveJourneyArray
                }
                
                if let currentJourney = arrayForDisplay?[indexPath.row].first {
                    
                    journey = currentJourney
                }
                
            }
            else {
                journey = self.sortedArray[indexPath.row]
            }
        }
        
        guard let strongJourney = journey else { return }
        shareJourney(journey: strongJourney)
        
    }
    
     func setPinnedFlightAt(_ flightKey: String , isPinned : Bool) {
        
        guard let index = results.journeyArray.firstIndex(where: {
            
            for journey in $0.journeyArray {
                
                if journey.fk == flightKey
                {
                    return true
                }
            }
            return false
        }) else {
            return
        }
            
        let displayArray = results.journeyArray[index]
        
        guard let journeyArrayIndex = displayArray.journeyArray.firstIndex(where : {
            $0.fk == flightKey
        }) else {
            return
        }
        
        displayArray.journeyArray[journeyArrayIndex].isPinned = isPinned
        results.journeyArray[index] = displayArray
        
        
        if isPinned {
            self.pinnedFlightsArray.append(displayArray.journeyArray[journeyArrayIndex])
            showPinnedFlightsOption(true)
        }
        else {
            for i in 0..<pinnedFlightsArray.count{
                if pinnedFlightsArray[i].fk == flightKey{
                    pinnedFlightsArray.remove(at: i)
                }
            }

            let containesPinnedFlight = results.journeyArray.reduce(results.journeyArray[0].containsPinnedFlight) { $0 || $1.containsPinnedFlight }
            showPinnedFlightsOption(containesPinnedFlight)
            
            if !containesPinnedFlight {
                resultTableState = stateBeforePinnedFlight
                hidePinnedFlightOptions(true)
                showPinnedSwitch.isOn = false
            }
        }
        self.resultsTableView.reloadData()
        showFooterView()
        
    }
    
    //MARK:-  Methods for TableviewCell Swipe Implementation
    
    fileprivate func createSwipeActionForLeftOrientation(_ indexPath: IndexPath) -> [UIContextualAction] {
        

        var currentArray : [JourneyOnewayDisplay]
        let flightKey : String
        let journey : JourneyOnewayDisplay
        
        if sortOrder == .Smart {
            //|| sortOrder == .Price || sortOrder == .PriceHighToLow{
            if indexPath.section == 0 {
                currentArray = results.suggestedJourneyArray
            }
            else {
                currentArray = results.expensiveJourneyArray
            }
            journey = currentArray[indexPath.row]
            flightKey = journey.journeyArray[0].fk


            if journey.isPinned(atIndex: 0) {

                let pinAction = UIContextualAction(style: .normal, title: nil , handler: { [weak self] (action, view , completionHandler)  in

                    if let strongSelf = self {
                        strongSelf.setPinnedFlightAt(flightKey , isPinned:  false)
                        strongSelf.showPinnedSwitch.isOn = false
                        strongSelf.hidePinnedFlightOptions(true)
                    }
                    completionHandler(true)
                })
                pinAction.backgroundColor = .white
                if let cgImageX =  UIImage(named: "Unpin")?.cgImage {
                    pinAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
                }

                return [pinAction]

            }
            else {

                let pinAction = UIContextualAction(style: .normal, title: nil , handler: { [weak self] (action, view , completionHandler)  in

                    if let strongSelf = self {
                        strongSelf.setPinnedFlightAt(flightKey , isPinned:  true)
                    }
                    completionHandler(true)
                })

                pinAction.backgroundColor = .white
                if let cgImageX =  UIImage(named: "Pin")?.cgImage {
                    pinAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
                }

                return [pinAction]

            }


        }
        else {

            let currentJourney = self.sortedArray[indexPath.row]
            flightKey = currentJourney.fk

            if currentJourney.isPinned ?? false {

                let pinAction = UIContextualAction(style: .normal, title: nil , handler: { [weak self] (action, view , completionHandler)  in

                    if let strongSelf = self {
                        strongSelf.setPinnedFlightAt(flightKey , isPinned:  false)
                        strongSelf.showPinnedSwitch.isOn = false
                        strongSelf.hidePinnedFlightOptions(true)
                    }
                   completionHandler(true)
                })
                pinAction.backgroundColor = .white
                if let cgImageX =  UIImage(named: "Unpin")?.cgImage {
                    pinAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
                }

                return [pinAction]

            }
            else {

                let pinAction = UIContextualAction(style: .normal, title: nil , handler: { [weak self] (action, view , completionHandler)  in

                    if let strongSelf = self {
                        strongSelf.setPinnedFlightAt(flightKey , isPinned:  true)
                    }
                    completionHandler(true)
                })

                pinAction.backgroundColor = .white
                if let cgImageX =  UIImage(named: "Pin")?.cgImage {
                    pinAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
                }

                return [pinAction]

            }
        }
    }
    
    fileprivate func createSwipeActionForPinnedFlightLeftOrientation(_ indexPath: IndexPath) -> [UIContextualAction] {
        
//        let journeyArray = results.pinnedFlights
        let journeyArray = pinnedFlightsArray
        let journey = journeyArray[indexPath.row]
        let flightKey = journey.fk

        if journey.isPinned ?? false {

            let pinAction = UIContextualAction(style: .normal, title: nil , handler: { [weak self] (action, view , completionHandler)  in

                if let strongSelf = self {
                    strongSelf.setPinnedFlightAt(flightKey , isPinned:  false)
                }
                completionHandler(true)
            })
            pinAction.backgroundColor = .white
            if let cgImageX =  UIImage(named: "Unpin")?.cgImage {
                pinAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
            }

            return [pinAction]

        }
        else {

            let pinAction = UIContextualAction(style: .normal, title: nil , handler: { [weak self] (action, view , completionHandler)  in

                if let strongSelf = self {
                    strongSelf.setPinnedFlightAt(flightKey , isPinned:  true)
                }
                completionHandler(true)
            })

            pinAction.backgroundColor = .white
            if let cgImageX =  UIImage(named: "Pin")?.cgImage {
                pinAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
            }

            return [pinAction]

        }
    }
    
    fileprivate func createSwipeActionsForRightOrientation(_ indexPath: IndexPath) -> [UIContextualAction] {
        let shareAction = UIContextualAction(style: .normal, title: nil , handler: { [weak self] (action, view , completionHandler) in
            completionHandler(true)

            if let strongSelf = self {
                strongSelf.shareFlightAt(indexPath)
            }
            completionHandler(true)

        })

        if let cgImageX =  UIImage(named: "Share")?.cgImage {
            shareAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
        }
        shareAction.backgroundColor =  .white
        
        let addToTripAction = UIContextualAction(style: .normal, title: nil, handler: { [weak self]  (action, view , completionHandler)  in

            if let strongSelf = self {
                strongSelf.addToTripFlightAt(indexPath)
            }
            completionHandler(true)
        })
        addToTripAction.backgroundColor = .white

        if let cgImageX =  UIImage(named: "AddToTrip")?.cgImage {
            addToTripAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
        }

        return [addToTripAction, shareAction]
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        if (tableView.cellForRow(at: indexPath) as? SingleJourneyResultTableViewCell) != nil {

            let configuration : UISwipeActionsConfiguration

            if resultTableState == .showPinnedFlights {
                configuration = UISwipeActionsConfiguration(actions: createSwipeActionForPinnedFlightLeftOrientation(indexPath))
            }
            else {
                configuration = UISwipeActionsConfiguration(actions: createSwipeActionForLeftOrientation(indexPath))
            }
            return configuration
        }

        let configuration = UISwipeActionsConfiguration(actions: [])
        return configuration
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        if (tableView.cellForRow(at: indexPath) as? SingleJourneyResultTableViewCell) != nil {

            let configuration = UISwipeActionsConfiguration(actions: createSwipeActionsForRightOrientation(indexPath))
            return configuration
        }
        let configuration = UISwipeActionsConfiguration(actions: [])
        return configuration

    }
    
    //MARK:- Methods for naviagating to other View Controller


    
    func navigateToFlightDetailFor(journey : Journey, selectedIndex:IndexPath)
    {
        let storyboard = UIStoryboard(name: "FlightDetailsBaseVC", bundle: nil)
        let flightDetailsVC:FlightDetailsBaseVC =
            storyboard.instantiateViewController(withIdentifier: "FlightDetailsBaseVC") as! FlightDetailsBaseVC
        
        flightDetailsVC.delegate = self
        flightDetailsVC.bookFlightObject = self.bookFlightObject
        flightDetailsVC.taxesResult = self.taxesResult
        flightDetailsVC.sid = sid
        flightDetailsVC.selectedIndex = selectedIndex
        flightDetailsVC.journey = [journey]
        flightDetailsVC.titleString = titleString
        flightDetailsVC.airportDetailsResult = airportDetailsResult
        flightDetailsVC.airlineDetailsResult = airlineDetailsResult
        flightDetailsVC.selectedJourneyFK = [journey.fk]
        self.present(flightDetailsVC, animated: true, completion: nil)
    }
    
    
    
    //MARK:- Sharing Journey
    fileprivate func executeWebServiceForShare(with postData: Data , onCompletion:@escaping (String) -> ()) {
        let webservice = WebAPIService()
        
        webservice.executeAPI(apiServive: .getShareUrl(postData: postData ) , completionHandler: {    (data) in
            
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase

          if let currentParsedResponse = parse(data: data, into: getPinnedURLResponse.self, with:decoder) {
              let data = currentParsedResponse.data
              if let link = data["u"] {
                  onCompletion(link)
              }
          }
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    fileprivate func executeWebServiceForEmail(with postData: Data , onCompletion:@escaping (String) -> ()) {
        let webservice = WebAPIService()
        
        webservice.executeAPI(apiServive: .getEmailUrl(postData: postData ) , completionHandler: {    (receivedData) in
  
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase

          if let currentParsedResponse = parse(data: receivedData, into: getPinnedURLResponse.self, with:decoder) {
              let data = currentParsedResponse.data
              if let view = data["view"] {
                onCompletion(view)
              }
          }
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    func generatePostDataForEmail( for journey : [Journey] ) -> Data? {
        
        let flightAdultCount = bookFlightObject.flightAdultCount
         let flightChildrenCount = bookFlightObject.flightChildrenCount
         let flightInfantCount = bookFlightObject.flightInfantCount
         let isDomestic = bookFlightObject.isDomestic
         
        guard let firstJourney = journey.first else { return nil}
        
         let cc = firstJourney.cc
         let ap = firstJourney.ap
         
         let trip_type = "single"
         
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let departDate = inputFormatter.string(from: bookFlightObject.onwardDate)
         
        var valueString = "https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(flightAdultCount)&child=\(flightChildrenCount)&infant=\(flightInfantCount)&origin=\(ap[0])&destination=\(ap[1])&depart=\(departDate)&cabinclass=\(cc)&pType=flight&isDomestic=\(isDomestic)"
        
        
        for i in 0 ..< journey.count {
            let tempJourney = journey[i]
            valueString = valueString + "&PF[\(i)]=\(tempJourney.fk)"
        }

        var parameters = [ "u": valueString , "sid": bookFlightObject.sid ]
     
        
        let fkArray = journey.map{ $0.fk }
        
        for i in 0 ..< fkArray.count {
            let key = "fk%5B\(i)%5D"
            parameters[key] = fkArray[i]
        }
        
        
        let parameterArray = parameters.map { (arg) -> String in
          let (key, value) = arg
         
        let percentEscapeString = self.percentEscapeString(value!)
          return "\(key)=\(percentEscapeString)"
        }
        
        let data = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
        return data
    }
        
    func percentEscapeString(_ string: String) -> String {
      var characterSet = CharacterSet.alphanumerics
      characterSet.insert(charactersIn: "-._* ")
      
      return string
        .addingPercentEncoding(withAllowedCharacters: characterSet)!
        .replacingOccurrences(of: " ", with: "+")
        .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    func generatePostData( for journey : [Journey] ) -> NSData? {
        
        
        let flightAdultCount = bookFlightObject.flightAdultCount
        let flightChildrenCount = bookFlightObject.flightChildrenCount
        let flightInfantCount = bookFlightObject.flightInfantCount
        let isDomestic = bookFlightObject.isDomestic
        
        guard let firstJourney = journey.first else { return nil}
        
        let cc = firstJourney.cc
        let ap = firstJourney.ap
        
        let trip_type = "single"
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let departDate = inputFormatter.string(from: bookFlightObject.onwardDate)
         
        let postData = NSMutableData()
        
        var valueString = "https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(flightAdultCount)&child=\(flightChildrenCount)&infant=\(flightInfantCount)&origin=\(ap[0])&destination=\(ap[1])&depart=\(departDate)&cabinclass=\(cc)&pType=flight&isDomestic=\(isDomestic)"
        
        for i in 0 ..< journey.count {
            let tempJourney = journey[i]
            valueString = valueString + "&PF[\(i)]=\(tempJourney.fk)"
        }
        
         let parameters = [
             [
                 "name": "u",
                 "value": valueString
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
         
         
         guard let bodyData = body.data(using: String.Encoding.utf8) else { return nil }
         postData.append(bodyData)
        
        return postData
    }
    
    func shareJourney(journey : Journey) {
         
        guard let postData = generatePostData(for: [journey]) else { return }
        
        executeWebServiceForShare(with: postData as Data, onCompletion:{ (link)  in
            
            DispatchQueue.main.async {
                let textToShare = [ link ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        })
    }
}

//MARK:- Tableview DataSource , Delegate Methods
extension FlightResultSingleJourneyVC : UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch resultTableState {
        case .showPinnedFlights, .showTemplateResults , .showNoResults:
            return 1
        case .showExpensiveFlights :
            
            if sortOrder == .Smart || sortOrder == .Price || sortOrder == .PriceHighToLow{
                return 2
            }
            else {
                return 1
            }
        case .showRegularResults :
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultTableState == .showTemplateResults {
            return 6
        }
        
        if resultTableState == .showPinnedFlights {
//            return results.pinnedFlights.count
            return pinnedFlightsArray.count
        }
        
        if resultTableState == .showExpensiveFlights
        {
            if sortOrder == .Smart || sortOrder == .Price || sortOrder == .PriceHighToLow{
                if section == 0 {
                    return results.suggestedJourneyArray.count
                }
                if section == 1 {
                    return results.expensiveJourneyArray.count
                }
            }else {
                return results.journeyArray.count
            }
        }else {
            if sortOrder == .Smart || sortOrder == .Price || sortOrder == .PriceHighToLow {
                return results.suggestedJourneyArray.count
            }
              else {
                return results.belowThresholdHumanScore
            }
        }
        
        assertionFailure("Execution in invalid state for table row count")
        return -1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if resultTableState == .showTemplateResults {
            return getTemplateCell()
        }
        
        if resultTableState == .showPinnedFlights {
//            let journey = results.pinnedFlights[indexPath.row]
            let journey = pinnedFlightsArray[indexPath.row]
            return getSingleJourneyCell(indexPath: indexPath ,journey: journey )
        }
        
        if sortOrder == .Smart || sortOrder == .Price || sortOrder == .PriceHighToLow {
            var arrayForDisplay = results.suggestedJourneyArray
            
            if resultTableState == .showExpensiveFlights && indexPath.section == 1 {
                arrayForDisplay = results.expensiveJourneyArray
            }
            
            if arrayForDisplay!.count > 0{
                if indexPath.row < arrayForDisplay!.count{
                    if let journey = arrayForDisplay?[indexPath.row]  {
                        
                        if journey.cellType == .singleJourneyCell {
                            return getSingleJourneyCell(indexPath: indexPath ,journey: journey.first )
                        }
                        else {
                            return getGroupedFlightCell(indexPath: indexPath, journey: journey)
                        }
                    }
                }
            }
        } else {
            let currentJourney =  self.sortedArray[indexPath.row]
            return getSingleJourneyCell(indexPath: indexPath ,journey: currentJourney)
        }
        
        assertionFailure("Failed to load appropriate cell , please check cell registration ")
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if resultTableState == .showTemplateResults {
            return
        }
        
        if (tableView.cellForRow(at: indexPath) as? SingleJourneyResultTableViewCell) != nil {
            
            if resultTableState == .showPinnedFlights {
//                let journeyArray = self.results.pinnedFlights
                let journeyArray = pinnedFlightsArray
                let currentJourney = journeyArray[indexPath.row]
                navigateToFlightDetailFor(journey: currentJourney, selectedIndex: indexPath)
                return
            }
            
            if sortOrder == .Smart || sortOrder == .Price || sortOrder == .PriceHighToLow {
                var arrayForDisplay = results.suggestedJourneyArray
                
                if resultTableState == .showExpensiveFlights && indexPath.section == 1 {
                    arrayForDisplay = results.expensiveJourneyArray
                }
                
                if let journey = arrayForDisplay?[indexPath.row]  {
                    navigateToFlightDetailFor(journey:  journey.first, selectedIndex: indexPath)
                }
            }else {
                let currentJourney =  self.sortedArray[indexPath.row]
                navigateToFlightDetailFor(journey: currentJourney, selectedIndex: indexPath)
            }
        }
    }
}

@available(iOS 13.0, *) extension FlightResultSingleJourneyVC : UIContextMenuInteractionDelegate
{
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
              
            var fk : String?
            var isPinned = false
            let locationInTableView = interaction.location(in: self.resultsTableView)
            var currentJourney  : Journey?

            if let indexPath = self.resultsTableView.indexPathForRow(at: locationInTableView) {
                
                if self.resultTableState == .showPinnedFlights {
//                    let journeyArray = self.results.pinnedFlights
                    let journeyArray = self.pinnedFlightsArray
                    currentJourney = journeyArray[indexPath.row]
                    fk = currentJourney?.fk
                }else{
                    if self.sortOrder == .Smart || self.sortOrder == .Price || self.sortOrder == .PriceHighToLow {
                        var arrayForDisplay = self.results.suggestedJourneyArray
                        
                        if self.resultTableState == .showExpensiveFlights && indexPath.section == 1 {
                            arrayForDisplay = self.results.expensiveJourneyArray
                        }
                        
                        if let journey = arrayForDisplay?[indexPath.row].first {
                            fk = journey.fk
                            if let journeyIsPinned = journey.isPinned {
                                isPinned = !journeyIsPinned
                            }
                            currentJourney = journey
                        }
                    }else{
                        let journey =  self.sortedArray[indexPath.row]
                        fk = journey.fk
                        if let journeyIsPinned = journey.isPinned {
                            isPinned = !journeyIsPinned
                        }
                        currentJourney = journey
                    }
                }
            }
            return self.makeMenusFor(journey : currentJourney ,fk : fk , markPinned : isPinned)
        }
    }
    
    func makeMenusFor(journey : Journey? ,  fk: String? , markPinned : Bool) -> UIMenu
    {
        if let currentJourney = journey {
            let pinTitle : String
            if markPinned {
                pinTitle = "Pin"
            }
            else {
                pinTitle = "Unpin"
            }
            
            let pin = UIAction(title:  pinTitle , image: UIImage(systemName: "pin" ), identifier: nil) { (action) in
                guard let flightKey = fk else {
                    return
                }
                self.setPinnedFlightAt(flightKey, isPinned: markPinned)
            }
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil) {[weak self] (action) in
                
                guard let strongSelf = self else { return }
                guard let strongJourney = journey else { return }
                strongSelf.shareJourney(journey: strongJourney)
                
            }
            let addToTrip = UIAction(title: "Add To Trip", image: UIImage(systemName: "map" ), identifier: nil) { (action) in
                
                self.addToTrip(journey: currentJourney)
            }
            
            // Create and return a UIMenu with all of the actions as children
            return UIMenu(title: "", children: [pin, share, addToTrip])
        }
        
        return UIMenu(title: "", children: [])
    }
}
