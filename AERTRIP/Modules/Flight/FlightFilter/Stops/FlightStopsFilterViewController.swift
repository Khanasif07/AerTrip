//
//  FlightFilterStopsViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class FlightStopsFilterViewController: UIViewController, FilterViewController  {
    
    //MARK:- Outlets
    @IBOutlet weak var stopsBaseView: UIView!
    @IBOutlet weak var multiLegJourney: UIView!
    @IBOutlet weak var multicitySegmentView: UIView!
    @IBOutlet weak var multiLegViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stopsBaseViewTopConstant: NSLayoutConstraint!
    @IBOutlet weak var leastStopsButton: UIButton!
    @IBOutlet weak var leastStopTapGestureView: UIView!
    @IBOutlet weak var LeastStopsTitle: UILabel!
    @IBOutlet weak var LeastStopsTitleWidth: NSLayoutConstraint!
    
    @IBOutlet weak var avoidChangeOfAirportsView: UIView!
    @IBOutlet weak var avoidChangeOfAirportsTitleLbl: UILabel!
    @IBOutlet weak var allSectorsLbl: UILabel!
    @IBOutlet weak var avoidChangeOfAirportsDescLbl: UILabel!
    @IBOutlet weak var avoidChangeOfAirportsImgView: UIImageView!
    @IBOutlet weak var avoidChangeOfAirportsBtn: UIButton!
    
    @IBOutlet weak var sectorNameLbl: UILabel!
    
    //MARK:- State Properties
    
    let viewModel = FlightStopsFilterVM()
    var stopsButtonsArray = [UIButton]()
    private var multiLegSegmentControl = GreenDotSegmentControl()
    
    //MARK:- View Controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        
        allSectorsLbl.isHidden = !viewModel.isIntMCOrReturnVC
        sectorNameLbl.isHidden = true
        
        if viewModel.allStopsFilters.count > 0 {
            viewModel.currentStopFilter = viewModel.allStopsFilters[0]
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnLeastStopsView))
        leastStopTapGestureView.isUserInteractionEnabled = true
        leastStopTapGestureView.addGestureRecognizer(tapGestureRecognizer)
        setupStopsBaseView()
        
        if viewModel.allStopsFilters.count == 1 {
            multiLegViewHeight.constant = 0
            multiLegJourney.isHidden = true
            stopsBaseViewTopConstant.constant = 17
        }
        else {
            setLeastStopsTitle()
            setupMultiLegSegmentControl()
            if viewModel.allStopsFilters.count > 3 {
                stopsBaseViewTopConstant.constant = 130
                sectorNameLbl.isHidden = false
                sectorNameLbl.attributedText = viewModel.allLegNames[viewModel.currentActiveIndex].descriptionTextForSectorHeader
            } else {
                stopsBaseViewTopConstant.constant = 107
            }
        }
        setupOvernightFlightsView()
    }
    
    
    func initialSetup() {
        setColors()
    }
    
    func setColors(){
        self.view.backgroundColor = AppColors.themeWhiteDashboard
        
    }
    
    
    private func setupOvernightFlightsView() {
        avoidChangeOfAirportsTitleLbl.font = AppFonts.Regular.withSize(18)
        avoidChangeOfAirportsDescLbl.font = AppFonts.Regular.withSize(14)
        avoidChangeOfAirportsDescLbl.textColor = AppColors.themeGray60
        allSectorsLbl.font = AppFonts.Regular.withSize(14)
        allSectorsLbl.textColor = AppColors.themeGray40
    }
    

    
    func updateUIPostLatestResults() {
        viewModel.currentStopFilter = viewModel.allStopsFilters[viewModel.currentActiveIndex]
        setupStopsBaseView()
        sectorNameLbl.isHidden = true
        if viewModel.allStopsFilters.count == 1 {
            multiLegViewHeight.constant = 0
            multiLegJourney.isHidden = true
            stopsBaseViewTopConstant.constant = 17
        } else {
            multiLegViewHeight.constant = 107
            multiLegJourney.isHidden = false
            if viewModel.allStopsFilters.count > 3 {
                stopsBaseViewTopConstant.constant = 130
                sectorNameLbl.isHidden = false
                sectorNameLbl.attributedText = viewModel.allLegNames[viewModel.currentActiveIndex].descriptionTextForSectorHeader
            } else {
                stopsBaseViewTopConstant.constant = 107
            }
            setLeastStopsTitle()
            setupMultiLegSegmentControl()
        }
        hideShowOvernightView()
        resetAvoidChangeOfAirportsBtn()
        checkIfLeastStopsSelected()
    }
    
    private func checkIfLeastStopsSelected() {
        var isSelected = true
        for filter in viewModel.allStopsFilters {
            if filter.userSelectedStops.count == 1 {
                if !filter.userSelectedStops.contains(filter.availableStops.sorted().first ?? 0) {
                    isSelected = false
                    break
                }
            } else {
                isSelected = false
                break
            }
        }
        leastStopsButton.isSelected = isSelected
    }
    
    func resetFilter() {
        selectAllStops()
        viewModel.resetFilter()
        leastStopsButton.isSelected = false
        updateSegmentTitles()
    }
    
    //MARK:- Additional UI Methods
    fileprivate func setupStopsBaseView () {
        
        stopsBaseView.layer.borderWidth = 1.0
        stopsBaseView.layer.borderColor = AppColors.themeGray10.cgColor
        stopsBaseView.layer.cornerRadius = 10.0
        stopsBaseView.clipsToBounds = true
        if viewModel.currentStopFilter != nil{
            setStopsSubviews()
        }
    }
    
    fileprivate func setStopsSubviews () {
        
        stopsBaseView.subviews.forEach { $0.removeFromSuperview() }
        stopsButtonsArray.removeAll()
        
        let baseStopCount = viewModel.currentStopFilter?.leastStop ?? 0
        var stopCount = baseStopCount
        let numberOfAvailableStops = min(viewModel.currentStopFilter?.numberofAvailableStops ?? 0 , 4)
        for  i in 1...numberOfAvailableStops  {
            let segmentViewWidth = UIScreen.main.bounds.size.width - 32
            
            let width = segmentViewWidth  / CGFloat(numberOfAvailableStops)
            let xcordinate = CGFloat( i - 1 ) * width
            let height = self.stopsBaseView.frame.size.height
            var rect = CGRect(x: xcordinate, y: 0, width: width, height: height)
            let stopButton = UIButton(frame: rect)
            stopButton.backgroundColor = AppColors.flightFilterSessionSelectedColor
            
            stopButton.addTarget(self, action: #selector(tappedOnStopButton(sender:)), for: .touchDown)
            stopsBaseView.addSubview(stopButton)
            stopsButtonsArray.append(stopButton)
            
            if i != numberOfAvailableStops {
                rect  = CGRect(x: xcordinate + width - 1 , y: 0, width: 1, height: 69)
                let verticalSeparator = UIView(frame: rect)
                verticalSeparator.backgroundColor = UIColor.TWO_THREE_ZERO_COLOR
                stopsBaseView.addSubview(verticalSeparator)
            }
            
            rect = CGRect(x: 0, y: 12, width: width, height: 25)
            let title = UILabel ( frame: rect)
//            title.font = UIFont(name: "SourceSansPro-Semibold", size: 20)
            title.font = AppFonts.SemiBold.withSize(20)
            title.tag = 1
            
            title.textAlignment = .center
            title.textColor = UIColor.FIVE_ONE_COLOR
            stopButton.addSubview(title)
            
            rect = CGRect(x: 0, y: 37, width: width, height: 20)
            let subTitle = UILabel ( frame: rect)
//            subTitle.font = UIFont(name: "SourceSansPro-Regular", size: 16)
            subTitle.font = AppFonts.Regular.withSize(16)
            subTitle.text  = "stop"
            subTitle.tag = 2
            subTitle.textAlignment = .center
            subTitle.textColor = UIColor.FIVE_ONE_COLOR
            stopButton.addSubview(subTitle)
            
            stopButton.isSelected = false
            
            if viewModel.currentStopFilter?.userSelectedStops.contains(stopCount) ?? false {
                selectionStateUIFor(stopButton)
                stopButton.isSelected = true
            }
            else {
                if viewModel.currentStopFilter?.userSelectedStops.count != 0 {
                    deselectionStateUIFor(stopButton)
                }
            }
            
            switch (stopCount - baseStopCount) {
            case 0 :
                title.text = "\(stopCount)"
                stopButton.tag = 1000 + stopCount
            case 1 :
                title.text = "\(stopCount)"
                stopButton.tag = 1000 + stopCount
            case 2 :
                title.text = "\(stopCount)"
                stopButton.tag = 1000 + stopCount
            case 3 :
                title.text = "\(stopCount - 1)" + "+"
                stopButton.tag = 1000 + stopCount
            default:
                title.text = "more"
            }
            
            if stopCount < 2   {
                subTitle.text = "stop"
            }
            else {
                subTitle.text = "stops"
            }
            
            stopCount = stopCount + 1
        }
    }
    
    
    fileprivate func setLeastStopsTitle() {
        
        let leastStop = viewModel.allStopsFilters.reduce( 0 , { $0 + $1.leastStop })
        if leastStop == 0 {
            LeastStopsTitle.text = "Non-stop only"
            LeastStopsTitleWidth.constant = LeastStopsTitle.intrinsicContentSize.width
        }
        else {
            LeastStopsTitle.text = "Least stops only"
            LeastStopsTitleWidth.constant = LeastStopsTitle.intrinsicContentSize.width
        }
    }
    
    private func setupMultiLegSegmentControl() {
                
        multiLegSegmentControl.removeAllSegments()
        
        let numberOfStops = viewModel.allStopsFilters.count

        for  index in 1...numberOfStops  {
            let segmentTitle = getSegmentTitleFor(index)
            multiLegSegmentControl.insertSegment(withTitle: segmentTitle, at: index-1, animated: false)
        }
        
        multiLegSegmentControl.selectedSegmentIndex = viewModel.currentActiveIndex
                
        if multiLegSegmentControl.superview == nil && numberOfStops > 1 {
            multiLegSegmentControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
            multicitySegmentView.addSubview(multiLegSegmentControl)
            multiLegSegmentControl.snp.makeConstraints { (maker) in
                maker.width.equalToSuperview()
                maker.height.equalToSuperview()
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
            }
        }
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        
        guard viewModel.currentActiveIndex != sender.selectedSegmentIndex, let curFilter = viewModel.currentStopFilter else { return }
        
        viewModel.allStopsFilters[viewModel.currentActiveIndex] = curFilter
        viewModel.currentActiveIndex = sender.selectedSegmentIndex
        viewModel.currentStopFilter = viewModel.allStopsFilters[viewModel.currentActiveIndex]
        setStopsSubviews()
        updateSegmentTitles()
        hideShowOvernightView()
        resetAvoidChangeOfAirportsBtn()
        sectorNameLbl.attributedText = viewModel.allLegNames[viewModel.currentActiveIndex].descriptionTextForSectorHeader
    }
    
    private func getSegmentTitleFor(_ index: Int) -> String {
        let currentFilter = viewModel.allStopsFilters[(index - 1)]
        let isFilterApplied = currentFilter.userSelectedStops.count > 0
        var title = "\(viewModel.allLegNames[index - 1].origin) \u{279E} \(viewModel.allLegNames[index - 1].destination)"
        if viewModel.allStopsFilters.count > 3 {
            title = "\(index)"
        }
        var segmentTitle = "\(title) "
        if isFilterApplied {
            segmentTitle = "\(title) •"
        }
        return segmentTitle
    }
    
    private func updateSegmentTitles() {
        for index in 0..<multiLegSegmentControl.numberOfSegments {
            let segmentTitle = getSegmentTitleFor(index + 1)
//            let attImage = getImgFromAttString(segmentTitle: segmentTitle)
//            multiLegSegmentControl.setImage(attImage, forSegmentAt: index)
            multiLegSegmentControl.setTitle(segmentTitle, forSegmentAt: index)
        }
    }
    
    fileprivate func selectAllStops() {
        stopsBaseView.subviews.forEach{ view in
            if let button = view as? UIButton {
                
                button.backgroundColor = AppColors.flightFilterSessionSelectedColor
                
                if let title = button.viewWithTag(1) as? UILabel {
                    title.textColor =  UIColor.FIVE_ONE_COLOR
                }
                
                if let subTitle = button.viewWithTag(2) as? UILabel {
                    subTitle.textColor =  UIColor.FIVE_ONE_COLOR
                    subTitle.font = UIFont(name: "SourceSansPro-Regular", size: 16)
                }
                button.isSelected = false
            }
        }
    }
    
    
    fileprivate func selectLeastStopsForAllLegs() {
        let leastBtnState = leastStopsButton.isSelected
        for index in 0 ..< viewModel.allStopsFilters.count {
            
            var filter = viewModel.allStopsFilters[index]
            let leastStop = filter.leastStop
            filter.userSelectedStops.removeAll()
            if filter.availableStops.count <= 1 {
                filter.userSelectedStops = []
            } else {
                filter.userSelectedStops = [leastStop]
            }
            viewModel.allStopsFilters[index] = filter
            
            if index == viewModel.currentActiveIndex {
                
                viewModel.currentStopFilter = filter
                setStopsSubviews()
                if let button = stopsBaseView.viewWithTag(1000) as? UIButton {
                    button.isSelected = false
                    tappedOnStopButton(sender: button)
                }
            }
            viewModel.delegate?.stopsSelectionChangedAt(index, stops: [viewModel.allStopsFilters[index].leastStop])
        }
        updateSegmentTitles()
        leastStopsButton.isSelected = leastBtnState
    }
    
    fileprivate func deselectionStateUIFor(_ sender: UIButton) {
        sender.backgroundColor = AppColors.themeWhiteDashboard
        if let title = sender.viewWithTag(1) as? UILabel {
            title.textColor = UIColor.black
        }
        
        if let subTitle = sender.viewWithTag(2) as? UILabel {
            subTitle.textColor = UIColor.black
//            subTitle.font = UIFont(name: "SourceSansPro-Regular", size: 16)
            subTitle.font = AppFonts.Regular.withSize(16)
        }
        
        // Added check for buttons not turning light green if all deselected
        var allDeselected = true
        for btn in stopsButtonsArray {
            if let title = btn.viewWithTag(1) as? UILabel, title.textColor == UIColor.AertripColor {
                allDeselected = false
                break
            }
        }
        if allDeselected {
            stopsButtonsArray.forEach { (btn) in
                btn.backgroundColor = AppColors.flightFilterSessionSelectedColor
            }
        }
    }
    
    fileprivate func selectionStateUIFor(_ sender: UIButton) {
        sender.backgroundColor = AppColors.flightFilterSessionSelectedColor
        if let title = sender.viewWithTag(1) as? UILabel {
            title.textColor = UIColor.AertripColor
        }
        
        if let subTitle = sender.viewWithTag(2) as? UILabel {
            subTitle.textColor = UIColor.AertripColor
//            subTitle.font = UIFont(name: "SourceSansPro-Semibold", size: 16)
            subTitle.font = AppFonts.SemiBold.withSize(16)
        }
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func leastStopsButtonTapped(_ sender: UIButton) {
        
        if sender.isSelected {
            return
        } else {
            sender.isSelected = true
            selectLeastStopsForAllLegs()
        }
    }
    
    @objc func tapOnLeastStopsView( sender: UITapGestureRecognizer) {
        
        if leastStopsButton.isSelected {
            return
        } else {
            selectLeastStopsForAllLegs()
            leastStopsButton.isSelected = true
        }
    }
    
    @objc fileprivate func tappedOnStopButton( sender : UIButton) {
        
        let isSelected = sender.isSelected
        
        if viewModel.currentStopFilter?.numberofAvailableStops == 1 { return }
        var currentLegStopsSelection = viewModel.currentStopFilter?.userSelectedStops ?? []
        
        let tag = sender.tag - 1000
        
        for button in stopsButtonsArray {
            let buttonTag = button.tag - 1000
            if  !currentLegStopsSelection.contains(buttonTag) {
                button.backgroundColor = AppColors.themeWhiteDashboard
            }
        }
        
        if isSelected {
            deselectionStateUIFor(sender)
            sender.isSelected = false
            
            if let index = currentLegStopsSelection.firstIndex(of: tag) {
                
                if index == 3 {
                    
                    currentLegStopsSelection.removeAll(where: { $0 >= tag })
                } else {
                    currentLegStopsSelection.remove(at: index)
                }
                
                viewModel.currentStopFilter?.userSelectedStops = currentLegStopsSelection
                if let curFilter = viewModel.currentStopFilter {
                    viewModel.allStopsFilters[viewModel.currentActiveIndex] = curFilter
                }
            }
            
        }else {
            selectionStateUIFor(sender)
            
            sender.isSelected = true
            
            if !currentLegStopsSelection.contains(tag) {
                
                if tag == 3 {
                    let allQualifyingStops = viewModel.currentStopFilter?.availableStops.filter { $0 >= tag } ?? []
                    currentLegStopsSelection.append(contentsOf: allQualifyingStops)

                }
                else {
                    currentLegStopsSelection.append(tag)
                }
                
                viewModel.currentStopFilter?.userSelectedStops = currentLegStopsSelection
                if let curFilter = viewModel.currentStopFilter {
                    viewModel.allStopsFilters[viewModel.currentActiveIndex] = curFilter
                }
            }
        }
        
        if viewModel.currentStopFilter?.userSelectedStops.count ?? 0 > 1 || (viewModel.currentStopFilter?.userSelectedStops.isEmpty ?? false) {
            leastStopsButton.isSelected = false
            
        }else if viewModel.currentStopFilter?.userSelectedStops.count == 1 {
            for filter in viewModel.allStopsFilters {
                
                if filter.userSelectedStops.count == 1 && filter.userSelectedStops.contains(filter.leastStop){
                    leastStopsButton.isSelected = true
                    continue
                }else {
                    leastStopsButton.isSelected = false
                    break
                }
            }
        }
        
        
//        if currentLegStopsSelection.count == 0  || currentLegStopsSelection.count == viewModel.currentStopFilter.numberofAvailableStops{
//            viewModel.currentStopFilter.userSelectedStops.removeAll()
//            selectAllStops()
//            leastStopsButton.isSelected = false
//            if showingForReturnJourney {
//                viewModel.delegate?.allStopsSelectedAt(0)
//                viewModel.delegate?.allStopsSelectedAt(1)
//            } else {
//                viewModel.delegate?.allStopsSelectedAt(viewModel.currentActiveIndex)
//            }
//        } else {
            
        if viewModel.showingForReturnJourney {
                viewModel.delegate?.stopsSelectionChangedAt(0, stops: currentLegStopsSelection)
                viewModel.delegate?.stopsSelectionChangedAt(1, stops: currentLegStopsSelection)
            }else {
//                viewModel.delegate?.stopsSelectionChangedAt(viewModel.currentActiveIndex, stops: currentLegStopsSelection)
                
                viewModel.allStopsFilters.enumerated().forEach { (index, filter) in
                    if filter.userSelectedStops.count == 0{
                        viewModel.delegate?.allStopsSelectedAt(index)
                    }else{
                        viewModel.delegate?.stopsSelectionChangedAt(index, stops: filter.userSelectedStops)
                    }
                }
            }
        if let curFilter = viewModel.currentStopFilter {
            viewModel.allStopsFilters[viewModel.currentActiveIndex] = curFilter
        }
        updateSegmentTitles()
    }
    
    @IBAction func avoidChangeOfAirportsBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        toggleAvoidChangeOfAirports(sender.isSelected)
        updateSegmentTitles()
    }
    
    private func toggleAvoidChangeOfAirports(_ selected: Bool) {
        viewModel.toggleAvoidChangeOfAirports(selected)
        resetAvoidChangeOfAirportsBtn()
        
    }
    
    private func resetAvoidChangeOfAirportsBtn() {
        avoidChangeOfAirportsBtn.isSelected = viewModel.currentStopFilter?.qualityFilter.isSelected ?? false
        if viewModel.currentStopFilter?.qualityFilter.isSelected ?? false {
            avoidChangeOfAirportsImgView.image = AppImages.CheckedGreenRadioButton
        }
        else {
            avoidChangeOfAirportsImgView.image = AppImages.UncheckedGreenRadioButton
        }
    }
    
    private func hideShowOvernightView() {
        if viewModel.isIntMCOrReturnVC {
            if viewModel.enableOvernightFlightQualityFilter.indices.contains(0) {
                avoidChangeOfAirportsView.isHidden = !viewModel.enableOvernightFlightQualityFilter[0]
            }
        } else {
            if viewModel.enableOvernightFlightQualityFilter.indices.contains(viewModel.currentActiveIndex) {
                avoidChangeOfAirportsView.isHidden = !viewModel.enableOvernightFlightQualityFilter[viewModel.currentActiveIndex]
            }
        }
    }
}
