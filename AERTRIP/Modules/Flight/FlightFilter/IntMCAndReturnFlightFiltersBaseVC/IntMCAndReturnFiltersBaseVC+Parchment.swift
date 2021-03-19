//
//  IntMCAndReturnFiltersBaseVC+Parchment.swift
//  AERTRIP
//
//  Created by Rishabh on 20/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import Parchment

extension IntMCAndReturnFiltersBaseVC: PagingViewControllerDataSource , PagingViewControllerDelegate ,PagingViewControllerSizeDelegate{
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        
        if let pagingIndexItem = pagingItem as? MenuItemForFilter {
            let text = pagingIndexItem.title
            let font = isSelected ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(16.0)
            return text.widthOfString(usingFont: font) + 23.0
        }
        
        return 100.0
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        menuItems.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return MenuItemForFilter(title: menuItems[index].title, index: index, isSelected: !menuItems[index].isSelected, showSelectedFont: showSelectedFontOnMenu)
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didSelectItem pagingItem: PagingItem) {
        if let pagingIndexItem = pagingItem as? MenuItemForFilter {
            filterUIDelegate?.selectedIndexChanged(index: UInt(pagingIndexItem.index))
            didTapFilter = true
            logTapEvent(filterIndex: pagingIndexItem.index)
        }
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        if didTapFilter {
            didTapFilter = false
            return
        }
        if let pagingIndexItem = pagingItem as? MenuItemForFilter {
            logSwipeEvent(filterIndex: pagingIndexItem.index)
        }
    }
}

// MARK: Analytics
extension IntMCAndReturnFiltersBaseVC {
    func logTapEvent(filterIndex: Int) {
        guard let selectedFilter = Filters(rawValue: filterIndex) else { return }
        var selectedEvent: FirebaseEventLogs.EventsTypeName = .SortFilterTapped
        switch selectedFilter {
        case .sort:             selectedEvent = .SortFilterTapped
        case .stops:            selectedEvent = .StopsFilterTapped
        case .Times:            selectedEvent = .TimesFilterTapped
        case .Duration:         selectedEvent = .DurationFilterTapped
        case .Airlines:         selectedEvent = .AirlinesFilterTapped
        case .Airport:          selectedEvent = .AirportFilterTapped
        case .Price:            selectedEvent = .PriceFilterTapped
        case .Aircraft:         selectedEvent = .AircraftFilterTapped
        default: break
        }
        FirebaseEventLogs.shared.logFlightFilterEvents(with: selectedEvent)
    }
    
    func logSwipeEvent(filterIndex: Int) {
        guard let selectedFilter = Filters(rawValue: filterIndex) else { return }
        var selectedEvent: FirebaseEventLogs.EventsTypeName = .SortFilterSwiped
        switch selectedFilter {
        case .sort:             selectedEvent = .SortFilterSwiped
        case .stops:            selectedEvent = .StopsFilterSwiped
        case .Times:            selectedEvent = .TimesFilterSwiped
        case .Duration:         selectedEvent = .DurationFilterSwiped
        case .Airlines:         selectedEvent = .AirlinesFilterSwiped
        case .Airport:          selectedEvent = .AirportFilterSwiped
        case .Price:            selectedEvent = .PriceFilterSwiped
        case .Aircraft:         selectedEvent = .AircraftFilterSwiped
        default: break
        }
        FirebaseEventLogs.shared.logFlightFilterEvents(with: selectedEvent)
    }
}
