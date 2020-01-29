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
        
        let title = self.viewModel.hotels[index].cityName
        printDebug("Title = \(title)")
        
        return PagingIndexItem(index: index, title: "\(title)") as! T
    }

    func numberOfViewControllers<T>(in pagingViewController: PagingViewController<T>) -> Int {
        return self.allChildVCs.count
    }

    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController {
        return self.allChildVCs[index]
    }
}

// To handle the page view object properties, and how they look in the view.
extension FavouriteHotelsVC : PagingViewControllerDelegate{
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, widthForPagingItem pagingItem: T, isSelected: Bool) -> CGFloat? where T : PagingItem, T : Comparable, T : Hashable {

        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? PagingIndexItem{
            let text = pagingIndexItem.title
            
            let font = AppFonts.Bold.withSize(15.0)
            return text.widthOfString(usingFont: font)
        }
        
        return 100.0
    }
}

fileprivate extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
