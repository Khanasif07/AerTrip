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
    
    
    private let urlScheme = "://"

    private init() {}
    
    private var mainNavigationController = UINavigationController() {
        didSet {
            mainNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            mainNavigationController.navigationBar.backgroundColor = AppColors.themeTotalBlack
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
        
        if let _ = UserInfo.loggedInUserId {
//            if user.userType == .guest {
//                let home = MapVC.instantiate(fromAppStoryboard: .Home)
//                self.mainNavigationController.viewControllers.append(home)
//            } else {
                self.goToHomeWithSideMenu()
//            }
        } else {
            self.goToLogin()
        }
    }
    
    func goToLogin() {
        
        self.window.becomeKey()
        self.window.makeKeyAndVisible()
    }
    
    func goToHomeWithSideMenu() {
        
        self.window.becomeKey()
        self.window.makeKeyAndVisible()
    }
}

//MARK: - Public Navigation func
extension AppFlowManager {
    func moveToLoginFromSignup() {
        
    }
    
    func moveToLogoutNavigation() {
        
    }
}

//MARK: - Private func
extension AppFlowManager {

}
