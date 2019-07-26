//
//  MyBookingFilterVC.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class MyBookingFilterVC: BaseVC {
    
    //MARK:- Variables
    //MARK:- Private
    private var currentIndex: Int = 0
//    fileprivate weak var categoryView: ATCategoryView!
    private let allTabsStr: [String] = [LocalizedString.TravelDate.localized, LocalizedString.EventType.localized, LocalizedString.BookingDate.localized]
    private var allTabButtons: [PKCategoryButton] {
        return [travelDateButton, eventTypeButton, bookingDateButton]
    }
//    private var allTabs: [ATCategoryItem] {
//        var temp = [ATCategoryItem]()
//        for title in self.allTabsStr {
//            var obj = ATCategoryItem()
//            obj.title = title
//            temp.append(obj)
//        }
//        return temp
//    }
    
//    private var allChildVCs: [UIViewController] = [UIViewController]()
    private var minDate: Date?
    
    private var travelDateVC: TravelDateVC?
    private var eventTypeVC: EventTypeVC?
    private var bookingDateVC: TravelDateVC?
    private var previousOffset = CGPoint.zero
    
    //MARK:- IBOutlets
    @IBOutlet var topNavBar: TopNavigationView!{
        didSet {
            self.topNavBar.delegate = self
        }
    }
    @IBOutlet var childContainerView: UIView!
    @IBOutlet var mainContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var mainContainerView: UIView!
    @IBOutlet var navigationViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainBackView: UIView!
    
    @IBOutlet weak var allTabTitleContainerView: UIView!
    @IBOutlet weak var travelDateButton: PKCategoryButton!
    @IBOutlet weak var eventTypeButton: PKCategoryButton!
    @IBOutlet weak var bookingDateButton: PKCategoryButton!
    @IBOutlet weak var tabSelectionIndicatorView: UIView!
    @IBOutlet weak var allTabDetailConatinerView: UIScrollView!
    
    //MARK:- LifeCycle
    override func initialSetup() {
        
        self.fetchMinDateFromCoreData()
        self.setCounts()
        
        self.topNavBar.configureNavBar(title: "\(MyBookingFilterVM.shared.filteredResultCount) of \(MyBookingFilterVM.shared.totalResultCount) Results", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true, backgroundType: .clear)
        
        let clearStr = "  \(LocalizedString.ClearAll.localized)"
        let doneStr = "\(LocalizedString.Done.localized)  "
        self.topNavBar.configureLeftButton(normalTitle: clearStr, selectedTitle: clearStr, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.topNavBar.configureFirstRightButton(normalTitle: doneStr, selectedTitle: doneStr, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        
        self.mainContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 4)
        
//        for i in 0..<self.allTabsStr.count {
//            if i == 0 {
//                if let vc = AppGlobals.shared.travelDateVC {
//                    self.allChildVCs.append(vc)
//                }
//                else {
//                    let vc = TravelDateVC.instantiate(fromAppStoryboard: .Bookings)
//                    vc.delegate = self
//                    vc.minFromDate = minDate
//                    vc.oldFromDate = MyBookingFilterVM.shared.travelFromDate
//                    vc.oldToDate = MyBookingFilterVM.shared.travelToDate
//                    vc.currentlyUsingAs = .travelDate
//
//                    //                    AppGlobals.shared.travelDateVC = vc
//
//                    self.allChildVCs.append(vc)
//                }
//
//            } else if i == 1 {
//                if let vc = AppGlobals.shared.eventTypeVC {
//                    self.allChildVCs.append(vc)
//                }
//                else {
//                    let vc = EventTypeVC.instantiate(fromAppStoryboard: .Bookings)
//                    vc.delegate = self
//                    if MyBookingFilterVM.shared.isFirstTime {
//                        vc.oldSelection = []
//                    } else {
//                        vc.oldSelection = MyBookingFilterVM.shared.eventType
//                    }
//                    //if all event types wan to show as deselected by-default
//                    //vc.oldSelection = MyBookingFilterVM.shared.eventType //if all event types wan to show as selected by-default
//
//                    //                    AppGlobals.shared.eventTypeVC = vc
//
//
//
//                    self.allChildVCs.append(vc)
//                }
//
//            } else {
//                if let vc = AppGlobals.shared.bookingDateVC {
//                    self.allChildVCs.append(vc)
//                }
//                else {
//                    let vc = TravelDateVC.instantiate(fromAppStoryboard: .Bookings)
//                    vc.delegate = self
//                    vc.minFromDate = minDate
//                    vc.oldFromDate = MyBookingFilterVM.shared.bookingFromDate
//                    vc.oldToDate = MyBookingFilterVM.shared.bookingToDate
//                    vc.currentlyUsingAs = .bookingDate
//
//                    //                    AppGlobals.shared.bookingDateVC = vc
//
//                    self.allChildVCs.append(vc)
//                }
//            }
//        }
        
        let height = UIApplication.shared.statusBarFrame.height
        self.navigationViewTopConstraint.constant = CGFloat(height)
//        self.setupPagerView()
        self.configureTabBar()
        self.hide(animated: false)
        delay(seconds: 0.01) { [weak self] in
            self?.show(animated: true)
        }
        self.setupGesture()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.categoryView?.frame = self.childContainerView.bounds
//        self.categoryView?.layoutIfNeeded()
//    }
    
    override func setupTexts() {
    }
    
    override func setupFonts() {
        self.topNavBar.navTitleLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupColors() {
        self.topNavBar.navTitleLabel.textColor = AppColors.themeGray40
    }
    
    //MARK:- Functions
    private func setCounts() {
        
        self.topNavBar.navTitleLabel.text = "\(MyBookingFilterVM.shared.filteredResultCount) of \(MyBookingFilterVM.shared.totalResultCount) Results"
    }
    private func notifyToFilterApplied() {
        
//        self.setBadgesOnAllCategories()
        self.setBadge()
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        // dalay for 1 seconds for the filter applied same as Android
        perform(#selector(sendNotification), with: nil, afterDelay: 1.0)
    }
    
    @objc private func sendNotification() {
        self.sendDataChangedNotification(data: ATNotification.myBookingFilterApplied)
        
        delay(seconds: 0.5) { [weak self] in
            self?.setCounts()
        }
    }
    
    private func fetchMinDateFromCoreData() {
        if let dict = CoreDataManager.shared.fetchData(fromEntity: "BookingData", forAttribute: "dateHeader", usingFunction: "min").first, let minDt = dict["min"] as? String {
            
            //2019-08-07 00:00:00
            printDebug("Min date \(minDt)")
            self.minDate = minDt.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
    }
    private func show(animated: Bool) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerViewTopConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    private func cancelAllOperation() {
        //cancel all the operation if user trying to close the filter screen
//        for obj in self.allChildVCs {
//            NSObject.cancelPreviousPerformRequests(withTarget: obj)
//        }
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerViewTopConstraint.constant = -(self.mainContainerView.height)
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if shouldRemove {
                self.removeFromParentVC
            }
        })
    }
    
    
//    private func setupPagerView() {
//        var style = ATCategoryNavBarStyle()
//        style.height = 50.0
//        style.interItemSpace = 21.8
//        style.itemPadding = 12.8
//        style.isScrollable = false
//        style.layoutAlignment = .left
//        style.isEmbeddedToView = true
//        style.showBottomSeparator = true
//        style.bottomSeparatorColor = AppColors.themeGray40
//        style.defaultFont = AppFonts.Regular.withSize(16.0)
//        style.selectedFont = AppFonts.SemiBold.withSize(16.0)
//        style.indicatorColor = AppColors.themeGreen
//        style.normalColor = AppColors.textFieldTextColor51
//        style.selectedColor = AppColors.themeBlack
//
//        style.badgeDotSize = CGSize(width: 4.0, height: 4.0)
//        style.badgeBackgroundColor = AppColors.themeGreen
//        style.badgeBorderColor = AppColors.clear
//        style.badgeBorderWidth = 0.0
//
//
//        let categoryView = ATCategoryView(frame: self.childContainerView.bounds, categories: self.allTabs, childVCs: self.allChildVCs, parentVC: self, barStyle: style)
//        categoryView.interControllerSpacing = 0.0
//        categoryView.navBar.internalDelegate = self
//        self.childContainerView.addSubview(categoryView)
//        self.categoryView = categoryView
//
//        // Set last Selected Index on Nav bar
//        self.categoryView.select(at: MyBookingFilterVM.shared.lastSelectedIndex)
//        self.setBadgesOnAllCategories()
//    }
    
//    private func setBadgesOnAllCategories() {
//
//        for (idx,tab) in self.allTabsStr.enumerated() {
//
//            var badgeCount = 0
//
//            switch tab.lowercased() {
//            case LocalizedString.TravelDate.localized.lowercased():
//                badgeCount = (MyBookingFilterVM.shared.travelToDate != nil || MyBookingFilterVM.shared.travelFromDate != nil) ? 1 : 0
//
//            case LocalizedString.EventType.localized.lowercased():
//                badgeCount = MyBookingFilterVM.shared.eventType.isEmpty ? 0 : 1
//
//            case LocalizedString.BookingDate.localized.lowercased():
//                badgeCount = (MyBookingFilterVM.shared.bookingToDate != nil || MyBookingFilterVM.shared.bookingFromDate != nil) ? 1 : 0
//
//            default:
//                printDebug("not useable case")
//            }
//
//            self.categoryView.setBadge(atIndex: idx, badgeNumber: badgeCount)
//        }
//    }
    
    private func setupGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(outsideAreaTapped))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.delegate = self
        self.mainBackView.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK:- IBActions
    @objc func  outsideAreaTapped() {
        self.cancelAllOperation()
        self.hide(animated: true, shouldRemove: true)
    }
    
    @IBAction func travelDateButtonAction(_ sender: PKCategoryButton) {
        self.selectTab(atIndex: 0.0, animated: true)
    }
    
    @IBAction func eventTypeButtonAction(_ sender: PKCategoryButton) {
        self.selectTab(atIndex: 1.0, animated: true)
    }
    
    @IBAction func bookingDateButtonAction(_ sender: PKCategoryButton) {
        self.selectTab(atIndex: 2.0, animated: true)
    }
}

//MARK:- Extensions
extension MyBookingFilterVC: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //clear all
        self.sendDataChangedNotification(data: ATNotification.myBookingFilterCleared)
        self.hide(animated: true, shouldRemove: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        printDebug("Filters \(MyBookingFilterVM.shared)")
        self.hide(animated: true, shouldRemove: true)
    }
}

