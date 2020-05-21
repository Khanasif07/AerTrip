//
//  AirportsFilterViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


protocol AirportFilterDelegate : FilterDelegate {
    
    func originSelectionChanged(selection : [AirportsGroupedByCity]  ,at index : Int )
    func destinationSelectionChanged(selection : [AirportsGroupedByCity] ,at index : Int )
    func sameSourceDestinationSelected(at index : Int)
    func layoverSelectionsChanged(selection : [LayoverDisplayModel] , at index : Int )
    func allLayoverSelectedAt( index : Int)
    func allOriginDestinationAirportsSelectedAt( index : Int)
    func airportSelectionChangedForReturnJourneys(originAirports: [AirportsGroupedByCity], destinationAirports: [AirportsGroupedByCity])
    func layoverSelectionsChangedForReturnJourney(selection : [LayoverDisplayModel] , at index : Int)
    func allLayoversSelectedInReturn()
}

extension AirportFilterDelegate {
    func layoverSelectionsChangedForReturnJourney(selection : [LayoverDisplayModel] , at index : Int) { }
    func allLayoversSelectedInReturn() { }
}


class AirportsFilterViewController: UIViewController , FilterViewController {

    //MARK:- TableViews and ScrollView Outlets

    @IBOutlet weak var originsTableView: UITableView!
    @IBOutlet weak var destinationsTableView: UITableView!
    @IBOutlet weak var layoverTableview: UITableView!
    @IBOutlet weak var baseScrollview: UIScrollView!

    //MARK:- View Outlets
    @IBOutlet weak var multicitySegmentView: UIView!
    @IBOutlet weak var journeyTitle: UILabel!
    @IBOutlet weak var originSeparator: UIView!
    @IBOutlet weak var sameDepartReturnView: UIView!
    @IBOutlet weak var sameDepartReturnLbl: UILabel!
    @IBOutlet weak var sameDepartReturnBtn: UIButton!
    @IBOutlet weak var originDestinationView: UIView!
    @IBOutlet weak var originDestinationLbl: UILabel!
    @IBOutlet weak var originDestinationBtn: UIButton!
    @IBOutlet weak var multiCitySegmentSeparator: UIView!
    @IBOutlet weak var destinationSeparatorView: UIView!
    @IBOutlet weak var layoverSeparatorView: UIView!
    @IBOutlet weak var allLayoverButton: UIButton!
    //MARK:- Height Constraints Outlets
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var originTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var destinationTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var layoverTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var originDestinationSameViewHeight: NSLayoutConstraint!
    @IBOutlet weak var OriginDestinationViewHeight: NSLayoutConstraint!
    
    //MARK:- Top Constraints Outletss
    @IBOutlet weak var layOverSeparatorTop: NSLayoutConstraint!
    @IBOutlet weak var destinationTopViewSpacing: NSLayoutConstraint!
    
    //MARK:- State Properties
    weak var delegate : AirportFilterDelegate?
    var currentActiveIndex = 0
    var airportFilterArray  = [AirportLegFilter]()
    var currentAirportFilter : AirportLegFilter!
    var searchType : FlightSearchType? 
    var allLayoverSelectedByUserInteraction = false
    
    private var allOriginDestSelectedAtIndex: [Int: Bool] = [:]
    var isIntReturnOrMCJourney = false
    private var tableOffsetAtIndex: [Int: CGFloat] = [:]
    var areAllDepartReturnNotSame = false {
        didSet {
            checkForDepartReturnSame()
        }
    }
    
