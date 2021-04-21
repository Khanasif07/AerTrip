//
//  FlightFilterTimesViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class FlightFilterTimesViewController : UIViewController , FilterViewController {
    
    //MARK:- State Properties
    
    let viewModel = FlightFilterTimesVM()
    var onToastInitiation: ((String) -> ())?
    private var multiLegSegmentControl = UISegmentedControl()
        
    /// Used for day segments pan gesture
    var panGesture: UIPanGestureRecognizer?
    private var highlightedBtnArr = Set<UIButton>()
    
    //MARK:- multiLeg Outlets
    @IBOutlet weak var flightTimesScrollView: UIScrollView!
    @IBOutlet weak var multiLegViewHeight: NSLayoutConstraint!
    @IBOutlet weak var multiLegView: UIView!
    @IBOutlet weak var multiSegmentView: UIView!
    @IBOutlet weak var sectorNameLbl: UILabel!
    
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
   
    @IBOutlet weak var avoidOvernightView: UIView!
    @IBOutlet weak var avoidOvernightTitleLbl: UILabel!
    @IBOutlet weak var allSectorsLbl: UILabel!
    @IBOutlet weak var avoidOvernightDescLbl: UILabel!
    @IBOutlet weak var avoidOvernightImgView: UIImageView!
    @IBOutlet weak var avoidOvernightBtn: UIButton!
    
    @IBOutlet weak var noTimesView: UIView!
    @IBOutlet weak var noTimesLbl: UILabel!
    
    //MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    /// Updates UI if data is coming and filters
    func updateFiltersFromAPI() {
        viewModel.currentTimerFilter = viewModel.multiLegTimerFilter[viewModel.currentActiveIndex]
        noTimesView.isHidden = viewModel.currentTimerFilter.isAvailable
        if viewModel.multiLegTimerFilter.count == 1 {
            multiLegViewHeight.constant = 0
            multiLegView.isHidden = true
        }
        else {
            multiLegViewHeight.constant = 50
            multiLegView.isHidden = false
            setupMultiLegSegmentControl()
        }
        guard departureRangeSlider != nil else { return }
        setupDeparatureRangeButtons()
        UIView.animate(withDuration: 0.3) {
            self.setDepartureSliderValues()
//            self.setArrivalSliderValues(userSelected: false)
            self.setArrivalSliderValues(userSelected: true)
            self.departureRangeSlider.layoutIfNeeded()
            self.arrivalRangeSlider.layoutIfNeeded()
        }
        addDaysSeparatorInArrivalRangeSlider()
        hideShowOvernightView()
        resetAvoidOvernightBtn()
    }
    
    //MARK:- Departure feature methods
    fileprivate func setDepartureLabelAttributedString() {
//        let attributes =   [NSAttributedString.Key.font :UIFont(name: "SourceSansPro-Semibold", size: 14.0)! , NSAttributedString.Key.foregroundColor : UIColor.ONE_FIVE_THREE_COLOR]
        let attributes =   [NSAttributedString.Key.font :AppFonts.SemiBold.withSize(14) , NSAttributedString.Key.foregroundColor : UIColor.ONE_FIVE_THREE_COLOR]

        let departureTime  = NSMutableAttributedString(string: "Departure Time " , attributes: attributes)
        
        if viewModel.multiLegTimerFilter.count > 1 {
            departureTime.append(viewModel.currentTimerFilter.leg.descriptionOneFiveThree)
        }
        departureTimeLabel.attributedText = departureTime
    }
    
    fileprivate func setDepartureLabel(){
        let numberOfStops = viewModel.multiLegTimerFilter.count
        if numberOfStops > 3 {
//            setDepartureLabelAttributedString()
            sectorNameLbl.isHidden = false
            sectorNameLbl.attributedText = viewModel.currentTimerFilter.leg.descriptionTextForSectorHeader
        } else {
            sectorNameLbl.isHidden = true
            departureTimeLabel.text = "Departure Time"
        }
    }
    
    fileprivate func setDepartureSliderValues() {
        viewModel.setDepartureSliderValues()
        updateDepartureUIValues()
    }
    
    fileprivate func initialSetupDepartureRangeSlider() {
        
        departureRangeSlider.addTarget(self, action: #selector(departureRangeChanged), for: .valueChanged)
        departureRangeSlider.addTarget(self, action: #selector(departurnRangeUpdated), for: .touchUpInside)
        departureRangeSlider.createMarkersAt(positions: [0.25 , 0.5 , 0.75] )
        
        if viewModel.currentTimerFilter != nil{
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
        
        
        let startDateTime = Calendar.current.startOfDay(for: viewModel.currentTimerFilter.departureMinTime)
        let minTimeInterval = viewModel.currentTimerFilter.departureMinTime.timeIntervalSince(startDateTime)
        let maxTimeInterval = viewModel.currentTimerFilter.departureTimeMax.timeIntervalSince(startDateTime)

        let startTime = TimeInterval(3600 * floor(minTimeInterval / 3600))

        let endTime = 3600 * TimeInterval(ceil(maxTimeInterval  / 3600 ))
        
        
        if startTime > TimeInterval.sixAM {
//            earlyMorningButton.isEnabled = false
            earlyMorningButton.alpha = 0.6
        }
        
        if startTime > TimeInterval.twelvePM {
            noonButton.alpha = 0.6
        }
        
        if startTime > TimeInterval.sixPM {
            eveningButton.alpha = 0.6
        }
        
        if endTime < TimeInterval.sixPM {
            lateEveningButton.alpha = 0.6
        }
        
        if endTime < TimeInterval.twelvePM {
            eveningButton.alpha = 0.6
        }
        
        if endTime < TimeInterval.sixAM {
            noonButton.alpha = 0.6
        }

        if let gesture = panGesture {
            departureButtonStackView.removeGestureRecognizer(gesture)
        }
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(sender:)))
        departureButtonStackView.isUserInteractionEnabled = true
        departureButtonStackView.addGestureRecognizer(panGesture!)
    }
        
    @objc private func handlePan(sender: UIPanGestureRecognizer) {
        
        guard let senderView = sender.view else { return }
        
        let location = sender.location(in: senderView)
        
        if locationOutOfRange(senderView: senderView, location: location) {
            return
        }
        
        if let startPos = viewModel.panStartPos {
            highlightButtonsInRange(mainRectView: senderView, startPos: startPos, curPos: location.x)
        }
        
        if sender.state == .began {
            viewModel.panStartPos = location.x
        }
        
        if sender.state == .changed {
            
            let calendar = Calendar.current
            let startTime = calendar.startOfDay(for: viewModel.currentTimerFilter.departureMinTime)
            let minDeparture = viewModel.currentTimerFilter.departureMinTime.timeIntervalSince(startTime)
            let roundedMinDeparture = TimeInterval(3600.0 * floor((minDeparture  / 3600 )))
            let maxDeparture =  viewModel.currentTimerFilter.departureTimeMax.timeIntervalSince(startTime)
            let roundedMaxDeparture = TimeInterval(3600 * ceil(maxDeparture  / 3600 ))
            
            let width = senderView.frame.width
            let partWidth = width/4.0
            
            let panStartPositionInNumber = (viewModel.panStartPos ?? 0) / partWidth
            
            if location.x < (viewModel.panStartPos ?? 0) {
                let curPosInNumber = floor(location.x / partWidth)
                viewModel.handleLeftSidePan(maxPosNumber: ceil(panStartPositionInNumber), roundedMinDeparture: roundedMinDeparture, roundedMaxDeparture: roundedMaxDeparture, curPosNumber: curPosInNumber)
                
            } else {
                let curPosInNumber = ceil(location.x / partWidth)
                viewModel.handleRightSidePan(minPosNumber: floor(panStartPositionInNumber), roundedMinDeparture: roundedMinDeparture, roundedMaxDeparture: roundedMaxDeparture, curPosNumber: curPosInNumber)
            }
            UIView.animate(withDuration: 0.3) {
                self.updateDepartureUIValues()
                self.view.layoutIfNeeded()
            }
        }
        
        if sender.state == .ended || sender.state == .cancelled {
            checkToShowMsg()
            viewModel.delegate?.departureSelectionChangedAt(viewModel.currentActiveIndex , minDuration: viewModel.departureStartTimeInterval , maxDuration: viewModel.departureEndTimeInterval)
            self.buttonReleased(sender: UIButton())
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: viewModel.currentTimerFilter.departureMinTime)
            viewModel.currentTimerFilter.userSelectedStartTime = startOfDay.addingTimeInterval(viewModel.departureStartTimeInterval)
            viewModel.currentTimerFilter.userSelectedEndTime = startOfDay.addingTimeInterval(viewModel.departureEndTimeInterval)
            viewModel.multiLegTimerFilter[viewModel.currentActiveIndex] = viewModel.currentTimerFilter
            updateSegmentTitles()
        }
    }
    
    private func locationOutOfRange(senderView: UIView, location: CGPoint) -> Bool {
        
        var leftFrameToExclude: CGRect = .zero
        var rightFrameToExclude: CGRect = .zero
        
        let startDateTime = Calendar.current.startOfDay(for: viewModel.currentTimerFilter.departureMinTime)
        let minTimeInterval = viewModel.currentTimerFilter.departureMinTime.timeIntervalSince(startDateTime)
        let maxTimeInterval = viewModel.currentTimerFilter.departureTimeMax.timeIntervalSince(startDateTime)
        
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
                    if !highlightedBtnArr.contains(button) {
                        giveHapticFeedback()
                        highlightedBtnArr.insert(button)
                    }
                    button.backgroundColor = UIColor(displayP3Red: 236.0/255.0 , green:253.0/255.0 , blue:244.0/255.0 , alpha:1)
                } else {
                    highlightedBtnArr.remove(button)
                    button.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
                }
            }
        }
    }
    
    private func checkToShowMsg() {
        let calendar = Calendar.current
        let startTime = calendar.startOfDay(for: viewModel.currentTimerFilter.departureMinTime)
        let minDeparture = viewModel.currentTimerFilter.departureMinTime.timeIntervalSince(startTime)
        let roundedMinDeparture = TimeInterval(3600.0 * floor((minDeparture  / 3600 )))
        let maxDeparture =  viewModel.currentTimerFilter.departureTimeMax.timeIntervalSince(startTime)
        let roundedMaxDeparture = TimeInterval(3600 * ceil(maxDeparture  / 3600 ))
        
        if roundedMinDeparture >= viewModel.departureStartTimeInterval || roundedMaxDeparture <= viewModel.departureEndTimeInterval {
            let availableMinTime = TimeInterval(3600 * floor(roundedMinDeparture / 3600))
            let availabelMaxTime = TimeInterval(3600 * ceil(roundedMaxDeparture / 3600))
            
            let curSelectedMinTime = TimeInterval( floor(viewModel.departureStartTimeInterval / 3600))
            let curSelectedMaxTime = TimeInterval( ceil(viewModel.departureEndTimeInterval / 3600))
            
            
            if (curSelectedMinTime == 0 || curSelectedMinTime == 6 || curSelectedMinTime == 12 || curSelectedMinTime == 18) && (curSelectedMaxTime == 6 || curSelectedMaxTime == 12 || curSelectedMaxTime == 18 || curSelectedMaxTime == 24) {
                return
            }

            let message = "Flights are available between " +  stringFromTimeInterval(interval: availableMinTime) + " and " + stringFromTimeInterval(interval: availabelMaxTime)
            showToastMessageForAvailableDepartureRange(message)
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
        
        let startTimeInHour = startTime/3600
        let endTimeInHour = endTime/3600
        
        if (startTimeInHour.truncatingRemainder(dividingBy: 6) == 0 && startTimeInHour != 0) || (endTimeInHour.truncatingRemainder(dividingBy: 6) == 0 && endTimeInHour != 24) {
            if !viewModel.isHapticFeedbackProvided {
                giveHapticFeedback()
            }
            viewModel.isHapticFeedbackProvided = true
        } else {
            viewModel.isHapticFeedbackProvided = false
        }
    }
    
    fileprivate func updateDepartureUIValues() {
        
        let leftValue = viewModel.departureStartTimeInterval / 86400.0
        let rightValue = viewModel.departureEndTimeInterval / 86400.0
        
        departureRangeSlider.set(leftValue: CGFloat(leftValue) , rightValue: CGFloat( rightValue) )
        departureStartTime.text = stringFromTimeInterval(interval: viewModel.departureStartTimeInterval)
        departureEndTime.text = stringFromTimeInterval(interval: viewModel.departureEndTimeInterval)
        setDepartureLabel()
    }
    
    func showToastMessageForAvailableDepartureRange(_ message : String) {
        
        onToastInitiation?(message)
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
        
        let startDateTime = Calendar.current.startOfDay(for: viewModel.currentTimerFilter.departureMinTime)
        let minTimeInterval = viewModel.currentTimerFilter.departureMinTime.timeIntervalSince(startDateTime)
        let maxTimeInterval = viewModel.currentTimerFilter.departureTimeMax.timeIntervalSince(startDateTime)

        let startTime = TimeInterval(3600 * floor(minTimeInterval / 3600))
        viewModel.departureStartTimeInterval = TimeInterval(3600 * floor(leftValue / 3600))
        
        let endTime = 3600 * TimeInterval(ceil(maxTimeInterval  / 3600 ))
        viewModel.departureEndTimeInterval = TimeInterval(3600 * floor(rightValue / 3600))

        // MAX and MIN checks
        if leftValue < startTime {
            viewModel.departureStartTimeInterval = TimeInterval(startTime)
            showMessage = true
        }
        
        if leftValue >= endTime {
            let maxValForDeparture = (endTime/3600) - 2
            viewModel.departureStartTimeInterval = TimeInterval(maxValForDeparture * 3600)
        }

        if rightValue > endTime {
            viewModel.departureEndTimeInterval = TimeInterval(endTime)
            showMessage = true
        }
        
        if rightValue <= startTime {
            let minValForDeparture = (startTime/3600) + 2
            viewModel.departureEndTimeInterval = TimeInterval(minValForDeparture * 3600)
        }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: viewModel.currentTimerFilter.departureMinTime)
        viewModel.currentTimerFilter.userSelectedStartTime = startOfDay.addingTimeInterval(viewModel.departureStartTimeInterval)
        viewModel.currentTimerFilter.userSelectedEndTime = startOfDay.addingTimeInterval(viewModel.departureEndTimeInterval)
        
        updateDepartureUIValues()
        if showMessage {
            
            let availableMinTime = TimeInterval(3600 * floor(minTimeInterval / 3600))
            let availabelMaxTime = TimeInterval(3600 * ceil(maxTimeInterval / 3600))
            
            message = "Flights are available between " +  stringFromTimeInterval(interval: availableMinTime) + " and " + stringFromTimeInterval(interval: availabelMaxTime)
            showToastMessageForAvailableDepartureRange(message)
//            return
        }
        
        viewModel.multiLegTimerFilter[viewModel.currentActiveIndex] = viewModel.currentTimerFilter
        updateSegmentTitles()
        viewModel.delegate?.departureSelectionChangedAt(viewModel.currentActiveIndex , minDuration: viewModel.departureStartTimeInterval , maxDuration: viewModel.departureEndTimeInterval)
    }
    
    
    @IBAction func departureSelectedByRangeButtons(_ sender: UIButton) {
        
        guard sender.alpha == 1 else {
            let message = "Flights are available between " +  stringFromTimeInterval(interval: viewModel.departureStartTimeInterval) + " and " + stringFromTimeInterval(interval: viewModel.departureEndTimeInterval)
            showToastMessageForAvailableDepartureRange(message)
            return
        }
        
        let buttonTag = sender.tag
        var message = String()
        var showMessage = false
        let calendar = Calendar.current
        let startTime = calendar.startOfDay(for: viewModel.currentTimerFilter.departureMinTime)
        let minDeparture = viewModel.currentTimerFilter.departureMinTime.timeIntervalSince(startTime)
        let roundedMinDeparture = TimeInterval(3600.0 * floor((minDeparture  / 3600 )))
        let maxDeparture =  viewModel.currentTimerFilter.departureTimeMax.timeIntervalSince(startTime)
        let roundedMaxDeparture = TimeInterval(3600 * ceil(maxDeparture  / 3600 ))
        
        switch buttonTag {
        case 1 :
            
            if roundedMinDeparture > TimeInterval.startOfDay {
                viewModel.departureStartTimeInterval = roundedMinDeparture
                showMessage = true
            }
            else {
                viewModel.departureStartTimeInterval = TimeInterval.startOfDay
            }
            if roundedMaxDeparture < TimeInterval.sixAM  {
                viewModel.departureEndTimeInterval = roundedMaxDeparture
                showMessage = true
            }
            else {
                viewModel.departureEndTimeInterval = TimeInterval.sixAM
            }
            
            
        case 2 :
            
            if roundedMinDeparture > TimeInterval.sixAM {
                viewModel.departureStartTimeInterval = roundedMinDeparture
                showMessage = true
            }
            else {
                viewModel.departureStartTimeInterval = TimeInterval.sixAM
            }
            if roundedMaxDeparture < TimeInterval.twelvePM {
                viewModel.departureEndTimeInterval = roundedMaxDeparture
                showMessage = true
            }
            else {
                viewModel.departureEndTimeInterval = TimeInterval.twelvePM
            }
        case 3 :
            if roundedMinDeparture > TimeInterval.twelvePM {
                viewModel.departureStartTimeInterval = roundedMinDeparture
                showMessage = true
            }
            else {
                viewModel.departureStartTimeInterval = TimeInterval.twelvePM
            }
            if roundedMaxDeparture < TimeInterval.sixPM {
                viewModel.departureEndTimeInterval = roundedMaxDeparture
                showMessage = true
            }
            else {
                viewModel.departureEndTimeInterval = TimeInterval.sixPM
            }
            
        case 4 :
            
            if roundedMinDeparture > TimeInterval.sixPM {
                viewModel.departureStartTimeInterval = roundedMinDeparture
                showMessage = true
            }
            else {
                viewModel.departureStartTimeInterval = TimeInterval.sixPM
            }
            
            if roundedMaxDeparture < TimeInterval.endOfDay {
                viewModel.departureEndTimeInterval = roundedMaxDeparture
                showMessage = true
            }
            else {
                viewModel.departureEndTimeInterval = TimeInterval.endOfDay
            }
        default:
            printDebug("unknown state")
        }
        
        
        let startOfDay = calendar.startOfDay(for: viewModel.currentTimerFilter.departureMinTime)
        viewModel.currentTimerFilter.userSelectedStartTime = startOfDay.addingTimeInterval(viewModel.departureStartTimeInterval)
        viewModel.currentTimerFilter.userSelectedEndTime = startOfDay.addingTimeInterval(viewModel.departureEndTimeInterval)

        updateDepartureUIValues()
        if showMessage {
            
            message = "Flights are available between " +  stringFromTimeInterval(interval: minDeparture) + " and " + stringFromTimeInterval(interval: maxDeparture)
            showToastMessageForAvailableDepartureRange(message)
        }
        
        viewModel.multiLegTimerFilter[viewModel.currentActiveIndex] = viewModel.currentTimerFilter
        updateSegmentTitles()
        viewModel.delegate?.departureSelectionChangedAt(viewModel.currentActiveIndex , minDuration: viewModel.departureStartTimeInterval , maxDuration: viewModel.departureEndTimeInterval)
        
        giveHapticFeedback()
        
    }
    
    @IBAction func avoidOvernightBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        toggleAvoidOvernight(sender.isSelected)
        updateSegmentTitles()
    }
    
    private func toggleAvoidOvernight(_ selected: Bool) {
        viewModel.toggleAvoidOvernight(selected)
        resetAvoidOvernightBtn()
        
    }
    
    private func resetAvoidOvernightBtn() {
        avoidOvernightBtn.isSelected = viewModel.currentTimerFilter.qualityFilter.isSelected
        if viewModel.currentTimerFilter.qualityFilter.isSelected {
            avoidOvernightImgView.image = UIImage(named: "CheckedGreenRadioButton")
        }
        else {
            avoidOvernightImgView.image = UIImage(named: "UncheckedGreenRadioButton")
        }
    }
    
    private func hideShowOvernightView() {
        if viewModel.isIntMCOrReturnVC {
            if viewModel.enableOvernightFlightQualityFilter.indices.contains(0) {
                avoidOvernightView.isHidden = !viewModel.enableOvernightFlightQualityFilter[0]
            }
        } else {
            if viewModel.enableOvernightFlightQualityFilter.indices.contains(viewModel.currentActiveIndex) {
                avoidOvernightView.isHidden = !viewModel.enableOvernightFlightQualityFilter[viewModel.currentActiveIndex]
            }
        }
    }
    
    //MARK:- Multi Leg Feature
    
    
    private func setupMultiLegSegmentControl() {
                
        multiLegSegmentControl.removeAllSegments()
        
        let numberOfStops = viewModel.multiLegTimerFilter.count

        for  index in 1...numberOfStops  {
            let segmentTitle = viewModel.getSegmentTitleFor(index)
            multiLegSegmentControl.insertSegment(withTitle: segmentTitle, at: index-1, animated: false)
        }
        
        multiLegSegmentControl.selectedSegmentIndex = viewModel.currentActiveIndex
                
        if multiLegSegmentControl.superview == nil && numberOfStops > 1 {
            let font: [NSAttributedString.Key : Any] = [.font : AppFonts.SemiBold.withSize(14)]
            multiLegSegmentControl.setTitleTextAttributes(font, for: .normal)
            multiLegSegmentControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
            multiSegmentView.addSubview(multiLegSegmentControl)
            multiLegSegmentControl.snp.makeConstraints { (maker) in
                maker.width.equalToSuperview()
                maker.height.equalToSuperview()
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
            }
        }
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        
        guard viewModel.currentActiveIndex != sender.selectedSegmentIndex else { return }
        viewModel.multiLegTimerFilter[viewModel.currentActiveIndex] = viewModel.currentTimerFilter
        viewModel.currentActiveIndex = sender.selectedSegmentIndex
        viewModel.currentTimerFilter = viewModel.multiLegTimerFilter[viewModel.currentActiveIndex]
        if viewModel.currentTimerFilter != nil {
            setDepartureSliderValues()
        }
        setDepartureLabel()
        if viewModel.currentTimerFilter != nil{
            setArrivalSliderValues(userSelected: true)
        }
        setupDeparatureRangeButtons()
        addDaysSeparatorInArrivalRangeSlider()
        hideShowOvernightView()
        resetAvoidOvernightBtn()
        updateSegmentTitles()
        noTimesView.isHidden = viewModel.currentTimerFilter.isAvailable
    }
    
    private func updateSegmentTitles() {
        for index in 0..<multiLegSegmentControl.numberOfSegments {
            let segmentTitle = viewModel.getSegmentTitleFor(index + 1)
            multiLegSegmentControl.setTitle(segmentTitle, forSegmentAt: index)
        }
    }
    
    
    //MARK:- Arrival feature methods
    fileprivate func setArrivalSliderValues(userSelected:Bool ) {
        
        if userSelected {
            viewModel.arrivalInputStartDate = viewModel.currentTimerFilter.userSelectedArrivalStartTime
            viewModel.arrivalInputEndDate = viewModel.currentTimerFilter.userSelectedArrivalEndTime
        } else {
            viewModel.arrivalInputStartDate = viewModel.currentTimerFilter.arrivalStartTime
            viewModel.arrivalInputEndDate = viewModel.currentTimerFilter.arrivalEndTime
        }
        
        let diff = viewModel.currentTimerFilter.arrivalEndTime.timeIntervalSince(viewModel.currentTimerFilter.arrivalStartTime)
        
        self.viewModel.arivalDifferenceInSeconds = diff == 0 ? 1 : diff
            
        let startTimeInterval = viewModel.arrivalInputStartDate.timeIntervalSince(viewModel.currentTimerFilter.arrivalStartTime)
        let endTimeInterval = viewModel.arrivalInputEndDate.timeIntervalSince(viewModel.currentTimerFilter.arrivalStartTime)
       
        var startPosition = startTimeInterval / Double(viewModel.arivalDifferenceInSeconds)
        var endPosition = endTimeInterval / Double(viewModel.arivalDifferenceInSeconds)
        
        // MARK: For out of range values
        startPosition = startPosition < 0 ? 0 : startPosition
        endPosition = endPosition > 1 ? 1 : endPosition
                
        arrivalRangeSlider.set(leftValue: CGFloat(startPosition), rightValue: CGFloat(endPosition))
        
        arrivalStartTime.text = dateStringFromTime(date: viewModel.arrivalInputStartDate)
        arrivalStartTimeWidth.constant = arrivalStartTime.intrinsicContentSize.width + 16.0
        
        arrivalEndTime.text = dateStringFromTime(date: viewModel.arrivalInputEndDate)
        arrivalEndTimeWidth.constant = arrivalEndTime.intrinsicContentSize.width + 16.0
        
    }
    
    fileprivate func setupArrivalRangeSlider() {
      
        
        arrivalRangeSlider.addTarget(self, action: #selector(arrivalRangeChanged), for: .valueChanged)
        arrivalRangeSlider.addTarget(self, action: #selector(arrivalRangeUpdated), for: .touchUpInside)
        if viewModel.currentTimerFilter != nil{
            setArrivalSliderValues(userSelected: true)
        }
        addDaysSeparatorInArrivalRangeSlider()

    }
    
    func addDaysSeparatorInArrivalRangeSlider(){
        let startOfInputStartDay = Calendar.current.startOfDay(for: viewModel.arrivalInputStartDate)
        let startOfInputEndDay = Calendar.current.startOfDay(for: viewModel.arrivalInputEndDate)
        let diffFromStartOfDay = viewModel.arrivalInputStartDate.timeIntervalSince(startOfInputStartDay)
        let timeDifference = CGFloat(viewModel.arrivalInputEndDate.timeIntervalSince(viewModel.arrivalInputStartDate))

        guard let numberOfDays = Calendar.current.dateComponents( [.day] , from: startOfInputStartDay, to: startOfInputEndDay).day else {
            assertionFailure("Failed to get numberOfDays")
            return
        }
        
        var positions = [CGFloat]()
        if numberOfDays > 0 {
            for i in 1...numberOfDays {
                let nextDayMidNight =  CGFloat(i * 86400) - CGFloat(diffFromStartOfDay)
                let x = nextDayMidNight / timeDifference
                positions.append(x)
            }
        }
        arrivalRangeSlider.createMarkersAt(positions: positions)
    }
    
    func daySeparatorView() -> UIView {
        
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 3 ))
        separatorView.backgroundColor  = UIColor.black.withAlphaComponent(0.4)
        return separatorView
    }
    
    func getArrivalDates() -> (Date , Date) {
        let leftValue =  arrivalRangeSlider.leftValue
        let rightValue = arrivalRangeSlider.rightValue
      
        let timeDifference = viewModel.currentTimerFilter.arrivalEndTime.timeIntervalSince(viewModel.currentTimerFilter.arrivalStartTime)
        
        var startTime = (TimeInterval(leftValue) * timeDifference)
        
        startTime =   (floor(startTime / 3600 ) ) * 3600
        
        let addingDateInStart = viewModel.currentTimerFilter.arrivalStartTime.addingTimeInterval(startTime)
        
        var endTime = (TimeInterval(rightValue) * timeDifference)
        
        endTime = (ceil(endTime / 3600 ) ) * 3600

        let addingDateInEnd = viewModel.currentTimerFilter.arrivalStartTime.addingTimeInterval(endTime)

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
            if !viewModel.isHapticFeedbackProvided {
                giveHapticFeedback()
                viewModel.isHapticFeedbackProvided = true
            }
        } else {
            viewModel.isHapticFeedbackProvided = false
        }
    }
        
    @objc fileprivate func arrivalRangeUpdated() {
        let (startDate , endDate) = getArrivalDates()
        viewModel.currentTimerFilter.userSelectedArrivalStartTime = startDate
        viewModel.currentTimerFilter.userSelectedArrivalEndTime = endDate
        viewModel.multiLegTimerFilter[viewModel.currentActiveIndex] = viewModel.currentTimerFilter
        updateSegmentTitles()
        viewModel.delegate?.arrivalSelectionChangedAt(viewModel.currentActiveIndex, minDate: startDate, maxDate: endDate)
    }

    //MARK:- Date, time conversion methods
    fileprivate func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    
    fileprivate func dateFromTime(interval : TimeInterval) -> Date {
        
        var currentTimeInterval = viewModel.arrivalInputStartDate.timeIntervalSince1970
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
        
        noTimesLbl.text = LocalizedString.filterNotAvailable.localized
        noTimesLbl.font = AppFonts.Regular.withSize(16)
        noTimesLbl.textColor = AppColors.themeGray40
       
        flightTimesScrollView.delegate = self
        
        allSectorsLbl.isHidden = !viewModel.isIntMCOrReturnVC
                
        if viewModel.multiLegTimerFilter.count == 1 {
            multiLegViewHeight.constant = 0
            multiLegView.isHidden = true
        } else {
            multiLegViewHeight.constant = 50
            multiLegView.isHidden = false
            updateSegmentTitles()
        }
        
        if viewModel.multiLegTimerFilter.count > 0 {
            viewModel.currentTimerFilter = viewModel.multiLegTimerFilter[0]
        }

        earlyMorningButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        earlyMorningButton.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        
        noonButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        noonButton.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        
        eveningButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        eveningButton.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        
        lateEveningButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        lateEveningButton.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        
        initialSetupDepartureRangeSlider()
        setDepartureLabel()
        
        guard viewModel.currentTimerFilter != nil else { return }
        setupDeparatureRangeButtons()
        setupArrivalRangeSlider()
        setupOvernightFlightsView()
    }
    
    
    private func setupOvernightFlightsView() {
        avoidOvernightTitleLbl.font = AppFonts.Regular.withSize(18)
        avoidOvernightDescLbl.font = AppFonts.Regular.withSize(14)
        avoidOvernightDescLbl.textColor = AppColors.themeGray60
        allSectorsLbl.font = AppFonts.Regular.withSize(14)
        allSectorsLbl.textColor = AppColors.themeGray40
    }
    
    @objc func buttonPressed(sender:UIButton)
    {
        if sender.alpha != 1 {
            let startDateTime = Calendar.current.startOfDay(for: viewModel.currentTimerFilter.departureMinTime)
            let minTimeInterval = viewModel.currentTimerFilter.departureMinTime.timeIntervalSince(startDateTime)
            let maxTimeInterval = viewModel.currentTimerFilter.departureTimeMax.timeIntervalSince(startDateTime)
            let message = "Flights are available between " +  stringFromTimeInterval(interval: minTimeInterval) + " and " + stringFromTimeInterval(interval: maxTimeInterval)
            showToastMessageForAvailableDepartureRange(message)
            return
        }
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
            printDebug("unknown state")
        }
        
        departureSelectedByRangeButtons(sender)
    }
    
    @objc func buttonReleased(sender:UIButton)
    {
        DispatchQueue.delay(0.1) {
            self.earlyMorningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            self.noonButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            self.eveningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
            self.lateEveningButton.backgroundColor = UIColor(displayP3Red: 246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha:1)
        }
    }
        
    func setUIValues(){
        
        resetAvoidOvernightBtn()
        
          let calendar = Calendar.current
          let startOfDay = calendar.startOfDay(for: viewModel.currentTimerFilter.departureMinTime)
          let startTime = viewModel.currentTimerFilter.departureMinTime.timeIntervalSince(startOfDay)
        
          let roundedMinDeparture = 3600.0 * floor(startTime / 3600.0)
          
        viewModel.departureStartTimeInterval = roundedMinDeparture
          
          let endTime = viewModel.currentTimerFilter.departureTimeMax.timeIntervalSince(startOfDay)
        viewModel.departureEndTimeInterval = 3600.0 * ceil(endTime / 3600.0)
          updateDepartureUIValues()
          
          
        if viewModel.currentTimerFilter != nil {
            setArrivalSliderValues(userSelected: false)
        }
          
        if viewModel.multiLegTimerFilter.count == 1 {
              multiLegViewHeight.constant = 0   
              multiLegView.isHidden = true
          }
          else {
              multiLegViewHeight.constant = 50
              multiLegView.isHidden = false
              updateSegmentTitles()
          }
    }
    
    func updateUIPostLatestResults() {
        guard departureRangeSlider != nil else { return }
        setUIValues()
        
    }

    func resetFilter() {
        
        viewModel.multiLegTimerFilter = viewModel.multiLegTimerFilter.map {
            var newFilter = $0
            newFilter.resetFilter()
            return newFilter
        }
        
        viewModel.currentTimerFilter.resetFilter()
        guard departureRangeSlider != nil else { return }
        setUIValues()
        
        
    }
    
    private func giveHapticFeedback() {
        //*******************Haptic Feedback code********************
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.selectionChanged()
        //*******************Haptic Feedback code********************
    }
}

extension FlightFilterTimesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        buttonReleased(sender: UIButton())
    }
}

