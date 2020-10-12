//
//  FlightDomesticMultiLegResultVC.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//



import UIKit
import SnapKit
import MessageUI

class FlightDomesticMultiLegResultVC: UIViewController , NoResultScreenDelegate, getSharableUrlDelegate {
    //MARK:- Outlets
    var bannerView : ResultHeaderView?
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var switchView : ATSwitcher!
    @IBOutlet weak var unpinnedAllButton: UIButton!
    @IBOutlet weak var emailPinnedFlights: UIButton!
    @IBOutlet weak var sharePinnedFilghts: UIButton!
    @IBOutlet weak var pinnedFlightOptionView: UIView!
    @IBOutlet weak var pinnedSwitchOptionsBackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pinedswitchOptionsBackViewBottom: NSLayoutConstraint!
    
    //MARK:- NSLayoutConstraints
//    @IBOutlet weak var pinnedFlightOptionsTop: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var baseScrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var headerCollectionViewTop: NSLayoutConstraint!
//    @IBOutlet weak var pinOptionsViewWidth: NSLayoutConstraint!
//    @IBOutlet weak var unpinAllLeading: NSLayoutConstraint!
//    @IBOutlet weak var emailPinnedFlightLeading: NSLayoutConstraint!
//    @IBOutlet weak var sharePinnedFlightsLeading: NSLayoutConstraint!
    @IBOutlet weak var miniHeaderScrollView: UIScrollView!
    @IBOutlet weak var miniHeaderTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionContainerView: UIView!
    
    //MARK:- State Properties
    
    let viewModel = FlightDomesticMultiLegResultVM()
    var sid : String = ""
    var bookFlightObject = BookFlightObject()
    var titleString : NSAttributedString!
    var subtitleString : String!

    var sortedJourneyArray = [[Journey]]()
    var comboResults = [CombinationJourney]()
    var journeyHeaderViewArray = [JourneyHeaderView]()
    var headerArray : [MultiLegHeader]
    var flightsResults  =  FlightsResults()

    var testView = UIView()
    var apiProgress : Float = 0
    var ApiProgress: UIProgressView!
    var flightSearchResultVM  : FlightSearchResultVM!
    var flightSearchType : FlightSearchType
    var fareBreakupVC : FareBreakupVC?
    let journeyCompactViewHeight : CGFloat = 44.0
    var scrollviewInitialYOffset = CGFloat(0.0)
    //    var debugVisibilityView = UIView()
    //    var firstVisibleRectView = UIView()
    var statusBarHeight : CGFloat {
        return UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
    }
    
    var lastTargetContentOffsetX: CGFloat = 0
    var userSelectedFilters = [FiltersWS]()
    var updatedApiProgress : Float = 0

    let getSharableLink = GetSharableUrl()
    var previousRequest : [DispatchWorkItem?] = []
    var isNeedToUpdateLayout = true
    var initialHeader:CGFloat = 138.0
    var isHiddingHeader = false
    var isSettingupHeader = false

    
    //MARK:-  Initializers

    convenience init(numberOfLegs  : Int , headerArray : [MultiLegHeader]) {
        self.init(nibName:nil, bundle:nil)
        self.viewModel.numberOfLegs = numberOfLegs
        self.headerArray = headerArray
        self.flightSearchType = flightSearchType
        self.viewModel.results = Array(repeating: DomesticMultilegJourneyResultsArray(sort: .Smart), count: numberOfLegs)
        sortedJourneyArray = Array(repeating: [Journey](), count: numberOfLegs)
        viewModel.resultsTableStates =  Array(repeating: .showTemplateResults , count: numberOfLegs)
        viewModel.stateBeforePinnedFlight = Array(repeating: .showRegularResults, count: numberOfLegs)
        previousRequest = Array(repeating: nil, count: numberOfLegs)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.viewModel.numberOfLegs = 0
        self.headerArray = [MultiLegHeader]()
        self.flightSearchType = RETURN_JOURNEY
        self.viewModel.results = Array(repeating: DomesticMultilegJourneyResultsArray(sort: .Smart), count: 0)
        sortedJourneyArray = Array(repeating: [Journey](), count: 0)
        viewModel.resultsTableStates =  Array(repeating: .showTemplateResults , count: 0)
        previousRequest = Array(repeating: nil, count: 0)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel.numberOfLegs = 0
        self.flightSearchType = RETURN_JOURNEY
        self.headerArray = [MultiLegHeader]()
        self.viewModel.results = Array(repeating: DomesticMultilegJourneyResultsArray(sort: .Smart), count: 0)
        sortedJourneyArray = Array(repeating: [Journey](), count: 0)
        viewModel.resultsTableStates =  Array(repeating: .showTemplateResults , count: 0)
        previousRequest = Array(repeating: nil, count: 0)
        super.init(coder: aDecoder)
    }
    
