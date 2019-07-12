//
//  MyBookingsVC.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class MyBookingsVC: BaseVC {
    // Mark:- Variables
    //================
    private var selectedButton: Int = 0
    private var currentIndex: Int = 0
    fileprivate weak var categoryView: ATCategoryView!
    private var allTabsStr: [String] = []
    private var allTabs: [ATCategoryItem] {
        var temp = [ATCategoryItem]()
        for title in self.allTabsStr {
            var obj = ATCategoryItem()
            obj.title = title
            temp.append(obj)
        }
        return temp
    }
    
    
    
    var allChildVCs: [UIViewController] = [UIViewController]()
    
    // Mark:- IBOutlets
    //================
    @IBOutlet var topNavBar: TopNavigationView! {
        didSet {
            self.topNavBar.delegate = self
        }
    }
    
    @IBOutlet var searchBarContainerView: UIView!
    @IBOutlet var searchBar: ATSearchBar! {
        didSet {
            self.searchBar.backgroundColor = AppColors.screensBackground.color
            self.searchBar.placeholder = LocalizedString.search.localized
            self.searchBar.delegate = self
        }
    }
    
    @IBOutlet var emptyStateImageView: UIImageView!
    @IBOutlet var emptyStateTitleLabel: UILabel!
    @IBOutlet var emptyStateSubTitleLabel: UILabel!
    @IBOutlet var childContainerView: UIView!
    
    // Mark:- LifeCycle
    
    override func initialSetup() {
        self.topNavBar.configureNavBar(title: LocalizedString.MyBookings.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "bookingFilterIcon"), selectedImage: #imageLiteral(resourceName: "bookingFilterIconSelected"))
        //        self.topNavBar.configureSecondRightButton(normalImage: #imageLiteral(resourceName: "swipeArrow"), selectedImage: #imageLiteral(resourceName: "swipeArrow"))
        self.searchBar.cornerRadius = 10.0
        self.searchBar.clipsToBounds = true
        self.hideAllData()
        MyBookingsVM.shared.delgate = self
        MyBookingsVM.shared.getBookings()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.allTabsStr.removeAll()
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification {
            if noti == .myBookingFilterApplied {
                self.topNavBar.firstRightButton.isSelected = true
            }
            else if noti == .myBookingFilterCleared {
                self.topNavBar.firstRightButton.isSelected = false
                MyBookingFilterVM.shared.setToDefault()
            }
            else if noti == .myBookingCasesRequestStatusChanged {
                MyBookingsVM.shared.getBookings()
            }
        }
    }
    
    // MARK:- Override methods
    
    override func setupTexts() {
        self.emptyStateImageView.image = #imageLiteral(resourceName: "booking_Emptystate")
        self.emptyStateTitleLabel.text = LocalizedString.NoBookingsYet.localized
        self.emptyStateSubTitleLabel.text = LocalizedString.StartYourWanderlustJourneyWithUs.localized
    }
    
    override func setupFonts() {
        self.topNavBar.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.emptyStateTitleLabel.font = AppFonts.Regular.withSize(22.0)
        self.emptyStateSubTitleLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.emptyStateTitleLabel.textColor = AppColors.themeBlack
        self.emptyStateSubTitleLabel.textColor = AppColors.themeGray60
        self.topNavBar.navTitleLabel.textColor = AppColors.textFieldTextColor51
    }
    
    override func bindViewModel() {
        
        MyBookingsVM.shared.delgate = self
    }
    
    
    
    // MARK:- Functions
    //================
    private func filterOptionsPopUp() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.TravelDate.localized, LocalizedString.EventType.localized, LocalizedString.BookingDate.localized], colors: [AppColors.themeGreen, AppColors.themeGreen, AppColors.themeGreen])
        _ = PKAlertController.default.presentActionSheetWithTextAllignMentAndImage(nil, message: nil, sourceView: view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton, textAlignment: CATextLayerAlignmentMode.right, selectedButtonIndex: self.selectedButton) { _, index in
            switch index {
            case 0:
                self.selectedButton = index
                MyBookingFilterVM.shared.bookingSortType = .travelDate
                printDebug(LocalizedString.TravelDate.localized)
            case 1:
                self.selectedButton = index
                MyBookingFilterVM.shared.bookingSortType = .eventType
                printDebug(LocalizedString.EventType.localized)
            case 2:
                self.selectedButton = index
                MyBookingFilterVM.shared.bookingSortType = .bookingDate
                printDebug(LocalizedString.BookingDate.localized)
            default:
                printDebug("default")
            }
        }
    }
    
    func emptyStateSetUp() {
        self.allChildVCs.removeAll()
        if MyBookingsVM.shared.allTabTypes.isEmpty {
            self.emptyStateImageView.isHidden = false
            self.emptyStateTitleLabel.isHidden = false
            self.emptyStateSubTitleLabel.isHidden = false
            self.childContainerView.isHidden = true
            self.searchBarContainerView.isHidden = true
        } else {
            self.emptyStateImageView.isHidden = true
            self.emptyStateTitleLabel.isHidden = true
            self.emptyStateSubTitleLabel.isHidden = true
            self.childContainerView.isHidden = false
            self.searchBarContainerView.isHidden = false
            self.instantiateChildVC()
        }
    }
    
    private func instantiateChildVC() {
        self.allTabsStr.removeAll()
        
        if MyBookingsVM.shared.allTabTypes.contains(Int16(BookingTabCategory.upcoming.rawValue)) {
            self.allTabsStr.append(LocalizedString.Upcoming.localized)
            if MyBookingsVM.shared.allTabTypes.contains(Int16(BookingTabCategory.completed.rawValue)) {
                self.allTabsStr.append(LocalizedString.Completed.localized)
            }
            if MyBookingsVM.shared.allTabTypes.contains(Int16(BookingTabCategory.cancelled.rawValue)) {
                self.allTabsStr.append(LocalizedString.Cancelled.localized)
            }
        }
        
        self.allChildVCs.removeAll()
        for i in 0..<self.allTabsStr.count {
            if i == 0 {
                let vc = UpcomingBookingsVC.instantiate(fromAppStoryboard: .Bookings)
                self.allChildVCs.append(vc)
            } else if i == 1 {
                let vc = CompletedVC.instantiate(fromAppStoryboard: .Bookings)
                self.allChildVCs.append(vc)
            }
            else if i == 2 {
                let vc = CancelledVC.instantiate(fromAppStoryboard: .Bookings)
                self.allChildVCs.append(vc)
            }
            else {
                printDebug("No vc")
            }
        }
        
        if self.allChildVCs.count == 1 {
            self.setupPagerView(headerHeight: 0.0, interItemSpace: 0.0, itemPadding: 0.0, isScrollable: false)
        } else if self.allChildVCs.count == 2 {
            self.setupPagerView(interItemSpace: 45.0, itemPadding: 32.0)
        } else {
            self.setupPagerView(interItemSpace: 21.8, itemPadding: 12.8)
        }
    }
    
    private func setupPagerView(headerHeight: CGFloat = 50.0, interItemSpace: CGFloat, itemPadding: CGFloat, isScrollable: Bool = true) {
        var style = ATCategoryNavBarStyle()
        style.height = headerHeight // 50.0
        style.interItemSpace = interItemSpace // 21.8
        style.itemPadding = itemPadding // 12.8
        style.isScrollable = isScrollable
        style.layoutAlignment = .left
        style.isEmbeddedToView = true
        style.showBottomSeparator = true
        style.bottomSeparatorColor = AppColors.themeGray40
        style.defaultFont = AppFonts.Regular.withSize(16.0)
        style.selectedFont = AppFonts.SemiBold.withSize(16.0)
        style.indicatorColor = AppColors.themeGreen
        style.normalColor = AppColors.textFieldTextColor51
        style.selectedColor = AppColors.themeBlack
        //        style.badgeDotSize = CGSize(width: 0.0, height: 0.0)
        //        style.badgeBackgroundColor = AppColors.themeGreen
        //        style.badgeBorderColor = AppColors.clear
        //        style.badgeBorderWidth = 0.0
        
        if let _ = self.categoryView {
            self.categoryView?.removeFromSuperview()
            self.categoryView = nil
        }
        let categoryView = ATCategoryView(frame: self.childContainerView.bounds, categories: self.allTabs, childVCs: self.allChildVCs, parentVC: self, barStyle: style)
        self.categoryView = categoryView
        categoryView.interControllerSpacing = 0.0
        categoryView.navBar.internalDelegate = self
        self.childContainerView.addSubview(categoryView)
        
        // Set last Selected Index on Nav bar
        self.categoryView.select(at: 0)
    }
    
    
    private func hideAllData() {
        self.emptyStateImageView.isHidden = true
        self.emptyStateTitleLabel.isHidden = true
        self.emptyStateSubTitleLabel.isHidden = true
        self.childContainerView.isHidden = true
        self.searchBarContainerView.isHidden = true
    }
    
    
    // Mark:- IBActions
    //================
}

// Mark:- Extensions
//=================
extension MyBookingsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        printDebug("topNavBarFirstRightButtonAction")
        
        AppFlowManager.default.showBookingFilterVC(self)
    }
    
    func topNavBarSecondRightButtonAction(_ sender: UIButton) {
        printDebug("topNavBarSecondRightButtonAction")
        self.filterOptionsPopUp()
    }
}

// MARK: - ATCategoryNavBarDelegate

extension MyBookingsVC: ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
        //        HotelFilterVM.shared.lastSelectedIndex = toIndex
    }
}

// MARK: - MyBookingFooterViewDelegate

