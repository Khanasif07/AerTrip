//
//  FlightFilterTimesViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit
protocol FlightTimeFilterDelegate : FilterDelegate {
    
    func departureSelectionChangedAt(_ index : Int , minDuration : TimeInterval , maxDuration : TimeInterval)
    func arrivalSelectionChangedAt(_ index : Int , minDate : Date , maxDate : Date)
}


extension TimeInterval  {
    static let startOfDay = TimeInterval(0)
    static let sixAM = TimeInterval(6 * 60 * 60)
    static let twelvePM = TimeInterval(12 * 60 * 60)
    static let sixPM = TimeInterval(18 * 60 * 60)
    static let endOfDay = TimeInterval(24 * 60 * 60)
}

class FlightFilterTimesViewController : UIViewController , FilterViewController {

    weak var  delegate : FlightTimeFilterDelegate?
    
    //MARK:- State Properties
    var departureStartTimeInterval : TimeInterval = TimeInterval.startOfDay
    var departureEndTimeInterval : TimeInterval = TimeInterval.endOfDay
    var arrivalInputStartDate : Date!
    var arrivalInputEndDate : Date!
    var multiLegTimerFilter = [FlightLegTimeFilter]()
    
    var currentTimerFilter : FlightLegTimeFilter!
    var currentActiveIndex = 0
    var numberOfLegs = 1
//    var dragStartPosition : CGFloat =  0.0
//    var dragEndPosition : CGFloat = 0.0
    
    var airportsArr = [AirportLegFilter]()
    var isIntMCOrReturnVC = false

    var arivalDifferenceInSeconds : TimeInterval = 0
    
    /// Used for day segments pan gesture
    var panStartPos: CGFloat?
    
    //MARK:- multiLeg Outlets
    @IBOutlet weak var multiLegViewHeight: NSLayoutConstraint!
    @IBOutlet weak var multiLegView: UIView!
    @IBOutlet weak var multiSegmentView: UIView!
    
    //MARK:- Departure Outlets
    @IBOutlet weak var departureStackView: UIStackView!
    @IBOutlet weak var departureButtonStackView: UIStackView!
    @IBOutlet weak var departureStartTime: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var departureEndTime: UILabel!
    @IBOutlet weak var departureRangeSlider:  AertripRangeSlider!

    @IBOutlet weak var earlyMorningContainerView: UIView!
    @IBOutlet weak var earlyMorningButton: UIButton!
    @IBOutlet weak var noonContainerView: UIView!
    @IBOutlet weak var noonButton: UIButton!
    @IBOutlet weak var eveningContainerView: UIView!
    @IBOutlet weak var eveningButton: UIButton!
    @IBOutlet weak var lateEveningContainerView: UIView!
    @IBOutlet weak var lateEveningButton: UIButton!
    
    //MARK:- Arrival Outlets
    @IBOutlet weak var arrivalRangeSlider: AertripRangeSlider!
    @IBOutlet weak var arrivalStartTime: UILabel!
    @IBOutlet weak var arrivalEndTime: UILabel!
    @IBOutlet weak var arrivalStartTimeWidth: NSLayoutConstraint!
    @IBOutlet weak var arrivalEndTimeWidth: NSLayoutConstraint!
   
    //MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    /// Updates UI if data is coming and filters
    func updateFiltersFromAPI() {
        currentTimerFilter = multiLegTimerFilter[currentActiveIndex]
        UIView.animate(withDuration: 0.3) {
            self.setDepartureSliderValues()
            self.setArrivalSliderValues(userSelected: false)
            self.setArrivalSliderValues(userSelected: true)
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- Departure feature methods
    fileprivate func setDepartureLabelAttributedString() {
        let attributes =   [NSAttributedString.Key.font :UIFont(name: "SourceSansPro-Semibold", size: 14.0)! , NSAttributedString.Key.foregroundColor : UIColor.ONE_FIVE_THREE_COLOR]
        let departureTime  = NSMutableAttributedString(string: "Departure Time " , attributes: attributes)
        
        if multiLegTimerFilter.count > 1 {
            departureTime.append(currentTimerFilter.leg.descriptionOneFiveThree)
        }
        departureTimeLabel.attributedText = departureTime
    }
    
    fileprivate func setDepartureLabel(){
        let numberOfStops = multiLegTimerFilter.count
        if numberOfStops > 3 {
            setDepartureLabelAttributedString()
        } else {
            departureTimeLabel.text = "Departure Time"
        }
    }
    
    fileprivate func setDepartureSliderValues() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: currentTimerFilter.departureMinTime)
        
        let startTime = currentTimerFilter.userSelectedStartTime.timeIntervalSince(startOfDay)
        let roundedMinDeparture = 3600.0 * floor(startTime / 3600.0)
        
        departureStartTimeInterval = roundedMinDeparture
        
        let endTime = currentTimerFilter.userSelectedEndTime.timeIntervalSince(startOfDay)
        departureEndTimeInterval = 3600.0 * ceil(endTime / 3600.0)
        updateDepartureUIValues()
    }
    
