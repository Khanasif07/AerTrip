//
//  MyBookingsVC.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment

class MyBookingsVC: BaseVC {
    // Mark:- Variables
    //================
    private var selectedButton: Int = 0
    private var currentIndex: Int = 0
    private var allTabsStr: [String] = []
    // Parchment View
    fileprivate var parchmentView : PagingViewController?
    private var allChildVCs :[UIViewController] = []
    
    private var previousOffset = CGPoint.zero
    private var isBookingApiRunned = false
    // Mark:- IBOutlets
    //================
    @IBOutlet weak var topNavBar: TopNavigationView! {
        didSet {
            self.topNavBar.delegate = self
        }
    }
    
    @IBOutlet weak var childContainerView: UIView!
    @IBOutlet weak var searchBarContainerView: UIView!
    @IBOutlet weak var searchBar: ATSearchBar! {
        didSet {
            self.searchBar.backgroundColor = AppColors.screensBackground.color
            self.searchBar.placeholder = LocalizedString.search.localized
            self.searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var emptyStateImageView: UIImageView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    @IBOutlet weak var emptyStateSubTitleLabel: UILabel!
    
    
    // Mark:- LifeCycle
    
    override func initialSetup() {
        self.topNavBar.configureNavBar(title: LocalizedString.MyBookings.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "bookingFilterIcon"), selectedImage: #imageLiteral(resourceName: "bookingFilterIconSelected"))
        self.topNavBar.firstRightBtnTrailingConst.constant = 3.0
        //        self.topNavBar.configureSecondRightButton(normalImage: #imageLiteral(resourceName: "swipeArrow"), selectedImage: #imageLiteral(resourceName: "swipeArrow"))
        self.searchBar.cornerRadius = 10.0
        self.searchBar.clipsToBounds = true
        self.hideAllData()
        
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
                MyBookingsVM.shared.getBookings(shouldCallWillDelegate: false)
            }
        }
    }
    
    // MARK:- Override methods
    override func viewDidLayoutSubviews() {
        self.parchmentView?.view.frame = self.childContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
    }
    
    override func setupTexts() {
        self.emptyStateImageView.image = #imageLiteral(resourceName: "booking_Emptystate")
        self.emptyStateTitleLabel.text = LocalizedString.NoBookingsYet.localized
        self.emptyStateSubTitleLabel.text = LocalizedString.StartYourWanderlustJourneyWithUs.localized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isBookingApiRunned {
            isBookingApiRunned = true
            MyBookingsVM.shared.getBookings()
        }
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
    // Asif Change
    public func setUpViewPager() {
        self.currentIndex = 0
        self.allChildVCs.removeAll()
        if allTabsStr.contains("Upcoming"){
            let upcomingVC = UpcomingBookingsVC.instantiate(fromAppStoryboard: .Bookings)
            self.allChildVCs.append(upcomingVC)
        }
        if  allTabsStr.contains("Completed"){
            let completedVC = CompletedVC.instantiate(fromAppStoryboard: .Bookings)
            self.allChildVCs.append(completedVC)
        }
        if  allTabsStr.contains("Cancelled"){
            let cancelledVC = CancelledVC.instantiate(fromAppStoryboard: .Bookings)
            self.allChildVCs.append(cancelledVC)
        }
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        setupParchmentPageController()
    }
    
    // Added to replace the existing page controller, added Asif Khan
    private func setupParchmentPageController(){
        
        self.parchmentView = PagingViewController()
        self.parchmentView?.menuItemSpacing =  self.allTabsStr.count == 2 ? (UIDevice.screenWidth - 269.0) : (UIDevice.screenWidth - 269.0)/2
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: self.allTabsStr.count == 2 ? 59.0 : 28.0, bottom: 0.0, right:  self.allTabsStr.count == 2 ? 64.0 : 29.0)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0), insets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0))
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 50)
        self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.parchmentView?.borderColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
        self.parchmentView?.indicatorColor = AppColors.themeGreen
        self.parchmentView?.selectedTextColor = AppColors.themeBlack
        self.childContainerView.addSubview(self.parchmentView!.view)
        
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.select(index: 0)
        
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
    }
    
    
    // MARK:- Functions
    //================
    private func filterOptionsPopUp() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.TravelDate.localized, LocalizedString.EventType.localized, LocalizedString.BookingDate.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen, AppColors.themeDarkGreen])
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
            self.setUpViewPager()
        }
    }
    
    private func instantiateChildVC() {
        self.allTabsStr.removeAll()
        
        if MyBookingsVM.shared.allTabTypes.contains(Int16(BookingTabCategory.upcoming.rawValue)) {
            self.allTabsStr.append(LocalizedString.Upcoming.localized)
        }
        
        if MyBookingsVM.shared.allTabTypes.contains(Int16(BookingTabCategory.completed.rawValue)) {
            if !allTabsStr.contains(LocalizedString.Upcoming.localized) {
                self.allTabsStr.append(LocalizedString.Upcoming.localized)
                self.allTabsStr.append(LocalizedString.Completed.localized)
            } else {
                self.allTabsStr.append(LocalizedString.Completed.localized)
            }
        }
        if MyBookingsVM.shared.allTabTypes.contains(Int16(BookingTabCategory.cancelled.rawValue)) {
            self.allTabsStr.append(LocalizedString.Cancelled.localized)
        }
        
    }
    
    private func hideAllData() {
        self.emptyStateImageView.isHidden = true
        self.emptyStateTitleLabel.isHidden = true
        self.emptyStateSubTitleLabel.isHidden = true
        self.childContainerView.isHidden = true
        self.searchBarContainerView.isHidden = true
    }
}


// Mark:- Extensions
//=================
extension MyBookingsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        MyBookingFilterVM.shared.searchText = ""
        MyBookingFilterVM.shared.filteredResultCount = 0
        MyBookingFilterVM.shared.setToDefault()
        self.navigationController?.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        printDebug("topNavBarFirstRightButtonAction")
        self.dismissKeyboard()
        AppFlowManager.default.showBookingFilterVC(self)
    }
    
    func topNavBarSecondRightButtonAction(_ sender: UIButton) {
        printDebug("topNavBarSecondRightButtonAction")
        self.filterOptionsPopUp()
    }
}


// MARK: - MyBookingFooterViewDelegate

// MARK:- Custom Tab bar


extension MyBookingsVC : PagingViewControllerDataSource , PagingViewControllerDelegate {
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int{
        self.allTabsStr.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return self.allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title:  self.allTabsStr[index])
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, widthForPagingItem pagingItem: PagingIndexItem, isSelected: Bool) -> CGFloat? {
        
        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? PagingIndexItem{
            let text = pagingIndexItem.title
            
            let font = AppFonts.SemiBold.withSize(16.0)
            return text.widthOfString(usingFont: font)
        }
        
        return 100.0
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: T, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) where T : PagingItem, T : Comparable, T : Hashable {
        
        let pagingIndexItem = pagingItem as! PagingIndexItem
        self.currentIndex = pagingIndexItem.index
    }
}


