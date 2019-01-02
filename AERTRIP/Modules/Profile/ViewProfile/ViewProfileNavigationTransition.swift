//
//  ViewProfileNavigationTransition.swift
//  AERTRIP
//
//  Created by Admin on 02/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ViewProfileNavigationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    //MARK:- Properties
    //MARK:- Private
    weak private var context: UIViewControllerContextTransitioning?
    
    //MARK:- Public
    
    /**
     Used to decide the transion timing.
     */
    open var duration = 0.5
    private var snapshot = UIView()
    
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
        guard let fromVC = transitionContext?.viewController(forKey: .from) as? PKSideMenuController, let sideMenu = fromVC.menuViewController as? SideMenuVC else {
            return duration
        }
        
        sideMenu.profileImage.isHidden = true
        sideMenu.userNameLabel.isHidden = true
        self.snapshot = fromVC.view.snapshotView(afterScreenUpdates: true) ?? UIView()
        sideMenu.profileImage.isHidden = false
        sideMenu.userNameLabel.isHidden = false
        
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
                let toVC = transitionContext.viewController(forKey: .to) as? ViewProfileVC, let sideMenu = fromVC.menuViewController as? SideMenuVC else {
                    transitionContext.completeTransition(false)
                    return
            }
            
            containerView.addSubview(fromVC.view)
            
            toVC.view.frame = CGRect(x: UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            containerView.addSubview(toVC.view)
            
            let snapFrame = CGRect(x: -UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            let viewFrame = CGRect(x: 0.0, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            let headerFrame = CGRect(x: toVC.view.frame.origin.x, y: toVC.view.frame.origin.y, width: toVC.view.frame.size.width, height: 319.0)
            //319 used as in view profile vc
            
            UIView.animate(withDuration: 0.6, animations: {
                [weak self] in
                fromVC.view.frame = snapFrame
                toVC.view.frame = viewFrame
                sideMenu.profileImage.alpha = 0.0
                sideMenu.userNameLabel.alpha = 0.0
                toVC.profileImageHeaderView.frame = headerFrame
            }) { (isDone) in
                if isDone {
                    sideMenu.profileImage.isHidden = true
                    sideMenu.userNameLabel.isHidden = true
                    self.context?.completeTransition(true)
                }
            }
        }
        else {
            //handel pop animation
            guard let fromVC = transitionContext.viewController(forKey: .from) as? ViewProfileVC,
                let toVC = transitionContext.viewController(forKey: .to) as? PKSideMenuController, let sideMenu = toVC.menuViewController as? SideMenuVC else {
                    transitionContext.completeTransition(false)
                    return
            }
            
            containerView.addSubview(fromVC.view)
            
            toVC.view.frame = CGRect(x: -UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            containerView.addSubview(toVC.view)
            
            let snapFrame = CGRect(x: UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            let viewFrame = CGRect(x: 0.0, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            let headerFrame = CGRect(x: fromVC.view.frame.origin.x, y: fromVC.view.frame.origin.y, width: fromVC.view.frame.size.width, height: 0.0)

            UIView.animate(withDuration: 0.6, animations: {
                fromVC.view.frame = snapFrame
                toVC.view.frame = viewFrame
                sideMenu.profileImage.alpha = 1.0
                sideMenu.userNameLabel.alpha = 1.0
                fromVC.profileImageHeaderView.frame = headerFrame
            }) { (isDone) in
                if isDone {
                    sideMenu.profileImage.isHidden = false
                    sideMenu.userNameLabel.isHidden = false
                    self.context?.completeTransition(true)
                }
            }
        }
    }
}
