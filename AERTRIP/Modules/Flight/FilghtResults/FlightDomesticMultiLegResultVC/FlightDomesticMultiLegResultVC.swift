//
//  FlightDomesticMultiLegResultVC.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit
import SnapKit

class FlightDomesticMultiLegResultVC: UIViewController {

    //MARK:- Outlets
    var bannerView : ResultHeaderView?
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var showPinnedSwitch: AertripSwitch!
    @IBOutlet weak var unpinnedAllButton: UIButton!
    @IBOutlet weak var emailPinnedFlights: UIButton!
    @IBOutlet weak var sharePinnedFilghts: UIButton!
    
    //MARK:- NSLayoutConstraints
    @IBOutlet weak var pinnedFlightOptionsTop: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var baseScrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var headerCollectionViewTop: NSLayoutConstraint!
    
    //MARK:- State Properties
    var resultsTableViewStates =  [ResultTableViewState]()
    var showPinnedFlights = false
    var numberOfLegs : Int
    var results = [DomesticMultilegJourneyResultsArray]()
    var journeyHeaderViewArray = [JourneyHeaderView]()
    var headerArray : [MultiLegHeader]
    
    var taxesResult : [String : String]!
    var airportDetailsResult : [String : AirportDetailsWS]!
    var airlineDetailsResult : [String : AirlineMasterWS]!

    var flightsResults  =  FlightsResults()
    var sid : String = ""
    var bookFlightObject = BookFlightObject()

    var titleString : NSAttributedString!
    var subtitleString : String!

    var selectedJourneyArray : [Journey]!
    var fareBreakupVC : FareBreakupVC?
    let journeyCompactViewHeight : CGFloat = 44.0
    var scrollviewInitialYOffset = CGFloat(0.0)
    // Initializers
    
     convenience init(numberOfLegs  : Int , headerArray : [MultiLegHeader] ) {
        self.init(nibName:nil, bundle:nil)
        self.numberOfLegs = numberOfLegs
        self.headerArray = headerArray
        results = Array(repeating: DomesticMultilegJourneyResultsArray(), count: numberOfLegs)
        resultsTableViewStates =  Array(repeating: .showTemplateResults , count: numberOfLegs)

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.numberOfLegs = 0
        self.headerArray = [MultiLegHeader]()
        results = Array(repeating: DomesticMultilegJourneyResultsArray(), count: 0)
        resultsTableViewStates =  Array(repeating: .showTemplateResults , count: 0)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.numberOfLegs = 0
        self.headerArray = [MultiLegHeader]()
        results = Array(repeating: DomesticMultilegJourneyResultsArray(), count: 0)
        resultsTableViewStates =  Array(repeating: .showTemplateResults , count: 0)

        super.init(coder: aDecoder)
    }
    
    
    //MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupHeaderView()
        setupScrollView()
        setupPinnedFlightsOptionsView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width =  UIScreen.main.bounds.size.width / 2.0
        let height = self.baseScrollView.frame.height
        baseScrollView.contentSize = CGSize( width: (CGFloat(numberOfLegs) * width ), height:height)

