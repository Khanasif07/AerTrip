//
//  FlightDurationFilterViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class FlightDurationFilterViewController : UIViewController , FilterViewController {
    
    //MARK:- State Properties
    
    let viewModel = FlightDurationFilterVM()
    
    private var multiLegSegmentControl = GreenDotSegmentControl()
    
    //MARK:- multiLeg Outlets
    @IBOutlet weak var multiLegViewHeight: NSLayoutConstraint!
    @IBOutlet weak var multiLegView: UIView!
    @IBOutlet weak var multiLegSegmentView: UIView!
    @IBOutlet weak var sectorNameLbl: UILabel!
    @IBOutlet weak var avoidOvernightView: UIView!
    @IBOutlet weak var avoidOvernightTitleLbl: UILabel!
    @IBOutlet weak var allSectorsLbl: UILabel!
    @IBOutlet weak var avoidOvernightDescLbl: UILabel!
    @IBOutlet weak var avoidOvernightImgView: UIImageView!
    @IBOutlet weak var avoidOvernightBtn: UIButton!
    @IBOutlet weak var backScrollView: UIScrollView!
    @IBOutlet weak var tripDurationTitleLabel: UILabel!
    @IBOutlet weak var layoverDurationTitleLabel: UILabel!
    

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
    @IBOutlet weak var layoverDurationSlider: AertripRangeSlider!
    @IBOutlet weak var multicityViewHeight: NSLayoutConstraint!
    
    
    //MARK:- Initializers
    convenience init(delegate : FlightDurationFilterDelegate, durationFilters : [DurationFilter]) {
        self.init(nibName:nil, bundle:nil)
        self.viewModel.delegate = delegate
        self.viewModel.durationFilters = durationFilters
        self.viewModel.currentDurationFilter = viewModel.durationFilters[0]
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.viewModel.currentDurationFilter = DurationFilter(leg : Leg(origin: "", destination: "") , tripMin: 0.0, tripMax: 0.0, layoverMin: 0.0 , layoverMax: 0.0, layoverMinTimeFormat:"")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel.currentDurationFilter = DurationFilter(leg : Leg(origin: "", destination: "") , tripMin: 0.0, tripMax: 0.0 , layoverMin: 0.0 , layoverMax: 0.0, layoverMinTimeFormat:"")
        super.init(coder: aDecoder)
        
    }
    
    //MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if viewModel.durationFilters.count == 1 || viewModel.durationFilters.count == 0 {
            multicityViewHeight.constant = 0.0
            multiLegView.isHidden = true
        }
        else {
            multicityViewHeight.constant = 50.0
            multiLegView.isHidden = false
            setupMultiLegSegmentControl()
        }
                
        initialSetup()
        addMarkersOnTripDuration()
        setUColors()
    }
    
    
    func setUColors(){
        self.view.backgroundColor = AppColors.themeWhiteDashboard
        
        
        
//        self.backScrollView.backgroundColor = AppColors.themeWhiteDashboard
    }
    
    private func addMarkersOnTripDuration() {
        tripDurationSlider.createMarkersAt(positions: viewModel.getTripDurationMarkerLocations())
    }
    
    private func addMarkersOnLayoverDuration() {
        tripDurationSlider.createMarkersAt(positions: viewModel.getLayoverDurationMarkerLocations())
    }
    
    //MARK:- Additional methods
    
    func initialSetup() {
        
        allSectorsLbl.isHidden = !viewModel.isIntMCOrReturnVC
        viewModel.setInitialValues()
        setupTripDurationValues()
        setupLayoutDurationValues()
        setupOvernightFlightsView()
        
    }
    
    private func setupOvernightFlightsView() {
        avoidOvernightTitleLbl.font = AppFonts.Regular.withSize(18)
        avoidOvernightDescLbl.font = AppFonts.Regular.withSize(14)
        avoidOvernightDescLbl.textColor = AppColors.themeGray60
        allSectorsLbl.font = AppFonts.Regular.withSize(14)
        allSectorsLbl.textColor = AppColors.themeGray40
    }
    
    func updateFiltersFromAPI() {
        viewModel.setCurrentFilter()
        if viewModel.durationFilters.count == 1 || viewModel.durationFilters.count == 0 {
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
        hideShowOvernightView()
        resetAvoidOvernightBtn()
    }
    
    func updateUIPostLatestResults() {
        resetFilter()
    }
    
    func resetFilter() {
        
        viewModel.durationFilters = viewModel.durationFilters.map {
            var newFilter = $0
            newFilter.resetFilter()
            return newFilter
        }
        viewModel.currentDurationFilter.resetFilter()
        
        guard tripDurationSlider != nil else { return }
        tripDurationSlider.set(leftValue: (viewModel.currentDurationFilter.tripDurationMinDuration - viewModel.currentDurationFilter.tripDurationMinDuration)/viewModel.tripDurationDiffForFraction, rightValue: (viewModel.currentDurationFilter.tripDurationmaxDuration - viewModel.currentDurationFilter.tripDurationMinDuration)/viewModel.tripDurationDiffForFraction)
        
        tripDurationMinLabel.text = formattedStringWith(duration: viewModel.currentDurationFilter.tripDurationMinDuration)
        tripDurationMinLabelWidth.constant = tripDurationMinLabel.intrinsicContentSize.width + 16.0
        
        tripDurationMaxLabel.text = formattedStringWith(duration: viewModel.currentDurationFilter.tripDurationmaxDuration)
        tripDurationMaxLabelWidth.constant = tripDurationMaxLabel.intrinsicContentSize.width + 16.0
        
        layoverDurationSlider.set(leftValue: (viewModel.currentDurationFilter.layoverMinDuration - viewModel.currentDurationFilter.layoverMinDuration)/viewModel.layoverDurationDiffForFraction, rightValue: (viewModel.currentDurationFilter.layoverMaxDuration - viewModel.currentDurationFilter.layoverMinDuration)/viewModel.layoverDurationDiffForFraction)
        layoverDurationMinLabel.text = formattedStringWith(duration: viewModel.currentDurationFilter.layoverMinDuration)
        layoverDurationMinLabelWidth.constant = layoverDurationMinLabel.intrinsicContentSize.width + 16.0
        layoverDurationMaxLabel.text = formattedStringWith(duration: viewModel.currentDurationFilter.layoverMaxDuration)
        layoverDurationMaxLabelWidth.constant = layoverDurationMaxLabel.intrinsicContentSize.width + 16.0
        
        updateSegmentTitles()
        resetAvoidOvernightBtn()
    }
    
    
    private func setupMultiLegSegmentControl() {
                
        multiLegSegmentControl.removeAllSegments()
        
        let numberOfStops = viewModel.durationFilters.count
        
        if numberOfStops > 3 {
            sectorNameLbl.isHidden = false
            sectorNameLbl.attributedText = viewModel.currentDurationFilter.leg.descriptionTextForSectorHeader
        } else {
            sectorNameLbl.isHidden = true
        }

        for  index in 1...numberOfStops  {
            let segmentTitle = getSegmentTitleFor(index)
            multiLegSegmentControl.insertSegment(withTitle: segmentTitle, at: index-1, animated: false)
        }
        
        multiLegSegmentControl.selectedSegmentIndex = viewModel.currentActiveIndex
                
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
        
        guard viewModel.currentActiveIndex != sender.selectedSegmentIndex else { return }
        
        viewModel.durationFilters[viewModel.currentActiveIndex] = viewModel.currentDurationFilter
        viewModel.currentActiveIndex = sender.selectedSegmentIndex
        viewModel.setCurrentFilter()
        setupTripDurationValues()
        setupLayoutDurationValues()
        updateSegmentTitles()
        addMarkersOnLayoverDuration()
        addMarkersOnTripDuration()
        hideShowOvernightView()
        resetAvoidOvernightBtn()
        sectorNameLbl.attributedText = viewModel.currentDurationFilter.leg.descriptionTextForSectorHeader
    }
    
    private func getSegmentTitleFor(_ index: Int) -> String {
        let currentFilter = viewModel.durationFilters[(index - 1)]
        let isFilterApplied = currentFilter.filterApplied()
        var title = "\(viewModel.legsArray[index - 1].origin) \u{279E} \(viewModel.legsArray[index - 1].destination)"
        if viewModel.durationFilters.count > 3 {
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
        tripDurationSlider.set(leftValue: (viewModel.currentDurationFilter.userSelectedTripMin - viewModel.currentDurationFilter.tripDurationMinDuration)/viewModel.tripDurationDiffForFraction, rightValue: (viewModel.currentDurationFilter.userSelectedTripMax - viewModel.currentDurationFilter.tripDurationMinDuration)/viewModel.tripDurationDiffForFraction)
        
        tripDurationMinLabel.text = formattedStringWith(duration:  viewModel.currentDurationFilter.userSelectedTripMin)
        tripDurationMinLabelWidth.constant = tripDurationMinLabel.intrinsicContentSize.width + 16.0
        tripDurationMaxLabel.text = formattedStringWith(duration:  viewModel.currentDurationFilter.userSelectedTripMax)
        tripDurationMaxLabelWidth.constant = tripDurationMaxLabel.intrinsicContentSize.width + 16.0
        
    }
    
    fileprivate func setupLayoutDurationValues() {
        layoverDurationSlider.set(leftValue: (viewModel.currentDurationFilter.userSelectedLayoverMin - viewModel.currentDurationFilter.layoverMinDuration)/viewModel.layoverDurationDiffForFraction, rightValue: (viewModel.currentDurationFilter.userSelectedLayoverMax - viewModel.currentDurationFilter.layoverMinDuration)/viewModel.layoverDurationDiffForFraction)
        
        layoverDurationMinLabel.text = formattedStringWith(duration:  viewModel.currentDurationFilter.userSelectedLayoverMin)
        layoverDurationMinLabelWidth.constant = layoverDurationMinLabel.intrinsicContentSize.width + 16.0
        
        layoverDurationMaxLabel.text = formattedStringWith(duration:  viewModel.currentDurationFilter.userSelectedLayoverMax)
        layoverDurationMaxLabelWidth.constant = layoverDurationMaxLabel.intrinsicContentSize.width + 16.0
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func tripDurationChanged(_ sender: AertripRangeSlider) {
        
        viewModel.currentDurationFilter.userSelectedTripMin = ((tripDurationSlider.leftValue * viewModel.tripDurationDiffForFraction) + viewModel.currentDurationFilter.tripDurationMinDuration).rounded(.down)
        viewModel.currentDurationFilter.userSelectedTripMax = ((tripDurationSlider.rightValue * viewModel.tripDurationDiffForFraction) + viewModel.currentDurationFilter.tripDurationMinDuration).rounded(.up)
        
        if (((viewModel.currentDurationFilter.userSelectedTripMin.truncatingRemainder(dividingBy: 24) == 0) && viewModel.currentDurationFilter.userSelectedTripMin != viewModel.currentDurationFilter.tripDurationMinDuration)) || ((viewModel.currentDurationFilter.userSelectedTripMax.truncatingRemainder(dividingBy: 24) == 0) && viewModel.currentDurationFilter.userSelectedTripMax != viewModel.currentDurationFilter.tripDurationmaxDuration) {
            if !viewModel.isFeedBackProvided {
               generateHapticFeedback()
            }
            viewModel.isFeedBackProvided = true
        } else {
            viewModel.isFeedBackProvided = false
        }
        
        tripDurationMinLabel.text = formattedStringWith(duration:  viewModel.currentDurationFilter.userSelectedTripMin)
        tripDurationMinLabelWidth.constant = tripDurationMinLabel.intrinsicContentSize.width + 16.0
        
        tripDurationMaxLabel.text = formattedStringWith(duration:  viewModel.currentDurationFilter.userSelectedTripMax)
        tripDurationMaxLabelWidth.constant = tripDurationMaxLabel.intrinsicContentSize.width + 16.0
        
    }
    
    
    @IBAction func tripDurationUpdated(_ sender: AertripRangeSlider) {
        
        viewModel.currentDurationFilter.userSelectedTripMin = floor((tripDurationSlider.leftValue * viewModel.tripDurationDiffForFraction) + viewModel.currentDurationFilter.tripDurationMinDuration)
        viewModel.currentDurationFilter.userSelectedTripMax = ceil((tripDurationSlider.rightValue * viewModel.tripDurationDiffForFraction) + viewModel.currentDurationFilter.tripDurationMinDuration)
        viewModel.durationFilters[viewModel.currentActiveIndex] = viewModel.currentDurationFilter
        updateSegmentTitles()
        
        if viewModel.showingForReturnJourney {
            viewModel.delegate?.tripDurationChangedAt(0, min:  viewModel.currentDurationFilter.userSelectedTripMin, max:  viewModel.currentDurationFilter.userSelectedTripMax)
            viewModel.delegate?.tripDurationChangedAt(1, min:  viewModel.currentDurationFilter.userSelectedTripMin, max:  viewModel.currentDurationFilter.userSelectedTripMax)
        }
        else {
            viewModel.delegate?.tripDurationChangedAt(viewModel.currentActiveIndex, min:  viewModel.currentDurationFilter.userSelectedTripMin, max:  viewModel.currentDurationFilter.userSelectedTripMax)
        }
    }
    
    @IBAction func layoverDurationChanged(_ sender: MARKRangeSlider) {
        
        viewModel.currentDurationFilter.userSelectedLayoverMin = ((layoverDurationSlider.leftValue * viewModel.layoverDurationDiffForFraction) + viewModel.currentDurationFilter.layoverMinDuration).rounded(.down)
        viewModel.currentDurationFilter.userSelectedLayoverMax = ((layoverDurationSlider.rightValue * viewModel.layoverDurationDiffForFraction) + viewModel.currentDurationFilter.layoverMinDuration).rounded(.up)
        
        layoverDurationMinLabel.text = formattedStringWith(duration:  viewModel.currentDurationFilter.userSelectedLayoverMin)
        layoverDurationMinLabelWidth.constant = layoverDurationMinLabel.intrinsicContentSize.width + 16.0
        
        layoverDurationMaxLabel.text = formattedStringWith(duration:  viewModel.currentDurationFilter.userSelectedLayoverMax)
        
        
        if (((viewModel.currentDurationFilter.userSelectedLayoverMin.truncatingRemainder(dividingBy: 24) == 0) && viewModel.currentDurationFilter.userSelectedLayoverMin != viewModel.currentDurationFilter.layoverMinDuration) || (viewModel.currentDurationFilter.userSelectedLayoverMax.truncatingRemainder(dividingBy: 24) == 0) && viewModel.currentDurationFilter.userSelectedLayoverMax != viewModel.currentDurationFilter.layoverMaxDuration) {
            if !viewModel.isFeedBackProvided {
               generateHapticFeedback()
            }
            viewModel.isFeedBackProvided = true
        } else {
            viewModel.isFeedBackProvided = false
        }
        
    }
    
    @IBAction func layoverDurationUpdated(_ sender: MARKRangeSlider) {
        
        viewModel.currentDurationFilter.userSelectedLayoverMin = ((layoverDurationSlider.leftValue * viewModel.layoverDurationDiffForFraction) + viewModel.currentDurationFilter.layoverMinDuration).rounded(.down)
        viewModel.currentDurationFilter.userSelectedLayoverMax = ((layoverDurationSlider.rightValue * viewModel.layoverDurationDiffForFraction) + viewModel.currentDurationFilter.layoverMinDuration).rounded(.up)
        viewModel.durationFilters[viewModel.currentActiveIndex] = viewModel.currentDurationFilter
        
        if viewModel.showingForReturnJourney {
            viewModel.delegate?.layoverDurationChangedAt(0 ,min:  viewModel.currentDurationFilter.userSelectedLayoverMin, max:  viewModel.currentDurationFilter.userSelectedLayoverMax)
            viewModel.delegate?.layoverDurationChangedAt(1 ,min:  viewModel.currentDurationFilter.userSelectedLayoverMin, max:  viewModel.currentDurationFilter.userSelectedLayoverMax)
        }
        else {
            viewModel.delegate?.layoverDurationChangedAt(viewModel.currentActiveIndex ,min:  viewModel.currentDurationFilter.userSelectedLayoverMin, max:  viewModel.currentDurationFilter.userSelectedLayoverMax)
        }
    }
    
    @IBAction func avoidOvernightBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        toggleAvoidOvernight(sender.isSelected)
        updateSegmentTitles()
    }
    
    private func toggleAvoidOvernight(_ selected: Bool) {
        viewModel.currentDurationFilter.qualityFilter.isSelected = selected
        viewModel.durationFilters[viewModel.currentActiveIndex] = viewModel.currentDurationFilter
        
        if viewModel.isIntMCOrReturnVC {
            viewModel.durationFilters = viewModel.durationFilters.map {
                var newFilter = $0
                newFilter.qualityFilter = viewModel.currentDurationFilter.qualityFilter
                return newFilter
            }
        }
        
        if viewModel.showingForReturnJourney {
            viewModel.qualityFilterDelegate?.qualityFiltersChanged(viewModel.currentDurationFilter.qualityFilter)
        } else {
            viewModel.qualityFilterDelegate?.qualityFilterChangedAt(viewModel.currentActiveIndex, filter: viewModel.currentDurationFilter.qualityFilter)
        }
        resetAvoidOvernightBtn()
        
    }
    
    private func resetAvoidOvernightBtn() {
        avoidOvernightBtn.isSelected = viewModel.currentDurationFilter.qualityFilter.isSelected
        if viewModel.currentDurationFilter.qualityFilter.isSelected {
            avoidOvernightImgView.image = AppImages.CheckedGreenRadioButton
        }
        else {
            avoidOvernightImgView.image = AppImages.UncheckedGreenRadioButton
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
    
    private func generateHapticFeedback() {
        //*******************Haptic Feedback code********************
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.selectionChanged()
        //*******************Haptic Feedback code********************
    }
    
    class MarkerView: UIView { }
}