    //MARK:- View Controller Method
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    
    //MARK:- Additional Setup
    fileprivate func setupTopView() {
        
        if airportFilterArray.count == 1 {
            topViewHeight.constant = 0
            journeyTitle.isHidden = true
            return
        }
        
        if searchType == MULTI_CITY {
           
            if airportFilterArray.count > 3 {
                topViewHeight.constant = 94
                journeyTitle.isHidden = false
            }else {
                    topViewHeight.constant = 62
                    journeyTitle.isHidden = true
            }
            return
        }
    
        if searchType == RETURN_JOURNEY {
                topViewHeight.constant = 0
                journeyTitle.isHidden = true
        }
    }
    
    
    fileprivate func setupOriginTable(_ zeroRectView: UIView) {
        
        originsTableView.tableFooterView = zeroRectView
        originsTableView.separatorStyle = .none
        
        originsTableView.register(UINib(nibName: "AirportSelectionCell", bundle: nil), forCellReuseIdentifier: "OriginCells")
        originsTableView.isScrollEnabled = false
        
        originsTableView.dataSource = self
        originsTableView.delegate = self
        
        originsTableView.reloadData()
    }
    
    fileprivate func setdestinationTable(_ zeroRectView: UIView) {
        
        destinationsTableView.tableFooterView = zeroRectView
        destinationsTableView.separatorStyle = .none
        
        destinationsTableView.register(UINib(nibName: "AirportSelectionCell", bundle: nil), forCellReuseIdentifier: "DestinationCells")
        destinationsTableView.isScrollEnabled = false
        destinationsTableView.dataSource = self
        destinationsTableView.delegate = self
        destinationsTableView.reloadData()
    }
    
    fileprivate func setupLayoverTable(_ zeroRectView: UIView) {
        layoverTableview.tableFooterView = zeroRectView
        layoverTableview.separatorStyle = .none
        layoverTableview.register(UINib(nibName: "AirportSelectionCell", bundle: nil), forCellReuseIdentifier: "LayOverCells")
        layoverTableview.isScrollEnabled = false
        layoverTableview.dataSource = self
        layoverTableview.delegate = self
        layoverTableview.reloadData()
    }
    
    fileprivate func setupScrollView() {
        
        if isIntReturnOrMCJourney {
            baseScrollview.contentOffset.y = tableOffsetAtIndex[currentActiveIndex] ?? 0
            
            currentAirportFilter = airportFilterArray[currentActiveIndex]
            
            originDestinationBtn.isSelected = currentAirportFilter.allOriginDestinationSelected()
                        
            allLayoverButton.isSelected = currentAirportFilter.allLayoverSelected()
            
            currentAirportFilter.originCities = currentAirportFilter.originCities.map { (city) in
                var newCity = city
                newCity.airports.sort(by: { $0.name < $1.name })
                return newCity
            }
            currentAirportFilter.originCities.sort(by: { $0.name < $1.name })
            
            currentAirportFilter.destinationCities = currentAirportFilter.destinationCities.map { (city) in
                var newCity = city
                newCity.airports.sort(by: { $0.name < $1.name })
                return newCity
            }
            currentAirportFilter.destinationCities.sort(by: { $0.name < $1.name })
            
//            if searchType == RETURN_JOURNEY {
//                currentAirportFilter.layoverCities = airportFilterArray.flatMap { $0.layoverCities }
//            }
        }
        
//        if let allAirportsSelected = allOriginDestSelectedAtIndex[currentActiveIndex] {
//            originDestinationBtn.isSelected = allAirportsSelected
//            currentAirportFilter.originCities = currentAirportFilter.originCities.map {
//                var newAirport = $0
//                newAirport.selectAll(allAirportsSelected)
//                return newAirport
//            }
//            currentAirportFilter.destinationCities = currentAirportFilter.destinationCities.map {
//                var newAirport = $0
//                newAirport.selectAll(allAirportsSelected)
//                return newAirport
//            }
//        }
        
        // Setup Origin Table
        let zeroRectView = UIView(frame: .zero)
        setupOriginTable(zeroRectView)
       
        if currentAirportFilter.originAirportsCount == 1 {
            self.originTableViewHeight.constant = 0
            self.destinationTopViewSpacing.constant = 0
        }
        else {
            self.destinationTopViewSpacing.constant = 16
            self.originTableViewHeight.constant = self.originsTableView.contentSize.height
        }
       
        // Setup Destinations Table
        setdestinationTable(zeroRectView)
        if currentAirportFilter.destinationAirportsCount == 1  {
             self.destinationTableViewHeight.constant = 0
        }
        else {

            self.destinationTableViewHeight.constant = self.destinationsTableView.contentSize.height
        }

        if self.originTableViewHeight.constant != 0 &&  self.destinationTableViewHeight.constant != 0 {
            destinationSeparatorView.isHidden = false
        }
        else {
            destinationSeparatorView.isHidden = true
        }
        setupLayoverTable(zeroRectView)
        self.layoverTableViewHeight.constant = self.layoverTableview.contentSize.height
  
        
        if isIntReturnOrMCJourney {
            if searchType == RETURN_JOURNEY {
                checkForDepartReturnSame()
            } else {
                if currentAirportFilter.originAirportsCount > 1 || currentAirportFilter.destinationAirportsCount > 1 {
                    originDestinationView.isHidden = false
                } else {
                    originDestinationView.isHidden = true
                }
            }
        }
        
//        if self.searchType != RETURN_JOURNEY {
//            SameDepartReturn.isHidden = true
//            originDestinationSameViewHeight.constant = 0
//        }
//
//        if self.searchType == RETURN_JOURNEY {
//            if currentAirportFilter.originAirportsCount > 1 || currentAirportFilter.destinationAirportsCount > 1 {
//                SameDepartReturn.isHidden = false
//                originDestinationSameViewHeight.constant = 60.0
//            }
//            else {
//                SameDepartReturn.isHidden = true
//                originDestinationSameViewHeight.constant = 0
//
//            }
//        }
        
        if currentAirportFilter.originAirportsCount == 1 && currentAirportFilter.destinationAirportsCount == 1 {
            layOverSeparatorTop.constant = 0
            layoverSeparatorView.alpha = 0
        } else {
            layOverSeparatorTop.constant = 16
            layoverSeparatorView.alpha = 1
        }
        
     self.view.layoutSubviews()

    }
    
