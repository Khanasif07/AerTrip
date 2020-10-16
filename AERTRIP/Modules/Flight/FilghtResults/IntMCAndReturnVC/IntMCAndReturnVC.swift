//
//  FlightInternationalMultiLegResultVC.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class IntMCAndReturnVC : UIViewController, getSharableUrlDelegate
{
    
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var pinnedFlightsOptionsView : UIView!
    @IBOutlet weak var switchView: ATSwitcher!
    @IBOutlet weak var unpinnedAllButton: UIButton!
    @IBOutlet weak var emailPinnedFlights: UIButton!
    @IBOutlet weak var sharePinnedFilghts: UIButton!
    @IBOutlet weak var resultTableViewTop: NSLayoutConstraint!
    
    
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
    var noResultScreen : NoResultsScreenViewController?
    let viewModel = IntMCAndReturnVM()
    var previousRequest : DispatchWorkItem?
    var updateResultWorkItem: DispatchWorkItem?
    var flightSearchResultVM  : FlightSearchResultVM?
    let getSharableLink = GetSharableUrl()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.results = InternationalJourneyResultsArray(sort: .Smart)
        setUpSubView()
        getSharableLink.delegate = self
        self.viewModel.setSharedFks()
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
        resultsTableView.estimatedRowHeight = 123
        resultsTableView.rowHeight = UITableView.automaticDimension
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
    }
    
    func addBannerTableHeaderView() {
        DispatchQueue.main.async {
            let rect = CGRect(x: 0, y: 82, width: UIScreen.main.bounds.size.width, height: 154)
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
    
    func setupPinnedFlightsOptionsView() {
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

            manageSwitchContainer(isHidden: true)
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
        if hide {
            self.hideFavsButtons(isAnimated : true)
        } else {
            self.animateFloatingButtonOnListView(isAnimated: true)
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
    
     func animateTableHeader() {
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
        
        if self.viewModel.results.suggestedJourneyArray.isEmpty && viewModel.resultTableState != .showPinnedFlights { viewModel.resultTableState = .showExpensiveFlights
        }
        
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
    
    func callAPIToGetMailTemplate()
    {
        let flightAdultCount = bookFlightObject.flightAdultCount
        let flightChildrenCount = bookFlightObject.flightChildrenCount
        let flightInfantCount = bookFlightObject.flightInfantCount
        let isDomestic = bookFlightObject.isDomestic
        var valStr = ""
        if #available(iOS 13.0, *) {
            valStr = generateCommonString(for: viewModel.results.pinnedFlights, flightObject: bookFlightObject)
        }

        self.getSharableLink.getUrlForMail(adult: "\(flightAdultCount)", child: "\(flightChildrenCount)", infant: "\(flightInfantCount)",isDomestic: isDomestic, sid: sid, isInternational: true, journeyArray: viewModel.results.pinnedFlights, valString: valStr, trip_type: "")

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
    
//    func returnSharableUrl(url: String)
//    {
//
//    }
    
    func returnSharableUrl(url: String) {
        sharePinnedFilghts.displayLoadingIndicator(false)
        self.sharePinnedFilghts.setImage(UIImage(named: "SharePinned"), for: .normal)

        if url == "No Data"{
            AertripToastView.toast(in: self.view, withText: "Something went wrong. Please try again.")
        }else{
            let textToShare = [ "Checkout my favourite flights on Aertrip!\n\(url)" ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func sharePinnedFlights(_ sender: Any){
        if #available(iOS 13.0, *) {
            shareJourney(journey: viewModel.results.pinnedFlights)
        } else {
            // Fallback on earlier versions
        }
    }
    
//    {
//        self.sharePinnedFilghts.setImage(UIImage(named: "OvHotelResult"), for: .normal)
//        sharePinnedFilghts.displayLoadingIndicator(true)
//
//        if #available(iOS 13.0, *) {
//            guard let postData = generatePostData(for: viewModel.results.pinnedFlights ) else { return }
//
//            executeWebServiceForShare(with: postData as Data, onCompletion:{ (link)  in
//
//                DispatchQueue.main.async {
//                    self.sharePinnedFilghts.setImage(UIImage(named: "SharePinned"), for: .normal)
//                    self.sharePinnedFilghts.displayLoadingIndicator(false)
//
//                    if link == "No Data"{
//                        AertripToastView.toast(in: self.view, withText: "Something went wrong. Please try again.")
//                    }else{
//                        let textToShare = [ "Checkout my favourite flights on Aertrip!\n\(link)" ]
//                        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//                        activityViewController.popoverPresentationController?.sourceView = self.view
//                        self.present(activityViewController, animated: true, completion: nil)
//                    }
//                }
//            })
//        }
//    }
}

extension IntMCAndReturnVC {
    
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
        
        self.viewModel.updateRefundStatusInJourneys(fk: fk, rfd: rfd, rsc: rsc)
        
        self.resultsTableView.reloadData()

    }
    
    
    func updateRefundStatusIfPending(fk: String) {
        
//        printDebug("fk..\(fk)")
        
        self.resultsTableView.reloadData()
        
        
        
        
    }
    
    func reloadRowFromFlightDetails(fk: String, isPinned: Bool, isPinnedButtonClicked: Bool) {
        if #available(iOS 13.0, *) {
            self.setPinnedFlightAt(fk, isPinned: isPinned)
        } else {
            // Fallback on earlier versions
        }
    }
    
}
