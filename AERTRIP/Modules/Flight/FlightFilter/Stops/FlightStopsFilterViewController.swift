//
//  FlightFilterStopsViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


protocol  FlightStopsFilterDelegate : FilterDelegate {
    func stopsSelectionChangedAt(_ index: Int, stops : [Int])
    func allStopsSelectedAt(_ index: Int)
}



struct StopsFilter{
    let availableStops : [Int]
    var userSelectedStops = [Int]()
    
    var leastStop : Int {
        if availableStops.count > 0 {
            return availableStops.min()!
        }
        else {
            assertionFailure("Invalid least stops state")
            return -1
        }
    }
    
    var numberofAvailableStops : Int {
        return availableStops.count
    }
    
    init( stops : [Int]) {
        availableStops = stops
    }
    
    
    mutating func resetFilter() {
        userSelectedStops.removeAll()
    }
    
    
    
}
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
    
    //MARK:- State Properties
    weak var delegate : FlightStopsFilterDelegate?
    var currentActiveIndex = 0
    var allStopsFilters = [StopsFilter]()
    var currentStopFilter : StopsFilter!
    var allLegNames  = [Leg]()
    var stopsButtonsArray = [UIButton]()
    var showingForReturnJourney = false
    
    //MARK:- View Controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentStopFilter = allStopsFilters[0]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnLeastStopsView))
        leastStopTapGestureView.isUserInteractionEnabled = true
        leastStopTapGestureView.addGestureRecognizer(tapGestureRecognizer)
        setupStopsBaseView()
        
        if allStopsFilters.count == 1 {
            multiLegViewHeight.constant = 0
            multiLegJourney.isHidden = true
            stopsBaseViewTopConstant.constant = 17
        }
        else {
            setLeastStopsTitle()
            setmultiLegSubviews()
            stopsBaseViewTopConstant.constant = 107
        }
        
    }
    
    
    func initialSetup() {
        
    }
    
    func updateUIPostLatestResults() {
        setupStopsBaseView()
        
        if allStopsFilters.count == 1 {
            multiLegViewHeight.constant = 0
            multiLegJourney.isHidden = true
            stopsBaseViewTopConstant.constant = 17
        } else {
            multiLegViewHeight.constant = 107
            multiLegJourney.isHidden = false
            stopsBaseViewTopConstant.constant = 107
            setLeastStopsTitle()
            setmultiLegSubviews()
        }
    }
    
    func resetFilter() {
        selectAllStops()
        currentStopFilter.userSelectedStops.removeAll()
        leastStopsButton.isSelected = false
        for i in 0 ..< allStopsFilters.count {
            var filter = allStopsFilters[i]
            filter.resetFilter()
            allStopsFilters[i] = filter
        }
        setmultiLegSubviews()

    }
    
    //MARK:- Additional UI Methods
    fileprivate func setupStopsBaseView () {
        
        stopsBaseView.layer.borderWidth = 1.0
        stopsBaseView.layer.borderColor = UIColor.TWO_THREE_ZERO_COLOR.cgColor
        stopsBaseView.layer.cornerRadius = 10.0
        stopsBaseView.clipsToBounds = true
        setStopsSubviews()
    }
    
    fileprivate func setStopsSubviews () {
        
        stopsBaseView.subviews.forEach { $0.removeFromSuperview() }
        stopsButtonsArray.removeAll()
        
        let baseStopCount = currentStopFilter.leastStop
        var stopCount = baseStopCount
        let numberOfAvailableStops = min(currentStopFilter.numberofAvailableStops , 4)
        for  i in 1...numberOfAvailableStops  {
            let segmentViewWidth = UIScreen.main.bounds.size.width - 32
            
            let width = segmentViewWidth  / CGFloat(numberOfAvailableStops)
            let xcordinate = CGFloat( i - 1 ) * width
            let height = self.stopsBaseView.frame.size.height
            var rect = CGRect(x: xcordinate, y: 0, width: width, height: height)
            let stopButton = UIButton(frame: rect)
            stopButton.backgroundColor = UIColor.SELECTION_COLOR.withAlphaComponent(0.25)
            
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
            title.font = UIFont(name: "SourceSansPro-Semibold", size: 20)
            title.tag = 1
            
            
            title.textAlignment = .center
            title.textColor = UIColor.FIVE_ONE_COLOR
            stopButton.addSubview(title)
            
            rect = CGRect(x: 0, y: 37, width: width, height: 20)
            let subTitle = UILabel ( frame: rect)
            subTitle.font = UIFont(name: "SourceSansPro-Regular", size: 16)
            subTitle.text  = "stop"
            subTitle.tag = 2
            subTitle.textAlignment = .center
            subTitle.textColor = UIColor.FIVE_ONE_COLOR
            stopButton.addSubview(subTitle)
            
            stopButton.isSelected = false
            
            
            if currentStopFilter.userSelectedStops.contains(stopCount) {
                selectionStateUIFor(stopButton)
                stopButton.isSelected = true
            }
            else {
                if currentStopFilter.userSelectedStops.count != 0 {
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
        
        let leastStop = allStopsFilters.reduce( 0 , { $0 + $1.leastStop })
        if leastStop == 0 {
            
            LeastStopsTitle.text = "Non-stop only"
            LeastStopsTitleWidth.constant = LeastStopsTitle.intrinsicContentSize.width
        }
        else {
            LeastStopsTitle.text = "Least stops only"
            LeastStopsTitleWidth.constant = LeastStopsTitle.intrinsicContentSize.width

        }
        
    }
    
    fileprivate func setmultiLegSubviews () {
        
        multicitySegmentView.subviews.forEach { $0.removeFromSuperview() }
        
        multicitySegmentView.layer.cornerRadius = 3
        multicitySegmentView.layer.borderColor = UIColor.AertripColor.cgColor
        multicitySegmentView.layer.borderWidth = 1.0
        multicitySegmentView.clipsToBounds = true
        
        let numberOfLegs = allStopsFilters.count
        
        for  i in 1...numberOfLegs  {
            let segmentViewWidth = UIScreen.main.bounds.size.width - 32
            
            let width = segmentViewWidth / CGFloat(numberOfLegs)
            let xcordinate = CGFloat( i - 1 ) * width
            let height = self.multicitySegmentView.frame.size.height
            var rect = CGRect(x: xcordinate, y: 0, width: width, height: height)
            let stopButton = UIButton(frame: rect)
            stopButton.isSelected = false
            stopButton.tag = i - 1
            
            let currentFilter = allStopsFilters[(i - 1)]
            let isCurrentIndexActive = (i == (currentActiveIndex + 1 )) ? true : false
            
            let isFilterApplied = currentFilter.userSelectedStops.count > 0
            
            if isCurrentIndexActive {
                stopButton.backgroundColor = UIColor.AertripColor
            }
            
            var normalStateTitle : NSMutableAttributedString
            if  numberOfLegs > 3 {
                
                
                let dot = "\u{2022}"
                let font = UIFont(name: "SourceSansPro-Semibold", size: 14.0)!
                let aertripColorAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : UIColor.AertripColor]
                let whiteColorAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : UIColor.white]
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
                let leg = allLegNames[(i - 1)]
                normalStateTitle = leg.getTitle(isCurrentlySelected: isCurrentIndexActive, isFilterApplied: isFilterApplied)
            }
            
            stopButton.setAttributedTitle(normalStateTitle, for: .normal)
            
            stopButton.addTarget(self, action: #selector(tappedOnMulticityButton(sender:)), for: .touchDown)
            stopButton.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 16)
            
            multicitySegmentView.addSubview(stopButton)
            
            if i != numberOfLegs {
                rect  = CGRect(x: xcordinate + width - 1 , y: 0, width: 1, height: 30)
                let verticalSeparator = UIView(frame: rect)
                verticalSeparator.backgroundColor = UIColor.AertripColor
                multicitySegmentView.addSubview(verticalSeparator)
            }
        }
    }
    
    
    
    fileprivate func selectAllStops() {
        stopsBaseView.subviews.forEach{ view in
            if let button = view as? UIButton {
                
                button.backgroundColor = UIColor.SELECTION_COLOR.withAlphaComponent(0.40)
                
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
        for index in 0 ..< allStopsFilters.count {
            
            var filter = allStopsFilters[index]
            let leastStop = filter.leastStop
            filter.userSelectedStops.removeAll()
            filter.userSelectedStops = [leastStop]
            allStopsFilters[index] = filter
            
            if index == currentActiveIndex {
                
                currentStopFilter = filter
                setStopsSubviews()
                if let button = stopsBaseView.viewWithTag(1000) as? UIButton {
                    button.isSelected = false
                    tappedOnStopButton(sender: button)
                }
            }
            delegate?.stopsSelectionChangedAt(index, stops: [allStopsFilters[index].leastStop])
        }
        setmultiLegSubviews()
        leastStopsButton.isSelected = leastBtnState
    }
    
    fileprivate func deselectionStateUIFor(_ sender: UIButton) {
        sender.backgroundColor = UIColor.white
        if let title = sender.viewWithTag(1) as? UILabel {
            title.textColor = UIColor.black
        }
        
        if let subTitle = sender.viewWithTag(2) as? UILabel {
            subTitle.textColor = UIColor.black
            subTitle.font = UIFont(name: "SourceSansPro-Regular", size: 16)
        }
    }
    
    
    
    fileprivate func selectionStateUIFor(_ sender: UIButton) {
        sender.backgroundColor = UIColor.SELECTION_COLOR
        if let title = sender.viewWithTag(1) as? UILabel {
            title.textColor = UIColor.AertripColor
        }
        
        if let subTitle = sender.viewWithTag(2) as? UILabel {
            subTitle.textColor = UIColor.AertripColor
            subTitle.font = UIFont(name: "SourceSansPro-Semibold", size: 16)
        }
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func leastStopsButtonTapped(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
            selectLeastStopsForAllLegs()
        }
    }
    
    @objc func tapOnLeastStopsView( sender: UITapGestureRecognizer) {
        
        if leastStopsButton.isSelected {
            leastStopsButton.isSelected = false
        } else {
            selectLeastStopsForAllLegs()
            leastStopsButton.isSelected = true
        }
    }
    
    @objc fileprivate func tappedOnStopButton( sender : UIButton) {
        
        let isSelected = sender.isSelected
        
        if currentStopFilter.numberofAvailableStops == 1 { return }
        var currentLegStopsSelection = currentStopFilter.userSelectedStops
        
        let tag = sender.tag - 1000
        
        for button in stopsButtonsArray {
            let buttonTag = button.tag - 1000
            if  !currentLegStopsSelection.contains(buttonTag) {
                button.backgroundColor = UIColor.white
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
                
                currentStopFilter.userSelectedStops = currentLegStopsSelection
                allStopsFilters[currentActiveIndex] = currentStopFilter
            }
            
        }else {
            selectionStateUIFor(sender)
            
            sender.isSelected = true
            
            if !currentLegStopsSelection.contains(tag) {
                
                if tag == 3 {
                    let allQualifyingStops = currentStopFilter.availableStops.filter { $0 >= tag }
                    currentLegStopsSelection.append(contentsOf: allQualifyingStops)

                }
                else {
                    currentLegStopsSelection.append(tag)
                }
                
                currentStopFilter.userSelectedStops = currentLegStopsSelection
                allStopsFilters[currentActiveIndex] = currentStopFilter
            }
        }
        
        if currentStopFilter.userSelectedStops.count > 1 {
//            leastStopsButton.isSelected = false
        }
        
        if currentStopFilter.userSelectedStops.count == 1 {
            for filter in allStopsFilters {
                
                if filter.userSelectedStops.count == 1 && filter.userSelectedStops.contains(filter.leastStop){
//                    leastStopsButton.isSelected = true
                    continue
                }else {
//                    leastStopsButton.isSelected = false
                    break
                }
            }
        }
        
        
//        if currentLegStopsSelection.count == 0  || currentLegStopsSelection.count == currentStopFilter.numberofAvailableStops{
//            currentStopFilter.userSelectedStops.removeAll()
//            selectAllStops()
//            leastStopsButton.isSelected = false
//            if showingForReturnJourney {
//                delegate?.allStopsSelectedAt(0)
//                delegate?.allStopsSelectedAt(1)
//            } else {
//                delegate?.allStopsSelectedAt(currentActiveIndex)
//            }
//        } else {
            
            if showingForReturnJourney {
                delegate?.stopsSelectionChangedAt(0, stops: currentLegStopsSelection)
                delegate?.stopsSelectionChangedAt(1, stops: currentLegStopsSelection)
            }else {
                delegate?.stopsSelectionChangedAt(currentActiveIndex, stops: currentLegStopsSelection)
            }
       // }
        allStopsFilters[currentActiveIndex] = currentStopFilter
        setmultiLegSubviews()
        
    

    }
    
    @objc fileprivate func tappedOnMulticityButton( sender : UIButton) {
                
        let tag = sender.tag
        if tag == currentActiveIndex {
            return
        }
        else {
            allStopsFilters[currentActiveIndex] = currentStopFilter
            currentActiveIndex = tag
        }
        
        currentStopFilter = allStopsFilters[currentActiveIndex]
        setStopsSubviews()
        setmultiLegSubviews()
        
    }
    
}
