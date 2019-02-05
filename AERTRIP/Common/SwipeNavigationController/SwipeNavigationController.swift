//
//  SwipeNavigationController.swift
//  AERTRIP
//
//  Created by Admin on 04/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

final class SwipeNavigationController: UINavigationController {
    
    var isPushingViewController = false
    weak var externalDelegate: UINavigationControllerDelegate?
    
    // 1
    override var delegate: UINavigationControllerDelegate? {
        didSet {
            if !(delegate is SwipeNavigationController) {
                externalDelegate = delegate
                super.delegate = oldValue
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        isPushingViewController = true
        super.pushViewController(viewController, animated: animated)
    }
}

extension SwipeNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer is UIScreenEdgePanGestureRecognizer else { return true }
        return viewControllers.count > 1 && !isPushingViewController
    }
}

// 2
extension SwipeNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isPushingViewController = false
        externalDelegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        externalDelegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return externalDelegate?.navigationControllerSupportedInterfaceOrientations?(navigationController) ?? visibleViewController?.supportedInterfaceOrientations ?? .all
    }
    
    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        return externalDelegate?.navigationControllerPreferredInterfaceOrientationForPresentation?(navigationController) ?? self.preferredInterfaceOrientationForPresentation
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return externalDelegate?.navigationController?(navigationController, animationControllerFor: operation, from: fromVC, to:toVC)
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return externalDelegate?.navigationController?(navigationController, interactionControllerFor: animationController)
    }
}
