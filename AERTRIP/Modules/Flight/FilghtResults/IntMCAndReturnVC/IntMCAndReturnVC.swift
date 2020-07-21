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
    
    var airlineCode = ""
    var bannerView : ResultHeaderView?
    var titleString : NSAttributedString!
    var subtitleString : String!
//    var resultTableState  = ResultTableViewState.showTemplateResults
    var stateBeforePinnedFlight = ResultTableViewState.showRegularResults
    var sid : String = ""
    var bookFlightObject = BookFlightObject()
    var scrollviewInitialYOffset = CGFloat(0.0)
//    var sortOrder = Sort.Smart
//    var results : InternationalJourneyResultsArray!
    var sortedArray: [IntMultiCityAndReturnWSResponse.Results.J] = []
    var numberOfLegs = 2
    var headerTitles : [MultiLegHeader] = []
    var taxesResult : [String : String]!
    var airportDetailsResult : [String : IntAirportDetailsWS]!
    var airlineDetailsResult : [String : IntAirlineMasterWS]!
    var visualEffectViewHeight : CGFloat {
        return statusBarHeight + 88.0
    }
    var statusBarHeight : CGFloat {
        return UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
    }
    
//    var isConditionReverced = false
//    var prevLegIndex = 0
    private var noResultScreen : NoResultsScreenViewController?
    
    let viewModel = IntMCAndReturnVM()
    
    var previousRequest : DispatchWorkItem?
    
    var updateResultWorkItem: DispatchWorkItem?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.results = InternationalJourneyResultsArray(sort: .Smart)
        setUpSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
}

extension IntMCAndReturnVC {
    
    fileprivate func setUpSubView(){
        setupTableView()
        viewModel.results = InternationalJourneyResultsArray(sort: .Smart)
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
        
        if self.viewModel.results.suggestedJourneyArray.isEmpty && viewModel.resultTableState != .showPinnedFlights { viewModel.resultTableState = .showExpensiveFlights }
        
        if viewModel.resultTableState == .showExpensiveFlights {
            self.setExpandedStateFooter()
        } else {
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
            stateBeforePinnedFlight = viewModel.resultTableState
            viewModel.resultTableState = .showPinnedFlights
            resultsTableView.tableFooterView = nil
            if viewModel.results.pinnedFlights.isEmpty {
                showNoFilteredResults()
            }
        }else {
            viewModel.resultTableState = stateBeforePinnedFlight
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
            guard let postData = generatePostDataForEmail(for: viewModel.results.pinnedFlights) else { return }
            executeWebServiceForEmail(with: postData as Data, onCompletion:{ (view)  in
                DispatchQueue.main.async {
                    self.showEmailViewController(body : view)
                }
            })
        }
    }
    
    @IBAction func sharePinnedFlights(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            guard let postData = generatePostData(for: viewModel.results.pinnedFlights ) else { return }
            
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
        
        if viewModel.resultTableState == .showTemplateResults {
            viewModel.resultTableState = .showRegularResults
        }
        
        var modifiedResult = results
        
        for i in 0..<modifiedResult.count {
            var isFlightCodeSame = false
            for leg in modifiedResult[i].legsWithDetail{
                for flight in leg.flightsWithDetails{
                    let flightNum = flight.al + flight.fn
                    if flightNum.uppercased() == airlineCode.uppercased(){
                        isFlightCodeSame = true
                    }
                }
            }
            
            if isFlightCodeSame == true{
                modifiedResult[i].isPinned = true

            }
        }
        
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
            
            
            let groupedArray =  self.viewModel.getInternationalDisplayArray(results: modifiedResult)
            self.viewModel.results.journeyArray = groupedArray
            self.sortedArray = Array(self.viewModel.results.sortedArray)
            self.viewModel.setPinnedFlights(shouldApplySorting: true)
            
            self.applySorting(sortOrder: self.viewModel.sortOrder, isConditionReverced: self.viewModel.isConditionReverced, legIndex: self.viewModel.prevLegIndex, completion: {
                DispatchQueue.main.async {
                    self.animateTableHeader()
                    
                    if self.viewModel.resultTableState == .showPinnedFlights{
                        self.resultsTableView.tableFooterView = nil
                    }
                    
                    if self.viewModel.results.suggestedJourneyArray.isEmpty {
                        self.resultsTableView.tableFooterView = nil
                    }
                    
                    if self.viewModel.resultTableState == .showPinnedFlights && self.viewModel.results.pinnedFlights.isEmpty {
                        self.showNoFilteredResults()
                    } else if modifiedResult.count > 0 {
                        self.noResultScreen?.view.removeFromSuperview()
                        self.noResultScreen?.removeFromParent()
                        self.noResultScreen = nil
                    }
                }
            })
        }
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
    
    
    func updateAirportDetailsArray(_ results : [String : IntAirportDetailsWS]) {
        airportDetailsResult = results
    }
    
    func updateAirlinesDetailsArray(_ results : [String : IntAirlineMasterWS]) {
        airlineDetailsResult = results
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


//MARK:- Pinned and RefundStatus Delegate.

extension IntMCAndReturnVC : flightDetailsPinFlightDelegate, UpdateRefundStatusDelegate{
    func updateRefundStatus(for fk: String, rfd: Int, rsc: Int) {
        print(fk, rfd, rsc)
    }
    
    func reloadRowFromFlightDetails(fk: String, isPinned: Bool, isPinnedButtonClicked: Bool) {
        if #available(iOS 13.0, *) {
            self.setPinnedFlightAt(fk, isPinned: isPinned)
        } else {
            // Fallback on earlier versions
        }
    }
    
}

