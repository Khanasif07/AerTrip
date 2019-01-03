//
//  TransitionCoordinator.swift
//  AERTRIP
//
//  Created by Admin on 31/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class TransitionCoordinator: NSObject, UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        func getDefaultTransition() -> DefaultNavigationTransition {
            let animation = DefaultNavigationTransition()
            animation.transitionMode = operation == .pop ? .pop : .push
            return animation
        }
        
        switch fromVC {
            
        case is PKSideMenuController:
            
            if toVC.isKind(of: ViewProfileVC.self) {
                let animation = ViewProfileNavigationTransition()
                animation.transitionMode = .push
                return animation
            }
            else if toVC.isKind(of: SocialLoginVC.self) {
                let animation = SocialLoginNavigationTransition()
                animation.transitionMode = .push
                return animation
            }
            return getDefaultTransition()
            
        case is SocialLoginVC:
            if operation == .pop {
                let animation = SocialLoginNavigationTransition()
                animation.transitionMode = .pop
                return animation
            }
            return getDefaultTransition()
            
        case is ViewProfileVC :
            if toVC.isKind(of: PKSideMenuController.self) {
                let animation = ViewProfileNavigationTransition()
                animation.transitionMode = .pop
                return animation
            }
            return getDefaultTransition()
            
        default:
            return getDefaultTransition()
        }
    }
}
