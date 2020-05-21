//
//  FlightResultHomeViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 01/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit
//import HMSegmentedControl
import SnapKit

class FlightResultBaseViewController: UIViewController , FilterUIDelegate {
    
    var flightSearchResultVM  : FlightSearchResultVM!
    var flightSearchParameters : NSDictionary!
    var visualEffectViewHeight : CGFloat {
        
        return statusBarHeight + 88.0
    }
    var ApiProgress: UIProgressView!
    @IBOutlet weak var resultContainerTopOffset: NSLayoutConstraint!
    @IBOutlet weak var headerImageViewHeight: NSLayoutConstraint!
    var visualEffectView : UIVisualEffectView!
    var backView : UIView!
    var statusBarBlurView : UIVisualEffectView!
    //MARK:- ViewController Elements
    var  singleJourneyResultVC : FlightResultSingleJourneyVC?
    var  domesticMultiLegResultVC : FlightDomesticMultiLegResultVC?
    var  intMultiLegResultVC : IntMCAndReturnVC?
    var flightFilterVC : FlightFilterBaseViewController?
    var intMCAndReturnFilterVC: IntMCAndReturnFlightFiltersBaseVC?
    var noResultScreen : NoResultsScreenViewController?
    //MARK:- Navigation Bar UI Elements
    var backButton : UIButton!
    var filterButton : UIButton!
    var filterSegmentView: HMSegmentedControl!
    var resultTitle : UILabel!
    var resultsubTitle: UILabel!
    var infoButton : UIButton!
    var clearAllFiltersButton : UIButton?
    var doneButton : UIButton!
    var filterTitle : UILabel!
    let separatorView = UIView()
    private var numberOfLegs = 0 {
        didSet {
            self.flightSearchResultVM.numberOfLegs = numberOfLegs
        }
    }
    private var isIntReturnOrMCJourney = false
    var statusBarHeight : CGFloat {
        
        return UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
    }
    
    private var filterUpdateWorkItem : DispatchWorkItem?
    private var showDepartReturnSame = false
    
    //MARK:- Initializers
    @objc convenience init(flightSearchResultVM : FlightSearchResultVM , flightSearchParameters: NSDictionary, isIntReturnOrMCJourney: Bool) {
        self.init(nibName:nil, bundle:nil)
        self.flightSearchResultVM = flightSearchResultVM
        flightSearchResultVM.delegate = self
        flightSearchResultVM.initiateResultWebService()
        self.flightSearchParameters = flightSearchParameters
        self.isIntReturnOrMCJourney = isIntReturnOrMCJourney
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNagationBar()
        createFilterTitle()
        
        setupSegmentView()
        self.filterSegmentView.sectionTitles = flightSearchResultVM.segmentTitles(showSelection: false, selectedIndex: filterSegmentView.selectedSegmentIndex)
        self.filterSegmentView.selectedSegmentIndex = HMSegmentedControlNoSegment
        
        setupResultView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addCustomBackgroundBlurView()
        
    }
    
