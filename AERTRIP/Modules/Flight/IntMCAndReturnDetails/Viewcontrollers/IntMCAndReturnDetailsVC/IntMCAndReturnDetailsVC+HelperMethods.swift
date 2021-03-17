//
//  IntMCAndReturnDetailsVC+HelperMethods.swift
//  Aertrip
//
//  Created by Apple  on 17.04.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation
import UIKit

extension IntMCAndReturnDetailsVC{
   
    
    func  getSelectedJourneyForAllLegs() -> [IntJourney]? {
        var selectedJourneys = [IntJourney]()
        
        for index in 0 ..< self.viewModel.numberOfLegs {
            
            if let tableView = baseScrollView.viewWithTag( 1000 + index ) as? UITableView {
                
                guard let selectedIndex = tableView.indexPathForSelectedRow else {
                    return nil }
                let currentJourney = self.viewModel.results[index][selectedIndex.row]
                selectedJourneys.append(currentJourney)
                
            }
        }
        if selectedJourneys.count == self.viewModel.numberOfLegs {
            self.viewModel.selectedJourney = selectedJourneys
            return selectedJourneys
        }
        printDebug("getSelectedJourneyForAllLegs return five")
        return nil
    }
    
}

extension IntMCAndReturnDetailsVC {
    
    
    //MARK:- NavigationView Animation
    func hidingAnimationOnNavigationBarOnScroll(offsetDifference : CGFloat){
       }
    
    
    func revealAnimationOfNavigationBarOnScroll(offsetDifference : CGFloat) {
    }
    
    func animateTopViewOnScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset
        let offsetDifference = contentOffset.y - scrollviewInitialYOffset
        
