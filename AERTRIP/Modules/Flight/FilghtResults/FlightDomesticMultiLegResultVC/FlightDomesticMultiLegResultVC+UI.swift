//
//  FlightDomesticMultiLegResultVC.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit
import SnapKit

extension FlightDomesticMultiLegResultVC {
    
        
    func setupHeaderView() {
        let rect = CGRect(x: 0, y: self.headerCollectionViewTop.constant , width: UIScreen.main.bounds.size.width, height: 165)
        self.bannerView = ResultHeaderView(frame: rect)
        self.bannerView?.frame = rect
        self.view.addSubview(self.bannerView!)
    }
    
    func setupPinnedFlightsOptionsView() {
        
        pinnedFlightOptionsTop.constant = 0
        
        
        showPinnedSwitch.tintColor = UIColor.TWO_ZERO_FOUR_COLOR
        showPinnedSwitch.isOn = false
        showPinnedSwitch.setupUI()
        
        hidePinnedFlightOptions(true)
        addShadowTo(unpinnedAllButton)
        addShadowTo(emailPinnedFlights)
        addShadowTo(sharePinnedFilghts)
        
    }
    
    
    func addShadowTo(_ view : UIView) {
        
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func setupScrollView() {
        
        //        self.view.addSubview(debugVisibilityView)
        //        debugVisibilityView.backgroundColor = .red
        //        debugVisibilityView.layer.zPosition = 100
        //
        //
        //        self.view.addSubview(firstVisibleRectView)
        //        firstVisibleRectView.backgroundColor = .yellow
        //        firstVisibleRectView.layer.zPosition = 150
        
        let width =  UIScreen.main.bounds.size.width / 2.0
        let height = self.baseScrollView.frame.height
        baseScrollView.contentSize = CGSize( width: (CGFloat(numberOfLegs) * width ), height:height + 88.0)
        baseScrollView.showsHorizontalScrollIndicator = false
        baseScrollView.showsVerticalScrollIndicator = false
        baseScrollView.delegate = self
        baseScrollView.bounces = false
        baseScrollView.isDirectionalLockEnabled = true
        for i in 0 ..< numberOfLegs {
            setupTableView(At: i)
        }
    }
    
    
    func setupTableView(At index : Int) {
        
        let width = UIScreen.main.bounds.width / 2.0
        let height = UIScreen.main.bounds.height
        let rect = CGRect(x: (width * CGFloat(index)), y: 0, width: width, height: height)
        
        
        let tableView = UITableView(frame: rect)
        tableView.dataSource = self
        tableView.tag = 1000 + index
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        tableView.isScrollEnabled = false
        tableView.scrollsToTop = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "DomesticMultiLegCell", bundle: nil), forCellReuseIdentifier: "DomesticMultiLegCell")
        tableView.register(UINib(nibName: "DomesticMultiLegTemplateCell", bundle: nil), forCellReuseIdentifier: "DomesticMultiLegTemplateCell")
        
        
        let headerRect = CGRect(x: 0, y: 0, width: width, height: 254.0)
        let tableViewHeader = UIView(frame: headerRect)
        
        let separatorView = UIView(frame:CGRect(x: 0, y: 253.5, width: width, height: 0.5))
        separatorView.backgroundColor = .TWO_ZERO_FOUR_COLOR
        tableViewHeader.addSubview(separatorView)
        tableView.tableHeaderView = tableViewHeader
        
        let boarderRect = CGRect(x: ((width * CGFloat(index + 1)) - 1), y: 0, width: 0.5, height: height)
        let borderView = UIView(frame: boarderRect)
        borderView.backgroundColor = .TWO_ZERO_FOUR_COLOR
        
        baseScrollView.addSubview(tableView)
        baseScrollView.addSubview(borderView)
        