    func addCustomBackgroundBlurView()
    {
        
        visualEffectView = UIVisualEffectView(frame:  CGRect(x: 0 , y: 0, width:self.view.frame.size.width , height: visualEffectViewHeight))
        visualEffectView.effect = UIBlurEffect(style: .prominent)
        
        backView = UIView(frame: CGRect(x: 0 , y: 0, width:self.view.frame.size.width , height: visualEffectViewHeight))
        backView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        backView.addSubview(visualEffectView)
        backView.tag = 500
        
        backButton = UIButton(type: .custom)
        let buttonImage = UIImage(named: "green")
        backButton.setImage(buttonImage, for: .normal)
        backButton.setImage(buttonImage, for: .selected)
        
        backButton.frame = CGRect(x: 8, y: statusBarHeight, width: 44, height: 44)
        
        backButton.addTarget(self, action: #selector(self.popToPreviousScreen(sender:)), for: .touchUpInside)
        visualEffectView.contentView.addSubview(backButton)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.view.addSubview(backView)
        
        visualEffectView.contentView.addSubview(resultTitle)
        visualEffectView.contentView.addSubview(resultsubTitle)
        visualEffectView.contentView.addSubview(filterButton)
        
        filterButton.snp.makeConstraints { (make) in
            make.left.equalTo(visualEffectView.contentView).offset(0)
            make.bottom.equalTo(visualEffectView.contentView).offset(0)
            make.width.equalTo(44)
            make.height.equalTo(51)
        }
        
        visualEffectView.contentView.addSubview(infoButton)
        
        visualEffectView.contentView.addSubview(self.filterSegmentView)
        filterSegmentView.snp.makeConstraints { (make) in
            make.left.equalTo(visualEffectView.contentView).offset(44.0)
            make.bottom.equalTo(visualEffectView.contentView).offset(0)
            make.trailing.equalTo(visualEffectView.contentView).offset(0)
            make.height.equalTo(51)
        }
        
        ApiProgress = UIProgressView()
        ApiProgress.progressTintColor = UIColor.AertripColor
        ApiProgress.trackTintColor = .clear
        
        ApiProgress.progress = 0.25
        
        if flightSearchResultVM.isIntMCOrReturnJourney {
            ApiProgress.progress = flightSearchResultVM.containsJourneyResuls ? 0 : 0.25
        }
        
        visualEffectView.contentView.addSubview(ApiProgress)
        ApiProgress.snp.makeConstraints { (make) in
            make.bottom.equalTo(visualEffectView.contentView).offset(0)
            make.width.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        
        separatorView.backgroundColor = UIColor.TWO_ZERO_FOUR_COLOR
        visualEffectView.contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.left.equalTo(visualEffectView.contentView).offset(0.0)
            make.bottom.equalTo(visualEffectView.contentView).offset(-2.0)
            make.width.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        
        // Added Blur view Behind Status bar to avoid content getting merged with status bars
        statusBarBlurView = UIVisualEffectView(frame:  CGRect(x: 0 , y: 0, width:self.view.frame.size.width , height: statusBarHeight))
        statusBarBlurView.effect = UIBlurEffect(style: .prominent)
        self.navigationController?.view.addSubview(statusBarBlurView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        backView.removeFromSuperview()
        statusBarBlurView.removeFromSuperview()
        self.flightSearchResultVM.cancelAllWebserviceCalls()
    }
    
    
    //MARK:- View Controller Container Methods
    
    func  dateStringForHeaderFrom(inputString : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = dateFormatter.date(from: inputString) {
            dateFormatter.dateFormat = "E, dd MMM"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    
    func headerTitlesForReturnJourney() ->  [MultiLegHeader] {
        var headerTitles = [MultiLegHeader]()
        
        guard let departDate = self.flightSearchParameters["depart"] as? String else { return headerTitles }
        guard let returnDate = self.flightSearchParameters["return"] as? String else { return headerTitles }
        
        let departTitle = dateStringForHeaderFrom(inputString: departDate)
        let returnTitle = dateStringForHeaderFrom(inputString: returnDate)
        
        
        let departAttributedString = NSAttributedString(string: departTitle)
        let returnAttributedString = NSAttributedString(string: returnTitle)
        
        let redAttributes = [NSAttributedString.Key.foregroundColor : UIColor.AERTRIP_RED_COLOR]
        let onwardsRedString  = NSMutableAttributedString(string: departTitle, attributes: redAttributes)
        let returnRedString  = NSMutableAttributedString(string: returnTitle, attributes: redAttributes)
        
        let onwardsHeader =  MultiLegHeader(title: departAttributedString, redTitle: onwardsRedString, subTitle: "Onward")
        let returnHeader =  MultiLegHeader(title: returnAttributedString, redTitle: returnRedString, subTitle: "Return")
        
        headerTitles.append(onwardsHeader)
        headerTitles.append(returnHeader)
        
        return headerTitles
    }
    
    func headerTitlesForIntMultiCityJourney()-> [MultiLegHeader]{
        
        guard let allKey = (self.flightSearchParameters.allKeys as? [String]) else {return []}
        var headerTitles = [MultiLegHeader]()
        let departArray = allKey.map{$0.contains("depart")}
        for i in 0..<departArray.count{
            
            let departKey = "depart[\(i)]"
            let destinationKey = "destination[\(i)]"
            let originKey  =  "origin[\(i)]"
            
            guard let departDate = self.flightSearchParameters[departKey] as? String else { return headerTitles }
            guard let destination = self.flightSearchParameters[destinationKey] as? String else { return headerTitles }
            guard let origin = self.flightSearchParameters[originKey] as? String else { return headerTitles }
            
            let fullString = NSMutableAttributedString(string: origin + " " )
            let desinationAtrributedString = NSAttributedString(string: " " + destination)
            let imageString = getStringFromImage(name : "oneway")
            fullString.append(imageString)
            fullString.append(desinationAtrributedString)
            
            
            let redString = NSMutableAttributedString(string: origin + " " )
            let redImageString = getStringFromImage(name : "ArrowRed")
            redString.append(redImageString)
            redString.append(desinationAtrributedString)
            let redAttributes = [NSAttributedString.Key.foregroundColor : UIColor.AERTRIP_RED_COLOR]
            redString.addAttributes(redAttributes, range: NSMakeRange(0, redString.length))
            
            let subtitle = dateStringForHeaderFrom(inputString: departDate)
            let legHeader = MultiLegHeader(title: fullString, redTitle: redString, subTitle: subtitle)
            
            headerTitles.append(legHeader)
        }
        return headerTitles
    }
    
    
    
    
    func headerTitlesForMultiCityJourney() -> [MultiLegHeader] {
        var headerTitles = [MultiLegHeader]()
        
        let count = self.flightSearchResultVM.displayGroups.count
        
        
        for i in 0 ..< count {
            
            let departKey = "depart[\(i)]"
            let destinationKey = "destination[\(i)]"
            let originKey  =  "origin[\(i)]"
            
            guard let departDate = self.flightSearchParameters[departKey] as? String else { return headerTitles }
            guard let destination = self.flightSearchParameters[destinationKey] as? String else { return headerTitles }
            guard let origin = self.flightSearchParameters[originKey] as? String else { return headerTitles }
            
            let fullString = NSMutableAttributedString(string: origin + " " )
            let desinationAtrributedString = NSAttributedString(string: " " + destination)
            let imageString = getStringFromImage(name : "oneway")
            fullString.append(imageString)
            fullString.append(desinationAtrributedString)
            
            
            let redString = NSMutableAttributedString(string: origin + " " )
            let redImageString = getStringFromImage(name : "ArrowRed")
            redString.append(redImageString)
            redString.append(desinationAtrributedString)
            let redAttributes = [NSAttributedString.Key.foregroundColor : UIColor.AERTRIP_RED_COLOR]
            redString.addAttributes(redAttributes, range: NSMakeRange(0, redString.length))
            
            let subtitle = dateStringForHeaderFrom(inputString: departDate)
            let legHeader = MultiLegHeader(title: fullString, redTitle: redString, subTitle: subtitle)
            
            headerTitles.append(legHeader)
        }
        return headerTitles
    }
    
    
    func getStringFromImage(name : String) -> NSAttributedString {
        
        let imageAttachment = NSTextAttachment()
        let sourceSansPro18 = UIFont(name: "SourceSansPro-Semibold", size: 18.0)!
        let iconImage = UIImage(named: name )!
        imageAttachment.image = iconImage
        
        let yCordinate  = roundf(Float(sourceSansPro18.capHeight - iconImage.size.height) / 2.0)
        imageAttachment.bounds = CGRect(x: CGFloat(0.0), y: CGFloat(yCordinate) , width: iconImage.size.width, height: iconImage.size.height )
        let imageString = NSAttributedString(attachment: imageAttachment)
        return imageString
    }
    
    fileprivate func addReturnJourneyViewController() {
        
        let count : Int
        let flightType = flightSearchResultVM.flightSearchType
        
        let headerTitles : [MultiLegHeader]
        switch flightType {
        case RETURN_JOURNEY:
            count = 2
            headerTitles = headerTitlesForReturnJourney()
        case MULTI_CITY :
            count = self.flightSearchResultVM.displayGroups.count
            headerTitles = headerTitlesForMultiCityJourney()
        default:
            return
        }
        self.numberOfLegs = headerTitles.count
        let resultBaseVC = FlightDomesticMultiLegResultVC(numberOfLegs: count , headerArray: headerTitles)
        resultBaseVC.titleString = flightSearchResultVM.titleString
        resultBaseVC.subtitleString = flightSearchResultVM.subTitleString
        resultBaseVC.sid = flightSearchResultVM.sid
        resultBaseVC.bookFlightObject = flightSearchResultVM.bookFlightObject
        resultBaseVC.flightSearchType = flightSearchResultVM.flightSearchType
        domesticMultiLegResultVC = resultBaseVC
        addChildView(resultBaseVC)
    }
    
    func addInternationalReturnViewControl(){
        
        let count : Int
        let flightType = flightSearchResultVM.flightSearchType
        
        let headerTitles : [MultiLegHeader]
        switch flightType {
        case RETURN_JOURNEY:
            count = 2
            headerTitles = headerTitlesForReturnJourney()
        case MULTI_CITY :
            count = self.flightSearchResultVM.displayGroups.count
            headerTitles = headerTitlesForIntMultiCityJourney()
        default:
            return
        }
        self.numberOfLegs = headerTitles.count
        let resultBaseVC = IntMCAndReturnVC()
        resultBaseVC.viewModel.resultTableState = .showTemplateResults
        resultBaseVC.addBannerTableHeaderView()
        resultBaseVC.titleString = flightSearchResultVM.titleString
        resultBaseVC.subtitleString = flightSearchResultVM.subTitleString
        resultBaseVC.sid = flightSearchResultVM.sid
        resultBaseVC.bookFlightObject = flightSearchResultVM.bookFlightObject
        resultBaseVC.headerTitles = headerTitles
        resultBaseVC.numberOfLegs = self.numberOfLegs
        addChildView(resultBaseVC)
        self.intMultiLegResultVC = resultBaseVC
    }
    
    fileprivate func addSingleJourneyViewController() {
        let resultBaseVC = FlightResultSingleJourneyVC()
        resultBaseVC.resultTableState = .showTemplateResults
        resultBaseVC.addBannerTableHeaderView()
        resultBaseVC.titleString = flightSearchResultVM.titleString
        resultBaseVC.subtitleString = flightSearchResultVM.subTitleString
        resultBaseVC.sid = flightSearchResultVM.sid
        resultBaseVC.bookFlightObject = flightSearchResultVM.bookFlightObject
        addChildView(resultBaseVC)
        singleJourneyResultVC = resultBaseVC
    }
    
    func setupResultView() {
        
        let flightType = flightSearchResultVM.flightSearchType
        
        switch flightType {
        case SINGLE_JOURNEY:
            addSingleJourneyViewController()
            
        case RETURN_JOURNEY:
            if flightSearchResultVM.isDomestic {
                addReturnJourneyViewController()
            }
            else {
                addInternationalReturnViewControl()
            }
            
        case  MULTI_CITY:
            
            if flightSearchResultVM.isDomestic {
                addReturnJourneyViewController()
            } else {
                addInternationalReturnViewControl()
                //                let resultBaseVC = FlightInternationalMultiLegResultVC()
                //                addChildView(resultBaseVC)
            }
            break
        default:
            return
        }
    }
    
    fileprivate func addChildView(_ resultBaseVC: UIViewController ) {
        
        var rect = self.view.frame
        rect.origin.y = statusBarHeight
        rect.size.height = rect.size.height - statusBarHeight
        resultBaseVC.view.frame = rect
        
        self.view.addSubview(resultBaseVC.view)
        self.addChild(resultBaseVC)
        resultBaseVC.didMove(toParent: self)
    }
    
    
    fileprivate func legListForReturnFlightSearch()-> [Leg] {
        
        var legList = [Leg]()
        let bookingObject = flightSearchResultVM.bookFlightObject
        let displayGroup : Dictionary<String , Int> = bookingObject.displayGroups as? Dictionary<String, Int> ?? Dictionary<String, Int>()
        var displaygroup2 = Dictionary<Int , String >()
        
        
        for (key,value) in displayGroup {
            if value > 0 {
                displaygroup2[value] = key
            }
        }
        
        let sortedkeys = displaygroup2.keys.sorted(by: < )
        
        for key in sortedkeys {
            
            guard let displayGroup = displaygroup2[key] else { continue }
            let displayGroupComponents = displayGroup.components(separatedBy: "-")
            let journey = Leg(origin: displayGroupComponents[0], destination: displayGroupComponents[1])
            legList.append(journey)
        }
        
        if isIntReturnOrMCJourney {
            if let originStr = flightSearchParameters["origin"] as? String, let destStr = flightSearchParameters["destination"] as? String {
                let originLeg = Leg(origin: originStr, destination: destStr)
                let returnLeg = Leg(origin: originLeg.destination, destination: originLeg.origin)
                legList = [originLeg, returnLeg]
            } else {
                legList.append(Leg(origin: "", destination: ""))
            }
        }
        
        return legList
    }
    
    fileprivate func legListForMultiCityFlightSearch() -> [Leg] {
        
        var legList = [Leg]()
        
        let count = self.flightSearchResultVM.displayGroups.count
        for i in 0 ..< count {
            
            let destinationKey = "destination[\(i)]"
            let originKey  =  "origin[\(i)]"
            
            guard let destination = self.flightSearchParameters[destinationKey] as? String else { return legList }
            guard let origin = self.flightSearchParameters[originKey] as? String else { return legList }
            
            let leg = Leg(origin: origin, destination: destination)
            legList.append(leg)
            
        }
        
        return legList
    }
    
    fileprivate func getLegListForIntMCAndReturnSearch() -> [Leg] {
        
        var legList = [Leg]()
        for index in 0..<numberOfLegs {
            let originKey = "origin[\(index)]"
            let destinationKey = "destination[\(index)]"
            
            if let origin = flightSearchParameters[originKey] as? String, let destination = flightSearchParameters[destinationKey] as? String {
                legList.append(Leg(origin: origin, destination: destination))
            }
        }
        return legList
    }
    
    func createFiltersBaseView(index : Int) {
        
        var legList = [Leg]()
        
        let flightType = flightSearchResultVM.flightSearchType
        
        if flightType == SINGLE_JOURNEY {
            let origin = self.flightSearchParameters.value(forKey: "origin") as! String
            let destination = self.flightSearchParameters.value(forKey: "destination") as! String
            let journey = Leg(origin: origin, destination: destination)
            legList = [journey]
            
        }
        if flightType == RETURN_JOURNEY {
            legList = legListForReturnFlightSearch()
        }
        if flightType == MULTI_CITY {
            legList = legListForMultiCityFlightSearch()
            
            if isIntReturnOrMCJourney {
                legList = getLegListForIntMCAndReturnSearch()
            }
            
        }
        
        if isIntReturnOrMCJourney {
            
            intMCAndReturnFilterVC = IntMCAndReturnFlightFiltersBaseVC(flightSearchResult: self.flightSearchResultVM.intFlightResultArray, selectedIndex: index, legList: legList, searchType: flightType)
            self.intMCAndReturnFilterVC?.delegate = flightSearchResultVM
            self.intMCAndReturnFilterVC?.filterUIDelegate = self
            self.intMCAndReturnFilterVC?.showDepartReturnSame = showDepartReturnSame
            return
        }
        
        self.flightFilterVC = FlightFilterBaseViewController(flightSearchResult: self.flightSearchResultVM.flightResultArray , selectedIndex: index , legList: legList , searchType: flightType )
        self.flightFilterVC?.delegate = flightSearchResultVM
        self.flightFilterVC?.filterUIDelegate = self
    }
    
    //MARK:- HMSegmentedControl SegmentView UI Methods
    
    fileprivate func setupSegmentView(){
        self.filterSegmentView = HMSegmentedControl()
        self.filterSegmentView.backgroundColor = .clear
        self.filterSegmentView.selectionIndicatorLocation = .down;
        self.filterSegmentView.segmentWidthStyle = .dynamic
        self.filterSegmentView.segmentEdgeInset = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0);
        self.filterSegmentView.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 40.0);
        
        self.filterSegmentView.autoresizingMask = .flexibleWidth
        self.filterSegmentView.selectionStyle = .textWidthStripe
        self.filterSegmentView.selectionIndicatorLocation = .down;
        self.filterSegmentView.selectionIndicatorHeight = 2
        self.filterSegmentView.isVerticalDividerEnabled = false
        self.filterSegmentView.selectionIndicatorColor = .clear
        
        self.filterSegmentView.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black , NSAttributedString.Key.font : UIFont(name:"SourceSansPro-Regular" , size: 16)! ]
        self.filterSegmentView.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black , NSAttributedString.Key.font : UIFont(name:"SourceSansPro-Semibold" , size: 16)!]
        self.filterSegmentView .addTarget(self, action: #selector(filtersegmentChanged(_:)), for: .valueChanged)
        
        self.filterSegmentView.sectionTitles = flightSearchResultVM.segmentTitles(showSelection: false, selectedIndex: filterSegmentView.selectedSegmentIndex)
        self.filterSegmentView.selectedSegmentIndex = HMSegmentedControlNoSegment
    }
    
    //MARK:- Navigation Bar Methods
    
    @objc func popToPreviousScreen( sender : UIButton) {
        self.navigationController?.view.viewWithTag(500)?.removeFromSuperview()
        self.navigationController?.view.viewWithTag(2500)?.removeFromSuperview()
        statusBarBlurView.removeFromSuperview()
        self.navigationController?.viewControllers.removeLast()
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupNagationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        addTitleToNavigationController()
        addSubTitleToNavigationController()
        addInfoButton()
        createFilterButton()
    }
    
    fileprivate func addInfoButton() {
        
        if infoButton != nil {
            infoButton.removeFromSuperview()
            infoButton = nil
        }
        
        infoButton = UIButton(type: .custom)
        infoButton.setImage(UIImage(named: "InfoButton"), for: .normal)
        
        let x = UIScreen.main.bounds.width - 40
        infoButton.frame = CGRect(x: x, y: statusBarHeight +  7, width: 30, height: 30)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        
    }
    
    func addFilterHeader() {
        
        flightResultHeadersViews(isHidden: true)
        addDoneButton()
        addCancelButton()
        addFilterTitle()
    }
    
    
    func createFilterButton() {
        filterButton = UIButton(type: .custom)
        guard let normalImage = UIImage(named: "filterClearIndicator") else { assertionFailure("filter clear imaage missing")
            return }
        guard let selectedImage = UIImage(named:"FilterApplIiedndicator") else { assertionFailure("filter selected image missing")
            return }
        filterButton.setImage(normalImage, for: .normal)
        filterButton.setImage(selectedImage, for: .selected)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchDown)
        
    }
    
    func addSubTitleToNavigationController() {
        
        resultsubTitle = UILabel(frame: CGRect(x:0 , y: statusBarHeight + 23, width: UIScreen.main.bounds.size.width, height: 17))
        resultsubTitle.font = UIFont(name: "SourceSansPro-regular", size: 13)!
        resultsubTitle.text = flightSearchResultVM.subTitleString
        resultsubTitle.textAlignment = .center
        
    }
    
    
    func addCancelButton() {
        
        if clearAllFiltersButton != nil {
            clearAllFiltersButton?.removeFromSuperview()
            clearAllFiltersButton = nil
        }
        
        let clearAllFilters = UIButton(type: .custom)
        clearAllFilters.setTitle("Clear all", for: .normal)
        clearAllFilters.setTitleColor( UIColor.AertripColor, for: .normal)
        clearAllFilters.setTitleColor( UIColor.TWO_ZERO_FOUR_COLOR , for: .disabled)
        clearAllFilters.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 18.0)
        clearAllFilters.titleLabel?.textAlignment = .left
        clearAllFilters.addTarget(self, action: #selector(clearAllFilterTapped), for: .touchDown)
        
        var appliedFilters = Set<Filters>()
        var UIFilters = Set<UIFilters>()
        
        if isIntReturnOrMCJourney {
            for flightLeg in flightSearchResultVM.intFlightLegs {
                appliedFilters = appliedFilters.union(flightLeg.appliedFilters)
                UIFilters = UIFilters.union(flightLeg.UIFilters)
            }
        } else {
            for flightLeg in flightSearchResultVM.flightLegs {
                appliedFilters = appliedFilters.union(flightLeg.appliedFilters)
                UIFilters = UIFilters.union(flightLeg.UIFilters)
            }
        }
        let filterApplied =  appliedFilters.count > 0 || UIFilters.count > 0
        
        clearAllFilters.isEnabled = filterApplied
        visualEffectView.contentView.addSubview(clearAllFilters)
        
        clearAllFilters.snp.makeConstraints { (maker) in
            maker.height.equalTo(44.0)
            maker.leading.equalTo(13.0)
            maker.width.equalTo(62.0)
            maker.top.equalTo(statusBarHeight)
        }
        
        clearAllFiltersButton =  clearAllFilters
    }
    
    
    func addDoneButton () {
        
        if doneButton != nil {
            doneButton.removeFromSuperview()
            doneButton = nil
        }
        
        doneButton = UIButton(type: .custom)
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.textAlignment = .right
        doneButton.setTitleColor( UIColor.AertripColor, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: "SourceSansPro-Semibold", size: 18.0)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchDown)
        visualEffectView.contentView.addSubview(doneButton)
        
        doneButton.snp.makeConstraints { (maker) in
            maker.height.equalTo(41.0)
            maker.trailing.equalTo(-13.0)
            maker.width.equalTo(41.0)
            maker.top.equalTo(statusBarHeight)
        }
    }
    
    
    func addTitleToNavigationController() {
        
        resultTitle = UILabel(frame: CGRect(x: 50 , y: statusBarHeight + 1.0 , width: UIScreen.main.bounds.size.width  - 100.0 , height: 23))
        resultTitle.font = UIFont(name: "SourceSansPro-semibold", size: 18)!
        resultTitle.attributedText = flightSearchResultVM.titleString
        resultTitle.textAlignment = .center
        resultTitle.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
    }
    
    
    //MARK:- Target Methods
    @IBAction func clearAllFilterTapped(_ sender: Any) {
        flightSearchResultVM.clearAllFilters()
        flightFilterVC?.resetAllFilters()
        intMCAndReturnFilterVC?.resetAllFilters()
        
    }
    
