//
//  AppFlowManager.swift
//  
//
//  Created by Pramod Kumar on 24/07/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

enum ViewPresnetEnum {
    case push, present, popup
}

class AppFlowManager {
    
    static let `default` = AppFlowManager()
    
    var sideMenuController: PKSideMenuController?
    
    private let urlScheme = "://"

    private init() {}
    
    private var mainNavigationController = UINavigationController() {
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
        PKSideMenuOptions.opacityViewBackgroundColor = AppColors.themeGreen
        let dashboard = PKSideMenuController(mainViewController: MainDashboardVC.instantiate(fromAppStoryboard: .Dashboard), rightMenuViewController: SideMenuVC.instantiate(fromAppStoryboard: .Dashboard))
        self.sideMenuController = dashboard
        let nvc = UINavigationController(rootViewController: dashboard)
        self.mainNavigationController = nvc
        self.window.rootViewController = nvc
        self.window.becomeKey()
        self.window.makeKeyAndVisible()
    }
}

//MARK: - Public Navigation func
extension AppFlowManager {
    func moveToLogoutNavigation() {
        
    }
    
    func moveToLoginVC() {
        let ob = LoginVC.instantiate(fromAppStoryboard: .PreLogin)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToCreateYourAccountVC() {
        let ob = CreateYourAccountVC.instantiate(fromAppStoryboard: .PreLogin)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToRegistrationSuccefullyVC(email: String) {
        let ob = ThankYouRegistrationVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.email = email
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToSecureAccountVC(isPasswordType: SecureYourAccountVM.SecureAccount) {
        let ob = SecureYourAccountVC.instantiate(fromAppStoryboard: .PreLogin)
        ob.viewModel.isPasswordType = isPasswordType
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToCreateProfileVC() {
        let ob = CreateProfileVC.instantiate(fromAppStoryboard: .PreLogin)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func moveToForgotPasswordVC() {
        let ob = ForgotPasswordVC.instantiate(fromAppStoryboard: .PreLogin)
        self.mainNavigationController.pushViewController(ob, animated: true)
    }
    
    func addSuccessFullPopupVC(vc: UIViewController) {
        
        let ob = SuccessPopupVC.instantiate(fromAppStoryboard: .PreLogin)
        
        vc.view.addSubview(ob.view)
        vc.addChild(ob)
    }
}

//MARK: - Private func
extension AppFlowManager {

}