        for view in self.baseScrollView.subviews
        {
            if view is JourneyHeaderView {
                continue
            }
            
            var frame = view.frame
            frame.size.height = height
            view.frame = frame
        }
    }

    //MARK:- Additional UI Methods
    func setupHeaderView() {
        let rect = CGRect(x: 0, y: self.headerCollectionViewTop.constant , width: UIScreen.main.bounds.size.width, height: 156)
        self.bannerView = ResultHeaderView(frame: rect)
        self.bannerView?.frame = rect
        self.view.addSubview(self.bannerView!)
    }
    
    fileprivate func animateTableHeader(index : Int , updatedArray : [Journey] , sortOrder :Sort)  {
        if bannerView?.isHidden == false {
            guard let headerView = bannerView  else { return }

            let rect = headerView.frame
            baseScrollViewTop.constant = 0

            UIView.animate(withDuration: 1.0 , animations: {
                let y = rect.origin.y - rect.size.height - 20
                headerView.frame = CGRect(x: 0, y: y , width: UIScreen.main.bounds.size.width, height: 156)
                self.view.layoutIfNeeded()

            }) { (bool) in

                self.bannerView?.isHidden = true
                self.updateUI(index: index, updatedArray : updatedArray, sortOrder: sortOrder)
            }
        }
        else {
            self.updateUI(index: index , updatedArray: updatedArray, sortOrder: sortOrder)
        }
        
    }
    
    
    func updateUI(index : Int , updatedArray : [Journey] , sortOrder : Sort) {
    
        let currentState =  resultsTableViewStates[index]
        if currentState == .showTemplateResults || currentState == .showNoResults {
            if updatedArray.count == 0 {
                return
            }
            resultsTableViewStates[index] = .showRegularResults
        }

        results[index].journeyArray = updatedArray

        DispatchQueue.main.async {
            
            if let errorView = self.baseScrollView.viewWithTag( 500 + index) {
                
                if updatedArray.count > 0 {
                    errorView.removeFromSuperview()
                }
            }
        
            if let tableView = self.baseScrollView.viewWithTag( 1000 + index) as? UITableView {
                tableView.reloadData()
                let width = UIScreen.main.bounds.size.width / 2.0
                let headerRect = CGRect(x: 0, y: 0, width: width, height: 138.0)
                tableView.tableHeaderView = UIView(frame: headerRect)
                 
                let indexPath : IndexPath
                if (self.results[index].suggestedJourneyArray.count > 0 ) {
                    indexPath = IndexPath(row: 0, section: 0)
                    tableView.selectRow(at: indexPath , animated: false, scrollPosition: .none)
                    self.hideHeaderCellAt(index: index)
                }
                else if (self.results[index].expensiveJourneyArray.count > 0 ){
                    indexPath = IndexPath(row: 0, section: 1)
                    tableView.selectRow(at: indexPath , animated: false, scrollPosition: .none)
                    self.hideHeaderCellAt(index: index)
                }
                tableView.isScrollEnabled = true
            }
            
            if self.resultsTableViewStates[index] == .showExpensiveFlights {
                self.setExpandedStateFooterAt(index: index)
            }
            else {
                self.setGroupedFooterViewAt(index: index)
            }
            

            self.setTotalFare()
            self.checkForOverlappingFlights()
        }
        
        
    }
    
    
    func ShowBottomView() {
        
        DispatchQueue.main.async {
            if self.fareBreakupVC == nil {
            
                let bottomInset = self.view.safeAreaInsets.bottom
                self.scrollViewBottomConstraint.constant = 50 + bottomInset
                self.setupBottomView()
            }

            self.fareBreakupVC?.journey = self.getSelectedJourneyForAllLegs()
            self.fareBreakupVC?.taxesDataDisplay()
            self.fareBreakupVC?.initialDisplayView()
            let bottomInset = ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!)
            self.fareBreakupVC?.view.frame = CGRect(x: 0, y: self.view.frame.height-50-bottomInset, width: self.view.frame.width, height:50+CGFloat(bottomInset))
            self.fareBreakupVC?.view.isHidden = false
        }
    }
    
    func hideBottomView() {
        DispatchQueue.main.async {
            self.scrollViewBottomConstraint.constant = 0.0
            guard var rect = self.fareBreakupVC?.view.frame else { return }
            rect.origin.y =  self.view.frame.height
            self.fareBreakupVC?.view.frame = rect
            self.fareBreakupVC?.view.isHidden = true
        }
    }
    
    func setupPinnedFlightsOptionsView() {
        
        pinnedFlightOptionsTop.constant = 0
        
        
        showPinnedSwitch.tintColor = UIColor.TWO_ZERO_FOUR_COLOR
        showPinnedSwitch.isOn = false
        showPinnedSwitch.setupUI()
        
        hidePinnedFlightOptions(true)
        addShadowTo(unpinnedAllButton)
        addShadowTo(emailPinnedFlights)
        addShadowTo(sharePinnedFilghts)
        
    }
    
    
    func addShadowTo(_ view : UIView) {
        
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
    }

    
    fileprivate func hidePinnedFlightOptions( _ hide : Bool) {
        
        let opacity : CGFloat =  hide ? 0.0 : 1.0
        UIView.animate(withDuration: 0.5, delay: 0.0 ,
                       options: UIView.AnimationOptions.curveEaseOut
            , animations: {
                
                self.emailPinnedFlights.alpha = opacity
                self.unpinnedAllButton.alpha = opacity
                self.sharePinnedFilghts.alpha = opacity
                
        }) { (onCompletion) in
            
            self.emailPinnedFlights.isHidden = hide
            self.unpinnedAllButton.isHidden = hide
            self.sharePinnedFilghts.isHidden = hide
        }
    }
    
    func setupBottomView() {
        
        let bottomInset = ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!)

        let fareBreakupVC = FareBreakupVC(nibName: "FareBreakupVC", bundle: nil)
        fareBreakupVC.taxesResult = taxesResult
        fareBreakupVC.journey = getSelectedJourneyForAllLegs()
        fareBreakupVC.sid = sid
        fareBreakupVC.flightAdultCount = bookFlightObject.flightAdultCount
        fareBreakupVC.flightChildrenCount = bookFlightObject.flightChildrenCount
        fareBreakupVC.flightInfantCount = bookFlightObject.flightInfantCount
        fareBreakupVC.view.autoresizingMask = []
        fareBreakupVC.view.frame = CGRect(x: 0, y: self.view.frame.height-50-bottomInset, width: self.view.frame.width, height:50+CGFloat(bottomInset))
        fareBreakupVC.delegate = self
        fareBreakupVC.view.tag = 2500
        self.view.addSubview(fareBreakupVC.view)
        self.addChild(fareBreakupVC)
        fareBreakupVC.didMove(toParent: self)

        self.fareBreakupVC = fareBreakupVC
    }
    

    func setupScrollView() {
        
        let width =  UIScreen.main.bounds.size.width / 2.0
        let height = self.baseScrollView.frame.height
        baseScrollView.contentSize = CGSize( width: (CGFloat(numberOfLegs) * width ), height:height)
        baseScrollView.showsHorizontalScrollIndicator = false
        baseScrollView.showsVerticalScrollIndicator = false
        baseScrollView.delegate = self
        for i in 0 ..< numberOfLegs {
            
            setupTableView(At: i)
        }
        
    }
    
    
    func setupTableView(At index : Int) {
        
        let width = UIScreen.main.bounds.width / 2.0
        let height = UIScreen.main.bounds.height
        let rect = CGRect(x: (width * CGFloat(index)), y: 0, width: width, height: height)
        
        
        let tableView = UITableView(frame: rect)
        tableView.dataSource = self
        tableView.tag = 1000 + index
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        tableView.isScrollEnabled = false
        tableView.scrollsToTop = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "DomesticMultiLegCell", bundle: nil), forCellReuseIdentifier: "DomesticMultiLegCell")
        tableView.register(UINib(nibName: "DomesticMultiLegTemplateCell", bundle: nil), forCellReuseIdentifier: "DomesticMultiLegTemplateCell")


        let headerRect = CGRect(x: 0, y: 0, width: width, height: 138.0)
        tableView.tableHeaderView = UIView(frame: headerRect)
        
        let boarderRect = CGRect(x: ((width * CGFloat(index + 1)) - 1), y: 0, width: 0.5, height: height)
        let borderView = UIView(frame: boarderRect)
        borderView.backgroundColor = .TWO_ZERO_FOUR_COLOR
      
        baseScrollView.addSubview(tableView)
        baseScrollView.addSubview(borderView)
        
        setupCompactJourneyView(width, index)
    }
    func setupCollectionView() {
        
        headerCollectionView.register( UINib(nibName: "FlightSectorHeaderCell", bundle: nil), forCellWithReuseIdentifier: "HeaderCollectionView")
        headerCollectionView.bounces = false
    }
    
    
    func showPinnedFlightsOption(_ show  : Bool) {
        
        let offsetFromBottom = show ? 60.0 : 0
        self.pinnedFlightOptionsTop.constant = CGFloat(offsetFromBottom)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    fileprivate func hideNavigationBar(_ hide : Bool) {
        UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.navigationController?.setNavigationBarHidden(hide, animated: true)
            
        }, completion: nil)
    }
    
    
    fileprivate func setTotalFare() {
        if let selectedJourneys = self.getSelectedJourneyForAllLegs() {
            
            if selectedJourneys.count == numberOfLegs {
                ShowBottomView()
            }
        }
        else {
            hideBottomView()
        }
    }
    
    func updateReceivedAt(index : Int , updatedArray : [Journey] , sortOrder : Sort) {
        animateTableHeader(index: index , updatedArray: updatedArray, sortOrder: sortOrder)
    }
    

    func showNoResultScreenAt(index: Int) {
        addErrorScreenAtIndex(index: index, forFilteredResults: false)
    }
    
    
    func showNoFilteredResults(index: Int) {
        addErrorScreenAtIndex(index: index, forFilteredResults: true)
    }
    
    func addErrorScreenAtIndex(index: Int , forFilteredResults: Bool ) {
        

        if let tableview = baseScrollView.viewWithTag(1000 + index) as? UITableView {
         
            resultsTableViewStates[index] = .showNoResults
            tableview.tableFooterView = nil
            tableview.reloadData()
        }
        let noResultsView : NoResultScreenView
        if let errorView = baseScrollView.viewWithTag( 500 + index) as? NoResultScreenView {
            noResultsView = errorView
            baseScrollView.addSubview(noResultsView)
        }
        else {
            var rect = CGRect()
            let width = UIScreen.main.bounds.size.width / 2.0
            
            let headerCollectionviewHeight = headerCollectionView.frame.size.height
            rect.origin.x = CGFloat(index) * width + 1.0
            rect.origin.y = self.headerCollectionViewTop.constant + headerCollectionviewHeight
            rect.size.height = baseScrollView.bounds.size.height - 50
            rect.size.width = width - 2.0
            
            noResultsView = NoResultScreenView(frame: rect)
            noResultsView.delegate = self.parent as? NoResultScreenDelegate
            noResultsView.frame = rect
            noResultsView.tag = ( 500 + index)
            baseScrollView.addSubview(noResultsView)
        }
        
        
        if forFilteredResults {
            noResultsView.showNoFilteredResults()
        }
        else {
            noResultsView.showNoResultsMode()
        }
    }
    
    func showHintAnimation() {
        
        if numberOfLegs > 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let point = CGPoint(x: 30 , y: 0)
                self.baseScrollView.setContentOffset(point , animated: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                  let point  = CGPoint(x: 0 , y: 0)
                 self.baseScrollView.setContentOffset(point , animated: true)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                  let point  = CGPoint(x: 30 , y: 0)
                 self.baseScrollView.setContentOffset(point , animated: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                  let point  = CGPoint(x: 0 , y: 0)
                 self.baseScrollView.setContentOffset(point , animated: true)
            }
        }
    }
    
    //MARK:- CompactJourneyView Implementation
    fileprivate func setupCompactJourneyView(_ width: CGFloat, _ index: Int) {
        
        let headerJourneyRect  = CGRect(x: (width * CGFloat(index)), y: (-journeyCompactViewHeight) , width: width - 1 , height: journeyCompactViewHeight)
        let headerJourneyView = JourneyHeaderView(frame: headerJourneyRect)
        headerJourneyView.tag = 1000 + index
        journeyHeaderViewArray.append(headerJourneyView)

        baseScrollView.addSubview(headerJourneyView)
        headerJourneyView.isHidden = true
        hideHeaderCellAt(index: index)
    }
    
    func showHideJourneyCompactView(for tableView : UITableView) {
        
        guard let selectedRowIndex = tableView.indexPathForSelectedRow else { return }
        var visibleRect = tableView.bounds
        visibleRect.origin.y = visibleRect.origin.y + self.headerCollectionViewTop.constant + 6.0
        visibleRect.size.height =  visibleRect.size.height
        

        let selectedRowRect = tableView.rectForRow(at: selectedRowIndex)
        
        if visibleRect.contains(selectedRowRect) {
            let index = tableView.tag - 1000
            hideHeaderCellAt(index: index)
        }
        else {
            showHeaderCellAt(indexPath: selectedRowIndex , tableView: tableView)
        }
    }
    
    
    func showHeaderCellAt(indexPath : IndexPath, tableView : UITableView) {
        
        let index = tableView.tag - 1000
        let headerView = journeyHeaderViewArray[index]
        
        if headerView.isHidden {
            headerView.isHidden = false
        
            let width = UIScreen.main.bounds.size.width / 2.0

            
            if indexPath.section == 0 {
               
                let journey = results[index].suggestedJourneyArray[indexPath.row]
                headerView.setValuesFrom(journey: journey)
                selectedJourneyArray = [journey]
            }
            else {
                let journey = results[index].expensiveJourneyArray[indexPath.row]
                headerView.setValuesFrom(journey: journey)
                selectedJourneyArray = [journey]
            }
            
            let headerJourneyRect  = CGRect(x: (width * CGFloat(index)), y: (-journeyCompactViewHeight) , width: width - 1 , height: journeyCompactViewHeight)
            headerView.frame = headerJourneyRect
            
            
            UIView.animate(withDuration: 0.4) {
                var rect = headerView.frame
                rect.origin.y = self.headerCollectionViewTop.constant + 6 + self.journeyCompactViewHeight
                rect.size.height = self.journeyCompactViewHeight
                headerView.frame = rect
            }
        }
    }
    
    func hideHeaderCellAt(index : Int) {
        
        let headerView = journeyHeaderViewArray[index]
        
        if headerView.isHidden {
            return
        }
        
        if !headerView.isHidden {
            UIView.animate(withDuration: 0.4, animations: {
                
                var frame = headerView.frame
                frame.origin.y = (-self.journeyCompactViewHeight)
                headerView.frame = frame
                
            }) { (completed) in
                headerView.isHidden = true
                
                if let tableView = self.baseScrollView.viewWithTag( 1000 + index) as? UITableView {
                    let visibleCellsIndices = tableView.indexPathsForVisibleRows
                    let isFirstCellVisible = visibleCellsIndices?.contains(IndexPath(row: 0, section: 0)) ?? false
                    
                    if isFirstCellVisible {
                        tableView.setContentOffset(CGPoint(x: 0, y: 50) , animated: true)
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            let width = UIScreen.main.bounds.size.width / 2.0
//                            let rect = CGRect(x: 0, y: 0, width: width, height: 138.0)
//                            let tableHeaderView = UIView(frame: rect)
//                            tableView.tableHeaderView = tableHeaderView
//                        }
                    }
                }
            }
        }
    }
    
    func setLargerTableViewHeaderFor(tableView  : UITableView) {
        
        guard let selectedRowIndex = tableView.indexPathForSelectedRow else { return }
        var visibleRect = tableView.bounds
        visibleRect.origin.y = visibleRect.origin.y + self.headerCollectionViewTop.constant
        visibleRect.size.height =  visibleRect.size.height
        let selectedRowRect = tableView.rectForRow(at: selectedRowIndex)
        let visibleCellsIndices = tableView.indexPathsForVisibleRows
        let isFirstCellVisible = visibleCellsIndices?.contains(IndexPath(row: 0, section: 0)) ?? true
        
        if !isFirstCellVisible  && !visibleRect.contains(selectedRowRect) {

            let width = UIScreen.main.bounds.size.width / 2.0
            let rect = CGRect(x: 0, y: 0, width: width, height: 188.0 )
            let tableHeaderView = UIView(frame: rect)
            tableView.tableHeaderView = tableHeaderView
        }
    }
    //MARK:- Logical methods
    
    fileprivate func  getSelectedJourneyForAllLegs() -> [Journey]? {
        
        var selectedJourneys = [Journey]()
        
        for index in 0 ..< numberOfLegs {
            
            let tableResultState = resultsTableViewStates[index]
            if tableResultState == .showTemplateResults {  return nil }
            
            if let tableView = baseScrollView.viewWithTag( 1000 + index ) as? UITableView {
                
                guard let selectedIndex = tableView.indexPathForSelectedRow else { return nil }
                
                var currentJourney : Journey
                let currentArray : [Journey]
                switch tableResultState {
                case .showExpensiveFlights :
                    if selectedIndex.section == 1 {
                        currentArray = results[index].expensiveJourneyArray
                    }else {
                        currentArray = results[index].suggestedJourneyArray
                    }
                    
                    if selectedIndex.row < currentArray.count {
                        currentJourney = currentArray[selectedIndex.row]
                        selectedJourneys.append(currentJourney)
                    }
                    else {
                        return nil
                    }
                case .showPinnedFlights :
                    currentJourney = results[index].pinnedFlights[selectedIndex.row]
                    selectedJourneys.append(currentJourney)

                case .showRegularResults :
                    
                    let suggestedJourneyArray = results[index].suggestedJourneyArray
                    if suggestedJourneyArray?.count ?? 0 > 0 {
                        currentJourney = results[index].suggestedJourneyArray[selectedIndex.row]
                        selectedJourneys.append(currentJourney)
                    }
                    
                case .showTemplateResults :
                    assertionFailure("Invalid state")
                case .showNoResults:
                    return nil
                }
                
            }
        }
        if selectedJourneys.count == numberOfLegs {
            return selectedJourneys
        }
        return nil
    }
    
    
    fileprivate func setTextColorToHeader(_ color : UIColor) {
        for cell in headerCollectionView.visibleCells {
            
            if let headerCell = cell as? FlightSectorHeaderCell {
                headerCell.setTitleColor(color)
            }
        }
    }
    
    func checkForOverlappingFlights() {
        if let selectedJourneys = getSelectedJourneyForAllLegs() {
            
            if selectedJourneys.count >= 2 {
                
                for i in 0 ..< (selectedJourneys.count - 1) {
                    
                    let currentLegJourney = selectedJourneys[i]
                    let nextLegJourney = selectedJourneys[(i + 1)]
                    
                    guard let currentLegArrival = currentLegJourney.arrivalDate else { return }
                    guard let nextLegDeparture = nextLegJourney.departureDate else { return }
                    
                    if nextLegDeparture < currentLegArrival {
                        if let parentVC = self.parent {
                            AertripToastView.toast(in: parentVC.view , withText: "Flight timings are not compatible. Select a different flight.")
                            setTextColorToHeader(.AERTRIP_RED_COLOR)
                            fareBreakupVC?.bookButton.isEnabled = false
                            return
                        }
                    }
                    
                    if nextLegDeparture.timeIntervalSince(currentLegArrival) <= 7200 {
                        if let parentVC = self.parent {
                        AertripToastView.toast(in: parentVC.view , withText: "Selected flights have less than 2 hrs of gap.")
                        }
                    }
                    fareBreakupVC?.bookButton.isEnabled = true
                    setTextColorToHeader(.black)
                    
                }
            }
        }
    }
    
    
    func formatted(fare : Int ) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        
        formatter.locale = Locale.init(identifier: "en_IN")
        return formatter.string(from: NSNumber(value: fare)) ?? ""

    }
    
    //MARK:- Target  methods
    @IBAction func PinnedFlightSwitchTogged(_ sender: AertripSwitch) {
        
//        showPinnedFlights = sender.isOn
//
//        hidePinnedFlightOptions(!sender.isOn)
//        hideNavigationBar(false)
//
//        if sender.isOn {
//
////            resultsTableView.tableFooterView = nil
//        }
//        else {
//            showFooterView()
//        }
//        resultsTableView.reloadData()
//        resultsTableView.scrollToRow(at: IndexPath(row: 0, section: 0) , at: .top, animated: true)
        
    }
    
    @IBAction func unpinnedAllTapped(_ sender: Any) {
        
//        for i in 0 ..< journeyArray.count {
//
//            let journeyGroup = journeyArray[i]
//            journeyGroup.journeyArray = journeyGroup.journeyArray.map{
//                let journey = $0
//                journey.isPinned = false
//                return journey
//            }
//
//            journeyArray[i] = journeyGroup
//        }
        
        showPinnedSwitch.isOn = false
        showPinnedFlights = false
        
        showPinnedFlightsOption(false)
//        resultsTableView.reloadData()
//        resultsTableView.scrollToRow(at: IndexPath(row: 0, section: 0) , at: .top, animated: true)
        hideNavigationBar(false)
    }
    
    @IBAction func emailPinnedFlights(_ sender: Any) {
    }
    
    
    
    @IBAction func sharePinnedFlights(_ sender: Any) {
    }
    
    
    
    //MARK:- Tableview Footer View
    
    func showFooterViewAt(index : Int) {
        
        if resultsTableViewStates[index] == .showExpensiveFlights {
            setExpandedStateFooterAt(index: index)
        }
        else {
            setGroupedFooterViewAt(index: index)
        }
    }
    
    func setGroupedFooterViewAt(index : Int) {
        
        let aboveHumanScoreCount = results[index].aboveHumanScoreCount
        
        if let tableView = baseScrollView.viewWithTag( 1000 + index) as? UITableView {
            
            if aboveHumanScoreCount == 0 {
                tableView.tableFooterView = nil
                return
            }
            
            var numberOfView = 0
            
            switch  aboveHumanScoreCount {
            case 1:
                numberOfView = 1
            case 2 :
                numberOfView = 2
            default:
                numberOfView = 3
            }
            
            let height = 44.0 + 35.0 + CGFloat(numberOfView - 1) * 16.0
            
            let groupedFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: height))
            groupedFooterView.isUserInteractionEnabled = true
            groupedFooterView.tag = index
            let  tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnGroupedFooterView(_:)))
            tapGesture.numberOfTapsRequired = 1
            groupedFooterView.addGestureRecognizer(tapGesture)
            
            for count in 1...numberOfView {
                
                let baseView = createRepeatedFooterBaseView(for: tableView)
                baseView.frame = CGRect(x: (8 * count) ,y: (10 + 6 * count) ,width: (Int(groupedFooterView.frame.width) - (16 * count))  ,height:60)
                groupedFooterView.addSubview(baseView)
                groupedFooterView.sendSubviewToBack(baseView)
            }
            
            let titleLabel = UILabel(frame: CGRect(x:8,y: 16 ,width:groupedFooterView.frame.width - 16  ,height:60))
            titleLabel.textColor = UIColor.AertripColor
            titleLabel.numberOfLines = 0
            titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 14.0)
            titleLabel.textAlignment = .center
            
            if aboveHumanScoreCount == 1 {
                titleLabel.text  = "Show 1 longer or more expensive flight"
            }else {
                titleLabel.text  = "Show " + String(aboveHumanScoreCount) + " longer or more expensive flights"
            }
            
            groupedFooterView.addSubview(titleLabel)
            tableView.tableFooterView = groupedFooterView
            
        }
        
    }
    
    @objc func tappedOnGroupedFooterView(_ sender : UITapGestureRecognizer) {
        
        if let index = sender.view?.tag {
            resultsTableViewStates[index] = .showExpensiveFlights
            if let tableView = baseScrollView.viewWithTag( 1000 + index) as? UITableView {
                tableView.reloadData()
                
                let indexPath : IndexPath
                if (self.results[index].suggestedJourneyArray.count == 0 ) {
                    indexPath = IndexPath(row: 0, section: 1)
                    tableView.selectRow(at: indexPath , animated: false, scrollPosition: .none)
                    ShowBottomView()
                }
                
            }
            setExpandedStateFooterAt(index: index)
        }
    }
    
    
    func setExpandedStateFooterAt(index: Int) {
        
        if let tableView = baseScrollView.viewWithTag( 1000 + index) as? UITableView {
        
        let aboveHumanScoreCount = results[index].aboveHumanScoreCount

        let expandedFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 96))
        expandedFooterView.isUserInteractionEnabled = true
        expandedFooterView.tag = index
            
        let  tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnExpandedFooterView(_:)))
        tapGesture.numberOfTapsRequired = 1
        expandedFooterView.addGestureRecognizer(tapGesture)

        let baseView = createRepeatedFooterBaseView(for: tableView)
        baseView.frame = CGRect(x: 8,y: 16 ,width:expandedFooterView.frame.width - 16  ,height:60)

        expandedFooterView.addSubview(baseView)

        let titleLabel = UILabel(frame: CGRect(x:8,y: 16 ,width:expandedFooterView.frame.width - 16  ,height:60))
        titleLabel.textColor = UIColor.AertripColor
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 14.0)
        titleLabel.textAlignment = .center
        titleLabel.text  = "Hide " + String(aboveHumanScoreCount) + " longer or more expensive flights"
        expandedFooterView.addSubview(titleLabel)
        tableView.tableFooterView = expandedFooterView
            
        }
    }
    
    
    func createRepeatedFooterBaseView(for view : UIView) -> UIView {
        let baseView = UIView(frame: CGRect(x: 0 , y: 0, width: view.frame.width, height: 60))
        baseView.backgroundColor = .white
        baseView.layer.cornerRadius = 5.0
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOpacity = 0.1
        baseView.layer.shadowRadius = 8.0
        baseView.layer.shadowOffset = CGSize(width: 0, height: 2)

        return baseView
    }
    
    
    @objc func tapOnExpandedFooterView(_ sender: UITapGestureRecognizer) {
        
        if let index = sender.view?.tag {
            
            resultsTableViewStates[index] = .showRegularResults
            if let tableView = baseScrollView.viewWithTag( 1000 + index) as? UITableView {
                
                tableView.deleteSections( IndexSet(integer: 1), with: .top)
                
                if let bounds = tableView.tableFooterView?.bounds {
                    let rect = tableView.convert( bounds, from: tableView.tableFooterView)
                    tableView.scrollRectToVisible(rect, animated: true)
                }
            }
            setGroupedFooterViewAt(index: index)
        }
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
    
}