    @IBAction func doneButtonTapped() {
        flightFilterVC?.view.removeFromSuperview()
        flightFilterVC?.removeFromParent()
        intMCAndReturnFilterVC?.view.removeFromSuperview()
        intMCAndReturnFilterVC?.removeFromParent()
        removedFilterUIFromParent()
    }
    
    
    @objc func infoButtonTapped() {
        
    }
    
    func selectedIndexChanged(index: UInt) {
        self.filterSegmentView.setSelectedSegmentIndex(index , animated: true)
        self.filterSegmentView.sectionTitles = flightSearchResultVM.segmentTitles(showSelection: true, selectedIndex: filterSegmentView.selectedSegmentIndex)
    }
    
    //MARK:- Methods to open Filter UI
    @IBAction func filterButtonTapped(_ sender: Any) {
        
        if flightSearchResultVM.containsJourneyResuls  {
            self.openFiltersWith(index: 0)
            self.filterSegmentView.selectedSegmentIndex = 0
            filterSegmentView.sectionTitles = flightSearchResultVM.segmentTitles(showSelection: true, selectedIndex: filterSegmentView.selectedSegmentIndex)
        }
    }
    
    @IBAction func filtersegmentChanged(_ sender: HMSegmentedControl) {
        if flightSearchResultVM.containsJourneyResuls {
            self.openFiltersWith(index: sender.selectedSegmentIndex)
            self.filterSegmentView.sectionTitles = flightSearchResultVM.segmentTitles(showSelection: true, selectedIndex: filterSegmentView.selectedSegmentIndex)
        }
        else {
            self.filterSegmentView.selectedSegmentIndex = HMSegmentedControlNoSegment
        }
    }
    
