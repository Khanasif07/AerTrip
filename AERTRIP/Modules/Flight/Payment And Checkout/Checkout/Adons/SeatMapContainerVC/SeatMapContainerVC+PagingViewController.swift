//
//  SeatMapContainerVC+PagingViewController.swift
//  AERTRIP
//
//  Created by Rishabh on 17/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment

extension SeatMapContainerVC: PagingViewControllerDataSource , PagingViewControllerDelegate ,PagingViewControllerSizeDelegate{
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        
        if let pagingIndexItem = pagingItem as? MenuItem{
            let text = pagingIndexItem.attributedTitle
            return (text?.size().width ?? 0) + 10
        }
        
        return 100.0
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        viewModel.allTabsStr.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return MenuItem(title: "", index: index, isSelected:true, attributedTitle: viewModel.allTabsStr[index])
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        
        if let pagingIndexItem = pagingItem as? MenuItem {
            viewModel.currentIndex = pagingIndexItem.index
            self.planeLayoutCollView.reloadData()
            DispatchQueue.delay(0.5) {
                self.setCurrentPlaneLayout()
            }
        }
    }
}