//MARK:- Header CollectionView Method
extension FlightDomesticMultiLegResultVC : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfLegs
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionView", for: indexPath) as? FlightSectorHeaderCell {
            cell.setUI( headerArray[indexPath.row])
             return cell
        }
        return UICollectionViewCell()
        
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = UIScreen.main.bounds.size
        size.height = 50
        
        if numberOfLegs > 2 {
        
            if indexPath.row == 1 {
                size.width = size.width * 0.4
            }else {
                size.width = size.width * 0.5
            }
        }
        else {
           size.width = size.width * 0.5
        }
        return size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

//        let width = baseScrollView.frame.size.width / 2.0
//        let offset = CGFloat(indexPath.row ) * width
//        baseScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
    }
    
    
    
}

//MARK:- TableView Data source , Delegate Methods
extension  FlightDomesticMultiLegResultVC : UITableViewDataSource , UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let index = tableView.tag - 1000
        let tableState = resultsTableViewStates[index]

        switch tableState {
        case .showExpensiveFlights :
            return 2
        case .showPinnedFlights, .showTemplateResults, .showNoResults :
            return 1
        case .showRegularResults :
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let index = tableView.tag - 1000

        let tableState = resultsTableViewStates[index]
        
        switch tableState {
        case .showTemplateResults:
                return 10
        case .showPinnedFlights:
            return results[index].pinnedFlights.count
        case .showExpensiveFlights:
            if section == 0 {
                return results[index].suggestedJourneyArray.count
            }
            if section == 1 {
                return results[index].expensiveJourneyArray.count
            }
        case .showRegularResults :
            return results[index].suggestedJourneyArray.count
        case .showNoResults:
            return 0
        }
        
        return 0
        
    }
    
    fileprivate func setPropertiesToCellAt( index: Int, _ indexPath: IndexPath,  cell: DomesticMultiLegCell, _ tableView: UITableView) {
      
        let tableState = resultsTableViewStates[index]
        var arrayForDisplay = results[index].suggestedJourneyArray
        
        if tableState == .showExpensiveFlights && indexPath.section == 1 {
            arrayForDisplay = results[index].expensiveJourneyArray
        }
        
        if let journey = arrayForDisplay?[indexPath.row] {
            cell.showDetailsFrom(journey:  journey)
            if let logoArray = journey.airlineLogoArray {
                
                switch logoArray.count {
                case 1 :
                    cell.iconTwo.isHidden = true
                    cell.iconThree.isHidden = true
                    setImageto(tableView: tableView, imageView: cell.iconOne, url:logoArray[0] , index:  indexPath.row)
                case 2 :
                    cell.iconThree.isHidden = true
                    setImageto(tableView: tableView, imageView: cell.iconOne, url:logoArray[0] , index:  indexPath.row)
                    setImageto(tableView: tableView, imageView: cell.iconTwo, url:logoArray[1] , index:  indexPath.row)
                    
                case 3 :
                    setImageto(tableView: tableView, imageView: cell.iconOne, url:logoArray[0] , index:  indexPath.row)
                    setImageto(tableView: tableView, imageView: cell.iconTwo, url:logoArray[1] , index:  indexPath.row)
                    setImageto(tableView: tableView, imageView: cell.iconThree, url:logoArray[2] , index:  indexPath.row)
                default:
                    break
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = tableView.tag - 1000
        let tableState = resultsTableViewStates[index]

        if tableState == .showTemplateResults {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DomesticMultiLegTemplateCell") as? DomesticMultiLegTemplateCell{
            cell.selectionStyle = .none
            return cell
            }
        }
        else {
        
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DomesticMultiLegCell") as? DomesticMultiLegCell{
                cell.selectionStyle = .none
                setPropertiesToCellAt(index:index, indexPath, cell: cell, tableView)
                return cell
                }
            }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showHideJourneyCompactView(for: tableView)
        checkForOverlappingFlights()
        setTotalFare()
        
    }
    
    
    
    func setImageto(tableView: UITableView,  imageView : UIImageView , url : String , index : Int ) {
        if let image = tableView.resourceFor(urlPath: url , forView: index) {
            
            let resizedImage = image.resizeImage(24.0, opaque: false)
            imageView.contentMode = .scaleAspectFit
            imageView.image = resizedImage
        }
        
    }
    fileprivate func hideNavigationHeaderOnScroll(_ scrollView: UIScrollView) {
        
        return
        let visualEffectViewHeight =  CGFloat(108.0)
        
        let contentOffset = scrollView.contentOffset
        let offsetDifference = contentOffset.y - scrollviewInitialYOffset
        
        if offsetDifference > 0 {
            DispatchQueue.main.async {
                

                var yCordinate : CGFloat
                yCordinate = max (  -visualEffectViewHeight ,  -offsetDifference )
                yCordinate = min ( 0,  yCordinate)
                
                var yCordinateForHeaderView : CGFloat
                yCordinateForHeaderView = max (  0 , 88.0 - offsetDifference)
                yCordinateForHeaderView = min ( 88.0  ,  yCordinateForHeaderView)

                
                UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
                    
                    if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
                        var rect = blurEffectView.frame
                        rect.origin.y = yCordinate
//                        self.baseScrollViewTop.constant = yCoordinateForScrollView
                        self.headerCollectionViewTop.constant = yCordinateForHeaderView
                        blurEffectView.frame = rect
                    }
                } ,completion: nil)
            }
            
        }
        else {
                
                let invertedOffset = -offsetDifference / 2.0
              
                DispatchQueue.main.async {
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                        
                        if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
                            var rect = blurEffectView.frame
                            var yCordinate = rect.origin.y + invertedOffset
                            yCordinate = min ( 0,  yCordinate)
                            rect.origin.y = yCordinate
                            blurEffectView.frame = rect
                            
                            var yCordinateForHeaderView : CGFloat
                            yCordinateForHeaderView = 88.0
                            self.headerCollectionViewTop.constant = yCordinateForHeaderView
                        }
                    } ,completion: nil)
                }
            }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        scrollviewInitialYOffset = scrollView.contentOffset.y
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == baseScrollView {
            
            let contentOffsetPercentages  = scrollView.contentOffset.x / scrollView.contentSize.width
            let headerCollectionViewTargetOffset = contentOffsetPercentages * scrollView.contentSize.width
            let point = CGPoint(x: (headerCollectionViewTargetOffset) , y: 0)
            headerCollectionView.setContentOffset(point , animated: false)
            return
        }
        
        if scrollView == headerCollectionView {

            let contentOffsetPercentages  = scrollView.contentOffset.x / scrollView.contentSize.width

            let scollViewTargetOffset = contentOffsetPercentages * baseScrollView.contentSize.width
            let minOffset = max( 0 , scollViewTargetOffset)
            let maxOffset = min(baseScrollView.maxContentOffset.x, minOffset)
            let point = CGPoint(x: (maxOffset) , y: 0)
            baseScrollView.setContentOffset(point , animated: false)
            return
        }
        if scrollView.tag > 999 {
            
            hideNavigationHeaderOnScroll(scrollView)
            
            if let tableView = scrollView as? UITableView {
                showHideJourneyCompactView(for: tableView)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.tag > 999 {
            if let tableView = scrollView as? UITableView {
                setLargerTableViewHeaderFor(tableView: tableView)
            }
        }
    }
    
    
    
    func scrollToNearstLeg(scrollView: UIScrollView) {
        
        baseScrollView.decelerationRate = .fast
        let contenxtOffsetX = baseScrollView.contentOffset.x

        let legWidth = self.view.bounds.size.width / 2
        let currentIndex =  contenxtOffsetX / legWidth
        let offset = currentIndex.rounded(.toNearestOrAwayFromZero)
        let desiredOffsetX = CGFloat(offset) * legWidth

        let point = CGPoint(x: desiredOffsetX, y: 0.0)
        baseScrollView.setContentOffset(point, animated: false)
        
    }
    
}


extension FlightDomesticMultiLegResultVC : FareBreakupVCDelegate {
    func bookButtonTapped() {
        
                let storyboard = UIStoryboard(name: "FlightDetailsBaseVC", bundle: nil)
                let flightDetailsVC:FlightDetailsBaseVC =
                    storyboard.instantiateViewController(withIdentifier: "FlightDetailsBaseVC") as! FlightDetailsBaseVC
                
                flightDetailsVC.bookFlightObject = self.bookFlightObject
                flightDetailsVC.taxesResult = self.taxesResult
                flightDetailsVC.sid = sid
                flightDetailsVC.journey = getSelectedJourneyForAllLegs()
                flightDetailsVC.titleString = titleString
                flightDetailsVC.airportDetailsResult = airportDetailsResult
                flightDetailsVC.airlineDetailsResult = airlineDetailsResult
                flightDetailsVC.modalPresentationStyle = .overFullScreen
                self.present(flightDetailsVC, animated: false, completion: nil)
        
    }
 }
