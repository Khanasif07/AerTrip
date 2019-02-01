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
        
    private let urlScheme = "://"

    private override init() {
        super.init()
    }
    
    var mainNavigationController = UINavigationController() {
        didSet {
            mainNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            mainNavigationController.navigationBar.backgroundColor = AppColors.themeBlack
            mainNavigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] as [NSAttributedString.Key : Any]
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
    
    func setupInitialFlow() {
        self.goToDashboard()
    }
    
    func goToDashboard() {
        let mainHome = MainHomeVC.instantiate(fromAppStoryboard: .Dashboard)
        self.mainHomeVC = mainHome
        let nvc = UINavigationController(rootViewController: mainHome)
        nvc.delegate = AppDelegate.shared.transitionCoordinator
        self.mainNavigationController = nvc
        self.window.rootViewController = nvc
        self.window.becomeKey()
        self.window.backgroundColor = .white
        self.window.makeKeyAndVisible()
    }
}

//MARK: - Public Navigation func
extension AppFlowManager {
    func moveToLogoutNavigation() {
        
    }
    
    func moveToSocialLoginVC() {
        let ob = SocialLoginVC.instantiate(fromAppStoryboard: .PreLogin)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToLoginVC(email: String) {
        let ob = LoginVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.email = email
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToCreateYourAccountVC(email: String) {
        let ob = CreateYourAccountVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.email = email
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
        
        let nvc = UINavigationController(rootViewController: ob)
        self.mainNavigationController = nvc
        self.window.rootViewController = nvc
        self.window.becomeKey()
        self.window.makeKeyAndVisible()
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
    
    func moveToViewProfileDetailVC(_ travellerDetails: TravelDetailModel, _ isFromTravellerList:Bool = false) {
        let ob = ViewProfileDetailVC.instantiate(fromAppStoryboard: .Profile)
        ob.viewModel.paxId = travellerDetails.id
        ob.travelData = travellerDetails
        ob.viewModel.isFromTravellerList = isFromTravellerList
        self.mainNavigationController.pushViewController(ob, animated: true)

    }
    
    func moveToEditProfileVC(){
        let ob = EditProfileVC.instantiate(fromAppStoryboard: .Profile)
        ob.viewModel.isFromViewProfile = true
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToLinkedAccountsVC(){
        let ob = LinkedAccountsVC.instantiate(fromAppStoryboard: .Profile)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToHotelSearchVC(){
        let ob = HotelSearchVC.instantiate(fromAppStoryboard: .HotelPreferences)
        self.mainNavigationController.present(ob, animated: true, completion: nil)
    }
    
    func moveToViewAllHotelsVC() {
        let ob = ViewAllHotelsVC.instantiate(fromAppStoryboard: .HotelPreferences)
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
    
    func showRoomGuestSelectionVC(selectedAdults: Int, selectedChildren: Int, selectedAges: [Int], delegate: RoomGuestSelectionVCDelegate) {
        if let mVC = self.mainHomeVC {
            let ob = RoomGuestSelectionVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.delegate = delegate
            ob.viewModel.selectedChilds = selectedChildren
            ob.viewModel.selectedAdults = max(1, selectedAdults)
            
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
    
    func showSelectDestinationVC(delegate: SelectDestinationVCDelegate) {
        if let mVC = self.mainHomeVC {
            let ob = SelectDestinationVC.instantiate(fromAppStoryboard: .HotelsSearch)
            ob.delegate = delegate
            mVC.add(childViewController: ob)
        }
    }
    
    func showBulkBookingVC() {
        if let mVC = self.mainHomeVC {
            let ob = BulkBookingVC.instantiate(fromAppStoryboard: .HotelsSearch)
            mVC.add(childViewController: ob)
        }
    }
    
    func presentEditProfileVC() {
        let ob = EditProfileVC.instantiate(fromAppStoryboard: .Profile)
        ob.viewModel.isFromTravellerList = true
        self.mainNavigationController.present(ob, animated: true, completion: nil)
    }
    
    func presentAssignGroupVC(_ vc: TravellerListVC,_ selectedTraveller : [String]){
        let ob = AssignGroupVC.instantiate(fromAppStoryboard: .TravellerList)
        ob.viewModel.paxIds = selectedTraveller
        ob.delegate  = vc
        self.mainNavigationController.present(ob, animated: true, completion: nil)
    }
    
    func moveToSettingsVC() {
        let obj = SettingsVC.instantiate(fromAppStoryboard: .Settings)
        self.mainNavigationController.pushViewController(obj, animated: true)
    }
    
    func moverToFilterVC(){
        let obj = HotelFilterVC.instantiate(fromAppStoryboard: .Filter)
        self.mainNavigationController.present(obj, animated:true , completion: nil)
    }
    func showFilterVC() {
        if let mVC = self.mainHomeVC {
            let ob = HotelFilterVC.instantiate(fromAppStoryboard: .Filter)
            mVC.add(childViewController: ob)
        }
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
