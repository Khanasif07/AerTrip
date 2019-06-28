//
//  BookingRequestAddOnsFFVC.swift
//  AERTRIP
//
//  Created by apple on 21/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingRequestAddOnsFFVC: BaseVC {
    
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var topNavigationView: TopNavigationView!
    @IBOutlet weak var dataContainerView : UIView!
    @IBOutlet weak var requestButton: UIButton!
    
    // MARK: - Properties
    private var currentIndex: Int = 0
    private let selectedIndex:Int = 0
    private var allChildVCs : [UIViewController]  = [UIViewController]()
    private var allTabsStr: [String] = [LocalizedString.AddOns.localized]
    
    fileprivate weak var categoryView: ATCategoryView!
    private var allTabs: [ATCategoryItem] {
        var temp = [ATCategoryItem]()
        
        for title in self.allTabsStr {
            var obj = ATCategoryItem()
            obj.title = title
            temp.append(obj)
        }
        
        return temp
    }
    
    
    
    override func initialSetup() {
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.currentIndex = 0
        if !BookingRequestAddOnsFFVM.shared.isLCC {
            self.allTabsStr.append(LocalizedString.FrequentFlyer.localized)
        }
        
        for i in 0..<self.allTabsStr.count {
            if i == 0 {
                let vc = AddOnsVC.instantiate(fromAppStoryboard: .Bookings)
                self.allChildVCs.append(vc)
            } else if i == 1 {
                let vc = FrequentFlyerVC.instantiate(fromAppStoryboard: .Bookings)
                self.allChildVCs.append(vc)
            }
        }
        self.setupPagerView()
         self.requestButton.addGredient(isVertical: false)
        self.setupNavBar()
        
       
        BookingRequestAddOnsFFVM.shared.getPreferenceMaster()
        
    }
    
    override func setupNavBar() {
        self.topNavigationView.delegate = self
        self.topNavigationView.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.topNavigationView.navTitleLabel.textColor = AppColors.themeBlack
        self.topNavigationView.configureNavBar(title: LocalizedString.RequestAddOnsAndFF.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavigationView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.CancelWithRightSpace.localized, selectedTitle: LocalizedString.CancelWithRightSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        
    }
    
    
    override func setupFonts() {
        self.requestButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupTexts() {
        self.requestButton.setTitle(LocalizedString.Request.localized, for: .normal)
        self.requestButton.setTitle(LocalizedString.Request.localized, for: .selected)
    }
    
    override func setupColors() {
        self.requestButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.requestButton.setTitleColor(AppColors.themeWhite, for: .normal)
    }
    
   

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.categoryView?.frame = self.dataContainerView.bounds
        self.categoryView?.layoutIfNeeded()
    }
    
    
    
    
    private func setupPagerView() {
        var style = ATCategoryNavBarStyle()
        style.height = 49.0 // category bar Height
        style.interItemSpace = 110.0
        style.itemPadding = 8.0
        style.isScrollable = false
        style.layoutAlignment = .center
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
        
        
        let categoryView = ATCategoryView(frame: self.dataContainerView.bounds, categories: self.allTabs, childVCs: self.allChildVCs, parentVC: self, barStyle: style)
        categoryView.interControllerSpacing = 0.0
        categoryView.navBar.internalDelegate = self
        self.dataContainerView.addSubview(categoryView)
        self.categoryView = categoryView
        
        
    }
    
    
    @IBAction func requstButtonTapped(_ sender: Any) {
   // AppFlowManager.default.showAddonRequestSent(buttonTitle:LocalizedString.Done.localized)
    }
    
    
    
    
    
}


// MARK: - ATCategoryNavBarDelegate

extension BookingRequestAddOnsFFVC: ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
        
    }
}


// MARK: - TopNavgiation View Delegate

extension BookingRequestAddOnsFFVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        printDebug("Optional")
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        printDebug("Updated Booking details:\(BookingRequestAddOnsFFVM.shared.bookingDetails)")
        dismiss(animated: true)
    }
    
    
}


// MARK: - Booking