        if offsetDifference > 0 {
            self.hidingAnimationOnNavigationBarOnScroll(offsetDifference : offsetDifference)
        }
        else {
            self.revealAnimationOfNavigationBarOnScroll(offsetDifference : offsetDifference)
        }
    }
    
    
    fileprivate func snapToTopOrBottomOnSlowScrollDragging(_ scrollView: UIScrollView) {

        if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
            let rect = blurEffectView.frame
            let yCoordinate = rect.origin.y * ( -1 )
            let visualEffectViewHeight =  CGFloat(44.0)
//            // After dragging if blurEffectView is at top or bottom position , snapping animation is not required
            if yCoordinate == 0 || yCoordinate == ( -visualEffectViewHeight){
                return
            }
//
//            // If blurEffectView yCoodinate is close to top of the screen
            if  ( yCoordinate > ( visualEffectViewHeight / 2.0 ) ){
                hidingAnimationOnNavigationBarOnScroll(offsetDifference: 44.0)
                
            }
            else {  //If blurEffectView yCoodinate is close to fully visible state of blurView
                revealAnimationOfNavigationBarOnScroll(offsetDifference: (44.0))
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
    
    func updateUIForTableviewAt(_ index: Int) {
        DispatchQueue.main.async {
            if index < self.viewModel.numberOfLegs - 1{
                if let tableView = self.baseScrollView.viewWithTag( 1000 + index) as? UITableView {
                    var selectedIndex = tableView.indexPathForSelectedRow
                    // setting up header for table view
                    let width = UIScreen.main.bounds.size.width / 2.0
                    let headerRect = CGRect(x: 0, y: 0, width: width, height: 94.0)
                    tableView.tableHeaderView = UIView(frame: headerRect)
                    
                    //selecting tableview cell
                    guard (self.viewModel.results[index].count > 0) else {return}
                    if (selectedIndex != nil) {
                        tableView.selectRow(at:selectedIndex, animated: false, scrollPosition: .none)
                    }else{
                        let indx = self.viewModel.results[index].firstIndex(where:{$0.id == self.viewModel.selectedJourney[index].id}) ?? 0
                        let indexPath = IndexPath(row: indx, section: 0)
                        selectedIndex = indexPath
                        tableView.selectRow(at: selectedIndex , animated: true, scrollPosition: .none)
                    }
                    if selectedIndex != nil{
                        self.updateSeleted(indexPath: selectedIndex!, table: tableView)
                    }
                    tableView.isScrollEnabled = true
                }
            }
            self.setTotalFare()
        }
    }

     func setTotalFare() {
        if let selectedJourneys = self.getSelectedJourneyForAllLegs() {
            
            if selectedJourneys.count == self.viewModel.numberOfLegs {
                ShowFareBreakupView()
            }
        }
        else {
            hideFareBreakupView()
        }
        
    }
    
    func ShowFareBreakupView() {
        
        DispatchQueue.main.async {
            if self.fareBreakupVC == nil {

                let bottomInset = self.view.safeAreaInsets.bottom
                self.scrollViewBottomConstraint.constant = 50 + bottomInset
                self.setupBottomView()
            }

            guard let fareBreakupViewController =  self.fareBreakupVC else { return }
            var isFSRVisible = false
            if let selectedJourney = self.getSelectedJourneyForAllLegs(){
                for i in 0..<selectedJourney.count{
                    let fk = selectedJourney[i].fk
                    fareBreakupViewController.selectedJourneyFK.append(fk)

                    if selectedJourney[i].fsr == 1{
                        isFSRVisible = true
                    }

                }
            }
            if fareBreakupViewController.isFareBreakupExpanded {
                fareBreakupViewController.infoButtonTapped()
            }

            if isFSRVisible == true{
                fareBreakupViewController.fewSeatsLeftViewHeightFromFlightDetails = 40
            }else{
                fareBreakupViewController.fewSeatsLeftViewHeightFromFlightDetails = 0
            }
            fareBreakupViewController.setupUpgradeButton(isHidden: !self.viewModel.selectedCompleteJourney.otherFares)
            fareBreakupViewController.journey = self.getSelectedJourneyForAllLegs()
            fareBreakupViewController.taxesDataDisplay()
            fareBreakupViewController.initialDisplayView()
            fareBreakupViewController.view.isHidden = false
        }
    }
    
    func hideFareBreakupView() {
        DispatchQueue.main.async {
            self.scrollViewBottomConstraint.constant = 0.0
            guard var rect = self.fareBreakupVC?.view.frame else { return }
            rect.origin.y =  self.view.frame.height
            self.fareBreakupVC?.view.frame = rect
            self.fareBreakupVC?.view.isHidden = true
        }
    }
    
    
    func setupBottomView() {
        
        viewForFare.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        viewForFare.tag = 5100
        self.view.addSubview(viewForFare)
        
        let vc = IntFareBreakupVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
        vc.taxesResult = self.viewModel.taxesResult
        vc.journey = getSelectedJourneyForAllLegs()
        vc.sid = self.viewModel.sid
        vc.isHideUpgradeOption = !self.viewModel.selectedCompleteJourney.otherFares
        vc.bookFlightObject = self.viewModel.bookFlightObject
        vc.view.autoresizingMask = []
        vc.delegate = self
        vc.view.tag = 2500
        vc.modalPresentationStyle = .overCurrentContext
        
        var isFSRVisible = false
        if let selectedJourney = getSelectedJourneyForAllLegs(){
            for i in 0..<selectedJourney.count{
                let fk = selectedJourney[i].fk
                vc.selectedJourneyFK.append(fk)
                if selectedJourney[i].fsr == 1{
                    isFSRVisible = true
                }
            }
        }
        
        if isFSRVisible == true{
            vc.fewSeatsLeftViewHeightFromFlightDetails = 40
        }else{
            vc.fewSeatsLeftViewHeightFromFlightDetails = 0
        }
        let ts = CATransition()
        ts.type = .moveIn
        ts.subtype = .fromTop
        ts.duration = 0.4
        ts.timingFunction = .init(name: CAMediaTimingFunctionName.easeOut)
        vc.view.layer.add(ts, forKey: nil)
        self.view.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
        self.fareBreakupVC = vc
        
    }
    
    
    //MARK:- ScrollView Delegate Methods
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        scrollviewInitialYOffset = scrollView.contentOffset.y
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Synchronizing scrolling of headerCollectionView to baseScrollView scroll movement
        if scrollView == baseScrollView {
            self.syncScrollView(headerCollection, toScrollView: baseScrollView)
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
//                    if let tableView = subview as? UIScrollView {
//                        tableView.setContentOffset(tableView.contentOffset, animated: false)
//                    }
                }
            }
        }
    }
    
    func syncScrollView(_ scrollViewToScroll: UIScrollView, toScrollView scrolledView: UIScrollView) {
        
        var offset : CGFloat
        let screenWidth = UIScreen.width
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
        
//        if scrollView.tag > 999 {
            if let tableView = scrollView as? UITableView {
                setTableViewHeaderFor(tableView: tableView)
                snapToTopOrBottomOnSlowScrollDragging(scrollView)
                return
            }else{
                snapToTopOrBottomOnSlowScrollDragging(scrollView)
        }
//        }

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
}

