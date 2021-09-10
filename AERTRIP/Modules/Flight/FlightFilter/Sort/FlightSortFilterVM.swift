//
//  FlightSortFilterVM.swift
//  AERTRIP
//
//  Created by Rishabh on 11/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


protocol SortFilterDelegate : FilterDelegate {

    func resetSort()
    func sortFilterChanged(sort : Sort )
    func departSortFilterChanged( departMode  : Bool )
    func arrivalSortFilterChanged( arrivalMode : Bool)
    func durationSortFilterChanged( longestFirst : Bool)
    
    func priceFilterChangedWith(_ highToLow: Bool)
    func durationFilterChangedWith(_ longestFirst: Bool)
    func departSortFilterChangedWith(_ index: Int,_ earliestFirst: Bool)
    func arrivalSortFilterChangedWith(_ index: Int,_ earliestFirst: Bool)
}

extension SortFilterDelegate {
    func priceFilterChangedWith(_ highToLow: Bool) { }
    func durationFilterChangedWith(_ latestFirst: Bool) { }
    func departSortFilterChangedWith(_ index: Int,_ earliestFirst: Bool) { }
    func arrivalSortFilterChangedWith(_ index: Int,_ earliestFirst: Bool) { }
}

protocol FilterViewController : UIViewController {
    func initialSetup()
    func resetFilter()
    func updateUIPostLatestResults()
}

class FlightSortFilterVM {
    
    var  departModeLatestFirst : Bool = false
    var  arrivalModeLatestFirst : Bool = false
    var  priceHighToLow : Bool = false
    var  durationLogestFirst : Bool = false
    var flightSearchParameters = JSONDictionary()
    weak var vmDelegate: FlightsSortVMDelegate?

    weak var delegate : SortFilterDelegate?
    var selectedSorting = Sort.Smart
    var isInitialSetup = true
    var isFirstIndexSelected = true
    var selectedIndex = 0
    
    func resetSort() {
        departModeLatestFirst = false
        arrivalModeLatestFirst = false
        priceHighToLow = false
        durationLogestFirst = false
        selectedSorting = Sort.Smart
        delegate?.sortFilterChanged(sort: selectedSorting)
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
        
        selectedSorting = sortType
        
        switch sortType {
        case .Price:
            priceHighToLow = isDescending
            delegate?.priceFilterChangedWith(priceHighToLow)
            selectedIndex = 1
            vmDelegate?.selectRow(row: 1)
        case .Duration:
            durationLogestFirst = isDescending
            delegate?.durationFilterChangedWith(durationLogestFirst)
            selectedIndex = 2
            vmDelegate?.selectRow(row: 2)
        case .Depart:
            departModeLatestFirst = isDescending
            delegate?.departSortFilterChanged(departMode: departModeLatestFirst)
            selectedIndex = 3
            vmDelegate?.selectRow(row: 3)
        case .Arrival:
            arrivalModeLatestFirst = isDescending
            delegate?.departSortFilterChanged(departMode: arrivalModeLatestFirst)
            selectedIndex = 4
            vmDelegate?.selectRow(row: 4)
        default:
            break
        }
    }
    
}
