//
//  FlightFilterBaseVC+Parchment.swift
//  AERTRIP
//
//  Created by Rishabh on 17/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import Parchment

extension FlightFilterBaseVC: PagingViewControllerDataSource , PagingViewControllerDelegate ,PagingViewControllerSizeDelegate{
    
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
extension FlightFilterBaseVC {
    func logTapEvent(filterIndex: Int) {
        guard let selectedFilter = Filters(rawValue: filterIndex) else { return }
        var selectedEvent: FirebaseEventLogs.EventsTypeName = .FlightSortFilterTapped
        switch selectedFilter {
        case .sort:             selectedEvent = .FlightSortFilterTapped
        case .stops:            selectedEvent = .FlightStopsFilterTapped
        case .Times:            selectedEvent = .FlightTimesFilterTapped
        case .Duration:         selectedEvent = .FlightDurationFilterTapped
        case .Airlines:         selectedEvent = .FlightAirlinesFilterTapped
        case .Airport:          selectedEvent = .FlightAirportFilterTapped
        case .Price:            selectedEvent = .FlightPriceFilterTapped
        case .Aircraft:         selectedEvent = .FlightAircraftFilterTapped
        default: break
        }
        FirebaseEventLogs.shared.logFlightNavigationEvents(with: selectedEvent)
    }
    
    func logSwipeEvent(filterIndex: Int) {
        guard let selectedFilter = Filters(rawValue: filterIndex) else { return }
        var selectedEvent: FirebaseEventLogs.EventsTypeName = .FlightSortFilterSwiped
        switch selectedFilter {
        case .sort:             selectedEvent = .FlightSortFilterSwiped
        case .stops:            selectedEvent = .FlightStopsFilterSwiped
        case .Times:            selectedEvent = .FlightTimesFilterSwiped
        case .Duration:         selectedEvent = .FlightDurationFilterSwiped
        case .Airlines:         selectedEvent = .FlightAirlinesFilterSwiped
        case .Airport:          selectedEvent = .FlightAirportFilterSwiped
        case .Price:            selectedEvent = .FlightPriceFilterSwiped
        case .Aircraft:         selectedEvent = .FlightAircraftFilterSwiped
        default: break
        }
        FirebaseEventLogs.shared.logFlightNavigationEvents(with: selectedEvent)
    }
}