extension IntMCAndReturnDetailsVC : FareBreakupVCDelegate{
    func bookButtonTapped(journeyCombo: [CombinationJourney]?) {
        let flightDetailsVC = FlightDetailsBaseVC.instantiate(fromAppStoryboard: .FlightDetailsBaseVC)
        flightDetailsVC.delegate = self
        flightDetailsVC.isConditionReverced = isConditionReverced
        flightDetailsVC.appliedFilterLegIndex = appliedFilterLegIndex
        flightDetailsVC.isInternational = true
        flightDetailsVC.bookFlightObject = self.viewModel.bookFlightObject
        flightDetailsVC.taxesResult = self.viewModel.taxesResult
        flightDetailsVC.sid = self.viewModel.sid
        flightDetailsVC.intJourney = [self.viewModel.selectedCompleteJourney]
        flightDetailsVC.intAirportDetailsResult = self.viewModel.airportDetailsResult
        flightDetailsVC.intAirlineDetailsResult = self.viewModel.airlineDetailsResult
        flightDetailsVC.selectedJourneyFK = [self.viewModel.selectedCompleteJourney.fk]
        flightDetailsVC.refundDelegate = refundDelegate
        self.present(flightDetailsVC, animated: true, completion: nil)
    }
    
    func infoButtonTapped(isViewExpanded: Bool) {
        
        if isViewExpanded{
            viewForFare.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.viewForFare.backgroundColor = AppColors.blackWith20PerAlpha
            })
        }else{
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.viewForFare.backgroundColor = AppColors.clear
            },completion: { _ in
                self.viewForFare.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            })
        }
        
    }
    
    func tapUpgradeButton() {
        let vc = UpgradePlanContrainerVC.instantiate(fromAppStoryboard:.InternationalReturnAndMulticityDetails)
        vc.viewModel.oldIntJourney = [self.viewModel.selectedCompleteJourney]
        vc.viewModel.sid = self.viewModel.sid
        vc.viewModel.isInternational = true
        vc.viewModel.selectedJourneyFK = [self.viewModel.selectedCompleteJourney.fk]
        vc.viewModel.flightAdultCount = self.viewModel.bookFlightObject.flightAdultCount
        vc.viewModel.flightChildrenCount = self.viewModel.bookFlightObject.flightAdultCount
        vc.viewModel.flightInfantCount = self.viewModel.bookFlightObject.flightAdultCount
        vc.viewModel.bookingObject = self.viewModel.bookFlightObject
        vc.viewModel.taxesResult = self.viewModel.taxesResult
        self.present(vc, animated: true, completion: nil)
    }
}


extension IntMCAndReturnDetailsVC : ShowMessageDelegate{
    func updateSeleted() {
        _ = self.getSelectedJourneyForAllLegs()
    }
    
    
    func showTost(msg: String) {
        var frame = self.view.frame
        let bottomInset = self.view.safeAreaInsets.bottom
        let height = 50 + bottomInset
        frame.size.height = frame.size.height - height
        AertripToastView.toast(in: self.view , withText: msg , parentRect: frame)
//        AertripToastView.toast(in: self.view, withText: msg)
    }
    
}