    //MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupHeaderView()
        setupScrollView()
        setupPinnedFlightsOptionsView()
        showHintAnimation()
        
        ApiProgress = UIProgressView(progressViewStyle: .bar)
        ApiProgress.progressTintColor = UIColor.AertripColor
        ApiProgress.trackTintColor = .clear
        ApiProgress.progress = 0.25
        
        ApiProgress.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 10.0)
        ApiProgress.transform = CGAffineTransform(scaleX: 1, y: 0.8)
        self.collectionContainerView.addSubview(ApiProgress)
        getSharableLink.delegate = self
        self.viewModel.setSharedFks()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard isNeedToUpdateLayout else {return}
        let width =  UIScreen.main.bounds.size.width / 2.0
        let height = self.baseScrollView.frame.height + 88.0//statusBarHeight + 88.0
        baseScrollView.contentSize = CGSize( width: (CGFloat(self.viewModel.numberOfLegs) * width ), height:height)
        self.miniHeaderTopConstraint.constant = 0.0
        for view in self.baseScrollView.subviews {
            
            if view is JourneyHeaderView {
                continue
            }
            
            var frame = view.frame
            frame.size.height = height
            view.frame = frame
        }
    }
    
    //MARK:- Additional UI Methods
    
    func showNoResultScreenAt(index: Int) {
        addErrorScreenAtIndex(index: index, forFilteredResults: false)
    }
    
    func showNoFilteredResults(index: Int) {
        addErrorScreenAtIndex(index: index, forFilteredResults: true)
    }
    
    
    //MARK:- Logical methods
    
    fileprivate func setTextColorToHeader(_ color : UIColor , indexPath : Int ) {
        
        let index = IndexPath(item: indexPath, section: 0)
        if let headerCell =  headerCollectionView.cellForItem(at: index) as? FlightSectorHeaderCell {
            if indexPath == 0{
                headerCell.veticalSeparatorWidth.constant = 0.4
                headerCell.veticalSeparatorTrailing.constant = 0.7
            }else{
                headerCell.veticalSeparatorWidth.constant = 0.4
                headerCell.veticalSeparatorTrailing.constant = 0.7
            }
 
            if color == .black {
                headerCell.setBlackColoredTitles()
            }
            else {
                headerCell.setRedColoredTitles()
            }
        } else {
            print("cell not fount...\(indexPath)")
        }
    }
    
    func checkForComboFares() {
        
        if let selectedJourneys = self.viewModel.getSelectedJourneyForAllLegs() {
            
            let fkArray = selectedJourneys.map( {
                return $0.fk
            })
            
            if let comboResultFiltered = comboResults.first(where: {$0.fk == fkArray }) {
                fareBreakupVC?.journeyCombo = [comboResultFiltered]
            }else{
                fareBreakupVC?.journeyCombo = nil
            }
        }else{
            fareBreakupVC?.journeyCombo = nil
        }
        
    }
    
    func checkForOverlappingFlights(shouldDisplayToast : Bool = true) {
        fareBreakupVC?.bookButton.isEnabled = true
        
        for i in 0 ..< self.viewModel.numberOfLegs {
            setTextColorToHeader(.black, indexPath: i)
        }
        
        guard let selectedJourneys = self.viewModel.getSelectedJourneyForAllLegs(), selectedJourneys.count >= 2 else { return }

                for i in 0 ..< (selectedJourneys.count - 1) {
                    
                    let currentLegJourney = selectedJourneys[i]
                    let nextLegJourney = selectedJourneys[(i + 1)]
                                
                    let fsr = currentLegJourney.fsr + nextLegJourney.fsr
                    
                    guard let currentLegArrival = currentLegJourney.arrivalDate else { return }
                    guard let nextLegDeparture = nextLegJourney.departureDate else { return }
                        
                    if nextLegDeparture < currentLegArrival {
                        if let parentVC = self.parent {
                            
                            var frame = parentVC.view.frame
                            let bottomInset = self.view.safeAreaInsets.bottom
                            let height = 36 + bottomInset
                            frame.size.height = frame.size.height - height
                            
                            if fsr > 0 {
                                frame.size.height = frame.size.height - 16
                            }
                            
                            if self.viewModel.shouldDisplayToast {
                                AertripToastView.toast(in: parentVC.view , withText: "Flight timings are not compatible. Select a different flight." , parentRect: frame)
                            }
                            
                            setTextColorToHeader(.AERTRIP_RED_COLOR, indexPath: i)
                            setTextColorToHeader(.AERTRIP_RED_COLOR, indexPath: (i + 1 ))
                            
                            self.headerArray[i].isInCompatable = true
                            self.headerArray[i+1].isInCompatable = true

                            fareBreakupVC?.bookButton.isEnabled = false
                            
                        }
                    } else if nextLegDeparture.timeIntervalSince(currentLegArrival) <= 7200 {
                       
                        self.headerArray[i].isInCompatable = false
                        self.headerArray[i+1].isInCompatable = false
                        
                        if let parentVC = self.parent {
                            
                            var frame = parentVC.view.frame
                            let bottomInset = self.view.safeAreaInsets.bottom
                            let height = 36 + bottomInset
                            frame.size.height = frame.size.height - height
                            
                            if fsr > 0 {
                                frame.size.height = frame.size.height - 16
                            }
                            
                            if self.viewModel.shouldDisplayToast {
                                AertripToastView.toast(in: parentVC.view , withText: "Selected flights have less than 2 hrs of gap." , parentRect: frame)
                            }
                            
                            fareBreakupVC?.bookButton.isEnabled = true
                        }
                    } else {
                        self.headerArray[i].isInCompatable = false
                        self.headerArray[i+1].isInCompatable = false
                        CustomToast.shared.fadeAllToasts()
                        
//                        setTextColorToHeader(.black, indexPath: i)
//                        setTextColorToHeader(.black, indexPath: (i + 1 ))
                        
//                        AertripToastView.hideToast()
            }
                    headerCollectionView.reloadData()

       }
        
        
    }
    
    
    //MARK:- Target  methods
    @IBAction func PinnedFlightSwitchTogged(_ sender: AertripSwitch) {
        
        if sender.isOn  {
            viewModel.stateBeforePinnedFlight = viewModel.resultsTableStates
            viewModel.resultsTableStates = Array(repeating: .showPinnedFlights, count: self.viewModel.numberOfLegs)
           
            for subView in self.baseScrollView.subviews {
                if let tableview = subView as? UITableView {
                    let index = tableview.tag - 1000
                    let count = self.viewModel.results[index].pinnedFlights.count
                    
                    
                    if count > 0 {
                        tableview.reloadData()
                        tableview.tableFooterView = nil
                        
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableview.scrollToRow(at: indexPath, at: .top, animated: true)
                        tableview.selectRow(at: indexPath , animated: false, scrollPosition: .none)
                    }
                    else {
                        addErrorScreenAtIndex(index: index , forFilteredResults: true)
                    }
                }
            }
       
            self.baseScrollView.setContentOffset(.zero, animated: true)
        
//            hidePinnedFlightOptions(false)
      
        } else {
            
            viewModel.resultsTableStates = viewModel.stateBeforePinnedFlight
            for index in 0 ..< self.viewModel.numberOfLegs {
                if let errorView = self.baseScrollView.viewWithTag( 500 + index) {
                    errorView.removeFromSuperview()
                }
                self.updateUIForTableviewAt(index)
            }
//            hidePinnedFlightOptions(true)
        }
        self.viewModel.isPinnedOn = sender.isOn
        self.setTotalFare()
        let containsPinnedFlight = self.viewModel.results.reduce(false) { $0 || $1.containsPinnedFlight }
//        showPinnedFlightSwitch(containsPinnedFlight)
        self.checkForOverlappingFlights()
        
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
    

    
   
    
//    MARK:- Email Flight code added by Monika
    @IBAction func emailPinnedFlights(_ sender: Any) {
        
        emailPinnedFlights.setImage(UIImage(named: "OvHotelResult"), for: .normal)
        emailPinnedFlights.displayLoadingIndicator(true)


        let pinnedFlightsArray = viewModel.results.reduce([]) { $0 + $1.pinnedFlights }
          
          let flightAdultCount = bookFlightObject.flightAdultCount
          let flightChildrenCount = bookFlightObject.flightChildrenCount
          let flightInfantCount = bookFlightObject.flightInfantCount
          let isDomestic = bookFlightObject.isDomestic
          let tripType = (self.bookFlightObject.flightSearchType == RETURN_JOURNEY) ? "return" : "multi"

          self.getSharableLink.getUrlForMail(adult: "\(flightAdultCount)", child: "\(flightChildrenCount)", infant: "\(flightInfantCount)",isDomestic: isDomestic, sid: sid, isInternational: false, journeyArray: pinnedFlightsArray, valString: "", trip_type: tripType)

    }
   
    //MARK:- Sharing Journey code added by Monika

    @IBAction func sharePinnedFlights(_ sender: Any)
    {
        let pinnedFlightsArray = self.viewModel.results.reduce([]) { $0 + $1.pinnedFlights }
        shareFlights(journeyArray: pinnedFlightsArray)
    }
    
    func shareFlights( journeyArray : [Journey]) {
        sharePinnedFilghts.displayLoadingIndicator(true)
        self.sharePinnedFilghts.setImage(UIImage(named: "OvHotelResult"), for: .normal)

        let flightAdultCount = bookFlightObject.flightAdultCount
        let flightChildrenCount = bookFlightObject.flightChildrenCount
        let flightInfantCount = bookFlightObject.flightInfantCount
        let isDomestic = bookFlightObject.isDomestic
        let tripType = (self.bookFlightObject.flightSearchType == RETURN_JOURNEY) ? "return" : "multi"
        let filterStr = getSharableLink.getAppliedFiltersForSharingDomesticJourney(legs: self.flightSearchResultVM.flightLegs)

        self.getSharableLink.getUrl(adult: "\(flightAdultCount)", child: "\(flightChildrenCount)", infant: "\(flightInfantCount)",isDomestic: isDomestic, isInternational: false, journeyArray: journeyArray, valString: "", trip_type: tripType,filterString: filterStr)

    }
    
    func returnSharableUrl(url: String)
    {
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
    
}


extension  FlightDomesticMultiLegResultVC {

    func updateApiProcess(progress:Float) {
        if progress > 0.25 {
            DispatchQueue.main.async {
                
                if self.ApiProgress.progress < progress {
                    self.ApiProgress.setProgress(progress, animated: true)
                }
                
                if progress >= 0.97 {
                    self.ApiProgress.isHidden = true
                    self.hideBannerWhenAPIFails()
                }
            }
        }
    }
}



extension FlightDomesticMultiLegResultVC {
    
    
    func updatePriceWhenGoneup(_ fk: String, changeResult: ChangeResult,tableIndex : Int ) {
        
         var journeyArray = self.viewModel.results[tableIndex].journeyArray
        guard let index = journeyArray.firstIndex(where: {
            $0.fk == fk
        }) else {
            return
        }
        
        let journeyToToggle = journeyArray[index]
//        journeyToToggle.isPinned = isPinned
        journeyToToggle.farepr = changeResult.farepr
        journeyToToggle.fare.BF.value = changeResult.fare.bf.value
        journeyToToggle.fare.taxes.value = changeResult.fare.taxes.value
        journeyToToggle.fare.taxes.details = changeResult.fare.taxes.details
        journeyArray[index] = journeyToToggle
        self.viewModel.results[tableIndex].journeyArray = journeyArray
        
        //Updating pinned flight indicator in tableview Cell after pin / unpin action
        guard let tableview = self.baseScrollView.viewWithTag(1000 + tableIndex) as? UITableView  else { return }
        tableview.reloadData()
    }
    
}
