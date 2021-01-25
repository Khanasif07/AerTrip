//
//  AppFlowManager.swift
//
//
//  Created by Pramod Kumar on 24/07/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import CoreData
import Foundation
import UIKit

enum ViewPresnetEnum {
    case push, present, popup
}

class AppFlowManager: NSObject {
    @objc static let `default` = AppFlowManager()
    
    var sideMenuController: PKSideMenuController? {
        return self.mainHomeVC?.sideMenuController
    }
    
    var mainHomeVC: MainHomeVC?
    var documentInteractionController = UIDocumentInteractionController()
    var showHotelResult = false
    
    private var blurEffectView: UIVisualEffectView?
    private let urlScheme = "://"
    private var loginVerificationComplition: ((_ isGuest: Bool) -> Void)?
    
    
    private override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataChanged(_:)), name: .dataChanged, object: nil)
    }
    ///Change because flight is not added in main navigation currently.
    //    var safeAreaInsets: UIEdgeInsets {
    //        return AppFlowManager.default.mainNavigationController.view.safeAreaInsets
    //    }
    var safeAreaInsets: UIEdgeInsets {
        if self.mainNavigationController != nil{
            return AppFlowManager.default.mainNavigationController.view.safeAreaInsets
        }else{
            return currentNavigation?.view.safeAreaInsets ?? UIEdgeInsets()
        }
        
    }
    
    var mainNavigationController: UINavigationController! {
        didSet {
            let textAttributes = [NSAttributedString.Key.font: AppFonts.Regular.withSize(17.0),
                                  NSAttributedString.Key.foregroundColor: AppColors.themeWhite]
            
            mainNavigationController.navigationBar.titleTextAttributes = textAttributes
            mainNavigationController.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            mainNavigationController.navigationBar.shadowImage = nil
            mainNavigationController.navigationBar.barTintColor = AppColors.themeWhite
            mainNavigationController.navigationBar.backgroundColor = AppColors.themeWhite
            mainNavigationController.navigationBar.tintColor = AppColors.themeGreen
            //mainNavigationController.navigationBar.isTranslucent = false
            mainNavigationController.interactivePopGestureRecognizer?.delegate = self
            
            if oldValue != nil {
                oldValue.interactivePopGestureRecognizer?.delegate = nil
            }
        }
    }
    
    var currentNavigation:UINavigationController?{
        return UIApplication.topViewController()?.navigationController
    }
    
    func getNavigationController(forPresentVC: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: forPresentVC)
        let textAttributes = [NSAttributedString.Key.font: AppFonts.Regular.withSize(17.0),
                              NSAttributedString.Key.foregroundColor: AppColors.themeWhite]
        
        nav.navigationBar.titleTextAttributes = textAttributes
        nav.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        nav.navigationBar.shadowImage = nil
        nav.navigationBar.barTintColor = AppColors.themeWhite
        nav.navigationBar.backgroundColor = AppColors.themeWhite
        nav.navigationBar.tintColor = AppColors.themeGreen
        nav.interactivePopGestureRecognizer?.delegate = self

        //nav.navigationBar.isTranslucent = false
        //nav.interactivePopGestureRecognizer?.delegate = self
        
        return nav
    }
    
    @objc private func dataChanged(_ note: Notification) {
        // function intended to override
        if let noti = note.object as? ATNotification, let com = loginVerificationComplition {
            switch noti {
            case .userAsGuest:
                com(true)
            case .userLoggedInSuccess(let dict):
                com(false)
            default:
                break
            }
        }
    }
    
    private var window: UIWindow {
        if let window = AppDelegate.shared.window {
            return window
        }
        else {
            AppDelegate.shared.window = UIWindow()
            return AppDelegate.shared.window!
        }
    }
    
    func openSideMenu() {}
    
    func closeSideMenu() {}
    
    //    func openCamera(ctx: UIViewController.ImagePickerDelegateController, sender: UIView) {
    //        self.mainNavigationController.captureImage(delegate: ctx, sender: sender)
    //    }
    
    private func addBlurToStatusBar() {
        //        if self.blurEffectView == nil {
        //            let bEffect = UIBlurEffect(style: .regular)
        //            let bEffectView = UIVisualEffectView(effect: bEffect)
        //            bEffectView.frame = UIApplication.shared.statusBarFrame
        //            bEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //            bEffectView.alpha = 0.8
        //
        //            self.blurEffectView = bEffectView
        //            self.window.addSubview(bEffectView)
        //        }
    }
    
    func setupSplashAnimationFlow() {
        let splashAnimationScene = SplashAnimationVC.instantiate(fromAppStoryboard: .SplashAnimation)
        self.window.rootViewController = splashAnimationScene
        //self.window.becomeKey()
        self.window.backgroundColor = .black
        self.window.makeKeyAndVisible()
    }
    
    func setupInitialFlow() {
        self.goToDashboard(launchThroughSplash: true)
        self.addBlurToStatusBar()
    }
    
    func goToDashboard(launchThroughSplash: Bool = false, toBeSelect: DashboardVC.SelectedOption = .aerin) {
        let mainHome = MainHomeVC.instantiate(fromAppStoryboard: .Dashboard)
        self.mainHomeVC = mainHome
        self.mainHomeVC?.isLaunchThroughSplash = launchThroughSplash
        self.mainHomeVC?.toBeSelect = toBeSelect
        let nvc = UINavigationController(rootViewController: mainHome)
        // nvc.delegate = AppDelegate.shared.transitionCoordinator
        self.mainNavigationController = nvc
        self.window.rootViewController = nvc
        //self.window.becomeKey()
        self.window.backgroundColor = .black
        self.window.makeKeyAndVisible()
    }
    
    // check and manage the further processing if user logged-in or not
    func proccessIfUserLoggedIn(verifyingFor: LoginFlowUsingFor, presentViewController: Bool = false, completion: ((_ isGuest: Bool) -> Void)?) {
        self.loginVerificationComplition = completion
        if let _ = UserInfo.loggedInUserId {
            // user is logged in
            completion?(false)
        }
        else {
            // user note logged in
            // open login flow
            
            let socialVC = SocialLoginVC.instantiate(fromAppStoryboard: .PreLogin)
            socialVC.currentlyUsingFrom = verifyingFor
            
            delay(seconds: 0.1) { [weak socialVC] in
                socialVC?.animateContentOnLoad()
            }
            
            if presentViewController {
                let newNavigation = self.getNavigationController(forPresentVC: socialVC)
                newNavigation.modalPresentationStyle = .overFullScreen
                self.currentNavigation?.presentAsPushAnimation(newNavigation)
            } else {
                self.currentNavigation?.pushViewController(socialVC, animated: true)
            }
            AppGlobals.shared.stopLoading()
            
        }
    }
    
    // check and manage the further processing if user logged-in or not
    @objc func proccessIfUserLoggedInForFlight(verifyingFor: LoginFlowUsingFor, presentViewController: Bool = false, vc: UIViewController, completion: ((_ isGuest: Bool) -> Void)?) {
        self.loginVerificationComplition = completion
        if let _ = UserInfo.loggedInUserId {
            // user is logged in
            completion?(false)
        }
        else {
            // user note logged in
            // open login flow
            
            let socialVC = SocialLoginVC.instantiate(fromAppStoryboard: .PreLogin)
            socialVC.currentlyUsingFrom = verifyingFor
            
            delay(seconds: 0.1) { [weak socialVC] in
                socialVC?.animateContentOnLoad()
            }
            
            if presentViewController {
                let newNavigation = self.getNavigationController(forPresentVC: socialVC)
                newNavigation.modalPresentationStyle = .overFullScreen
                vc.presentAsPushAnimation(newNavigation)
            } else {
                self.currentNavigation?.pushViewController(socialVC, animated: true)
            }
            AppGlobals.shared.stopLoading()
            
        }
    }
    
}

// MARK: - Public Navigation func

extension AppFlowManager {
    func moveToLogoutNavigation() {}
    
    func showURLOnATWebView(_ url: URL, screenTitle: String, presentingStatusBarStyle: UIStatusBarStyle = .darkContent, dismissalStatusBarStyle: UIStatusBarStyle = .darkContent) {
        let obj = ATWebViewVC.instantiate(fromAppStoryboard: .Common)
        obj.urlToLoad = url
        obj.navTitle = screenTitle
        obj.presentingStatusBarStyle = presentingStatusBarStyle
        obj.dismissalStatusBarStyle = dismissalStatusBarStyle
        //        self.mainNavigationController.present(obj, animated: true, completion: nil)
        UIApplication.topViewController()?.present(obj, animated: true, completion: nil)
    }
    
