//
//  FlightFilterBaseViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 27/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

protocol  FilterDelegate : AnyObject {
    
}

protocol FilterUIDelegate : AnyObject
{
    func selectedIndexChanged(index : UInt)
    func removedFilterUIFromParent()
}

/// Base Class for Flight Filters
class FlightFilterBaseViewController: UIViewController
{
    //MARK:- Outlets
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var FilterTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var filterIndicatorView: UIImageView!
    @IBOutlet weak var backgroudView: UIView!
    
    //MARK:- State Properties
    weak var delegate : FilterDelegate?
    weak var filterUIDelegate : FilterUIDelegate?
    var legList : [Leg]!
    var searchType : FlightSearchType!
    var flightResultArray : [FlightsResults]!
    var userAppliedFilters: AppliedAndUIFilters?
    
    //MARK:- Computed Properties
    var selectedIndex  : Int! {
        didSet {
            setCurrentIndex()
        }
    }
    
    var inputFilters : [FiltersWS]? {
        var inputFiltersArray = [FiltersWS]()
        
        for flightsResult in flightResultArray {
            
            guard let fliters = flightsResult.f.last else { continue }
            inputFiltersArray.append(fliters)
        }
        
        return inputFiltersArray
    }
    
    //MARK:- Initializers
    convenience init(flightSearchResult : [FlightsResults] , selectedIndex :Int = 0 , legList : [Leg] , searchType: FlightSearchType) {
        self.init(nibName:nil, bundle:nil)
        self.flightResultArray = flightSearchResult
        self.selectedIndex = selectedIndex
        self.legList = legList
        self.searchType = searchType
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK:- ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBaseView()
        setupScrollView()
        
        for filter in Filters.allCases {
            self.addToScrollView(filter: filter)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setCurrentIndex()
    }
    
    //MARK:- Additional UI Methods
    /// Method to setup BaseView ( view with white Background and rounded corner )
    fileprivate func setupBaseView() {
        
        baseView.clipsToBounds = true
        baseView.layer.cornerRadius = 10
        if #available(iOS 11.0, *) {
            baseView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            baseView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        }
    }
    
