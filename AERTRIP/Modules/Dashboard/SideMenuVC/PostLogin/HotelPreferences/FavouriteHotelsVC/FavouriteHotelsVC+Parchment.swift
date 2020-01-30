//
//  FavouriteHotelsVC+Parchment.swift
//  AERTRIP
//
//  Created by Hitesh Soni on 29/01/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import Parchment

// To display the view controllers, and how they traverse from one page to another
extension FavouriteHotelsVC: PagingViewControllerDataSource {
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T where T : PagingItem, T : Comparable, T : Hashable {
        
        return PagingIndexItem(index: index, title: self.viewModel.hotels[index].cityName) as! T
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController where T : PagingItem, T : Comparable, T : Hashable {
      
        return self.allChildVCs[index]
    }
    func numberOfViewControllers<T>(in pagingViewController: PagingViewController<T>) -> Int where T : PagingItem, T : Comparable, T : Hashable {
        return self.viewModel.hotels.count
    }
}

// To handle the page view object properties, and how they look in the view.
extension FavouriteHotelsVC : PagingViewControllerDelegate{
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, widthForPagingItem pagingItem: T, isSelected: Bool) -> CGFloat? where T : PagingItem, T : Comparable, T : Hashable {

        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? PagingIndexItem{
            let text = pagingIndexItem.title
            
            let font = AppFonts.SemiBold.withSize(17.0)
            return text.widthOfString(usingFont: font)
        }
        
        return 100.0
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, didScrollToItem pagingItem: T, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) where T : PagingItem, T : Comparable, T : Hashable {
        
        let pagingIndexItem = pagingItem as! PagingIndexItem
        self.currentIndex = pagingIndexItem.index
    }
}

fileprivate extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