    //MARK:- Filter Mode UI Methods
    func flightResultHeadersViews( isHidden : Bool) {
        
        resultTitle.isHidden = isHidden
        resultsubTitle.isHidden = isHidden
        infoButton.isHidden = isHidden
        backButton.isHidden = isHidden
    }
    
    func removeFilterHeader() {
        flightResultHeadersViews(isHidden: false)
        
        doneButton.removeFromSuperview()
        doneButton = nil
        
        clearAllFiltersButton?.removeFromSuperview()
        clearAllFiltersButton = nil
        
        filterTitle.removeFromSuperview()
        
    }
    
    func createFilterTitle() {
        self.filterTitle = UILabel()
        self.filterTitle.font = UIFont(name: "SourceSansPro-Regular", size: 16.0)
        self.filterTitle.textColor = UIColor.ONE_FIVE_THREE_COLOR
        self.filterTitle.textAlignment = .center
        
    }
    
    func addFilterTitle() {
        
        visualEffectView.contentView.addSubview(self.filterTitle)
        self.filterTitle.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview()
            maker.height.equalTo(44.0)
            maker.top.equalTo(statusBarHeight)
            maker.centerX.equalToSuperview()
        }
    }
    
    
    func openFiltersWith( index : Int) {
        
        // Creating Filters Base View Controller
        if isIntReturnOrMCJourney {
            if intMCAndReturnFilterVC == nil {
                createFiltersBaseView(index: index)
            }
        } else {
            if self.flightFilterVC == nil {
                createFiltersBaseView(index : index)
            }
        }
        
        if let FilterBaseView = self.flightFilterVC {
            if FilterBaseView.parent == nil {
                var frame = self.view.frame
                frame.origin.y = statusBarHeight + 88
                frame.size.height = UIScreen.main.bounds.size.height - 88 - statusBarHeight 
                FilterBaseView.view.frame = frame
                self.view.addSubview(FilterBaseView.view)
                self.addChild(FilterBaseView)
                self.view.bringSubviewToFront(FilterBaseView.view)
                FilterBaseView.didMove(toParent: self)
                addFilterHeader()
            }
            
            FilterBaseView.selectedIndex = index
            
        }
        
        if let filterBaseView = self.intMCAndReturnFilterVC {
            if filterBaseView.parent == nil {
                var frame = self.view.frame
                frame.origin.y = statusBarHeight + 88
                frame.size.height = UIScreen.main.bounds.size.height - 88 - statusBarHeight
                filterBaseView.view.frame = frame
                self.view.addSubview(filterBaseView.view)
                self.addChild(filterBaseView)
                self.view.bringSubviewToFront(filterBaseView.view)
                filterBaseView.didMove(toParent: self)
                addFilterHeader()
            }
            filterBaseView.selectedIndex = index
            
        }
        
        self.filterSegmentView.selectionIndicatorColor = .AertripColor
        self.filterSegmentView.setNeedsDisplay()
        filterTitle.text = self.flightSearchResultVM.filterSummaryTitle
    }
    
    func removedFilterUIFromParent() {
        self.removeFilterHeader()
        self.filterSegmentView.selectionIndicatorColor = .clear
        self.filterSegmentView.sectionTitles = flightSearchResultVM.segmentTitles(showSelection: false, selectedIndex: filterSegmentView.selectedSegmentIndex)
        self.filterSegmentView.selectedSegmentIndex = HMSegmentedControlNoSegment
        
    }
    
}

