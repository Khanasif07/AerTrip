//
//  FlightDomesticMultiLegResultVC+Scrolling.swift
//  Aertrip
//
//  Created by  hrishikesh on 26/12/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

extension FlightDomesticMultiLegResultVC {
    
    
    //MARK:- NavigationView Animation
    func hidingAnimationOnNavigationBarOnScroll(offsetDifference : CGFloat) {
         DispatchQueue.main.async {
            let visualEffectViewHeight =  CGFloat(88.0)
            
            var yCordinate : CGFloat
            yCordinate = max (  -visualEffectViewHeight ,  -offsetDifference )
            yCordinate = min ( 0,  yCordinate)
            
            var yCordinateForHeaderView : CGFloat
            yCordinateForHeaderView = max (  0 , 88.0 - offsetDifference)
            yCordinateForHeaderView = min ( 88.0  ,  yCordinateForHeaderView)
            
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
                
                if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
                    var rect = blurEffectView.frame
                    let yCordinateOfView = rect.origin.y
                    if ( yCordinateOfView  > yCordinate ) {
                        rect.origin.y = yCordinate
                        var baseViewContentOffset = self.baseScrollView.contentOffset
                        baseViewContentOffset.y = max( 0 , -yCordinate)
                        self.baseScrollView.setContentOffset(baseViewContentOffset, animated: false )
                        self.headerCollectionViewTop.constant = yCordinateForHeaderView
                        blurEffectView.frame = rect
                        
                    }
                }
            } ,completion: nil)
        }
       }
    
    
    func revealAnimationOfNavigationBarOnScroll(offsetDifference : CGFloat) {
        let invertedOffset = -offsetDifference
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
                
                if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
                    var rect = blurEffectView.frame
                    var yCordinate = rect.origin.y + invertedOffset
                    yCordinate = min ( 0,  yCordinate)
                    rect.origin.y = yCordinate
                    blurEffectView.frame = rect
                    var baseViewContentOffset = self.baseScrollView.contentOffset
                    baseViewContentOffset.y = min( 0 , invertedOffset)
                    self.baseScrollView.setContentOffset(baseViewContentOffset, animated: false )
                    
                    rect = self.headerCollectionView.frame
                    var yCordinateForHeaderView = rect.origin.y + invertedOffset
                    yCordinateForHeaderView = min(88.0 , yCordinateForHeaderView)
                    self.headerCollectionViewTop.constant = yCordinateForHeaderView
                }
            } ,completion: nil)
        }
    }
    
    func animateTopViewOnScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset
        let offsetDifference = contentOffset.y - scrollviewInitialYOffset
        
        if offsetDifference > 0 {
            self.hidingAnimationOnNavigationBarOnScroll(offsetDifference : offsetDifference)
        } else {
            self.revealAnimationOfNavigationBarOnScroll(offsetDifference : offsetDifference)
        }
    }
    
    fileprivate func snapToTopOrBottomOnSlowScrollDragging(_ scrollView: UIScrollView) {

        if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
            let rect = blurEffectView.frame
            let yCoordinate = rect.origin.y * ( -1 )
            let visualEffectViewHeight =  CGFloat(88.0)
//            // After dragging if blurEffectView is at top or bottom position , snapping animation is not required
            if yCoordinate == 0 || yCoordinate == ( -visualEffectViewHeight){
                return
            }
//
//            // If blurEffectView yCoodinate is close to top of the screen
            if  ( yCoordinate > ( visualEffectViewHeight / 2.0 ) ){
                hidingAnimationOnNavigationBarOnScroll(offsetDifference: 88.0)
                
            }
            else {  //If blurEffectView yCoodinate is close to fully visible state of blurView
                revealAnimationOfNavigationBarOnScroll(offsetDifference: (-88.0))
            }
        }
    }
    
    //MARK:- Journey CompactView ( Mini View ) Animation on scroll
    
    func getVisibleAreaRectFor(tableView : UITableView) -> CGRect {
        
        let xCoordinate = tableView.frame.origin.x
        let yCoordinate = self.headerCollectionViewTop.constant + self.headerCollectionView.frame.height
        let width = tableView.bounds.size.width
        let bottomInset = self.view.safeAreaInsets.bottom
        //FIXME :- magical no
        let height = UIScreen.main.bounds.height - yCoordinate - bottomInset - 50 - self.statusBarHeight
        let visibleRect = CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
        return visibleRect
    }
    
        func animateJourneyCompactView(for tableView : UITableView) {
            
            guard let selectedRowIndex = tableView.indexPathForSelectedRow else { return }
            let visibleRect = getVisibleAreaRectFor(tableView: tableView)
            let xCoordinate = tableView.frame.origin.x

            var selectedRowRect = tableView.rectForRow(at: selectedRowIndex)
            selectedRowRect.origin.y = selectedRowRect.origin.y - tableView.contentOffset.y
            selectedRowRect.origin.x = xCoordinate
            if visibleRect.contains(selectedRowRect) {
                let index = tableView.tag - 1000
                hideHeaderCellAt(index: index)
            }
            else {
                showHeaderCellAt(indexPath: selectedRowIndex , tableView: tableView)
            }
            setTableViewHeaderFor(tableView: tableView)
        }
        
        func showHeaderCellAt(indexPath : IndexPath, tableView : UITableView) {
            
            let index = tableView.tag - 1000
            let headerView = journeyHeaderViewArray[index]
            
            if headerView.isHidden {
                headerView.isHidden = false
            
                let width = UIScreen.main.bounds.size.width / 2.0

                let tableState = resultsTableViewStates[index]
                var arrayForDisplay = results[index].suggestedJourneyArray
                
                if sortOrder == .Smart  {
                    
                    if tableState == .showExpensiveFlights && indexPath.section == 1 {
                        arrayForDisplay = results[index].expensiveJourneyArray
                    }
                }
                else {
                    arrayForDisplay =  self.sortedJourneyArray[index]
                }
                
                guard let journey = arrayForDisplay?[indexPath.row] else {   return }
                headerView.setValuesFrom(journey: journey)
                
                let headerJourneyRect  = CGRect(x: (width * CGFloat(index)), y: (-journeyCompactViewHeight) , width: width - 1 , height: journeyCompactViewHeight)
                headerView.frame = headerJourneyRect
                
                
                UIView.animate(withDuration: 0.4) {
                    var rect = headerView.frame
                    var yCoordinate = max(self.headerCollectionViewTop.constant +  self.headerCollectionView.frame.size.height , self.headerCollectionView.frame.size.height )
                    if self.baseScrollView.contentOffset.y == 88.0 {
                        yCoordinate = yCoordinate + 88.0
                    }
                    rect.origin.y = yCoordinate
                    rect.size.height = self.journeyCompactViewHeight
                    headerView.frame = rect
                }
            }
        }
        
        func hideHeaderCellAt(index : Int) {
            
            let headerView = journeyHeaderViewArray[index]
            
            if headerView.isHidden {
                return
            }
            
            if !headerView.isHidden {
                UIView.animate(withDuration: 0.4, animations: {
                    
                    var frame = headerView.frame
                    frame.origin.y =  (-self.headerCollectionViewTop.constant - self.journeyCompactViewHeight)
                    headerView.frame = frame
                    
                }) { (completed) in
                    headerView.isHidden = true
                }
            }
        }
    
    
    
    //MARK:- Horizontal Scrolling
    func showHintAnimation() {
        
        if numberOfLegs > 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let point = CGPoint(x: 30 , y: 0)
                self.baseScrollView.setContentOffset(point , animated: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                  let point  = CGPoint(x: 0 , y: 0)
                 self.baseScrollView.setContentOffset(point , animated: true)
            }
        }
    }
    
    //MARK:- Setting TableView Header after showing/hiding journey compact view to avoid overlapping of first cell
    
    func setTableViewHeaderFor(tableView  : UITableView) {
                
        let width = tableView.bounds.size.width
        let index = tableView.tag - 1000
        let headerView = journeyHeaderViewArray[index]
        
        let height : CGFloat
        if headerView.isHidden {
            height = 138.0
        }
        else {
            height = 188.0
        }
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height )
        let tableHeaderView = UIView(frame: rect)
        tableView.tableHeaderView = tableHeaderView
    }
               

    func setTableViewHeaderAfterSelection(tableView  : UITableView) {
        
        let visibleRect = self.getVisibleAreaRectFor(tableView: tableView)
        let xCoordinate = tableView.frame.origin.x
        let zerothRowIndex = IndexPath(item: 0, section: 0)
        var zerothRowRect = tableView.rectForRow(at: zerothRowIndex)
        zerothRowRect.origin.x = xCoordinate
        let width = tableView.bounds.size.width

        let isFirstCellVisible : Bool
        if visibleRect.contains(zerothRowRect) {
            isFirstCellVisible = true
        }
        else {
            isFirstCellVisible = false
        }
        
        // Debuging code
//        zerothRowRect.origin.x = 0
//        visibleRect.origin.x = 0
//        firstVisibleRectView.frame = zerothRowRect
//        debugVisibilityView.frame = visibleRect
        
        let index = tableView.tag - 1000
        let headerView = journeyHeaderViewArray[index]
        
        var height : CGFloat = 188.0
        if isFirstCellVisible {

            if headerView.isHidden {
                height = 138.0
            }
            else {
                height = 188.0
            }
        }

        if let selectedIndex =  tableView.indexPathForSelectedRow
        {
            
            if selectedIndex.row <= 4 {
                  height = 138.0
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: width, height: height )
        let tableHeaderView = UIView(frame: rect)
        tableView.tableHeaderView = tableHeaderView
    }

    
    //MARK:- ScrollView Delegate Methods
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        scrollviewInitialYOffset = scrollView.contentOffset.y
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Synchronizing scrolling of headerCollectionView to baseScrollView scroll movement
        if scrollView == baseScrollView {
            self.syncScrollView(headerCollectionView, toScrollView: baseScrollView)
            return
        }
        
        // Scrolling on tableviews
        if scrollView.tag > 999 {
            
            for subview in baseScrollView.subviews.filter({ $0.tag > 999 }) {
                
                if subview == scrollView {
                    animateTopViewOnScroll(scrollView)
                    if let tableView = scrollView as? UITableView {
                        animateJourneyCompactView(for: tableView)
                    }
                }
                else {
                    if let tableView = subview as? UIScrollView {
                        tableView.setContentOffset(tableView.contentOffset, animated: false)
                    }
                }
            }
        }
    }
    
    func syncScrollView(_ scrollViewToScroll: UIScrollView, toScrollView scrolledView: UIScrollView) {
        
        var offset : CGFloat
        let screenWidth = UIScreen.main.bounds.size.width
        let tenPercentWidth = screenWidth * 0.1
        let halfWidth = screenWidth * 0.5
        let scrolledDistance =  scrolledView.contentOffset.x

        if scrolledView == baseScrollView {
            
            let currentIndex = scrolledDistance/halfWidth
            offset = currentIndex * tenPercentWidth
            offset = ( -1 ) * offset
            var scrollBounds = scrollViewToScroll.bounds
            scrollBounds.origin.x = scrolledView.contentOffset.x + offset
            scrollViewToScroll.bounds = scrollBounds

        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.tag > 999 {
            if let tableView = scrollView as? UITableView {
                
//                if let selectedIndex = tableView.indexPathForSelectedRow {
//                    if selectedIndex == IndexPath(item: 0, section: 0) {
//                        return
//                    }
//                }
                setTableViewHeaderFor(tableView: tableView)
                snapToTopOrBottomOnSlowScrollDragging(scrollView)
                return
            }
        }

    }
    
    // For Horizontal Scrollig , snaping at the edge of tableview column
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if scrollView == baseScrollView {
            let currentOffset = scrollView.contentOffset.x
            let targetOffset = CGFloat(targetContentOffset.pointee.x)
            var newTargetOffset:CGFloat = 0.0
            let legWidth = self.view.bounds.size.width / 2
            var currentIndex =  currentOffset / legWidth
            
            // snap to closes , but gives jerk when pan is small
            
            let position = scrollView.panGestureRecognizer.translation(in: scrollView.superview )
            if position.x < 0 {

                 currentIndex.round(.awayFromZero)
            }
            else {

                if targetOffset > currentOffset {
                   currentIndex.round(.awayFromZero)
                }
                else {
                  currentIndex.round(.towardZero)
                }
            }
                                    
            newTargetOffset = CGFloat(currentIndex) * legWidth
            
            // To avoid going out of content size
             if newTargetOffset < 0.0 {
                 newTargetOffset = 0.0
             }
             else if newTargetOffset > scrollView.contentSize.width {
                 newTargetOffset = scrollView.contentSize.width
             }
            
            targetContentOffset.pointee = CGPoint(x: newTargetOffset, y: targetContentOffset.pointee.y)
            
//            if velocity.x != 0 && lastTargetContentOffsetX == targetContentOffset.pointee.x {
//                scrollView.setContentOffset(targetContentOffset.pointee, animated: true)
//            }
            
            lastTargetContentOffsetX = targetContentOffset.pointee.x
        }
    }
}