// MARK: - ATCategoryNavBarDelegate

extension MyBookingFilterVC: ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
        MyBookingFilterVM.shared.lastSelectedIndex = toIndex
    }
}



extension MyBookingFilterVC: EventTypeVCDelegate {
    func didSelectEventTypes(selection: [Int]) {
        MyBookingFilterVM.shared.isFirstTime = false
        MyBookingFilterVM.shared.eventType = selection
        self.notifyToFilterApplied()
    }
}

extension MyBookingFilterVC: TravelDateVCDelegate {
    func didSelect(fromDate: Date, forType: TravelDateVC.UsingFor) {
        if forType == .bookingDate {
            MyBookingFilterVM.shared.bookingFromDate = fromDate
        }
        else if forType == .travelDate {
            MyBookingFilterVM.shared.travelFromDate = fromDate
        }
        self.notifyToFilterApplied()
    }
    
    func didSelect(toDate: Date, forType: TravelDateVC.UsingFor) {
        if forType == .bookingDate {
            MyBookingFilterVM.shared.bookingToDate = toDate
        }
        else if forType == .travelDate {
            MyBookingFilterVM.shared.travelToDate = toDate
        }
        self.notifyToFilterApplied()
    }
}

extension MyBookingFilterVC {
    
    var totalTabs: Int {
        return self.allTabsStr.count
    }
    
