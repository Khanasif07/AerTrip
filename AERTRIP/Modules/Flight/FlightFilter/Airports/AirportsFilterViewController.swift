//
//  AirportsFilterViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit
import SnapKit

protocol AirportFilterDelegate : FilterDelegate {
    
    func originSelectionChanged(selection : [AirportsGroupedByCity]  ,at index : Int )
    func destinationSelectionChanged(selection : [AirportsGroupedByCity] ,at index : Int )
    func sameSourceDestinationSelected(at index : Int, selected: Bool)
    func layoverSelectionsChanged(selection : [LayoverDisplayModel] , at index : Int )
    func allLayoverSelectedAt( index : Int, selected: Bool)
    func allOriginDestinationAirportsSelectedAt( index : Int)
    func airportSelectionChangedForReturnJourneys(originAirports: [AirportsGroupedByCity], destinationAirports: [AirportsGroupedByCity])
    func layoverSelectionsChangedForReturnJourney(selection : [LayoverDisplayModel] , at index : Int)
    func allLayoversSelectedInReturn(selected: Bool)
}

extension AirportFilterDelegate {
    func layoverSelectionsChangedForReturnJourney(selection : [LayoverDisplayModel] , at index : Int) { }
    func allLayoversSelectedInReturn(selected: Bool) { }
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
    @IBOutlet weak var layoverTitleLbl: UILabel!
    @IBOutlet weak var allLayoverButton: UIButton!
    @IBOutlet weak var allLayoversContainerBtn: UIButton!
    @IBOutlet weak var noLayoversLbl: UILabel!
    @IBOutlet weak var sameDepartReturnTopBtn: UIButton!
    
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
    
    private var allOriginDestSelectedAtIndex: [Int: Bool] = [:]
    var isIntReturnOrMCJourney = false
    private var tableOffsetAtIndex: [Int: CGFloat] = [:]
    var areAllDepartReturnNotSame = false {
        didSet {
            checkForDepartReturnSame()
        }
    }
    
