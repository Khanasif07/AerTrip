//
//  FlightInternationalMultiLegResultVC.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class IntMCAndReturnVC : UIViewController {
    
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var pinnedFlightsOptionsView : UIView!
    @IBOutlet weak var showPinnedSwitch: AertripSwitch!
    @IBOutlet weak var unpinnedAllButton: UIButton!
    @IBOutlet weak var emailPinnedFlights: UIButton!
    @IBOutlet weak var sharePinnedFilghts: UIButton!
    @IBOutlet weak var pinnedFlightOptionsTop: NSLayoutConstraint!
    @IBOutlet weak var resultTableViewTop: NSLayoutConstraint!
    @IBOutlet weak var pinOptionsViewWidth: NSLayoutConstraint!
    @IBOutlet weak var unpinAllLeading: NSLayoutConstraint!
    @IBOutlet weak var emailPinnedLeading: NSLayoutConstraint!
    @IBOutlet weak var sharePinnedFlightLeading: NSLayoutConstraint!
    
    
    var bannerView : ResultHeaderView?
    var titleString : NSAttributedString!
    var subtitleString : String!
    var resultTableState  = ResultTableViewState.showTemplateResults
    var stateBeforePinnedFlight = ResultTableViewState.showRegularResults
    var sid : String = ""
    var bookFlightObject = BookFlightObject()
    var scrollviewInitialYOffset = CGFloat(0.0)
    var sortOrder = Sort.Smart
    var results : InternationalJourneyResultsArray!
    var sortedArray: [IntMultiCityAndReturnWSResponse.Results.J] = []
    var numberOfLegs = 2
    var headerTitles : [MultiLegHeader] = []
    var taxesResult : [String : String]!
    var visualEffectViewHeight : CGFloat {
        return statusBarHeight + 88.0
    }
    var statusBarHeight : CGFloat {
        return UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
    }
    
    var isConditionReverced = false
    var prevLegIndex = 0
    var noResultScreen : NoResultsScreenViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        results = InternationalJourneyResultsArray(sort: .Smart)
        setUpSubView()
    }
    
}

extension IntMCAndReturnVC {
    
    fileprivate func setUpSubView(){
        setupTableView()
        results = InternationalJourneyResultsArray(sort: .Smart)
        setupPinnedFlightsOptionsView()
    }
    
    fileprivate func setupTableView() {
        resultsTableView.register(UINib(nibName: "SingleJourneyResultTemplateCell", bundle: nil), forCellReuseIdentifier: "SingleJourneyTemplateCell")
        resultsTableView.register(UINib(nibName: "InternationalReturnTableViewCell", bundle: nil), forCellReuseIdentifier: "InternationalReturnTableViewCell")
        resultsTableView.register(UINib(nibName: "InternationalReturnTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "InternationalReturnTemplateTableViewCell")
        resultsTableView.separatorStyle = .none
        resultsTableView.scrollsToTop = true
        resultsTableView.estimatedRowHeight  = 123
        resultsTableView.rowHeight = UITableView.automaticDimension
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
    }
    
    func addBannerTableHeaderView() {
        DispatchQueue.main.async {
            let rect = CGRect(x: 0, y: 82, width: UIScreen.main.bounds.size.width, height: 156)
            self.bannerView = ResultHeaderView(frame: rect)
            self.bannerView?.frame = rect
            self.view.addSubview(self.bannerView!)
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 94))
            self.resultsTableView.tableHeaderView = headerView
            self.resultsTableView.isScrollEnabled = false
            self.resultsTableView.tableFooterView = nil
        }
    }
    