    /// Setting up ViewController's view
    fileprivate func setupView() {
        self.view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnBaseView))
        self.backgroudView.addGestureRecognizer(tapGesture)
    }
    
    /// Setup for scrollview
    fileprivate func setupScrollView()
    {
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        let width =  UIScreen.main.bounds.size.width
        let height = self.scrollView.frame.height
        scrollView.contentSize = CGSize( width: (CGFloat(Filters.allCases.count) * width ), height:height)
    }
    
    fileprivate func addToScrollView(filter : Filters )
    {
        let width =  UIScreen.main.bounds.size.width
        let height = self.scrollView.frame.height
        let x = CGFloat(filter.rawValue) *  width
        let viewController = filter.viewController
        setValuesFor(viewController , filter: filter)
        viewController.view.frame = CGRect(x: x, y: 0, width: width, height :height)
        viewController.view.autoresizingMask = []
        self.scrollView.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    @objc func tapOnBaseView() {
        self.filterUIDelegate?.removedFilterUIFromParent()
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    fileprivate func setCurrentIndex() {
        let width = UIScreen.main.bounds.width
        let x = CGFloat(selectedIndex) * width
        let point = CGPoint(x: x, y: 0.0)
        if scrollView != nil {
            scrollView.setContentOffset(point, animated: true)
        }
    }
    
    //MARK:- Setting Filter ViewController's  values
    func resetAllFilters() {
        for viewController in self.children {
            if let sortViewController = viewController as? FlightSortFilterViewController {
                sortViewController.resetSort()
            }else{
                if let filterViewController = viewController as? FilterViewController {
                    filterViewController.resetFilter()
                }
            }
        }
    }
    
    func setValuesFor(_ uiViewController  : UIViewController , filter : Filters)
    {
        guard let filters = inputFilters else {
            return
        }
        
        switch filter {
        case .sort:
            if uiViewController is FlightSortFilterViewController {
                setSortVC(uiViewController as! FlightSortFilterViewController)
            }
            
        case .stops:
            if uiViewController is FlightStopsFilterViewController {
                setStopsVC(uiViewController as! FlightStopsFilterViewController, inputFilters: filters)
            }
            
        case .Times :
            if uiViewController is FlightFilterTimesViewController {
                setTimesVC(uiViewController as! FlightFilterTimesViewController, inputFilters: filters)
            }
            
        case .Duration:
            if uiViewController is FlightDurationFilterViewController {
                
                if searchType == RETURN_JOURNEY {
                    setDurationVCForReturnJourney(uiViewController as! FlightDurationFilterViewController, inputFilters: filters)
                }else {
                    setDurationVC(uiViewController as! FlightDurationFilterViewController, inputFilters: filters)
                }
            }
            
        case .Airlines:
            if uiViewController is AirlinesFilterViewController {
                
                if searchType == RETURN_JOURNEY {
                    setAirlineVCForReturnJourney(uiViewController as! AirlinesFilterViewController, inputFilters: filters)
                }else {
                    setAirlineVC( uiViewController as! AirlinesFilterViewController, inputFilters: filters)
                }
            }
            
        case .Price:
            if uiViewController is PriceFilterViewController {
                setPriceVC( uiViewController as! PriceFilterViewController, inputFilters: filters)
            }
            
        case .Airport:
            if uiViewController is AirportsFilterViewController {
                setAirportVC ( uiViewController as! AirportsFilterViewController, inputFilters: filters)
            }
            
        case .Quality:
            if uiViewController is QualityFilterViewController {
                setQualityFilterVC(uiViewController as! QualityFilterViewController)
            }
        }
    }
    
    func updateInputFilters( flightResultArray : [FlightsResults])
    {
        self.flightResultArray = flightResultArray
        guard let filters = inputFilters else { return }
        for viewController in self.children {
            
            if !(viewController is FilterViewController )  {
                continue
            }
            
            let VCclass = viewController.className
            
            switch VCclass {
            case AirlinesFilterViewController.className:
                if let airlineVC = viewController as? AirlinesFilterViewController {
                    updateAirlineVC(airlineVC, filters: filters )
                }
            case FlightFilterTimesViewController.className :
                if let timesFilterVC = viewController as? FlightFilterTimesViewController {
//                    updateTimesVC(TimesFilterVC, inputFilters: filters  )
                    updateFlightLegTimeFilters(timesFilterVC, inputFilters: filters)
                }
            case PriceFilterViewController.className :
                if let priceFilterVC = viewController as? PriceFilterViewController {
//                    setPriceVC( priceFilterVC, inputFilters: filters)
                    updatePriceVC(priceFilterVC, inputFilters: filters)
//                    priceFilterVC.updateUIPostLatestResults()
                }
            case FlightDurationFilterViewController.className :
                if let durationFilterVC = viewController as? FlightDurationFilterViewController {
                    updateDurationVC(durationFilterVC , inputFilters: filters)
//                    durationFilterVC.updateUIPostLatestResults()
                }
            case FlightStopsFilterViewController.className :
                if let stopVC = viewController as? FlightStopsFilterViewController {
                    setStopsVC(stopVC, inputFilters: filters)
                    stopVC.updateUIPostLatestResults()
                }
            case AirportsFilterViewController.className :
                if let airportFilter = viewController as? AirportsFilterViewController {
                    setAirportVC(airportFilter , inputFilters : filters)
                    airportFilter.updateUIPostLatestResults()
                }
            case QualityFilterViewController.className :
                if let qualityFilterVC = viewController as? QualityFilterViewController {
                    updateQualityFilter(qualityFilterVC)
                }
            default:
                print("Switch case missing for " + VCclass)
            }
        }
    }
    
    //MARK:- Sort
    func setSortVC(_ sortViewController : FlightSortFilterViewController) {
        sortViewController.delegate = delegate as? SortFilterDelegate
    }
    
    // MARK:- Stops
    func setStopsVC(_ stopsViewController  : FlightStopsFilterViewController , inputFilters : [FiltersWS])
    {
        var allLegsStops = [StopsFilter]()
        for fliter in inputFilters
        {
            let stopsStringArray = fliter.stp
            let stops : [Int] = stopsStringArray.map({Int($0) ?? 0})
            
            let stopFilter = StopsFilter(stops: stops)
            allLegsStops.append(stopFilter)
        }
        
        if searchType == RETURN_JOURNEY {
            
            var reducedStops  = allLegsStops.reduce([], { $0 + $1.availableStops })
            let reducedStopsSet = Set(reducedStops)
            reducedStops = Array(reducedStopsSet).sorted()
            stopsViewController.allStopsFilters = [StopsFilter(stops:reducedStops )]
            stopsViewController.allLegNames = [legList[0]]
            stopsViewController.showingForReturnJourney = true
        }else {
            stopsViewController.allStopsFilters = allLegsStops
            stopsViewController.allLegNames = legList
            stopsViewController.showingForReturnJourney = false
        }
        
        stopsViewController.delegate = delegate as? FlightStopsFilterDelegate
    }
    
    //MARK:- Times
    
    func updateTimesVC(_ timesViewController : FlightFilterTimesViewController, inputFilters : [FiltersWS]){
        timesViewController.multiLegTimerFilter = getFlightLegTimeFilters( inputFilters)
        timesViewController.updateUIPostLatestResults()
    }
    
    func setTimesVC(_ timesViewController : FlightFilterTimesViewController , inputFilters : [FiltersWS])
    {
        timesViewController.multiLegTimerFilter = getFlightLegTimeFilters( inputFilters)
        timesViewController.delegate = delegate as? FlightTimeFilterDelegate
    }
    
    
    func getFlightLegTimeFilters(_ inputFilters : [FiltersWS]) -> [FlightLegTimeFilter]
    {
        var flightLegTimeFilters = [FlightLegTimeFilter]()
        
        for index in 0 ..< inputFilters.count {
            
            let leg = legList[index]
            let filter = inputFilters[index]
            
            let departureTime = filter.depDt
            let arrivalTime = filter.arDt
            
            let departureMin = departureTime.earliest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: false, interval: 3600)
            let departureMax = departureTime.latest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: true, interval: 3600)!
            let arrivalMin = arrivalTime.earliest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: false, interval: 3600)!
            let arrivalMax = arrivalTime.latest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: true, interval: 3600)
            
            let flightLegFilter =  FlightLegTimeFilter(leg:leg, departureStartTime:  departureMin!, departureMaxTime: departureMax, arrivalStartTime: arrivalMin, arrivalEndTime: arrivalMax! )
            flightLegTimeFilters.append(flightLegFilter)
            
        }
        return flightLegTimeFilters
    }
    
    func updateFlightLegTimeFilters(_ timesViewController : FlightFilterTimesViewController, inputFilters : [FiltersWS]) {
                
        for index in 0 ..< inputFilters.count {
            
            let leg = legList[index]
            let filter = inputFilters[index]
            
            let departureTime = filter.depDt
            let arrivalTime = filter.arDt
            
            let departureMin = departureTime.earliest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: false, interval: 3600)
            let departureMax = departureTime.latest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: true, interval: 3600)!
            let arrivalMin = arrivalTime.earliest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: false, interval: 3600)!
            let arrivalMax = arrivalTime.latest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: true, interval: 3600)
            
            let newFlightLegFilter =  FlightLegTimeFilter(leg:leg, departureStartTime:  departureMin!, departureMaxTime: departureMax, arrivalStartTime: arrivalMin, arrivalEndTime: arrivalMax! )
            
            if let userFilters = userAppliedFilters, userFilters.appliedFilters[index].contains(.Times), timesViewController.multiLegTimerFilter.indices.contains(index) {
                
                if userFilters.appliedSubFilters[index].contains(.departureTime) {
                    timesViewController.multiLegTimerFilter[index].departureMinTime = newFlightLegFilter.departureMinTime
                    
                    timesViewController.multiLegTimerFilter[index].departureTimeMax = newFlightLegFilter.departureTimeMax
                }
                
                if userFilters.appliedSubFilters[index].contains(.arrivalTime) {
                    timesViewController.multiLegTimerFilter[index].arrivalStartTime = newFlightLegFilter.arrivalStartTime
                    
                    timesViewController.multiLegTimerFilter[index].arrivalEndTime = newFlightLegFilter.arrivalEndTime
                }
                
            } else {
                timesViewController.multiLegTimerFilter[index] = newFlightLegFilter
            }
            timesViewController.updateFiltersFromAPI()
        }
    }
    
    //MARK:- Duration
    func updateDurationVC(_ durationVC : FlightDurationFilterViewController , inputFilters : [FiltersWS])
    {
        if searchType == RETURN_JOURNEY {
            updateDurationFilterForReturnJourney(durationVC, inputFilters: inputFilters)
        } else {
            updateDurationFilter(durationVC, inputFilters: inputFilters)
        }
//        let durationLegFilters : [DurationFilter]
//        if searchType == RETURN_JOURNEY {
//            let durationLegFilter = self.createDurationFilterArrayReturnJourney(inputFilters: inputFilters)
//            durationLegFilters = [durationLegFilter]
//        }else {
//            durationLegFilters = self.createDurationFilterArray(inputFilters: inputFilters)
//        }
//
//        durationVC.durationFilters = durationLegFilters
//        if durationLegFilters.count>0{
//            durationVC.currentDurationFilter = durationLegFilters[0]
//        }
    }
    
    func createDurationFilterArray(inputFilters : [FiltersWS]) ->  [DurationFilter] {
        var durationFilters = [DurationFilter]()
        
        for index in 0 ..< inputFilters.count {
            
            let filter = inputFilters[index]
            let tripTime = filter.tt
            let layoverTime = filter.lott
            var duration : Float
            
            guard let tripTimeMinDuration = tripTime.minTime else { continue }
            duration = (tripTimeMinDuration as NSString).floatValue
            let trimMinDuration = CGFloat( floor(duration / 3600.0 ))
            
            guard let tripTimeMaxDuration = tripTime.maxTime else { continue }
            duration = (tripTimeMaxDuration as NSString).floatValue
            let tripMaxDuration = CGFloat( round(duration / 3600.0))
            
            guard let layoverMinDuration = layoverTime?.minTime else { continue }
            duration = ( layoverMinDuration as NSString).floatValue
            let layoverMin = CGFloat(floor( duration / 3600.0 ))
            
            guard let layoverMaxDuration = layoverTime?.maxTime else { continue }
            duration = ( layoverMaxDuration as NSString).floatValue
            let layoverMax = CGFloat( round(duration / 3600.0))
            
            let leg = legList[index]
            let durationFilter = DurationFilter(leg: leg, tripMin: trimMinDuration, tripMax: tripMaxDuration, layoverMin: layoverMin, layoverMax: layoverMax, layoverMinTimeFormat: "")
            
            durationFilters.append(durationFilter)
        }
        
        return durationFilters
    }
    
    func createDurationFilterArrayReturnJourney( inputFilters : [FiltersWS]) -> DurationFilter {
        var tripDurationMin : CGFloat  = CGFloat.greatestFiniteMagnitude
        var tripDurationMax : CGFloat = 0.0
        
        var layoverDurationMin : CGFloat = CGFloat.greatestFiniteMagnitude
        var layoverMaxDuration : CGFloat = 0.0
        
        
        for filter in inputFilters {
            
            let tripTime = filter.tt
            let layoverTime = filter.lott
            var duration : Float
            
            guard let tripTimeMinDuration = tripTime.minTime else { continue }
            duration = (tripTimeMinDuration as NSString).floatValue
            let tripMin = CGFloat( floor(duration / 3600.0 ))
            
            
            // tripDurationMinDuration is set to max value initially, whenever tripMinDuration is less than tripDurationMinDuration , tripMinDuration is assigned to tripDurationMinDuration
            // This logic works for first loop as well as in second iteration if tripMinDuration is less than tripDurationMinDuration.
            if tripMin < tripDurationMin {
                tripDurationMin = tripMin
            }
            
            guard let tripTimeMaxDuration = tripTime.maxTime else { continue }
            duration = (tripTimeMaxDuration as NSString).floatValue
            let tripMax = CGFloat( ceil(duration / 3600.0))
            
            
            // tripDurationMax is set to 0.0 value initially, whenever tripMax is more than tripDurationMax , tripMax is assigned to tripDurationMax
            // This logic works for first loop as well as in second iteration if tripMax is more than tripDurationMax.
            
            if tripDurationMax < tripMax {
                tripDurationMax = tripMax
            }
            
            guard let layoverMinDuration = layoverTime?.minTime else { continue }
            duration = ( layoverMinDuration as NSString).floatValue
            let layoverMin = CGFloat(floor( duration / 3600.0 ))
            
            // layoverDurationMinDuration is set to max value initially, whenever layoverMin is less than layoverDurationMinDuration , layoverMin is assigned to layoverDurationMinDuration
            // This logic works for first loop as well as in second iteration if layoverMin is less than layoverDurationMinDuration.
            
            if layoverMin < layoverDurationMin {
                layoverDurationMin = layoverMin
            }
            
            guard let layoverMaxString = layoverTime?.maxTime else { continue }
            duration = ( layoverMaxString as NSString).floatValue
            let layoverMax = CGFloat( ceil(duration / 3600.0))
            
            // layoverMaxDuration is set to 0.0 value initially, whenever layoverMax is more than layoverMaxDuration , layoverMax is assigned to layoverMaxDuration
            // This logic works for first loop as well as in second iteration if layoverMax is more than layoverMax.
            
            if layoverMaxDuration < layoverMax {
                layoverMaxDuration = layoverMax
            }
        }
        
        let durationFilter = DurationFilter(leg: legList[0], tripMin: tripDurationMin, tripMax: tripDurationMax, layoverMin: layoverDurationMin, layoverMax: layoverMaxDuration,layoverMinTimeFormat:"")
        
        return durationFilter
    }
    
    private func updateDurationFilterForReturnJourney(_ durationViewController : FlightDurationFilterViewController, inputFilters : [FiltersWS]) {
        
        var tripDurationMin : CGFloat  = CGFloat.greatestFiniteMagnitude
        var tripDurationMax : CGFloat = 0.0
        
        var layoverDurationMin : CGFloat = CGFloat.greatestFiniteMagnitude
        var layoverMaxDuration : CGFloat = 0.0
        
        
        for filter in inputFilters {
            
            let tripTime = filter.tt
            let layoverTime = filter.lott
            var duration : Float
            
            guard let tripTimeMinDuration = tripTime.minTime else { continue }
            duration = (tripTimeMinDuration as NSString).floatValue
            let tripMin = CGFloat( floor(duration / 3600.0 ))
            
            
            // tripDurationMinDuration is set to max value initially, whenever tripMinDuration is less than tripDurationMinDuration , tripMinDuration is assigned to tripDurationMinDuration
            // This logic works for first loop as well as in second iteration if tripMinDuration is less than tripDurationMinDuration.
            if tripMin < tripDurationMin {
                tripDurationMin = tripMin
            }
            
            guard let tripTimeMaxDuration = tripTime.maxTime else { continue }
            duration = (tripTimeMaxDuration as NSString).floatValue
            let tripMax = CGFloat( ceil(duration / 3600.0))
            
            
            // tripDurationMax is set to 0.0 value initially, whenever tripMax is more than tripDurationMax , tripMax is assigned to tripDurationMax
            // This logic works for first loop as well as in second iteration if tripMax is more than tripDurationMax.
            
            if tripDurationMax < tripMax {
                tripDurationMax = tripMax
            }
            
            guard let layoverMinDuration = layoverTime?.minTime else { continue }
            duration = ( layoverMinDuration as NSString).floatValue
            let layoverMin = CGFloat(floor( duration / 3600.0 ))
            
            // layoverDurationMinDuration is set to max value initially, whenever layoverMin is less than layoverDurationMinDuration , layoverMin is assigned to layoverDurationMinDuration
            // This logic works for first loop as well as in second iteration if layoverMin is less than layoverDurationMinDuration.
            
            if layoverMin < layoverDurationMin {
                layoverDurationMin = layoverMin
            }
            
            guard let layoverMaxString = layoverTime?.maxTime else { continue }
            duration = ( layoverMaxString as NSString).floatValue
            let layoverMax = CGFloat( ceil(duration / 3600.0))
            
            // layoverMaxDuration is set to 0.0 value initially, whenever layoverMax is more than layoverMaxDuration , layoverMax is assigned to layoverMaxDuration
            // This logic works for first loop as well as in second iteration if layoverMax is more than layoverMax.
            
            if layoverMaxDuration < layoverMax {
                layoverMaxDuration = layoverMax
            }
        }
        
        let durationFilter = DurationFilter(leg: legList[0], tripMin: tripDurationMin, tripMax: tripDurationMax, layoverMin: layoverDurationMin, layoverMax: layoverMaxDuration,layoverMinTimeFormat:"")
        
        
        if let userFilters = userAppliedFilters, userFilters.appliedFilters[0].contains(.Duration) {
            
            if userFilters.appliedSubFilters[0].contains(.tripDuration) {
                durationViewController.durationFilters[0].tripDurationMinDuration = tripDurationMin
                durationViewController.durationFilters[0].tripDurationmaxDuration = tripDurationMax
            }
            
            if userFilters.appliedSubFilters[0].contains(.layoverDuration) {
                durationViewController.durationFilters[0].layoverMinDuration = layoverDurationMin
                durationViewController.durationFilters[0].layoverMaxDuration = layoverMaxDuration
            }
            
        } else {
            durationViewController.durationFilters = [durationFilter]
        }
        durationViewController.updateFiltersFromAPI()
    }
    
    private func updateDurationFilter(_ durationViewController : FlightDurationFilterViewController , inputFilters : [FiltersWS]) {
        
        for index in 0 ..< inputFilters.count {
            
            let filter = inputFilters[index]
            let tripTime = filter.tt
            let layoverTime = filter.lott
            var duration : Float
            
            guard let tripTimeMinDuration = tripTime.minTime else { continue }
            duration = (tripTimeMinDuration as NSString).floatValue
            let tripMinDuration = CGFloat( floor(duration / 3600.0 ))
            
            guard let tripTimeMaxDuration = tripTime.maxTime else { continue }
            duration = (tripTimeMaxDuration as NSString).floatValue
            let tripMaxDuration = CGFloat( round(duration / 3600.0))
            
            guard let layoverMinDuration = layoverTime?.minTime else { continue }
            duration = ( layoverMinDuration as NSString).floatValue
            let layoverMin = CGFloat(floor( duration / 3600.0 ))
            
            guard let layoverMaxDuration = layoverTime?.maxTime else { continue }
            duration = ( layoverMaxDuration as NSString).floatValue
            let layoverMax = CGFloat( round(duration / 3600.0))
            
            let leg = legList[index]
            let durationFilter = DurationFilter(leg: leg, tripMin: tripMinDuration, tripMax: tripMaxDuration, layoverMin: layoverMin, layoverMax: layoverMax, layoverMinTimeFormat: "")
            
            if let userFilters = userAppliedFilters, userFilters.appliedFilters[index].contains(.Duration) {
                
                if userFilters.appliedSubFilters[index].contains(.tripDuration) {
                    durationViewController.durationFilters[index].tripDurationMinDuration = tripMinDuration
                    durationViewController.durationFilters[index].tripDurationmaxDuration = tripMaxDuration
                }
                
                if userFilters.appliedSubFilters[index].contains(.layoverDuration) {
                    durationViewController.durationFilters[index].layoverMinDuration = layoverMin
                    durationViewController.durationFilters[index].layoverMaxDuration = layoverMax
                }
                
            } else {
                durationViewController.durationFilters[index] = durationFilter
            }
            durationViewController.updateFiltersFromAPI()
        }
    }
    
    func setDurationVC(_ durationViewController : FlightDurationFilterViewController , inputFilters : [FiltersWS])
    {
        durationViewController.showingForReturnJourney = false
        durationViewController.legsArray = legList
        let durationFilters = createDurationFilterArray(inputFilters: inputFilters)
        durationViewController.durationFilters = durationFilters
        if durationFilters.count > 0{
            durationViewController.currentDurationFilter = durationFilters[0]
        }
        durationViewController.delegate = delegate as? FlightDurationFilterDelegate
    }
    
    func setDurationVCForReturnJourney(_ durationViewController : FlightDurationFilterViewController , inputFilters : [FiltersWS]) {
        
        durationViewController.showingForReturnJourney = true
        durationViewController.legsArray = [legList[0]]
        let durationFilter = createDurationFilterArrayReturnJourney(inputFilters: inputFilters)
        durationViewController.durationFilters = [durationFilter]
        durationViewController.currentDurationFilter = durationFilter
        durationViewController.legsArray = [legList[0]]
        durationViewController.delegate = delegate as? FlightDurationFilterDelegate
    }
    
    //MARK:- Airline
    fileprivate func createAirlineFiltersArray(inputFilters : [FiltersWS]) -> [AirlineLegFilter] {
        
        var airlineFilters = [AirlineLegFilter]()
        
        for  index in 0 ..< inputFilters.count {
            
            let filter = inputFilters[index]
            
            let airlineDetail = flightResultArray[index].aldet
            let multiAL = filter.multiAl
            var airlineArray = [Airline]()
            
            for (code , name) in airlineDetail {
                let tempAirline = Airline(name: name, code: code)
                airlineArray.append(tempAirline)
            }
            let leg = legList[index]
            let airlineLegFilter = AirlineLegFilter( leg: leg, airlinesArray: airlineArray, multiAl: multiAL ?? 0 )
            
            airlineFilters.append(airlineLegFilter)
        }
        return airlineFilters
    }
    
    fileprivate func setAirlineVC( _ airlineViewController : AirlinesFilterViewController , inputFilters : [FiltersWS]) {
        
        let airlineFilters = self.createAirlineFiltersArray(inputFilters: inputFilters)
        airlineViewController.airlinesFilterArray = airlineFilters
        airlineViewController.currentSelectedAirlineFilter = airlineFilters[0]
        airlineViewController.showingForReturnJourney = false
        airlineViewController.delegate = delegate as? AirlineFilterDelegate
    }
    
    fileprivate func createAirlineFilterForReturnJourney(inputFilters : [FiltersWS]) -> AirlineLegFilter {
        
        var multiAL = 0
        var airlineSet = Set<Airline>()
        
        for  index in 0 ..< inputFilters.count {
            
            let filter = inputFilters[index]
            multiAL = multiAL + (filter.multiAl ?? 0)
            let airlineDetail = flightResultArray[index].aldet
            
            for (code , name) in airlineDetail {
                let tempAirline = Airline(name: name, code: code)
                airlineSet.insert(tempAirline)
            }
        }
        
        let airlineArray = Array(airlineSet)
        multiAL = max(1, multiAL)
        let leg = legList[0]
        let airlineLegFilter = AirlineLegFilter( leg: leg, airlinesArray: airlineArray, multiAl: multiAL )
        return airlineLegFilter
        
    }
    
    fileprivate func setAirlineVCForReturnJourney( _ airlineViewController : AirlinesFilterViewController , inputFilters : [FiltersWS])
    {
        let airlineLegFilter = self.createAirlineFilterForReturnJourney(inputFilters: inputFilters)
        airlineViewController.airlinesFilterArray  = [airlineLegFilter]
        airlineViewController.currentSelectedAirlineFilter = airlineLegFilter
        airlineViewController.showingForReturnJourney = true
        airlineViewController.delegate = delegate as? AirlineFilterDelegate
        
    }
    
    fileprivate func updateAirlineVC(_ airlineVC: AirlinesFilterViewController , filters: [FiltersWS]) {
        let airlineFilters : [AirlineLegFilter]
        if searchType == RETURN_JOURNEY {
            let airlineLegFilter = self.createAirlineFilterForReturnJourney(inputFilters: filters)
            airlineFilters = [airlineLegFilter]
        }
        else {
            airlineFilters = self.createAirlineFiltersArray(inputFilters: filters)
        }
        
        airlineVC.airlinesFilterArray = airlineFilters
        airlineVC.currentSelectedAirlineFilter = airlineFilters[0]
        airlineVC.updateUIPostLatestResults()
    }
    
    //MARK:- Price
    func setPriceVC(_ priceViewController : PriceFilterViewController , inputFilters : [FiltersWS])
    {
        priceViewController.delegate = delegate as? PriceFilterDelegate
        var priceFilters = [PriceFilter]()
        
        for filter in inputFilters {
            
            let priceWS = filter.pr
            let priceFilter = PriceFilter(onlyRefundableFaresSelected: false,
                                          inputFareMinValue: CGFloat(priceWS.minPrice) ,
                                          inputFareMaxVaule: CGFloat(priceWS.maxPrice) ,
                                          userSelectedFareMinValue: CGFloat(priceWS.minPrice) ,
                                          userSelectedFareMaxValue: CGFloat(priceWS.maxPrice) )
            
            priceFilters.append(priceFilter)
        }
        
        priceViewController.flightResultArray = flightResultArray
        priceViewController.legsArray = legList
        priceViewController.allPriceFilters = priceFilters
        priceViewController.currentPriceFilter = priceFilters[0]
    }
    
    func updatePriceVC(_ priceViewController : PriceFilterViewController , inputFilters : [FiltersWS]) {
                
        for (index, filter) in inputFilters.enumerated() {
            let newPriceWS = filter.pr
            let newPriceFilter = PriceFilter(onlyRefundableFaresSelected: false,
            inputFareMinValue: CGFloat(newPriceWS.minPrice) ,
            inputFareMaxVaule: CGFloat(newPriceWS.maxPrice) ,
            userSelectedFareMinValue: CGFloat(newPriceWS.minPrice) ,
            userSelectedFareMaxValue: CGFloat(newPriceWS.maxPrice) )
            
            if let userFilters = userAppliedFilters, userFilters.appliedFilters[index].contains(.Price), priceViewController.allPriceFilters.indices.contains(index) {
                priceViewController.allPriceFilters[index].inputFareMinValue = newPriceFilter.inputFareMinValue
                
                priceViewController.allPriceFilters[index].inputFareMaxVaule = newPriceFilter.inputFareMaxVaule
            } else {
                priceViewController.allPriceFilters[index] = newPriceFilter
            }
            priceViewController.updateFiltersFromAPI()
        }
    }
    
    //MARK:- Airport
    func setAirportVC(_ airportViewController : AirportsFilterViewController , inputFilters : [FiltersWS])
    {
        var airportLegFilters = [AirportLegFilter]()
        
        for index in 0 ..< inputFilters.count {
            
            let filter = inputFilters[index]
            let airports = filter.cityapN
            
            let airportsDetails = flightResultArray[index].apdet
            
            let fromAirports = airports.fr
            let toAirports = airports.to
            
            var originAirports = [AirportsGroupedByCity]()
            var destinationAirports = [AirportsGroupedByCity]()
            var layoverAirportsDisplayModelArray = [LayoverDisplayModel]()
            
            for city in fromAirports {
                
                let airportCodes = city.value
                
                var airportsArray = [Airport]()
                var cityName = city.key
                for airportcode in airportCodes {
                    
                    let airport = airportsDetails[airportcode]
                    
                    let name = airport?.n
                    guard let airportCity = airport?.c else { continue }
                    cityName = airportCity
                    let airportCode = airportcode
                    
                    let displayModel = Airport(name : name!, IATACode:airportCode, city: airportCity )
                    airportsArray.append(displayModel)
                }
                originAirports.append( AirportsGroupedByCity(name: cityName, airports: airportsArray))
            }
            
            for city in toAirports {
                
                let airportCodes = city.value
                
                var airportsArray = [Airport]()
                var cityName = city.key
                for airportcode in airportCodes {
                    
                    if  let airport = airportsDetails[airportcode] {
                        
                        let name = airport.n
                        let city = airport.c
                        cityName = city!
                        let airportCode = airportcode
                        
                        let displayModel = Airport(name : name!, IATACode:airportCode, city: city! )
                        airportsArray.append(displayModel)
                    }
                }
                destinationAirports.append( AirportsGroupedByCity(name: cityName, airports: airportsArray))
            }
            
            let layoverAirportsCode = filter.loap
            
            var country : String
            for layoverAirport in  layoverAirportsCode {
                
                if let airport = airportsDetails[layoverAirport] {
                    let name = airport.n
                    country = airport.cname!
                    let city = airport.c
                    let airportCode = layoverAirport
                    
                    var layouverAirportsArray = [Airport]()
                    let displayModel = Airport(name : name!, IATACode:airportCode, city: city! )
                    layouverAirportsArray.append(displayModel)
                    let layoverDisplayModel =  LayoverDisplayModel(country: country, airports:layouverAirportsArray)
                    
                    if layoverAirportsDisplayModelArray.count > 0 {
                        
                        if let row = layoverAirportsDisplayModelArray.firstIndex(where: {$0.country == country}) {
                            
                            var airportsArray =  layoverAirportsDisplayModelArray[row].airports
                            airportsArray.append(displayModel)
                            
                            airportsArray = airportsArray.sorted(by: { $0.IATACode < $1.IATACode })
                            layoverAirportsDisplayModelArray[row] = LayoverDisplayModel(country: country, airports:airportsArray)
                        }
                        else {
                            layoverAirportsDisplayModelArray.append(layoverDisplayModel)
                        }
                    }
                    else {
                        layoverAirportsDisplayModelArray.append(layoverDisplayModel)
                    }
                }
            }
            
            layoverAirportsDisplayModelArray = layoverAirportsDisplayModelArray.sorted(by: { $0.country < $1.country })
            
            let leg = legList[index]
            let airportLegFilter =  AirportLegFilter(leg:leg, originCities: originAirports, destinationCities: destinationAirports, layoverCities: layoverAirportsDisplayModelArray)
            
            airportLegFilters.append(airportLegFilter)
        }
        
        airportViewController.airportFilterArray = airportLegFilters
        airportViewController.currentAirportFilter = airportLegFilters[0]
        airportViewController.delegate = delegate as? AirportFilterDelegate
        airportViewController.searchType = self.searchType
    }
    
    //MARK:- Quality
    func setQualityFilterVC(_ qualityViewController : QualityFilterViewController)
    {
        qualityViewController.delegate = delegate as? QualityFilterDelegate
        
        guard let flightQuality = inputFilters?.first?.fq else { return }
        
        var qualityFilterArray = [QualityFilter]()
        for ( key , value ) in flightQuality {
            
            var selectedFilter = UIFilters.refundableFares
            for filter in UIFilters.allCases {
                
                if filter.title == value {
                    selectedFilter = filter
                    break
                }
            }
            
            // Longer and expensive flights as filter will not added as quality filter
            if selectedFilter == UIFilters.hideLongerOrExpensive {
                continue
            }
            
            assert(selectedFilter != .refundableFares, "Quailty Filter title and UIFilter Title did not match for " + value )
            let filter = QualityFilter(name: value, filterKey: key, isSelected: false, filterID: selectedFilter)
            qualityFilterArray.append(filter)
        }
        
        qualityViewController.qualityFilterArray = qualityFilterArray
    }
    
    private func updateQualityFilter(_ qualityViewController : QualityFilterViewController) {
        
        guard let flightQuality = inputFilters?.first?.fq else { return }
        
        for ( key , value ) in flightQuality {
            
            var filterToAdd = UIFilters.refundableFares
            for filter in UIFilters.allCases {
                
                if filter.title == value {
                    filterToAdd = filter
                    break
                }
            }
            
            // Longer and expensive flights as filter will not added as quality filter
            if filterToAdd == UIFilters.hideLongerOrExpensive {
                continue
            }
            
            assert(filterToAdd != .refundableFares, "Quailty Filter title and UIFilter Title did not match for " + value )
            let filter = QualityFilter(name: value, filterKey: key, isSelected: false, filterID: filterToAdd)
            
            if qualityViewController.qualityFilterArray.contains(where: { $0.filterID == filter.filterID }) {
                
            } else {
                qualityViewController.qualityFilterArray.append(filter)
            }
        }
        qualityViewController.updateUIPostLatestResults()
    }
}

extension FlightFilterBaseViewController : UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.frame.size.width
        filterUIDelegate?.selectedIndexChanged(index: UInt(index))
    }
}