    func showHTMLOnATWebView(_ html: String, screenTitle: String) {
        let obj = ATWebViewVC.instantiate(fromAppStoryboard: .Common)
        obj.htmlString = html
        obj.navTitle = screenTitle
        //        self.mainNavigationController.present(obj, animated: true, completion: nil)
        //        UIApplication.topViewController()?.present(obj, animated: true, completion: nil)
        self.currentNavigation?.present(obj, animated: true, completion: nil)
    }
    
    func moveToLoginVC(email: String, usingFor: LoginFlowUsingFor = .loginProcess) {
        let ob = LoginVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.email = email
        ob.currentlyUsingFrom = usingFor
        self.currentNavigation?.pushViewController(ob, animated: true)
    }
    
    func moveToCreateYourAccountVC(email: String, usingFor: LoginFlowUsingFor = .loginProcess) {
        let ob = CreateYourAccountVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.email = email
        ob.currentlyUsingFrom = usingFor
        self.currentNavigation?.pushViewController(ob, animated: true)
    }
    
    func moveToRegistrationSuccefullyVC(type: ThankYouRegistrationVM.VerifyRegistrasion, email: String, refId: String = "", token: String = "") {
        let ob = ThankYouRegistrationVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.type = type
        ob.viewModel.email = email
        ob.viewModel.refId = refId
        ob.viewModel.token = token
        self.currentNavigation?.pushViewController(ob, animated: true)
    }
    
    func deeplinkToRegistrationSuccefullyVC(type: ThankYouRegistrationVM.VerifyRegistrasion, email: String, refId: String = "", token: String = "") {
        let ob = ThankYouRegistrationVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.type = type
        ob.viewModel.email = email
        ob.viewModel.refId = refId
        ob.viewModel.token = token
        
        let nvc = UINavigationController(rootViewController: ob)
        self.mainNavigationController = nvc
        self.window.rootViewController = nvc
        self.window.becomeKey()
        self.window.makeKeyAndVisible()
    }
    
