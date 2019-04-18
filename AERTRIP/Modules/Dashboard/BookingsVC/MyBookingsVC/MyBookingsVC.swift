//
//  MyBookingsVC.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class MyBookingsVC: BaseVC {
    
    //Mark:- Variables
    //================
    let viewModel = MyBookingsVM()
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
    private var allChildVCs: [UIViewController] = [UIViewController]()
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var topNavBar: TopNavigationView! {
        didSet {
            self.topNavBar.delegate = self
        }
    }
    @IBOutlet weak var searchBarContainerView: UIView!
    @IBOutlet weak var searchBar: ATSearchBar! {
        didSet {
            self.searchBar.backgroundColor = AppColors.screensBackground.color
        }
    }
    @IBOutlet weak var emptyStateImageView: UIImageView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    @IBOutlet weak var emptyStateSubTitleLabel: UILabel!
    @IBOutlet var childContainerView: UIView!
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.topNavBar.configureNavBar(title: LocalizedString.MyBookings.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: false)
        self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "ic_hotel_filter"), selectedImage: #imageLiteral(resourceName: "ic_hotel_filter"))
        self.topNavBar.configureSecondRightButton(normalImage: #imageLiteral(resourceName: "swipeArrow"), selectedImage: #imageLiteral(resourceName: "swipeArrow"))
        self.searchBar.cornerRadius = 10.0
        self.searchBar.clipsToBounds = true
        self.emptyStateSetUp()
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

    }
    
    override func bindViewModel() {
        
    }
    
    //Mark:- Functions
    //================
    private func filterOptionsPopUp() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.TravelDate.localized,LocalizedString.EventType.localized,LocalizedString.BookingDate.localized], colors: [AppColors.themeGreen,AppColors.themeGreen,AppColors.themeGreen])
        _ = PKAlertController.default.presentActionSheetWithTextAllignMentAndImage(nil, message: nil, sourceView: view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton , textAlignment: CATextLayerAlignmentMode.center , selectedButtonIndex: self.selectedButton) { _, index in
            switch index {
            case 0:
                self.selectedButton = index
                printDebug(LocalizedString.TravelDate.localized)
            case 1:
                self.selectedButton = index
                printDebug(LocalizedString.EventType.localized)
            case 2:
                self.selectedButton = index
                printDebug(LocalizedString.BookingDate.localized)
            default:
                printDebug("default")
            }
        }
    }
    
    private func emptyStateSetUp() {
        if self.viewModel.upComingBookingsData.isEmpty , self.viewModel.completedBookingsData.isEmpty , self.viewModel.cancelledBookingData.isEmpty {
            self.emptyStateImageView.isHidden = false
            self.emptyStateTitleLabel.isHidden = false
            self.emptyStateSubTitleLabel.isHidden = false
            self.childContainerView.isHidden = true
        } else {
            self.emptyStateImageView.isHidden = true
            self.emptyStateTitleLabel.isHidden = true
            self.emptyStateSubTitleLabel.isHidden = true
            self.childContainerView.isHidden = false
            self.instantiateChildVC()
        }
    }
    
    private func instantiateChildVC() {
        
        if !self.viewModel.upComingBookingsData.isEmpty {
            self.allTabsStr.append(LocalizedString.Upcoming.localized)
            if !self.viewModel.completedBookingsData.isEmpty {
                self.allTabsStr.append(LocalizedString.Completed.localized)
            }
            if !self.viewModel.cancelledBookingData.isEmpty {
                self.allTabsStr.append(LocalizedString.Cancelled.localized)
            }
        }
        
        for i in 0..<self.allTabsStr.count {
            if i == 0 {
                let vc = UpcomingBookingsVC.instantiate(fromAppStoryboard: .Bookings)
                self.allChildVCs.append(vc)
            } else if i == 1 , !self.viewModel.completedBookingsData.isEmpty {
                let vc = CompletedVC.instantiate(fromAppStoryboard: .Bookings)
                self.allChildVCs.append(vc)
            } else if !self.viewModel.cancelledBookingData.isEmpty {
                let vc = CancelledVC.instantiate(fromAppStoryboard: .Bookings)
                self.allChildVCs.append(vc)
            } else {
                printDebug("No vc")
            }
        }
        
        if self.allChildVCs.count == 1 {
            self.setupPagerView(headerHeight: 0.0, interItemSpace: 0.0, itemPadding: 0.0 , isScrollable: false)
        } else if self.allChildVCs.count == 2 {
            self.setupPagerView(interItemSpace: 45.0, itemPadding: 32.0)
        } else {
            self.setupPagerView(interItemSpace: 21.8, itemPadding: 12.8)
        }
    }
    
    private func setupPagerView(headerHeight: CGFloat = 50.0 , interItemSpace: CGFloat , itemPadding: CGFloat , isScrollable: Bool = true) {
        var style = ATCategoryNavBarStyle()
        style.height = headerHeight//50.0
        style.interItemSpace = interItemSpace//21.8
        style.itemPadding = itemPadding//12.8
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
        
        let categoryView = ATCategoryView(frame: self.childContainerView.bounds, categories: self.allTabs, childVCs: self.allChildVCs, parentVC: self, barStyle: style)
        categoryView.interControllerSpacing = 0.0
        categoryView.navBar.internalDelegate = self
        self.childContainerView.addSubview(categoryView)
        self.categoryView = categoryView
        
        // Set last Selected Index on Nav bar
        self.categoryView.select(at: 0)
    }
    //Mark:- IBActions
    //================
}

//Mark:- Extensions
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
        HotelFilterVM.shared.lastSelectedIndex = toIndex
    }
}