    var oneTabWidth: CGFloat {
        return allTabTitleContainerView.width / CGFloat(totalTabs)
    }
    
    private func configureTabBar() {
        self.configureTabButtons()
        self.configureSelectionIndicator()
        self.configureScrollView()
        
        self.selectTab(atIndex: CGFloat(MyBookingFilterVM.shared.lastSelectedIndex), animated: false)
        self.setBadge()
    }
    
    private func configureTabButtons() {
        func configure(button: PKCategoryButton, title: String) {

            button.setTitle(title, for: .normal)
            button.setTitle(title, for: .selected)
            
            button.setTitleColor(AppColors.textFieldTextColor51, for: .normal)
            button.setTitleColor(AppColors.themeBlack, for: .selected)
            
            button.setTitleFont(font: AppFonts.Regular.withSize(16.0), for: .normal)
            button.setTitleFont(font: AppFonts.SemiBold.withSize(16.0), for: .selected)
            
            button.isSelected = false
            button.tintColor = AppColors.clear
        }

        //Travel Date button
        configure(button: self.travelDateButton, title: LocalizedString.TravelDate.localized)
        
        //Event Type button
        configure(button: self.eventTypeButton, title: LocalizedString.EventType.localized)
        
        //Booking Date button
        configure(button: self.bookingDateButton, title: LocalizedString.BookingDate.localized)
        
        self.tabSelectionIndicatorView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    private func configureSelectionIndicator() {
        self.tabSelectionIndicatorView.backgroundColor = AppColors.themeGreen
    }
    
    private func configureScrollView() {
        self.allTabDetailConatinerView.contentSize = CGSize(width: self.allTabDetailConatinerView.width * CGFloat(totalTabs), height: self.allTabDetailConatinerView.height)
        self.allTabDetailConatinerView.delegate = self
        self.allTabDetailConatinerView.isPagingEnabled = true
        self.allTabDetailConatinerView.showsVerticalScrollIndicator = false
        self.allTabDetailConatinerView.showsHorizontalScrollIndicator = false
        
        //Travel Date
        if self.travelDateVC == nil {
            let vc = TravelDateVC.instantiate(fromAppStoryboard: .Bookings)
            vc.delegate = self
            vc.minFromDate = minDate
            vc.oldFromDate = MyBookingFilterVM.shared.travelFromDate
            vc.oldToDate = MyBookingFilterVM.shared.travelToDate
            vc.currentlyUsingAs = .travelDate
            
            self.travelDateVC = vc
            
            self.allTabDetailConatinerView.addSubview(vc.view)
        }
        self.travelDateVC?.view.frame = CGRect(x: (self.allTabDetailConatinerView.width * 0.0), y: 0.0, width: self.allTabDetailConatinerView.width, height: self.allTabDetailConatinerView.height)
        
        
        //Event Type
        if self.eventTypeVC == nil {
            let vc = EventTypeVC.instantiate(fromAppStoryboard: .Bookings)
            vc.delegate = self
            if MyBookingFilterVM.shared.isFirstTime {
                vc.oldSelection = []
            } else {
                vc.oldSelection = MyBookingFilterVM.shared.eventType
            }
            //if all event types wan to show as deselected by-default
            //vc.oldSelection = MyBookingFilterVM.shared.eventType //if all event types wan to show as selected by-default
            
            self.eventTypeVC = vc
            
            self.allTabDetailConatinerView.addSubview(vc.view)
        }
        self.eventTypeVC?.view.frame = CGRect(x: (self.allTabDetailConatinerView.width * 1.0), y: 0.0, width: self.allTabDetailConatinerView.width, height: self.allTabDetailConatinerView.height)
        
        //Booking Date
        if self.bookingDateVC == nil {
            let vc = TravelDateVC.instantiate(fromAppStoryboard: .Bookings)
            vc.delegate = self
            vc.minFromDate = minDate
            vc.oldFromDate = MyBookingFilterVM.shared.bookingFromDate
            vc.oldToDate = MyBookingFilterVM.shared.bookingToDate
            vc.currentlyUsingAs = .bookingDate
            
            self.bookingDateVC = vc
            
            self.allTabDetailConatinerView.addSubview(vc.view)
        }
        self.bookingDateVC?.view.frame = CGRect(x: (self.allTabDetailConatinerView.width * 2.0), y: 0.0, width: self.allTabDetailConatinerView.width, height: self.allTabDetailConatinerView.height)
    }
    
    private func setBadge() {
        
        for tab in self.allTabsStr {
            
            switch tab.lowercased() {
            case LocalizedString.TravelDate.localized.lowercased():
                let badgeCount = (MyBookingFilterVM.shared.travelToDate != nil || MyBookingFilterVM.shared.travelFromDate != nil) ? 1 : 0
                self.allTabButtons[0].badgeCount = badgeCount
                
            case LocalizedString.EventType.localized.lowercased():
                let badgeCount = MyBookingFilterVM.shared.eventType.isEmpty ? 0 : 1
                self.allTabButtons[1].badgeCount = badgeCount
                
            case LocalizedString.BookingDate.localized.lowercased():
                let badgeCount = (MyBookingFilterVM.shared.bookingToDate != nil || MyBookingFilterVM.shared.bookingFromDate != nil) ? 1 : 0
                self.allTabButtons[2].badgeCount = badgeCount
                
            default:
                printDebug("not useable case")
            }
        }
    }
}

extension MyBookingFilterVC {
    private func selectTab(atIndex: CGFloat, animated: Bool) {
        let point = CGPoint(x: self.allTabDetailConatinerView.width * atIndex, y: 0.0)
        self.allTabDetailConatinerView.setContentOffset(point, animated: animated)
        
        for (idx, btn) in allTabButtons.enumerated() {
            btn.isSelected = (idx == Int(atIndex))
        }
        self.moveIndicator(fromIndex: Int(atIndex), toIndex: Int(atIndex), progress: 1.0, animated: animated)
    }
    