    func moveToEditProfileVC(travelData: TravelDetailModel?, usingFor: EditProfileVM.UsingFor) {
        let ob = EditProfileVC.instantiate(fromAppStoryboard: .Profile)
        ob.viewModel.travelData = travelData
        ob.viewModel.currentlyUsinfFor = usingFor
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToSecureAccountVC(isPasswordType: SecureYourAccountVM.SecureAccount, email: String = "", key: String = "", token: String = "") {
        let ob = SecureYourAccountVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.isPasswordType = isPasswordType
        ob.viewModel.email = email
        ob.viewModel.hashKey = key
        ob.viewModel.token = token
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToCreateProfileVC(refId: String, email: String, password: String) {
        let ob = CreateProfileVC.instantiate(fromAppStoryboard: .PreLogin)
        
        ob.viewModel.userData.paxId = refId
        ob.viewModel.userData.email = email
        ob.viewModel.userData.password = password
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToForgotPasswordVC(email: String) {
        let ob = ForgotPasswordVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.email = email
        self.currentNavigation?.pushViewController(ob, animated: true)
    }
    
    func moveResetSuccessFullyPopup(vc: UIViewController) {
        let ob = SuccessPopupVC.instantiate(fromAppStoryboard: .PreLogin)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToViewProfileVC(comingfromDeepLink: Bool = false) {
        let ob = ViewProfileVC.instantiate(fromAppStoryboard: .Profile)
        ob.viewModel.isComingFromDeepLink = comingfromDeepLink
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToViewProfileDetailVC(_ travellerDetails: TravelDetailModel, usingFor: EditProfileVM.UsingFor) {
        let ob = ViewProfileDetailVC.instantiate(fromAppStoryboard: .Profile)
        ob.viewModel.travelData = travellerDetails
        ob.viewModel.currentlyUsingFor = usingFor
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToLinkedAccountsVC() {
        let ob = LinkedAccountsVC.instantiate(fromAppStoryboard: .Profile)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToAccountDetailsVC() {
        let ob = UserAccountDetailsVC.instantiate(fromAppStoryboard: .Profile)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToFFSearchVC(defaultAirlines: [FlyerModel], delegate: SearchVCDelegate?) {
        let controller = FFSearchVC.instantiate(fromAppStoryboard: .Profile)
        controller.modalPresentationStyle = .fullScreen
        controller.delgate = delegate
        controller.defaultAirlines = defaultAirlines
        self.mainNavigationController.present(controller, animated: true, completion: nil)
    }
    
    func moveToSearchFavouriteHotelsVC() {
        let ob = SearchFavouriteHotelsVC.instantiate(fromAppStoryboard: .HotelPreferences)
        ob.modalPresentationStyle = .fullScreen
        self.mainNavigationController.present(ob, animated: true, completion: nil)
    }
    
    func moveToViewAllHotelsVC() {
        let ob = FavouriteHotelsVC.instantiate(fromAppStoryboard: .HotelPreferences)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToTravellerListVC() {
        let ob = TravellerListVC.instantiate(fromAppStoryboard: .TravellerList)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToPreferencesVC(_ delegate: PreferencesVCDelegate) {
        let ob = PreferencesVC.instantiate(fromAppStoryboard: .TravellerList)
        ob.delegate = delegate
        ob.modalPresentationStyle = .fullScreen
        self.mainNavigationController.present(ob, animated: true, completion: nil)
    }
    
    func moveToImportContactVC() {
        let ob = ImportContactVC.instantiate(fromAppStoryboard: .TravellerList)
        ob.modalPresentationStyle = .fullScreen
        self.mainNavigationController.present(ob, animated: true, completion: nil)
    }
    
    func showRoomGuestSelectionVC(selectedAdults: Int, selectedChildren: Int, selectedAges: [Int], roomNumber: Int, delegate: RoomGuestSelectionVCDelegate) {
        if let mVC = self.mainHomeVC {
            let ob = RoomGuestSelectionVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.delegate = delegate
            ob.viewModel.selectedChilds = selectedChildren
            ob.viewModel.selectedAdults = max(1, selectedAdults)
            ob.viewModel.roomNumber = roomNumber
            var ages = selectedAges
            if selectedAges.count < 4 {
                for _ in 0..<(4 - selectedAges.count) {
                    ages.append(0)
                }
            }
            ob.viewModel.childrenAge = ages
            // mVC.add(childViewController: ob)
            ob.modalPresentationStyle = .overCurrentContext
            ob.modalPresentationCapturesStatusBarAppearance = true
            mVC.present(ob, animated: false, completion: nil)
        }
    }
    
    func showSelectDestinationVC(delegate: SelectDestinationVCDelegate, currentlyUsingFor: SelectDestinationVC.CurrentlyUsingFor, navigationController: UINavigationController? = nil) {
        if let mVC = self.mainHomeVC {
            let ob = SelectDestinationVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.currentlyUsingFor = currentlyUsingFor
            ob.delegate = delegate
            if #available(iOS 13.0, *) {} else {
                ob.modalPresentationStyle = .overCurrentContext
            }
            //            mVC.add(childViewController: ob)
            (navigationController ?? mVC).present(ob, animated: true, completion: nil)
        }
        
    }
    
    func moveToHotelsResultVc(withFormData: HotelFormPreviosSearchData, recentSearchModel: RecentSearchesModel?) {
        let obj = HotelResultVC.instantiate(fromAppStoryboard: .HotelsSearch)
        obj.viewModel.searchedFormData = withFormData
        obj.viewModel.recentSearchModel = recentSearchModel
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToHotelsResultMapVC(viewModel: HotelsResultVM) {
        let obj = HotelsMapVC.instantiate(fromAppStoryboard: .HotelsSearch)
        obj.viewModel = viewModel
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func showBulkBookingVC(withOldData: HotelFormPreviosSearchData, delegate: BulkBookingVCDelegate) {
        if let mVC = self.mainHomeVC {
            let ob = BulkBookingVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.viewModel.oldData = withOldData
            ob.delegate = delegate
            
            //mVC.add(childViewController: ob)
            let navigationController = self.getNavigationController(forPresentVC: ob)
            if #available(iOS 13.0, *) {} else {
                navigationController.modalPresentationStyle = .overCurrentContext
            }
            mVC.present(navigationController, animated: true, completion: nil)
        }
    }
    
    
    func showEditProfileVC(travelData: TravelDetailModel?, usingFor: EditProfileVM.UsingFor) {
        let ob = EditProfileVC.instantiate(fromAppStoryboard: .Profile)
        ob.viewModel.travelData = travelData
        ob.modalPresentationStyle = .fullScreen
        ob.viewModel.currentlyUsinfFor = usingFor
        self.mainNavigationController.present(ob, animated: true, completion: nil)
    }
    
    func presentEditProfileVC() {
        let ob = EditProfileVC.instantiate(fromAppStoryboard: .Profile)
        ob.viewModel.currentlyUsinfFor = .addNewTravellerList
        ob.modalPresentationStyle = .fullScreen
        self.mainNavigationController.present(ob, animated: true, completion: nil)
    }
    
    func showBulkRoomSelectionVC(rooms: Int, adults: Int, children: Int, delegate: BulkRoomSelectionVCDelegate,navigationController: UINavigationController? = nil) {
        if let mVC = UIApplication.topViewController() {
            let ob = BulkRoomSelectionVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.delegate = delegate
            ob.viewModel.roomCount = rooms
            ob.viewModel.adultCount = adults
            ob.viewModel.childrenCounts = children
            //mVC.add(childViewController: ob)
//            if #available(iOS 13.0, *) {} else {
                ob.modalPresentationStyle = .overFullScreen
//            }
            (navigationController ?? mVC).present(ob, animated: false, completion: nil)
        }
    }
    
    func showBulkEnquiryVC(buttonConfig: BulkEnquirySuccessfulVC.ButtonConfiguration, delegate: BulkEnquirySuccessfulVCDelegate) {
        if let mVC = UIApplication.topViewController() {
            let ob = BulkEnquirySuccessfulVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.searchButtonConfiguration = buttonConfig
            ob.currentUsingAs = .bulkBooking
            ob.delegate = delegate
            mVC.add(childViewController: ob)
        }
    }
    
    @objc func showFlightsBulkEnquiryVC(delegate: BulkEnquirySuccessfulVCDelegate, mainView: UIView, viewHeight: CGFloat, submitBtn: UIButton) {
        if let mVC = UIApplication.topViewController() {
            let ob = BulkEnquirySuccessfulVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.searchButtonConfiguration = createConfigForFlightsBulkEnquiry(mainView: mainView, viewHeight: viewHeight, submitBtn: submitBtn)
            ob.currentUsingAs = .bulkBooking
            ob.delegate = delegate
            mVC.add(childViewController: ob)
        }
    }
    
    private func createConfigForFlightsBulkEnquiry(mainView: UIView ,viewHeight: CGFloat, submitBtn: UIButton) -> BulkEnquirySuccessfulVC.ButtonConfiguration {
        var config = BulkEnquirySuccessfulVC.ButtonConfiguration()
        config.text = ""//LocalizedString.Submit.localized
        config.cornerRadius = 25.0
        config.textFont = AppFonts.SemiBold.withSize(17)
        let point = submitBtn.superview?.convert(submitBtn.frame.origin, to: mainView) ?? .zero
        let y = viewHeight - (point.y)
        config.width = submitBtn.width
        config.spaceFromBottom = y
        return config
    }
    
    func showAddonRequestSent(buttonConfig: BulkEnquirySuccessfulVC.ButtonConfiguration, delegate: BulkEnquirySuccessfulVCDelegate) {
        if let mVC = UIApplication.topViewController() {
            let ob = BulkEnquirySuccessfulVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.delegate = delegate
            ob.currentUsingAs = .addOnRequest
            ob.searchButtonConfiguration = buttonConfig
            mVC.add(childViewController: ob)
        }
    }
    
    func showCancellationRequest(buttonTitle: String, delegate: BulkEnquirySuccessfulVCDelegate) {
        if let mVC = UIApplication.topViewController() {
            let ob = BulkEnquirySuccessfulVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.currentUsingAs = .cancellationRequest
            ob.delegate = delegate
            mVC.add(childViewController: ob)
        }
    }
    
    func showReschedulingRequest(buttonTitle: String, delegate: BulkEnquirySuccessfulVCDelegate) {
        if let mVC = UIApplication.topViewController() {
            let ob = BulkEnquirySuccessfulVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.currentUsingAs = .reschedulingRequest
            ob.delegate = delegate
            mVC.add(childViewController: ob)
        }
    }
    
    func showCancellationProcessed(buttonTitle: String, delegate: BulkEnquirySuccessfulVCDelegate) {
        if let mVC = UIApplication.topViewController() {
            let ob = BulkEnquirySuccessfulVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.currentUsingAs = .cancellationProcessed
            ob.delegate = delegate
            mVC.add(childViewController: ob)
        }
    }
    
    func showSpecialRequest(buttonTitle: String, delegate: BulkEnquirySuccessfulVCDelegate) {
        if let mVC = UIApplication.topViewController() {
            let ob = BulkEnquirySuccessfulVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.currentUsingAs = .specialRequest
            ob.delegate = delegate
            mVC.add(childViewController: ob)
        }
    }
    
    func presentHotelDetailsVC(_ vc: BaseVC, hotelInfo: HotelSearched, sid: String, hotelSearchRequest: HotelSearchRequestModel?, filterParams: JSONDictionary, searchFormData: HotelFormPreviosSearchData, onCloseHandler: (() -> Void)? = nil) {
        if let topVC = UIApplication.topViewController() {
            let ob = HotelDetailsVC.instantiate(fromAppStoryboard: .HotelResults)
            ob.viewModel.hotelInfo = hotelInfo
            ob.delegate = vc as? HotelDetailsVCDelegate
            ob.viewModel.hotelSearchRequest = hotelSearchRequest
            ob.viewModel.filterParams = filterParams
            ob.viewModel.searchedFormData = searchFormData
            ob.onCloseHandler = onCloseHandler
            //ob.modalPresentationStyle = .fullScreen
            // ob.show(onViewController: topVC, sourceView: sourceView, animated: true)
            
            let nav = AppFlowManager.default.getNavigationController(forPresentVC: ob)
            if #available(iOS 13.0, *) {} else {
                nav.modalPresentationStyle = .overCurrentContext
            }
            topVC.present(nav, animated: true, completion: nil)
        }
    }
    
    // presentHotelDetailsVCOverExpendCard
    //    func presentHotelDetailsVCOverExpendCard(_ vc: HotelsGroupExpendedVC, hotelInfo: HotelSearched, sourceView: UIView, sid: String, hotelSearchRequest: HotelSearchRequestModel?, onCloseHandler: (() -> Void)? = nil) {
    //        if let topVC = UIApplication.topViewController() {
    //            let ob = HotelDetailsVC.instantiate(fromAppStoryboard: .HotelResults)
    //            ob.viewModel.hotelInfo = hotelInfo
    //            ob.delegate = vc
    //            ob.isHideWithAnimation = false
    //            ob.viewModel.hotelSearchRequest = hotelSearchRequest
    //            ob.onCloseHandler = onCloseHandler
    //            ob.show(onViewController: topVC, sourceView: sourceView, animated: false)
    //        }
    //    }
    
    func presentHCSelectGuestsVC(delegate: HCSelectGuestsVCDelegate, productType:ProductType = .hotel) {
        if let topVC = UIApplication.topViewController() {
            let ob = HCSelectGuestsVC.instantiate(fromAppStoryboard: .HotelCheckout)
            ob.delegate = delegate
            ob.viewModel.productType = productType
            ob.modalPresentationStyle = .overFullScreen
            delay(seconds: 0.3) {
                topVC.present(ob, animated: true, completion:nil)
            }
            
        }
    }
    
    func presentSearchHotelTagVC(tagButtons: [String], superView: HotelDetailsSearchTagTableCell, presentingStatusBarStyle: UIStatusBarStyle = .darkContent, dismissingStatusBarStyle: UIStatusBarStyle = .darkContent) {
        let ob = SearchHotelTagVC.instantiate(fromAppStoryboard: .HotelResults)
        ob.delegate = superView
        ob.tagButtons = tagButtons
        ob.presentingStatusBarStyle = presentingStatusBarStyle
        ob.dismissingStatusBarStyle = dismissingStatusBarStyle
        //        ob.modalPresentationStyle = .overFullScreen
        //        ob.modalPresentationCapturesStatusBarAppearance = true
        ob.modalPresentationStyle = .popover
        UIApplication.topViewController()?.present(ob, animated: true, completion: nil)
    }
    
    func showHotelDetailAmenitiesVC(amenitiesGroups : [String : Any] = [:],amentites: Amenities? = nil, amenitiesGroupOrder: [String : String] ) {
        let ob = HotelDetailsAmenitiesVC.instantiate(fromAppStoryboard: .HotelResults)
        ob.viewModel.amenitiesGroups = amenitiesGroups
        ob.viewModel.amenities = amentites
        ob.viewModel.amenitiesGroupOrder = amenitiesGroupOrder
        //        ob.modalPresentationStyle = .overFullScreen
        //        ob.modalPresentationCapturesStatusBarAppearance = true
        //        ob.statusBarColor = AppColors.themeWhite
        if !(UIApplication.topViewController()?.isKind(of: HotelDetailsAmenitiesVC.self) ?? false){
            UIApplication.topViewController()?.present(ob, animated: true, completion: nil)
        }
    }
    
    func presentHotelDetailsOverViewVC(overViewInfo: String) {
        let ob = HotelDetailsOverviewVC.instantiate(fromAppStoryboard: .HotelResults)
        ob.viewModel.overViewInfo = overViewInfo
        //        ob.modalPresentationStyle = .overFullScreen
        //        ob.modalPresentationCapturesStatusBarAppearance = true
        //        ob.statusBarColor = AppColors.themeWhite
        UIApplication.topViewController()?.present(ob, animated: true, completion: nil)
    }
    
    func presentHotelDetailsTripAdvisorVC(hotelId: String, presentingStatusBarStyle: UIStatusBarStyle = .darkContent, dismissalStatusBarStyle: UIStatusBarStyle = .darkContent) {
        let ob = HotelDetailsReviewsVC.instantiate(fromAppStoryboard: .HotelResults)
        ob.viewModel.hotelId = hotelId
        ob.presentingStatusBarStyle = presentingStatusBarStyle
        ob.dismissalStatusBarStyle = dismissalStatusBarStyle
        //        ob.modalPresentationStyle = .overFullScreen
        //        ob.modalPresentationCapturesStatusBarAppearance = true
        //        ob.statusBarColor = AppColors.themeWhite
        UIApplication.topViewController()?.present(ob, animated: true, completion: nil)
    }
    
    func showAssignGroupVC(_ vc: TravellerListVC, _ selectedTraveller: [String]) {
        let ob = AssignGroupVC.instantiate(fromAppStoryboard: .TravellerList)
        ob.viewModel.paxIds = selectedTraveller
        ob.delegate = vc
        ob.modalPresentationStyle = .overFullScreen
        self.currentNavigation?.present(ob, animated: true, completion: nil)
    }
    
    func showFilterVC(_ vc: BaseVC, index: Int? = nil) {
        if let obj = UIApplication.topViewController() {
            let ob = HotelFilterVC.instantiate(fromAppStoryboard: .Filter)
            ob.delegate = vc as? HotelFilteVCDelegate
            if let idx = index {
                ob.selectedIndex = idx
            }
            obj.add(childViewController: ob)
        }
    }
    
    func moverToFilterVC() {
        let obj = HotelFilterVC.instantiate(fromAppStoryboard: .Filter)
        self.mainNavigationController.present(obj, animated: true, completion: nil)
    }
    
    func moveToHCDataSelectionVC(sid: String, hid: String, qid: String, placeModel: PlaceModel, hotelSearchRequest: HotelSearchRequestModel, itData:ItineraryData? = nil, hotelInfo: HotelSearched, locid: String, roomRate: Rates, delegate: HCDataSelectionVCDelegate, presentViewController: Bool = false) {
        let obj = HCDataSelectionVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.viewModel.sId = sid
        obj.viewModel.hId = hid
        obj.viewModel.qId = qid
        obj.viewModel.locid = locid
        obj.viewModel.placeModel = placeModel
        obj.viewModel.hotelSearchRequest = hotelSearchRequest
        obj.viewModel.hotelInfo = hotelInfo
        obj.viewModel.detailPageRoomRate = roomRate
        obj.viewModel.itineraryData = itData
        obj.delegate = delegate
        if presentViewController {
            let newNavigation = self.getNavigationController(forPresentVC: obj)
            newNavigation.modalPresentationStyle = .overFullScreen
            self.currentNavigation?.presentAsPushAnimation(newNavigation)
        } else {
            self.currentNavigation?.pushViewController(obj, animated: true)
        }
    }
    
    func presentHCCouponCodeVC(itineraryId: String, vc: HCCouponCodeVCDelegate, couponData: [HCCouponModel],couponCode: String, product:CouponFor = .hotels) {
        let obj = HCCouponCodeVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.delegate = vc
        obj.viewModel.itineraryId = itineraryId
        obj.viewModel.couponCode = couponCode
        obj.viewModel.product = product
        obj.viewModel.couponsData = couponData
        obj.viewModel.isCouponApplied = !couponCode.isEmpty
        obj.modalPresentationStyle = .overFullScreen
        self.currentNavigation?.present(obj, animated: true)
    }
    
    func presentFlightCouponCodeVC(itineraryId: String, vc: FlightCouponCodeVCDelegate, couponCode: String, product:CouponFor = .hotels) {
        let obj = HCCouponCodeVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.flightDelegate = vc
        obj.viewModel.itineraryId = itineraryId
        obj.viewModel.couponCode = couponCode
        obj.viewModel.product = product
        obj.modalPresentationStyle = .overFullScreen
        self.currentNavigation?.present(obj, animated: true)
    }
    
    func presentHCSpecialRequestsVC(specialRequests: [SpecialRequest], selectedRequestIds: [Int],selectedRequestNames: [String],other: String,specialRequest: String,  delegate: HCSpecialRequestsDelegate) {
        let obj = HCSpecialRequestsVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.delegate = delegate
        obj.viewModel.specialRequests = specialRequests
//        obj.viewModel.selectedRequestsId = selectedRequestIds
        obj.viewModel.other = other
        obj.viewModel.specialRequest = specialRequest
        obj.viewModel.selectedRequests = specialRequests.filter { selectedRequestIds.contains($0.id) }
        obj.modalPresentationStyle = .overFullScreen
        self.currentNavigation?.present(obj, animated: true)
    }
    
    func presentHCEmailItinerariesVC(forBookingId bId: String, travellers: [TravellersList], presentingStatusBarStyle: UIStatusBarStyle = .darkContent, dismissalStatusBarStyle: UIStatusBarStyle = .darkContent) {
        let obj = HCEmailItinerariesVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.viewModel.bookingId = bId
        obj.viewModel.travellers = travellers
        UIApplication.topViewController()?.present(obj, animated: true, completion: nil)
    }
    
    func presentYouAreAllDoneVC(forItId itId: String, bookingIds: [String], cid: [String], originLat: String, originLong: String, recieptData: HotelReceiptModel?, sId: String) {
        let obj = YouAreAllDoneVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.viewModel.itId = itId
        obj.viewModel.bookingIds = bookingIds
        obj.viewModel.cId = cid
        obj.viewModel.originLat = originLat
        obj.viewModel.originLong = originLong
        obj.viewModel.hotelReceiptData = recieptData
        obj.viewModel.sId = sId
        self.currentNavigation?.pushViewController(obj, animated: false)
    }
    
    // Mail Composer
    
    func presentMailComposerVC(_ favouriteHotels: [HotelSearched], _ hotelSearchRequest: HotelSearchRequestModel, _ pinnedTemplateUrl: String, presentingStatusBarStyle: UIStatusBarStyle = .darkContent, dismissalStatusBarStyle: UIStatusBarStyle = .darkContent) {
        let obj = MailComposerVC.instantiate(fromAppStoryboard: .HotelResults)
        obj.viewModel.favouriteHotels = favouriteHotels
        obj.viewModel.shortUrl = pinnedTemplateUrl
        obj.viewModel.hotelSearchRequest = hotelSearchRequest
        obj.presentingStatusBarStyle = presentingStatusBarStyle
        obj.dismissalStatusBarStyle = dismissalStatusBarStyle
        //obj.modalPresentationStyle = .overFullScreen
        self.currentNavigation?.present(obj, animated: true)
    }
    
    func presentSelectTripVC(delegate: SelectTripVCDelegate, usingFor: TripUsingFor = .hotel,allTrips: [TripModel] = [],tripInfo: TripInfo = TripInfo(), dismissalStatusBarStyle: UIStatusBarStyle = .lightContent) {
        /* Don't call this method directly if you want to get the default trip or select the trip if there is no default trip.
         In that case use `AppFlowManager.default.selectTrip()` method.
         */
        let obj = SelectTripVC.instantiate(fromAppStoryboard: .HotelResults)
        obj.viewModel.usingFor = usingFor
        obj.viewModel.allTrips = allTrips
        obj.viewModel.tripInfo = tripInfo
        obj.delegate = delegate
        obj.modalPresentationStyle = .overFullScreen
        obj.dismissalStatusBarStyle = dismissalStatusBarStyle
        self.currentNavigation?.present(obj, animated: true)
    }
    
    func presentCreateNewTripVC(delegate: CreateNewTripVCDelegate, onViewController: UIViewController? = nil) {
        let obj = CreateNewTripVC.instantiate(fromAppStoryboard: .HotelResults)
        if #available(iOS 13.0, *) {} else {
            obj.modalPresentationStyle = .overFullScreen
            obj.modalPresentationCapturesStatusBarAppearance =  true
            obj.statusBarColor = AppColors.themeWhite
        }
        obj.delegate = delegate
        if let oVC = onViewController {
            oVC.present(obj, animated: true)
        }
        else {
            self.currentNavigation?.present(obj, animated: true)
        }
    }
    
    func moveToGuestDetailScreen(delegate: GuestDetailsVCDelegate, _ indexPath: IndexPath) {
        let obj = GuestDetailsVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.vcDelegate = delegate
        obj.viewModel.selectedIndexPath = indexPath
        self.currentNavigation?.pushViewController(obj, animated: true)
    }
    
    func moveToFinalCheckoutVC(delegate: FinalCheckOutVCDelegate, _ itinaryData: ItineraryData? = ItineraryData(), _ itinaryPriceDetail: ItenaryModel? = ItenaryModel(), originLat: String, originLong: String, sId: String) {
        let obj = FinalCheckOutVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.viewModel.itineraryData = itinaryData
        obj.delegate = delegate
        obj.viewModel.originLat = originLat
        obj.viewModel.originLong = originLong
        obj.viewModel.itinaryPriceDetail = itinaryPriceDetail
        obj.viewModel.sId = sId
        self.currentNavigation?.pushViewController(obj, animated: true)
    }
    
    func moveToBookingIncompleteVC() {
        let obj = HCBookingIncompleteVC.instantiate(fromAppStoryboard: .HotelCheckout)
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToRefundRequestedVC() {
        let obj = HCRefundRequestedVC.instantiate(fromAppStoryboard: .HotelCheckout)
        self.currentNavigation?.pushViewController(obj, animated: true)
    }
    
    func moveToPaymentAmountHigh() {
        let obj = HCRefundRequestedVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.currentUsingAs = .paymentAmountHigh
        self.currentNavigation?.pushViewController(obj, animated: true)
    }
    
    // MARK: - Booking Module
    
    // MARK: ----
    
    func moveToMyBookingsVC(bookingId:String = "") {
        let obj = MyBookingsVC.instantiate(fromAppStoryboard: .Bookings)
        MyBookingsVM.shared.deepLinkBookingId = bookingId
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func showBookingFilterVC(_ vc: MyBookingsVC) {
        if let obj = UIApplication.topViewController() {
            let ob = MyBookingFilterVC.instantiate(fromAppStoryboard: .Bookings)
            //            ob.delegate = vc
            obj.add(childViewController: ob)
        }
    }
    
    func showUpcomingVC(_ vc: UIViewController) {
        if let obj = UIApplication.topViewController() {
            let ob = UpcomingBookingsVC.instantiate(fromAppStoryboard: .Bookings)
            obj.add(childViewController: ob)
        }
    }
    
    // MARK: - Booking Detail VC
    
    // MARK: -
    
    func moveToOtherBookingsDetailsVC(bookingId: String, isForDeepLink:Bool = false, bookingDetails: BookingDetailModel? = nil) {
        let obj = OtherBookingsDetailsVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.bookingDetail = bookingDetails
        obj.viewModel.bookingId = bookingId
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToFlightBookingsDetailsVC(bookingId: String, tripCitiesStr: NSMutableAttributedString?, isForDeepLink:Bool = false, bookingDetails: BookingDetailModel? = nil) {
        let obj = FlightBookingsDetailsVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.bookingDetail = bookingDetails
        obj.viewModel.bookingId = bookingId
        obj.viewModel.tripCitiesStr = tripCitiesStr ?? NSMutableAttributedString(string: "")
        self.currentNavigation?.pushViewController(obj, animated: true)
    }
    
    func moveToHotelBookingsDetailsVC(bookingId: String, isForDeepLink:Bool = false, bookingDetails: BookingDetailModel? = nil) {
        let obj = HotlelBookingsDetailsVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.bookingDetail = bookingDetails
        obj.viewModel.bookingId = bookingId
        self.currentNavigation?.pushViewController(obj, animated: true)
    }
    
    func moveToRequestReschedulingVC(onNavController: UINavigationController?, legs: [BookingLeg], isOnlyReturn:Bool = false) {
        let obj = RequestReschedulingVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.legsWithSelection = legs
        obj.viewModel.isOnlyReturn = isOnlyReturn
        (onNavController ?? self.mainNavigationController).pushViewController(obj, animated: true)
    }
    
    func presentToHotelCancellationVC(bookingDetail: BookingDetailModel, presentingStatusBarStyle: UIStatusBarStyle = .darkContent, dismissalStatusBarStyle: UIStatusBarStyle = .darkContent) {
        let obj = HotelCancellationVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.bookingDetail = bookingDetail
        obj.presentingStatusBarStyle = presentingStatusBarStyle
        obj.dismissalStatusBarStyle = dismissalStatusBarStyle
        let nav = UINavigationController(rootViewController: obj)
        nav.isNavigationBarHidden = true
        self.currentNavigation?.present(nav, animated: true, completion: nil)
    }
    
    func presentBookingFareInfoDetailVC(usingFor: BookingFareInfoDetailVC.UsingFor, forBookingId: String, legDetails: BookingLeg?, bookingFee: BookingFeeDetail?) {
        let obj = BookingFareInfoDetailVC.instantiate(fromAppStoryboard: .Bookings)
        obj.currentlyUsingAs = usingFor
        obj.viewModel.bookingId = forBookingId
        obj.viewModel.legDetails = legDetails
        obj.viewModel.bookingFee = bookingFee
        UIApplication.topViewController()?.present(obj, animated: true)
    }
    
    func presentFareBookingRulesVC(forBookingId: String, legDetails: BookingLeg?, bookingFee: BookingFeeDetail?) {
        let obj = FareBookingRulesVC.instantiate(fromAppStoryboard: .Bookings)
        //obj.currentlyUsingAs = usingFor
        obj.viewModel.bookingId = forBookingId
        obj.viewModel.legDetails = legDetails
        obj.viewModel.bookingFee = bookingFee
        UIApplication.topViewController()?.present(obj, animated: true)
    }
    
    func moveToAbortRequestVC(forCase: Case) {
        let obj = AbortRequestVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.caseToAbort = forCase
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    // MARK: - Account Section
    
    // MARK: -
    
    func moveToAccountDetailsScreen() {
        guard let user = UserInfo.loggedInUser else {
            return
        }
        
        switch user.userCreditType {
        case .regular:
            self.moveToAccountDetailsVC(usingFor: .account, forDetails: [:], forVoucherTypes: [])
            
        case .billwise:
            let obj = SpecialAccountDetailsVC.instantiate(fromAppStoryboard: .Account)
            self.mainNavigationController.pushViewController(obj, animated: true)
            
        case .statement:
            let obj = SpecialAccountDetailsVC.instantiate(fromAppStoryboard: .Account)
            self.mainNavigationController.pushViewController(obj, animated: true)
            
        case .topup:
            let obj = SpecialAccountDetailsVC.instantiate(fromAppStoryboard: .Account)
            self.mainNavigationController.pushViewController(obj, animated: true)
        }
    }
    
    func moveToAccountDetailsVC(usingFor: AccountDetailsVC.UsingFor, forDetails: JSONDictionary, forVoucherTypes: [String]) {
        if let _ = mainNavigationController.topViewController as? AccountDetailsVC { return }
        let obj = AccountDetailsVC.instantiate(fromAppStoryboard: .Account)
        obj.currentUsingAs = usingFor
        obj.viewModel.allVouchers = forVoucherTypes
        obj.viewModel.setAccountDetails(details: forDetails)
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToAccountLadgerDetailsVC(forEvent: AccountDetailEvent, detailType: AccountLadgerDetailsVM.AccountLadgerDetailType) {
        let obj = AccountLadgerDetailsVC.instantiate(fromAppStoryboard: .Account)
        obj.viewModel.ladgerEvent = forEvent
        obj.viewModel.detailType = detailType
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func emoveToAccountLadgerDetailsForOnAccount(forEvent: OnAccountLedgerEvent?, detailType: AccountLadgerDetailsVM.AccountLadgerDetailType) {
        let obj = AccountLadgerDetailsVC.instantiate(fromAppStoryboard: .Account)
        obj.viewModel.onAccountEvent = forEvent
        obj.viewModel.detailType = detailType
        obj.viewModel.isForOnAccount = true
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToADEventFilterVC(onViewController: UIViewController? = nil, delegate: ADEventFilterVCDelegate) {
        if let obj = onViewController ?? UIApplication.topViewController() {
            let vc = ADEventFilterVC.instantiate(fromAppStoryboard: .Account)
            vc.delegate = delegate
            obj.add(childViewController: vc)
        }
    }
    
    func moveToAccountOutstandingLadgerVC(data: AccountOutstanding) {
        if let _ = mainNavigationController.topViewController as? AccountOutstandingLadgerVC { return }
        let obj = AccountOutstandingLadgerVC.instantiate(fromAppStoryboard: .Account)
        obj.viewModel.accountOutstanding = data
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToOnAccountDetailVC(outstanding: AccountOutstanding) {
        let obj = OnAccountDetailVC.instantiate(fromAppStoryboard: .Account)
        obj.viewModel.outstanding = outstanding
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToPeriodicStatementVC(periodicEvents: JSONDictionary) {
        if let _ = mainNavigationController.topViewController as? PeriodicStatementVC { return }
        let obj = PeriodicStatementVC.instantiate(fromAppStoryboard: .Account)
        obj.viewModel.periodicEvents = periodicEvents
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToAccountOnlineDepositVC(depositItinerary: DepositItinerary?, usingToPaymentFor: AccountOnlineDepositVC.UsingToPaymentFor) {
        let obj = AccountOnlineDepositVC.instantiate(fromAppStoryboard: .Account)
        obj.viewModel.depositItinerary = depositItinerary
        obj.currentUsingFor = usingToPaymentFor
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToAccountOfflineDepositVC(usingFor: AccountOfflineDepositVC.UsingForPayBy, usingToPaymentFor: AccountOfflineDepositVC.UsingToPaymentFor, paymentModeDetail: PaymentModeDetails?, netAmount: Double, bankMaster: [String]) {
        let obj = AccountOfflineDepositVC.instantiate(fromAppStoryboard: .Account)
        obj.currentUsingAs = usingFor
        obj.currentUsingFor = usingToPaymentFor
        obj.viewModel.paymentModeDetails = paymentModeDetail
        obj.viewModel.bankMaster = bankMaster
        obj.viewModel.userEnteredDetails.depositAmount = netAmount
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func showAccountDepositSuccessVC(buttonConfig: BulkEnquirySuccessfulVC.ButtonConfiguration, delegate: BulkEnquirySuccessfulVCDelegate, flow: BulkEnquirySuccessfulVC.UsingFor) {
        if let mVC = UIApplication.topViewController() {
            let ob = BulkEnquirySuccessfulVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.delegate = delegate
            ob.searchButtonConfiguration = buttonConfig
            ob.currentUsingAs = flow
            mVC.add(childViewController: ob)
        }
    }
    
    
    
    func moveHotelCalenderVC(isHotelCalendar: Bool = false, isReturn: Bool = false, isMultiCity: Bool = false, checkInDate: Date? = nil, checkOutDate: Date? = nil, delegate: CalendarDataHandler, isStartDateSelection: Bool, navigationController: UINavigationController? = nil) {
        if let ob = UIStoryboard(name: "AertripCalendar", bundle: Bundle(for: AertripCalendarViewController.self)).instantiateViewController(withIdentifier: "AertripCalendarViewController") as? AertripCalendarViewController {
            let calendarVM = CalendarVM()
            calendarVM.isHotelCalendar = isHotelCalendar
            calendarVM.isReturn = isReturn
            calendarVM.isMultiCity = isMultiCity
            calendarVM.isStartDateSelection = isStartDateSelection
            calendarVM.date1 = checkInDate
            calendarVM.date2 = checkOutDate
            ob.viewModel = calendarVM
            ob.viewModel?.delegate = delegate
            (navigationController ?? self.mainNavigationController).present(ob, animated: true, completion: nil)
        }
    }
    
    func presentAccountChargeInfoVC(usingFor: AccountChargeInfoVM.UsingFor) {
        let obj = AccountChargeInfoVC.instantiate(fromAppStoryboard: .Account)
        obj.viewModel.currentUsingFor = usingFor
        self.mainNavigationController.present(obj, animated: true, completion: nil)
    }
    
    func presentAertripBankDetailsVC(bankDetails: [BankAccountDetail], currentIndex:Int = 0) {
        let obj = AertripBankDetailsVC.instantiate(fromAppStoryboard: .Account)
        obj.viewModel.allBanks = bankDetails
        obj.currentIndex = currentIndex
        self.mainNavigationController.present(obj, animated: true, completion: nil)
    }
    
    
    func moveToTestViewController() {
        //        let ob = TestViewController.instantiate(fromAppStoryboard: .Common)
        //        self.mainNavigationController.pushViewController(ob, animated: true)
        let ob = CreateProfileVC.instantiate(fromAppStoryboard: .PreLogin)
        self.mainNavigationController.pushViewController(ob, animated: true)
        
        
    }
    
    // MARK: - Aerin
//    
//    func showAerinTextToSpeechVC() {
//        let ob = AerinTextSpeechVC.instantiate(fromAppStoryboard: .Aerin)
//        self.mainNavigationController.pushViewController(ob, animated: true)
//    }
//    
//    func moveToAerinTextSpeechDetailVC() {
//        let ob = AerinTextSpeechDetailVC.instantiate(fromAppStoryboard: .Aerin)
//        self.mainNavigationController.pushViewController(ob, animated: true)
//    }
//    
//    func presentAerinTextSpeechVC() {
//        let ob = AerinTextSpeechVC.instantiate(fromAppStoryboard: .Aerin)
//        ob.isFromHotelResult = true
//        self.mainNavigationController.present(ob, animated: true)
//    }
    
    func moveToBookingDetail(bookingDetail: BookingDetailModel?,tripCities: NSMutableAttributedString = NSMutableAttributedString(string: ""),legSectionTap: Int = 0, presentingStatusBarStyle: UIStatusBarStyle = .darkContent, dismissalStatusBarStyle: UIStatusBarStyle = .darkContent) {
        let ob = BookingFlightDetailVC.instantiate(fromAppStoryboard: .Bookings)
        ob.viewModel.bookingDetail = bookingDetail
        ob.viewModel.tripStr = tripCities
        ob.viewModel.legSectionTap = legSectionTap
        ob.presentingStatusBarStyle = presentingStatusBarStyle
        ob.dismissalStatusBarStyle = dismissalStatusBarStyle
        self.currentNavigation?.present(ob, animated: true, completion: nil)
    }
    
    func presentBaggageInfoVC(dimension: Dimension) {
        let ob = BaggageInfoVC.instantiate(fromAppStoryboard: .Bookings)
        ob.dimension = dimension
        UIApplication.topViewController()?.present(ob, animated: true)
    }
    
    // Complete Hotel Booking Details VC
    func moveToBookingHotelDetailVC(bookingDetail: BookingDetailModel?,hotelTitle: String,bookingId: String = "", hotelName: String = "", taRating: Double = 0, hotelStarRating: Double = 0, presentingStatusBarStyle: UIStatusBarStyle = .darkContent, dismissalStatusBarStyle: UIStatusBarStyle = .darkContent) {
        let ob = BookingHotelDetailVC.instantiate(fromAppStoryboard: .Bookings)
        ob.viewModel.bookingDetail = bookingDetail
        ob.viewModel.hotelTitle = hotelTitle
        ob.viewModel.bookingId = bookingId
        ob.viewModel.hotelName = hotelName
        ob.viewModel.taRating = taRating
        ob.viewModel.hotelStarRating = hotelStarRating
        ob.presentingStatusBarStyle = presentingStatusBarStyle
        ob.dismissalStatusBarStyle = dismissalStatusBarStyle
        self.currentNavigation?.present(ob, animated: true)
    }
    
    func presentPolicyVC(_ usingForVC: VCUsingFor, bookingDetail: BookingDetailModel?) {
        let ob = BookingCancellationPolicyVC.instantiate(fromAppStoryboard: .Bookings)
        ob.viewModel.vcUsingType = usingForVC
        ob.viewModel.bookingDetail = bookingDetail
        UIApplication.topViewController()?.present(ob, animated: true)
    }
    
    // Move to  select Trip VC
    func moveToSelectTripVC(delegate: SelectTripVCDelegate) {
        /* Don't call this method directly if you want to get the default trip or select the trip if there is no default trip.
         In that case use `AppFlowManager.default.selectTrip()` method.
         */
        let obj = SelectTripVC.instantiate(fromAppStoryboard: .HotelResults)
        obj.delegate = delegate
        self.currentNavigation?.pushViewController(obj, animated: true)
    }
    
    // Move to Add on Request Clel
    
    func moveToAddOnRequestVC(caseData: Case, receipt: Receipt?) {
        let obj = BookingAddOnRequestVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.caseData = caseData
        obj.viewModel.receipt = receipt
        self.currentNavigation?.pushViewController(obj, animated: true)
    }
    
    // Move to Booking Voucher VC
    func moveToBookingVoucherVC(receipt: Receipt, bookingId: String) {
        let obj = BookingVoucherVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.receipt = receipt
        obj.viewModel.bookingId = bookingId
        self.currentNavigation?.pushViewController(obj, animated: true)
    }
    
    // Move To Booking Call VC
    
    func moveToBookingCallVC(contactInfo: ContactInfo?,usingFor: BookingCallVCUsingFor = .flight,hotel: String = "", presentingStatusBarStyle: UIStatusBarStyle = .darkContent, dismissalStatusBarStyle: UIStatusBarStyle = .darkContent ) {
        let obj = BookingCallVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.contactInfo = contactInfo
        obj.viewModel.usingFor = usingFor
        obj.viewModel.hotelName = hotel
        obj.presentingStatusBarStyle = presentingStatusBarStyle
        obj.dismissalStatusBarStyle = dismissalStatusBarStyle
        self.currentNavigation?.present(obj, animated: true, completion: nil)
    }
    
    // Move To Booking Call VC
    
    func moveToBookingWebCheckinVC(contactInfo: ContactInfo?, webCheckins: [String] ) {
        let obj = WebCheckinVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.contactInfo = contactInfo
        obj.viewModel.webCheckins = webCheckins
        self.currentNavigation?.present(obj, animated: true, completion: nil)
    }
    
    // Move To Booking Invoice VC
    func moveToBookingInvoiceVC(forVoucher: Voucher, bookingId: String, isReciept: Bool, receiptIndex: Int) {
        let obj = BookingInvoiceVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.voucher = forVoucher
        obj.viewModel.bookingId = bookingId
        obj.viewModel.isReciept = isReciept
        obj.viewModel.receiptIndex = receiptIndex
        self.currentNavigation?.pushViewController(obj, animated: true)
    }
    
    // Move To Booking Direction VC
    func moveToBookingDirectionVC(directions: [Direction]) {
        let obj = BookingDirectionVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.directionData = directions
        self.currentNavigation?.present(obj, animated: true, completion: nil)
    }
    
    // Present BookingRequestAddOnsAndFFC
    func presentBookingReuqestAddOnVC(bookingdata: BookingDetailModel?,delegate:BookingRequestAddOnsFFVCDelegate) {
        let obj = BookingRequestAddOnsFFVC.instantiate(fromAppStoryboard: .Bookings)
        obj.delegate = delegate
        BookingRequestAddOnsFFVM.shared.bookingDetails = bookingdata
        self.currentNavigation?.present(obj, animated: true)
    }
    
    // Present BookingReschedulingVC
    
    func presentBookingReschedulingVC(usingFor data: BookingReschedulingVCUsingFor = .rescheduling, legs: [BookingLeg]) {
        let obj = BookingReschedulingVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.usingFor = data
        obj.viewModel.legsData = legs
        
        let nav = UINavigationController(rootViewController: obj)
        nav.isNavigationBarHidden = true
        self.currentNavigation?.present(nav, animated: true)
    }
    
    // Present RequestCancellation
    
    func presentRequestCancellationVC(usingFor data: BookingReschedulingVCUsingFor = .cancellation, legs: [BookingLeg]) {
        let obj = BookingReschedulingVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.usingFor = data
        obj.viewModel.legsData = legs
        
        let nav = UINavigationController(rootViewController: obj)
        nav.isNavigationBarHidden = true
        self.currentNavigation?.present(nav, animated: true)
    }
    
    // Move to Booking Review Cancellation
    
    func moveToReviewCancellationVC(onNavController: UINavigationController?, usingAs: BookingReviewCancellationVM.UsingFor, legs: [BookingLeg]?, selectedRooms: [RoomDetailModel]?) {
        let obj = BookingReviewCancellationVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.legsWithSelection = legs ?? []
        obj.viewModel.currentUsingAs = usingAs
        obj.viewModel.selectedRooms = selectedRooms ?? []
        (onNavController ?? self.mainNavigationController).pushViewController(obj, animated: true)
    }
    
    func moveToSpecialRequestVC(forBookingId: String, presentingStatusBarStyle: UIStatusBarStyle = .darkContent, dismissalStatusBarStyle: UIStatusBarStyle = .darkContent) {
        let obj = BookingReviewCancellationVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.legsWithSelection = []
        obj.viewModel.currentUsingAs = .specialRequest
        obj.viewModel.selectedRooms = []
        obj.viewModel.bookingId = forBookingId
        obj.presentingStatusBarStyle = presentingStatusBarStyle
        obj.dismissalStatusBarStyle = dismissalStatusBarStyle
        self.currentNavigation?.present(obj, animated: true, completion: nil)
    }
    
    // Move to Booking confirm email
    
    func presentConfirmationMailVC(bookindId: String, presentingStatusBarStyle: UIStatusBarStyle = .darkContent, dismissalStatusBarStyle: UIStatusBarStyle = .darkContent) {
        let obj = BookingConfimationMailVC.instantiate(fromAppStoryboard: .Bookings)
        obj.viewModel.bookingId = bookindId
        obj.presentingStatusBarStyle = presentingStatusBarStyle
        obj.dismissalStatusBarStyle = dismissalStatusBarStyle
        self.currentNavigation?.present(obj, animated: true)
    }
    
    
    // Move to Quick Pay Screen
    
    func moveToQuickPayVC() {
        let ob = QuickPayVC.instantiate(fromAppStoryboard: .Profile)
        self.mainNavigationController?.pushViewController(ob, animated: true)
    }
    
    // Move to Notification screen
    
    func moveToNotificationVC() {
        let ob = NotificationVC.instantiate(fromAppStoryboard: .Profile)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToNotificationSettingsVC(){
        let ob = NotificationSettingsVC.instantiate(fromAppStoryboard: .Settings)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToWebViewVC(type : WebViewVM.WebViewType){
        let ob = WebViewVC.instantiate(fromAppStoryboard: .Settings)
        ob.webViewVm.webViewType = type
        self.mainNavigationController.present(ob, animated: true, completion: nil)
    }
    
    
    //MARK:- Settings Screen
    
    func moveToSettingsVC() {
        let obj = SettingsVC.instantiate(fromAppStoryboard: .Settings)
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToCountryVC() {
        let obj = CountryVC.instantiate(fromAppStoryboard: .Settings)
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToCurrencyVC() {
        let obj = CurrencyVC.instantiate(fromAppStoryboard: .Settings)
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToChangePasswordVC(type: ChangePasswordVM.ChangePasswordType, delegate: ChangePasswordVCDelegate) {
        let ob = ChangePasswordVC.instantiate(fromAppStoryboard: .Profile)
        ob.viewModel.isPasswordType = type
        ob.delegate = delegate
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToHotelCheckoutDetailVC(viewModel: HCDataSelectionVM, delegate: HotelCheckOutDetailsVIewDelegate) {
        let ob = HotelCheckoutDetailVC.instantiate(fromAppStoryboard: .HotelCheckout)
        ob.sectionData.removeAll()
        ob.roomRates.removeAll()
        ob.viewModel = viewModel.itineraryData?.hotelDetails ?? HotelDetails()
        ob.hotelInfo = viewModel.hotelInfo ?? HotelSearched()
        ob.placeModel = viewModel.placeModel ?? PlaceModel()
        ob.sectionData = viewModel.sectionData
        ob.roomRates = viewModel.roomRates
        ob.requestParameters = viewModel.hotelSearchRequest?.requestParameters
        ob.updateData()
        ob.delegate = delegate
        
        let nav = UINavigationController(rootViewController: ob)
        nav.isNavigationBarHidden = true
        self.currentNavigation?.present(nav, animated: true, completion: nil)
    }
    
    func presentBookingNotesVC(overViewInfo: String) {
        let ob = BookingNotesVC.instantiate(fromAppStoryboard: .Bookings)
        ob.viewModel.noteInfo = overViewInfo
        //        ob.modalPresentationStyle = .overFullScreen
        //        ob.modalPresentationCapturesStatusBarAppearance = true
        //        ob.statusBarColor = AppColors.themeWhite
        UIApplication.topViewController()?.present(ob, animated: true, completion: nil)
    }
    
    func presentMicAccessPermissionPopup() {
        let alert = UIAlertController(
            title: LocalizedString.accessDenied.localized,
            message: LocalizedString.microphoneAccessRequired.localized,
            preferredStyle: .alert
        )
        guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else {return}
        alert.addAction(UIAlertAction(title: LocalizedString.Cancel.localized, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: LocalizedString.allowMicAccess.localized, style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingUrl)
        }))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func moveToSpeechToText(with speechToTextDelegate: SpeechToTextVCDelegate ){
        let vc = SpeechToTextVC.instantiate(fromAppStoryboard: .Common)
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = speechToTextDelegate
        (speechToTextDelegate as? UIViewController)?.present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - Select Trip Flow Methods

extension AppFlowManager {
    func selectTrip(_ tripDetails: TripDetails?, tripType: TripUsingFor, cancelDelegate:TripCancelDelegate? = nil, presentingStatusBarStyle: UIStatusBarStyle = .darkContent, dismissalStatusBarStyle: UIStatusBarStyle = .lightContent ,complition: @escaping ((TripModel, TripDetails?) -> Void)) {
        func openSelectTripScreen(trips: [TripModel]) {
            let obj = SelectTripVC.instantiate(fromAppStoryboard: .HotelResults)
            obj.selectionComplition = complition
            obj.viewModel.allTrips = trips
            obj.viewModel.tripDetails = tripDetails
            obj.viewModel.usingFor = tripType
            obj.cancelDelegate = cancelDelegate
            if #available(iOS 13.0, *) {} else {
                obj.modalPresentationStyle = .overFullScreen
                obj.modalPresentationCapturesStatusBarAppearance = true
                obj.statusBarColor = AppColors.themeWhite
            }
            obj.presentingStatusBarStyle = presentingStatusBarStyle
            obj.dismissalStatusBarStyle = dismissalStatusBarStyle
            
            if self.currentNavigation != nil{
                self.currentNavigation?.present(obj, animated: true)
            }else{
                UIApplication.topViewController()?.present(obj, animated: true)
            }
            
        }
        
        func checkDefaultTrip(trips: [TripModel]) {
            var isDefaultFound = false
            for trip in trips {
                if trip.isDefault {
                    isDefaultFound = true
                    complition(trip, nil)
                    break
                }
            }
            
            if !isDefaultFound {
                openSelectTripScreen(trips: trips)
            }
        }
        
        if let detail = tripDetails {
            APICaller.shared.getOwnedTripsAPI(params: ["trip_id": detail.trip_id]) { _, _, trips, defaultTrip in
                // commented this for after completing booking from YouAreAllDoneVC
                //                if let trip = defaultTrip {
                //                    complition(trip, nil)
                //                }
                //                else {
                //                if tripType == .hotel {
                //                    checkDefaultTrip(trips: trips)
                //                } else {
                openSelectTripScreen(trips: trips)
                //                }
                //                }
            }
        }
        else {
            APICaller.shared.getAllTripsAPI { _, _, trips, defaultTrip in
                // commented this for after completing booking from YouAreAllDoneVC
                //                if let trip = defaultTrip {
                //                    complition(trip, nil)
                //                }
                //                else {
                //                if tripType == .hotel {
                //                    checkDefaultTrip(trips: trips)
                //                } else {
                openSelectTripScreen(trips: trips)
                //                }
                //                }
            }
        }
    }
    
    func removeLoginConfirmationScreenFromStack() {
        delay(seconds: 0.5, completion: { [weak self] in
            guard let _ = self else { return }
            
            // for currentNavigation controller
            // after going to the Data selection screen remove login screen from navigation stack
            var updatedNavStack = AppFlowManager.default.currentNavigation?.viewControllers ?? []
            let navStack = AppFlowManager.default.currentNavigation?.viewControllers ?? []
            var isSocialFound = false, isLoginFound = false
            for (idx, obj) in navStack.enumerated() {
                if let _ = obj as? SocialLoginVC {
                    updatedNavStack.removeObject(obj)
                    isSocialFound = true
                }
                else if let _ = obj as? LoginVC {
                    updatedNavStack.removeObject(obj)
                    isLoginFound = true
                }
                
                if idx == (navStack.count - 1), (isSocialFound || isLoginFound) {
                    AppFlowManager.default.currentNavigation?.viewControllers = updatedNavStack
                }
            }
            
            // for mainnavigation controller
            // after going to the Data selection screen remove login screen from navigation stack
            var updatedNavStack2 = AppFlowManager.default.mainNavigationController?.viewControllers ?? []
            let navStack2 = AppFlowManager.default.mainNavigationController?.viewControllers ?? []
            var isSocialFound2 = false, isLoginFound2 = false
            for (idx, obj) in navStack2.enumerated() {
                if let _ = obj as? SocialLoginVC {
                    updatedNavStack2.removeObject(obj)
                    isSocialFound2 = true
                }
                else if let _ = obj as? LoginVC {
                    updatedNavStack2.removeObject(obj)
                    isLoginFound2 = true
                }
                
                if idx == (navStack2.count - 1), (isSocialFound2 || isLoginFound2) {
                    AppFlowManager.default.mainNavigationController?.viewControllers = updatedNavStack2
                }
            }
        })
    }
}

extension AppFlowManager: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = UIApplication.topViewController() else {
            return AppFlowManager.default.mainNavigationController
        }
        
        return navVC
    }
    
    func setupForDummy(){
        self.documentInteractionController.url = URL(string: "")
        self.documentInteractionController.name = ""
        self.documentInteractionController.delegate = self
        self.documentInteractionController.presentPreview(animated: true)
        self.documentInteractionController.dismissPreview(animated: true)
    }
    
    func openDocument(atURL url: URL, screenTitle: String) {
        self.documentInteractionController.url = url
        self.documentInteractionController.name = screenTitle
        self.documentInteractionController.delegate = self
        self.documentInteractionController.presentPreview(animated: true)
    }
}

// MARK: - Pop Methods

extension AppFlowManager {
    func popViewController(animated: Bool) {
        self.currentNavigation?.popViewController(animated: animated)
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool) {
        self.currentNavigation?.popToViewController(viewController, animated: animated)
    }
    
    @objc func popToRootViewController(animated: Bool) {
        self.currentNavigation?.popToRootViewController(animated: animated)
    }
    
}

// MARK: - Animation

extension AppFlowManager {
    func addPopAnimation(onNavigationController: UINavigationController?) {
        let transition = CATransition()
        transition.duration = 0.6
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        onNavigationController?.view.layer.add(transition, forKey: nil)
    }
}


//FlightsCheckout and payment
extension AppFlowManager {
    
    func moveToAddOnVC(){
        let vc = AddOnVC.instantiate(fromAppStoryboard: .Adons)
        self.mainNavigationController.pushViewController(vc, animated: true)
    }
    
}


//Flight return to home VC
extension AppFlowManager {
    
    func flightReturnToHomefrom(_ vc: UIViewController){
        //        AppDelegate.shared.setupFlightsVC()
        self.goToDashboard(launchThroughSplash: true)
        
    }
    
}

extension AppFlowManager : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navi = self.mainNavigationController {
            return navi.viewControllers.count > 1 ? true : false
        }
        return false
    }
}


