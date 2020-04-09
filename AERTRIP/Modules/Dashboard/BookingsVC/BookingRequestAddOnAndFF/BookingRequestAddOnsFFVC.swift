//
//  BookingRequestAddOnsFFVC.swift
//  AERTRIP
//
//  Created by apple on 21/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment

protocol BookingRequestAddOnsFFVCDelegate: class  {
    func addOnAndFFUpdated()
}

class BookingRequestAddOnsFFVC: BaseVC {
    // MARK: - IBOutlet
    
    @IBOutlet weak var topNavigationView: TopNavigationView!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    // MARK: - Properties
    
    private var currentIndex: Int = 0
    private let selectedIndex: Int = 0
    private var allChildVCs: [UIViewController] = [UIViewController]()
    private var allTabsStr: [String] = [LocalizedString.AddOns.localized]
    weak var delegate: BookingRequestAddOnsFFVCDelegate?
    
    //fileprivate weak var categoryView: ATCategoryView!
    // Parchment View
    fileprivate var parchmentView : PagingViewController?
//    private var allTabs: [ATCategoryItem] {
//        var temp = [ATCategoryItem]()
//
//        for title in self.allTabsStr {
//            var obj = ATCategoryItem()
//            obj.title = title
//            temp.append(obj)
//        }
//
//        return temp
//    }
    
    override func initialSetup() {
        //self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        self.currentIndex = 0
        if !BookingRequestAddOnsFFVM.shared.isLCC {
            self.allTabsStr.append(LocalizedString.FrequentFlyer.localized)
        }
        
        self.setupPagerView()
        self.setupNavBar()
        let frequentFlyerData = BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerDatas ?? []
        BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData = frequentFlyerData
        BookingRequestAddOnsFFVM.shared.getPreferenceMaster()
        self.gradientView.addGredient(isVertical: false)
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
    
    override func bindViewModel() {
        BookingRequestAddOnsFFVM.shared.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.parchmentView?.view.frame = self.dataContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
        self.gradientView.addGredient(isVertical: false)
    }
    
    private func setupPagerView() {
        self.currentIndex = 0
        self.allChildVCs.removeAll()
        for i in 0..<self.allTabsStr.count {
            if i == 0 {
                let vc = AddOnsVC.instantiate(fromAppStoryboard: .Bookings)
                self.allChildVCs.append(vc)
            } else if i == 1 {
                let vc = FrequentFlyerVC.instantiate(fromAppStoryboard: .Bookings)
                self.allChildVCs.append(vc)
            }
        }
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        setupParchmentPageController()
    }
    
    // Added to replace the existing page controller, added Asif Khan, 28-29Jan'2020
    private func setupParchmentPageController(){
        
        self.parchmentView = PagingViewController()
        if self.allTabsStr.count == 1 {
            self.parchmentView?.menuHorizontalAlignment = .center
        }
        self.parchmentView?.menuItemSpacing = self.allTabsStr.count == 2 ? (UIDevice.screenWidth - 273.0) : (UIDevice.screenWidth - 273.0)/2
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
        self.dataContainerView.addSubview(self.parchmentView!.view)
        
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: 0)
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
        
    }
    
    @IBAction func requstButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        // AppFlowManager.default.showAddonRequestSent(buttonTitle:LocalizedString.Done.localized)
        BookingRequestAddOnsFFVM.shared.postAddOnRequest()
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
        dismiss(animated: true)
    }
}

// MARK: - BookingRequestAddOnsFFVMDelegate methods called

extension BookingRequestAddOnsFFVC: BookingRequestAddOnsFFVMDelegate {
    func willGetPreferenceMaster() {
        //
    }
    
    func getPreferenceMasterSuccess() {
        //
    }
    
    func getPreferenceMasterFail() {
        //
    }
    
    func willSendAddOnFFRequest() {
        AppGlobals.shared.startLoading()
    }
    
    func sendAddOnFFRequestSuccess() {
        AppFlowManager.default.showAddonRequestSent(buttonTitle: "", delegate: self)
        AppGlobals.shared.stopLoading()
    }
    
    func failAddOnFFRequestFail(errorCode: ErrorCodes) {
        AppToast.default.showToastMessage(message: LocalizedString.SomethingWentWrong.localized)
        AppGlobals.shared.stopLoading()
    }
}

extension BookingRequestAddOnsFFVC: BulkEnquirySuccessfulVCDelegate {
    func doneButtonAction() {
          self.delegate?.addOnAndFFUpdated()
          self.dismiss(animated: true)
    }
}

extension BookingRequestAddOnsFFVC: PagingViewControllerDataSource , PagingViewControllerDelegate, PagingViewControllerSizeDelegate {
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title:  self.allTabsStr[index])
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        self.allTabsStr.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController  {
        return self.allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        
        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? PagingIndexItem{
            let text = pagingIndexItem.title
            
            let font = AppFonts.SemiBold.withSize(16.0)
            return text.widthOfString(usingFont: font) + 2.5
        }
        
        return 100.0
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool){
        
        let pagingIndexItem = pagingItem as! PagingIndexItem
        self.currentIndex = pagingIndexItem.index
    }
}
