//
//  AppFlowManager.swift
//  
//
//  Created by Pramod Kumar on 24/07/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum ViewPresnetEnum {
    case push, present, popup
}

class AppFlowManager: NSObject {
    
    static let `default` = AppFlowManager()
    
    var sideMenuController: PKSideMenuController? {
        return self.mainHomeVC?.sideMenuController
    }
    var mainHomeVC: MainHomeVC?
    
    var documentInteractionController = UIDocumentInteractionController()

    private var blurEffectView: UIVisualEffectView?
    private let urlScheme = "://"
    private var loginVerificationComplition: ((_ isGuest: Bool)->Void)? = nil
    
    private override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged(_:)), name: .dataChanged, object: nil)
    }
    
    var safeAreaInsets: UIEdgeInsets {
        return AppFlowManager.default.mainNavigationController.view.safeAreaInsets
    }
    
    var mainNavigationController: SwipeNavigationController! {
        didSet {
            let textAttributes = [NSAttributedString.Key.font: AppFonts.Regular.withSize(17.0),
                                  NSAttributedString.Key.foregroundColor: AppColors.themeWhite
            ]
            
            mainNavigationController.navigationBar.titleTextAttributes = textAttributes
            mainNavigationController.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            mainNavigationController.navigationBar.shadowImage = nil
            mainNavigationController.navigationBar.barTintColor = AppColors.themeWhite
            mainNavigationController.navigationBar.backgroundColor = AppColors.themeWhite
            mainNavigationController.navigationBar.tintColor = AppColors.themeGreen
            mainNavigationController.navigationBar.isTranslucent = false
            
            //        let yourBackImage = #imageLiteral(resourceName: "backGreen")
            //        navVC.navigationBar.backIndicatorImage = yourBackImage
            //        navVC.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        }
    }
    
    private var currentTabbarNavigationController = UINavigationController() {
        didSet {
            currentTabbarNavigationController.isNavigationBarHidden = true
        }
    }
    
    func setCurrentTabbarNavigationController(navigation: UINavigationController) {
        currentTabbarNavigationController = navigation
    }
    
    private var tabBarController: BaseTabBarController!
    
    func setTabbarController(controller: BaseTabBarController) {
        tabBarController = controller
    }
    
    @objc private func dataChanged(_ note: Notification) {
        //function intended to override
        if let noti = note.object as? ATNotification, let com = loginVerificationComplition {
            if noti == .userAsGuest {
                com(true)
            }
            else if noti == .userLoggedInSuccess {
                com(false)
            }
        }
    }
    
    private var window : UIWindow {
        
        if let window = AppDelegate.shared.window {
            return window
        } else {
            AppDelegate.shared.window = UIWindow()
            return AppDelegate.shared.window!
        }
    }
    
    func openSideMenu() {
        
    }
    
    func closeSideMenu() {
        
    }
    
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
    
    func setupInitialFlow() {
        self.goToDashboard()
        
        self.addBlurToStatusBar()
    }
    
    func goToDashboard() {
        let mainHome = MainHomeVC.instantiate(fromAppStoryboard: .Dashboard)
        self.mainHomeVC = mainHome
        let nvc = SwipeNavigationController(rootViewController: mainHome)
        nvc.delegate = AppDelegate.shared.transitionCoordinator
        self.mainNavigationController = nvc
        self.window.rootViewController = nvc
        self.window.becomeKey()
        self.window.backgroundColor = .white
        self.window.makeKeyAndVisible()
    }
    
    //check and manage the further processing if user logged-in or not
    func proccessIfUserLoggedIn(verifyingFor: LoginFlowUsingFor, completion: ((_ isGuest: Bool)->Void)?) {
        loginVerificationComplition = completion
        if let _ = UserInfo.loggedInUserId {
            //user is logged in
            completion?(false)
        }
        else {
            //user note logged in
            //open login flow
            
            let socialVC = SocialLoginVC.instantiate(fromAppStoryboard: .PreLogin)
            socialVC.currentlyUsingFrom = verifyingFor
            
            delay(seconds: 0.1) { [weak socialVC] in
                socialVC?.animateContentOnLoad()
            }
            
            self.mainNavigationController.pushViewController(socialVC, animated: true)
        }
    }
}