    fileprivate func initialSetupDepartureRangeSlider() {
        
        departureRangeSlider.addTarget(self, action: #selector(departureRangeChanged), for: .valueChanged)
        departureRangeSlider.addTarget(self, action: #selector(departurnRangeUpdated), for: .touchUpInside)
        departureRangeSlider.createMarkersAt(positions: [0.25 , 0.5 , 0.75] )
        
        if currentTimerFilter != nil{
            setDepartureSliderValues()
        }
    }
    
    fileprivate func setupDeparatureRangeButtons() {
        
        earlyMorningButton.isEnabled = true
        noonButton.isEnabled = true
        noonButton.isEnabled = true
        eveningButton.isEnabled = true
        lateEveningButton.isEnabled = true
        
        earlyMorningButton.alpha = 1
        noonButton.alpha = 1
        noonButton.alpha = 1
        eveningButton.alpha = 1
        lateEveningButton.alpha = 1
        
        
        let startDateTime = Calendar.current.startOfDay(for: currentTimerFilter.departureMinTime)
        let minTimeInterval = currentTimerFilter.departureMinTime.timeIntervalSince(startDateTime)
        let maxTimeInterval = currentTimerFilter.departureTimeMax.timeIntervalSince(startDateTime)

        let startTime = TimeInterval(3600 * floor(minTimeInterval / 3600))

        let endTime = 3600 * TimeInterval(ceil(maxTimeInterval  / 3600 ))
        
        
        if startTime > TimeInterval.sixAM {
//            earlyMorningButton.isEnabled = false
            earlyMorningButton.alpha = 0.6
        }
        
        if startTime > TimeInterval.twelvePM {
//            noonButton.isEnabled = false
            noonButton.alpha = 0.6
        }
        
        if startTime > TimeInterval.sixPM {
//            eveningButton.isEnabled = false
            eveningButton.alpha = 0.6
        }
        
        if endTime < TimeInterval.sixPM {
//            lateEveningButton.isEnabled = false
            lateEveningButton.alpha = 0.6
        }
        
        if endTime < TimeInterval.twelvePM {
//            eveningButton.isEnabled = false
            eveningButton.alpha = 0.6
        }
        
        if endTime < TimeInterval.sixAM {
//            noonButton.isEnabled = false
            noonButton.alpha = 0.6
        }

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(sender:)))
        departureButtonStackView.isUserInteractionEnabled = true
        departureButtonStackView.addGestureRecognizer(panGesture)
    }
    
    
//    @objc func handlePanOnView(sender: UIPanGestureRecognizer) {
//
//        guard let senderView = sender.view else { return }
//
//        if sender.state == .began {
//            dragStartPosition = sender.location(in: senderView).x
//        }
//
//        if sender.state == .ended {
//            dragEndPosition = sender.location(in: senderView).x
//
//            if dragEndPosition < dragStartPosition {
//                dragStartPosition = 0.0
//                dragEndPosition = 0.0
//                return
//            }
//
//            let width = senderView.frame.width
//            let partWidth = width/4.0
//
//            let startPosition = floor(dragStartPosition  /  partWidth )
//            let endPosition =  ceil(dragEndPosition  /  partWidth )
//            var showMessage = false
//            let calendar = Calendar.current
//            let startTime = calendar.startOfDay(for: currentTimerFilter.departureMinTime)
//            let minDeparture = currentTimerFilter.departureMinTime.timeIntervalSince(startTime)
//            let roundedMinDeparture = TimeInterval(3600.0 * floor((minDeparture  / 3600 )))
//            let maxDeparture =  currentTimerFilter.departureTimeMax.timeIntervalSince(startTime)
//            let roundedMaxDeparture = TimeInterval(3600 * ceil(maxDeparture  / 3600 ))
//
//
//            switch startPosition {
//            case 0 :
//                if roundedMinDeparture > TimeInterval.startOfDay {
//                    departureStartTimeInterval = roundedMinDeparture
//                    showMessage = true
//                }
//                else {
//                    departureStartTimeInterval = TimeInterval.startOfDay
//                }
//            case 1 :
//
//                if roundedMinDeparture > TimeInterval.sixAM {
//                    departureStartTimeInterval = roundedMinDeparture
//                    showMessage = true
//                }
//                else {
//                    departureStartTimeInterval = TimeInterval.sixAM
//                }
//            case 2 :
//                if roundedMinDeparture > TimeInterval.twelvePM {
//                    departureStartTimeInterval = roundedMinDeparture
//                    showMessage = true
//                }
//                else {
//                    departureStartTimeInterval = TimeInterval.twelvePM
//                }
//            case 3 :
//
//                if roundedMinDeparture > TimeInterval.sixPM {
//                    departureStartTimeInterval = roundedMinDeparture
//                    showMessage = true
//                }
//                else {
//                    departureStartTimeInterval = TimeInterval.sixPM
//                }
//
//            default:
//                print("unknown state")
//            }
//
//            switch  endPosition{
//            case 1 :
//                if roundedMaxDeparture < TimeInterval.sixAM  {
//                    departureEndTimeInterval = roundedMaxDeparture
//                    showMessage = true
//                }
//                else {
//                    departureEndTimeInterval = TimeInterval.sixAM
//                }
//            case 2 :
//                if roundedMaxDeparture < TimeInterval.twelvePM {
//                    departureEndTimeInterval = roundedMaxDeparture
//                    showMessage = true
//                }
//                else {
//                    departureEndTimeInterval = TimeInterval.twelvePM
//                }
//            case 3 :
//                if roundedMaxDeparture < TimeInterval.sixPM {
//                    departureEndTimeInterval = roundedMaxDeparture
//                    showMessage = true
//                }
//                else {
//                    departureEndTimeInterval = TimeInterval.sixPM
//                }
//            case 4 , 5 :
//
//                if roundedMaxDeparture < TimeInterval.endOfDay {
//                    departureEndTimeInterval = roundedMaxDeparture
//                    showMessage = true
//                }
//                    else {
//                    departureEndTimeInterval = TimeInterval.endOfDay
//                }
//
//            default:
//                print("unknown state")
//            }
//
//            //*******************Haptic Feedback code********************
//            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
//            selectionFeedbackGenerator.selectionChanged()
//            //*******************Haptic Feedback code********************
//
//            updateDepartureUIValues()
//            var message = String()
//
//            if showMessage {
//                message = "Flights are available between " +  stringFromTimeInterval(interval: departureStartTimeInterval) + " and " + stringFromTimeInterval(interval: departureEndTimeInterval)
//                showToastMessageForAvailableDepartureRange(message)
//            }
//
//            delegate?.departureSelectionChangedAt(currentActiveIndex , minDuration:departureStartTimeInterval , maxDuration: departureEndTimeInterval)
//            dragStartPosition = 0.0
//            dragEndPosition = 0.0
//
//
//        }
//    }
        