        setupCompactJourneyView(width, index)
    }
    func setupCollectionView() {
        
        headerCollectionView.register( UINib(nibName: "FlightSectorHeaderCell", bundle: nil), forCellWithReuseIdentifier: "HeaderCollectionView")
        headerCollectionView.bounces = false
        headerCollectionView.isScrollEnabled = false
    }
    
    
    
    fileprivate func setupCompactJourneyView(_ width: CGFloat, _ index: Int) {
        
        let headerJourneyRect  = CGRect(x: (width * CGFloat(index)), y: (-journeyCompactViewHeight) , width: width - 1 , height: journeyCompactViewHeight)
        let headerJourneyView = JourneyHeaderView(frame: headerJourneyRect)
        headerJourneyView.tag = 1000 + index
        journeyHeaderViewArray.append(headerJourneyView)
        
        baseScrollView.addSubview(headerJourneyView)
        headerJourneyView.isHidden = true
        hideHeaderCellAt(index: index)
    }
    
    
    //MARK:- Additional UI Methods
    
    func animateTableBanner(index : Int , updatedArray : [Journey] , sortOrder :Sort)  {
        if bannerView?.isHidden == false {
            guard let headerView = bannerView  else { return }
            
            var rect = headerView.frame
            baseScrollViewTop.constant = 0
            
            UIView.animate(withDuration: 1.0 , animations: {
                let y = rect.origin.y - rect.size.height - 20
                rect.origin.y = y
                headerView.frame = rect
                self.view.layoutIfNeeded()
                
                for subview in self.baseScrollView.subviews {
                    
                    if let tableView = subview as? UITableView {
                        let width = UIScreen.main.bounds.size.width / 2.0
                        let headerRect = CGRect(x: 0, y: 0, width: width, height: 138.0)
                        tableView.tableHeaderView = UIView(frame: headerRect)
                    }
                }
                
            }) { (bool) in
                
                self.baseScrollView.setContentOffset(CGPoint(x: 0, y: 0) , animated: false)
                self.bannerView?.isHidden = true
                self.updateUI(index: index, updatedArray : updatedArray, sortOrder: sortOrder)
            }
        }
        else {
            self.updateUI(index: index , updatedArray: updatedArray, sortOrder: sortOrder)
        }
        
    }
    
    func addErrorScreenAtIndex(index: Int , forFilteredResults: Bool )
    {
        if let tableview = baseScrollView.viewWithTag(1000 + index) as? UITableView {
            
            resultsTableViewStates[index] = .showNoResults
            tableview.tableFooterView = nil
            tableview.reloadData()
        }
        let noResultsView : NoResultScreenView
        if let errorView = baseScrollView.viewWithTag( 500 + index) as? NoResultScreenView {
            noResultsView = errorView
            baseScrollView.addSubview(noResultsView)
        }
        else {
            var rect = CGRect()
            let width = UIScreen.main.bounds.size.width / 2.0
            
            let headerCollectionviewHeight = headerCollectionView.frame.size.height
            rect.origin.x = CGFloat(index) * width + 1.0
            rect.origin.y = self.headerCollectionViewTop.constant + headerCollectionviewHeight
            rect.size.height = baseScrollView.bounds.size.height - 50
            rect.size.width = width - 2.0
            
            noResultsView = NoResultScreenView(frame: rect)
            let state = resultsTableViewStates[index]
            if state == .showPinnedFlights {
                noResultsView.delegate = self
            }
            else {
                noResultsView.delegate = self.parent as? NoResultScreenDelegate
            }
            noResultsView.frame = rect
            noResultsView.tag = ( 500 + index)
            baseScrollView.addSubview(noResultsView)
        }
        
        if forFilteredResults {
            noResultsView.showNoFilteredResults()
        }
        else {
            noResultsView.showNoResultsMode()
        }
    }
    
    func clearFilters() {
        
    }
    
    func restartFlightSearch() {
        // empty implementation
    }
    
    //MARK:- Fare Breakup View Methods
    
    fileprivate func setTotalFare() {
        if let selectedJourneys = self.getSelectedJourneyForAllLegs() {
            if selectedJourneys.count == numberOfLegs {
                ShowFareBreakupView()
            }
        }
        else {
            hideFareBreakupView()
        }
    }
    
    func setupBottomView() {
        
        testView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        testView.tag = 5100
        self.navigationController?.view.addSubview(testView)
//        self.navigationController?.addChild(fareBreakupVC)
//        fareBreakupVC.didMove(toParent: self.navigationController)

        
        let fareBreakupVC = FareBreakupVC(nibName: "FareBreakupVC", bundle: nil)
        fareBreakupVC.taxesResult = taxesResult
        fareBreakupVC.journey = getSelectedJourneyForAllLegs()
        fareBreakupVC.sid = sid
        fareBreakupVC.flightAdultCount = bookFlightObject.flightAdultCount
        fareBreakupVC.flightChildrenCount = bookFlightObject.flightChildrenCount
        fareBreakupVC.flightInfantCount = bookFlightObject.flightInfantCount
        fareBreakupVC.view.autoresizingMask = []
        fareBreakupVC.delegate = self
        fareBreakupVC.view.tag = 2500
        fareBreakupVC.modalPresentationStyle = .overCurrentContext
        
        var isFSRVisible = false
        if let selectedJourney = getSelectedJourneyForAllLegs(){
            for i in 0..<selectedJourney.count{
                let fk = selectedJourney[i].fk
                fareBreakupVC.selectedJourneyFK.append(fk)
                if selectedJourney[i].fsr == 1{
                    isFSRVisible = true
                }
            }
        }
        
        if isFSRVisible == true{
            fareBreakupVC.fewSeatsLeftViewHeightFromFlightDetails = 40
        }else{
            fareBreakupVC.fewSeatsLeftViewHeightFromFlightDetails = 0
        }
        
        
        let ts = CATransition()
        ts.type = .moveIn
        ts.subtype = .fromTop
        ts.duration = 0.4
        ts.timingFunction = .init(name: CAMediaTimingFunctionName.easeOut)
        fareBreakupVC.view.layer.add(ts, forKey: nil)
        self.navigationController?.view.addSubview(fareBreakupVC.view)
        self.navigationController?.addChild(fareBreakupVC)
        fareBreakupVC.didMove(toParent: self.navigationController)
        
        self.fareBreakupVC = fareBreakupVC
        
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
            
            self.checkForComboFares()
            
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
    
    //MARK:- PinnedFlightsOption View Methods
    func hidePinnedFlightOptions( _ hide : Bool) {
        
        let optionViewWidth : CGFloat =  hide ? 50.0 : 212.0
        let unpinButtonLeading : CGFloat = hide ? 0.0 : 60.0
        let emailButton : CGFloat = hide ? 0.0 : 114.0
        let shareButtonLeading : CGFloat =
            hide ?  0.0 : 168.0
        
        if !hide {
            self.emailPinnedFlights.isHidden = hide
            self.unpinnedAllButton.isHidden = hide
            self.sharePinnedFilghts.isHidden = hide
        }
        
        pinOptionsViewWidth.constant = optionViewWidth
        unpinAllLeading.constant = unpinButtonLeading
        emailPinnedFlightLeading.constant = emailButton
        sharePinnedFlightsLeading.constant = shareButtonLeading
        
        UIView.animate(withDuration: 0.1, delay: 0.0 ,
                       options: []
            , animations: {
                
                self.view.layoutIfNeeded()
                
        }) { (onCompletion) in
            if hide {
                self.emailPinnedFlights.isHidden = hide
                self.unpinnedAllButton.isHidden = hide
                self.sharePinnedFilghts.isHidden = hide
            }
        }
    }
    
    func showPinnedFlightSwitch(_ show  : Bool) {
        
        DispatchQueue.main.async {
            
            let bottomInset = self.view.safeAreaInsets.bottom
            var height :  CGFloat = 0.0
            
            if show {
                height =  60.0
                height = height + bottomInset
                
                if self.fareBreakupVC?.view.isHidden == false {
                    height = height + 50
                }
            }
            else {
                height = 0.0
            }
            
            self.pinnedFlightOptionsTop.constant = CGFloat(height)
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
}

extension FlightDomesticMultiLegResultVC : FareBreakupVCDelegate , flightDetailsPinFlightDelegate
{
    func reloadRowFromFlightDetails(fk: String, isPinned: Bool) {
        for index in 0 ..< numberOfLegs {
                   
                   let tableResultState = resultsTableViewStates[index]
                   if tableResultState == .showTemplateResults {  return  }
                   
                   if let tableView = baseScrollView.viewWithTag( 1000 + index ) as? UITableView {
                       
                       guard let selectedIndex = tableView.indexPathForSelectedRow else {
                           return  }
                       
                       if let cell = tableView.cellForRow(at: selectedIndex) as? DomesticMultiLegCell {
                           cell.setPinnedFlight()
                           cell.smartIconsArray = cell.currentJourney?.smartIconArray
                           cell.smartIconCollectionView.reloadData()

                       }
                   }
                   
               }
    }
    func infoButtonTapped(isViewExpanded: Bool) {
        
        if isViewExpanded == true{
            testView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.testView.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.2)
            })
        }else{
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.testView.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
            },completion: { _ in
                self.testView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            })
        }
    }
    
    func bookButtonTapped(journeyCombo: [CombinationJourney]?) {
            let storyboard = UIStoryboard(name: "FlightDetailsBaseVC", bundle: nil)
            
            
            let flightDetailsVC:FlightDetailsBaseVC =
                storyboard.instantiateViewController(withIdentifier: "FlightDetailsBaseVC") as! FlightDetailsBaseVC
    
            flightDetailsVC.delegate = self
            flightDetailsVC.bookFlightObject = self.bookFlightObject
            flightDetailsVC.taxesResult = self.taxesResult
            flightDetailsVC.sid = sid
            flightDetailsVC.journey = getSelectedJourneyForAllLegs()
            flightDetailsVC.titleString = titleString
            flightDetailsVC.airportDetailsResult = airportDetailsResult
            flightDetailsVC.airlineDetailsResult = airlineDetailsResult
    
            if let allJourneyObj = getSelectedJourneyForAllLegs(){
                for i in 0..<allJourneyObj.count{
                    let fk = allJourneyObj[i].fk
                    flightDetailsVC.selectedJourneyFK.append(fk)
                }
            }
            flightDetailsVC.journeyCombo = journeyCombo
            self.present(flightDetailsVC, animated: true, completion: nil)
    }
    
    func updateAirportDetailsArray(_ results : [String : AirportDetailsWS])
    {
        airportDetailsResult = results
    }
    
    func updateAirlinesDetailsArray(_ results : [String : AirlineMasterWS])
    {
        airlineDetailsResult = results
    }
    
    func updateTaxesArray(_ results : [String : String])
    {
        taxesResult = results
    }
}