extension FlightResultBaseViewController  : FlightResultViewModelDelegate , NoResultScreenDelegate {
    
    func showDepartReturnSame(_ show: Bool) {
        self.showDepartReturnSame = show
        intMCAndReturnFilterVC?.showDepartReturnSame = show
    }
    
    func clearFilters() {
        flightSearchResultVM.clearAllFilters()
        flightFilterVC?.resetAllFilters()
        intMCAndReturnFilterVC?.resetAllFilters()
    }
    
    func restartFlightSearch()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showNoFilteredResultsAt(index: Int) {
        
        self.filterTitle.text = self.flightSearchResultVM.filterSummaryTitle
        let flightType = flightSearchResultVM.flightSearchType
        
        switch flightType {
        case SINGLE_JOURNEY:
            singleJourneyResultVC?.showNoFilteredResults()
        case RETURN_JOURNEY:
            if flightSearchResultVM.isDomestic {
                domesticMultiLegResultVC?.showNoFilteredResults(index: index)
            }else {
                intMultiLegResultVC?.showNoFilteredResults()
            }
        case  MULTI_CITY:
            if flightSearchResultVM.isDomestic {
                domesticMultiLegResultVC?.showNoFilteredResults(index: index)
            }else {
                intMultiLegResultVC?.showNoFilteredResults()
            }
        default:
            return
        }
    }
    