    private func moveIndicator(fromIndex: Int, toIndex: Int, progress: CGFloat, animated: Bool) {
        
//        print("fromIndex: \(fromIndex), toIndex: \(toIndex), progress: \(progress)")
        
        let buttonWidth = oneTabWidth
        let indicatorWidth = self.allTabsStr[Int(toIndex)].sizeCount(withFont: AppFonts.SemiBold.withSize(16.0), bundingSize: CGSize(width: 10000.0, height: self.allTabTitleContainerView.height)).width + 10.0
        let indicatorHeight: CGFloat = 2.0
        
        func xFor(index: Int) -> CGFloat {
            return (((buttonWidth - indicatorWidth) / 2.0) + (buttonWidth * CGFloat(index)))
        }
        
        var newX: CGFloat = 0.0
        if fromIndex > toIndex {
            //back
            newX = xFor(index: fromIndex) - (buttonWidth * (1.0 - progress))
        }
        else if fromIndex < toIndex {
            //forward
            newX = xFor(index: fromIndex) + (buttonWidth * progress)
        }
        else {
            //select any page
            newX = xFor(index: fromIndex)
        }
        
//        print("fromIndex: \(newX)")
        let indicatorFrame = CGRect(x: newX, y: self.allTabTitleContainerView.height - indicatorHeight, width: indicatorWidth, height: indicatorHeight)
        
        self.tabSelectionIndicatorView.frame = indicatorFrame
        
        if animated {
            UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
                self?.tabSelectionIndicatorView.layoutIfNeeded()
            }
        }
        
