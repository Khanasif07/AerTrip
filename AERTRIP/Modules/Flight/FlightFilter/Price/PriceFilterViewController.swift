//
//  PriceFilterViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit
import SnapKit

protocol  PriceFilterDelegate : FilterDelegate {
    func priceSelectionChangedAt(_ index : Int , minFare : CGFloat , maxFare : CGFloat )
    func onlyRefundableFares( selected : Bool , index : Int)
}


struct PriceFilter {
    
    var onlyRefundableFaresSelected : Bool = false
    var inputFareMinValue : CGFloat
    var inputFareMaxVaule : CGFloat
    var userSelectedFareMinValue : CGFloat
    var userSelectedFareMaxValue : CGFloat
    
    mutating func resetFilter() {
        onlyRefundableFaresSelected = false
        userSelectedFareMinValue = inputFareMinValue
        userSelectedFareMaxValue = inputFareMaxVaule
    }
    
    func filterApplied()-> Bool {
        
        if onlyRefundableFaresSelected {
            return true
        }
        
        if userSelectedFareMinValue > inputFareMinValue {
            return true
        }
        
        if userSelectedFareMaxValue < inputFareMaxVaule {
            return true
        }
        
        return false
    }
}

class PriceFilterViewController: UIViewController , FilterViewController {
    //MARK:- State Properties
    weak var delegate : PriceFilterDelegate?
    var currentActiveIndex : Int = 0
    var allPriceFilters : [PriceFilter]!
    var currentPriceFilter : PriceFilter!
    var legsArray = [Leg]()
    var flightResultArray : [FlightsResults]!
    var intFlightResultArray : [IntMultiCityAndReturnWSResponse.Results]!
    var isInternational = false
    
    private var multiLegSegmentControl = UISegmentedControl()
    