    @objc private func handlePan(sender: UIPanGestureRecognizer) {
        
        guard let senderView = sender.view else { return }
        
        let location = sender.location(in: senderView)
        
        if locationOutOfRange(senderView: senderView, location: location) {
            return
        }
        
        if let startPos = panStartPos {
            highlightButtonsInRange(mainRectView: senderView, startPos: startPos, curPos: location.x)
        }
        
        if sender.state == .began {
            panStartPos = location.x
        }
        
        if sender.state == .changed {
            
            let calendar = Calendar.current
            let startTime = calendar.startOfDay(for: currentTimerFilter.departureMinTime)
            let minDeparture = currentTimerFilter.departureMinTime.timeIntervalSince(startTime)
            let roundedMinDeparture = TimeInterval(3600.0 * floor((minDeparture  / 3600 )))
            let maxDeparture =  currentTimerFilter.departureTimeMax.timeIntervalSince(startTime)
            let roundedMaxDeparture = TimeInterval(3600 * ceil(maxDeparture  / 3600 ))
            
            let width = senderView.frame.width
            let partWidth = width/4.0
            
            let panStartPositionInNumber = (panStartPos ?? 0) / partWidth
            
            if location.x < (panStartPos ?? 0) {
                let curPosInNumber = floor(location.x / partWidth)
                handleLeftSidePan(maxPosNumber: ceil(panStartPositionInNumber), roundedMinDeparture: roundedMinDeparture, roundedMaxDeparture: roundedMaxDeparture, curPosNumber: curPosInNumber)
                
            } else {
                let curPosInNumber = ceil(location.x / partWidth)
                handleRightSidePan(minPosNumber: floor(panStartPositionInNumber), roundedMinDeparture: roundedMinDeparture, roundedMaxDeparture: roundedMaxDeparture, curPosNumber: curPosInNumber)
            }
            UIView.animate(withDuration: 0.3) {
                self.updateDepartureUIValues()
                self.view.layoutIfNeeded()
            }
        }
        
        if sender.state == .ended || sender.state == .cancelled {
            delegate?.departureSelectionChangedAt(currentActiveIndex , minDuration:departureStartTimeInterval , maxDuration: departureEndTimeInterval)
            self.buttonReleased(sender: UIButton())
        }
    }
    
    private func locationOutOfRange(senderView: UIView, location: CGPoint) -> Bool {
        
        var leftFrameToExclude: CGRect = .zero
        var rightFrameToExclude: CGRect = .zero
        
        let startDateTime = Calendar.current.startOfDay(for: currentTimerFilter.departureMinTime)
        let minTimeInterval = currentTimerFilter.departureMinTime.timeIntervalSince(startDateTime)
        let maxTimeInterval = currentTimerFilter.departureTimeMax.timeIntervalSince(startDateTime)
        
        let startTime = TimeInterval(3600 * floor(minTimeInterval / 3600))
        
        let endTime = 3600 * TimeInterval(ceil(maxTimeInterval  / 3600 ))
        
        
        if startTime > TimeInterval.sixAM {
            leftFrameToExclude = earlyMorningContainerView.convert(earlyMorningButton.frame, to: senderView)
        }
        
        if startTime > TimeInterval.twelvePM {
            leftFrameToExclude = noonContainerView.convert(noonButton.frame, to: senderView)
        }
        
        if startTime > TimeInterval.sixPM {
            leftFrameToExclude = eveningContainerView.convert(eveningButton.frame, to: senderView)
        }
        
        if endTime < TimeInterval.sixPM {
            rightFrameToExclude = lateEveningContainerView.convert(lateEveningButton.frame, to: senderView)
        }
        
        if endTime < TimeInterval.twelvePM {
            rightFrameToExclude = eveningContainerView.convert(eveningButton.frame, to: senderView)
        }
        
        if endTime < TimeInterval.sixAM {
            rightFrameToExclude = noonContainerView.convert(noonButton.frame, to: senderView)
        }
        
        leftFrameToExclude.origin.x -= senderView.width
        leftFrameToExclude.size.width += senderView.width + 25
        rightFrameToExclude.origin.x -= 25
        rightFrameToExclude.size.width = senderView.width
        
        if leftFrameToExclude.contains(location) || rightFrameToExclude.contains(location) {
            return true
        }
        return false
    }
    