        MyBookingFilterVM.shared.lastSelectedIndex = toIndex
    }
    
    private func onScrollEnding(_ scrollView: UIScrollView) {
        let page = CGFloat(Int(scrollView.contentOffset.x / scrollView.bounds.width))
        self.selectTab(atIndex: page, animated: true)
    }
    
    private func movePage(from: Int, to: Int, pregress: CGFloat) {
        if pregress >= 1.0 {
            self.selectTab(atIndex: CGFloat(to), animated: false)
        }
        else {
            self.moveIndicator(fromIndex: from, toIndex: to, progress: pregress, animated: false)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.onScrollEnding(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.onScrollEnding(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        
        let upperBound = scrollView.contentSize.width - scrollView.bounds.width
        guard 0...upperBound ~= offset.x else {
            return
        }
        
        let progress: CGFloat = offset.x.truncatingRemainder(dividingBy: scrollView.bounds.width) / scrollView.bounds.width

        if offset.x > previousOffset.x {
            //increase
            let fromPage = Int((offset.x - 1) / scrollView.bounds.width)
            let toPage = fromPage + 1
            self.movePage(from: fromPage, to: toPage, pregress: progress)
        }
        else if offset.x < previousOffset.x {
            //decrease
            let fromPage = Int((offset.x + scrollView.bounds.width) / scrollView.bounds.width)
            let toPage = fromPage - 1
            self.movePage(from: fromPage, to: toPage, pregress: progress)
        }
        
        previousOffset = scrollView.contentOffset
    }
}
