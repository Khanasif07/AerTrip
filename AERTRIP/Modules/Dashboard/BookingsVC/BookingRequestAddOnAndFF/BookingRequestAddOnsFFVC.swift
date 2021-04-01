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

protocol BookingRequestAddOnsFFVCTextfiledDelegate: class{
    func closeKeyboard()
}

class BookingRequestAddOnsFFVC: BaseVC {
    // MARK: - IBOutlet
    
    @IBOutlet weak var topNavigationView: TopNavigationView!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var currentIndex: Int = 0
    private let selectedIndex: Int = 0
    private var allChildVCs: [UIViewController] = [UIViewController]()
    private var allTabsStr: [String] = [LocalizedString.AddOns.localized]
    weak var delegate: BookingRequestAddOnsFFVCDelegate?
    
    static let shared = BookingRequestAddOnsFFVC()

    var isRequestButtonEnabled = false
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
        self.setupRequestButton()
        let frequentFlyerData = BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerDatas ?? []
        BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData = frequentFlyerData
        BookingRequestAddOnsFFVM.shared.getPreferenceMaster()
        self.gradientView.addGredient(isVertical: false)
        
        
//        FirebaseAnalyticsController.shared.logEvent(name: "BookingRequestAddOns", params: ["ScreenName":"BookingRequestAddOns", "ScreenClass":"BookingRequestAddOnsFFVC", "ButtonAction":"RequestAddonAndFrequentFlyer"])

        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Bookings.rawValue, params: [AnalyticsKeys.FilterName.rawValue:FirebaseEventLogs.EventsTypeName.BookingsRequestAddOns, AnalyticsKeys.FilterType.rawValue: "LoggedInUserType", AnalyticsKeys.Values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a"])

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarStyle = .darkContent
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
    
//    override func setupColors() {
//        self.requestButton.setTitleColor(AppColors.themeWhite, for: .normal)
//        self.requestButton.setTitleColor(AppColors.themeWhite, for: .normal)
//    }
    
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
                vc.delegate = self
                self.allChildVCs.append(vc)
            } else if i == 1 {
                let vc = FrequentFlyerVC.instantiate(fromAppStoryboard: .Bookings)
                vc.delegate = self
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
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: self.allTabsStr.count == 2 ? 59.0 : 28.0, bottom: 0.0, right:  self.allTabsStr.count == 2 ? 59.0 : 28.0)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0), insets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0))
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 50)
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
        self.dataContainerView.addSubview(self.parchmentView!.view)
        
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: 0)
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
        
    }
    
    func manageLoader(shouldStart: Bool) {
        self.indicatorView.style = .medium//.white
        self.indicatorView.color = AppColors.themeWhite
        if shouldStart{
            self.requestButton.setTitle("", for: .normal)
            self.requestButton.setTitle("", for: .selected)
            self.indicatorView.startAnimating()
        }else{
            self.indicatorView.stopAnimating()
            self.requestButton.setTitle(LocalizedString.Request.localized, for: .normal)
            self.requestButton.setTitle(LocalizedString.Request.localized, for: .selected)
        }
    }
    
    @IBAction func requstButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        //  BookingRequestAddOnsFFVM.shared.postAddOnRequest()
        
        if isRequestButtonEnabled{
            BookingRequestAddOnsFFVM.shared.postAddOnRequest()
        }
        
        
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
        self.manageLoader(shouldStart: true)
    }
    
    func sendAddOnFFRequestSuccess() {
       // AppFlowManager.default.showAddonRequestSent(buttonTitle: "", delegate: self)
        
        var config = BulkEnquirySuccessfulVC.ButtonConfiguration()
        config.text = self.requestButton.title(for: .normal) ?? ""
          config.textFont = AppFonts.SemiBold.withSize(20.0)
          config.cornerRadius = 0.0
          config.width = self.requestButton.width
            config.buttonHeight = self.gradientView.height
          config.spaceFromBottom = AppFlowManager.default.safeAreaInsets.bottom
          AppFlowManager.default.showAddonRequestSent(buttonConfig: config, delegate: self)

        self.manageLoader(shouldStart: false)
    }
    
    func failAddOnFFRequestFail(errorCode: ErrorCodes) {
        AppToast.default.showToastMessage(message: LocalizedString.SomethingWentWrong.localized)
        self.manageLoader(shouldStart: false)
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
        return MenuItem(title: self.allTabsStr[index], index: index, isSelected:false)
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        self.allTabsStr.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController  {
        return self.allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        
        if let pagingIndexItem = pagingItem as? MenuItem{
            let text = pagingIndexItem.title
            
            let font = isSelected ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(16.0)
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



extension BookingRequestAddOnsFFVC:BookingRequestAddOnsFFVCTextfiledDelegate
{
    func closeKeyboard() {
        setupRequestButton()
    }
    
    func setupRequestButton()
    {
        var isAnythingEdited = false
        for leg in BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg ?? [] {
            for pax in leg.pax {
                if !pax.seat.isEmpty || !pax.meal.isEmpty || !pax.baggage.isEmpty || !pax.other.isEmpty || !pax.mealPreferenes.isEmpty{
                    isAnythingEdited = true
                }
            }
        }
        
        for leg in BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData ?? [] {
            for flight in leg.flights{
                if !flight.frequentFlyerNumber.isEmpty{
                    isAnythingEdited = true
                }
            }
        }
                
        if  !isAnythingEdited{
            self.requestButton.setTitleColor(AppColors.themeWhite.withAlphaComponent(0.5), for: .normal)
            isRequestButtonEnabled = false
        }else{
            self.requestButton.setTitleColor(AppColors.themeWhite.withAlphaComponent(1.0), for: .normal)
            isRequestButtonEnabled = true
        }
    }
}
