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

    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T {
        
        return MenuItem(title: HotelFilterVM.shared.allTabsStr[index], index: index, isSelected: filtersTabs[index].isSelected ) as! T
    }

    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController where T : PagingItem, T : Comparable, T : Hashable {
      
        return self.allChildVCs[index]
    }
    func numberOfViewControllers<T>(in pagingViewController: PagingViewController<T>) -> Int where T : PagingItem, T : Comparable, T : Hashable {
        return HotelFilterVM.shared.allTabsStr.count
    }
}

// To handle the page view object properties, and how they look in the view.
extension HotelFilterVC : PagingViewControllerDelegate{
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, widthForPagingItem pagingItem: T, isSelected: Bool) -> CGFloat? where T : PagingItem, T : Comparable, T : Hashable {

        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? MenuItem {
            let text = pagingIndexItem.title
            
            let font = AppFonts.SemiBold.withSize(16.0)
            return text.widthOfString(usingFont: font) + 20.0
        }
        
        return 100.0
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, didScrollToItem pagingItem: T, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) where T : PagingItem, T : Comparable, T : Hashable {
        
        let pagingIndexItem = pagingItem as! MenuItem
        HotelFilterVM.shared.lastSelectedIndex = pagingIndexItem.index
    }
}
