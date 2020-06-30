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
//    private var statusBarBlurView : UIVisualEffectView!
//    private var headerBlurView : UIVisualEffectView!
    private var statusBarHeight : CGFloat {
        return UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
    }
    
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
            self.searchBar.backgroundColor = AppColors.clear
            self.searchBar.placeholder = LocalizedString.search.localized
            self.searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var emptyStateImageView: UIImageView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    @IBOutlet weak var emptyStateSubTitleLabel: UILabel!
    @IBOutlet weak var blurBackgroundView: BlurView!
    
    // Mark:- LifeCycle
    
    override func initialSetup() {
        self.topNavBar.configureNavBar(title: LocalizedString.MyBookings.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "bookingFilterIcon"), selectedImage: #imageLiteral(resourceName: "bookingFilterIconSelected"))
        self.topNavBar.firstRightBtnTrailingConst.constant = 3.0
        //        self.topNavBar.configureSecondRightButton(normalImage: #imageLiteral(resourceName: "swipeArrow"), selectedImage: #imageLiteral(resourceName: "swipeArrow"))
        self.topNavBar.firstRightButton.isHidden = true
        self.searchBar.cornerRadius = 10.0
        self.searchBar.clipsToBounds = true
        self.hideAllData()        
    }
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification {
            if noti == .myBookingFilterApplied {
                if  MyBookingFilterVM.shared.isFilterAplied() {
                    self.topNavBar.firstRightButton.isSelected = true
                    self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "bookingFilterIconSelected"), selectedImage: #imageLiteral(resourceName: "bookingFilterIconSelected"))
                } else {
                    self.topNavBar.firstRightButton.isSelected = false
                    self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "bookingFilterIcon"), selectedImage: #imageLiteral(resourceName: "bookingFilterIcon"))
                }
            }
            else if noti == .myBookingFilterCleared {
                self.topNavBar.firstRightButton.isSelected = false
                self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "bookingFilterIcon"), selectedImage: #imageLiteral(resourceName: "bookingFilterIcon"))
                MyBookingFilterVM.shared.setToDefault()
            }
            else if noti == .myBookingCasesRequestStatusChanged {
                MyBookingsVM.shared.getBookings(shouldCallWillDelegate: false)
            }
        }
    }
    
    // MARK:- Override methods
    override func viewDidLayoutSubviews() {
        if allTabsStr.count > 1 {
            self.parchmentView?.view.frame = self.childContainerView.bounds
            self.parchmentView?.loadViewIfNeeded()
        } else {
            if let firstVC = self.allChildVCs.first {
                firstVC.view.frame = self.childContainerView.bounds
                firstVC.view.layoutIfNeeded()
            }
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isBookingApiRunned {
            isBookingApiRunned = true
            MyBookingsVM.shared.getBookings()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //addCustomBackgroundBlurView()
        self.statusBarColor = AppColors.clear
        self.statusBarStyle = .default
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.statusBarColor = AppColors.clear
//        self.headerBlurView.removeFromSuperview()
//        self.statusBarBlurView.removeFromSuperview()
    }
    
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
        self.searchBarContainerView.backgroundColor = AppColors.clear
        self.childContainerView.backgroundColor = AppColors.clear
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
            upcomingVC.showFirstDivider = allTabsStr.count ==  1
            self.allChildVCs.append(upcomingVC)
        }
        if  allTabsStr.contains("Completed"){
            let completedVC = CompletedVC.instantiate(fromAppStoryboard: .Bookings)
            completedVC.showFirstDivider = allTabsStr.count ==  1
            self.allChildVCs.append(completedVC)
        }
        if  allTabsStr.contains("Cancelled"){
            let cancelledVC = CancelledVC.instantiate(fromAppStoryboard: .Bookings)
            cancelledVC.showFirstDivider = allTabsStr.count ==  1
            self.allChildVCs.append(cancelledVC)
        }
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        if allTabsStr.count > 1 {
            setupParchmentPageController()
        } else {
            if let firstVC = self.allChildVCs.first {
                firstVC.view.frame = self.childContainerView.bounds
                self.childContainerView.addSubview(firstVC.view)
                self.childContainerView.backgroundColor = UIColor.red
            }
        }
    }
    
    // Added to replace the existing page controller, added Asif Khan
    private func setupParchmentPageController(){
        
        self.parchmentView = PagingViewController()
        var textWidth: CGFloat = 0
        allTabsStr.forEach { (str) in
           textWidth += str.widthOfString(usingFont: AppFonts.Regular.withSize(16.0))
        }
        var menuItemSpacing: CGFloat = 0
        if self.allTabsStr.count > 2 {
            menuItemSpacing = (UIDevice.screenWidth - (textWidth + 28.0 + 28.0))/2 // (screen width - textspace + leading and trailing constant space) / number of tabs - 1
        } else {
            menuItemSpacing = UIDevice.screenWidth - (textWidth + 59.0 + 59.0)
        }
        
        self.parchmentView?.menuItemSpacing = menuItemSpacing // self.allTabsStr.count == 2 ? (UIDevice.screenWidth - 273.0) : (UIDevice.screenWidth - 270.0)/2
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: self.allTabsStr.count == 2 ? 59.0 : 28.0, bottom: 0.0, right:  self.allTabsStr.count == 2 ? 59.0 : 28.0)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets.zero)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 52)
        self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        let nib = UINib(nibName: "MenuItemCollectionCell", bundle: nil)
        self.parchmentView?.register(nib, for: MenuItem.self)
        self.parchmentView?.borderColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
        self.parchmentView?.indicatorColor = AppColors.themeGreen
        self.parchmentView?.selectedTextColor = AppColors.themeBlack
        self.childContainerView.addSubview(self.parchmentView!.view)
        
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: 0)
        
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
        
        self.parchmentView?.menuBackgroundColor = UIColor.clear
        self.parchmentView?.collectionView.backgroundColor = UIColor.clear
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
            self.blurBackgroundView.isHidden = true
            self.topNavBar.firstRightButton.isHidden = true
        } else {
            self.emptyStateImageView.isHidden = true
            self.emptyStateTitleLabel.isHidden = true
            self.emptyStateSubTitleLabel.isHidden = true
            self.childContainerView.isHidden = false
            self.searchBarContainerView.isHidden = false
            self.instantiateChildVC()
            self.setUpViewPager()
            self.blurBackgroundView.isHidden = false
            self.topNavBar.firstRightButton.isHidden = false
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
    /*
    func addCustomBackgroundBlurView(){
            
            headerBlurView = UIVisualEffectView(frame:  CGRect(x: 0 , y: 0, width:self.view.frame.size.width , height: blurBackgroundView.height))
            headerBlurView.effect = UIBlurEffect(style: .prominent)
            headerBlurView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            
            blurBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.85)
            blurBackgroundView.addSubview(headerBlurView)
            
            statusBarBlurView = UIVisualEffectView(frame:  CGRect(x: 0 , y: 0, width:self.view.frame.size.width , height: statusBarHeight))
            statusBarBlurView.effect = UIBlurEffect(style: .prominent)
            self.navigationController?.view.addSubview(statusBarBlurView)
        statusBarBlurView.backgroundColor = UIColor.white.withAlphaComponent(0.85)
            
        }
 */
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
        topNavBar.firstRightButton.isEnabled = false
        delay(seconds: 0.2) { [weak self] in
            self?.topNavBar.firstRightButton.isEnabled = true
        }
    }
    
    func topNavBarSecondRightButtonAction(_ sender: UIButton) {
        printDebug("topNavBarSecondRightButtonAction")
        self.filterOptionsPopUp()
    }
}


// MARK: - MyBookingFooterViewDelegate

// MARK:- Custom Tab bar


extension MyBookingsVC : PagingViewControllerDataSource , PagingViewControllerDelegate, PagingViewControllerSizeDelegate {
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int{
        self.allTabsStr.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return self.allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return MenuItem(title: self.allTabsStr[index], index: index, isSelected:false)
    }
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        
        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? MenuItem{
            let text = pagingIndexItem.title
            
            let font = isSelected ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(16.0)
            print(text)
            print("size: \(text.widthOfString(usingFont: font))")
            return text.widthOfString(usingFont: font)
        }
        
        return 100.0
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        
        if let pagingIndexItem = pagingItem as? MenuItem {
            self.currentIndex = pagingIndexItem.index
        }
    }
}