    private func checkForDepartReturnSame() {
        guard currentAirportFilter != nil && sameDepartReturnView != nil else { return }
        if (currentAirportFilter.originAirportsCount > 1 || currentAirportFilter.destinationAirportsCount > 1) && areAllDepartReturnNotSame {
            sameDepartReturnView.isHidden = false
        } else {
            sameDepartReturnView.isHidden = true
        }
    }
    
    fileprivate func setmultiLegSubviews () {
        
        multicitySegmentView.subviews.forEach { $0.removeFromSuperview() }
        multiCitySegmentSeparator.alpha = 0.0
        if airportFilterArray.count == 1 || self.searchType == RETURN_JOURNEY {
            return
        }
        
        multicitySegmentView.layer.cornerRadius = 3
        multicitySegmentView.layer.borderColor = UIColor.AertripColor.cgColor
        multicitySegmentView.layer.borderWidth = 1.0
        multicitySegmentView.clipsToBounds = true
        
        let numberOfStops = airportFilterArray.count
        
        for  i in 1...numberOfStops  {
            
            let segmentViewWidth = UIScreen.main.bounds.size.width - 32
            let width = segmentViewWidth / CGFloat(numberOfStops)
            let xcordinate = CGFloat( i - 1 ) * width
            let height = self.multicitySegmentView.frame.size.height
            var rect = CGRect(x: xcordinate, y: 0, width: width, height: height)
            let stopButton = UIButton(frame: rect)
            stopButton.tag = (i - 1)

            let currentFilter = airportFilterArray[(i - 1)]
            var normalStateTitle : NSMutableAttributedString
            let isCurrentIndexActive = (i == (currentActiveIndex + 1 )) ? true : false
            let isFilterApplied = currentFilter.filterApplied()

            
            if isCurrentIndexActive {
                stopButton.backgroundColor = UIColor.AertripColor
            }
            
            
            if numberOfStops > 3 {
                
                let dot = "\u{2022}"
                let font = UIFont(name: "SourceSansPro-Semibold", size: 14.0)!
                let aertripColorAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : UIColor.AertripColor]
                let whiteColorAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor :  UIColor.white]
                let clearColorAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : UIColor.clear]
                
                
                if isCurrentIndexActive {
                    normalStateTitle = NSMutableAttributedString(string: "\(i) " , attributes: whiteColorAttributes)
                    
                    let dotString : NSAttributedString
                    if isFilterApplied {
                        dotString = NSMutableAttributedString(string: dot , attributes: whiteColorAttributes)
                    }
                    else {
                        dotString = NSMutableAttributedString(string: dot , attributes: clearColorAttributes)
                    }
                    normalStateTitle.append(dotString)
                }
                else {
                    normalStateTitle = NSMutableAttributedString(string: "\(i) " , attributes: aertripColorAttributes)
                    let dotString : NSAttributedString
                    
                    if isFilterApplied {
                        dotString = NSMutableAttributedString(string: dot , attributes: aertripColorAttributes)
                    }
                    else {
                        dotString = NSMutableAttributedString(string: dot , attributes: clearColorAttributes)
                    }
                    normalStateTitle.append(dotString)
                }
            }
            else {
                let leg = airportFilterArray[(i - 1)].leg
                normalStateTitle = leg.getTitle(isCurrentlySelected: isCurrentIndexActive, isFilterApplied: isFilterApplied)
            }

            stopButton.setAttributedTitle(normalStateTitle, for: .normal)
            stopButton.addTarget(self, action: #selector(tappedOnMulticityButton(sender:)), for: .touchDown)
            
            multicitySegmentView.addSubview(stopButton)
            
            if i != numberOfStops {
                rect  = CGRect(x: xcordinate + width - 1 , y: 0, width: 1, height: 30)
                let verticalSeparator = UIView(frame: rect)
                verticalSeparator.backgroundColor = UIColor.AertripColor
                multicitySegmentView.addSubview(verticalSeparator)
            }
        }
    }
    
    //MARK:- FilterViewController Methods
    func initialSetup() {
        originDestinationView.isHidden = true
        sameDepartReturnView.isHidden = true
        setupTopView()
        
        if airportFilterArray.count > 1 {
            setmultiLegSubviews()
        }
        setupScrollView()
    }
    func updateUIPostLatestResults() {
        
        if allLayoverSelectedByUserInteraction {
            currentAirportFilter.layoverCities = currentAirportFilter.layoverCities.map { var newAirport = $0
                newAirport.selectAll(true)
                return newAirport
            }
        }
        setupTopView()
        journeyTitle.attributedText = currentAirportFilter.leg.descriptionOneFiveThree
        setupScrollView()
        setmultiLegSubviews()

    }
    
    func resetFilter() {
        
        for i in 0 ..< airportFilterArray.count {
            
            var filter = airportFilterArray[i]
            
            if isIntReturnOrMCJourney {
                currentAirportFilter = filter
            }
           
            filter.originCities = currentAirportFilter.originCities.map { var newAirport = $0
                newAirport.selectAll(false)
                return newAirport
            }
            
            filter.destinationCities = currentAirportFilter.destinationCities.map { var newAirport = $0
                newAirport.selectAll(false)
                return newAirport
            }
            
            filter.layoverCities = currentAirportFilter.layoverCities.map { var newAirport = $0
                newAirport.selectAll(false)
                return newAirport
            }
            airportFilterArray[i] = filter
        }
        currentAirportFilter.sameDepartReturnSelected = false
        sameDepartReturnBtn.isSelected = false
        
        currentAirportFilter = airportFilterArray[currentActiveIndex]
        if !isIntReturnOrMCJourney {
            allLayoverButton.isSelected = false
            allLayoverSelectedByUserInteraction = false
        }
        setmultiLegSubviews ()
        originsTableView.reloadData()
        destinationsTableView.reloadData()
        layoverTableview.reloadData()
        tableOffsetAtIndex[currentActiveIndex] = baseScrollview.contentOffset.y
    }
    
    
    //MARK:- IBAction Methods
    @objc func originAirportTapped(sender : UIButton) {
        tableOffsetAtIndex[currentActiveIndex] = baseScrollview.contentOffset.y
        sender.isSelected.toggle()
        let section = sender.tag / 100
        let row = sender.tag % 100
        
        var airports = currentAirportFilter.originCities[section].airports
        var currentAirport = airports[row]
        
        currentAirport.isSelected = sender.isSelected
        airports[row] = currentAirport
        currentAirportFilter.originCities[section].airports = airports
        
        guard  currentAirportFilter != nil else {
            return
        }
        airportFilterArray[currentActiveIndex] = currentAirportFilter
        
        originDestinationBtn.isSelected = currentAirportFilter.allOriginDestinationSelected()
        
        setmultiLegSubviews ()
        if searchType == RETURN_JOURNEY {
//            delegate?.originSelectionChanged(selection: currentAirportFilter.originCities ,at: 0)
//            delegate?.originSelectionChanged(selection: currentAirportFilter.originCities ,at: 1)
            
//            var combinedData = currentAirportFilter.originCities
//            combinedData.append(contentsOf: currentAirportFilter.destinationCities)
            delegate?.airportSelectionChangedForReturnJourneys(originAirports: currentAirportFilter.originCities, destinationAirports: currentAirportFilter.destinationCities)
            
        } else {
            delegate?.originSelectionChanged(selection: currentAirportFilter.originCities ,at: currentActiveIndex)
        }
    }
    
    
    @objc fileprivate func tappedOnMulticityButton( sender : UIButton) {
        tableOffsetAtIndex[currentActiveIndex] = baseScrollview.contentOffset.y
        let tag = sender.tag
        
        if tag == currentActiveIndex {
            return
        }
        else {
            airportFilterArray[currentActiveIndex] = currentAirportFilter
            currentActiveIndex = tag
        }
        
        currentAirportFilter = airportFilterArray[currentActiveIndex]
        journeyTitle.attributedText = currentAirportFilter.leg.descriptionOneFiveThree
        originsTableView.reloadData()
        destinationsTableView.reloadData()
        layoverTableview.reloadData()
        setmultiLegSubviews ()
        
        setupScrollView()
    }
    
    @objc func layoverAirportTapped(sender: UIButton){
        tableOffsetAtIndex[currentActiveIndex] = baseScrollview.contentOffset.y
        sender.isSelected.toggle()
        
        let section = sender.tag / 100
        let row = sender.tag % 100
        
        var airports = currentAirportFilter.layoverCities[section].airports
        var currentAirport = airports[row]
        currentAirport.isSelected = sender.isSelected
        airports[row] = currentAirport
        currentAirportFilter.layoverCities[section].airports = airports
        
        let combinedSelectionStatus = currentAirportFilter.allLayoverSelected()
        if !isIntReturnOrMCJourney {
            allLayoverSelectedByUserInteraction = combinedSelectionStatus
        }
        allLayoverButton.isSelected = combinedSelectionStatus
        
        airportFilterArray[currentActiveIndex] = currentAirportFilter
        setmultiLegSubviews ()
        if searchType == RETURN_JOURNEY {
            if isIntReturnOrMCJourney {
                delegate?.layoverSelectionsChangedForReturnJourney(selection: currentAirportFilter.layoverCities, at: 0)
            } else {
                delegate?.layoverSelectionsChanged(selection: currentAirportFilter.layoverCities, at: 0)
                delegate?.layoverSelectionsChanged(selection: currentAirportFilter.layoverCities, at: 1)
            }
        }
        else {
            delegate?.layoverSelectionsChanged(selection: currentAirportFilter.layoverCities, at: currentActiveIndex)
        }
        
    }
    
    
    @objc func destinationAirportTapped(sender : UIButton) {
        tableOffsetAtIndex[currentActiveIndex] = baseScrollview.contentOffset.y
        sender.isSelected.toggle()
        let section = sender.tag / 100
        let row = sender.tag % 100
        
        var airports = currentAirportFilter.destinationCities[section].airports
        var currentAirport = airports[row]
        currentAirport.isSelected = sender.isSelected
        airports[row] = currentAirport
        currentAirportFilter.destinationCities[section].airports = airports
        
        guard  let airportFilter  = currentAirportFilter else {
            return
        }
        
        airportFilterArray[currentActiveIndex] = currentAirportFilter
        
        originDestinationBtn.isSelected = currentAirportFilter.allOriginDestinationSelected()
        
        setmultiLegSubviews ()
        
        if searchType == RETURN_JOURNEY {
//            delegate?.destinationSelectionChanged(selection :  airportFilter.destinationCities  ,at: 0)
//            delegate?.destinationSelectionChanged(selection :  airportFilter.destinationCities  ,at: 1)
//            var combinedData = currentAirportFilter.originCities
//                       combinedData.append(contentsOf: currentAirportFilter.destinationCities)
            delegate?.airportSelectionChangedForReturnJourneys(originAirports: currentAirportFilter.originCities, destinationAirports: currentAirportFilter.destinationCities)
        }else {
            delegate?.destinationSelectionChanged(selection :  airportFilter.destinationCities  ,at: currentActiveIndex)
        }
    }
    
    @IBAction func sameDepartReturnBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        currentAirportFilter.sameDepartReturnSelected = sender.isSelected
        delegate?.sameSourceDestinationSelected(at: 0)
    }
    
    
    
    @IBAction func OriginDestinationSelected(_ sender: UIButton) {
        
         sender.isSelected.toggle()
        guard var newAirportFilter = currentAirportFilter else { return }
        newAirportFilter.originCities = currentAirportFilter.originCities.map { var newAirport = $0
            newAirport.selectAll( sender.isSelected)
            return newAirport
        }
        
        newAirportFilter.destinationCities = currentAirportFilter.destinationCities.map { var newAirport = $0
            newAirport.selectAll( sender.isSelected )
            return newAirport
        }
        currentAirportFilter = newAirportFilter
        airportFilterArray[currentActiveIndex] = currentAirportFilter
        
//        allOriginDestSelectedAtIndex[currentActiveIndex] = sender.isSelected
        setmultiLegSubviews()
        
        originsTableView.reloadData()
        destinationsTableView.reloadData()
        self.delegate?.allOriginDestinationAirportsSelectedAt(index: currentActiveIndex )
        
        
    }
    @IBAction func AllLayoversSelected(_ sender: UIButton ) {
        tableOffsetAtIndex[currentActiveIndex] = baseScrollview.contentOffset.y
        sender.isSelected.toggle()

        currentAirportFilter.layoverCities = currentAirportFilter.layoverCities.map { var newAirport = $0
            newAirport.selectAll(sender.isSelected  )
            return newAirport
        }
        if !isIntReturnOrMCJourney {
            allLayoverSelectedByUserInteraction  = sender.isSelected
        }
        airportFilterArray[currentActiveIndex] = currentAirportFilter
        setmultiLegSubviews ()
        layoverTableview.reloadData()
        if searchType == RETURN_JOURNEY {
            if isIntReturnOrMCJourney {
                self.delegate?.allLayoversSelectedInReturn()
                return
            }
            
            self.delegate?.allLayoverSelectedAt(index: 0)
            self.delegate?.allLayoverSelectedAt(index: 1)
        }
        else {
            self.delegate?.allLayoverSelectedAt(index: currentActiveIndex)
        }
        
    }
}



