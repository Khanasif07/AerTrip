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
        if userSelectedTripMax != tripDurationmaxDuration {
            return true
        }
        
        if userSelectedLayoverMin > layoverMinDuration {
            return true
        }
        
        if layoverMaxDuration != userSelectedLayoverMax {
            return true
        }
        
        return false
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
    @IBOutlet weak var tripDurationSlider: MARKRangeSlider!
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
            setmultiLegSubviews()
        }

        tripDurationSlider.setupThemeImages()
        layoverDurationSlider.setupThemeImages()

        initialSetup()
        
        //Trip Duration Slider
        if tripDurationSlider.maximumValue == 29{
            createMarkersAt(positions: [0.85] , slider: tripDurationSlider)
        }else if tripDurationSlider.maximumValue == 36{
            createMarkersAt(positions: [0.72] , slider: tripDurationSlider)
        }else if tripDurationSlider.maximumValue == 25{
            createMarkersAt(positions: [0.98] , slider: tripDurationSlider)
        }else if tripDurationSlider.maximumValue == 33 || tripDurationSlider.maximumValue == 32 || tripDurationSlider.maximumValue == 31{
            createMarkersAt(positions: [0.78] , slider: tripDurationSlider)
        }else if tripDurationSlider.maximumValue == 26{
            createMarkersAt(positions: [0.98] , slider: tripDurationSlider)
        }else if tripDurationSlider.maximumValue == 42{
            createMarkersAt(positions: [0.72] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 27 || tripDurationSlider.maximumValue == 28) && (tripDurationSlider.minimumValue == 1 || tripDurationSlider.minimumValue == 2) {
            createMarkersAt(positions: [0.90] , slider: tripDurationSlider)
        }else if tripDurationSlider.maximumValue == 40 || tripDurationSlider.maximumValue == 41{
            createMarkersAt(positions: [0.65] , slider: tripDurationSlider)
        }else if tripDurationSlider.maximumValue == 38{
            createMarkersAt(positions: [0.68] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 59 || tripDurationSlider.maximumValue == 60 || tripDurationSlider.maximumValue == 61) && (tripDurationSlider.minimumValue == 17 || tripDurationSlider.minimumValue == 18 || tripDurationSlider.minimumValue == 19){
            createMarkersAt(positions: [0.18, 0.77] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 54 || tripDurationSlider.maximumValue == 55 || tripDurationSlider.maximumValue == 56) && (tripDurationSlider.minimumValue == 16 || tripDurationSlider.minimumValue == 17 || tripDurationSlider.minimumValue == 18){
            createMarkersAt(positions: [0.20, 0.88] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 60 || tripDurationSlider.maximumValue == 61 || tripDurationSlider.maximumValue == 62) && (tripDurationSlider.minimumValue == 22 || tripDurationSlider.minimumValue == 23 || tripDurationSlider.minimumValue == 24){
            createMarkersAt(positions: [0.08, 0.75] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 33 || tripDurationSlider.maximumValue == 34 || tripDurationSlider.maximumValue == 35) && (tripDurationSlider.minimumValue == 29 || tripDurationSlider.minimumValue == 30 || tripDurationSlider.minimumValue == 31){
            createMarkersAt(positions: [0.05, 0.75] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 63 || tripDurationSlider.maximumValue == 64 || tripDurationSlider.maximumValue == 65) && (tripDurationSlider.minimumValue == 22 || tripDurationSlider.minimumValue == 23 || tripDurationSlider.minimumValue == 24){
            createMarkersAt(positions: [0.08, 0.70] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 59 || tripDurationSlider.maximumValue == 60 || tripDurationSlider.maximumValue == 61) && (tripDurationSlider.minimumValue == 18 || tripDurationSlider.minimumValue == 19 || tripDurationSlider.minimumValue == 20){
            createMarkersAt(positions: [0.18, 0.78] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 65 || tripDurationSlider.maximumValue == 66 || tripDurationSlider.maximumValue == 67) && (tripDurationSlider.minimumValue == 19 || tripDurationSlider.minimumValue == 20 || tripDurationSlider.minimumValue == 21){
            createMarkersAt(positions: [0.15, 0.67] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 45 || tripDurationSlider.maximumValue == 46 || tripDurationSlider.maximumValue == 47) && (tripDurationSlider.minimumValue == 18 || tripDurationSlider.minimumValue == 19 || tripDurationSlider.minimumValue == 20){
            createMarkersAt(positions: [0.20] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 54 || tripDurationSlider.maximumValue == 55 || tripDurationSlider.maximumValue == 56) && (tripDurationSlider.minimumValue == 18 || tripDurationSlider.minimumValue == 19 || tripDurationSlider.minimumValue == 20){
            createMarkersAt(positions: [0.20, 0.85] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 63 || tripDurationSlider.maximumValue == 64 || tripDurationSlider.maximumValue == 65) && (tripDurationSlider.minimumValue == 17 || tripDurationSlider.minimumValue == 18 || tripDurationSlider.minimumValue == 18){
            createMarkersAt(positions: [0.18, 0.70] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 59 || tripDurationSlider.maximumValue == 60 || tripDurationSlider.maximumValue == 61) && (tripDurationSlider.minimumValue == 16 || tripDurationSlider.minimumValue == 15 || tripDurationSlider.minimumValue == 14){
            createMarkersAt(positions: [0.22, 0.78] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 45 ||  tripDurationSlider.maximumValue == 46 ||  tripDurationSlider.maximumValue == 47) && (tripDurationSlider.minimumValue == 8 || tripDurationSlider.minimumValue == 9 || tripDurationSlider.minimumValue == 10){
            createMarkersAt(positions: [0.40] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 42 || tripDurationSlider.maximumValue == 43 || tripDurationSlider.maximumValue == 44) && (tripDurationSlider.minimumValue == 12 || tripDurationSlider.minimumValue == 13 || tripDurationSlider.minimumValue == 14){
            createMarkersAt(positions: [0.40] , slider: tripDurationSlider)
        }else if (tripDurationSlider.maximumValue == 55 || tripDurationSlider.maximumValue == 56 || tripDurationSlider.maximumValue == 57) && (tripDurationSlider.minimumValue == 9 || tripDurationSlider.minimumValue == 10 || tripDurationSlider.minimumValue == 11){
            createMarkersAt(positions: [0.33, 0.85], slider: tripDurationSlider )
        }
        
        
        //Layover duration slider
        
        if layoverDurationSlider.maximumValue == 24 && (layoverDurationSlider.minimumValue == 0 || layoverDurationSlider.minimumValue == 1){
            
            let trackWidth = self.view.bounds.width - 16
            let xPosition = 1.0 * trackWidth
            let marker = UIView(frame: CGRect(x: xPosition, y: layoverDurationSlider.frame.height/2 - 2 , width: 3.0, height: 3.0 ))
            marker.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            layoverDurationSlider.addSubview(marker)
            layoverDurationSlider.bringSubviewToFront(layoverDurationSlider.leftThumbView)
            layoverDurationSlider.bringSubviewToFront(layoverDurationSlider.rightThumbView)
            
        }
    }
    
    func createMarkersAt(positions : [CGFloat], slider:MARKRangeSlider)
    {
        for position in positions
        {
            let trackWidth = (self.view.bounds.size.width - 2 * 15)
            let xPosition = position * trackWidth
            let marker = UIView(frame: CGRect(x: xPosition, y: slider.frame.height/2 - 2 , width: 3.0, height: 3.0 ))
            marker.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            slider.addSubview(marker)
            slider.bringSubviewToFront(marker)
            
        }
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
        UIView.animate(withDuration: 0.3) {
            self.setupTripDurationValues()
            self.setupLayoutDurationValues()
        }
    }
    
    func updateUIPostLatestResults() {
       resetFilter()
    }
    
    func resetFilter() {
        
    currentDurationFilter.userSelectedTripMin = currentDurationFilter.tripDurationMinDuration
    currentDurationFilter.userSelectedTripMax = currentDurationFilter.tripDurationmaxDuration

    currentDurationFilter.userSelectedLayoverMin = currentDurationFilter.layoverMinDuration
    currentDurationFilter.userSelectedLayoverMax = currentDurationFilter.layoverMaxDuration

    tripDurationSlider.setLeftValue(currentDurationFilter.tripDurationMinDuration, rightValue: currentDurationFilter.tripDurationmaxDuration)
    tripDurationMinLabel.text = formattedStringWith(duration: currentDurationFilter.tripDurationMinDuration)
        tripDurationMinLabelWidth.constant = tripDurationMinLabel.intrinsicContentSize.width + 16.0
        
    tripDurationMaxLabel.text = formattedStringWith(duration: currentDurationFilter.tripDurationmaxDuration)
        tripDurationMaxLabelWidth.constant = tripDurationMaxLabel.intrinsicContentSize.width + 16.0
    layoverDurationSlider.setLeftValue(currentDurationFilter.layoverMinDuration, rightValue: currentDurationFilter.layoverMaxDuration)
    layoverDurationMinLabel.text = formattedStringWith(duration: currentDurationFilter.layoverMinDuration)
        layoverDurationMinLabelWidth.constant = layoverDurationMinLabel.intrinsicContentSize.width + 16.0
    layoverDurationMaxLabel.text = formattedStringWith(duration: currentDurationFilter.layoverMaxDuration)
        layoverDurationMaxLabelWidth.constant = layoverDurationMaxLabel.intrinsicContentSize.width + 16.0
    
    setmultiLegSubviews()
        
    }
    
    fileprivate func setmultiLegSubviews () {
        
        multiLegSegmentView.subviews.forEach { $0.removeFromSuperview() }
        
        multiLegSegmentView.layer.cornerRadius = 3
        multiLegSegmentView.layer.borderColor = UIColor.AertripColor.cgColor
        multiLegSegmentView.layer.borderWidth = 1.0
        multiLegSegmentView.clipsToBounds = true
        
        let numberOfStops = durationFilters.count
        
        if numberOfStops > 0 {
            for  i in 1...numberOfStops  {
                
                let segmentViewWidth = UIScreen.main.bounds.size.width - 32
                let width = segmentViewWidth / CGFloat(numberOfStops)
                let xcordinate = CGFloat( i - 1 ) * width
                let height = self.multiLegSegmentView.frame.size.height
                var rect = CGRect(x: xcordinate, y: 0, width: width, height: height)
                let stopButton = UIButton(frame: rect)
                stopButton.tag = i
                
                let currentFilter = durationFilters[(i - 1)]
                
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
                    let leg = durationFilters[( i - 1 )].leg
                    normalStateTitle = leg.getTitle(isCurrentlySelected: isCurrentIndexActive, isFilterApplied: isFilterApplied)
                }
                
                stopButton.setAttributedTitle(normalStateTitle, for: .normal)
                stopButton.addTarget(self, action: #selector(tappedOnMulticityButton(sender:)), for: .touchDown)
                stopButton.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 16)
                
                
                
                multiLegSegmentView.addSubview(stopButton)
                
                if i != numberOfStops {
                    rect  = CGRect(x: xcordinate + width - 1 , y: 0, width: 1, height: 30)
                    let verticalSeparator = UIView(frame: rect)
                    verticalSeparator.backgroundColor = UIColor.AertripColor
                    multiLegSegmentView.addSubview(verticalSeparator)
                }
            }
        }
    }
    
    
    fileprivate func formattedStringWith(duration : CGFloat) -> String {
        
        if duration > 1 {
            return  "\(Int(duration))" + " hrs"
        }else {
            return  "\(Int(duration))" + " hr"
        }
    }
    
    fileprivate func setupTripDurationValues() {
       
        tripDurationSlider.setMinValue( currentDurationFilter.tripDurationMinDuration, maxValue:  currentDurationFilter.tripDurationmaxDuration)
        tripDurationSlider.setLeftValue( currentDurationFilter.userSelectedTripMin, rightValue:  currentDurationFilter.userSelectedTripMax)

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
    @IBAction func tripDurationChanged(_ sender: MARKRangeSlider) {
        
         currentDurationFilter.userSelectedTripMin = tripDurationSlider.leftValue.rounded(.down)
         currentDurationFilter.userSelectedTripMax = tripDurationSlider.rightValue.rounded(.up)
        tripDurationMinLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedTripMin)
        tripDurationMinLabelWidth.constant = tripDurationMinLabel.intrinsicContentSize.width + 16.0

        tripDurationMaxLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedTripMax)
        tripDurationMaxLabelWidth.constant = tripDurationMaxLabel.intrinsicContentSize.width + 16.0

    }
    
    
    @IBAction func tripDurationUpdated(_ sender: MARKRangeSlider) {
        
        currentDurationFilter.userSelectedTripMin = floor(tripDurationSlider.leftValue)
        currentDurationFilter.userSelectedTripMax = ceil(tripDurationSlider.rightValue)
        durationFilters[currentActiveIndex] = currentDurationFilter
        setmultiLegSubviews()
        
        if showingForReturnJourney {
            delegate?.tripDurationChangedAt(0, min:  currentDurationFilter.userSelectedTripMin, max:  currentDurationFilter.userSelectedTripMax)
            delegate?.tripDurationChangedAt(1, min:  currentDurationFilter.userSelectedTripMin, max:  currentDurationFilter.userSelectedTripMax)
        }
        else {
            delegate?.tripDurationChangedAt(currentActiveIndex, min:  currentDurationFilter.userSelectedTripMin, max:  currentDurationFilter.userSelectedTripMax)
        }
        
        if currentDurationFilter.userSelectedTripMin == 24.0 || currentDurationFilter.userSelectedTripMax == 24.0 || currentDurationFilter.userSelectedTripMin == 48.0 || currentDurationFilter.userSelectedTripMax == 48.0
        {
            //*******************Haptic Feedback code********************
               let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
               selectionFeedbackGenerator.selectionChanged()
            //*******************Haptic Feedback code********************
        }
    }
    
    

    
    @IBAction func layoverDurationChanged(_ sender: MARKRangeSlider) {
        
             currentDurationFilter.userSelectedLayoverMin = layoverDurationSlider.leftValue.rounded(.down)
        currentDurationFilter.userSelectedLayoverMax = layoverDurationSlider.rightValue.rounded(.up)

            layoverDurationMinLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedLayoverMin)
        layoverDurationMinLabelWidth.constant = layoverDurationMinLabel.intrinsicContentSize.width + 16.0

            layoverDurationMaxLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedLayoverMax)

    }
    
    @IBAction func layoverDurationUpdated(_ sender: MARKRangeSlider) {
        
        currentDurationFilter.userSelectedLayoverMin = floor(layoverDurationSlider.leftValue)
        currentDurationFilter.userSelectedLayoverMax = ceil(layoverDurationSlider.rightValue)
        durationFilters[currentActiveIndex] = currentDurationFilter
        setmultiLegSubviews()
        
        if showingForReturnJourney {
            delegate?.layoverDurationChangedAt(0 ,min:  currentDurationFilter.userSelectedLayoverMin, max:  currentDurationFilter.userSelectedLayoverMax)
            delegate?.layoverDurationChangedAt(1 ,min:  currentDurationFilter.userSelectedLayoverMin, max:  currentDurationFilter.userSelectedLayoverMax)
        }
        else {
            delegate?.layoverDurationChangedAt(currentActiveIndex ,min:  currentDurationFilter.userSelectedLayoverMin, max:  currentDurationFilter.userSelectedLayoverMax)
        }
        
        if currentDurationFilter.userSelectedLayoverMin == 24.0 || currentDurationFilter.userSelectedLayoverMax == 24.0 || currentDurationFilter.userSelectedLayoverMin == 48.0 || currentDurationFilter.userSelectedLayoverMax == 48.0
        {
            //*******************Haptic Feedback code********************
               let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
               selectionFeedbackGenerator.selectionChanged()
            //*******************Haptic Feedback code********************
        }
        
    }
    
    
    
    @IBAction fileprivate func tappedOnMulticityButton( sender : UIButton) {
        
        let tag = sender.tag
        
        if tag == (currentActiveIndex + 1) {
            return
        }
        else {
            
            durationFilters[currentActiveIndex] = currentDurationFilter
            currentActiveIndex = tag - 1
        }
        
        currentDurationFilter = durationFilters[currentActiveIndex]
        setmultiLegSubviews()
        setupTripDurationValues()
        setupLayoutDurationValues()
        
    }

    
}
