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
    func hidingAnimationOnNavigationBarOnScroll(offsetDifference : CGFloat, scrollView: UIScrollView) {
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
                        if ((scrollView as? UITableView) == nil) && (self.headerCollectionViewTop.constant == 0.0){
                            self.setAllTableViewHeader()
                        }
                        
                    }
                    self.view.layoutIfNeeded()
                }
            } ,completion: nil)
        }
       }
    
    
    fileprivate func revealAnimationOfNavigationBarOnScroll(offsetDifference : CGFloat, scrollView: UIScrollView) {
        let invertedOffset = -offsetDifference
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
                
                if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
                    var rect = blurEffectView.frame
                    var yCordinate = invertedOffset - 86
                    yCordinate = min ( 0,  yCordinate)
                    if self.baseScrollView.contentOffset.y <= 0 || rect.origin.y == 0{
                        yCordinate = 0
                    }
                    rect.origin.y = yCordinate
                    blurEffectView.frame = rect
                    var baseViewContentOffset = self.baseScrollView.contentOffset
                    let newDiff = 86 - invertedOffset
                    baseViewContentOffset.y = max(0 , newDiff)
                    if self.baseScrollView.contentOffset.y <= 0{
                        baseViewContentOffset.y = 0
                    }
                    self.baseScrollView.setContentOffset(baseViewContentOffset, animated: false )
                    rect = self.collectionContainerView.frame
                    var yCordinateForHeaderView = (invertedOffset + 2.0)
                    if rect.origin.y >= 88{
                        yCordinateForHeaderView = 88.0
                    }
                    yCordinateForHeaderView = min(88.0 , yCordinateForHeaderView)
                    self.headerCollectionViewTop.constant = yCordinateForHeaderView
                    if ((scrollView as? UITableView) == nil) && (self.headerCollectionViewTop.constant == 88.0){
                        self.setAllTableViewHeader()
                    }
                    self.view.layoutIfNeeded()
                }
            } ,completion: nil)//{_ in self.setAllTableViewHeader()}
        }
    }

    func animateTopViewOnScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset
        let offsetDifference = contentOffset.y - scrollviewInitialYOffset
        
        if offsetDifference > 0 {
            self.hidingAnimationOnNavigationBarOnScroll(offsetDifference : offsetDifference, scrollView: scrollView)
        } else if offsetDifference < 0{
            self.revealAnimationOfNavigationBarOnScroll(offsetDifference : offsetDifference, scrollView: scrollView)
        }else if contentOffset.y == 0.0{
//            self.baseScrollView.contentOffset.y = 0.0
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
                hidingAnimationOnNavigationBarOnScroll(offsetDifference: 88.0, scrollView: scrollView)
                
            }
            else {  //If blurEffectView yCoodinate is close to fully visible state of blurView
                revealAnimationOfNavigationBarOnScroll(offsetDifference: (-88.0), scrollView: scrollView)
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
        guard let selectedIndex =  self.getSelectedIndex(for: tableView) else {
            if let _ =  self.viewModel.results[tableView.tag - 1000].selectedJourney{
                self.showHeaderCellAt(tableView: tableView)
            }
            return
        }//tableView.indexPathForSelectedRow
//        let visibleRect = getVisibleAreaRectFor(tableView: tableView)
        let xCoordinate = tableView.frame.origin.x
        let selectedRowIndex = IndexPath(row: selectedIndex, section: 0)
        var selectedRowRect = tableView.rectForRow(at: selectedRowIndex)
        selectedRowRect.origin.y = selectedRowRect.origin.y - tableView.contentOffset.y
        selectedRowRect.origin.x = xCoordinate
        if self.isRowCompletelyVisible(at: selectedRowIndex, for: tableView){
            let index = tableView.tag - 1000
            hideHeaderCellAt(index: index, isHeaderNeedSet: isHeaderNeedToSet)
        }
        else {
            showHeaderCellAt(tableView: tableView, isHeaderNeedSet: isHeaderNeedToSet)
        }
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
            let hiddenHeaderY:CGFloat = -44.0
            let headerJourneyRect  = CGRect(x: (width * CGFloat(index)), y: hiddenHeaderY , width: width - 1 , height: journeyCompactViewHeight)
            headerView.frame = headerJourneyRect
            UIView.animate(withDuration: 0.4, animations: {
                var rect = headerView.frame
                rect.origin.y = 0.0
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
        
        if !headerView.isHidden && !isHiddingHeader {
            isHiddingHeader = true
            UIView.animate(withDuration: 0.4, animations: {
                var frame = headerView.frame
                frame.origin.y =  -44.0//(self.headerCollectionViewTop.constant + self.headerCollectionView.height + self.baseScrollView.contentOffset.y - 44.0)//(-self.headerCollectionViewTop.constant - self.journeyCompactViewHeight)
                headerView.frame = frame
            }) { (completed) in
                headerView.isHidden = true
                self.isHiddingHeader = false
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
        
        _ = tableView.bounds.size.width
        let index = tableView.tag - 1000
        let headerView = journeyHeaderViewArray[index]
        
        let height : CGFloat
        if headerView.isHidden {
            height = 0.0//138.0
        }
        else {
            height = 44.0//188.0
        }
        
//        tableView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        
//        guard !((tableView.tableHeaderView?.height) == height) else {return}
//        let rect = CGRect(x: 0, y: 0, width: width, height: height )
//        let tableHeaderView = UIView(frame: rect)
//        tableView.tableHeaderView = tableHeaderView
        
        if  (height != initialHeader) || (!self.isSettingupHeader){
            self.isSettingupHeader = true
            self.initialHeader = height
            UIView.animate(withDuration: 0.05, animations: {
                tableView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
            }) { (_) in
                self.isSettingupHeader = false
            }
        }
    }
               

    func setTableViewHeaderAfterSelection(tableView  : UITableView) {
        let index = tableView.tag - 1000
        if let journey = self.viewModel.results[index].selectedJourney{
            self.journeyHeaderViewArray[index].setValuesFrom(journey: journey)
        }
        self.hideHeaderCellAt(index: index, isHeaderNeedSet: true)
    }

    
    //MARK:- ScrollView Delegate Methods
   
    
    func changeContentOfssetWithMainScrollView(_ isNeedToAnimate:Bool = true){
        guard let blurView = self.navigationController?.view.viewWithTag(500) else  {return}
        DispatchQueue.main.async {
            UIView.animate(withDuration: isNeedToAnimate ? 0.3 : 0.0) {
                self.collectionContainerView.origin.y = (88.0 - self.baseScrollView.contentOffset.y)
                self.headerCollectionViewTop.constant = (88.0 - self.baseScrollView.contentOffset.y)
                blurView.frame.origin.y = -self.baseScrollView.contentOffset.y
                if ((self.headerCollectionViewTop.constant == 88.0) || (self.headerCollectionViewTop.constant == 0.0)){
                    self.setAllTableViewHeader()
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func syncScrollView(_ scrollViewToScroll: UIScrollView, toScrollView scrolledView: UIScrollView) {
        
        var offset : CGFloat
        let screenWidth = UIScreen.main.bounds.size.width
        let tenPercentWidth = screenWidth * 0.1
        let halfWidth = screenWidth * 0.5
        let scrolledDistance =  scrolledView.contentOffset.x
        self.miniHeaderScrollView.contentOffset.x = scrolledDistance
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
                guard (!scrollView.isBouncingBottom && ((scrollView.contentSize.height - 5.0) > (scrollView.contentOffset.y + scrollView.height)) || (self.baseScrollView.contentOffset.y < 88)) else {
                    return
                }
                if subview == scrollView {
                    animateTopViewOnScroll(scrollView)
                    if let tableView = scrollView as? UITableView {
                        animateJourneyCompactView(for: tableView)
                        self.setTableViewHeaderFor(tableView: tableView)
                    }
                }
                else {
                    if let tableView = subview as? UIScrollView {
                        if tableView.contentOffset.y < 0{
                            tableView.contentOffset.y = 0
                        }else{
                            tableView.setContentOffset(tableView.contentOffset, animated: false)
                        }
                    }
                }
            }
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if scrollView != self.baseScrollView{
            if let tableView = scrollView as? UITableView{
                if let index = self.getSelectedIndex(for: tableView){
                    if index < 5{
                        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    }else{
                        tableView.contentInset = UIEdgeInsets(top: 44.0, left: 0, bottom: 0, right: 0)
                    }
                    
                }
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
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
                if !scrollView.isBouncingBottom{
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
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let tableView = scrollView as? UITableView{
            let index = tableView.tag - 1000
            let headerView = journeyHeaderViewArray[index]
            guard headerView.isHidden || tableView.contentOffset.y == 0 else {return}
            UIView.animate(withDuration: 0.3) {
                self.setTableViewHeaderFor(tableView: tableView)
                if scrollView.contentOffset.y == 0{
//                    self.baseScrollView.contentOffset.y = 0
                }
            }
        }
        if self.baseScrollView.contentOffset.y < 88.0{
            if self.baseScrollView.contentOffset.y < 44{
                self.baseScrollView.contentOffset.y = 0.0
            }else{
                self.baseScrollView.contentOffset.y = 88.0
            }
            self.changeContentOfssetWithMainScrollView(true)
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if let tableView = scrollView as? UITableView{
            setTableViewHeaderFor(tableView: tableView)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let tableView = scrollView as? UITableView{
            delay(seconds: 0.2) {
                self.animateJourneyCompactView(for: tableView, isHeaderNeedToSet: true)
                self.setAllTableViewHeader()
            }
        }
        if self.baseScrollView.contentOffset.y < 88.0{
            if self.baseScrollView.contentOffset.y < 44{
                self.baseScrollView.contentOffset.y = 0.0
            }else{
                self.baseScrollView.contentOffset.y = 88.0
            }
            self.changeContentOfssetWithMainScrollView(true)
        }
    }
    
    func setAllTableViewHeader(){
        delay(seconds: 0.2) {
            for subView in self.baseScrollView.subviews{
                if let tableView = subView as? UITableView{
                    DispatchQueue.main.async {
                        self.animateJourneyCompactView(for: tableView, isHeaderNeedToSet: true)
                    }
                }
            }
        }
    }
    
}


extension FlightDomesticMultiLegResultVC{
    
    public func boundsWithoutInset(for tableView: UITableView)-> CGRect{
        var boundsWithoutInset = tableView.bounds
        let colletionSpace = self.headerCollectionViewTop.constant + self.headerCollectionView.height
        boundsWithoutInset.origin.y += (tableView.contentInset.top + colletionSpace + self.baseScrollView.contentOffset.y) + 10
        let insetOnTop:CGFloat = (colletionSpace <= 50) ? 20 : (colletionSpace + 50)
        boundsWithoutInset.size.height -= (tableView.contentInset.top + tableView.contentInset.bottom + insetOnTop + 50 + self.baseScrollView.contentOffset.y)
        return boundsWithoutInset
    }

    public func isRowCompletelyVisible(at indexPath: IndexPath, for tableView: UITableView) -> Bool {
        let rect = tableView.rectForRow(at: indexPath)
//        let rectWithRespectToView = tableView.convert(rect, from: self.view)
//        printDebug("rectWithRespectToView\(rectWithRespectToView)")
        return self.boundsWithoutInset(for: tableView).intersects(rect)
    }
    
}
