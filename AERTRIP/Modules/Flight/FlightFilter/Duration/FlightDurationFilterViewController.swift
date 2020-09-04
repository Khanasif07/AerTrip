//
//  FlightDurationFilterViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


protocol  FlightDurationFilterDelegate : FilterDelegate {
    func tripDurationChangedAt(_ index: Int , min: CGFloat , max : CGFloat)
    func layoverDurationChangedAt(_ index: Int , min: CGFloat , max : CGFloat)
}


struct DurationFilter {
    
    var leg : Leg
    var tripDurationMinDuration : CGFloat  = 0.0
    var tripDurationmaxDuration : CGFloat = CGFloat.greatestFiniteMagnitude
    
    var userSelectedTripMin : CGFloat = 0.0
    var userSelectedTripMax : CGFloat = CGFloat.greatestFiniteMagnitude
    
    var layoverMinDuration : CGFloat = 0.0
    var layoverMaxDuration : CGFloat = CGFloat.greatestFiniteMagnitude
    
    var userSelectedLayoverMin : CGFloat = 0.0
    var userSelectedLayoverMax : CGFloat = CGFloat.greatestFiniteMagnitude
    
    var layoverDurationTimeFormat : String = ""
    
    init(leg : Leg , tripMin : CGFloat , tripMax : CGFloat , layoverMin : CGFloat , layoverMax : CGFloat, layoverMinTimeFormat:String) {
        
        self.leg = leg
        tripDurationMinDuration = tripMin
        userSelectedTripMin = tripMin
        tripDurationmaxDuration = tripMax
        userSelectedTripMax = tripMax
        
        layoverMinDuration = layoverMin
        userSelectedLayoverMin = layoverMin
        layoverMaxDuration = layoverMax
        userSelectedLayoverMax = layoverMax
        layoverDurationTimeFormat = layoverMinTimeFormat
        
    }
    
    func filterApplied() -> Bool {
        
        if userSelectedTripMin > tripDurationMinDuration {
            return true
        }
        if userSelectedTripMax < tripDurationmaxDuration {
            return true
        }
        
        if userSelectedLayoverMin > layoverMinDuration {
            return true
        }
        
        if layoverMaxDuration > userSelectedLayoverMax {
            return true
        }
        
        return false
    }
    
    mutating func resetFilter() {
        self.userSelectedTripMin = self.tripDurationMinDuration
        self.userSelectedTripMax = self.tripDurationmaxDuration
        self.userSelectedLayoverMin = self.layoverMinDuration
        self.userSelectedLayoverMax = self.layoverMaxDuration
    }
}

class FlightDurationFilterViewController : UIViewController , FilterViewController {
    
    //MARK:- State Properties
    weak var delegate : FlightDurationFilterDelegate?
    var currentDurationFilter : DurationFilter
    var durationFilters = [DurationFilter]()
    var legsArray = [Leg]()
    var currentActiveIndex = 0
    var showingForReturnJourney = false
    var isFeedBackProvided = false
    
    var tripDurationDiffForFraction: CGFloat {
        return (currentDurationFilter.tripDurationmaxDuration - currentDurationFilter.tripDurationMinDuration)
    }
    
    private var multiLegSegmentControl = UISegmentedControl()
    
    //MARK:- multiLeg Outlets
    @IBOutlet weak var multiLegViewHeight: NSLayoutConstraint!
    @IBOutlet weak var multiLegView: UIView!
    @IBOutlet weak var multiLegSegmentView: UIView!
    
