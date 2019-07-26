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
    
    private var allTabButtons: [PKCategoryButton] = []
//    private var allTabs: [ATCategoryItem] {
//        var temp = [ATCategoryItem]()
//        for title in self.allTabsStr {
//            var obj = ATCategoryItem()
//            obj.title = title
//            temp.append(obj)
//        }
//        return temp
//    }
//
    
    
//    var allChildVCs: [UIViewController] = []
    private var upcomingVC: UpcomingBookingsVC?
    private var completedVC: CompletedVC?
    private var cancelledVC: CancelledVC?
    private var previousOffset = CGPoint.zero
    
    // Mark:- IBOutlets
    //================
    @IBOutlet var topNavBar: TopNavigationView! {
        didSet {
            self.topNavBar.delegate = self
        }
    }
    
       @IBOutlet var childContainerView: UIView!
    
    
    @IBOutlet weak var allTabsTitleContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var allTabTitleContainerView: UIView!
    @IBOutlet weak var upcomingButton: PKCategoryButton!
    @IBOutlet weak var completedButton: PKCategoryButton!
    @IBOutlet weak var cancelledButton: PKCategoryButton!
    @IBOutlet weak var tabSelectionIndicatorView: UIView!
    @IBOutlet weak var allTabDetailConatinerView: UIScrollView!
    
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
        
//        self.allTabsStr.removeAll()
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
//        self.allChildVCs.removeAll()
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
        
        if self.allTabsStr.count == 1 {
            self.allTabTitleContainerView.isHidden = true
            self.allTabsTitleContainerHeightConstraint.constant = 0.0
        }
        else {
            self.allTabTitleContainerView.isHidden = false
            self.allTabsTitleContainerHeightConstraint.constant = 50.0
        }
        
//        self.allChildVCs.removeAll()
//        for i in 0..<self.allTabsStr.count {
//            if i == 0 {
//                let vc = UpcomingBookingsVC.instantiate(fromAppStoryboard: .Bookings)
//                self.allChildVCs.append(vc)
//            } else if i == 1 {
//                let vc = CompletedVC.instantiate(fromAppStoryboard: .Bookings)
//                self.allChildVCs.append(vc)
//            }
//            else if i == 2 {
//                let vc = CancelledVC.instantiate(fromAppStoryboard: .Bookings)
//                self.allChildVCs.append(vc)
//            }
//            else {
//                printDebug("No vc")
//            }
//        }
        
        if self.upcomingVC == nil {
            self.configureTabBar()
        }
        
    }
    
//    private func setupPagerView(headerHeight: CGFloat = 50.0, interItemSpace: CGFloat, itemPadding: CGFloat, isScrollable: Bool = true) {
//        var style = ATCategoryNavBarStyle()
//        style.height = headerHeight
//        style.interItemSpace = interItemSpace
//        style.itemPadding = itemPadding
//        style.isScrollable = isScrollable
//        style.layoutAlignment = .left
//        style.isEmbeddedToView = true
//        style.showBottomSeparator = true
//        style.bottomSeparatorColor = AppColors.themeGray40
//        style.defaultFont = AppFonts.Regular.withSize(16.0)
//        style.selectedFont = AppFonts.SemiBold.withSize(16.0)
//        style.indicatorColor = AppColors.themeGreen
//        style.normalColor = AppColors.textFieldTextColor51
//        style.selectedColor = AppColors.themeBlack
//        //        style.badgeDotSize = CGSize(width: 0.0, height: 0.0)
//        //        style.badgeBackgroundColor = AppColors.themeGreen
//        //        style.badgeBorderColor = AppColors.clear
//        //        style.badgeBorderWidth = 0.0
//
//        if let _ = self.categoryView {
//            self.categoryView?.removeFromSuperview()
//            self.categoryView = nil
//        }
//        let categoryView = ATCategoryView(frame: self.childContainerView.bounds, categories: self.allTabs, childVCs: self.allChildVCs, parentVC: self, barStyle: style)
//        self.categoryView = categoryView
//        categoryView.interControllerSpacing = 0.0
//
//        self.childContainerView.addSubview(categoryView)
//
//        // Set last Selected Index on Nav bar
//        self.categoryView.select(at: 0)
//    }
    
    
    private func hideAllData() {
        self.emptyStateImageView.isHidden = true
        self.emptyStateTitleLabel.isHidden = true
        self.emptyStateSubTitleLabel.isHidden = true
        self.childContainerView.isHidden = true
        self.searchBarContainerView.isHidden = true
    }
    
    
    // MARK: - IB Action
   
    @IBAction func upcomingButtonAction(_ sender: PKCategoryButton) {
        if let idx = self.allTabButtons.firstIndex(of: sender) {
            self.selectTab(atIndex: CGFloat(idx), animated: true)
        }
    }
    
    @IBAction func completedButtonAction(_ sender: PKCategoryButton) {
        if let idx = self.allTabButtons.firstIndex(of: sender) {
            self.selectTab(atIndex: CGFloat(idx), animated: true)
        }
    }
    
    @IBAction func cancelledButtonAction(_ sender: PKCategoryButton) {
        if let idx = self.allTabButtons.firstIndex(of: sender) {
            self.selectTab(atIndex: CGFloat(idx), animated: true)
        }
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

// MARK: - ATCategoryNavBarDelegate

extension MyBookingsVC: ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
        MyBookingFilterVM.shared.lastSelectedIndex = toIndex
    }
}