    private var multiLegSegmentControl: UISegmentedControl?
    
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
            
        } else {
            currentAirportFilter = airportFilterArray[currentActiveIndex]
            currentAirportFilter.originCities = currentAirportFilter.originCitiesSortedArray
            currentAirportFilter.destinationCities = currentAirportFilter.destinationCitiesSortedArray
            currentAirportFilter.layoverCities = currentAirportFilter.layoverCities.sorted(by: {$0.country < $1.country})
            allLayoverButton.isSelected = currentAirportFilter.allLayoverSelected()
        }
        
        // Setup Origin Table
        let zeroRectView = UIView(frame: .zero)
        setupOriginTable(zeroRectView)
       
        if currentAirportFilter.originAirportsCount <= 1 {
            self.originTableViewHeight.constant = 0
            self.destinationTopViewSpacing.constant = 0
        }
        else {
            self.originTableViewHeight.constant = self.originsTableView.contentSize.height
        }
       
        // Setup Destinations Table
        setdestinationTable(zeroRectView)
        if currentAirportFilter.destinationAirportsCount <= 1  {
             self.destinationTableViewHeight.constant = 0
        }
        else {
            self.destinationTopViewSpacing.constant = originTableViewHeight.constant == 0 ? 0 : 16
            self.destinationTableViewHeight.constant = self.destinationsTableView.contentSize.height
        }

        if self.originTableViewHeight.constant != 0 &&  self.destinationTableViewHeight.constant != 0 {
            destinationSeparatorView.isHidden = false
        }
        else {
            destinationSeparatorView.isHidden = true
        }
        setupLayoverTable(zeroRectView)
        if currentAirportFilter.layoverAirportsCount < 1 {
            layoverTitleLbl.isHidden = true
            allLayoverButton.isHidden = true
            self.layoverTableViewHeight.constant = 0
        } else {
            layoverTitleLbl.isHidden = false
            allLayoverButton.isHidden = false
            self.layoverTableViewHeight.constant = self.layoverTableview.contentSize.height
        }
  
        
        if isIntReturnOrMCJourney {
            if searchType == RETURN_JOURNEY {
                checkForDepartReturnSame()
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
        } else if destinationTableViewHeight.constant == 0 {
            layOverSeparatorTop.constant = 0
            layoverSeparatorView.alpha = 1
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
    
    
    private func setupMultiLegSegmentControl() {
        
        if airportFilterArray.count == 1 || self.searchType == RETURN_JOURNEY {
            return
        }
                
        multiLegSegmentControl?.removeAllSegments()
        
        let numberOfStops = airportFilterArray.count

        for  index in 1...numberOfStops  {
            let segmentTitle = getSegmentTitleFor(index)
            multiLegSegmentControl?.insertSegment(withTitle: segmentTitle, at: index-1, animated: false)
        }
        
        multiLegSegmentControl?.selectedSegmentIndex = currentActiveIndex
                
        if multiLegSegmentControl?.superview == nil && numberOfStops > 1 {
            let font: [NSAttributedString.Key : Any] = [.font : AppFonts.SemiBold.withSize(14)]
            multiLegSegmentControl?.setTitleTextAttributes(font, for: .normal)
            multiLegSegmentControl?.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
            if let segmentControl = multiLegSegmentControl {
                multicitySegmentView.addSubview(segmentControl)
            }
            multiLegSegmentControl?.snp.makeConstraints { (maker) in
                maker.width.equalToSuperview()
                maker.height.equalToSuperview()
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
            }
        }
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
                
        tableOffsetAtIndex[currentActiveIndex] = baseScrollview.contentOffset.y
        
        guard currentActiveIndex != sender.selectedSegmentIndex else { return }

        airportFilterArray[currentActiveIndex] = currentAirportFilter
        currentActiveIndex = sender.selectedSegmentIndex
        
        currentAirportFilter = airportFilterArray[currentActiveIndex]
        journeyTitle.attributedText = currentAirportFilter.leg.descriptionOneFiveThree
        originsTableView.reloadData()
        destinationsTableView.reloadData()
        layoverTableview.reloadData()
//        setmultiLegSubviews ()
        updateSegmentTitles()
        setupScrollView()
        updateNoLayoversLbl()
    }
    
    private func getSegmentTitleFor(_ index: Int) -> String {
        let currentFilter = airportFilterArray[(index - 1)]
        let isFilterApplied = currentFilter.filterApplied()
        var title = "\(currentFilter.leg.origin) \u{279E} \(currentFilter.leg.destination)"
        if airportFilterArray.count > 3 {
            title = "\(index)"
        }
        var segmentTitle = title
        if isFilterApplied {
            segmentTitle = "\(title) •"
        }
        return segmentTitle
    }
    
    private func updateSegmentTitles() {
        guard let segmentControl = multiLegSegmentControl else { return }
        for index in 0..<segmentControl.numberOfSegments {
            let segmentTitle = getSegmentTitleFor(index + 1)
            multiLegSegmentControl?.setTitle(segmentTitle, forSegmentAt: index)
        }
    }
    
    //MARK:- FilterViewController Methods
    func initialSetup() {
        guard originDestinationView != nil else { return }
        originDestinationView.isHidden = true
        sameDepartReturnView.isHidden = true
        noLayoversLbl.isHidden = true
        noLayoversLbl.text = LocalizedString.noLayovers.localized
        noLayoversLbl.textColor = AppColors.themeGray40
        noLayoversLbl.font = AppFonts.Regular.withSize(16)
        multiCitySegmentSeparator.alpha = 0
        setupTopView()
        
        if airportFilterArray.count > 1 {
//            setmultiLegSubviews()
            setupMultiLegSegmentControl()
        }
        setupScrollView()
        if multiLegSegmentControl == nil {
            multiLegSegmentControl = UISegmentedControl()
        }
    }
    
    func updateUIPostLatestResults() {
        
        if currentAirportFilter.allLayoverSelectedByUserInteraction {
            currentAirportFilter.layoverCities = currentAirportFilter.layoverCities.map { var newAirport = $0
                newAirport.selectAll(true)
                return newAirport
            }
        }
        setupTopView()
        journeyTitle.attributedText = currentAirportFilter.leg.descriptionOneFiveThree
        setupScrollView()
//        setmultiLegSubviews()
        setupMultiLegSegmentControl()
        updateNoLayoversLbl()
    }
    
    func resetFilter() {
        guard originsTableView != nil else { return }

        for i in 0 ..< airportFilterArray.count {
            
            var filter = airportFilterArray[i]
            
//            if isIntReturnOrMCJourney {
                currentAirportFilter = filter
//            }
           
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
        currentAirportFilter.allLayoverSelectedByUserInteraction = false
        allLayoverButton.isSelected = false
                
//        setmultiLegSubviews ()
        updateSegmentTitles()
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
        
//        setmultiLegSubviews ()
        updateSegmentTitles()
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
        currentAirportFilter.allLayoverSelectedByUserInteraction = combinedSelectionStatus
        allLayoverButton.isSelected = combinedSelectionStatus
        
        airportFilterArray[currentActiveIndex] = currentAirportFilter
//        setmultiLegSubviews ()
        updateSegmentTitles()
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
        
//        setmultiLegSubviews ()
        updateSegmentTitles()
        
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
        delegate?.sameSourceDestinationSelected(at: 0, selected: sender.isSelected)
    }
    
    
    @IBAction func sameDepartReturnTopBtnAction(_ sender: UIButton) {
        sameDepartReturnBtnAction(sameDepartReturnBtn)
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
//        setmultiLegSubviews()
        updateSegmentTitles()
        
        originsTableView.reloadData()
        destinationsTableView.reloadData()
        self.delegate?.allOriginDestinationAirportsSelectedAt(index: currentActiveIndex )
        
        
    }
    
    @IBAction func AllLayoversSelected(_ sender: UIButton ) {
        tableOffsetAtIndex[currentActiveIndex] = baseScrollview.contentOffset.y
        sender.isSelected.toggle()

        currentAirportFilter.allLayoverSelectedByUserInteraction = sender.isSelected
        currentAirportFilter.layoverCities = currentAirportFilter.layoverCities.map { var newAirport = $0
            newAirport.selectAll(sender.isSelected  )
            return newAirport
        }
        airportFilterArray[currentActiveIndex] = currentAirportFilter
//        setmultiLegSubviews ()
        updateSegmentTitles()
        layoverTableview.reloadData()
        if searchType == RETURN_JOURNEY {
            if isIntReturnOrMCJourney {
                self.delegate?.allLayoversSelectedInReturn(selected: sender.isSelected)
                return
            }
            
            self.delegate?.allLayoverSelectedAt(index: 0, selected: sender.isSelected)
            self.delegate?.allLayoverSelectedAt(index: 1, selected: sender.isSelected)
        }
        else {
            self.delegate?.allLayoverSelectedAt(index: currentActiveIndex, selected: sender.isSelected)
        }
        
    }
    
    @IBAction func allLayoversContainerBtnAction(_ sender: UIButton) {
        AllLayoversSelected(allLayoverButton)
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
//                cell.radioButton.addTarget(self, action: #selector(originAirportTapped(sender:)), for: .touchDown)
                cell.radioButton.tag = indexPath.section * 100 + indexPath.row
                cell.radioButton.isUserInteractionEnabled = false
                cell.backgroundColor = .clear
                return cell
            }
        } else if tableView == destinationsTableView {

            if let cell = destinationsTableView.dequeueReusableCell(withIdentifier: "DestinationCells") as? AirportSelectionCell {
                cell.selectionStyle = .none

                let airports = currentAirportFilter.destinationCities[indexPath.section].airports
                let currentAirport = airports[indexPath.row]
                cell.airportCode.text = currentAirport.IATACode
                cell.airportName?.text = currentAirport.name
                cell.radioButton.isSelected = currentAirport.isSelected
//                cell.radioButton.addTarget(self, action: #selector(destinationAirportTapped(sender:)), for:.touchDown)
                cell.radioButton.tag = indexPath.section * 100 + indexPath.row
                cell.radioButton.isUserInteractionEnabled = false
                cell.backgroundColor = .clear
                return cell
            }
        } else if tableView == layoverTableview {
            
            if let cell = layoverTableview.dequeueReusableCell(withIdentifier: "LayOverCells") as? AirportSelectionCell {
                cell.selectionStyle = .none
                
                let airports = currentAirportFilter.layoverCities[indexPath.section].airports
                let currentAirport = airports[indexPath.row]
                cell.airportCode.text = currentAirport.IATACode
                cell.airportName?.text = currentAirport.city
                if currentAirportFilter.allLayoverSelectedByUserInteraction {
                   cell.radioButton.isSelected  = true
                } else {
                    printDebug(currentAirport.isSelected)
                    cell.radioButton.isSelected = currentAirport.isSelected
                }
//                cell.radioButton.addTarget(self, action: #selector(layoverAirportTapped(sender:)), for: .touchDown)
                cell.radioButton.tag = indexPath.section * 100 + indexPath.row
                cell.radioButton.isUserInteractionEnabled = false
                cell.backgroundColor = .clear
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AirportSelectionCell else { return }
        
        if cell.reuseIdentifier == "OriginCells" {
            originAirportTapped(sender: cell.radioButton)
        } else if cell.reuseIdentifier == "DestinationCells" {
            destinationAirportTapped(sender: cell.radioButton)
        } else if cell.reuseIdentifier == "LayOverCells" {
            layoverAirportTapped(sender: cell.radioButton)
        }
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
//        title.font = UIFont(name: "sourceSansPro-Regular", size: 16)
        title.font = AppFonts.Regular.withSize(16)
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
        if currentAirportFilter.layoverAirportsCount == 0 {
            multiCitySegmentSeparator.alpha = 0
        } else {
            multiCitySegmentSeparator.alpha = contentOffset / 100.0
        }
    }
    
    private func updateNoLayoversLbl() {
        noLayoversLbl.isHidden = currentAirportFilter.layoverAirportsCount != 0
    }
    
}