//MARK: - Public Navigation func
extension AppFlowManager {
    func moveToLogoutNavigation() {
        
    }
    
    func openURLOnATWebView(_ url: URL, screenTitle: String) {
        let obj = ATWebViewVC.instantiate(fromAppStoryboard: .Common)
        obj.urlToLoad = url
        obj.navTitle = screenTitle
        self.mainNavigationController.present(obj, animated: true, completion: nil)
    }
    
    func showURLOnATWebView(_ url: URL, screenTitle: String) {
        let obj = ATWebViewVC.instantiate(fromAppStoryboard: .Common)
        obj.urlToLoad = url
        obj.navTitle = screenTitle
//        self.mainNavigationController.present(obj, animated: true, completion: nil)
        UIApplication.topViewController()?.present(obj, animated: true, completion: nil)
    }
    
    func moveToLoginVC(email: String, usingFor: LoginFlowUsingFor = .loginProcess) {
        let ob = LoginVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.email = email
        ob.currentlyUsingFrom = usingFor
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToCreateYourAccountVC(email: String, usingFor: LoginFlowUsingFor = .loginProcess) {
        let ob = CreateYourAccountVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.email = email
        ob.currentlyUsingFrom = usingFor
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToRegistrationSuccefullyVC(type: ThankYouRegistrationVM.VerifyRegistrasion, email: String, refId: String = "", token: String = "") {
        let ob = ThankYouRegistrationVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.type  = type
        ob.viewModel.email = email
        ob.viewModel.refId = refId
        ob.viewModel.token = token
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func deeplinkToRegistrationSuccefullyVC(type: ThankYouRegistrationVM.VerifyRegistrasion, email: String, refId: String = "", token: String = "") {
        
        let ob = ThankYouRegistrationVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.type  = type
        ob.viewModel.email = email
        ob.viewModel.refId = refId
        ob.viewModel.token = token
        
        let nvc = SwipeNavigationController(rootViewController: ob)
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
    
    func moveToSecureAccountVC(isPasswordType: SecureYourAccountVM.SecureAccount, email: String = "", key: String = "", token:String = "") {
        let ob = SecureYourAccountVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.isPasswordType = isPasswordType
        ob.viewModel.email   = email
        ob.viewModel.hashKey = key
        ob.viewModel.token   = token
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToCreateProfileVC(refId: String, email: String, password: String) {
        
        let ob = CreateProfileVC.instantiate(fromAppStoryboard: .PreLogin)
        
        ob.viewModel.userData.paxId = refId
        ob.viewModel.userData.email    = email
        ob.viewModel.userData.password = password
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToForgotPasswordVC(email: String) {
        let ob = ForgotPasswordVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.email = email
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveResetSuccessFullyPopup(vc: UIViewController) {
        
        let ob = SuccessPopupVC.instantiate(fromAppStoryboard: .PreLogin)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToViewProfileVC() {
        let ob = ViewProfileVC.instantiate(fromAppStoryboard: .Profile)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToViewProfileDetailVC(_ travellerDetails: TravelDetailModel, usingFor: EditProfileVM.UsingFor) {
        let ob = ViewProfileDetailVC.instantiate(fromAppStoryboard: .Profile)
        ob.viewModel.travelData = travellerDetails
        ob.viewModel.currentlyUsingFor = usingFor
        self.mainNavigationController.pushViewController(ob, animated: true)
        
    }
    
    func moveToLinkedAccountsVC(){
        let ob = LinkedAccountsVC.instantiate(fromAppStoryboard: .Profile)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToFFSearchVC(defaultAirlines: [FlyerModel], delegate: SearchVCDelegate?) {
        let controller = FFSearchVC.instantiate(fromAppStoryboard: .Profile)
        controller.delgate = delegate
        controller.defaultAirlines = defaultAirlines
        self.mainNavigationController.present(controller, animated: true, completion: nil)
    }
    
    func moveToHotelSearchVC(){
        let ob = SearchFavouriteHotelsVC.instantiate(fromAppStoryboard: .HotelPreferences)
        self.mainNavigationController.present(ob, animated: true, completion: nil)
    }
    
    func moveToViewAllHotelsVC() {
        let ob = FavouriteHotelsVC.instantiate(fromAppStoryboard: .HotelPreferences)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToTravellerListVC(){
        let ob = TravellerListVC.instantiate(fromAppStoryboard: .TravellerList)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToPreferencesVC(_ delegate: PreferencesVCDelegate){
        let ob = PreferencesVC.instantiate(fromAppStoryboard: .TravellerList)
        ob.delegate = delegate
        self.mainNavigationController.present(ob, animated: true, completion: nil)
    }
    
    func moveToImportContactVC() {
        let ob = ImportContactVC.instantiate(fromAppStoryboard: .TravellerList)
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
                for _ in 0..<(4-selectedAges.count) {
                    ages.append(0)
                }
            }
            ob.viewModel.childrenAge = ages
            mVC.add(childViewController: ob)
        }
    }
    
    func showSelectDestinationVC(delegate: SelectDestinationVCDelegate , currentlyUsingFor: SelectDestinationVC.CurrentlyUsingFor) {
        if let mVC = self.mainHomeVC {
            let ob = SelectDestinationVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.currentlyUsingFor = currentlyUsingFor
            ob.delegate = delegate
            mVC.add(childViewController: ob)
        }
    }
    
    func moveToHotelsResultVc(withFormData: HotelFormPreviosSearchData) {
        let obj = HotelResultVC.instantiate(fromAppStoryboard: .HotelsSearch)
        obj.viewModel.searchedFormData = withFormData
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func showBulkBookingVC(withOldData: HotelFormPreviosSearchData) {
        if let mVC = self.mainHomeVC {
            let ob = BulkBookingVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.viewModel.oldData = withOldData
            mVC.add(childViewController: ob)
        }
    }
    
    func showEditProfileVC(travelData: TravelDetailModel?, usingFor: EditProfileVM.UsingFor) {
        let ob = EditProfileVC.instantiate(fromAppStoryboard: .Profile)
        ob.viewModel.travelData = travelData
        ob.viewModel.currentlyUsinfFor = usingFor
        self.mainNavigationController.present(ob, animated: true, completion: nil)
    }
    
    func presentEditProfileVC() {
        let ob = EditProfileVC.instantiate(fromAppStoryboard: .Profile)
        ob.viewModel.currentlyUsinfFor = .addNewTravellerList
        self.mainNavigationController.present(ob, animated: true, completion: nil)
    }
    
    func showBulkRoomSelectionVC(rooms: Int, adults: Int, children: Int, delegate: BulkRoomSelectionVCDelegate) {
        if let mVC = self.mainHomeVC {
            let ob = BulkRoomSelectionVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.delegate = delegate
            ob.viewModel.roomCount = rooms
            ob.viewModel.adultCount = adults
            ob.viewModel.childrenCounts = children
            mVC.add(childViewController: ob)
        }
    }
    
    func showBulkEnquiryVC(buttonTitle: String) {
        if let mVC = UIApplication.topViewController() {
            let ob = BulkEnquirySuccessfulVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.currentUsingAs = .bulkBooking
            ob.buttonTitle = buttonTitle
            mVC.add(childViewController: ob)
        }
    }
    
    func presentHotelDetailsVC(_ vc : HotelResultVC,hotelInfo: HotelSearched, sourceView: UIView, sid: String , hotelSearchRequest: HotelSearchRequestModel?) {
        if let topVC = UIApplication.topViewController() {
            let ob = HotelDetailsVC.instantiate(fromAppStoryboard: .HotelResults)
            ob.viewModel.hotelInfo = hotelInfo
            ob.delegate = vc
            ob.viewModel.hotelSearchRequest = hotelSearchRequest
            ob.show(onViewController: topVC, sourceView: sourceView, animated: true)
        }
    }
    
    func presentHCSelectGuestsVC(delegate: HCSelectGuestsVCDelegate) {
        if let topVC = UIApplication.topViewController() {
            let ob = HCSelectGuestsVC.instantiate(fromAppStoryboard: .HotelCheckout)
            ob.delegate = delegate
            topVC.present(ob, animated: true, completion: nil)
        }
    }
    
    func presentSearchHotelTagVC(tagButtons: [String] , superView: HotelDetailsSearchTagTableCell) {
        let ob = SearchHotelTagVC.instantiate(fromAppStoryboard: .HotelResults)
        ob.delegate = superView
        ob.tagButtons = tagButtons
        UIApplication.topViewController()?.present(ob, animated: true, completion: nil)
    }
    
    func showHotelDetailAmenitiesVC(hotelDetails: HotelDetails) {
        let ob = HotelDetailsAmenitiesVC.instantiate(fromAppStoryboard: .HotelResults)
        ob.viewModel.hotelDetails = hotelDetails
        UIApplication.topViewController()?.present(ob, animated: true, completion: nil)
    }
    
    func presentHotelDetailsOverViewVC(overViewInfo: String) {
        let ob = HotelDetailsOverviewVC.instantiate(fromAppStoryboard: .HotelResults)
        ob.viewModel.overViewInfo = overViewInfo
        UIApplication.topViewController()?.present(ob, animated: true, completion: nil)
    }
    
    func presentHotelDetailsTripAdvisorVC(hotelId: String) {
        let ob = HotelDetailsReviewsVC.instantiate(fromAppStoryboard: .HotelResults)
        ob.viewModel.hotelId = hotelId
        UIApplication.topViewController()?.present(ob, animated: true, completion: nil)
    }
    
    
    func showAssignGroupVC(_ vc: TravellerListVC,_ selectedTraveller : [String]){
        let ob = AssignGroupVC.instantiate(fromAppStoryboard: .TravellerList)
        ob.viewModel.paxIds = selectedTraveller
        ob.delegate  = vc
        self.mainNavigationController.present(ob, animated: true, completion: nil)
    }
    
    func moveToSettingsVC() {
        let obj = SettingsVC.instantiate(fromAppStoryboard: .Settings)
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func showFilterVC(_ vc : HotelResultVC ) {
        if let obj = UIApplication.topViewController() {
            let ob = HotelFilterVC.instantiate(fromAppStoryboard: .Filter)
            ob.delegate = vc
            obj.add(childViewController: ob)
        }
    }
    
    func moverToFilterVC(){
        let obj = HotelFilterVC.instantiate(fromAppStoryboard: .Filter)
        self.mainNavigationController.present(obj, animated:true , completion: nil)
    }
    
    func moveToHCDataSelectionVC(sid: String, hid: String, qid:String, placeModel: PlaceModel , hotelSearchRequest: HotelSearchRequestModel, hotelInfo: HotelSearched) {
        let obj = HCDataSelectionVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.viewModel.sId = sid
        obj.viewModel.hId = hid
        obj.viewModel.qId = qid
        obj.viewModel.placeModel = placeModel
        obj.viewModel.hotelSearchRequest = hotelSearchRequest
        obj.viewModel.hotelInfo = hotelInfo
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func presentHCCouponCodeVC(itineraryId: String , vc: FinalCheckOutVC , couponCode: String) {
        let obj = HCCouponCodeVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.delegate = vc
        obj.viewModel.itineraryId = itineraryId
        obj.viewModel.couponCode = couponCode
        self.mainNavigationController.present(obj, animated: true)
    }
    
    func presentHCSpecialRequestsVC(specialRequests: [SpecialRequest], selectedRequestIds: [Int], delegate: HCSpecialRequestsDelegate) {
        let obj = HCSpecialRequestsVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.delegate = delegate
        obj.viewModel.specialRequests = specialRequests
        obj.viewModel.selectedRequestsId  = selectedRequestIds
        self.mainNavigationController.present(obj, animated: true)
    }
    
    func presentHCEmailItinerariesVC(forBookingId bId: String , travellers: [TravellersList]) {
        let obj = HCEmailItinerariesVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.viewModel.bookingId = bId
        obj.viewModel.travellers = travellers
        UIApplication.topViewController()?.present(obj, animated: true, completion: nil)
    }
    
    func presentYouAreAllDoneVC(forItId itId: String, bookingIds: [String] , cid: [String] , originLat: String , originLong: String) {
        let obj = YouAreAllDoneVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.viewModel.itId = itId
        obj.viewModel.bookingIds = bookingIds
        obj.viewModel.cId = cid
        obj.viewModel.originLat = originLat
        obj.viewModel.originLong = originLong
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    // Mail Composer
    
    func presentMailComposerVC(_ favouriteHotels: [HotelSearched],_ hotelSearchRequest: HotelSearchRequestModel,_ pinnedTemplateUrl: String) {
        let obj = MailComposerVC.instantiate(fromAppStoryboard: .HotelResults)
        obj.viewModel.favouriteHotels = favouriteHotels
        obj.viewModel.u = pinnedTemplateUrl
        obj.viewModel.hotelSearchRequest = hotelSearchRequest
        self.mainNavigationController.present(obj, animated: true)
    }
    
    func presentSelectTripVC(delegate: SelectTripVCDelegate) {
        /* Don't call this method directly if you want to get the default trip or select the trip if there is no default trip.
         In that case use `AppFlowManager.default.selectTrip()` method.
        */
        let obj = SelectTripVC.instantiate(fromAppStoryboard: .HotelResults)
        obj.delegate = delegate
        self.mainNavigationController.present(obj, animated: true)
    }
    
    func presentCreateNewTripVC(delegate: CreateNewTripVCDelegate, onViewController: UIViewController? = nil) {
        let obj = CreateNewTripVC.instantiate(fromAppStoryboard: .HotelResults)
        obj.modalPresentationStyle = .overCurrentContext
        obj.delegate = delegate
        if let oVC = onViewController {
            oVC.present(obj, animated: true)
        }
        else {
            self.mainNavigationController.present(obj, animated: true)
        }
    }
    
    func moveToGuestDetailScreen(delegate: GuestDetailsVCDelegate,_ indexPath:IndexPath) {
        let obj = GuestDetailsVC.instantiate(fromAppStoryboard: .HotelCheckout)
         obj.vcDelegate = delegate
         obj.viewModel.selectedIndexPath = indexPath
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToFinalCheckoutVC(delegate: FinalCheckOutVCDelegate ,_ itinaryData : ItineraryData? = ItineraryData(),_ itinaryPriceDetail: ItenaryModel? = ItenaryModel() , originLat: String, originLong: String ) {
        let obj = FinalCheckOutVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.viewModel.itineraryData = itinaryData
        obj.delegate = delegate
        obj.viewModel.originLat = originLat
        obj.viewModel.originLong = originLong
        obj.viewModel.itinaryPriceDetail = itinaryPriceDetail
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToBookingIncompleteVC() {
        let obj = HCBookingIncompleteVC.instantiate(fromAppStoryboard: .HotelCheckout)
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToRefundRequestedVC() {
        let obj = HCRefundRequestedVC.instantiate(fromAppStoryboard: .HotelCheckout)
        self.mainNavigationController.pushViewController(obj, animated: true)
    }

    func moveToMyBookingsVC() {
        let obj = MyBookingsVC.instantiate(fromAppStoryboard: .Bookings)
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func showBookingFilterVC(_ vc : MyBookingsVC ) {
        if let obj = UIApplication.topViewController() {
            let ob = MyBookingFilterVC.instantiate(fromAppStoryboard: .Bookings)
//            ob.delegate = vc
            obj.add(childViewController: ob)
        }
    }
    
    func showUpcomingVC(_ vc : UIViewController ) {
        if let obj = UIApplication.topViewController() {
            let ob = UpcomingBookingsVC.instantiate(fromAppStoryboard: .Bookings)
            obj.add(childViewController: ob)
        }
    }
    
    func moveToOtherBookingsDetailsVC() {
        let obj = OtherBookingsDetailsVC.instantiate(fromAppStoryboard: .Bookings)
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func presentBookingFareInfoDetailVC() {
        let obj = BookingFareInfoDetailVC.instantiate(fromAppStoryboard: .Bookings)
        self.mainNavigationController.present(obj, animated: true)
    }

    //MARK:- Account Section
    //MARK:-
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
        let obj = AccountDetailsVC.instantiate(fromAppStoryboard: .Account)
        obj.currentUsingAs = usingFor
        obj.viewModel.allVouchers = forVoucherTypes
        obj.viewModel.setAccountDetails(details: forDetails)
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToAccountLadgerDetailsVC(forEvent: AccountDetailEvent) {
        let obj = AccountLadgerDetailsVC.instantiate(fromAppStoryboard: .Account)
        obj.viewModel.ladgerEvent = forEvent
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToADEventFilterVC(delegate: ADEventFilterVCDelegate, voucherTypes: [String], oldFilter: AccountSelectedFilter?) {
        if let obj = UIApplication.topViewController() {
            let vc = ADEventFilterVC.instantiate(fromAppStoryboard: .Account)
            vc.oldFilter = oldFilter
            vc.voucherTypes = voucherTypes
            vc.delegate = delegate
            obj.add(childViewController: vc)
        }
    }
    
    func moveToAccountOutstandingLadgerVC(data: AccountOutstanding) {
        let obj = AccountOutstandingLadgerVC.instantiate(fromAppStoryboard: .Account)
        obj.viewModel.accountOutstanding = data
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToOnAccountDetailVC(outstanding: AccountOutstanding) {
        let obj = OnAccountDetailVC.instantiate(fromAppStoryboard: .Account)
        obj.viewModel.outstanding = outstanding
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToPeriodicStatementVC() {
        let obj = PeriodicStatementVC.instantiate(fromAppStoryboard: .Account)
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToAccountOnlineDepositVC(depositItinerary: DepositItinerary?) {
        let obj = AccountOnlineDepositVC.instantiate(fromAppStoryboard: .Account)
        obj.viewModel.depositItinerary = depositItinerary
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moveToAccountOfflineDepositVC(usingFor: AccountOfflineDepositVC.UsingFor, paymentModeDetail: PaymentModeDetails?, bankMaster: [String]) {
        let obj = AccountOfflineDepositVC.instantiate(fromAppStoryboard: .Account)
        obj.currentUsingAs = usingFor
        obj.viewModel.paymentModeDetails = paymentModeDetail
        obj.viewModel.bankMaster = bankMaster
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func showAccountDepositSuccessVC(buttonTitle: String) {
        if let mVC = UIApplication.topViewController() {
            let ob = BulkEnquirySuccessfulVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.currentUsingAs = .accountDeposit
            ob.buttonTitle = buttonTitle
            mVC.add(childViewController: ob)
        }
    }
    
    func moveHotelCalenderVC(isHotelCalendar: Bool = false ,isReturn: Bool = false ,isMultiCity: Bool = false , checkInDate: Date =  Date() , checkOutDate: Date? = nil , delegate: CalendarDataHandler ){
        
        
        if let ob = UIStoryboard(name: "AertripCalendar", bundle: Bundle(for: AertripCalendarViewController.self)).instantiateViewController(withIdentifier: "AertripCalendarViewController") as? AertripCalendarViewController {
            let calendarVM = CalendarVM()
            calendarVM.isHotelCalendar = isHotelCalendar
            calendarVM.isReturn = isReturn
            calendarVM.isMultiCity = isMultiCity
            calendarVM.date1 = checkInDate
            calendarVM.date2 = checkOutDate
            ob.viewModel = calendarVM
            ob.viewModel?.delegate = delegate
            self.mainNavigationController.present(ob, animated: true, completion: nil)
        }
    }
    
    func presentAccountChargeInfoVC(usingFor: AccountChargeInfoVM.UsingFor) {
        let obj = AccountChargeInfoVC.instantiate(fromAppStoryboard: .Account)
        obj.viewModel.currentUsingFor = usingFor
        self.mainNavigationController.present(obj, animated: true, completion: nil)
    }
    
    func presentAertripBankDetailsVC(bankDetails: [BankAccountDetail]) {
        let obj = AertripBankDetailsVC.instantiate(fromAppStoryboard: .Account)
        obj.viewModel.allBanks = bankDetails
        self.mainNavigationController.present(obj, animated: true, completion: nil)
    }
    
    // MARK: - Aerin
    
    func showAerinTextToSpeechVC() {
        let ob = AerinTextSpeechVC.instantiate(fromAppStoryboard: .Aerin)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToAerinTextSpeechDetailVC() {
        
        let ob = AerinTextSpeechDetailVC.instantiate(fromAppStoryboard: .Aerin)
        self.mainNavigationController.pushViewController(ob, animated: true)
        
    }
    func presentAerinTextSpeechVC() {
        let ob = AerinTextSpeechVC.instantiate(fromAppStoryboard: .Aerin)
        ob.isFromHotelResult = true
        self.mainNavigationController.present(ob, animated: true)
    }
    
    
    func moveToBookingDetail() {
        let ob = BookingDetailVC.instantiate(fromAppStoryboard: .Bookings)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func presentBaggageInfoVC() {
        let ob = BaggageInfoVC.instantiate(fromAppStoryboard: .Bookings)
        self.mainNavigationController.present(ob, animated: true)
    }
    
    func moveToBookingHotelDetailVC() {
        let ob = BookingHotelDetailVC.instantiate(fromAppStoryboard: .Bookings)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
   

}

//MARK:- Select Trip Flow Methods
extension AppFlowManager {

    func selectTrip(_ tripDetails: TripDetails?, complition: @escaping ((TripModel, TripDetails?)->Void)) {
        
        func openSelectTripScreen(trips: [TripModel]) {
            let obj = SelectTripVC.instantiate(fromAppStoryboard: .HotelResults)
            obj.selectionComplition = complition
            obj.viewModel.allTrips = trips
            obj.viewModel.tripDetails = tripDetails
            self.mainNavigationController.present(obj, animated: true)
        }
        
        if let detail = tripDetails {
            APICaller.shared.getOwnedTripsAPI(params: ["trip_id": detail.trip_id]) { (success, errors, trips, defaultTrip) in
                if let trip = defaultTrip {
                    complition(trip, nil)
                }
                else {
                    openSelectTripScreen(trips: trips)
                }
            }
        }
        else {
            APICaller.shared.getAllTripsAPI { (success, errors, trips, defaultTrip) in
                if let trip = defaultTrip {
                    complition(trip, nil)
                }
                else {
                    openSelectTripScreen(trips: trips)
                }
            }
        }
    }
    
    func removeLoginConfirmationScreenFromStack() {
        delay(seconds: 0.5, completion: {[weak self] in
            guard let _ = self else {return}
            
            //after going to the Data selection screen remove login screen from navigation stack
            var updatedNavStack = AppFlowManager.default.mainNavigationController.viewControllers
            let navStack = AppFlowManager.default.mainNavigationController.viewControllers
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
                
                if (idx == (navStack.count - 1)), (isSocialFound || isLoginFound) {
                    AppFlowManager.default.mainNavigationController.viewControllers = updatedNavStack
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
    
    func openDocument(atURL url: URL, screenTitle: String) {
        self.documentInteractionController.url = url
        self.documentInteractionController.name = screenTitle
        self.documentInteractionController.delegate = self
        self.documentInteractionController.presentPreview(animated: true)
    }
}

//MARK: - Pop Methods
extension AppFlowManager {
    func popViewController(animated: Bool) {
        self.mainNavigationController.popViewController(animated: animated)
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool) {
        self.mainNavigationController.popToViewController(viewController, animated: animated)
    }
    
    func popToRootViewController(animated: Bool) {
        self.mainNavigationController.popToRootViewController(animated: animated)
    }
}

//MARK: - Animation
extension AppFlowManager {
    func addPopAnimation(onNavigationController: UINavigationController?) {
        let transition = CATransition()
        transition.duration = 0.6
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        onNavigationController?.view.layer.add(transition, forKey: nil)
    }
}
