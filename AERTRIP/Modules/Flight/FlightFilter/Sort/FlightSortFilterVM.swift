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
}
