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
    var appliedAndUIFilters: AppliedAndUIFilters?
    var userSelectedFilters = [IntMultiCityAndReturnWSResponse.Results.F]()
    
    var flightSearchParameters = JSONDictionary()

    var showDepartReturnSame = false {
        didSet {
            if !showDepartReturnSame { return }
            allChildVCs.forEach { (viewCon) in
                if let airportVC = viewCon as? AirportsFilterViewController {
                    airportVC.areAllDepartReturnNotSame = showDepartReturnSame
                }
            }
        }
    }
    
    var updatedAircraftFilter : AircraftFilter = AircraftFilter() {
        didSet {
            
            DispatchQueue.main.async {
                                    
                let aircraftVc = self.allChildVCs.filter { $0.className == AircraftFilterViewController.className }.first
                
                if let vc = aircraftVc as? AircraftFilterViewController {
                    self.setAircraftFilterVC(vc )
                 }
                
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
            if filter == .Quality { continue }
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
        self.parchmentView?.menuItemSpacing = 17.5
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 0, bottom: 0.0, right: 10)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 45.5)
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
            self.parchmentView?.selectedFont = AppFonts.Regular.withSize(16.0)
            self.parchmentView?.indicatorColor = .clear
            
            // to hide contents of filter children views
            UIView.animate(withDuration: 0.3) {
                self.parchmentView?.view.subviews[0].alpha = 0
            }
        } else {
            self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
            self.parchmentView?.indicatorColor = AppColors.themeGreen
            self.parchmentView?.view.subviews[0].alpha = 1
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
        guard let filters = appliedAndUIFilters else { return }
        menuItems[Filters.sort.rawValue].isSelected = filters.appliedFilters[0].contains(.sort)
        menuItems[Filters.stops.rawValue].isSelected = filters.appliedFilters[0].contains(.stops) || filters.uiFilters[0].contains(.hideChangeAirport)
        menuItems[Filters.Times.rawValue].isSelected = filters.appliedFilters[0].contains(.Times) || filters.uiFilters[0].contains(.hideOvernight)
        menuItems[Filters.Duration.rawValue].isSelected = filters.appliedFilters[0].contains(.Duration) || filters.uiFilters[0].contains(.hideOvernightLayover)
        menuItems[Filters.Airlines.rawValue].isSelected = filters.appliedFilters[0].contains(.Airlines) || filters.uiFilters[0].contains(.hideMultiAirlineItinarery)
        menuItems[Filters.Airport.rawValue].isSelected = filters.appliedFilters[0].contains(.Airport)
        menuItems[Filters.Quality.rawValue].isSelected = filters.appliedFilters[0].contains(.Quality)
        menuItems[Filters.Price.rawValue - 1].isSelected = filters.appliedFilters[0].contains(.Price)
        menuItems[Filters.Aircraft.rawValue - 1].isSelected = filters.appliedFilters[0].contains(.Aircraft)
        parchmentView?.reloadMenu()
    }
    
    func setValuesFor(_ uiViewController  : UIViewController , filter : Filters) {
        guard let filters = inputFilters else {
            return
        }
        
        switch filter {
        case .sort:
            //            if uiViewController is FlightSortFilterViewController {
            //                setSortVC(uiViewController as! FlightSortFilterViewController)
            //            }
            if let sortVC = uiViewController as? IntReturnAndMCSortVC {
                setSortVC(sortVC, inputFilters: filters)
            }
        case .stops:
            if let stopsVC = uiViewController as? FlightStopsFilterViewController {
                setStopsVC(stopsVC, inputFilters: filters)
            }
        case .Times :
            if let timesVC = uiViewController as? FlightFilterTimesViewController {
                setTimesVC(timesVC, inputFilters: filters)
            }
        case .Duration:
            if let durationVC = uiViewController as? FlightDurationFilterViewController {
                
                if searchType == RETURN_JOURNEY {
                    setDurationVCForReturnJourney(durationVC, inputFilters: filters)
                }
                else {
                    setDurationVC(durationVC, inputFilters: filters)
                }
            }
            
        case .Airlines:
            if let airlinesVC = uiViewController as? AirlinesFilterViewController {
                
                if searchType == RETURN_JOURNEY {
                    setAirlineVCForReturnJourney(airlinesVC, inputFilters: filters)
                } else {
                    setAirlineVC(airlinesVC, inputFilters: filters)
                }
            }
            
        case .Price:
            if let priceVC = uiViewController as? PriceFilterViewController {
                setPriceVC(priceVC, inputFilters: filters)
            }
        case .Airport:
            if let airportsVC = uiViewController as? AirportsFilterViewController {
                setAirportVC (airportsVC, inputFilters: filters, isUpdating: false)
            }
        case .Quality:
            if let qualityVC = uiViewController as? QualityFilterViewController {
                setQualityFilterVC(qualityVC)
            }
            
        case .Aircraft:
            if let aircraftVC = uiViewController as? AircraftFilterViewController {
                self.setAircraftFilterVC(aircraftVC)
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
//                    setStopsVC(stopVC, inputFilters: filters)
//                    stopVC.updateUIPostLatestResults()
                    updateStopsFilter(stopVC, inputFilters: filters)
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
                printDebug("Switch case missing for " + VCclass)
            }
        }
    }
    
    
    //MARK:- Sort
    func setSortVC(_ sortViewController : IntReturnAndMCSortVC, inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) {
        
        sortViewController.viewModel.flightSearchParameters = flightSearchParameters
        sortViewController.viewModel.delegate = delegate as? SortFilterDelegate
        let airportLegFilters = getAirportLegFilters(inputFilters: inputFilters)
        sortViewController.viewModel.airportsArr = airportLegFilters
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
                    
                    let name = airport?.n ?? ""
                    guard let airportCity = airport?.c else { continue }
                    cityName = airportCity
                    let airportCode = airportcode
                    
                    let displayModel = Airport(name : name, IATACode:airportCode, city: airportCity)
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
            stopsViewController.viewModel.allStopsFilters = [StopsFilter(stops:reducedStops )]
            stopsViewController.viewModel.allLegNames = [legList[0]]
            stopsViewController.viewModel.showingForReturnJourney = true
        }else {
            stopsViewController.viewModel.allStopsFilters = allLegsStops
            stopsViewController.viewModel.allLegNames = legList
            stopsViewController.viewModel.showingForReturnJourney = false
        }
        stopsViewController.viewModel.isIntMCOrReturnVC = true
        stopsViewController.viewModel.delegate = delegate as? FlightStopsFilterDelegate
        stopsViewController.viewModel.qualityFilterDelegate = delegate as? QualityFilterDelegate
        if let qualityFilters = inputFilters.first?.fq {
            if stopsViewController.viewModel.enableOvernightFlightQualityFilter.indices.contains(0) {
                stopsViewController.viewModel.enableOvernightFlightQualityFilter[0] =  qualityFilters.values.contains(UIFilters.hideChangeAirport.title)
            } else {
                stopsViewController.viewModel.enableOvernightFlightQualityFilter.insert(qualityFilters.values.contains(UIFilters.hideChangeAirport.title), at: 0)
            }
        }
    }
    
    func updateStopsFilter(_ stopsViewController  : FlightStopsFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F])
    {
        if searchType == RETURN_JOURNEY {
            var qualityFilter: QualityFilter?
            if stopsViewController.viewModel.allStopsFilters.indices.contains(0) {
                qualityFilter = stopsViewController.viewModel.allStopsFilters[0].qualityFilter
                if userSelectedFilters[0].fq.keys.contains("coa") {
                    qualityFilter?.isSelected = userSelectedFilters[0].fq["coa"] == ""
                }
            }
            var allLegsStops = [StopsFilter]()
            for fliter in inputFilters
            {
                let stopsStringArray = fliter.stp
                let stops : [Int] = stopsStringArray.map({Int($0) ?? 0})
                let stopFilter = StopsFilter(stops: stops)
                allLegsStops.append(stopFilter)
            }
            var reducedStops  = allLegsStops.reduce([], { $0 + $1.availableStops })
            let reducedStopsSet = Set(reducedStops)
            reducedStops = Array(reducedStopsSet).sorted()
            stopsViewController.viewModel.allStopsFilters[0].availableStops = reducedStops
            
            if appliedAndUIFilters?.appliedFilters[0].contains(.stops) ?? false {
                let userStopsStringArray = userSelectedFilters[0].stp
                let userStops : [Int] = userStopsStringArray.map({Int($0) ?? 0})
                stopsViewController.viewModel.allStopsFilters[0].userSelectedStops = userStops
            }
            if let quality = qualityFilter {
                stopsViewController.viewModel.allStopsFilters[0].qualityFilter = quality
            }
        } else {
            for index in 0..<inputFilters.count {
                
                var qualityFilter: QualityFilter?
                if stopsViewController.viewModel.allStopsFilters.indices.contains(index) {
                    qualityFilter = stopsViewController.viewModel.allStopsFilters[index].qualityFilter
                    if userSelectedFilters[index].fq.keys.contains("coa") {
                        qualityFilter?.isSelected = userSelectedFilters[index].fq["coa"] == ""
                    }
                }
                
                let filter = inputFilters[index]
                let stopsStringArray = filter.stp
                let stops : [Int] = stopsStringArray.map({Int($0) ?? 0})
                let stopFilter = StopsFilter(stops: stops)
                
                if let userFilters = appliedAndUIFilters, userFilters.appliedFilters[0].contains(.stops), stopsViewController.viewModel.allStopsFilters.indices.contains(index) {
                    stopsViewController.viewModel.allStopsFilters[index].availableStops = stopFilter.availableStops
                    
                    let userStopsStringArray = userSelectedFilters[index].stp
                    let userStops : [Int] = userStopsStringArray.map({Int($0) ?? 0})
                    stopsViewController.viewModel.allStopsFilters[index].userSelectedStops = userStops
                } else {
                    if !stopsViewController.viewModel.allStopsFilters.indices.contains(index) {
                        stopsViewController.viewModel.allStopsFilters.insert(stopFilter, at: index)
                    } else {
                        stopsViewController.viewModel.allStopsFilters[index] = stopFilter
                    }
                }
                if let quality = qualityFilter {
                    stopsViewController.viewModel.allStopsFilters[index].qualityFilter = quality
                }
            }
        }
        
        if let qualityFilters = inputFilters.first?.fq {
            if stopsViewController.viewModel.enableOvernightFlightQualityFilter.indices.contains(0) {
                stopsViewController.viewModel.enableOvernightFlightQualityFilter[0] =  qualityFilters.values.contains(UIFilters.hideChangeAirport.title)
            } else {
                stopsViewController.viewModel.enableOvernightFlightQualityFilter.insert(qualityFilters.values.contains(UIFilters.hideChangeAirport.title), at: 0)
            }
        }
        stopsViewController.updateUIPostLatestResults()
    }
    
    
    //MARK:- Times
    
    func updateTimesVC(_ timesViewController : FlightFilterTimesViewController, inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]){
        timesViewController.viewModel.multiLegTimerFilter = getFlightLegTimeFilters( inputFilters)
        timesViewController.updateUIPostLatestResults()
    }
    
    func setTimesVC(_ timesViewController : FlightFilterTimesViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F])
    {
        timesViewController.onToastInitiation = {[weak self] message in
            self?.toastDelegate?.showToastWithMsg(message)
        }
        let timeFilters = getFlightLegTimeFilters(inputFilters)
        timesViewController.viewModel.multiLegTimerFilter = timeFilters
        timesViewController.viewModel.isIntMCOrReturnVC = true
        timesViewController.viewModel.delegate = delegate as? FlightTimeFilterDelegate
        timesViewController.viewModel.qualityFilterDelegate = delegate as? QualityFilterDelegate
        timesViewController.viewModel.isReturnFlight = searchType.rawValue == 1
        if let qualityFilters = inputFilters.first?.fq {
            if timesViewController.viewModel.enableOvernightFlightQualityFilter.indices.contains(0) {
                timesViewController.viewModel.enableOvernightFlightQualityFilter[0] =  qualityFilters.values.contains(UIFilters.hideOvernight.title)
            } else {
                timesViewController.viewModel.enableOvernightFlightQualityFilter.insert(qualityFilters.values.contains(UIFilters.hideOvernight.title), at: 0)
            }
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

            
            var qualityFilter: QualityFilter?
            if timesViewController.viewModel.multiLegTimerFilter.indices.contains(index) {
                qualityFilter = timesViewController.viewModel.multiLegTimerFilter[index].qualityFilter
                if userSelectedFilters[index].fq.keys.contains("ovgtf") {
                    qualityFilter?.isSelected = userSelectedFilters[index].fq["ovgtf"] == ""
                }
            }
            
            let leg = legList[index]
            let filter = inputFilters[index]
            
            let departureTime = filter.depDt
            let arrivalTime = filter.arDt
            
            guard let departureMin = departureTime.earliest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: false, interval: 3600),
            let departureMax = departureTime.latest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: true, interval: 3600),
            let arrivalMin = arrivalTime.earliest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: false, interval: 3600),
            let arrivalMax = arrivalTime.latest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: true, interval: 3600) else { return }
            
            let newFlightLegFilter =  FlightLegTimeFilter(leg:leg, departureStartTime:  departureMin, departureMaxTime: departureMax, arrivalStartTime: arrivalMin, arrivalEndTime: arrivalMax)
            
            let userSelectedFilter = userSelectedFilters[index]
            let userDepartureTime = userSelectedFilter.depDt
            let userArrivalTime = userSelectedFilter.arDt
            

            guard let userDepartureMin = userDepartureTime.earliest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: false, interval: 3600),
            let userDepartureMax = userDepartureTime.latest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: true, interval: 3600),
            let userArrivalMin = userArrivalTime.earliest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: false, interval: 3600),
            let userArrivalMax = userArrivalTime.latest.dateUsing(format: "yyyy-MM-dd HH:mm", isRoundedUP: true, interval: 3600) else { return }
            
            if !timesViewController.viewModel.multiLegTimerFilter.indices.contains(index) {
                timesViewController.viewModel.multiLegTimerFilter.insert(newFlightLegFilter, at: index)
            } else {
                timesViewController.viewModel.multiLegTimerFilter[index] = newFlightLegFilter
            }
            
            if let userFilters = appliedAndUIFilters, userFilters.appliedFilters[0].contains(.Times),
               userFilters.appliedSubFilters.indices.contains(index), timesViewController.viewModel.multiLegTimerFilter.indices.contains(index) {
                
                
                timesViewController.viewModel.multiLegTimerFilter[index].departureMinTime = newFlightLegFilter.departureMinTime
                
                timesViewController.viewModel.multiLegTimerFilter[index].departureTimeMax = newFlightLegFilter.departureTimeMax
                
                if userFilters.appliedSubFilters[index].contains(.departureTime) {
                    
                    timesViewController.viewModel.multiLegTimerFilter[index].userSelectedStartTime = userDepartureMin

                    timesViewController.viewModel.multiLegTimerFilter[index].userSelectedEndTime = userDepartureMax
                    
                } else {
                    timesViewController.viewModel.multiLegTimerFilter[index].userSelectedStartTime = newFlightLegFilter.departureMinTime
                    
                    timesViewController.viewModel.multiLegTimerFilter[index].userSelectedEndTime = newFlightLegFilter.departureTimeMax
                }
                
                timesViewController.viewModel.multiLegTimerFilter[index].arrivalStartTime = newFlightLegFilter.arrivalStartTime
                
                timesViewController.viewModel.multiLegTimerFilter[index].arrivalEndTime = newFlightLegFilter.arrivalEndTime
                
                if userFilters.appliedSubFilters[index].contains(.arrivalTime) {
                    
                    timesViewController.viewModel.multiLegTimerFilter[index].userSelectedArrivalStartTime = userArrivalMin

                    timesViewController.viewModel.multiLegTimerFilter[index].userSelectedArrivalEndTime = userArrivalMax
                    
                } else {
                    timesViewController.viewModel.multiLegTimerFilter[index].userSelectedArrivalStartTime = newFlightLegFilter.arrivalStartTime
                    
                    timesViewController.viewModel.multiLegTimerFilter[index].userSelectedArrivalEndTime = newFlightLegFilter.arrivalEndTime
                }
                
            }
            if let quality = qualityFilter {
                timesViewController.viewModel.multiLegTimerFilter[index].qualityFilter = quality
            }
        }
        if let qualityFilters = inputFilters.first?.fq {
            if timesViewController.viewModel.enableOvernightFlightQualityFilter.indices.contains(0) {
                timesViewController.viewModel.enableOvernightFlightQualityFilter[0] =  qualityFilters.values.contains(UIFilters.hideOvernight.title)
            } else {
                timesViewController.viewModel.enableOvernightFlightQualityFilter.insert(qualityFilters.values.contains(UIFilters.hideOvernight.title), at: 0)
            }
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
        
        var qualityFilter: QualityFilter?
        if durationViewController.viewModel.durationFilters.indices.contains(0) {
            qualityFilter = durationViewController.viewModel.durationFilters[0].qualityFilter
            if userSelectedFilters[0].fq.keys.contains("ovgtlo") {
                qualityFilter?.isSelected = userSelectedFilters[0].fq["ovgtlo"] == ""
            }
        }
        
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
        
        let userTripTime = userSelectedFilters[0].tt
        let userLayoverTime = userSelectedFilters[0].lott
        
        
        if let userFilters = appliedAndUIFilters, userFilters.appliedFilters[0].contains(.Duration) {
            
            if userFilters.appliedSubFilters[0].contains(.tripDuration) {
                durationViewController.viewModel.durationFilters[0].tripDurationMinDuration = tripDurationMin
                durationViewController.viewModel.durationFilters[0].tripDurationmaxDuration = tripDurationMax
                
                let minDuration = Float(userTripTime.minTime ?? "") ?? 0
                let maxDuration = Float(userTripTime.maxTime ?? "") ?? 0
                durationViewController.viewModel.durationFilters[0].userSelectedTripMin = CGFloat(minDuration/3600)
                durationViewController.viewModel.durationFilters[0].userSelectedTripMax = CGFloat(maxDuration/3600)
            }
            
            if userFilters.appliedSubFilters[0].contains(.layoverDuration) {
                durationViewController.viewModel.durationFilters[0].layoverMinDuration = layoverDurationMin
                durationViewController.viewModel.durationFilters[0].layoverMaxDuration = layoverMaxDuration
                
                let minDuration = Float(userLayoverTime.minTime ?? "") ?? 0
                let maxDuration = Float(userLayoverTime.maxTime ?? "") ?? 0
                durationViewController.viewModel.durationFilters[0].userSelectedLayoverMin = CGFloat(minDuration/3600)
                durationViewController.viewModel.durationFilters[0].userSelectedLayoverMax = CGFloat(maxDuration/3600)
            }
            
        } else {
            durationViewController.viewModel.durationFilters = [durationFilter]
        }
        
        if let quality = qualityFilter {
            durationViewController.viewModel.durationFilters[0].qualityFilter = quality
        }
        
        if let qualityFilters = inputFilters.first?.fq {
            if durationViewController.viewModel.enableOvernightFlightQualityFilter.indices.contains(0) {
            durationViewController.viewModel.enableOvernightFlightQualityFilter[0] =  qualityFilters.values.contains(UIFilters.hideOvernightLayover.title)
            } else {
                durationViewController.viewModel.enableOvernightFlightQualityFilter.insert(qualityFilters.values.contains(UIFilters.hideOvernightLayover.title), at: 0)
            }
        }
        durationViewController.updateFiltersFromAPI()
    }
    
    private func updateDurationFilter(_ durationViewController : FlightDurationFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) {
        
        for index in 0 ..< inputFilters.count {
            
            var qualityFilter: QualityFilter?
            if durationViewController.viewModel.durationFilters.indices.contains(index) {
                qualityFilter = durationViewController.viewModel.durationFilters[index].qualityFilter
                if userSelectedFilters[index].fq.keys.contains("ovgtlo") {
                    qualityFilter?.isSelected = userSelectedFilters[index].fq["ovgtlo"] == ""
                }
            }
            
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
            
            let userTripTime = userSelectedFilters[index].tt
            let userLayoverTime = userSelectedFilters[index].lott
            
            if let userFilters = appliedAndUIFilters, userFilters.appliedFilters[0].contains(.Duration), durationViewController.viewModel.durationFilters.indices.contains(index) {
                
                if userFilters.appliedSubFilters[index].contains(.tripDuration) {
                    durationViewController.viewModel.durationFilters[index].tripDurationMinDuration = tripMinDuration
                    durationViewController.viewModel.durationFilters[index].tripDurationmaxDuration = tripMaxDuration
                    
                    let minDuration = Float(userTripTime.minTime ?? "") ?? 0
                    let maxDuration = Float(userTripTime.maxTime ?? "") ?? 0
                    durationViewController.viewModel.durationFilters[index].userSelectedTripMin = CGFloat(minDuration/3600)
                    durationViewController.viewModel.durationFilters[index].userSelectedTripMax = CGFloat(maxDuration/3600)
                }
                
                if userFilters.appliedSubFilters[index].contains(.layoverDuration) {
                    durationViewController.viewModel.durationFilters[index].layoverMinDuration = layoverMin
                    durationViewController.viewModel.durationFilters[index].layoverMaxDuration = layoverMax
                    
                    let minDuration = Float(userLayoverTime.minTime ?? "") ?? 0
                    let maxDuration = Float(userLayoverTime.maxTime ?? "") ?? 0
                    durationViewController.viewModel.durationFilters[index].userSelectedLayoverMin = CGFloat(minDuration/3600)
                    durationViewController.viewModel.durationFilters[index].userSelectedLayoverMax = CGFloat(maxDuration/3600)
                }
                
            } else {
                if !durationViewController.viewModel.durationFilters.indices.contains(index) {
                    durationViewController.viewModel.durationFilters.insert(durationFilter, at: index)
                } else {
                durationViewController.viewModel.durationFilters[index] = durationFilter
                }
            }
            if let quality = qualityFilter {
                durationViewController.viewModel.durationFilters[index].qualityFilter = quality
            }
        }
        guard durationViewController.viewModel.durationFilters.count > 0 else { return }
        if let qualityFilters = inputFilters.first?.fq {
            if durationViewController.viewModel.enableOvernightFlightQualityFilter.indices.contains(0) {
            durationViewController.viewModel.enableOvernightFlightQualityFilter[0] =  qualityFilters.values.contains(UIFilters.hideOvernightLayover.title)
            } else {
                durationViewController.viewModel.enableOvernightFlightQualityFilter.insert(qualityFilters.values.contains(UIFilters.hideOvernightLayover.title), at: 0)
            }
        }
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
        durationViewController.viewModel.showingForReturnJourney = false
        durationViewController.viewModel.legsArray = legList
        let durationFilters = createDurationFilterArray(inputFilters: inputFilters)
        durationViewController.viewModel.isIntMCOrReturnVC = true
        durationViewController.viewModel.durationFilters = durationFilters
        durationViewController.viewModel.currentDurationFilter = durationFilters[0]
        durationViewController.viewModel.delegate = delegate as? FlightDurationFilterDelegate
        durationViewController.viewModel.qualityFilterDelegate = delegate as? QualityFilterDelegate
        if let qualityFilters = inputFilters.first?.fq {
            if durationViewController.viewModel.enableOvernightFlightQualityFilter.indices.contains(0) {
            durationViewController.viewModel.enableOvernightFlightQualityFilter[0] =  qualityFilters.values.contains(UIFilters.hideOvernightLayover.title)
            } else {
                durationViewController.viewModel.enableOvernightFlightQualityFilter.insert(qualityFilters.values.contains(UIFilters.hideOvernightLayover.title), at: 0)
            }
        }
    }
    
    func setDurationVCForReturnJourney(_ durationViewController : FlightDurationFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) {
        
        durationViewController.viewModel.showingForReturnJourney = true
        durationViewController.viewModel.legsArray = [legList[0]]
        let durationFilter = createDurationFilterArrayReturnJourney(inputFilters: inputFilters)
        durationViewController.viewModel.durationFilters = [durationFilter]
        durationViewController.viewModel.currentDurationFilter = durationFilter
        durationViewController.viewModel.legsArray = [legList[0]]
        durationViewController.viewModel.delegate = delegate as? FlightDurationFilterDelegate
        durationViewController.viewModel.qualityFilterDelegate = delegate as? QualityFilterDelegate
        if let qualityFilters = inputFilters.first?.fq {
            if durationViewController.viewModel.enableOvernightFlightQualityFilter.indices.contains(0) {
            durationViewController.viewModel.enableOvernightFlightQualityFilter[0] =  qualityFilters.values.contains(UIFilters.hideOvernightLayover.title)
            } else {
                durationViewController.viewModel.enableOvernightFlightQualityFilter.insert(qualityFilters.values.contains(UIFilters.hideOvernightLayover.title), at: 0)
            }
        }
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
        airlineViewController.viewModel.airlinesFilterArray = airlineFilters
        airlineViewController.viewModel.currentSelectedAirlineFilter = airlineFilters[0]
        airlineViewController.viewModel.showingForReturnJourney = false
        airlineViewController.viewModel.isIntReturnOrMCJourney = true
        airlineViewController.viewModel.delegate = delegate as? AirlineFilterDelegate
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
        airlineViewController.viewModel.airlinesFilterArray  = [airlineLegFilter]
        airlineViewController.viewModel.currentSelectedAirlineFilter = airlineLegFilter
        airlineViewController.viewModel.showingForReturnJourney = true
        airlineViewController.viewModel.isIntReturnOrMCJourney = true
        airlineViewController.viewModel.delegate = delegate as? AirlineFilterDelegate
        
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
        
        let curSelectedFilter = airlineVC.viewModel.currentSelectedAirlineFilter
        airlineVC.viewModel.airlinesFilterArray = airlineFilters
        airlineVC.viewModel.currentSelectedAirlineFilter = airlineFilters[0]
        if appliedAndUIFilters?.appliedFilters[0].contains(.Airlines) ?? false {
            let selectedAirlines = userSelectedFilters.flatMap { $0.al }
            airlineVC.selectedAirlineArray = selectedAirlines
        }
        airlineVC.viewModel.currentSelectedAirlineFilter.hideMultipleAirline = curSelectedFilter?.hideMultipleAirline ?? false
        airlineVC.updateUIPostLatestResults()
    }
    
    //MARK:- Price
    func setPriceVC(_ priceViewController : PriceFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F])
    {
        priceViewController.viewModel.delegate = delegate as? PriceFilterDelegate
        var priceFilters = [PriceFilter]()
        let priceWS = inputFilters[0].pr
        let priceFilter = PriceFilter(onlyRefundableFaresSelected: false,
                                      inputFareMinValue: CGFloat(priceWS.minPrice) ,
                                      inputFareMaxVaule: CGFloat(priceWS.maxPrice) ,
                                      userSelectedFareMinValue: CGFloat(priceWS.minPrice) ,
                                      userSelectedFareMaxValue: CGFloat(priceWS.maxPrice) )
        
        priceFilters.append(priceFilter)
        priceViewController.viewModel.intFlightResultArray = flightResultArray
        priceViewController.viewModel.isInternational = true
        priceViewController.viewModel.legsArray = legList
        priceViewController.viewModel.allPriceFilters = priceFilters
        priceViewController.viewModel.currentPriceFilter = priceFilters[0]
    }
    
    func updatePriceVC(_ priceViewController : PriceFilterViewController , inputFilters : [IntMultiCityAndReturnWSResponse.Results.F]) {
        
        for (index, filter) in inputFilters.enumerated() {
            let newPriceWS = filter.pr
            
            var onlyRefundableSelected = false
            if let userFilters = appliedAndUIFilters, userFilters.uiFilters[0].contains(.refundableFares) {
                onlyRefundableSelected = true
            }

            let newPriceFilter = PriceFilter(onlyRefundableFaresSelected: onlyRefundableSelected,
                                             inputFareMinValue: CGFloat(newPriceWS.minPrice) ,
                                             inputFareMaxVaule: CGFloat(newPriceWS.maxPrice) ,
                                             userSelectedFareMinValue: CGFloat(newPriceWS.minPrice) ,
                                             userSelectedFareMaxValue: CGFloat(newPriceWS.maxPrice) )
            
            let userFilter = userSelectedFilters[index].pr
            
            if let userFilters = appliedAndUIFilters, userFilters.appliedFilters[0].contains(.Price), priceViewController.viewModel.allPriceFilters.indices.contains(index) {
                
                if userFilters.uiFilters[0].contains(.refundableFares){
                    priceViewController.viewModel.allPriceFilters[index].onlyRefundableFaresSelected = true
                }

                let onlyRefundable = priceViewController.viewModel.allPriceFilters[index].onlyRefundableFaresSelected
                
                if userFilters.uiFilters[0].contains(.priceRange) {
                    priceViewController.viewModel.allPriceFilters[index].inputFareMinValue = newPriceFilter.inputFareMinValue
                    
                    priceViewController.viewModel.allPriceFilters[index].inputFareMaxVaule = newPriceFilter.inputFareMaxVaule
                    priceViewController.viewModel.allPriceFilters[index].userSelectedFareMinValue = CGFloat(userFilter.minPrice)
                    
                    priceViewController.viewModel.allPriceFilters[index].userSelectedFareMaxValue = CGFloat(userFilter.maxPrice)
                    
                } else {
                    priceViewController.viewModel.allPriceFilters[index] = newPriceFilter
                }
                
                priceViewController.viewModel.allPriceFilters[index].onlyRefundableFaresSelected = onlyRefundable
                
            } else {
                if !priceViewController.viewModel.allPriceFilters.indices.contains(index) {
                    priceViewController.viewModel.allPriceFilters.insert(newPriceFilter, at: index)
                } else {
                    priceViewController.viewModel.allPriceFilters[index] = newPriceFilter
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
                    
                    if let airport = airportsDetails[airportcode]{
                        let name = airport.n
                        let airportCity = airport.c
                        cityName = airportCity
                        let airportCode = airportcode
                        
                        let displayModel = Airport(name : name, IATACode:airportCode, city: airportCity )
                        airportsArray.append(displayModel)
                        
                    }
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
                    
                    guard let airport = airportsDetails[airportcode] else { continue }
                    
                    let name = airport.n
                    let airportCity = airport.c
                    cityName = airportCity
                    let airportCode = airportcode
                    
                    let displayModel = Airport(name : name, IATACode:airportCode, city: airportCity )
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
                
                airportViewController.airportFilterArray[0].originCities = airportViewController.airportFilterArray[0].originCities.filter { !$0.airports.isEmpty }
                
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
                
                airportViewController.airportFilterArray[0].destinationCities = airportViewController.airportFilterArray[0].destinationCities.filter { !$0.airports.isEmpty }
                
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
            
            
            if let userFilters = appliedAndUIFilters, userFilters.appliedFilters[0].contains(.Airport), airportViewController.airportFilterArray.indices.contains(index) {
                let curAiportFilter = airportViewController.airportFilterArray[index]
                
                let allLayoversSelected = curAiportFilter.allLayoverSelectedByUserInteraction
                
                let inputOriginAirports = inputFilters[index].cityapn.fr.values.flatMap { $0.map { $0 } }
                let originSelectedAirports = userSelectedFilters[index].cityapn.fr.values.flatMap { $0.map { $0 } }
                
                let inputDestAirports = inputFilters[index].cityapn.to.values.flatMap { $0.map { $0 } }
                let destSelectedAirports = userSelectedFilters[index].cityapn.to.values.flatMap { $0.map { $0 } }
                
                let inputLayoverAirports = inputFilters[index].loap
                let userSelectedLayoverAirports = userSelectedFilters[index].loap
                
                if (userFilters.uiFilters[0].contains(.originAirports)) {
                    airportLegFilter.originCities = airportLegFilter.originCities.map { (city) in
                        var newCity = city
                        newCity.airports = newCity.airports.map({ (airport) in
                            var newAirport = airport
                            if (originSelectedAirports.contains(newAirport.IATACode) && inputOriginAirports.count != originSelectedAirports.count) {
                                newAirport.isSelected = true
                            }
                            return newAirport
                        })
                        return newCity
                    }
                }
                
                if (userFilters.uiFilters[0].contains(.destinationAirports)) {
                    airportLegFilter.destinationCities = airportLegFilter.destinationCities.map { (city) in
                        var newCity = city
                        newCity.airports = newCity.airports.map({ (airport) in
                            var newAirport = airport
                            if (destSelectedAirports.contains(newAirport.IATACode) && inputDestAirports.count != destSelectedAirports.count) {
                                newAirport.isSelected = true
                            }
                            return newAirport
                        })
                        return newCity
                    }
                }
                
                if (userSelectedLayoverAirports.count != inputLayoverAirports.count) && userFilters.uiFilters[0].contains(.layoverAirports) {
                    airportLegFilter.layoverCities = airportLegFilter.layoverCities.map { (city) in
                        var newCity = city
                        newCity.airports = newCity.airports.map({ (airport) in
                            var newAirport = airport
                            if userSelectedLayoverAirports.contains(newAirport.IATACode) || allLayoversSelected {
                                newAirport.isSelected = true
                            }
                            return newAirport
                        })
                        return newCity
                    }
                }
                airportLegFilter.allLayoverSelectedByUserInteraction = allLayoversSelected
                
                airportViewController.airportFilterArray[index] = airportLegFilter
                
                // For setting pre-selected airports in return filter
                if userFilters.uiFilters[0].contains(.originDestinationSelectedForReturnJourney) {
                    let returnOriginAP = userSelectedFilters[0].cityapn.returnOriginAirports
                    let returnDestAP = userSelectedFilters[0].cityapn.returnDestinationAirports
                
                    
                    airportViewController.airportFilterArray[0].originCities = airportViewController.airportFilterArray[0].originCities.map { (city) in
                        var newCity = city
                        newCity.airports = newCity.airports.map({ (airport) in
                            var newAirport = airport
                            if (returnOriginAP.contains(newAirport.IATACode)) {
                                newAirport.isSelected = true
                            }
                            return newAirport
                        })
                        return newCity
                    }
                    
                    airportViewController.airportFilterArray[0].destinationCities = airportViewController.airportFilterArray[0].destinationCities.map { (city) in
                        var newCity = city
                        newCity.airports = newCity.airports.map({ (airport) in
                            var newAirport = airport
                            if (returnDestAP.contains(newAirport.IATACode)) {
                                newAirport.isSelected = true
                            }
                            return newAirport
                        })
                        return newCity
                    }
                }
                
                
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
    
    
    func setAircraftFilterVC(_ aircraftViewController : AircraftFilterViewController) {
        DispatchQueue.main.async {
            let aircraftVc = aircraftViewController as AircraftFilterViewController
            aircraftVc.loadViewIfNeeded()
            aircraftVc.flightSearchParameters = self.flightSearchParameters
            aircraftVc.delegate = self.delegate as? AircraftFilterDelegate
            aircraftVc.updateAircraftList(filter: self.updatedAircraftFilter)
        }
    }
}


