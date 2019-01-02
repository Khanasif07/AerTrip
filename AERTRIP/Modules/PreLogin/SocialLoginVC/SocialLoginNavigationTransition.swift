//
//  SocialLoginNavigationTransition.swift
//  AERTRIP
//
//  Created by Admin on 29/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

open class SocialLoginNavigationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    //MARK:- Properties
    //MARK:- Private
    private var logoFrameOnSideMenuVC: CGRect = CGRect.zero
    weak private var context: UIViewControllerContextTransitioning?

    //MARK:- Public
    
    /**
     Used to decide the transion timing.
     */
    open var duration = 0.5
    
    /**
     Used to decide weather animation should be for which transition mode. Like (push, pop, present, dismiss)
     */
    open var transitionMode: ATTransitionMode = .present

    
    //MARK:- UIViewControllerAnimatedTransitioning
    //MARK:-
    
    /**
     Required by UIViewControllerAnimatedTransitioning
     */
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    /**
     Required by UIViewControllerAnimatedTransitioning
     */
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        context = transitionContext
        let containerView = transitionContext.containerView
        
        if self.transitionMode == .push {
            //handel push animation
            guard let fromVC = transitionContext.viewController(forKey: .from) as? PKSideMenuController,
                let toVC = transitionContext.viewController(forKey: .to) as? SocialLoginVC, let sideMenu = fromVC.menuViewController as? SideMenuVC, let logoView = sideMenu.logoContainerView, let snapshot = sideMenu.sideMenuSnap else {
                    transitionContext.completeTransition(false)
                    return
            }
            
            toVC.logoContainerView.isHidden = true
            toVC.logoContainerPassedView = logoView
            
//            logoView.removeFromSuperview()
            self.logoFrameOnSideMenuVC = logoView.frame
//            AppFlowManager.default.mainNavigationController.view.addSubview(logoView)

//            let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false) ?? UIView()
            containerView.addSubview(snapshot)
            fromVC.view.removeFromSuperview()
            
            toVC.view.frame = CGRect(x: UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            containerView.addSubview(toVC.view)
            
            let snapFrame = CGRect(x: -UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            let viewFrame = CGRect(x: 0.0, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            let logoFrame = CGRect(x: 35.0, y: 80.0, width: UIDevice.screenWidth - 70.0, height: logoView.height)
            
            toVC.animateContentOnLoad()
            UIView.animate(withDuration: 0.6, animations: {
                snapshot.frame = snapFrame
                toVC.view.frame = viewFrame
                logoView.frame = logoFrame
                
            }) { (isCompleted) in
                if isCompleted {
                    self.context?.completeTransition(true)
                }
            }
        }
        else {
            //handel pop animation
            guard let fromVC = transitionContext.viewController(forKey: .from) as? SocialLoginVC,
                let toVC = transitionContext.viewController(forKey: .to) as? PKSideMenuController,
                let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false), let sideMenu = toVC.menuViewController as? SideMenuVC, let logoView = sideMenu.logoContainerView else {
                    transitionContext.completeTransition(false)
                    return
            }
            
            fromVC.logoContainerView.isHidden = true
            logoView.isHidden = false
            
            containerView.addSubview(snapshot)
            fromVC.view.removeFromSuperview()
            
            toVC.view.frame = CGRect(x: -UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            containerView.addSubview(toVC.view)
            
            let snapFrame = CGRect(x: UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            let viewFrame = CGRect(x: 0.0, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            let logoFrame = CGRect(x: sideMenu.sideMenuTableView.x, y: sideMenu.sideMenuTableView.y, width: sideMenu.sideMenuTableView.width, height: 180.0)
            
            fromVC.animateContentOnPop()
            
            UIView.animate(withDuration: 0.3, animations: {
                snapshot.frame = snapFrame
                toVC.view.frame = viewFrame
                logoView.frame = logoFrame
                
            }) { (isCompleted) in
//                logoView.removeFromSuperview()
//                sideMenu.view.addSubview(logoView)
                if isCompleted {
                    self.context?.completeTransition(true)
                }
            }
        }
    }
}
