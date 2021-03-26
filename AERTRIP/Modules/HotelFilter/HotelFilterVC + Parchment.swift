//
//  HotelFilterVC + Parchment.swift
//  AERTRIP
//
//  Created by Admin on 31/01/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import Parchment

// To display the view controllers, and how they traverse from one page to another
extension HotelFilterVC: PagingViewControllerDataSource {

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        
        return MenuItem(title: HotelFilterVM.shared.allTabsStr[index], index: index, isSelected: filtersTabs[index].isSelected )
    }

    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
      
        return self.allChildVCs[index]
    }
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return HotelFilterVM.shared.allTabsStr.count
    }
}

// To handle the page view object properties, and how they look in the view.
extension HotelFilterVC : PagingViewControllerDelegate, PagingViewControllerSizeDelegate{
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? MenuItem {
            let text = pagingIndexItem.title
            
            let font = isSelected ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(16.0)
            return text.widthOfString(usingFont: font) + 23.0
        }
        
        return 100.0
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        
        if let pagingIndexItem = pagingItem as? MenuItem {
            HotelFilterVM.shared.lastSelectedIndex = pagingIndexItem.index
        }
        
        if didTapFilter {
            didTapFilter = false
            return
        }
        if let pagingIndexItem = pagingItem as? MenuItemForFilter {
            logSwipeEvent(filterIndex: pagingIndexItem.index)
        }
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didSelectItem pagingItem: PagingItem) {
        if let pagingIndexItem = pagingItem as? MenuItem {
            if HotelFilterVM.shared.lastSelectedIndex == pagingIndexItem.index {
                hideFilter(tappedOutside: false)
            }
            didTapFilter = true
            logTapEvent(filterIndex: pagingIndexItem.index)
        }
    }
}

// MARK: Analytics
extension HotelFilterVC {
    func logTapEvent(filterIndex: Int) {
        var selectedEvent: FirebaseEventLogs.EventsTypeName = .FlightSortFilterTapped
        switch filterIndex {
        case 0:             selectedEvent = .HotelSortFilterTapped
        case 1:             selectedEvent = .HotelDistanceFilterTapped
        case 2:             selectedEvent = .HotelPriceFilterTapped
        case 3:             selectedEvent = .HotelRatingsFilterTapped
        case 4:             selectedEvent = .HotelAmenitiesFilterTapped
        case 5:             selectedEvent = .HotelRoomFilterTapped
        default: break
        }
        FirebaseEventLogs.shared.logHotelFilterEvents(with: selectedEvent)
    }
    
    func logSwipeEvent(filterIndex: Int) {
        var selectedEvent: FirebaseEventLogs.EventsTypeName = .FlightSortFilterSwiped
        switch filterIndex {
        case 0:             selectedEvent = .HotelSortFilterSwiped
        case 1:             selectedEvent = .HotelDistanceFilterSwiped
        case 2:             selectedEvent = .HotelPriceFilterSwiped
        case 3:             selectedEvent = .HotelRatingsFilterSwiped
        case 4:             selectedEvent = .HotelAmenitiesFilterSwiped
        case 5:             selectedEvent = .HotelRoomFilterSwiped
        default: break
        }
        FirebaseEventLogs.shared.logHotelFilterEvents(with: selectedEvent)
    }
}