//MARK:- UIContextMenuInteractionDelegate Method
@available(iOS 13.0, *) extension FlightDomesticMultiLegResultVC : UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let locationInScrollView = interaction.location(in: self.baseScrollView)
            let width = UIScreen.main.bounds.width / 2
            let index = Int(locationInScrollView.x / width )
            
            
            if let tableview = self.baseScrollView.viewWithTag(1000 + index) as? UITableView {
                
                let locationInTableView = interaction.location(in: tableview)
                if let indexPath = tableview.indexPathForRow(at: locationInTableView) {
                    
                    var arrayForDisplay = self.results[index].suggestedJourneyArray
                    let tableState = self.resultsTableViewStates[index]
                    
                    if self.sortOrder == .Smart || self.sortOrder == .Price {
                        
                        if tableState == .showExpensiveFlights && indexPath.section == 1 {
                            arrayForDisplay = self.results[index].expensiveJourneyArray
                        }
                    }
                    else {
                        arrayForDisplay =  self.sortedJourneyArray[index]
                    }
                    if tableState == .showPinnedFlights {
                        arrayForDisplay = self.results[index].pinnedFlights
                    }
                    
                    if let journey = arrayForDisplay?[indexPath.row] {
                        return self.makeMenus(journey : journey, indexPath: indexPath , tableIndex: index)
                    }
                }
            }
            // should not come here following code is to silent the warnring
            return self.makeMenus(journey : nil, indexPath: IndexPath(row: 0, section: 0), tableIndex: 0)
        }
    }
    
    func makeMenus(journey : Journey? , indexPath : IndexPath , tableIndex : Int) -> UIMenu {
        
        guard let currentJourney = journey else { return  UIMenu(title: "", children: [])  }
        let isPinned = currentJourney.isPinned ?? false
        let flightKey  = currentJourney.fk
        let pinTitle : String
        if isPinned {
            pinTitle = "Unpin"
        }
        else {
            pinTitle = "Pin"
        }
        
        let pin = UIAction(title:  pinTitle, image: UIImage(systemName: "pin" ), identifier: nil) { (action) in
            self.setPinnedFlightAt(flightKey : flightKey ,  indexPath : indexPath , isPinned : !isPinned, tableIndex : tableIndex)
        }
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil) { (action) in
            self.shareFlights(journeyArray: [currentJourney])
        }
        let addToTrip = UIAction(title: "Add To Trip", image: UIImage(systemName: "map" ), identifier: nil) { (action) in
            self.addToTrip(journey: currentJourney)
        }
        
        // Create and return a UIMenu with all of the actions as children
        return UIMenu(title: "", children: [pin, share, addToTrip])
    }
}


//FIXME:- 2) Method to get jounrney object from indexpath  for current sorting method
//FIXME:- 3) Common method for pin , share and add to trip
