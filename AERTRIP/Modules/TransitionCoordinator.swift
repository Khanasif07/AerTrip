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
        
        let animation = DefaultNavigationTransition()
        animation.transitionMode = operation == .pop ? .pop : .push
        return animation
    }
}