    var priceDiffForFraction: CGFloat {
        let diff = currentPriceFilter.inputFareMaxVaule - currentPriceFilter.inputFareMinValue
        return diff == 0 ? 1 : diff
    }

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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        fareMinValView.roundedCorners(cornerRadius: fareMinValView.height/2)
        fareMaxValView.roundedCorners(cornerRadius: fareMaxValView.height/2)
    }

    //MARK:- Additional UI Methods
    
    func updateFiltersFromAPI() {
        currentPriceFilter = allPriceFilters[currentActiveIndex]
        initSetupForMLSubViews()
        guard priceRangeSlider != nil else { return }
        UIView.animate(withDuration: 0.3) {
            self.setupPriceSlider()
            self.setupPriceLabels()
            self.priceRangeSlider.layoutIfNeeded()
        }
    }
    
    func initialSetup () {
        
        initSetupForMLSubViews()
        
        currentPriceFilter.userSelectedFareMinValue = currentPriceFilter.inputFareMinValue
        currentPriceFilter.userSelectedFareMaxValue = currentPriceFilter.inputFareMaxVaule
       
    }
    
    private func initSetupForMLSubViews() {
        switch  allPriceFilters.count {
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
            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
        case 4 , 5 :
            multiLegView.isHidden = false
            multicityViewHeight.constant = 90.0
            setupMultiLegSegmentControl()
            JourneyTitle.isHidden = false
            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
        default:
            multicityViewHeight.constant = 90.0
            setupMultiLegSegmentControl()
            multiLegView.isHidden = false
            JourneyTitle.isHidden = false
            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
        }
    }
    
    private func setupMultiLegSegmentControl() {
                
        multiLegSegmentControl.removeAllSegments()
        
        let numberOfStops = allPriceFilters.count

        for  index in 1...numberOfStops  {
            let segmentTitle = getSegmentTitleFor(index)
            multiLegSegmentControl.insertSegment(withTitle: segmentTitle, at: index-1, animated: false)
        }
        
        multiLegSegmentControl.selectedSegmentIndex = currentActiveIndex
                
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
        
        guard currentActiveIndex != sender.selectedSegmentIndex else { return }
        
        allPriceFilters[currentActiveIndex] = currentPriceFilter
        currentActiveIndex = sender.selectedSegmentIndex
        currentPriceFilter = allPriceFilters[currentActiveIndex]
        JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
        
        checkRefundableFlights(index: sender.selectedSegmentIndex)
        setupPriceSlider()
        setupPriceLabels()
        updateSegmentTitles()

    }
    
    private func getSegmentTitleFor(_ index: Int) -> String {
        let currentFilter = allPriceFilters[(index - 1)]
        let isFilterApplied = currentFilter.filterApplied()
        var title = "\(legsArray[index - 1].origin) \u{279E} \(legsArray[index - 1].destination)"
        if allPriceFilters.count > 3 {
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
    
    fileprivate func setupPriceSlider() {
        
        priceRangeSlider.set(leftValue: (currentPriceFilter.userSelectedFareMinValue - currentPriceFilter.inputFareMinValue)/priceDiffForFraction, rightValue: (currentPriceFilter.userSelectedFareMaxValue - currentPriceFilter.inputFareMinValue)/priceDiffForFraction)
        
    }

    fileprivate func setupPriceLabels() {
        
        fareMinValue.attributedText = attributedStringForPrice(price: currentPriceFilter.userSelectedFareMinValue, currency: "₹")
        fareMaxValue.attributedText = attributedStringForPrice(price: currentPriceFilter.userSelectedFareMaxValue, currency: "₹")
    }

    
    
    
    fileprivate func attributedStringForPrice(price: CGFloat , currency: String)  -> NSAttributedString? {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale.init(identifier: "en_IN")
        guard let currencyString = formatter.string(from: NSNumber(value: Double(price))) else { return nil }
        
        
        let formattedString =  currencyString
        let attributedString = NSMutableAttributedString(string: formattedString, attributes: [
            .font: UIFont(name: "SourceSansPro-Regular", size: 18.0)!,
            .foregroundColor: UIColor.black,
            .kern: 0.0
        ])
        
        attributedString.addAttribute(.font, value: UIFont(name: "SourceSansPro-Regular", size: 14.0)!, range:NSRange(location: 0, length: 1))
        //            attributedString.addAttribute(.font, value: UIFont(name: "SourceSansPro-Regular", size: 14.0)!, range:NSRange(location: distance, length: 1))
        return attributedString
    }
    
    func setupUI() {
        
        currentPriceFilter = allPriceFilters[currentActiveIndex]
        
        priceRangeSlider.set(leftValue: (currentPriceFilter.userSelectedFareMinValue - currentPriceFilter.inputFareMinValue)/priceDiffForFraction, rightValue: (currentPriceFilter.userSelectedFareMaxValue - currentPriceFilter.inputFareMinValue)/priceDiffForFraction)
        
        setupPriceLabels()
        refundableFaresButton.isSelected = false
        
        switch  allPriceFilters.count {
        case 1:
            multicityViewHeight.constant = 0
            multiLegView.isHidden = true
        case 2:
            JourneyTitle.isHidden = true
            multicityViewHeight.constant = 60.0
            setupMultiLegSegmentControl()
        case 3:
            multiLegView.isHidden = false
            multicityViewHeight.constant = 60.0
            setupMultiLegSegmentControl()
            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
        case 4 , 5 :
            multiLegView.isHidden = false
            multicityViewHeight.constant = 90.0
            setupMultiLegSegmentControl()
            JourneyTitle.isHidden = false
            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
        default:
            multicityViewHeight.constant = 90.0
            setupMultiLegSegmentControl()
            multiLegView.isHidden = false
            JourneyTitle.isHidden = false
            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
        }
        
    }
    
    func updateUIPostLatestResults() {
        setupUI()
    }
    
    func resetFilter() {
        guard priceRangeSlider != nil else { return }
        if let newPriceFilters = allPriceFilters {
            let priceFilters = newPriceFilters.map { (priceFilter) -> PriceFilter in
                var newPriceFilter = priceFilter
                newPriceFilter.resetFilter()
                return newPriceFilter
            }
            allPriceFilters = priceFilters
        }
        setupUI()
    }
 
    //MARK:- IBAction Methods
    @objc fileprivate func priceRangeChanged() {
        
        currentPriceFilter.userSelectedFareMinValue = ((priceRangeSlider.leftValue * priceDiffForFraction) + currentPriceFilter.inputFareMinValue).rounded(.down)
        currentPriceFilter.userSelectedFareMaxValue = ((priceRangeSlider.rightValue * priceDiffForFraction) + currentPriceFilter.inputFareMinValue).rounded(.up)
        
        setupPriceLabels()
    }
    
    @objc fileprivate func priceRangeUpdated() {
        
        currentPriceFilter.userSelectedFareMinValue = ((priceRangeSlider.leftValue * priceDiffForFraction) + currentPriceFilter.inputFareMinValue).rounded(.down)
        currentPriceFilter.userSelectedFareMaxValue = ((priceRangeSlider.rightValue * priceDiffForFraction) + currentPriceFilter.inputFareMinValue).rounded(.up)
        
        allPriceFilters[currentActiveIndex] = currentPriceFilter
        updateSegmentTitles()
        delegate?.priceSelectionChangedAt(currentActiveIndex , minFare: currentPriceFilter.userSelectedFareMinValue, maxFare: currentPriceFilter.userSelectedFareMaxValue)
    }
    
    
    @IBAction func onlyRefundableFareSelected(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            currentPriceFilter.onlyRefundableFaresSelected = false
        }
        else {
            sender.isSelected = true
            currentPriceFilter.onlyRefundableFaresSelected = true
        }
        
        allPriceFilters[currentActiveIndex] = currentPriceFilter
        updateSegmentTitles()
        delegate?.onlyRefundableFares(selected: currentPriceFilter.onlyRefundableFaresSelected, index:  currentActiveIndex)
    }
    
    
    func checkRefundableFlights(index:Int){
         if isInternational{
             if intFlightResultArray.count > 0{
                 var isRefundable = true
                 let journey = intFlightResultArray[0].j
                 for j in journey{
                     if j.smartIconArray.contains("refundStatusPending") || j.smartIconArray.contains("noRefund") {
                         isRefundable = false
                     }
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
             if flightResultArray.count > 0{
                 var isRefundable = true
                 let journey = flightResultArray[index].j
                 for j in journey{
                     if j.smartIconArray.contains("refundStatusPending") || j.smartIconArray.contains("noRefund") {
                         isRefundable = false
                     }
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
     }
}
