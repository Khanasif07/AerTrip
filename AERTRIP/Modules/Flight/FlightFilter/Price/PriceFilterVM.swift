//
//  PriceFilterVM.swift
//  AERTRIP
//
//  Created by Rishabh on 14/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

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

class PriceFilterVM {
    
    weak var delegate : PriceFilterDelegate?
    var currentActiveIndex : Int = 0
    var allPriceFilters = [PriceFilter]()
    var currentPriceFilter : PriceFilter!
    var legsArray = [Leg]()
    var flightResultArray : [FlightsResults]!
    var intFlightResultArray : [IntMultiCityAndReturnWSResponse.Results]!
    var isInternational = false
    
    var priceDiffForFraction: CGFloat {
        let diff = currentPriceFilter.inputFareMaxVaule - currentPriceFilter.inputFareMinValue
        return diff == 0 ? 1 : diff
    }
    
}
