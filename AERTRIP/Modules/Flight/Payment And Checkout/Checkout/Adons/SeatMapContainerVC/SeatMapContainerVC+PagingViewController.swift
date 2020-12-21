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
        
        if let pagingIndexItem = pagingItem as? LogoMenuItem, let text = pagingIndexItem.attributedTitle {
            
            
            let attText = NSMutableAttributedString(attributedString: text)
            attText.addAttribute(.font, value: AppFonts.SemiBold.withSize(16), range: NSRange(location: 0, length: attText.length))
            let width = attText.widthOfText(50, font: AppFonts.SemiBold.withSize(16))
            return width + 50
            
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
        
        return LogoMenuItem(index: index, isSelected: true, attributedTitle: viewModel.allTabsStr[index], logoUrl: AppKeys.airlineMasterBaseUrl + viewModel.allFlightsData[index].al + ".png")
        
//        return MenuItem(title: "", index: index, isSelected:true, attributedTitle: viewModel.allTabsStr[index])
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        
        if let pagingIndexItem = pagingItem as? LogoMenuItem {
            viewModel.currentIndex = pagingIndexItem.index
            self.planeLayoutCollView.reloadData()
            DispatchQueue.delay(0.5) {
                self.setCurrentPlaneLayout()
            }
        }
    }
}

extension NSMutableAttributedString {
    func widthOfText(_ height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width
    }
}