// MARK: - MyBookingFooterViewDelegate

// MARK:- Custom Tab bar

extension MyBookingsVC {
    
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
            button.tintColor = AppColors.themeWhite.withAlphaComponent(0.1)
        }
        
        //upcoming  button
        configure(button: self.upcomingButton, title: LocalizedString.Upcoming.localized)
        
        //completed Type button
        configure(button: self.completedButton, title: LocalizedString.Completed.localized)
        
        //cancelled Date button
        configure(button: self.cancelledButton, title: LocalizedString.Cancelled.localized)
        
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
        self.upcomingButton.isHidden = true
        if self.upcomingVC == nil, self.allTabsStr.contains(LocalizedString.Upcoming.localized) {
            
            self.upcomingVC = UpcomingBookingsVC.instantiate(fromAppStoryboard: .Bookings)
            
            self.allTabDetailConatinerView.addSubview(self.upcomingVC!.view)
            self.upcomingButton.isHidden = false
            self.allTabButtons.append(self.upcomingButton)
        }
        self.upcomingVC?.view.frame = CGRect(x: (self.allTabDetailConatinerView.width * 0.0), y: 0.0, width: self.allTabDetailConatinerView.width, height: self.allTabDetailConatinerView.height)
        
        
        //completed Type
        self.completedButton.isHidden = true
        if self.completedVC == nil, self.allTabsStr.contains(LocalizedString.Completed.localized) {

            self.completedVC = CompletedVC.instantiate(fromAppStoryboard: .Bookings)

            self.allTabDetailConatinerView.addSubview(completedVC!.view)
            self.completedButton.isHidden = false
            self.allTabButtons.append(self.completedButton)
        }
        self.completedVC?.view.frame = CGRect(x: (self.allTabDetailConatinerView.width * 1.0), y: 0.0, width: self.allTabDetailConatinerView.width, height: self.allTabDetailConatinerView.height)
        
        //cancelled Date
        self.cancelledButton.isHidden = true
        if self.cancelledVC == nil, self.allTabsStr.contains(LocalizedString.Cancelled.localized) {
            
            self.cancelledVC = CancelledVC.instantiate(fromAppStoryboard: .Bookings)
            self.allTabDetailConatinerView.addSubview(cancelledVC!.view)
            self.cancelledButton.isHidden = false
            self.allTabButtons.append(self.cancelledButton)
        }
        let spaceIndex: CGFloat = self.completedVC == nil ? 1.0 : 2.0
        self.cancelledVC?.view.frame = CGRect(x: (self.allTabDetailConatinerView.width * spaceIndex), y: 0.0, width: self.allTabDetailConatinerView.width, height: self.allTabDetailConatinerView.height)
    }
}

extension MyBookingsVC {
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

