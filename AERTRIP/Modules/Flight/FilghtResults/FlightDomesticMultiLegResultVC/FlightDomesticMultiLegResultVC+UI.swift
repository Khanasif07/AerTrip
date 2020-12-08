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
        let rect = CGRect(x: 0, y: self.headerCollectionViewTop.constant + 52 , width: UIScreen.main.bounds.size.width, height: 165)
        self.bannerView = ResultHeaderView(frame: rect)
        self.bannerView?.frame = rect
        self.view.addSubview(self.bannerView!)
        self.baseScrollView.isScrollEnabled = false
        self.view.bringSubviewToFront(self.collectionContainerView)
    }
    
    func setupPinnedFlightsOptionsView() {
        
        switchView.delegate = self
        switchView.tintColor = UIColor.TWO_ZERO_FOUR_COLOR
        switchView.offTintColor = UIColor.TWO_THREE_ZERO_COLOR
        switchView.onTintColor = AppColors.themeGreen
        switchView.onThumbImage = #imageLiteral(resourceName: "pushpin")
        switchView.offThumbImage = #imageLiteral(resourceName: "pushpin-gray")
        switchView.setupUI()
        delay(seconds: 0.6) {
            self.switchView.isOn = false
        }
        
        showPinnedFlightsOption(false)
        
        hideOrShowPinnedButtons(show : false)
        
        addShadowTo(unpinnedAllButton)
        addShadowTo(emailPinnedFlights)
        addShadowTo(sharePinnedFilghts)
    }
    
    func addShadowTo(_ view : UIView)
    {
        view.layer.shadowOpacity = 0.1
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func setupScrollView(){
        let width =  UIScreen.main.bounds.size.width / 2.0
        let height = self.baseScrollView.frame.height
        baseScrollView.contentSize = CGSize( width: (CGFloat(self.viewModel.numberOfLegs) * width ), height:height + 88.0)
        baseScrollView.showsHorizontalScrollIndicator = false
        baseScrollView.showsVerticalScrollIndicator = false
        baseScrollView.alwaysBounceVertical = false
        baseScrollView.delegate = self
        baseScrollView.bounces = false
        baseScrollView.isDirectionalLockEnabled = true
        self.setupHeaderScrollView()
        for i in 0 ..< self.viewModel.numberOfLegs {
            setupTableView(At: i)
        }
    }
    
    func setupHeaderScrollView(){
        let width =  UIScreen.width / 2.0
        miniHeaderScrollView.contentSize = CGSize(width: (CGFloat(self.viewModel.numberOfLegs) * width ), height: 44.0)
        miniHeaderScrollView.showsHorizontalScrollIndicator = false
        miniHeaderScrollView.showsVerticalScrollIndicator = false
        miniHeaderScrollView.alwaysBounceVertical = false
        miniHeaderScrollView.delegate = nil
        miniHeaderScrollView.bounces = false
        miniHeaderScrollView.isScrollEnabled = false
    }
    
    
    func setupTableView(At index : Int) {
        
        let width = UIScreen.main.bounds.width / 2.0
        let height = UIScreen.main.bounds.height
        let rect = CGRect(x: (width * CGFloat(index)), y: 170, width: width, height: height)
        let tableView = UITableView(frame: rect)
        tableView.dataSource = self
        tableView.tag = 1000 + index
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        tableView.isScrollEnabled = false
        //        tableView.scrollsToTop = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "DomesticMultiLegCell", bundle: nil), forCellReuseIdentifier: "DomesticMultiLegCell")
        tableView.register(UINib(nibName: "DomesticMultiLegTemplateCell", bundle: nil), forCellReuseIdentifier: "DomesticMultiLegTemplateCell")
        
        
        let headerRect = CGRect(x: 0, y: 0, width: width, height: 138)
        let tableViewHeader = UIView(frame: headerRect)
        
//        let separatorView = ATDividerView()//UIView(frame:CGRect(x: 0, y: 137.5, width: width, height: 0.5))
//        separatorView.frame = CGRect(x: 0, y: 137.5, width: width, height: 0.5)
//        separatorView.backgroundColor = .TWO_ZERO_FOUR_COLOR
//        tableViewHeader.addSubview(separatorView)
        tableView.tableHeaderView = tableViewHeader
        
        let boarderRect = CGRect(x: ((width * CGFloat(index + 1)) - 1), y: 307.5, width: 0.5, height: height)
        let borderView = ATVerticalDividerView()
        borderView.frame = boarderRect//UIView(frame: boarderRect)
        borderView.backgroundColor = .TWO_ZERO_FOUR_COLOR
//        borderView.tag = 300 + index
        
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
        miniHeaderScrollView.addSubview(headerJourneyView)
//        baseScrollView.addSubview(headerJourneyView)
        headerJourneyView.isHidden = true
        hideHeaderCellAt(index: index)
    }
    
    
    
    func addErrorScreenAtIndex(index: Int , forFilteredResults: Bool )
    {
        if let tableview = baseScrollView.viewWithTag(1000 + index) as? UITableView {
            
            viewModel.resultsTableStates[index] = .showNoResults
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
            let state = viewModel.resultsTableStates[index]
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
    
    func setupBottomView() {
        testView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        testView.tag = 5100
        if self.navigationController?.view.viewWithTag(5100) == nil{
            self.navigationController?.view.addSubview(testView)
        }

        let fareBreakupVC = FareBreakupVC(nibName: "FareBreakupVC", bundle: nil)
        fareBreakupVC.taxesResult = self.viewModel.taxesResult
        fareBreakupVC.journey = self.viewModel.getSelectedJourneyForAllLegs()
        fareBreakupVC.sid = sid
        fareBreakupVC.bookingObject = bookFlightObject
        fareBreakupVC.flightAdultCount = bookFlightObject.flightAdultCount
        fareBreakupVC.flightChildrenCount = bookFlightObject.flightChildrenCount
        fareBreakupVC.flightInfantCount = bookFlightObject.flightInfantCount
        fareBreakupVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin]
        fareBreakupVC.delegate = self
        fareBreakupVC.view.tag = 2500
        fareBreakupVC.modalPresentationStyle = .overCurrentContext
        
        var isFSRVisible = false
        var remainingSeats = ""

        if let selectedJourney = self.viewModel.getSelectedJourneyForAllLegs(){
            for i in 0..<selectedJourney.count{
                let fk = selectedJourney[i].fk
                fareBreakupVC.selectedJourneyFK.append(fk)
                if selectedJourney[i].fsr == 1{
                    isFSRVisible = true
                }
                
                if selectedJourney[i].seats != nil{
                    remainingSeats = selectedJourney[i].seats!
                }
            }
        }
        
        if isFSRVisible == true && remainingSeats != "" && (Int(remainingSeats) ?? 0) != 0{
            fareBreakupVC.fewSeatsLeftViewHeightFromFlightDetails = 40
            self.viewModel.isFewSeatsLeft = true
        }else{
            fareBreakupVC.fewSeatsLeftViewHeightFromFlightDetails = 0
            self.viewModel.isFewSeatsLeft = false
        }
        let ts = CATransition()
        ts.type = .moveIn
        ts.subtype = .fromTop
        ts.duration = 0.4
        ts.timingFunction = .init(name: CAMediaTimingFunctionName.easeOut)
        fareBreakupVC.view.layer.add(ts, forKey: nil)
        //self.navigationController?.view.addSubview(fareBreakupVC.view)
        //self.navigationController?.addChild(fareBreakupVC)
        //fareBreakupVC.didMove(toParent: self.navigationController)
        if let parent = self.parent {
            parent.view.addSubview(fareBreakupVC.view)
        }
        self.fareBreakupVC = fareBreakupVC
    }
    
    func ShowFareBreakupView() {
        
        DispatchQueue.main.async {
            let bottomInset = self.view.safeAreaInsets.bottom
            let scrollBottom = ((self.viewModel.results.map{$0.selectedJourney}.filter{($0?.fsr ?? 0) == 1}).count == 0) ? (50 + bottomInset) : (90 + bottomInset)
            UIView.animate(withDuration: 0.2) {
                self.scrollViewBottomConstraint.constant = scrollBottom
                self.baseScrollView.layoutIfNeeded()
            }
            if self.fareBreakupVC == nil {
//                let bottomInset = self.view.safeAreaInsets.bottom
//                self.scrollViewBottomConstraint.constant = 50 + bottomInset
                self.setupBottomView()
            }
            
            guard let fareBreakupViewController =  self.fareBreakupVC else { return }
            var isFSRVisible = false
            var remainingSeats = ""
            
            if let selectedJourney = self.viewModel.getSelectedJourneyForAllLegs(){
                for i in 0..<selectedJourney.count{
                    let fk = selectedJourney[i].fk
                    fareBreakupViewController.selectedJourneyFK.append(fk)
                    
                    if selectedJourney[i].fsr == 1{
                        isFSRVisible = true
                    }
                    
                    if selectedJourney[i].seats != nil{
                        remainingSeats = selectedJourney[i].seats!
                    }
                }
            }
            if fareBreakupViewController.isFareBreakupExpanded {
                fareBreakupViewController.infoButtonTapped()
            }
            
            if isFSRVisible == true && remainingSeats != "" && (Int(remainingSeats) ?? 0) != 0{
                fareBreakupViewController.fewSeatsLeftViewHeightFromFlightDetails = 40
                self.viewModel.isFewSeatsLeft = true

            }else{
                fareBreakupViewController.fewSeatsLeftViewHeightFromFlightDetails = 0
                self.viewModel.isFewSeatsLeft = false
                
            }
            
            let containsPinnedFlight = self.viewModel.results.reduce(false) { $0 || $1.containsPinnedFlight }

            if containsPinnedFlight {
                self.showPinnedFlightsOption(true)
//                self.showPinnedFlightSwitch(true)
            }
            
            self.checkForComboFares()
            
            fareBreakupViewController.journey = self.viewModel.getSelectedJourneyForAllLegs()
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
            self.fareBreakupVC = nil
        }
    }
    
    //MARK:- PinnedFlightsOption View Methods
//    func hidePinnedFlightOptions( _ hide : Bool) {
//        //*******************Haptic Feedback code********************
//           let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
//           selectionFeedbackGenerator.selectionChanged()
//        //*******************Haptic Feedback code********************
//
//        print("hide=\(hide)")
//        if hide{
//
//            //true - hideOption
//
//            UIView.animate(withDuration: TimeInterval(0.4), delay: 0, options: .curveEaseOut, animations: { [weak self] in
//                self?.showPinnedSwitch.isUserInteractionEnabled = false
//
//                   self?.unpinnedAllButton.alpha = 0.0
//                   self?.emailPinnedFlights.alpha = 0.0
//                   self?.sharePinnedFilghts.alpha = 0.0
//                   self?.unpinnedAllButton.transform = CGAffineTransform(translationX: 0, y: 0)
//                   self?.emailPinnedFlights.transform = CGAffineTransform(translationX: 0, y: 0)
//                   self?.sharePinnedFilghts.transform = CGAffineTransform(translationX: 0, y: 0)
//                   }, completion: { [weak self] (success)
//            in
//                       self?.unpinnedAllButton.isHidden = true
//                       self?.emailPinnedFlights.isHidden = true
//                       self?.sharePinnedFilghts.isHidden = true
//                       self?.unpinnedAllButton.alpha = 1.0
//                       self?.emailPinnedFlights.alpha = 1.0
//                       self?.sharePinnedFilghts.alpha = 1.0
//                    self?.showPinnedSwitch.isUserInteractionEnabled = true
//               })
//        }else{
//            //false - showOption
//            self.unpinnedAllButton.alpha = 0.0
//            self.emailPinnedFlights.alpha = 0.0
//            self.sharePinnedFilghts.alpha = 0.0
//            UIView.animate(withDuration: TimeInterval(0.4), delay: 0, options: [.curveEaseOut, ], animations: { [weak self] in
//                self?.showPinnedSwitch.isUserInteractionEnabled = false
//
//                self?.unpinnedAllButton.isHidden = false
//                self?.emailPinnedFlights.isHidden = false
//                self?.sharePinnedFilghts.isHidden = false
//
//                self?.unpinnedAllButton.alpha = 1.0
//                self?.emailPinnedFlights.alpha = 1.0
//                self?.sharePinnedFilghts.alpha = 1.0
//                self?.unpinnedAllButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                self?.emailPinnedFlights.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                self?.sharePinnedFilghts.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                self?.emailPinnedFlights.transform = CGAffineTransform(translationX: 60, y: 0)
//                self?.sharePinnedFilghts.transform = CGAffineTransform(translationX: 114, y: 0)
//                self?.unpinnedAllButton.transform = CGAffineTransform(translationX: 168, y: 0)
//                }, completion: { [weak self] (success)
//                    in
//                    self?.showPinnedSwitch.isUserInteractionEnabled = true
//            })
//        }
//    }

    
//    func showPinnedFlightSwitch(_ show  : Bool) {
//
//        DispatchQueue.main.async {
//
//            let bottomInset = self.view.safeAreaInsets.bottom
//            var height :  CGFloat = 0.0
//
//           let fewSeatsLeftViewHeight = self.viewModel.isFewSeatsLeft ? 40 : 0
//
//            if show {
//                height =  60.0
//                height = height + bottomInset + CGFloat(fewSeatsLeftViewHeight)
//
//                if self.fareBreakupVC?.view.isHidden == false {
//                    height = height + 50
//                }
//            }
//            else {
//                height = 0.0
//            }
//
//            self.pinnedFlightOptionsTop.constant = CGFloat(height)
//
//            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
//                self.view.layoutIfNeeded()
//            }, completion: nil)
//        }
//    }
    
}

extension FlightDomesticMultiLegResultVC : FareBreakupVCDelegate , flightDetailsPinFlightDelegate {
    
    func updateRefundStatusIfPending(fk: String) {
        
        for index in 0 ..< self.viewModel.numberOfLegs {
            if let tableView = baseScrollView.viewWithTag( 1000 + index ) as? UITableView {
                tableView.reloadData()
            }
        }
        
    }
    
    func reloadRowFromFlightDetails(fk: String, isPinned: Bool, isPinnedButtonClicked: Bool) {
        for index in 0 ..< self.viewModel.numberOfLegs {
                   
                   let tableResultState = viewModel.resultsTableStates[index]
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
        guard fareBreakupVC != nil else {return}
        if isViewExpanded == true{
            testView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.navigationController?.view.addSubview(fareBreakupVC!.view)
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.testView.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.2)
            })
        }else{
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.testView.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
            },completion: { _ in
                self.testView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                if let parent = self.parent {
                    parent.view.addSubview(self.fareBreakupVC!.view)
                }
            })
        }
    }
    
    func bookButtonTapped(journeyCombo: [CombinationJourney]?) {
            let storyboard = UIStoryboard(name: "FlightDetailsBaseVC", bundle: nil)
            guard let flightDetailsVC:FlightDetailsBaseVC =
                    storyboard.instantiateViewController(withIdentifier: "FlightDetailsBaseVC") as? FlightDetailsBaseVC else {return}
    
        flightDetailsVC.isConditionReverced = viewModel.isConditionReverced
            flightDetailsVC.delegate = self
            flightDetailsVC.bookFlightObject = self.bookFlightObject
            flightDetailsVC.taxesResult = self.viewModel.taxesResult
            flightDetailsVC.sid = sid
            flightDetailsVC.journey = self.viewModel.getSelectedJourneyForAllLegs()
            flightDetailsVC.titleString = titleString
            flightDetailsVC.airportDetailsResult = self.viewModel.airportDetailsResult
            flightDetailsVC.airlineDetailsResult = self.viewModel.airlineDetailsResult
    
            if let allJourneyObj = self.viewModel.getSelectedJourneyForAllLegs(){
                for i in 0..<allJourneyObj.count{
                    let fk = allJourneyObj[i].fk
                    flightDetailsVC.selectedJourneyFK.append(fk)
                }
            }
            flightDetailsVC.journeyCombo = journeyCombo
            self.present(flightDetailsVC, animated: true, completion: nil)
    }
    
    func updateAirportDetailsArray(_ results : [String : AirportDetailsWS]) {
        self.viewModel.airportDetailsResult = results
    }
    
    func updateAirlinesDetailsArray(_ results : [String : AirlineMasterWS]) {
        self.viewModel.airlineDetailsResult = results
    }
    
    func updateTaxesArray(_ results : [String : String]) {
        self.viewModel.taxesResult = results
    }
    
    func hideBannerWhenAPIFails(){
        guard let headerView = bannerView, !headerView.isHidden  else { return }
        
        var rect = headerView.frame
        baseScrollViewTop.constant = 0
        self.baseScrollView.isScrollEnabled = true
        UIView.animate(withDuration: 1.0 , animations: {
            let y = rect.origin.y - rect.size.height - 20
            rect.origin.y = y
            headerView.frame = rect
            self.view.layoutIfNeeded()
            for subview in self.baseScrollView.subviews {
                if let tableView = subview as? UITableView {
                    tableView.origin.y = 0
                }else if let divider = subview as? ATVerticalDividerView{
                    divider.origin.y = 0.5
                }
            }
        }) { (bool) in
            self.baseScrollView.setContentOffset(CGPoint(x: 0, y: 0) , animated: false)
            self.bannerView?.isHidden = true
            if ((self.viewModel.results.filter{$0.allJourneys.count == 0}).count == 0){
                self.baseScrollView.isScrollEnabled = false
            }
        }
        
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
                    
                    var arrayForDisplay = self.viewModel.results[index].suggestedJourneyArray
                    let tableState = self.viewModel.resultsTableStates[index]
                                    
                    if tableState == .showPinnedFlights {
                         arrayForDisplay = self.viewModel.results[index].pinnedFlights
                      } else if tableState == .showExpensiveFlights {
                         arrayForDisplay = self.viewModel.results[index].allJourneys
                      } else {
                          arrayForDisplay = self.viewModel.results[index].suggestedJourneyArray
                      }
                    
                    
                     let journey = arrayForDisplay[indexPath.row]
                    return self.makeMenus(journey : journey, indexPath: indexPath , tableIndex: index)
                    
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