    private func highlightButtonsInRange(mainRectView: UIView, startPos: CGFloat, curPos: CGFloat) {
        var selectedRect: CGRect = .zero
        selectedRect = earlyMorningButton.frame
        if startPos < curPos {
            selectedRect.origin.x = startPos
            selectedRect.size.width = curPos - startPos
        } else {
            selectedRect.origin.x = curPos
            selectedRect.size.width = startPos - curPos
        }
        
        highlightUnhighlightButtonsInRect(selectedRect: selectedRect, mainRectView: mainRectView)
    }
    
    private func highlightUnhighlightButtonsInRect(selectedRect: CGRect, mainRectView: UIView) {
        let btnArr = [earlyMorningButton, noonButton, eveningButton, lateEveningButton]
        btnArr.forEach { (btn) in
            if let button = btn, let btnSuperViewRect = button.superview?.frame {
                if selectedRect.intersects(btnSuperViewRect) {
                    button.backgroundColor = UIColor(displayP3Red: 236.0/255.0 , green:253.0/255.0 , blue:244.0/255.0 , alpha:1)
                } else {
                    button.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
                }
            }
        }
    }
    
    private func handleRightSidePan(minPosNumber: CGFloat, roundedMinDeparture: TimeInterval, roundedMaxDeparture: TimeInterval, curPosNumber: CGFloat) {
        
        switch minPosNumber {
            case 0 :
                if roundedMinDeparture > TimeInterval.startOfDay {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.startOfDay
                }
            case 1 :
                
                if roundedMinDeparture > TimeInterval.sixAM {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.sixAM
                }
            case 2 :
                if roundedMinDeparture > TimeInterval.twelvePM {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.twelvePM
                }
            case 3 :
                
                if roundedMinDeparture > TimeInterval.sixPM {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.sixPM
                }
                
            default:
                print("unknown state")
        }
        
        switch curPosNumber {
        case 1 :
            if roundedMaxDeparture < TimeInterval.sixAM  {
                departureEndTimeInterval = roundedMaxDeparture
            }
            else {
                departureEndTimeInterval = TimeInterval.sixAM
            }
        case 2 :
            if roundedMaxDeparture < TimeInterval.twelvePM {
                departureEndTimeInterval = roundedMaxDeparture
            }
            else {
                departureEndTimeInterval = TimeInterval.twelvePM
            }
        case 3 :
            if roundedMaxDeparture < TimeInterval.sixPM {
                departureEndTimeInterval = roundedMaxDeparture
            }
            else {
                departureEndTimeInterval = TimeInterval.sixPM
            }
        case 4 , 5 :
        
            if roundedMaxDeparture < TimeInterval.endOfDay {
                departureEndTimeInterval = roundedMaxDeparture
            }
                else {
                departureEndTimeInterval = TimeInterval.endOfDay
            }
            
        default:
            print("unknown state")
        }
        
    }
    
    private func handleLeftSidePan(maxPosNumber: CGFloat, roundedMinDeparture: TimeInterval, roundedMaxDeparture: TimeInterval, curPosNumber: CGFloat) {
        
        switch maxPosNumber {
        case 1 :
            if roundedMaxDeparture < TimeInterval.sixAM  {
                departureEndTimeInterval = roundedMaxDeparture
            }
            else {
                departureEndTimeInterval = TimeInterval.sixAM
            }
        case 2 :
            if roundedMaxDeparture < TimeInterval.twelvePM {
                departureEndTimeInterval = roundedMaxDeparture
            }
            else {
                departureEndTimeInterval = TimeInterval.twelvePM
            }
        case 3 :
            if roundedMaxDeparture < TimeInterval.sixPM {
                departureEndTimeInterval = roundedMaxDeparture
            }
            else {
                departureEndTimeInterval = TimeInterval.sixPM
            }
        case 4 , 5 :
        
            if roundedMaxDeparture < TimeInterval.endOfDay {
                departureEndTimeInterval = roundedMaxDeparture
            }
                else {
                departureEndTimeInterval = TimeInterval.endOfDay
            }
            
        default:
            print("unknown state")
        }
                
        switch curPosNumber {
            case 0 :
                if roundedMinDeparture > TimeInterval.startOfDay {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.startOfDay
                }
            case 1 :
                
                if roundedMinDeparture > TimeInterval.sixAM {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.sixAM
                }
            case 2 :
                if roundedMinDeparture > TimeInterval.twelvePM {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.twelvePM
                }
            case 3 :
                
                if roundedMinDeparture > TimeInterval.sixPM {
                    departureStartTimeInterval = roundedMinDeparture
                }
                else {
                    departureStartTimeInterval = TimeInterval.sixPM
                }
                
            default:
                print("unknown state")
        }
    }
    
    @objc fileprivate func departureRangeChanged () {
        
        let leftValue  = departureRangeSlider.leftValue
        let rightValue = departureRangeSlider.rightValue
        var startTime  =  TimeInterval(leftValue * 86400.0 )
        var endTime    =  TimeInterval(rightValue * 86400.0 )

        startTime   =    3600 * floor(startTime / 3600)
        endTime     =    3600 * floor(endTime  / 3600 )
        departureStartTime.text = stringFromTimeInterval(interval: startTime)
        departureEndTime.text = stringFromTimeInterval(interval: endTime)
        
        if departureStartTime.text == "00:00" || departureStartTime.text == "06:00" || departureStartTime.text == "12:00" || departureStartTime.text == "18:00" || departureStartTime.text == "24:00" || departureEndTime.text == "00:00" || departureEndTime.text == "06:00" || departureEndTime.text == "12:00" || departureEndTime.text == "18:00" || departureEndTime.text == "24:00"
        {
            //*******************Haptic Feedback code********************
               let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
               selectionFeedbackGenerator.selectionChanged()
            //*******************Haptic Feedback code********************

        }
        
    }
    
