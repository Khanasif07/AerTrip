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
        
        switch fromVC {
            
        case is PKSideMenuController:
            let animation = SocialLoginNavigationTransition()
            animation.transitionMode = .push
            return animation
            
        case is SocialLoginVC:
            if operation == .pop {
                let animation = SocialLoginNavigationTransition()
                animation.transitionMode = .pop
                return animation
            }
            return nil
            
        default:
            return nil
        }

        return nil
    }
}
