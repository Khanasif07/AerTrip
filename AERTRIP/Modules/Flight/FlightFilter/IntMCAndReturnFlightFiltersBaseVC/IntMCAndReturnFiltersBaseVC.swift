//
//  IntMCAndReturnFiltersBaseVC.swift
//  AERTRIP
//
//  Created by Rishabh on 20/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment

class IntMCAndReturnFiltersBaseVC: UIViewController {
    
    // MARK: Properties
    weak var delegate : FilterDelegate?
    weak var filterUIDelegate : FilterUIDelegate?
    weak var toastDelegate: FlightFiltersToastDelegate?
    var legList : [Leg]!
    var searchType : FlightSearchType!
    var flightResultArray : [IntMultiCityAndReturnWSResponse.Results]!
    var selectedIndex : Int!
    var userAppliedFilters: AppliedAndUIFilters?
    
    var showDepartReturnSame = false {
        didSet {
            let viewCon = Filters.Airport.viewController
            if let airportVC = viewCon as? AirportsFilterViewController {
                airportVC.areAllDepartReturnNotSame = showDepartReturnSame
            }
        }
    }
    
    var inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]? {
        var inputFiltersArray = [IntMultiCityAndReturnWSResponse.Results.F]()
        
        for flightsResult in flightResultArray {
            
            //            guard let fliters = flightsResult.f.last else { continue }
            //            inputFiltersArray.append(fliters)
            let filters = flightsResult.f.map { $0 }
            inputFiltersArray.append(contentsOf: filters)
        }
        
        return inputFiltersArray
    }
    
    // Parchment View
    internal var allChildVCs = [UIViewController]()
    var menuItems = [MenuItemForFilter]()
    fileprivate var parchmentView : FiltersCustomPagingViewController?
    internal var showSelectedFontOnMenu = false
    
    // MARK: IBOutlets
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var closeFiltersBtn: UIButton!
    @IBOutlet weak var filtersView: UIView!
    
    //MARK:- Initializers
    convenience init(flightSearchResult : [IntMultiCityAndReturnWSResponse.Results] , selectedIndex :Int = 0 , legList : [Leg] , searchType: FlightSearchType) {
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
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        parchmentView?.view.frame = self.filtersView.bounds
        parchmentView?.view.roundParticularCorners(10, [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        self.parchmentView?.loadViewIfNeeded()
    }
    
    //MARK: IBActions
    @IBAction func closeFiltersBtnAction(_ sender: UIButton) {
        filterUIDelegate?.removedFilterUIFromParent()
    }
    
    //MARK:- Additional UI Methods
    /// Method to setup BaseView ( view with white Background and rounded corner )
    private func initialSetup() {
        for filter in Filters.allCases {
            self.addToParchment(filter: filter)
        }
        setUpViewPager()
        setupBaseView()
    }
    
    func selectSortVC() {
        parchmentView?.select(index: 0, animated: false)
    }
    
    fileprivate func setupBaseView() {
        
        //        baseView.clipsToBounds = true
        //        baseView.layer.cornerRadius = 10
        //        if #available(iOS 11.0, *) {
        //            baseView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        //        } else {
        //            baseView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        //        }
        filtersView.roundParticularCorners(10, [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
    
    fileprivate func addToParchment(filter : Filters)
    {
        var viewController = filter.viewController
        if viewController is FlightSortFilterViewController {
            viewController = filter.intReturnOrMCSortVC
        }
        allChildVCs.append(viewController)
        let newMenuItem = MenuItemForFilter(title: filter.title, index: filter.rawValue + 1, isSelected: false)
        menuItems.append(newMenuItem)
        setValuesFor(viewController , filter: filter)
        viewController.loadViewIfNeeded()
    }
    
    private func setUpViewPager() {
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        setupParchmentPageController()
    }
    
    private func setupParchmentPageController(){
        
        self.parchmentView = FiltersCustomPagingViewController()
        self.parchmentView?.menuItemSpacing = 18
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 0, bottom: 0.0, right: 10)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 45)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets.zero)
        self.parchmentView?.borderOptions = PagingBorderOptions.hidden
        let nib = UINib(nibName: "MenuItemFilterCollCell", bundle: nil)
        self.parchmentView?.register(nib, for: MenuItemForFilter.self)
        self.parchmentView?.borderColor = .clear//AppColors.themeGray20
        self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.selectedFont = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.indicatorColor = .clear
        self.parchmentView?.selectedTextColor = AppColors.themeBlack
        self.filtersView.addSubview(self.parchmentView!.view)
        
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
        self.parchmentView?.menuBackgroundColor = .clear
    }
    
    func toggleSelectedState(hidden: Bool) {
        showSelectedFontOnMenu = !hidden
        if hidden {
            self.parchmentView?.selectedFont = AppFonts.Regular.withSize(16.0)//AppFonts.SemiBold.withSize(16.0)
            self.parchmentView?.indicatorColor = .clear//AppColors.themeGreen
        } else {
            self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
            self.parchmentView?.indicatorColor = AppColors.themeGreen
        }
        parchmentView?.reloadMenu()
    }
    
    /// Temporary method to update all the data
    //    func resetData() {
    //        allChildVCs.removeAll()
    //        menuItems.removeAll()
    //        for filter in Filters.allCases {
    //            self.addToParchment(filter: filter)
    //        }
    //        parchmentView?.reloadData()
    //    }
    
    
    //MARK:- Setting Filter ViewController's  values
    func resetAllFilters() {
        for viewController in allChildVCs {
            if let filterViewController = viewController as? FilterViewController {
                filterViewController.resetFilter()
            }
        }
    }
    
    func updateMenuItems() {
        guard let filters = userAppliedFilters else { return }
        menuItems[Filters.sort.rawValue].isSelected = filters.appliedFilters[0].contains(.sort)
        menuItems[Filters.stops.rawValue].isSelected = filters.appliedFilters[0].contains(.stops)
        menuItems[Filters.Times.rawValue].isSelected = filters.appliedFilters[0].contains(.Times)
        menuItems[Filters.Duration.rawValue].isSelected = filters.appliedFilters[0].contains(.Duration)
        menuItems[Filters.Airlines.rawValue].isSelected = filters.appliedFilters[0].contains(.Airlines)
        menuItems[Filters.Airport.rawValue].isSelected = filters.appliedFilters[0].contains(.Airport)
        menuItems[Filters.Quality.rawValue].isSelected = filters.appliedFilters[0].contains(.Quality)
        menuItems[Filters.Price.rawValue].isSelected = filters.appliedFilters[0].contains(.Price)
        parchmentView?.reloadMenu()
    }
    
    func setValuesFor(_ uiViewController  : UIViewController , filter : Filters)
    {
        guard let filters = inputFilters else {
            return
        }
        
        switch filter {
        case .sort:
            //            if uiViewController is FlightSortFilterViewController {
            //                setSortVC(uiViewController as! FlightSortFilterViewController)
            //            }
            if uiViewController is IntReturnAndMCSortVC {
                setSortVC(uiViewController as! IntReturnAndMCSortVC, inputFilters: filters)
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
                }
                else {
                    setDurationVC(uiViewController as! FlightDurationFilterViewController, inputFilters: filters)
                }
            }
            
        case .Airlines:
            if uiViewController is AirlinesFilterViewController {
                
                if searchType == RETURN_JOURNEY {
                    setAirlineVCForReturnJourney(uiViewController as! AirlinesFilterViewController, inputFilters: filters)
                }
                else {
                    setAirlineVC( uiViewController as! AirlinesFilterViewController, inputFilters: filters)
                }
            }
            
        case .Price:
            if uiViewController is PriceFilterViewController {
                setPriceVC( uiViewController as! PriceFilterViewController, inputFilters: filters)
            }
        case .Airport:
            if uiViewController is AirportsFilterViewController {
                setAirportVC ( uiViewController as! AirportsFilterViewController, inputFilters: filters, isUpdating: false)
            }
        case .Quality:
            if uiViewController is QualityFilterViewController {
                setQualityFilterVC(uiViewController as! QualityFilterViewController)
            }
        }
    }
    
    
    func updateInputFilters( flightResultArray : [IntMultiCityAndReturnWSResponse.Results])
    {
        self.flightResultArray = flightResultArray
        guard let filters = inputFilters else { return }
        for viewController in  allChildVCs /*self.children*/ {
            
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
                if let TimesFilterVC = viewController as? FlightFilterTimesViewController {
                    //                    updateTimesVC(TimesFilterVC, inputFilters: filters  )
                    updateFlightLegTimeFilters(TimesFilterVC, inputFilters: filters)
                }
            case PriceFilterViewController.className :
                if let priceFilterVC = viewController as? PriceFilterViewController {
                    updatePriceVC( priceFilterVC, inputFilters: filters)
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
                    //                    setAirportVC(airportFilter , inputFilters : filters, isUpdating: true)
                    //                    airportFilter.updateUIPostLatestResults()
                    updateAirportVC(airportFilter, inputFilters: filters)
                }
            case QualityFilterViewController.className :
                if let qualityFilterVC = viewController as? QualityFilterViewController {
                    //                    setQualityFilterVC(qualityFilterVC)
                    //                    qualityFilterVC.updateUIPostLatestResults()
                    updateQualityFilter(qualityFilterVC)
                }
            default:
                print("Switch case missing for " + VCclass)
            }
        }
    }
    
    
    //MARK:- Sort
    func setSortVC(_ sortViewController : IntReturnAndMCSortVC, inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) {
        
        sortViewController.delegate = delegate as? SortFilterDelegate
        let airportLegFilters = getAirportLegFilters(inputFilters: inputFilters)
        sortViewController.airportsArr = airportLegFilters
    }
    
    private func getAirportLegFilters(inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) -> [AirportLegFilter] {
        var airportLegFilters = [AirportLegFilter]()
        
        for index in 0 ..< inputFilters.count {
            
            let filter = inputFilters[index]
            let airports = filter.cityapn
            
            let airportsDetails = flightResultArray[0].apdet
            
            let fromAirports = airports.fr
            let toAirports = airports.to
            
            var originAirports = [AirportsGroupedByCity]()
            var destinationAirports = [AirportsGroupedByCity]()
            
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
                    
                    let displayModel = Airport(name : name!, IATACode:airportCode, city: airportCity)
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
                        cityName = city
                        let airportCode = airportcode
                        
                        let displayModel = Airport(name : name, IATACode:airportCode, city: city )
                        airportsArray.append(displayModel)
                    }
                }
                destinationAirports.append( AirportsGroupedByCity(name: cityName, airports: airportsArray))
            }
            
            let leg = legList[index]
            let airportLegFilter =  AirportLegFilter(leg:leg, originCities: originAirports, destinationCities: destinationAirports, layoverCities: [])
            
            airportLegFilters.append(airportLegFilter)
        }
        return airportLegFilters
    }
    // MARK:- Stops
    func setStopsVC(_ stopsViewController  : FlightStopsFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F])
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
    
    func updateTimesVC(_ timesViewController : FlightFilterTimesViewController, inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]){
        timesViewController.multiLegTimerFilter = getFlightLegTimeFilters( inputFilters)
        timesViewController.updateUIPostLatestResults()
    }
    
    func setTimesVC(_ timesViewController : FlightFilterTimesViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F])
    {
        timesViewController.onToastInitiation = {[weak self] message in
            self?.toastDelegate?.showToastWithMsg(message)
        }
        let timeFilters = getFlightLegTimeFilters(inputFilters)
        timesViewController.multiLegTimerFilter = timeFilters
        timesViewController.isIntMCOrReturnVC = true
        timesViewController.delegate = delegate as? FlightTimeFilterDelegate
        timesViewController.qualityFilterDelegate = delegate as? QualityFilterDelegate
        if let qualityFilters = inputFilters.first?.fq {
            timesViewController.enableOvernightFlightQualityFilter[0] =  qualityFilters.values.contains(UIFilters.hideOvernight.title)
        }
    }
    
    
    func getFlightLegTimeFilters(_ inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) -> [FlightLegTimeFilter]
    {
        var flightLegTimeFilters = [FlightLegTimeFilter]()
        
        for index in 0 ..< inputFilters.count {
            
            let leg = legList[index]
            let filter = inputFilters[index]
            
            let departureTime = filter.depDt
            let arrivalTime = filter.arDt
            
            let departureMin = departureTime.earliest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: false, interval: 3600)
            let departureMax = departureTime.latest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: true, interval: 3600)
            let arrivalMin = arrivalTime.earliest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: false, interval: 3600)
            let arrivalMax = arrivalTime.latest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: true, interval: 3600)
            
            if let departMin = departureMin, let departMax = departureMax, let arrMin = arrivalMin, let arrMax = arrivalMax {
                
                let flightLegFilter =  FlightLegTimeFilter(leg:leg, departureStartTime:  departMin, departureMaxTime: departMax, arrivalStartTime: arrMin, arrivalEndTime: arrMax)
                flightLegTimeFilters.append(flightLegFilter)
            }
        }
        
        return flightLegTimeFilters
    }
    
    func updateFlightLegTimeFilters(_ timesViewController : FlightFilterTimesViewController, inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) {
        
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
            
            if let userFilters = userAppliedFilters, userFilters.appliedFilters[0].contains(.Times),
                userFilters.appliedSubFilters.indices.contains(index), timesViewController.multiLegTimerFilter.indices.contains(index) {
                
                if userFilters.appliedSubFilters[index].contains(.departureTime) {
                    timesViewController.multiLegTimerFilter[index].departureMinTime = newFlightLegFilter.departureMinTime
                    
                    timesViewController.multiLegTimerFilter[index].departureTimeMax = newFlightLegFilter.departureTimeMax
                }
                
                if userFilters.appliedSubFilters[index].contains(.arrivalTime) {
                    timesViewController.multiLegTimerFilter[index].arrivalStartTime = newFlightLegFilter.arrivalStartTime
                    
                    timesViewController.multiLegTimerFilter[index].arrivalEndTime = newFlightLegFilter.arrivalEndTime
                }
                
            } else {
                if !timesViewController.multiLegTimerFilter.indices.contains(index) {
                    timesViewController.multiLegTimerFilter.insert(newFlightLegFilter, at: index)
                } else {
                    timesViewController.multiLegTimerFilter[index] = newFlightLegFilter
                }
            }
        }
        if let qualityFilters = inputFilters.first?.fq {
            timesViewController.enableOvernightFlightQualityFilter[0] =  qualityFilters.values.contains(UIFilters.hideOvernight.title)
        }
        timesViewController.updateFiltersFromAPI()
    }
    
    //MARK:- Duration
    func updateDurationVC(_ durationVC : FlightDurationFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) {


        let durationLegFilters : [DurationFilter]
        if searchType == RETURN_JOURNEY {
//            let durationLegFilter = self.createDurationFilterArrayReturnJourney(inputFilters: inputFilters)
//            durationLegFilters = [durationLegFilter]
            updateDurationFilterForReturnJourney(durationVC, inputFilters: inputFilters)
        }
        else {
//            durationLegFilters = self.createDurationFilterArray(inputFilters: inputFilters)
            updateDurationFilter(durationVC, inputFilters: inputFilters)
        }

//        durationVC.durationFilters = durationLegFilters
//
//        durationVC.currentDurationFilter = durationLegFilters[durationVC.currentActiveIndex]

    }
    
    private func updateDurationFilterForReturnJourney(_ durationViewController : FlightDurationFilterViewController, inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) {
        
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
            
            guard let layoverMinDuration = layoverTime.minTime else { continue }
            duration = ( layoverMinDuration as NSString).floatValue
            let layoverMin = CGFloat(floor( duration / 3600.0 ))
            
            // layoverDurationMinDuration is set to max value initially, whenever layoverMin is less than layoverDurationMinDuration , layoverMin is assigned to layoverDurationMinDuration
            // This logic works for first loop as well as in second iteration if layoverMin is less than layoverDurationMinDuration.
            
            if layoverMin < layoverDurationMin {
                layoverDurationMin = layoverMin
            }
            
            guard let layoverMaxString = layoverTime.maxTime else { continue }
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
    
    private func updateDurationFilter(_ durationViewController : FlightDurationFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) {
        
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
            let tripMaxDuration = CGFloat( ceil(duration / 3600.0))
            
            guard let layoverMinDuration = layoverTime.minTime else { continue }
            duration = ( layoverMinDuration as NSString).floatValue
            let layoverMin = CGFloat(floor( duration / 3600.0 ))
            
            guard let layoverMaxDuration = layoverTime.maxTime else { continue }
            duration = ( layoverMaxDuration as NSString).floatValue
            let layoverMax = CGFloat( ceil(duration / 3600.0))
            
            let leg = legList[index]
            let durationFilter = DurationFilter(leg: leg, tripMin: tripMinDuration, tripMax: tripMaxDuration, layoverMin: layoverMin, layoverMax: layoverMax, layoverMinTimeFormat: "")
            
            if let userFilters = userAppliedFilters, userFilters.appliedFilters[0].contains(.Duration), durationViewController.durationFilters.indices.contains(index) {
                
                if userFilters.appliedSubFilters[index].contains(.tripDuration) {
                    durationViewController.durationFilters[index].tripDurationMinDuration = tripMinDuration
                    durationViewController.durationFilters[index].tripDurationmaxDuration = tripMaxDuration
                }
                
                if userFilters.appliedSubFilters[index].contains(.layoverDuration) {
                    durationViewController.durationFilters[index].layoverMinDuration = layoverMin
                    durationViewController.durationFilters[index].layoverMaxDuration = layoverMax
                }
                
            } else {
                if !durationViewController.durationFilters.indices.contains(index) {
                    durationViewController.durationFilters.insert(durationFilter, at: index)
                } else {
                durationViewController.durationFilters[index] = durationFilter
                }
            }
        }
        guard durationViewController.durationFilters.count > 0 else { return }
        durationViewController.updateFiltersFromAPI()
    }
    
    
    
    func createDurationFilterArray(inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) ->  [DurationFilter] {
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
            let tripMaxDuration = CGFloat( ceil(duration / 3600.0))
            
            guard let layoverMinDuration = layoverTime.minTime else { continue }
            duration = ( layoverMinDuration as NSString).floatValue
            let layoverMin = CGFloat(floor( duration / 3600.0 ))
            
            guard let layoverMaxDuration = layoverTime.maxTime else { continue }
            duration = ( layoverMaxDuration as NSString).floatValue
            let layoverMax = CGFloat( ceil(duration / 3600.0))
            
            let leg = legList[index]
            let durationFilter = DurationFilter(leg: leg, tripMin: trimMinDuration, tripMax: tripMaxDuration, layoverMin: layoverMin, layoverMax: layoverMax, layoverMinTimeFormat:"")
            
            durationFilters.append(durationFilter)
        }
        
        return durationFilters
    }
    
    func createDurationFilterArrayReturnJourney( inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) -> DurationFilter {
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
            
            guard let layoverMinDuration = layoverTime.minTime else { continue }
            duration = ( layoverMinDuration as NSString).floatValue
            let layoverMin = CGFloat(floor( duration / 3600.0 ))
            
            // layoverDurationMinDuration is set to max value initially, whenever layoverMin is less than layoverDurationMinDuration , layoverMin is assigned to layoverDurationMinDuration
            // This logic works for first loop as well as in second iteration if layoverMin is less than layoverDurationMinDuration.
            
            if layoverMin < layoverDurationMin {
                layoverDurationMin = layoverMin
            }
            
            guard let layoverMaxString = layoverTime.maxTime else { continue }
            duration = ( layoverMaxString as NSString).floatValue
            let layoverMax = CGFloat(ceil(duration / 3600.0))
            
            
            // layoverMaxDuration is set to 0.0 value initially, whenever layoverMax is more than layoverMaxDuration , layoverMax is assigned to layoverMaxDuration
            // This logic works for first loop as well as in second iteration if layoverMax is more than layoverMax.
            
            if layoverMaxDuration < layoverMax {
                layoverMaxDuration = layoverMax
            }
        }
        
        
        let durationFilter = DurationFilter(leg: legList[0], tripMin: tripDurationMin, tripMax: tripDurationMax, layoverMin: layoverDurationMin, layoverMax: layoverMaxDuration, layoverMinTimeFormat:"")
        
        return durationFilter
        
    }
    
    func setDurationVC(_ durationViewController : FlightDurationFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F])
    {
        durationViewController.showingForReturnJourney = false
        durationViewController.legsArray = legList
        let durationFilters = createDurationFilterArray(inputFilters: inputFilters)
        durationViewController.durationFilters = durationFilters
        durationViewController.currentDurationFilter = durationFilters[0]
        durationViewController.delegate = delegate as? FlightDurationFilterDelegate
    }
    
    func setDurationVCForReturnJourney(_ durationViewController : FlightDurationFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) {
        
        durationViewController.showingForReturnJourney = true
        durationViewController.legsArray = [legList[0]]
        let durationFilter = createDurationFilterArrayReturnJourney(inputFilters: inputFilters)
        durationViewController.durationFilters = [durationFilter]
        durationViewController.currentDurationFilter = durationFilter
        durationViewController.legsArray = [legList[0]]
        durationViewController.delegate = delegate as? FlightDurationFilterDelegate
        
    }
    
    //MARK:- Airline
    fileprivate func createAirlineFiltersArray(inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) -> [AirlineLegFilter] {
        
        var airlineFilters = [AirlineLegFilter]()
        
        for  index in 0 ..< inputFilters.count {
            
            let filter = inputFilters[index]
            
            let airlineDetail = flightResultArray[0].aldet
            let multiAL = filter.multiAl
            var airlineArray = [Airline]()
            
            for (code , name) in airlineDetail {
                let tempAirline = Airline(name: name, code: code)
                airlineArray.append(tempAirline)
            }
            let leg = legList[index]
            let airlineLegFilter = AirlineLegFilter( leg: leg, airlinesArray: airlineArray, multiAl: multiAL )
            
            airlineFilters.append(airlineLegFilter)
        }
        return airlineFilters
    }
    
    fileprivate func setAirlineVC( _ airlineViewController : AirlinesFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) {
        
        let airlineFilters = self.createAirlineFiltersArray(inputFilters: inputFilters)
        airlineViewController.airlinesFilterArray = airlineFilters
        airlineViewController.currentSelectedAirlineFilter = airlineFilters[0]
        airlineViewController.showingForReturnJourney = false
        airlineViewController.isIntReturnOrMCJourney = true
        airlineViewController.delegate = delegate as? AirlineFilterDelegate
    }
    
    fileprivate func createAirlineFilterForReturnJourney(inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) -> AirlineLegFilter {
        
        var multiAL = 0
        var airlineSet = Set<Airline>()
        
        for  index in 0 ..< inputFilters.count {
            
            let filter = inputFilters[index]
            multiAL = multiAL + (filter.multiAl )
            let airlineDetail = flightResultArray[0].aldet
            
            for (code , name) in airlineDetail {
                let tempAirline = Airline(name: name, code: code)
                airlineSet.insert(tempAirline)
            }
        }
        
        let airlineArray = Array(airlineSet)
        //        multiAL = max(1, multiAL)
        let leg = legList[0]
        let airlineLegFilter = AirlineLegFilter( leg: leg, airlinesArray: airlineArray, multiAl: multiAL )
        return airlineLegFilter
        
    }
    
    fileprivate func setAirlineVCForReturnJourney( _ airlineViewController : AirlinesFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) {
        
        let airlineLegFilter = self.createAirlineFilterForReturnJourney(inputFilters: inputFilters)
        airlineViewController.airlinesFilterArray  = [airlineLegFilter]
        airlineViewController.currentSelectedAirlineFilter = airlineLegFilter
        airlineViewController.showingForReturnJourney = true
        airlineViewController.isIntReturnOrMCJourney = true
        airlineViewController.delegate = delegate as? AirlineFilterDelegate
        
    }
    
    fileprivate func updateAirlineVC(_ airlineVC: AirlinesFilterViewController , filters: [IntMultiCityAndReturnWSResponse.Results.F]) {
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
    func setPriceVC(_ priceViewController : PriceFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F])
    {
        priceViewController.delegate = delegate as? PriceFilterDelegate
        var priceFilters = [PriceFilter]()
        let priceWS = inputFilters[0].pr
        let priceFilter = PriceFilter(onlyRefundableFaresSelected: false,
                                      inputFareMinValue: CGFloat(priceWS.minPrice) ,
                                      inputFareMaxVaule: CGFloat(priceWS.maxPrice) ,
                                      userSelectedFareMinValue: CGFloat(priceWS.minPrice) ,
                                      userSelectedFareMaxValue: CGFloat(priceWS.maxPrice) )
        
        priceFilters.append(priceFilter)
        priceViewController.intFlightResultArray = flightResultArray
        priceViewController.isInternational = true
        priceViewController.legsArray = legList
        priceViewController.allPriceFilters = priceFilters
        priceViewController.currentPriceFilter = priceFilters[0]
    }
    
    func updatePriceVC(_ priceViewController : PriceFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) {
        
        for (index, filter) in inputFilters.enumerated() {
            let newPriceWS = filter.pr
            let newPriceFilter = PriceFilter(onlyRefundableFaresSelected: false,
                                             inputFareMinValue: CGFloat(newPriceWS.minPrice) ,
                                             inputFareMaxVaule: CGFloat(newPriceWS.maxPrice) ,
                                             userSelectedFareMinValue: CGFloat(newPriceWS.minPrice) ,
                                             userSelectedFareMaxValue: CGFloat(newPriceWS.maxPrice) )
            
            if let userFilters = userAppliedFilters, userFilters.appliedFilters[0].contains(.Price), priceViewController.allPriceFilters.indices.contains(index) {
                priceViewController.allPriceFilters[index].inputFareMinValue = newPriceFilter.inputFareMinValue
                
                priceViewController.allPriceFilters[index].inputFareMaxVaule = newPriceFilter.inputFareMaxVaule
            } else {
                if !priceViewController.allPriceFilters.indices.contains(index) {
                    priceViewController.allPriceFilters.insert(newPriceFilter, at: index)
                } else {
                    priceViewController.allPriceFilters[index] = newPriceFilter
                }
            }
        }
        priceViewController.updateFiltersFromAPI()
    }
    
    
    //MARK:- Airport
    func setAirportVC(_ airportViewController : AirportsFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F], isUpdating: Bool)
    {
        var airportLegFilters = [AirportLegFilter]()
        
        for index in 0 ..< inputFilters.count {
            
            let filter = inputFilters[index]
            let airports = filter.cityapn
            
            let airportsDetails = flightResultArray[0].apdet
            
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
                        cityName = city
                        let airportCode = airportcode
                        
                        let displayModel = Airport(name : name, IATACode:airportCode, city: city )
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
                    country = airport.cname
                    let city = airport.c
                    let airportCode = layoverAirport
                    
                    var layouverAirportsArray = [Airport]()
                    let displayModel = Airport(name : name, IATACode:airportCode, city: city )
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
        
        if searchType == RETURN_JOURNEY {
            airportLegFilters[0].originCities = airportLegFilters[0].originCities.map({ (city) in
                var newCity = city
                if let cityInReturnLeg = airportLegFilters[1].destinationCities.first(where: { $0.name == newCity.name }) {
                    newCity.airports = Array(Set(newCity.airports + cityInReturnLeg.airports))
                    newCity.airports.sort(by: { $0.city < $1.city })
                }
                return newCity
            })
            
            airportLegFilters[0].destinationCities = airportLegFilters[0].destinationCities.map({ (city) in
                var newCity = city
                if let cityInReturnLeg = airportLegFilters[1].originCities.first(where: { $0.name == newCity.name }) {
                    newCity.airports = Array(Set(newCity.airports + cityInReturnLeg.airports))
                    newCity.airports.sort(by: { $0.city < $1.city })
                }
                return newCity
            })
            
            airportLegFilters[0].layoverCities = airportLegFilters[0].layoverCities.map({ (city) in
                var newCity = city
                if let cityInReturnLeg = airportLegFilters[1].layoverCities.first(where: { $0.country == newCity.country }) {
                    newCity.airports = Array(Set(newCity.airports + cityInReturnLeg.airports))
                    newCity.airports.sort(by: { $0.city < $1.city })
                }
                return newCity
            })
            
            airportLegFilters[1].layoverCities.forEach { (layCity) in
                if !airportLegFilters[0].layoverCities.contains(where: { $0.country == layCity.country }) {
                    airportLegFilters[0].layoverCities.append(layCity)
                }
            }
            
            airportLegFilters[0].layoverCities.sort(by: { $0.country < $1.country })
        }
        
        airportViewController.airportFilterArray = airportLegFilters
        if !isUpdating {
            airportViewController.currentAirportFilter = airportLegFilters[0]
        }
        airportViewController.delegate = delegate as? AirportFilterDelegate
        airportViewController.searchType = self.searchType
        airportViewController.isIntReturnOrMCJourney = true
        airportViewController.areAllDepartReturnNotSame = showDepartReturnSame
    }
    
    func updateAirportVC(_ airportViewController : AirportsFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F])
    {
        
        for index in 0 ..< inputFilters.count {
            
            let filter = inputFilters[index]
            let airports = filter.cityapn
            
            let airportsDetails = flightResultArray[0].apdet
            
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
                        cityName = city
                        let airportCode = airportcode
                        
                        let displayModel = Airport(name : name, IATACode:airportCode, city: city )
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
                    country = airport.cname
                    let city = airport.c
                    let airportCode = layoverAirport
                    
                    var layouverAirportsArray = [Airport]()
                    let displayModel = Airport(name : name, IATACode:airportCode, city: city )
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
            var airportLegFilter =  AirportLegFilter(leg:leg, originCities: originAirports, destinationCities: destinationAirports, layoverCities: layoverAirportsDisplayModelArray)
            
            if searchType == RETURN_JOURNEY {
                airportViewController.airportFilterArray[0].originCities = airportViewController.airportFilterArray[0].originCities.map({ (city) in
                    var newCity = city
                    if let cityInReturnLeg = airportLegFilter.destinationCities.first(where: { $0.name == newCity.name }) {
                        newCity.airports = Array(Set(newCity.airports + cityInReturnLeg.airports))
                        let selectedAirports = newCity.airports.filter { $0.isSelected }
                        selectedAirports.forEach { (airport) in
                            newCity.airports.removeAll(where: { $0.IATACode == airport.IATACode })
                        }
                        newCity.airports = Array(Set(newCity.airports + selectedAirports))
                        newCity.airports.sort(by: { $0.city < $1.city })
                    }
                    return newCity
                })
                
                airportViewController.airportFilterArray[0].destinationCities = airportViewController.airportFilterArray[0].destinationCities.map({ (city) in
                    var newCity = city
                    if let cityInReturnLeg = airportLegFilter.originCities.first(where: { $0.name == newCity.name }) {
                        newCity.airports = Array(Set(newCity.airports + cityInReturnLeg.airports))
                        let selectedAirports = newCity.airports.filter { $0.isSelected }
                        selectedAirports.forEach { (airport) in
                            newCity.airports.removeAll(where: { $0.IATACode == airport.IATACode })
                        }
                        newCity.airports = Array(Set(newCity.airports + selectedAirports))
                        newCity.airports.sort(by: { $0.city < $1.city })
                    }
                    return newCity
                })
                
                airportViewController.airportFilterArray[0].layoverCities = airportViewController.airportFilterArray[0].layoverCities.map({ (city) in
                    var newCity = city
                    if let cityInReturnLeg = airportLegFilter.layoverCities.first(where: { $0.country == newCity.country }) {
                        newCity.airports = Array(Set(newCity.airports + cityInReturnLeg.airports))
                        let selectedAirports = newCity.airports.filter { $0.isSelected }
                        selectedAirports.forEach { (airport) in
                            newCity.airports.removeAll(where: { $0.IATACode == airport.IATACode })
                        }
                        newCity.airports = Array(Set(newCity.airports + selectedAirports))
                        newCity.airports.sort(by: { $0.city < $1.city })
                    }
                    return newCity
                })
                
                airportLegFilter.layoverCities.forEach { (layCity) in
                    if !airportViewController.airportFilterArray[0].layoverCities.contains(where: { $0.country == layCity.country }) {
                        airportViewController.airportFilterArray[0].layoverCities.append(layCity)
                    }
                }
                
                airportViewController.airportFilterArray[0].layoverCities.sort(by: { $0.country < $1.country })
            }
            
            
            if let userFilters = userAppliedFilters, userFilters.appliedFilters[0].contains(.Airport), airportViewController.airportFilterArray.indices.contains(index) {
                let curAiportFilter = airportViewController.airportFilterArray[index]
                let selectedAirports = curAiportFilter.allSelectedAirports
                
                airportLegFilter.originCities = airportLegFilter.originCities.map { (city) in
                    var newCity = city
                    newCity.airports = newCity.airports.map({ (airport) in
                        var newAirport = airport
                        if let _ = selectedAirports.first(where: { $0.IATACode == newAirport.IATACode }) {
                            newAirport.isSelected = true
                        }
                        return newAirport
                    })
                    return newCity
                }
                
                airportLegFilter.destinationCities = airportLegFilter.destinationCities.map { (city) in
                    var newCity = city
                    newCity.airports = newCity.airports.map({ (airport) in
                        var newAirport = airport
                        if let _ = selectedAirports.first(where: { $0.IATACode == newAirport.IATACode }) {
                            newAirport.isSelected = true
                        }
                        return newAirport
                    })
                    return newCity
                }
                
                airportLegFilter.layoverCities = airportLegFilter.layoverCities.map { (city) in
                    var newCity = city
                    newCity.airports = newCity.airports.map({ (airport) in
                        var newAirport = airport
                        if let _ = selectedAirports.first(where: { $0.IATACode == newAirport.IATACode }) {
                            newAirport.isSelected = true
                        }
                        return newAirport
                    })
                    return newCity
                }
                
                airportViewController.airportFilterArray[index] = airportLegFilter
                
            } else {
                if !airportViewController.airportFilterArray.indices.contains(index) {
                    airportViewController.airportFilterArray.insert(airportLegFilter, at: index)
                } else {
                    airportViewController.airportFilterArray[index] = airportLegFilter
                }
            }
            airportViewController.initialSetup()
        }
    }
    
    
    
    //MARK:- Quality
    func setQualityFilterVC(_ qualityViewController : QualityFilterViewController) {
        
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


