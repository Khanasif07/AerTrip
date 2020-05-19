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

    
    init(leg : Leg , tripMin : CGFloat , tripMax : CGFloat , layoverMin : CGFloat , layoverMax : CGFloat) {
        
        self.leg = leg
        tripDurationMinDuration = tripMin
        userSelectedTripMin = tripMin
        tripDurationmaxDuration = tripMax
        userSelectedTripMax = tripMax
        
        layoverMinDuration = layoverMin
        userSelectedLayoverMin = layoverMin
        layoverMaxDuration = layoverMax
        userSelectedLayoverMax = layoverMax
        
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
        self.currentDurationFilter = DurationFilter(leg : Leg(origin: "", destination: "") , tripMin: 0.0, tripMax: 0.0, layoverMin: 0.0 , layoverMax: 0.0)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.currentDurationFilter = DurationFilter(leg : Leg(origin: "", destination: "") , tripMin: 0.0, tripMax: 0.0 , layoverMin: 0.0 , layoverMax: 0.0)
        super.init(coder: aDecoder)
        
    }
    

    //MARK:- Outlets
    @IBOutlet weak var tripDurationMinLabel: UILabel!
    @IBOutlet weak var tripDurationMaxLabel: UILabel!
    @IBOutlet weak var layoverDurationMinLabel: UILabel!
    @IBOutlet weak var layoverDurationMaxLabel: UILabel!
    @IBOutlet weak var tripDurationSlider: MARKRangeSlider!
    @IBOutlet weak var layoverDurationSlider: MARKRangeSlider!
    @IBOutlet weak var multicityViewHeight: NSLayoutConstraint!
    
    
    //MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if durationFilters.count == 1 {
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
    tripDurationMaxLabel.text = formattedStringWith(duration: currentDurationFilter.tripDurationmaxDuration)

    layoverDurationSlider.setLeftValue(currentDurationFilter.layoverMinDuration, rightValue: currentDurationFilter.layoverMaxDuration)
    layoverDurationMinLabel.text = formattedStringWith(duration: currentDurationFilter.layoverMinDuration)
    layoverDurationMaxLabel.text = formattedStringWith(duration: currentDurationFilter.layoverMaxDuration)
    
    setmultiLegSubviews()
        
    }
    
    fileprivate func setmultiLegSubviews () {
        
        multiLegSegmentView.subviews.forEach { $0.removeFromSuperview() }
        
        multiLegSegmentView.layer.cornerRadius = 3
        multiLegSegmentView.layer.borderColor = UIColor.AertripColor.cgColor
        multiLegSegmentView.layer.borderWidth = 1.0
        multiLegSegmentView.clipsToBounds = true
        
        let numberOfStops = durationFilters.count
        
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
        tripDurationMaxLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedTripMax)

        
    }

    fileprivate func setupLayoutDurationValues() {
      
        layoverDurationSlider.setMinValue( currentDurationFilter.layoverMinDuration, maxValue:  currentDurationFilter.layoverMaxDuration)
        layoverDurationSlider.setLeftValue( currentDurationFilter.userSelectedLayoverMin, rightValue:  currentDurationFilter.userSelectedLayoverMax)

        layoverDurationMinLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedLayoverMin)
        layoverDurationMaxLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedLayoverMax)

        
    }
    
    //MARK:- IBAction Methods
    @IBAction func tripDurationChanged(_ sender: MARKRangeSlider) {
        
         currentDurationFilter.userSelectedTripMin = tripDurationSlider.leftValue.rounded(.down)
         currentDurationFilter.userSelectedTripMax = tripDurationSlider.rightValue.rounded(.up)
        tripDurationMinLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedTripMin)
        tripDurationMaxLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedTripMax)
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
        
    }
    
    

    
    @IBAction func layoverDurationChanged(_ sender: MARKRangeSlider) {
        
             currentDurationFilter.userSelectedLayoverMin = layoverDurationSlider.leftValue.rounded(.down)
             currentDurationFilter.userSelectedLayoverMax = layoverDurationSlider.rightValue.rounded()

            layoverDurationMinLabel.text = formattedStringWith(duration:  currentDurationFilter.userSelectedLayoverMin)
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
