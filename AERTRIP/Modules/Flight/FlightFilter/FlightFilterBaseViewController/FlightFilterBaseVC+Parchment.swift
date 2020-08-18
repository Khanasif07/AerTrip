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
        filterUIDelegate?.selectedIndexChanged(index: 0)
    }
}
