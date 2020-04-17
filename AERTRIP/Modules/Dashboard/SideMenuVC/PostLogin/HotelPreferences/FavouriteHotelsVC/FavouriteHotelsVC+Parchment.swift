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
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        MenuItem(title: self.viewModel.hotels[index].cityName, index: index, isSelected:false)
    }

    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController  {
         return self.allChildVCs[index]
    }
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int  {
        return self.viewModel.hotels.count
    }
}

// To handle the page view object properties, and how they look in the view.
extension FavouriteHotelsVC : PagingViewControllerDelegate, PagingViewControllerSizeDelegate{
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {

        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? MenuItem{
            let text = pagingIndexItem.title
            
            let font = isSelected ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(16.0)
            return text.widthOfString(usingFont: font)
        }
        
        return 100.0
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        
        if let pagingIndexItem = pagingItem as? MenuItem {
            self.currentIndex = pagingIndexItem.index
        }
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
