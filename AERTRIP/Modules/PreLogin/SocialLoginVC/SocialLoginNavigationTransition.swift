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
            guard let fromVC = transitionContext.viewController(forKey: .from) as? PKSideMenuController,
                let toVC = transitionContext.viewController(forKey: .to) as? SocialLoginVC, let sideMenu = fromVC.menuViewController as? SideMenuVC, let logoView = sideMenu.logoContainerView else {
                    transitionContext.completeTransition(false)
                    return
            }
            
            toVC.logoContainerView.isHidden = true
            toVC.logoContainerPassedView = logoView
            (fromVC.menuViewController as? SideMenuVC)?.logoContainerView.isHidden = true
            let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false) ?? UIView()
            containerView.addSubview(snapshot)
            fromVC.view.removeFromSuperview()
            (fromVC.menuViewController as? SideMenuVC)?.logoContainerView.isHidden = false
            
            logoView.removeFromSuperview()
            self.logoFrameOnSideMenuVC = logoView.frame
            AppFlowManager.default.mainNavigationController.view.addSubview(logoView)
            
            toVC.view.frame = CGRect(x: UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            containerView.addSubview(toVC.view)
            
            let snapFrame = CGRect(x: -UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            let viewFrame = CGRect(x: 0.0, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            let logoFrame = CGRect(x: 20.0, y: 100.0, width: UIDevice.screenWidth - 40.0, height: logoView.height)
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
            UIView.animate(withDuration: 0.3, animations: {
                snapshot.frame = snapFrame
                toVC.view.frame = viewFrame
                logoView.frame = logoFrame
                
            }) { (isCompleted) in
//                sideMenu.logoContainerView = nil
                logoView.removeFromSuperview()
                sideMenu.view.addSubview(logoView)
                if isCompleted {
                    self.context?.completeTransition(true)
                }
            }
        }
    }
    
    func animateOldTextOffscreen(fromView: UIView) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseIn], animations: {
            fromView.center = CGPoint(x: fromView.center.x - 1000, y: fromView.center.y + 1500)
            fromView.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
        }, completion: nil)
    }
    func animate(toView: UIView, fromTriggerButton triggerButton: UIButton) {
        //Starting Path
        let rect = CGRect(x: triggerButton.frame.origin.x,
                          y: triggerButton.frame.origin.y,
                          width: triggerButton.frame.width,
                          height: triggerButton.frame.width)
        let circleMaskPathInitial = UIBezierPath(ovalIn: rect)
        
        //Destination Path
        let fullHeight = toView.bounds.height
        let extremePoint = CGPoint(x: triggerButton.center.x,
                                   y: triggerButton.center.y - fullHeight)
        let radius = sqrt((extremePoint.x*extremePoint.x) +
            (extremePoint.y*extremePoint.y))
        let circleMaskPathFinal = UIBezierPath(ovalIn: triggerButton.frame.insetBy(dx: -radius,
                                                                                   dy: -radius))
        
        //Actual mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        toView.layer.mask = maskLayer
        
        //Mask Animation
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
        maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
    
    func animateToTextView(toTextView: UIView, fromTriggerButton: UIButton) {
        //Start toView offscreen a little and animate it to normal
        let originalCenter = toTextView.center
        toTextView.alpha = 0.0
        toTextView.center = fromTriggerButton.center
        toTextView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.25, delay: 0.1, options: [.curveEaseOut], animations: {
            toTextView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            toTextView.center = originalCenter
            toTextView.alpha = 1.0
        }, completion: nil)
    }
}

extension SocialLoginNavigationTransition: CAAnimationDelegate {
    private func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        context?.completeTransition(true)
    }
}
