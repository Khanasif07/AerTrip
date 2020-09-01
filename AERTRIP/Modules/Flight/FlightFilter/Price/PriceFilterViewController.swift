//
//  PriceFilterViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


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

    //MARK:- Outlets
    @IBOutlet weak var multiLegView: UIView!
    @IBOutlet weak var multiSegmentView: UIView!
    @IBOutlet weak var priceRangeSlider: MARKRangeSlider!
    @IBOutlet weak var multicityViewHeight: NSLayoutConstraint!
    @IBOutlet weak var JourneyTitle: UILabel!
    @IBOutlet weak var fareMinValue: UILabel!
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

    //MARK:- Additional UI Methods
    
    func updateFiltersFromAPI() {
        currentPriceFilter = allPriceFilters[currentActiveIndex]
        initSetupForMLSubViews()
        guard priceRangeSlider != nil else { return }
        UIView.animate(withDuration: 0.3) {
            self.setupPriceSlider()
            self.setupPriceLabels()
            self.view.layoutIfNeeded()
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
            setmultiLegSubviews()
        case 3:
            multiLegView.isHidden = false
            multicityViewHeight.constant = 60.0
            setmultiLegSubviews()
            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
        case 4 , 5 :
            multiLegView.isHidden = false
            multicityViewHeight.constant = 90.0
            setmultiLegSubviews()
            JourneyTitle.isHidden = false
            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
        default:
            multicityViewHeight.constant = 90.0
            setmultiLegSubviews()
            multiLegView.isHidden = false
            JourneyTitle.isHidden = false
            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
        }
    }
    
    fileprivate func setmultiLegSubviews () {
        
        multiSegmentView.subviews.forEach { $0.removeFromSuperview() }
        
        multiSegmentView.layer.cornerRadius = 3
        multiSegmentView.layer.borderColor = UIColor.AertripColor.cgColor
        multiSegmentView.layer.borderWidth = 1.0
        multiSegmentView.clipsToBounds = true
        
        let numberOfStops = allPriceFilters.count
        
        for  i in 1...numberOfStops  {
            
            let segmentViewWidth = UIScreen.main.bounds.size.width - 32
            let width = segmentViewWidth / CGFloat(numberOfStops)
            let xcordinate = CGFloat( i - 1 ) * width
            let height = self.multiSegmentView.frame.size.height
            var rect = CGRect(x: xcordinate, y: 0, width: width, height: height)
            let stopButton = UIButton(frame: rect)
            stopButton.tag = i
            
            var normalStateTitle : NSMutableAttributedString
            let currentFilter = allPriceFilters[(i - 1)]
            let isCurrentIndexActive = (i == (currentActiveIndex + 1 )) ? true : false
            let isFilterApplied = currentFilter.filterApplied()

            
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

                let leg = legsArray[(i - 1)]
                normalStateTitle = leg.getTitle(isCurrentlySelected: isCurrentIndexActive, isFilterApplied: isFilterApplied)
            }
            
            stopButton.setAttributedTitle(normalStateTitle, for: .normal)
            stopButton.addTarget(self, action: #selector(tappedOnMulticityButton(sender:)), for: .touchDown)
            
            if i == (currentActiveIndex + 1 ) {
                stopButton.backgroundColor = UIColor.AertripColor
            }
            
            multiSegmentView.addSubview(stopButton)
            
            if i != numberOfStops {
                rect  = CGRect(x: xcordinate + width - 1 , y: 0, width: 1, height: 30)
                let verticalSeparator = UIView(frame: rect)
                verticalSeparator.backgroundColor = UIColor.AertripColor
                multiSegmentView.addSubview(verticalSeparator)
            }
        }
    }
    
    
    fileprivate func setupPriceSlider() {
        priceRangeSlider.setupThemeImages()
        priceRangeSlider.setMinValue(currentPriceFilter.inputFareMinValue, maxValue: currentPriceFilter.inputFareMaxVaule)
        priceRangeSlider.setLeftValue(currentPriceFilter.userSelectedFareMinValue, rightValue: currentPriceFilter.userSelectedFareMaxValue)
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
        priceRangeSlider.setLeftValue(currentPriceFilter.inputFareMinValue, rightValue: currentPriceFilter.inputFareMaxVaule)
        setupPriceLabels()
        refundableFaresButton.isSelected = false
        
        switch  allPriceFilters.count {
        case 1:
            multicityViewHeight.constant = 0
            multiLegView.isHidden = true
        case 2:
            JourneyTitle.isHidden = true
            multicityViewHeight.constant = 60.0
            setmultiLegSubviews()
        case 3:
            multiLegView.isHidden = false
            multicityViewHeight.constant = 60.0
            setmultiLegSubviews()
            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
        case 4 , 5 :
            multiLegView.isHidden = false
            multicityViewHeight.constant = 90.0
            setmultiLegSubviews()
            JourneyTitle.isHidden = false
            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
        default:
            multicityViewHeight.constant = 90.0
            setmultiLegSubviews()
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
        
        currentPriceFilter.userSelectedFareMinValue = priceRangeSlider.leftValue.rounded(.down)
        currentPriceFilter.userSelectedFareMaxValue = priceRangeSlider.rightValue.rounded(.up)
        
        setupPriceLabels()
    }
    
    @objc fileprivate func priceRangeUpdated() {
        
        currentPriceFilter.userSelectedFareMinValue = priceRangeSlider.leftValue.rounded(.down)
        currentPriceFilter.userSelectedFareMaxValue = priceRangeSlider.rightValue.rounded(.up)
        
        allPriceFilters[currentActiveIndex] = currentPriceFilter
        setmultiLegSubviews()
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
        setmultiLegSubviews()
        delegate?.onlyRefundableFares(selected: currentPriceFilter.onlyRefundableFaresSelected, index:  currentActiveIndex)
    }
     @IBAction fileprivate func tappedOnMulticityButton( sender : UIButton) {
        
        
        let tag = sender.tag
        
        if currentActiveIndex == (tag - 1) {
            return
        }
        else {
            
            allPriceFilters[currentActiveIndex] = currentPriceFilter
            currentActiveIndex = tag - 1
            currentPriceFilter = allPriceFilters[currentActiveIndex]
            JourneyTitle.attributedText = legsArray[currentActiveIndex].descriptionOneFiveThree
        }
        
        checkRefundableFlights(index: sender.tag-1)
        
        setmultiLegSubviews()
        setupPriceSlider()
        setupPriceLabels()
        
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
