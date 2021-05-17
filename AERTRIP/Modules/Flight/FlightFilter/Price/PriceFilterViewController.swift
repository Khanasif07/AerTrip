//
//  PriceFilterViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit
import SnapKit

class PriceFilterViewController: UIViewController , FilterViewController {
    //MARK:- State Properties
    
    private var multiLegSegmentControl = UISegmentedControl()
    let viewModel = PriceFilterVM()

    //MARK:- Outlets
    @IBOutlet weak var multiLegView: UIView!
    @IBOutlet weak var multiSegmentView: UIView!
    @IBOutlet weak var priceRangeSlider: AertripRangeSlider!
    @IBOutlet weak var multicityViewHeight: NSLayoutConstraint!
    @IBOutlet weak var JourneyTitle: UILabel!
    @IBOutlet weak var fareMinValView: UIView!
    @IBOutlet weak var fareMinValue: UILabel!
    @IBOutlet weak var fareMaxValView: UIView!
    @IBOutlet weak var fareMaxValue: UILabel!
    @IBOutlet weak var refundableFaresButton: UIButton!
    @IBOutlet weak var refundableFaresOnlyLabel: UILabel!
    @IBOutlet weak var refundableFaresTopBtn: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    
    //MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        setupPriceSlider()
        setupPriceLabels()
        
        refundableFaresOnlyLabel.isHidden = true

        checkRefundableFlights(index: 0)
        
        priceRangeSlider.addTarget(self, action: #selector(priceRangeChanged), for: .valueChanged)
        priceRangeSlider.addTarget(self, action: #selector(priceRangeUpdated), for: .touchUpInside)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAttributedTitles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        fareMinValView.roundedCorners(cornerRadius: fareMinValView.height/2)
        fareMaxValView.roundedCorners(cornerRadius: fareMaxValView.height/2)
    }

    //MARK:- Additional UI Methods
    
    func updateFiltersFromAPI() {
        viewModel.currentPriceFilter = viewModel.allPriceFilters[viewModel.currentActiveIndex]
        initSetupForMLSubViews()
        refundableFaresButton.isSelected = viewModel.currentPriceFilter.onlyRefundableFaresSelected
        guard priceRangeSlider != nil else { return }
        UIView.animate(withDuration: 0.3) {
            self.setupPriceSlider()
            self.setupPriceLabels()
            self.priceRangeSlider.layoutIfNeeded()
        }
        
        checkRefundableFlights(index: viewModel.currentActiveIndex)
    }
    
    func initialSetup () {
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(segmentLongPressed(_:)))
        multiLegSegmentControl.addGestureRecognizer(longGesture)
        
        initSetupForMLSubViews()
        
        viewModel.currentPriceFilter.userSelectedFareMinValue = viewModel.currentPriceFilter.inputFareMinValue
        viewModel.currentPriceFilter.userSelectedFareMaxValue = viewModel.currentPriceFilter.inputFareMaxVaule
       
    }
    
    private func initSetupForMLSubViews() {
        if viewModel.isInternational {
            multicityViewHeight.constant = 0
            multiLegView.isHidden = true
            return
        }
        switch  viewModel.allPriceFilters.count {
        case 1:
            multicityViewHeight.constant = 0
            multiLegView.isHidden = true
        case 2:
            multiLegView.isHidden = false
            JourneyTitle.isHidden = true
            multicityViewHeight.constant = 60.0
            setupMultiLegSegmentControl()
        case 3:
            multiLegView.isHidden = false
            multicityViewHeight.constant = 60.0
            setupMultiLegSegmentControl()
            JourneyTitle.attributedText = viewModel.legsArray[viewModel.currentActiveIndex].descriptionTextForSectorHeader
        case 4 , 5 :
            multiLegView.isHidden = false
            multicityViewHeight.constant = 90.0
            setupMultiLegSegmentControl()
            JourneyTitle.isHidden = false
            JourneyTitle.attributedText = viewModel.legsArray[viewModel.currentActiveIndex].descriptionTextForSectorHeader
        default:
            multicityViewHeight.constant = 90.0
            setupMultiLegSegmentControl()
            multiLegView.isHidden = false
            JourneyTitle.isHidden = false
            JourneyTitle.attributedText = viewModel.legsArray[viewModel.currentActiveIndex].descriptionTextForSectorHeader
        }
    }
    