extension AirportsFilterViewController : UITableViewDataSource , UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.originsTableView {
            
            let airports = currentAirportFilter.originCities[section].airports

            return airports.count
            
        }
        
        
        if tableView == self.destinationsTableView {
            
            let airports = currentAirportFilter.destinationCities[section].airports

            return airports.count
        }
        
        
        if tableView == self.layoverTableview {
            let airports = currentAirportFilter.layoverCities[section].airports
            return airports.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == originsTableView {
            
            if let cell = originsTableView.dequeueReusableCell(withIdentifier: "OriginCells") as? AirportSelectionCell {
                cell.selectionStyle = .none
                
                let airports = currentAirportFilter.originCities[indexPath.section].airports
                let currentAirport = airports[indexPath.row]
                cell.airportCode.text = currentAirport.IATACode
                cell.airportName?.text = currentAirport.name
                cell.radioButton.isSelected = currentAirport.isSelected
                cell.radioButton.addTarget(self, action: #selector(originAirportTapped(sender:)), for: .touchDown)
                cell.radioButton.tag = indexPath.section * 100 + indexPath.row
                cell.backgroundColor = .clear
                return cell
            }
        }
        
        if tableView == destinationsTableView {

            if let cell = destinationsTableView.dequeueReusableCell(withIdentifier: "DestinationCells") as? AirportSelectionCell {
                cell.selectionStyle = .none

                let airports = currentAirportFilter.destinationCities[indexPath.section].airports
                let currentAirport = airports[indexPath.row]
                cell.airportCode.text = currentAirport.IATACode
                cell.airportName?.text = currentAirport.name
                cell.radioButton.isSelected = currentAirport.isSelected
                cell.radioButton.addTarget(self, action: #selector(destinationAirportTapped(sender:)), for:.touchDown)
                cell.radioButton.tag = indexPath.section * 100 + indexPath.row
                cell.backgroundColor = .clear
                return cell
            }
        }
        
        if tableView == layoverTableview {
            
            if let cell = layoverTableview.dequeueReusableCell(withIdentifier: "LayOverCells") as? AirportSelectionCell {
                cell.selectionStyle = .none
                
                let airports = currentAirportFilter.layoverCities[indexPath.section].airports
                let currentAirport = airports[indexPath.row]
                cell.airportCode.text = currentAirport.IATACode
                cell.airportName?.text = currentAirport.city
                cell.radioButton.isSelected = currentAirport.isSelected
                if allLayoverSelectedByUserInteraction {
                   cell.radioButton.isSelected  = true
                }
                cell.radioButton.addTarget(self, action: #selector(layoverAirportTapped(sender:)), for: .touchDown)
                cell.radioButton.tag = indexPath.section * 100 + indexPath.row
                cell.backgroundColor = .clear
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        // Hiding country name if only all the layover cities are from same country
        if tableView == layoverTableview {
            if currentAirportFilter.layoverCities.count == 1 {
                return nil
            }
        }
        
        
        let view = UIView()
        
        let title = UILabel(frame: CGRect(x: 16, y: 16, width: self.view.frame.size.width - 16, height: 20))
        title.font = UIFont(name: "sourceSansPro-Regular", size: 16)
        title.textColor = UIColor.ONE_FIVE_THREE_COLOR
        title.textAlignment = .left
        view.addSubview(title)
        
        
        if tableView == originsTableView {
            title.text = currentAirportFilter.originCities[section].name
        }
        
        if tableView == destinationsTableView {
            title.text = currentAirportFilter.destinationCities[section].name
        }

        if tableView == layoverTableview {
            title.text = currentAirportFilter.layoverCities[section].country
        }
        return view
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        // Hiding country name if only all the layover cities are from same country
        if tableView == layoverTableview {
            if currentAirportFilter.layoverCities.count == 1 {
                return 0.0
            }
        }

        return 40.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == originsTableView {
            return currentAirportFilter.originCities.count
        }
        
        if tableView == destinationsTableView {
            return currentAirportFilter.destinationCities.count
        }
        
        if tableView == layoverTableview {
            return currentAirportFilter.layoverCities.count
        }
        return 0
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset.y
        multiCitySegmentSeparator.alpha = contentOffset / 100.0
    }
    
}