    func setupPinnedFlightsOptionsView() {
        pinnedFlightOptionsTop.constant = 100
        showPinnedSwitch.tintColor = UIColor.TWO_ZERO_FOUR_COLOR
        showPinnedSwitch.offTintColor = UIColor.TWO_THREE_ZERO_COLOR
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
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func hidePinnedFlightOptions( _ hide : Bool) {
        let optionViewWidth : CGFloat =  hide ? 50.0 : 212.0
        let unpinButtonLeading : CGFloat = hide ? 0.0 : 60.0
        let emailButton : CGFloat = hide ? 0.0 : 114.0
        let shareButtonLeading : CGFloat =
            hide ?  0.0 : 168.0
        if !hide {
            self.emailPinnedFlights.isHidden = hide
            self.unpinnedAllButton.isHidden = hide
            self.sharePinnedFilghts.isHidden = hide
        }
        
        pinOptionsViewWidth.constant = optionViewWidth
        unpinAllLeading.constant = unpinButtonLeading
        emailPinnedLeading.constant = emailButton
        sharePinnedFlightLeading.constant = shareButtonLeading
        UIView.animate(withDuration: 0.1, delay: 0.0 , options: [] , animations: {
            self.view.layoutIfNeeded()
        }) { (onCompletion) in
            if hide {
                self.emailPinnedFlights.isHidden = hide
                self.unpinnedAllButton.isHidden = hide
                self.sharePinnedFilghts.isHidden = hide
            }
        }
    }
    
    func showNoFilteredResults() {
        if noResultScreen != nil { return }
        noResultScreen = NoResultsScreenViewController()
        noResultScreen?.delegate = self.parent as? NoResultScreenDelegate
        self.view.addSubview(noResultScreen!.view)
        self.addChild(noResultScreen!)
        let frame = self.view.frame
        noResultScreen?.view.frame = frame
        noResultScreen?.noFilteredResults()
        //        self.noResultScreen = noResultScreenForFilter
    }
    
    fileprivate func animateTableHeader() {
        if bannerView?.isHidden == false {
            guard let headerView = bannerView  else { return }
            
            let rect = headerView.frame
            resultTableViewTop.constant = 0
            
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
    
    fileprivate func updateUI() {
        let rect = self.resultsTableView.rectForRow(at: IndexPath(row: 0, section: 0))
        self.resultsTableView.scrollRectToVisible(rect, animated: true)
        
        if self.resultTableState == .showExpensiveFlights {
            self.setExpandedStateFooter()
        }
        else {
            self.setGroupedFooterView()
        }
        self.resultsTableView.isScrollEnabled = true
        self.resultsTableView.scrollsToTop = true
        self.resultsTableView.reloadData()
    }
    
    func percentEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    @IBAction func PinnedFlightSwitchToggled(_ sender: AertripSwitch) {
        
        if sender.isOn {
            stateBeforePinnedFlight = resultTableState
            resultTableState = .showPinnedFlights
            resultsTableView.tableFooterView = nil
        }else {
            resultTableState = stateBeforePinnedFlight
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
    
    @IBAction func emailPinnedFlights(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            guard let postData = generatePostDataForEmail(for: results.pinnedFlights) else { return }
            executeWebServiceForEmail(with: postData as Data, onCompletion:{ (view)  in
                
                DispatchQueue.main.async {
                    self.showEmailViewController(body : view)
                }
            })
        }
    }
    
    @IBAction func sharePinnedFlights(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            guard let postData = generatePostData(for: results.pinnedFlights ) else { return }
            
            executeWebServiceForShare(with: postData as Data, onCompletion:{ (link)  in
                
                DispatchQueue.main.async {
                    let textToShare = [ "Checkout my favourite flights on Aertrip!\n\(link)" ]
                    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                }
            })
        }
    }
}

extension IntMCAndReturnVC {
    
    func updateWithArray(_ results : [IntMultiCityAndReturnWSResponse.Results.J] , sortOrder: Sort ) {
        if resultTableState == .showTemplateResults {
            resultTableState = .showRegularResults
        }
        
        DispatchQueue.main.async {
            
            self.sortOrder = sortOrder
            self.results.sort = sortOrder
            let groupedArray =  self.getInternationalDisplayArray(results: results)
            self.results.journeyArray = groupedArray
            self.sortedArray = Array(self.results.sortedArray)
            self.applySorting(sortOrder: self.sortOrder, isConditionReverced: self.isConditionReverced, legIndex: self.prevLegIndex)
            
            self.animateTableHeader()
            
            if results.count > 0 {
                self.noResultScreen?.view.removeFromSuperview()
                self.noResultScreen?.removeFromParent()
                self.noResultScreen = nil
            }
        }
        
    }
    
    func applySorting(sortOrder : Sort, isConditionReverced : Bool, legIndex : Int, shouldReload : Bool = false){
            
        self.sortOrder = sortOrder
        self.isConditionReverced = isConditionReverced
        self.prevLegIndex = legIndex
        
        var sortArray = self.results.suggestedJourneyArray
        
        if self.resultTableState == .showExpensiveFlights{
            sortArray = self.results.journeyArray
        }
        
        switch  sortOrder {
            
        case .Smart:
            
            sortArray = sortArray.sorted(by: { $0.computedHumanScore < $1.computedHumanScore })
            
        case .Price:
            
            sortArray.sort(by: { (obj1, obj2) -> Bool in
                if isConditionReverced {
                    return (obj1.journeyArray.first?.price ?? 0) > (obj2.journeyArray.first?.price ?? 0)
                }else{
                    return (obj1.journeyArray.first?.price ?? 0) < (obj2.journeyArray.first?.price ?? 0)
                }
            })
            
        case .Duration:
            
            sortArray.sort(by: { (obj1, obj2) -> Bool in
                if isConditionReverced {
                    return (obj1.journeyArray.first?.duration ?? 0) > (obj2.journeyArray.first?.duration ?? 0)
                }else{
                    return (obj1.journeyArray.first?.duration ?? 0) < (obj2.journeyArray.first?.duration ?? 0)
                }
            })
            
        case .Depart:
            
            sortArray.sort(by: { (obj1, obj2) -> Bool in
                
                let firstObjDepartureTime = obj1.journeyArray.first?.legsWithDetail[self.prevLegIndex].dt
                let secondObjDepartureTime = obj2.journeyArray.first?.legsWithDetail[self.prevLegIndex].dt
                
                if isConditionReverced {
                    
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime ?? "") < self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime ?? "")
                    
                }else{
                    return self.getTimeIntervalFromDepartureDateString(dt: firstObjDepartureTime ?? "") > self.getTimeIntervalFromDepartureDateString(dt: secondObjDepartureTime ?? "")
                    
                }
            })
            
        case .Arrival:
            sortArray.sort(by: { (obj1, obj2) -> Bool in
                
                let firstObjDepartureTime = (obj1.journeyArray.first?.legsWithDetail[self.prevLegIndex].ad ?? "") + " " + (obj1.journeyArray.first?.legsWithDetail[self.prevLegIndex].at ?? "")
                
                let secondObjDepartureTime = (obj2.journeyArray.first?.legsWithDetail[self.prevLegIndex].ad ?? "") + " " + (obj2.journeyArray.first?.legsWithDetail[self.prevLegIndex].at ?? "")
                
                let firstObjTimeInterval = getTimeIntervalFromArivalDateString(dt: firstObjDepartureTime)
                
                let secondObjTimeInterval = getTimeIntervalFromArivalDateString(dt: secondObjDepartureTime)
                
                if isConditionReverced {
                    return firstObjTimeInterval < secondObjTimeInterval
                }else{
                    return firstObjTimeInterval > secondObjTimeInterval
                }
            })
            
            
        default:
            break
            
        }
        
        if self.resultTableState == .showExpensiveFlights{
            self.results.journeyArray = sortArray
        }else{
            self.results.suggestedJourneyArray = sortArray
        }
        if shouldReload { self.resultsTableView.reloadData() }
    }
    
    
    func getTimeIntervalFromDepartureDateString(dt : String) -> TimeInterval {
        if dt.isEmpty { return  Date().timeIntervalSince1970 }
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.defaultDate = startOfDay
        guard let date = dateFormatter.date(from: dt) else { return  Date().timeIntervalSince1970 }
        return date.timeIntervalSince(startOfDay)
    }
    
    func getTimeIntervalFromArivalDateString(dt : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        //        let arrivalDateString = dt.legsWithDetail[legIndex].ad + " " + $0.legsWithDetail[legIndex].at
        guard let arrivalDate = dateFormatter.date(from: dt) else { return Date() }
        return arrivalDate
        
    }
    
    
    func getInternationalDisplayArray( results : [IntMultiCityAndReturnWSResponse.Results.J]) -> [IntMultiCityAndReturnDisplay] {
        
        var displayArray = [IntMultiCityAndReturnDisplay]()
        
        if resultTableState == .showExpensiveFlights {
            
            let combinedByGroupID = Dictionary(grouping: results, by: { $0.groupID })
            for (_ , journeyArray) in combinedByGroupID {
                let journey = IntMultiCityAndReturnDisplay(journeyArray)
                
                // Sort journeys by minimum computed humane score
                journey.journeyArray.sort { (j1, j2) in
                    let j1Humane = j1.computedHumanScore ?? 0
                    let j2Humane = j2.computedHumanScore ?? 0
                    return j1Humane < j2Humane
                }
                
                displayArray.append(journey)
            }
            
            
            //                displayArray = sortOrder == .Smart ?
            //
            //                    displayArray.sorted(by: { $0.computedHumanScore < $1.computedHumanScore }) :
            //
            //                    displayArray.sorted(by: { $0.fare < $1.fare })
            
        } else {
            
            let combinedByGroupID = Dictionary(grouping: results, by: { $0.groupID })
            
            for (_ , journeyArray) in combinedByGroupID {
                let journey = IntMultiCityAndReturnDisplay(journeyArray)
                
                // Sort journeys by minimum computed humane score
                journey.journeyArray.sort { (j1, j2) in
                    let j1Humane = j1.computedHumanScore ?? 0
                    let j2Humane = j2.computedHumanScore ?? 0
                    return j1Humane < j2Humane
                }
                
                displayArray.append(journey)
            }
            
            
            
            //                displayArray = sortOrder == .Smart ?
            //
            //                    displayArray.sorted(by: { $0.computedHumanScore < $1.computedHumanScore }) : displayArray.sorted(by: { $0.fare < $1.fare })
            
        }
        
        return displayArray
        
    }
    
    func updateAirportDetailsArray(_ results : [String : AirportDetailsWS]) {
        
    }
    
    func updateAirlinesDetailsArray(_ results : [String : AirlineMasterWS]) {
        
    }
    
    func updateTaxesArray(_ results : [String : String]){
        self.taxesResult = results
    }
    
    func addPlaceholderTableHeaderView() {
        DispatchQueue.main.async {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 96))
            self.resultsTableView.tableHeaderView = headerView
        }
    }
}


//MARK:- Tableview Footer View

extension IntMCAndReturnVC {
    
    
}

