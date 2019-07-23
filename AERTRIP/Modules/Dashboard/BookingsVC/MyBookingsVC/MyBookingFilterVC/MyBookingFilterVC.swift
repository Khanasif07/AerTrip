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
    fileprivate weak var categoryView: ATCategoryView!
    private let allTabsStr: [String] = [LocalizedString.TravelDate.localized, LocalizedString.EventType.localized, LocalizedString.BookingDate.localized]
    private var allTabs: [ATCategoryItem] {
        var temp = [ATCategoryItem]()
        for title in self.allTabsStr {
            var obj = ATCategoryItem()
            obj.title = title
            temp.append(obj)
        }
        return temp
    }
    
    private var allChildVCs: [UIViewController] = [UIViewController]()
    private var minDate: Date?
    
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
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
                
        self.fetchMinDateFromCoreData()
        self.setCounts()
        
        self.topNavBar.configureNavBar(title: "\(MyBookingFilterVM.shared.filteredResultCount) of \(MyBookingFilterVM.shared.totalResultCount) Results", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true, backgroundType: .clear)
        
        self.topNavBar.configureLeftButton(normalTitle: LocalizedString.ClearAll.localized, selectedTitle: LocalizedString.ClearAll.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.topNavBar.configureFirstRightButton(normalTitle: LocalizedString.Done.localized, selectedTitle: LocalizedString.Done.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        
        self.mainContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 4)
    
        for i in 0..<self.allTabsStr.count {
            if i == 0 {
                if let vc = AppGlobals.shared.travelDateVC {
                    self.allChildVCs.append(vc)
                }
                else {
                    let vc = TravelDateVC.instantiate(fromAppStoryboard: .Bookings)
                    vc.delegate = self
                    vc.minFromDate = minDate
                    vc.oldFromDate = MyBookingFilterVM.shared.travelFromDate
                    vc.oldToDate = MyBookingFilterVM.shared.travelToDate
                    vc.currentlyUsingAs = .travelDate
                    
//                    AppGlobals.shared.travelDateVC = vc
                    
                    self.allChildVCs.append(vc)
                }
                
            } else if i == 1 {
                if let vc = AppGlobals.shared.eventTypeVC {
                    self.allChildVCs.append(vc)
                }
                else {
                    let vc = EventTypeVC.instantiate(fromAppStoryboard: .Bookings)
                    vc.delegate = self
                    if MyBookingFilterVM.shared.isFirstTime {
                      vc.oldSelection = []
                    } else {
                        vc.oldSelection = MyBookingFilterVM.shared.eventType
                    }
                    //if all event types wan to show as deselected by-default
                    //vc.oldSelection = MyBookingFilterVM.shared.eventType //if all event types wan to show as selected by-default
                    
//                    AppGlobals.shared.eventTypeVC = vc
                    
                    
                    
                    self.allChildVCs.append(vc)
                }
                
            } else {
                if let vc = AppGlobals.shared.bookingDateVC {
                    self.allChildVCs.append(vc)
                }
                else {
                    let vc = TravelDateVC.instantiate(fromAppStoryboard: .Bookings)
                    vc.delegate = self
                    vc.minFromDate = minDate
                    vc.oldFromDate = MyBookingFilterVM.shared.bookingFromDate
                    vc.oldToDate = MyBookingFilterVM.shared.bookingToDate
                    vc.currentlyUsingAs = .bookingDate
                    
//                    AppGlobals.shared.bookingDateVC = vc
                    
                    self.allChildVCs.append(vc)
                }
            }
        }
        
        let height = UIApplication.shared.statusBarFrame.height
        self.navigationViewTopConstraint.constant = CGFloat(height)
        self.setupPagerView()
        self.hide(animated: false)
        delay(seconds: 0.01) { [weak self] in
            self?.show(animated: true)
        }
        self.setupGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.categoryView?.frame = self.childContainerView.bounds
        self.categoryView?.layoutIfNeeded()
    }
    
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
        
        self.setBadgesOnAllCategories()
        
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
        for obj in self.allChildVCs {
            NSObject.cancelPreviousPerformRequests(withTarget: obj)
        }
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
    
    
    private func setupPagerView() {
        var style = ATCategoryNavBarStyle()
        style.height = 50.0
        style.interItemSpace = 21.8
        style.itemPadding = 12.8
        style.isScrollable = false
        style.layoutAlignment = .left
        style.isEmbeddedToView = true
        style.showBottomSeparator = true
        style.bottomSeparatorColor = AppColors.themeGray40
        style.defaultFont = AppFonts.Regular.withSize(16.0)
        style.selectedFont = AppFonts.SemiBold.withSize(16.0)
        style.indicatorColor = AppColors.themeGreen
        style.normalColor = AppColors.textFieldTextColor51
        style.selectedColor = AppColors.themeBlack
        
        style.badgeDotSize = CGSize(width: 4.0, height: 4.0)
        style.badgeBackgroundColor = AppColors.themeGreen
        style.badgeBorderColor = AppColors.clear
        style.badgeBorderWidth = 0.0
        
        
        let categoryView = ATCategoryView(frame: self.childContainerView.bounds, categories: self.allTabs, childVCs: self.allChildVCs, parentVC: self, barStyle: style)
        categoryView.interControllerSpacing = 0.0
        categoryView.navBar.internalDelegate = self
        self.childContainerView.addSubview(categoryView)
        self.categoryView = categoryView
        
        // Set last Selected Index on Nav bar
        self.categoryView.select(at: MyBookingFilterVM.shared.lastSelectedIndex)
        self.setBadgesOnAllCategories()
    }
    
    private func setBadgesOnAllCategories() {
        
        for (idx,tab) in self.allTabsStr.enumerated() {
            
            var badgeCount = 0
            
            switch tab.lowercased() {
            case LocalizedString.TravelDate.localized.lowercased():
                badgeCount = (MyBookingFilterVM.shared.travelToDate != nil || MyBookingFilterVM.shared.travelFromDate != nil) ? 1 : 0
                
            case LocalizedString.EventType.localized.lowercased():
                badgeCount = MyBookingFilterVM.shared.eventType.isEmpty ? 0 : 1
                
            case LocalizedString.BookingDate.localized.lowercased():
                badgeCount = (MyBookingFilterVM.shared.bookingToDate != nil || MyBookingFilterVM.shared.bookingFromDate != nil) ? 1 : 0
                
            default:
                printDebug("not useable case")
            }
            
            self.categoryView.setBadge(atIndex: idx, badgeNumber: badgeCount)
        }
    }
    
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