    private func setupMultiLegSegmentControl() {
                
        multiLegSegmentControl.removeAllSegments()
        
        let numberOfStops = viewModel.allPriceFilters.count

        for  index in 1...numberOfStops  {
            let segmentTitle = getSegmentTitleFor(index)
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
        
        viewModel.allPriceFilters[viewModel.currentActiveIndex] = viewModel.currentPriceFilter
        viewModel.currentActiveIndex = sender.selectedSegmentIndex
        viewModel.currentPriceFilter = viewModel.allPriceFilters[viewModel.currentActiveIndex]
        JourneyTitle.attributedText = viewModel.legsArray[viewModel.currentActiveIndex].descriptionOneFiveThree
        
        checkRefundableFlights(index: sender.selectedSegmentIndex)
        setupPriceSlider()
        setupPriceLabels()
        updateSegmentTitles()
    }
    
    private func getSegmentTitleFor(_ index: Int) -> String {
        let currentFilter = viewModel.allPriceFilters[(index - 1)]
        let isFilterApplied = currentFilter.filterApplied()
        var title = "\(viewModel.legsArray[index - 1].origin) \u{279E} \(viewModel.legsArray[index - 1].destination)"
        if viewModel.allPriceFilters.count > 3 {
            title = "\(index)"
        }
        if viewModel.isReturnFlight {
            if index == 1 {
                title = LocalizedString.Onwards.localized
            } else {
                title = LocalizedString.Return.localized
            }
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
        self.setAttributedTitles()
        delay(seconds: 0.002) {
            self.setAttributedTitles()
        }
    }
    
    @objc private func segmentLongPressed(_ gestureRecognizer: UILongPressGestureRecognizer) {
        self.setAttributedTitles()
    }
    
    private func setAttributedTitles() {
        multiLegSegmentControl.subviews.forEach({ (subView) in
            if let label = subView.subviews.first as? UILabel, let text = label.text, !text.isEmpty {
                let mutableStr = NSMutableAttributedString(string: text, attributes: [.font: AppFonts.SemiBold.withSize(14)])
                let rangeOfDot = (mutableStr.string as NSString).range(of: "•")
                mutableStr.setAttributes([.font: AppFonts.SemiBold.withSize(14), .foregroundColor: AppColors.themeGreen], range: rangeOfDot)
                label.attributedText = mutableStr
            }
        })
    }
    
    fileprivate func setupPriceSlider() {
        
        priceRangeSlider.set(leftValue: (viewModel.currentPriceFilter.userSelectedFareMinValue - viewModel.currentPriceFilter.inputFareMinValue)/viewModel.priceDiffForFraction, rightValue: (viewModel.currentPriceFilter.userSelectedFareMaxValue - viewModel.currentPriceFilter.inputFareMinValue)/viewModel.priceDiffForFraction)
        
    }

    fileprivate func setupPriceLabels() {
        
        fareMinValue.attributedText = attributedStringForPrice(price: viewModel.currentPriceFilter.userSelectedFareMinValue, currency: "₹")
        fareMaxValue.attributedText = attributedStringForPrice(price: viewModel.currentPriceFilter.userSelectedFareMaxValue, currency: "₹")
    }

    
    
    
    fileprivate func attributedStringForPrice(price: CGFloat , currency: String)  -> NSAttributedString? {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale.init(identifier: "en_IN")
        guard let currencyString = formatter.string(from: NSNumber(value: Double(price))) else { return nil }
        
        
        let formattedString =  currencyString
        let attributedString = NSMutableAttributedString(string: formattedString, attributes: [
//            .font: UIFont(name: "SourceSansPro-Regular", size: 18.0)!,
            .font: AppFonts.Regular.withSize(18),
            .foregroundColor: UIColor.black,
            .kern: 0.0
        ])
        
        attributedString.addAttribute(.font, value: AppFonts.Regular.withSize(14), range:NSRange(location: 0, length: 1))
        //            attributedString.addAttribute(.font, value: UIFont(name: "SourceSansPro-Regular", size: 14.0)!, range:NSRange(location: distance, length: 1))
        return attributedString
    }
    
    func setupUI() {
        
        viewModel.currentPriceFilter = viewModel.allPriceFilters[viewModel.currentActiveIndex]
        
        priceRangeSlider.set(leftValue: (viewModel.currentPriceFilter.userSelectedFareMinValue - viewModel.currentPriceFilter.inputFareMinValue)/viewModel.priceDiffForFraction, rightValue: (viewModel.currentPriceFilter.userSelectedFareMaxValue - viewModel.currentPriceFilter.inputFareMinValue)/viewModel.priceDiffForFraction)
        
        setupPriceLabels()
        refundableFaresButton.isSelected = false
        
        initSetupForMLSubViews()
        
//        switch  allPriceFilters.count {
//        case 1:
//            multicityViewHeight.constant = 0
//            multiLegView.isHidden = true
//        case 2:
//            JourneyTitle.isHidden = true
//            multicityViewHeight.constant = 60.0
//            setupMultiLegSegmentControl()
//        case 3:
//            multiLegView.isHidden = false
//            multicityViewHeight.constant = 60.0
//            setupMultiLegSegmentControl()
//            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
//        case 4 , 5 :
//            multiLegView.isHidden = false
//            multicityViewHeight.constant = 90.0
//            setupMultiLegSegmentControl()
//            JourneyTitle.isHidden = false
//            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
//        default:
//            multicityViewHeight.constant = 90.0
//            setupMultiLegSegmentControl()
//            multiLegView.isHidden = false
//            JourneyTitle.isHidden = false
//            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
//        }
        
    }
    
    func updateUIPostLatestResults() {
        setupUI()
    }
    
    func resetFilter() {
        guard priceRangeSlider != nil else { return }
        let priceFilters = viewModel.allPriceFilters.map { (priceFilter) -> PriceFilter in
            var newPriceFilter = priceFilter
            newPriceFilter.resetFilter()
            return newPriceFilter
        }
        viewModel.allPriceFilters = priceFilters
        setupUI()
    }
 
    //MARK:- IBAction Methods
    @objc fileprivate func priceRangeChanged() {
        
        viewModel.currentPriceFilter.userSelectedFareMinValue = ((priceRangeSlider.leftValue * viewModel.priceDiffForFraction) + viewModel.currentPriceFilter.inputFareMinValue).rounded(.down)
        viewModel.currentPriceFilter.userSelectedFareMaxValue = ((priceRangeSlider.rightValue * viewModel.priceDiffForFraction) + viewModel.currentPriceFilter.inputFareMinValue).rounded(.up)
        
        setupPriceLabels()
    }
    
    @objc fileprivate func priceRangeUpdated() {
        
        viewModel.currentPriceFilter.userSelectedFareMinValue = ((priceRangeSlider.leftValue * viewModel.priceDiffForFraction) + viewModel.currentPriceFilter.inputFareMinValue).rounded(.down)
        viewModel.currentPriceFilter.userSelectedFareMaxValue = ((priceRangeSlider.rightValue * viewModel.priceDiffForFraction) + viewModel.currentPriceFilter.inputFareMinValue).rounded(.up)
        
        viewModel.allPriceFilters[viewModel.currentActiveIndex] = viewModel.currentPriceFilter
        updateSegmentTitles()
        viewModel.delegate?.priceSelectionChangedAt(viewModel.currentActiveIndex , minFare: viewModel.currentPriceFilter.userSelectedFareMinValue, maxFare: viewModel.currentPriceFilter.userSelectedFareMaxValue)
    }
    
    @IBAction func refundableFaresTopBtnAction(_ sender: UIButton) {
        onlyRefundableFareSelected(refundableFaresButton)
    }
    
    @IBAction func onlyRefundableFareSelected(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            viewModel.currentPriceFilter.onlyRefundableFaresSelected = false
        }
        else {
            sender.isSelected = true
            viewModel.currentPriceFilter.onlyRefundableFaresSelected = true
        }
        
        viewModel.allPriceFilters[viewModel.currentActiveIndex] = viewModel.currentPriceFilter
        updateSegmentTitles()
        viewModel.delegate?.onlyRefundableFares(selected: viewModel.currentPriceFilter.onlyRefundableFaresSelected, index:  viewModel.currentActiveIndex)
    }
    
    
    func checkRefundableFlights(index:Int){
        if viewModel.isInternational{
            if viewModel.intFlightResultArray.count > 0{
                 var isRefundable = true
                let journey = viewModel.intFlightResultArray[0].j

                var refundableCount = 0
                
                 for j in journey{
//                     if j.smartIconArray.contains("refundStatusPending") || j.smartIconArray.contains("noRefund") {
//                    if j.smartIconArray.contains("noRefund") {
//                         isRefundable = false
//                     }
                    if !j.rfdPlcy.rfd.values.contains(0) {
                        refundableCount += 1
                    }
                 }
                
                if refundableCount == journey.count {
                    isRefundable = false
                }
                 
                 if isRefundable{
                     seperatorView.isHidden = false
                     refundableFaresOnlyLabel.isHidden = false
                     refundableFaresButton.isHidden = false
                     refundableFaresButton.isUserInteractionEnabled = true
                 }else{
                     seperatorView.isHidden = true
                     refundableFaresOnlyLabel.isHidden = true
                     refundableFaresButton.isHidden = true
                     refundableFaresButton.isUserInteractionEnabled = false
                 }
             }
         } else {
            if viewModel.flightResultArray.count > 0{
                 var isRefundable = true
                let journey = viewModel.flightResultArray[index].j
                var refundableCount = 0
                
                 for j in journey{
//                    if j.smartIconArray.contains("refundStatusPending") || j.smartIconArray.contains("noRefund") {
//                        if j.smartIconArray.contains("noRefund") {
//                         isRefundable = false
//                     }
                    if !j.rfdPlcy.rfd.values.contains(0) {
                        refundableCount += 1
                    }
                 }
                
                if refundableCount == journey.count {
                    isRefundable = false
                }
                 
                 if isRefundable{
                     seperatorView.isHidden = false
                     refundableFaresOnlyLabel.isHidden = false
                     refundableFaresButton.isHidden = false
                     refundableFaresButton.isUserInteractionEnabled = true
                 }else{
                     seperatorView.isHidden = true
                     refundableFaresOnlyLabel.isHidden = true
                     refundableFaresButton.isHidden = true
                     refundableFaresButton.isUserInteractionEnabled = false
                 }
             }
         }
        refundableFaresButton.isSelected = viewModel.currentPriceFilter.onlyRefundableFaresSelected
     }
}