    //MARK:- Initializers
    convenience init(delegate : FlightDurationFilterDelegate, durationFilters : [DurationFilter]) {
        self.init(nibName:nil, bundle:nil)
        self.delegate = delegate
        self.durationFilters = durationFilters
        self.currentDurationFilter = durationFilters[0]
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.currentDurationFilter = DurationFilter(leg : Leg(origin: "", destination: "") , tripMin: 0.0, tripMax: 0.0, layoverMin: 0.0 , layoverMax: 0.0, layoverMinTimeFormat:"")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.currentDurationFilter = DurationFilter(leg : Leg(origin: "", destination: "") , tripMin: 0.0, tripMax: 0.0 , layoverMin: 0.0 , layoverMax: 0.0, layoverMinTimeFormat:"")
        super.init(coder: aDecoder)
        
    }
    
    
    //MARK:- Outlets
    @IBOutlet weak var tripDurationMinLabel: UILabel!
    @IBOutlet weak var tripDurationMinLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var tripDurationMaxLabel: UILabel!
    @IBOutlet weak var tripDurationMaxLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var layoverDurationMinLabel: UILabel!
    @IBOutlet weak var layoverDurationMinLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var layoverDurationMaxLabel: UILabel!
    @IBOutlet weak var layoverDurationMaxLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var tripDurationSlider: AertripRangeSlider!
    @IBOutlet weak var layoverDurationSlider: MARKRangeSlider!
    @IBOutlet weak var multicityViewHeight: NSLayoutConstraint!
    
    
    //MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if durationFilters.count == 1 || durationFilters.count == 0 {
            multicityViewHeight.constant = 0.0
            multiLegView.isHidden = true
        }
        else {
            multicityViewHeight.constant = 50.0
            multiLegView.isHidden = false
            setupMultiLegSegmentControl()
        }
        
        layoverDurationSlider.setupThemeImages()
        
        initialSetup()
        addMarkersOnTripDuration()
        
        //Layover duration slider
        
        if layoverDurationSlider.maximumValue == 24 && (layoverDurationSlider.minimumValue == 0 || layoverDurationSlider.minimumValue == 1){
            addMarkersOnLayoverDuration()
            layoverDurationSlider.bringSubviewToFront(layoverDurationSlider.leftThumbView)
            layoverDurationSlider.bringSubviewToFront(layoverDurationSlider.rightThumbView)
            
        }
    }
    
    private func addMarkersOnLayoverDuration() {
        layoverDurationSlider.subviews.forEach { (subview) in
            if subview is MarkerView {
                subview.removeFromSuperview()
            }
        }
        let trackWidth = self.view.bounds.width - 16
        let xPosition = 1.0 * trackWidth
        let marker = MarkerView(frame: CGRect(x: xPosition, y: layoverDurationSlider.frame.height/2 - 2 , width: 3.0, height: 3.0 ))
        marker.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        layoverDurationSlider.addSubview(marker)
    }
    
    private func addMarkersOnTripDuration() {
        let minVal = currentDurationFilter.tripDurationMinDuration - currentDurationFilter.tripDurationMinDuration
        let maxVal = currentDurationFilter.tripDurationmaxDuration - currentDurationFilter.tripDurationMinDuration
        let diff = maxVal - minVal
        var markerLocations = [CGFloat]()
        for dayChangeTime in stride(from: 24, through: 240, by: 24) {
            let markLoc = CGFloat(dayChangeTime) - currentDurationFilter.tripDurationMinDuration
            let fraction = markLoc/diff
            guard fraction < 1 else { break }
            markerLocations.append(fraction)
        }
        tripDurationSlider.createMarkersAt(positions: markerLocations)
    }
    
    //MARK:- Additional methods
    
    func initialSetup() {
        
        currentDurationFilter.userSelectedTripMin = currentDurationFilter.tripDurationMinDuration
        currentDurationFilter.userSelectedTripMax = currentDurationFilter.tripDurationmaxDuration
        
        currentDurationFilter.userSelectedLayoverMin = currentDurationFilter.layoverMinDuration
        currentDurationFilter.userSelectedLayoverMax = currentDurationFilter.layoverMaxDuration
        
        setupTripDurationValues()
        setupLayoutDurationValues()
        
    }
    
    
    func updateFiltersFromAPI() {
        currentDurationFilter = durationFilters[currentActiveIndex]
        if durationFilters.count == 1 || durationFilters.count == 0 {
            multicityViewHeight.constant = 0.0
            multiLegView.isHidden = true
        }
        else {
            multicityViewHeight.constant = 50.0
            multiLegView.isHidden = false
            setupMultiLegSegmentControl()
        }
        guard tripDurationSlider != nil else { return }
        addMarkersOnLayoverDuration()
        addMarkersOnTripDuration()
        UIView.animate(withDuration: 0.3) {
            self.setupTripDurationValues()
            self.setupLayoutDurationValues()
        }
    }
    
    func updateUIPostLatestResults() {
        resetFilter()
    }
    
    func resetFilter() {
        
        durationFilters = durationFilters.map {
            var newFilter = $0
            newFilter.resetFilter()
            return newFilter
        }
        currentDurationFilter.resetFilter()
        
        guard tripDurationSlider != nil else { return }
        tripDurationSlider.set(leftValue: (currentDurationFilter.tripDurationMinDuration - currentDurationFilter.tripDurationMinDuration)/tripDurationDiffForFraction, rightValue: (currentDurationFilter.tripDurationmaxDuration - currentDurationFilter.tripDurationMinDuration)/tripDurationDiffForFraction)
        
        tripDurationMinLabel.text = formattedStringWith(duration: currentDurationFilter.tripDurationMinDuration)
        tripDurationMinLabelWidth.constant = tripDurationMinLabel.intrinsicContentSize.width + 16.0
        
        tripDurationMaxLabel.text = formattedStringWith(duration: currentDurationFilter.tripDurationmaxDuration)
        tripDurationMaxLabelWidth.constant = tripDurationMaxLabel.intrinsicContentSize.width + 16.0
        layoverDurationSlider.setLeftValue(currentDurationFilter.layoverMinDuration, rightValue: currentDurationFilter.layoverMaxDuration)
        layoverDurationMinLabel.text = formattedStringWith(duration: currentDurationFilter.layoverMinDuration)
        layoverDurationMinLabelWidth.constant = layoverDurationMinLabel.intrinsicContentSize.width + 16.0
        layoverDurationMaxLabel.text = formattedStringWith(duration: currentDurationFilter.layoverMaxDuration)
        layoverDurationMaxLabelWidth.constant = layoverDurationMaxLabel.intrinsicContentSize.width + 16.0
        
        updateSegmentTitles()
        
    }
    
    
    private func setupMultiLegSegmentControl() {
                
        multiLegSegmentControl.removeAllSegments()
        
        let numberOfStops = durationFilters.count

        for  index in 1...numberOfStops  {
            let segmentTitle = getSegmentTitleFor(index)
            multiLegSegmentControl.insertSegment(withTitle: segmentTitle, at: index-1, animated: false)
        }
        
        multiLegSegmentControl.selectedSegmentIndex = currentActiveIndex
                
        if multiLegSegmentControl.superview == nil && numberOfStops > 1 {
            let font: [NSAttributedString.Key : Any] = [.font : AppFonts.SemiBold.withSize(14)]
            multiLegSegmentControl.setTitleTextAttributes(font, for: .normal)
            multiLegSegmentControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
            multiLegSegmentView.addSubview(multiLegSegmentControl)
            multiLegSegmentControl.snp.makeConstraints { (maker) in
                maker.width.equalToSuperview()
                maker.height.equalToSuperview()
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
            }
        }
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        
        guard currentActiveIndex != sender.selectedSegmentIndex else { return }
        
        durationFilters[currentActiveIndex] = currentDurationFilter
        currentActiveIndex = sender.selectedSegmentIndex
        currentDurationFilter = durationFilters[currentActiveIndex]
//        JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
        setupTripDurationValues()
        setupLayoutDurationValues()
        updateSegmentTitles()
        addMarkersOnLayoverDuration()
        addMarkersOnTripDuration()
    }
    
    private func getSegmentTitleFor(_ index: Int) -> String {
        let currentFilter = durationFilters[(index - 1)]
        let isFilterApplied = currentFilter.filterApplied()
        var title = "\(legsArray[index - 1].origin) \u{2794} \(legsArray[index - 1].destination)"
        if durationFilters.count > 3 {
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
            multiLegSegmentControl.setTitle(segmentTitle, forSegmentAt: index)
        }
    }
    
    fileprivate func formattedStringWith(duration : CGFloat) -> String {
        if duration > 100000 {
            return ""
        }
        if duration > 1 {
            return  "\(Int(duration))" + " hrs"
        }else {
            return  "\(Int(duration))" + " hr"
        }
    }
    
    fileprivate func setupTripDurationValues() {
        tripDurationSlider.set(leftValue: (currentDurationFilter.userSelectedTripMin - currentDurationFilter.tripDurationMinDuration)/tripDurationDiffForFraction, rightValue: (currentDurationFilter.userSelectedTripMax - currentDurationFilter.tripDurationMinDuration)/tripDurationDiffForFraction)
        
        tripDurationMinLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedTripMin)
        tripDurationMinLabelWidth.constant = tripDurationMinLabel.intrinsicContentSize.width + 16.0
        tripDurationMaxLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedTripMax)
        tripDurationMaxLabelWidth.constant = tripDurationMaxLabel.intrinsicContentSize.width + 16.0
        
    }
    
    fileprivate func setupLayoutDurationValues() {
        
        layoverDurationSlider.setMinValue( currentDurationFilter.layoverMinDuration, maxValue:  currentDurationFilter.layoverMaxDuration)
        layoverDurationSlider.setLeftValue( currentDurationFilter.userSelectedLayoverMin, rightValue:  currentDurationFilter.userSelectedLayoverMax)
        
        layoverDurationMinLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedLayoverMin)
        layoverDurationMinLabelWidth.constant = layoverDurationMinLabel.intrinsicContentSize.width + 16.0
        
        layoverDurationMaxLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedLayoverMax)
        layoverDurationMaxLabelWidth.constant = layoverDurationMaxLabel.intrinsicContentSize.width + 16.0
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func tripDurationChanged(_ sender: AertripRangeSlider) {
        
        currentDurationFilter.userSelectedTripMin = ((tripDurationSlider.leftValue * tripDurationDiffForFraction) + currentDurationFilter.tripDurationMinDuration).rounded(.down)
        currentDurationFilter.userSelectedTripMax = ((tripDurationSlider.rightValue * tripDurationDiffForFraction) + currentDurationFilter.tripDurationMinDuration).rounded(.up)
        
        if (((currentDurationFilter.userSelectedTripMin.truncatingRemainder(dividingBy: 24) == 0) && currentDurationFilter.userSelectedTripMin != currentDurationFilter.tripDurationMinDuration)) || ((currentDurationFilter.userSelectedTripMax.truncatingRemainder(dividingBy: 24) == 0) && currentDurationFilter.userSelectedTripMax != currentDurationFilter.tripDurationmaxDuration) {
            if !isFeedBackProvided {
               generateHapticFeedback()
            }
            isFeedBackProvided = true
        } else {
            isFeedBackProvided = false
        }
        
        tripDurationMinLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedTripMin)
        tripDurationMinLabelWidth.constant = tripDurationMinLabel.intrinsicContentSize.width + 16.0
        
        tripDurationMaxLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedTripMax)
        tripDurationMaxLabelWidth.constant = tripDurationMaxLabel.intrinsicContentSize.width + 16.0
        
    }
    
    
    @IBAction func tripDurationUpdated(_ sender: AertripRangeSlider) {
        
        currentDurationFilter.userSelectedTripMin = floor((tripDurationSlider.leftValue * tripDurationDiffForFraction) + currentDurationFilter.tripDurationMinDuration)
        currentDurationFilter.userSelectedTripMax = ceil((tripDurationSlider.rightValue * tripDurationDiffForFraction) + currentDurationFilter.tripDurationMinDuration)
        durationFilters[currentActiveIndex] = currentDurationFilter
        updateSegmentTitles()
        
        if showingForReturnJourney {
            delegate?.tripDurationChangedAt(0, min:  currentDurationFilter.userSelectedTripMin, max:  currentDurationFilter.userSelectedTripMax)
            delegate?.tripDurationChangedAt(1, min:  currentDurationFilter.userSelectedTripMin, max:  currentDurationFilter.userSelectedTripMax)
        }
        else {
            delegate?.tripDurationChangedAt(currentActiveIndex, min:  currentDurationFilter.userSelectedTripMin, max:  currentDurationFilter.userSelectedTripMax)
        }
    }
    
    @IBAction func layoverDurationChanged(_ sender: MARKRangeSlider) {
        
        currentDurationFilter.userSelectedLayoverMin = layoverDurationSlider.leftValue.rounded(.down)
        currentDurationFilter.userSelectedLayoverMax = layoverDurationSlider.rightValue.rounded(.up)
        
        layoverDurationMinLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedLayoverMin)
        layoverDurationMinLabelWidth.constant = layoverDurationMinLabel.intrinsicContentSize.width + 16.0
        
        layoverDurationMaxLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedLayoverMax)
        
        
        if (((currentDurationFilter.userSelectedLayoverMin.truncatingRemainder(dividingBy: 24) == 0) && currentDurationFilter.userSelectedLayoverMin != currentDurationFilter.layoverMinDuration) || (currentDurationFilter.userSelectedLayoverMax.truncatingRemainder(dividingBy: 24) == 0) && currentDurationFilter.userSelectedLayoverMax != currentDurationFilter.layoverMaxDuration) {
            if !isFeedBackProvided {
               generateHapticFeedback()
            }
            isFeedBackProvided = true
        } else {
            isFeedBackProvided = false
        }
        
    }
    
    @IBAction func layoverDurationUpdated(_ sender: MARKRangeSlider) {
        
        currentDurationFilter.userSelectedLayoverMin = floor(layoverDurationSlider.leftValue)
        currentDurationFilter.userSelectedLayoverMax = ceil(layoverDurationSlider.rightValue)
        durationFilters[currentActiveIndex] = currentDurationFilter
        
        if showingForReturnJourney {
            delegate?.layoverDurationChangedAt(0 ,min:  currentDurationFilter.userSelectedLayoverMin, max:  currentDurationFilter.userSelectedLayoverMax)
            delegate?.layoverDurationChangedAt(1 ,min:  currentDurationFilter.userSelectedLayoverMin, max:  currentDurationFilter.userSelectedLayoverMax)
        }
        else {
            delegate?.layoverDurationChangedAt(currentActiveIndex ,min:  currentDurationFilter.userSelectedLayoverMin, max:  currentDurationFilter.userSelectedLayoverMax)
        }
    }
    
    private func generateHapticFeedback() {
        //*******************Haptic Feedback code********************
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.selectionChanged()
        //*******************Haptic Feedback code********************
    }
    
    class MarkerView: UIView { }
}