    func filtersApplied(_ isApplied: Bool ) {
        
        clearAllFiltersButton?.isEnabled = isApplied
        filterButton.isSelected = isApplied
        
        filterSegmentView.sectionTitles = flightSearchResultVM.segmentTitles(showSelection: true, selectedIndex: filterSegmentView.selectedSegmentIndex)
    }
    
    
    
    func showNoResultScreenAt(index: Int) {
        
        let flightType = flightSearchResultVM.flightSearchType
        DispatchQueue.main.async {
            
            switch flightType {
            case SINGLE_JOURNEY:
                self.addNoResultScreen()
            case RETURN_JOURNEY:
                if self.flightSearchResultVM.isDomestic {
                    self.domesticMultiLegResultVC?.showNoResultScreenAt(index: index)
                }
                else {
                    self.addNoResultScreen()
                }
            case  MULTI_CITY:
                if self.flightSearchResultVM.isDomestic {
                    self.domesticMultiLegResultVC?.showNoResultScreenAt(index: index)
                }
                else {
                    self.addNoResultScreen()
                }
            default:
                return
            }
        }
        
    }
    
    private func addNoResultScreen() {
        self.ApiProgress.isHidden = true
        let noResultScreenForSearch = NoResultsScreenViewController()
        noResultScreenForSearch.delegate = self
        self.addChildView(noResultScreenForSearch)
        noResultScreenForSearch.noResultsScreen()
        self.noResultScreen = noResultScreenForSearch
    }
    
