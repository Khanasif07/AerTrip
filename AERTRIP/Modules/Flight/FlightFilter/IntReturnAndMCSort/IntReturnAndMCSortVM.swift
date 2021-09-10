//
//  IntReturnAndMCSortVM.swift
//  AERTRIP
//
//  Created by Rishabh on 16/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol FlightsSortVMDelegate: AnyObject {
    func selectRow(row: Int)
}

class IntReturnAndMCSortVM {
    var  priceHighToLow : Bool = false
    var  durationLongestFirst : Bool = false
    weak var delegate : SortFilterDelegate?
    var selectedSorting = Sort.Smart
    var airportsArr = [AirportLegFilter]()
    
    var flightSearchParameters = JSONDictionary()
    weak var vmDelegate: FlightsSortVMDelegate?
    
    var curSelectedIndex: Int?
    var earliestFirstAtDepartArrive: [Int: Bool] = [:]
        
    func getAttributedStringFor(index : Int) ->NSAttributedString? {
        
        if  let sortFilter = Sort(rawValue: index) {
            
            var attributes : [NSAttributedString.Key : Any]
            
            if index == curSelectedIndex{
//            if ( sortFilter == selectedSorting) {
                
                attributes = [NSAttributedString.Key.font : AppFonts.Regular.withSize(18) ,
                              NSAttributedString.Key.foregroundColor : UIColor.AertripColor]

            }
            else {
                attributes = [NSAttributedString.Key.font : AppFonts.Regular.withSize(18)]

            }
            
            let attributedString = NSMutableAttributedString(string: sortFilter.title, attributes: attributes)
            
            var substring = "  " + sortFilter.subTitle
            
            if index == 1  && priceHighToLow {
                substring = "  "  + "High to Low"
            }
            if index == 2 && durationLongestFirst {
                substring = "  " + "Longest first"
            }
            let substringAttributedString = NSAttributedString(string: substring, attributes: [NSAttributedString.Key.font : AppFonts.Regular.withSize(14), NSAttributedString.Key.foregroundColor : AppColors.commonThemeGray  ])
            attributedString.append(substringAttributedString)
         
            return attributedString
        }
        return nil
    }
    
    func getDepartArriveAttString(_ str: String,_ indexPath: IndexPath) -> NSAttributedString {
        var attributes : [NSAttributedString.Key : Any]
        if (curSelectedIndex == indexPath.row) {
            
            attributes = [NSAttributedString.Key.font : AppFonts.Regular.withSize(18) ,
                          NSAttributedString.Key.foregroundColor : UIColor.AertripColor]

        }
        else {
            attributes = [NSAttributedString.Key.font : AppFonts.Regular.withSize(18)]

        }
        let attributedString = NSMutableAttributedString(string: str, attributes: attributes)
        
        var substring = "  " + "Earliest First"
        
        if earliestFirstAtDepartArrive[indexPath.row] == false {
            substring = "  " + "Latest First"
        }
        
        let substringAttributedString = NSAttributedString(string: substring, attributes: [NSAttributedString.Key.font : AppFonts.Regular.withSize(14), NSAttributedString.Key.foregroundColor : AppColors.commonThemeGray ])
           attributedString.append(substringAttributedString)
        
        return attributedString
    }
    
    func setAppliedSortFromDeepLink() {
        let sharedSortOrder = flightSearchParameters["sort[]"] as? String ?? ""
        let order = FlightResultBaseViewController.SortingValuesWhenShared(rawValue: sharedSortOrder) ?? FlightResultBaseViewController.SortingValuesWhenShared.smart
        
        func getOrder() -> (Sort, Bool) {
            switch order {
            
            case .priceLowToHigh:
                return (Sort.Price, false)
                
            case .priceHighToLow:
                return (Sort.Price, true)
                
            case .durationLowToHigh:
                return (Sort.Duration, false)
                
            case .durationHighToLow:
                return (Sort.Duration, true)
                
            case .departureLowToHigh:
                return (Sort.Depart, false)
                
            case .departureHighToLow:
                return (Sort.Depart, true)
                
            case .arivalLowToHigh:
                return (Sort.Arrival, false)
                
            case .arivalHighToLow:
                return (Sort.Arrival, true)
                
            default:
                return (Sort.Smart, false)
            }
        }
        
        let sortType = getOrder().0
        let isDescending = getOrder().1
        
        switch sortType {
        case .Price:
            priceHighToLow = isDescending
            delegate?.priceFilterChangedWith(priceHighToLow)
            curSelectedIndex = 1
            vmDelegate?.selectRow(row: 1)
        case .Duration:
            durationLongestFirst = isDescending
            delegate?.durationFilterChangedWith(durationLongestFirst)
            curSelectedIndex = 2
            vmDelegate?.selectRow(row: 2)
        case .Depart:
            earliestFirstAtDepartArrive[3] = !isDescending
            delegate?.departSortFilterChangedWith(0, !isDescending)
            curSelectedIndex = 3
            vmDelegate?.selectRow(row: 3)
        case .Arrival:
            let firstIndex = 3 + airportsArr.count
            earliestFirstAtDepartArrive[firstIndex] = !isDescending
            delegate?.arrivalSortFilterChangedWith(0, !isDescending)
            curSelectedIndex = firstIndex
            vmDelegate?.selectRow(row: firstIndex)
        default: break
        }
    }
}
