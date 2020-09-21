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
    
    
    fileprivate func revealAnimationOfNavigationBarOnScroll(offsetDifference : CGFloat) {
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
        } else if offsetDifference < 0{
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
        let height = UIScreen.main.bounds.height - yCoordinate - bottomInset + 25.0 //- 50 - self.statusBarHeight
        let visibleRect = CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
        return visibleRect
    }
    
    func animateJourneyCompactView(for tableView : UITableView, isHeaderNeedToSet: Bool = false) {
        guard let selectedIndex =  self.getSelectedIndex(for: tableView) else { return }//tableView.indexPathForSelectedRow
        let visibleRect = getVisibleAreaRectFor(tableView: tableView)
        let xCoordinate = tableView.frame.origin.x
        let selectedRowIndex = IndexPath(row: selectedIndex, section: 0)
        var selectedRowRect = tableView.rectForRow(at: selectedRowIndex)
        selectedRowRect.origin.y = selectedRowRect.origin.y - tableView.contentOffset.y
        selectedRowRect.origin.x = xCoordinate
        if visibleRect.contains(selectedRowRect) {
            let index = tableView.tag - 1000
            hideHeaderCellAt(index: index, isHeaderNeedSet: isHeaderNeedToSet)
        }
        else {
            showHeaderCellAt(tableView: tableView, isHeaderNeedSet: isHeaderNeedToSet)
        }
//        setTableViewHeaderFor(tableView: tableView)
    }
        
    func showHeaderCellAt(tableView : UITableView, isHeaderNeedSet: Bool = false) {
        
        let index = tableView.tag - 1000
        let headerView = journeyHeaderViewArray[index]
        
        if headerView.isHidden {
            headerView.isHidden = false
            
            let width = UIScreen.main.bounds.size.width / 2.0
            
            if let journey = self.viewModel.results[index].selectedJourney{
                headerView.setValuesFrom(journey: journey)
            }
            let hiddenHeaderY = (self.headerCollectionViewTop.constant + self.headerCollectionView.height + self.baseScrollView.contentOffset.y - 44)
            
            let headerJourneyRect  = CGRect(x: (width * CGFloat(index)), y: hiddenHeaderY , width: width - 1 , height: journeyCompactViewHeight)
            headerView.frame = headerJourneyRect
            UIView.animate(withDuration: 0.4, animations: {
                var rect = headerView.frame
//                var yCoordinate = max(self.headerCollectionViewTop.constant +  self.headerCollectionView.frame.size.height , self.headerCollectionView.frame.size.height)
//                if self.baseScrollView.contentOffset.y == 88.0 {
//                    yCoordinate = yCoordinate + 88.0
//                }
                rect.origin.y = (self.headerCollectionViewTop.constant + self.headerCollectionView.height + self.baseScrollView.contentOffset.y)
                rect.size.height = self.journeyCompactViewHeight
                headerView.frame = rect
            }){ _ in
                if isHeaderNeedSet{
                    self.setTableViewHeaderFor(tableView: tableView)
                }
            }
        }else if isHeaderNeedSet{
            self.setTableViewHeaderFor(tableView: tableView)
        }
        
    }
        
    func hideHeaderCellAt(index : Int, isHeaderNeedSet: Bool = false)  {
        
        let headerView = journeyHeaderViewArray[index]
        
        if headerView.isHidden {
            if isHeaderNeedSet{
                if let table = self.baseScrollView.viewWithTag(1000 + index) as? UITableView{
                    self.setTableViewHeaderFor(tableView: table)
                }
            }
            return
        }
        
        if !headerView.isHidden {
            UIView.animate(withDuration: 0.4, animations: {
                var frame = headerView.frame
                frame.origin.y =  (self.headerCollectionViewTop.constant + self.headerCollectionView.height + self.baseScrollView.contentOffset.y - 44.0)//(-self.headerCollectionViewTop.constant - self.journeyCompactViewHeight)
                headerView.frame = frame
            }) { (completed) in
                headerView.isHidden = true
                if isHeaderNeedSet{
                    if let table = self.baseScrollView.viewWithTag(1000 + index) as? UITableView{
                        self.setTableViewHeaderFor(tableView: table)
                    }
                }
            }
        }
    }
    
    
    
    //MARK:- Horizontal Scrolling
    func showHintAnimation() {
        
        if self.viewModel.numberOfLegs > 2 {
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
//        guard !((tableView.tableHeaderView?.height) == height) else {return}
        let rect = CGRect(x: 0, y: 0, width: width, height: height )
        let tableHeaderView = UIView(frame: rect)
        tableView.tableHeaderView = tableHeaderView
    }
               

    func setTableViewHeaderAfterSelection(tableView  : UITableView) {
        
        self.hideHeaderCellAt(index: tableView.tag - 1000, isHeaderNeedSet: true)
//        let visibleRect = self.getVisibleAreaRectFor(tableView: tableView)
//        let xCoordinate = tableView.frame.origin.x
//        let zerothRowIndex = IndexPath(item: 0, section: 0)
//        var zerothRowRect = tableView.rectForRow(at: zerothRowIndex)
//        zerothRowRect.origin.x = xCoordinate
//        let width = tableView.bounds.size.width
//
//        let isFirstCellVisible : Bool
//        if visibleRect.contains(zerothRowRect) {
//            isFirstCellVisible = true
//        }
//        else {
//            isFirstCellVisible = false
//        }
        
//        let index = tableView.tag - 1000
//        if let journey = self.viewModel.results[index].selectedJourney{
//            journeyHeaderViewArray[index].setValuesFrom(journey: journey)
//        }
////        let headerView = journeyHeaderViewArray[index]
//
//        let height : CGFloat = 138.0
//        journeyHeaderViewArray[index].isHidden = true
//        if isFirstCellVisible {
//
//            if headerView.isHidden {
//                height = 138.0
//            }
//            else {
//                height = 188.0
//            }
//        }

//        if let selectedIndex =  self.getSelectedIndex(for: tableView){ //tableView.indexPathForSelectedRow
//
//            if selectedIndex <= 4 {//selectedIndex.row
//                  height = 138.0
//            }
//        }
//
//        let rect = CGRect(x: 0.0, y: 0.0, width: width, height: height )
//        let tableHeaderView = UIView(frame: rect)
//        tableView.tableHeaderView = tableHeaderView
    }

    
    //MARK:- ScrollView Delegate Methods
   
    
    func changeContentOfssetWithMainScrollView(_ isNeedToAnimate:Bool = false){
        guard let blurView = self.navigationController?.view.viewWithTag(500) else  {return}
        UIView.animate(withDuration: isNeedToAnimate ? 0.3 : 0.0) {
            blurView.frame.origin.y = -self.baseScrollView.contentOffset.y
            self.headerCollectionView.frame.origin.y = (88.0 - self.baseScrollView.contentOffset.y)
            self.headerCollectionViewTop.constant = (88.0 - self.baseScrollView.contentOffset.y)
            self.view.layoutIfNeeded()
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
    
   
    
    func getSelectedIndex(for table: UITableView)-> Int?{
        let index = table.tag - 1000
        let tableState = viewModel.resultsTableStates[index]
        if tableState == .showPinnedFlights {
            return self.viewModel.results[index].pinnedFlights.firstIndex(where: {$0.fk == (self.viewModel.results[index].selectedJourney?.fk ?? "")})
        } else if tableState == .showExpensiveFlights {
            return self.viewModel.results[index].allJourneys.firstIndex(where: {$0.fk == (self.viewModel.results[index].selectedJourney?.fk ?? "")})
        } else if tableState == .showRegularResults{
         return self.viewModel.results[index].suggestedJourneyArray.firstIndex(where: {$0.fk == (self.viewModel.results[index].selectedJourney?.fk ?? "")})
        } else{
            return nil
        }
    }
}

//MARK: ScrollView delegate
extension FlightDomesticMultiLegResultVC: UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        scrollviewInitialYOffset = scrollView.contentOffset.y
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Synchronizing scrolling of headerCollectionView to baseScrollView scroll movement
        
        if !scrollView.isScrollEnabled{
            return
        }
        
        if scrollView == baseScrollView {
            self.syncScrollView(headerCollectionView, toScrollView: baseScrollView)
            if scrollView.contentOffset.y > 88.0{
                scrollView.contentOffset.y = 88.0
            }else{
                self.changeContentOfssetWithMainScrollView()
            }
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
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if scrollView != self.baseScrollView{
            if let tableView = scrollView as? UITableView{
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
//                delay(seconds: 0.4) {
//                    self.setTableViewHeaderFor(tableView: tableView)
//                }
            }
        }
        return false
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
            
            lastTargetContentOffsetX = targetContentOffset.pointee.x
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.tag > 999 {
            if let tableView = scrollView as? UITableView {
                animateJourneyCompactView(for: tableView)
                if !scrollView.isBouncingTop{
                    snapToTopOrBottomOnSlowScrollDragging(scrollView)
                }
                return
            }
        }
        else{
            if scrollView == self.baseScrollView && scrollView.contentOffset.y < 88.0{
                if scrollView.contentOffset.y < 44{
                    scrollView.contentOffset.y = 0.0
                }else{
                    scrollView.contentOffset.y = 88.0
                }
                self.changeContentOfssetWithMainScrollView(true)
            }
        }
        
    }
    
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        printDebug("ended")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let tableView = scrollView as? UITableView{
            let index = tableView.tag - 1000
            let headerView = journeyHeaderViewArray[index]
            guard headerView.isHidden || tableView.contentOffset.y == 0 else {return}
            UIView.animate(withDuration: 0.3) {
                self.setTableViewHeaderFor(tableView: tableView)
            }
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if let tableView = scrollView as? UITableView{
            setTableViewHeaderFor(tableView: tableView)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let tableView = scrollView as? UITableView{
            delay(seconds: 0.4) {
                self.animateJourneyCompactView(for: tableView, isHeaderNeedToSet: true)
            }
        }
    }
    
}