    func updatedResponseReceivedAt(index: Int , filterApplied : Bool) {
        
        guard let resultVM = self.flightSearchResultVM else  { return }
        self.filterTitle.text = self.flightSearchResultVM.filterSummaryTitle
        
        if !filterApplied {
            self.flightFilterVC?.flightResultArray = self.flightSearchResultVM.flightResultArray
            self.flightFilterVC?.updateInputFilters(flightResultArray: self.flightSearchResultVM.flightResultArray)
            
            
            self.intMCAndReturnFilterVC?.flightResultArray = self.flightSearchResultVM.intFlightResultArray
            self.intMCAndReturnFilterVC?.updateInputFilters(flightResultArray: self.flightSearchResultVM.intFlightResultArray)
        }
        
        let flightType = flightSearchResultVM.flightSearchType
        
        switch flightType {
        case SINGLE_JOURNEY:
            if let singleJourneyVC = self.singleJourneyResultVC {
                singleJourneyVC.updateWithArray( resultVM.getOnewayJourneyDisplayArray(), sortOrder: resultVM.getSortOrder())
                singleJourneyVC.updateAirportDetailsArray(resultVM.getOnewayAirportArray())
                singleJourneyVC.updateAirlinesDetailsArray(resultVM.getAirlineDetailsArray())
                singleJourneyVC.updateTaxesArray(resultVM.getTaxesDetailsArray())
                singleJourneyVC.addPlaceholderTableHeaderView()
                
            }
            
        case RETURN_JOURNEY:
            if flightSearchResultVM.isDomestic {
                let journeyArray = resultVM.getJourneyDisplayArrayFor(index:  index)
                //print(journeyArray[0].originIATACode)
                domesticMultiLegResultVC?.updateReceivedAt(index: index , updatedArray: journeyArray, sortOrder: resultVM.getSortOrder())
                domesticMultiLegResultVC?.updateAirportDetailsArray(resultVM.getAllAirportsArray())
                domesticMultiLegResultVC?.updateAirlinesDetailsArray(resultVM.getAirlineDetailsArray())
                domesticMultiLegResultVC?.updateTaxesArray(resultVM.getTaxesDetailsArray())
                
                if resultVM.comboResults.count > 0 {
                    domesticMultiLegResultVC?.comboResults = resultVM.comboResults
                }
            }
            else {
            filterUpdateWorkItem?.cancel()
            filterUpdateWorkItem = DispatchWorkItem {
                let journeyArray = resultVM.getIntJourneyDisplayArrayFor(index: index)
                guard let intMCAndReturnVC = self.intMultiLegResultVC else { return }
                intMCAndReturnVC.updateWithArray( journeyArray, sortOrder: resultVM.getSortOrder())
                intMCAndReturnVC.updateAirportDetailsArray(resultVM.getAllIntAirportsArray())
                intMCAndReturnVC.updateAirlinesDetailsArray(resultVM.getIntAirlineDetailsArray())
                intMCAndReturnVC.updateTaxesArray(resultVM.getTaxesDetailsArray())
                intMCAndReturnVC.addPlaceholderTableHeaderView()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: filterUpdateWorkItem!)
            }
            
        case  MULTI_CITY:
            if flightSearchResultVM.isDomestic {
                
                let journeyArray = self.flightSearchResultVM.getJourneyDisplayArrayFor(index: index )
                domesticMultiLegResultVC?.updateReceivedAt(index: index , updatedArray: journeyArray, sortOrder: self.flightSearchResultVM.getSortOrder())
                domesticMultiLegResultVC?.updateAirportDetailsArray(resultVM.getAllAirportsArray())
                domesticMultiLegResultVC?.updateAirlinesDetailsArray(resultVM.getAirlineDetailsArray())
                domesticMultiLegResultVC?.updateTaxesArray(resultVM.getTaxesDetailsArray())
                
            }
            else {
                filterUpdateWorkItem?.cancel()
                filterUpdateWorkItem = DispatchWorkItem(block: {
                    let journeyArray = resultVM.getIntJourneyDisplayArrayFor(index: index)
                    guard let intMCAndReturnVC = self.intMultiLegResultVC else { return }
                    intMCAndReturnVC.updateWithArray( journeyArray, sortOrder: resultVM.getSortOrder())
                    intMCAndReturnVC.updateAirportDetailsArray(resultVM.getAllIntAirportsArray())
                    intMCAndReturnVC.updateAirlinesDetailsArray(resultVM.getIntAirlineDetailsArray())
                    intMCAndReturnVC.updateTaxesArray(resultVM.getTaxesDetailsArray())
                    intMCAndReturnVC.addPlaceholderTableHeaderView()
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: filterUpdateWorkItem!)
            }
            
        default:
            return
        }
    }
    
    func applySorting(sortOrder : Sort, isConditionReverced : Bool, legIndex : Int){
        guard let intMCAndReturnVC = self.intMultiLegResultVC else { return }
        intMCAndReturnVC.applySorting(sortOrder: sortOrder, isConditionReverced: isConditionReverced, legIndex: legIndex, shouldReload : true, completion: {})
    }
    
    func webserviceProgressUpdated(progress: Float) {
        if progress > 0.25 {
            DispatchQueue.main.async {
                
                
                if self.ApiProgress.progress < progress {
                    self.ApiProgress.setProgress(progress, animated: true)
                }
                
                if progress == 1.0 {
                    self.ApiProgress.isHidden = true
                    self.singleJourneyResultVC?.addPlaceholderTableHeaderView()
                    
                    self.separatorView.snp.updateConstraints { (make) in
                        make.bottom.equalTo(self.visualEffectView.contentView).offset(0.0)
                    }
                }
            }
        }
    }
}