    fileprivate func updateDepartureUIValues() {
        
        let leftValue = departureStartTimeInterval / 86400.0
        let rightValue = departureEndTimeInterval / 86400.0
        
        departureRangeSlider.set(leftValue: CGFloat(leftValue) , rightValue: CGFloat( rightValue) )
        departureStartTime.text = stringFromTimeInterval(interval: departureStartTimeInterval)
        departureEndTime.text = stringFromTimeInterval(interval: departureEndTimeInterval)
        setDepartureLabel()
        
        if departureStartTime.text == "00:00" || departureStartTime.text == "06:00" || departureStartTime.text == "12:00" || departureStartTime.text == "18:00" || departureStartTime.text == "24:00" || departureEndTime.text == "00:00" || departureEndTime.text == "06:00" || departureEndTime.text == "12:00" || departureEndTime.text == "18:00" || departureEndTime.text == "24:00"
        {
            //*******************Haptic Feedback code********************
               let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
               selectionFeedbackGenerator.selectionChanged()
            //*******************Haptic Feedback code********************

        }
    }
    
    func showToastMessageForAvailableDepartureRange(_ message : String) {
        
        if let view = self.parent?.view {
            AertripToastView.toast(in: view, withText: message)
        }
        
//        if multiLegTimerFilter.count > 1{
//            var frame = UIApplication.shared.windows.last!.frame
//            let bottomInset = self.view.safeAreaInsets.bottom
//            let height = 70 + bottomInset
//            frame.size.height = frame.size.height - height
//
//            AertripToastView.toast(in: UIApplication.shared.windows.last! , withText: message , parentRect: frame)
//        }else{
//            var frame = UIApplication.shared.windows.last!.frame
//            let bottomInset = self.view.safeAreaInsets.bottom
//            let height = 16 + bottomInset
//            frame.size.height = frame.size.height - height
//
//            AertripToastView.toast(in: UIApplication.shared.windows.last! , withText: message , parentRect: frame)
//        }
        
    }
    
    @objc fileprivate func departurnRangeUpdated() {
        
        let rangeLeftValue  = departureRangeSlider.leftValue
        let  rangeRightValue = departureRangeSlider.rightValue
        var leftValue  =  TimeInterval(rangeLeftValue * 86400.0 )
        var rightValue   =  TimeInterval(rangeRightValue * 86400.0 )
        
        leftValue   =    3600 * floor(leftValue / 3600)
        rightValue     =    3600 * floor(rightValue  / 3600 )
        
        var showMessage = false
        var message = String()
        
        let startDateTime = Calendar.current.startOfDay(for: currentTimerFilter.departureMinTime)
        let minTimeInterval = currentTimerFilter.departureMinTime.timeIntervalSince(startDateTime)
        let maxTimeInterval = currentTimerFilter.departureTimeMax.timeIntervalSince(startDateTime)

        let startTime = TimeInterval(3600 * floor(minTimeInterval / 3600))
        departureStartTimeInterval = TimeInterval(3600 * floor(leftValue / 3600))

        if leftValue < startTime {
            departureStartTimeInterval = TimeInterval(startTime)
            showMessage = true
        }

        let endTime = 3600 * TimeInterval(ceil(maxTimeInterval  / 3600 ))
        departureEndTimeInterval = TimeInterval(3600 * floor(rightValue / 3600))

        if rightValue > endTime {
            departureEndTimeInterval = TimeInterval(endTime)
            showMessage = true
        }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: currentTimerFilter.departureMinTime)
        currentTimerFilter.userSelectedStartTime = startOfDay.addingTimeInterval(departureStartTimeInterval)
        currentTimerFilter.userSelectedEndTime = startOfDay.addingTimeInterval(departureEndTimeInterval)
        
        updateDepartureUIValues()
        if showMessage {
            
            let availableMinTime = TimeInterval(3600 * floor(minTimeInterval / 3600))
            let availabelMaxTime = TimeInterval(3600 * ceil(maxTimeInterval / 3600))
            
            message = "Flights are available between " +  stringFromTimeInterval(interval: availableMinTime) + " and " + stringFromTimeInterval(interval: availabelMaxTime)
            showToastMessageForAvailableDepartureRange(message)
            return
        }
        
        multiLegTimerFilter[currentActiveIndex] = currentTimerFilter
        setmultiLegSubviews()
        delegate?.departureSelectionChangedAt(currentActiveIndex , minDuration:departureStartTimeInterval , maxDuration: departureEndTimeInterval)
    }
    
    
    @IBAction func departureSelectedByRangeButtons(_ sender: UIButton) {
        
        guard sender.alpha == 1 else {
            let message = "Flights are available between " +  stringFromTimeInterval(interval: departureStartTimeInterval) + " and " + stringFromTimeInterval(interval: departureEndTimeInterval)
            showToastMessageForAvailableDepartureRange(message)
            return
        }
        
        let buttonTag = sender.tag
        var message = String()
        var showMessage = false
        let calendar = Calendar.current
        let startTime = calendar.startOfDay(for: currentTimerFilter.departureMinTime)
        let minDeparture = currentTimerFilter.departureMinTime.timeIntervalSince(startTime)
        let roundedMinDeparture = TimeInterval(3600.0 * floor((minDeparture  / 3600 )))
        let maxDeparture =  currentTimerFilter.departureTimeMax.timeIntervalSince(startTime)
        let roundedMaxDeparture = TimeInterval(3600 * ceil(maxDeparture  / 3600 ))
        
        switch buttonTag {
        case 1 :
            
            if roundedMinDeparture > TimeInterval.startOfDay {
                departureStartTimeInterval = roundedMinDeparture
                showMessage = true
            }
            else {
                departureStartTimeInterval = TimeInterval.startOfDay
            }
            if roundedMaxDeparture < TimeInterval.sixAM  {
                departureEndTimeInterval = roundedMaxDeparture
                showMessage = true
            }
            else {
                departureEndTimeInterval = TimeInterval.sixAM
            }
            
            
        case 2 :
            
            if roundedMinDeparture > TimeInterval.sixAM {
                departureStartTimeInterval = roundedMinDeparture
                showMessage = true
            }
            else {
                departureStartTimeInterval = TimeInterval.sixAM
            }
            if roundedMaxDeparture < TimeInterval.twelvePM {
                departureEndTimeInterval = roundedMaxDeparture
                showMessage = true
            }
            else {
                departureEndTimeInterval = TimeInterval.twelvePM
            }
        case 3 :
            if roundedMinDeparture > TimeInterval.twelvePM {
                departureStartTimeInterval = roundedMinDeparture
                showMessage = true
            }
            else {
                departureStartTimeInterval = TimeInterval.twelvePM
            }
            if roundedMaxDeparture < TimeInterval.sixPM {
                departureEndTimeInterval = roundedMaxDeparture
                showMessage = true
            }
            else {
                departureEndTimeInterval = TimeInterval.sixPM
            }
            
        case 4 :
            
            if roundedMinDeparture > TimeInterval.sixPM {
                departureStartTimeInterval = roundedMinDeparture
                showMessage = true
            }
            else {
                departureStartTimeInterval = TimeInterval.sixPM
            }
            
            if roundedMaxDeparture < TimeInterval.endOfDay {
                departureEndTimeInterval = roundedMaxDeparture
                showMessage = true
            }
            else {
                departureEndTimeInterval = TimeInterval.endOfDay
            }
        default:
            print("unknown state")
        }
        
        
        let startOfDay = calendar.startOfDay(for: currentTimerFilter.departureMinTime)
        currentTimerFilter.userSelectedStartTime = startOfDay.addingTimeInterval(departureStartTimeInterval)
        currentTimerFilter.userSelectedEndTime = startOfDay.addingTimeInterval(departureEndTimeInterval)

        updateDepartureUIValues()
        if showMessage {
            
            message = "Flights are available between " +  stringFromTimeInterval(interval: departureStartTimeInterval) + " and " + stringFromTimeInterval(interval: departureEndTimeInterval)
            showToastMessageForAvailableDepartureRange(message)
        }
        
        multiLegTimerFilter[currentActiveIndex] = currentTimerFilter
        setmultiLegSubviews()
        delegate?.departureSelectionChangedAt(currentActiveIndex , minDuration:departureStartTimeInterval , maxDuration: departureEndTimeInterval)
        
        //*******************Haptic Feedback code********************
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.selectionChanged()
        //*******************Haptic Feedback code********************
        
    }
    

    
    //MARK:- Multi Leg Feature
    fileprivate func setmultiLegSubviews () {
        
        multiSegmentView.subviews.forEach { $0.removeFromSuperview() }
        
        multiSegmentView.layer.cornerRadius = 3
        multiSegmentView.layer.borderColor = UIColor.AertripColor.cgColor
        multiSegmentView.layer.borderWidth = 1.0
        multiSegmentView.clipsToBounds = true
        
        let numberOfStops = multiLegTimerFilter.count
        
        if numberOfStops > 0 {
            for  i in 1...numberOfStops  {
                
                let segmentViewWidth = UIScreen.main.bounds.size.width - 32
                let width = segmentViewWidth / CGFloat(numberOfStops)
                let xcordinate = CGFloat( i - 1 ) * width
                let height = self.multiSegmentView.frame.size.height
                var rect = CGRect(x: xcordinate, y: 0, width: width, height: height)
                let stopButton = UIButton(frame: rect)
                stopButton.tag = (i - 1)
                
                var normalStateTitle : NSMutableAttributedString
                let currentFilter = multiLegTimerFilter[(i - 1)]
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
                    let leg = multiLegTimerFilter[(i - 1)].leg
                    normalStateTitle = leg.getTitle(isCurrentlySelected: isCurrentIndexActive, isFilterApplied: isFilterApplied)
                }
                
                stopButton.setAttributedTitle(normalStateTitle, for: .normal)
                stopButton.addTarget(self, action: #selector(tappedOnMulticityButton(sender:)), for: .touchDown)
                
                multiSegmentView.addSubview(stopButton)
                
                if i != numberOfStops {
                    rect  = CGRect(x: xcordinate + width - 1 , y: 0, width: 1, height: 30)
                    let verticalSeparator = UIView(frame: rect)
                    verticalSeparator.backgroundColor = UIColor.AertripColor
                    multiSegmentView.addSubview(verticalSeparator)
                }
            }
        }
    }
    
    
    @objc fileprivate func tappedOnMulticityButton( sender : UIButton) {
        
        let tag = sender.tag
        
        if tag == currentActiveIndex {
            return
        } else {
            multiLegTimerFilter[currentActiveIndex] = currentTimerFilter
            currentActiveIndex = tag
        }
        
        currentTimerFilter = multiLegTimerFilter[currentActiveIndex]
        if currentTimerFilter != nil {
            setDepartureSliderValues()
        }
        setmultiLegSubviews()
        setDepartureLabel()
        if currentTimerFilter != nil{
            setArrivalSliderValues(userSelected: true)
        }
        setupDeparatureRangeButtons()
    }
    
    
    //MARK:- Arrival feature methods
    fileprivate func setArrivalSliderValues(userSelected:Bool ) {
        
        if userSelected {
            arrivalInputStartDate = currentTimerFilter.userSelectedArrivalStartTime
            arrivalInputEndDate = currentTimerFilter.userSelectedArrivalEndTime
        } else {
            arrivalInputStartDate = currentTimerFilter.arrivalStartTime
            arrivalInputEndDate = currentTimerFilter.arrivalEndTime
        }
        
        self.arivalDifferenceInSeconds = currentTimerFilter.arrivalEndTime.timeIntervalSince(currentTimerFilter.arrivalStartTime)
            
        let startTimeInterval = arrivalInputStartDate.timeIntervalSince(currentTimerFilter.arrivalStartTime)
        let endTimeInterval = arrivalInputEndDate.timeIntervalSince(currentTimerFilter.arrivalStartTime)
       
        let startPosition = startTimeInterval / Double(arivalDifferenceInSeconds)
        let endPosition = endTimeInterval / Double(arivalDifferenceInSeconds)
                
        arrivalRangeSlider.set(leftValue: CGFloat(startPosition), rightValue: CGFloat(endPosition))
        
        arrivalStartTime.text = dateStringFromTime(date: arrivalInputStartDate)
        arrivalStartTimeWidth.constant = arrivalStartTime.intrinsicContentSize.width + 16.0
        
        arrivalEndTime.text = dateStringFromTime(date: arrivalInputEndDate)
        arrivalEndTimeWidth.constant = arrivalEndTime.intrinsicContentSize.width + 16.0
        
    }
    
    fileprivate func setupArrivalRangeSlider() {
      
        
        arrivalRangeSlider.addTarget(self, action: #selector(arrivalRangeChanged), for: .valueChanged)
        arrivalRangeSlider.addTarget(self, action: #selector(arrivalRangeUpdated), for: .touchUpInside)
        if currentTimerFilter != nil{
            setArrivalSliderValues(userSelected: true)
        }
        addDaysSeparatorInArrivalRangeSlider()

    }
    
    func addDaysSeparatorInArrivalRangeSlider(){
        let startOfInputStartDay = Calendar.current.startOfDay(for: arrivalInputStartDate)
        let startOfInputEndDay = Calendar.current.startOfDay(for: arrivalInputEndDate)
        let diffFromStartOfDay = arrivalInputStartDate.timeIntervalSince(startOfInputStartDay)
        let timeDifference = CGFloat(arrivalInputEndDate.timeIntervalSince(arrivalInputStartDate))

        guard let numberOfDays = Calendar.current.dateComponents( [.day] , from: startOfInputStartDay, to: startOfInputEndDay).day else {
            assertionFailure("Failed to get numberOfDays")
            return
        }
        
        if numberOfDays > 0 {
            var positions = [CGFloat]()
            for i in 1...numberOfDays {
                let nextDayMidNight =  CGFloat(i * 86400) - CGFloat(diffFromStartOfDay)
                let x = nextDayMidNight / timeDifference
                positions.append(x)
            }
            arrivalRangeSlider.createMarkersAt(positions: positions)
        }
    }
    
    func daySeparatorView() -> UIView {
        
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 3 ))
        separatorView.backgroundColor  = UIColor.black.withAlphaComponent(0.4)
        return separatorView
    }
    
    func getArrivalDates() -> (Date , Date) {
        let leftValue =  arrivalRangeSlider.leftValue
        let rightValue = arrivalRangeSlider.rightValue
      
        let timeDifference = currentTimerFilter.arrivalEndTime.timeIntervalSince(currentTimerFilter.arrivalStartTime)
        
        var startTime = (TimeInterval(leftValue) * timeDifference)
        
        startTime =   (floor(startTime / 3600 ) ) * 3600
        
        let addingDateInStart = currentTimerFilter.arrivalStartTime.addingTimeInterval(startTime)
        
        var endTime = (TimeInterval(rightValue) * timeDifference)
        
        endTime = (ceil(endTime / 3600 ) ) * 3600

        let addingDateInEnd = currentTimerFilter.arrivalStartTime.addingTimeInterval(endTime)

        return (addingDateInStart , addingDateInEnd)
        

//        var startTime =   timeDifference * leftValue
//
//        startTime =   (floor(startTime / 3600 ) ) * 3600
//
//        let startDate = arrivalInputStartDate.addingTimeInterval(TimeInterval(startTime))
//
//        var endTime =  timeDifference * rightValue
//        endTime = (floor(endTime / 3600 ) ) * 3600
//        let endDate =  arrivalInputStartDate.addingTimeInterval(TimeInterval(endTime))
//        return ( startDate , endDate )
    }
    
    @objc fileprivate func arrivalRangeChanged () {
//        print(arrivalRangeSlider.leftValue)

        let (startDate , endDate) = getArrivalDates()
        arrivalStartTime.text = dateStringFromTime(date: startDate)
        arrivalStartTimeWidth.constant = arrivalStartTime.intrinsicContentSize.width + 16.0
        arrivalEndTime.text = dateStringFromTime(date: endDate)
        arrivalEndTimeWidth.constant = arrivalEndTime.intrinsicContentSize.width + 16.0
        
        if arrivalEndTime.text!.contains(find: "00:00") || arrivalStartTime.text!.contains(find: "00:00")
         {
             //*******************Haptic Feedback code********************
             let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
             selectionFeedbackGenerator.selectionChanged()
             //*******************Haptic Feedback code********************
             
         }
    }
        
    @objc fileprivate func arrivalRangeUpdated() {
        let (startDate , endDate) = getArrivalDates()
        currentTimerFilter.userSelectedArrivalStartTime = startDate
        currentTimerFilter.userSelectedArrivalEndTime = endDate
        multiLegTimerFilter[currentActiveIndex] = currentTimerFilter
        setmultiLegSubviews()
        delegate?.arrivalSelectionChangedAt(currentActiveIndex, minDate: startDate, maxDate: endDate)
    }

    //MARK:- Date, time conversion methods
    fileprivate func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    
    fileprivate func dateFromTime(interval : TimeInterval) -> Date {
        
        var currentTimeInterval = arrivalInputStartDate.timeIntervalSince1970
        currentTimeInterval = currentTimeInterval + interval
        currentTimeInterval = TimeInterval(3600 * Int(round(currentTimeInterval / 3600)))
        return Date(timeIntervalSince1970: currentTimeInterval)
        
    }
    
    fileprivate func dateStringFromTime(date : Date) -> String {

        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EE, HH:mm"
        return dateformatter.string(from: date)
    }

    //MARK:- FilterViewController delegate method
    
    func initialSetup() {
       
        
        if multiLegTimerFilter.count == 1 {
            multiLegViewHeight.constant = 0
            multiLegView.isHidden = true
        } else {
            multiLegViewHeight.constant = 50
            multiLegView.isHidden = false
            setmultiLegSubviews()
        }
        
        if multiLegTimerFilter.count > 0 {
            currentTimerFilter = multiLegTimerFilter[0]
        }
        initialSetupDepartureRangeSlider()
        setDepartureLabel()
        setupDeparatureRangeButtons()
        setupArrivalRangeSlider()
        
        earlyMorningButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        earlyMorningButton.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        
        noonButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        noonButton.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        
        eveningButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        eveningButton.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        
        lateEveningButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        lateEveningButton.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
    }
    
    @objc func buttonPressed(sender:UIButton)
    {
        switch sender.tag
        {
        case 1 :
            
            earlyMorningButton.backgroundColor = UIColor(displayP3Red: 236.0/255.0 , green:253.0/255.0 , blue:244.0/255.0 , alpha:1)
            noonButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            eveningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            lateEveningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            
        case 2 :
            earlyMorningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            noonButton.backgroundColor = UIColor(displayP3Red: 236.0/255.0 , green:253.0/255.0 , blue:244.0/255.0 , alpha:1)
            eveningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            lateEveningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            
        case 3 :
            earlyMorningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            noonButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            eveningButton.backgroundColor = UIColor(displayP3Red: 236.0/255.0 , green:253.0/255.0 , blue:244.0/255.0 , alpha:1)
            lateEveningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            
        case 4 :
            earlyMorningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            noonButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            eveningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            lateEveningButton.backgroundColor = UIColor(displayP3Red: 236.0/255.0 , green:253.0/255.0 , blue:244.0/255.0 , alpha:1)
            
        default:
            print("unknown state")
        }
    }
    
    @objc func buttonReleased(sender:UIButton)
    {
        earlyMorningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
        noonButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
        eveningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
        lateEveningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
    }
        
    func setUIValues(){
          let calendar = Calendar.current
          let startOfDay = calendar.startOfDay(for: currentTimerFilter.departureMinTime)
          let startTime = currentTimerFilter.departureMinTime.timeIntervalSince(startOfDay)
        
          let roundedMinDeparture = 3600.0 * floor(startTime / 3600.0)
          
          departureStartTimeInterval = roundedMinDeparture
          
          let endTime = currentTimerFilter.departureTimeMax.timeIntervalSince(startOfDay)
          departureEndTimeInterval = 3600.0 * ceil(endTime / 3600.0)
          updateDepartureUIValues()
          
          
        if currentTimerFilter != nil {
            setArrivalSliderValues(userSelected: false)
        }
          
        if multiLegTimerFilter.count == 1 {
              multiLegViewHeight.constant = 0   
              multiLegView.isHidden = true
          }
          else {
              multiLegViewHeight.constant = 50
              multiLegView.isHidden = false
              setmultiLegSubviews()
          }
    }
    
    func updateUIPostLatestResults() {
        setUIValues()
    }

    func resetFilter() {
        
        for i in 0 ..< multiLegTimerFilter.count {
            var filter = multiLegTimerFilter[i]
            filter.resetFilter()
            multiLegTimerFilter[i] = filter
        }
        
        currentTimerFilter.resetFilter()
        setUIValues()
        
        
    }
}

