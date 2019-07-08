//
//  DefaultNavigationTransition.swift
//  AERTRIP
//
//  Created by Admin on 02/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class DefaultNavigationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    //MARK:- Properties
    //MARK:- Private
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
            guard let fromVC = transitionContext.viewController(forKey: .from),
                let toVC = transitionContext.viewController(forKey: .to) else {
                    transitionContext.completeTransition(false)
                    return
            }
            
            containerView.addSubview(fromVC.view)
            
            toVC.view.frame = CGRect(x: UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            containerView.addSubview(toVC.view)
            
            let fromFrame = CGRect(x: -UIDevice.screenWidth, y: 0.0, width: fromVC.view.width, height: fromVC.view.height)
            let toFrame = CGRect(x: 0.0, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            
            UIView.animate(withDuration: self.duration, animations: {
                fromVC.view.frame = fromFrame
                toVC.view.frame = toFrame
                
            }) { (isCompleted) in
                if isCompleted {
                    self.context?.completeTransition(true)
                }
            }
        }
        else {
            //handel pop animation
            
            guard let fromVC = transitionContext.viewController(forKey: .from),
                let toVC = transitionContext.viewController(forKey: .to) else {
                    transitionContext.completeTransition(false)
                    return
            }
            
            fromVC.view.frame = CGRect(x: 0.0, y: 0.0, width: fromVC.view.width, height: fromVC.view.height)
            containerView.addSubview(fromVC.view)
            
            toVC.view.frame = CGRect(x: -UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            containerView.addSubview(toVC.view)
            
            let fromFrame = CGRect(x: UIDevice.screenWidth, y: 0.0, width: fromVC.view.width, height: fromVC.view.height)
            let toFrame = CGRect(x: 0.0, y: 0.0, width: toVC.view.width, height: toVC.view.height)

            UIView.animate(withDuration: self.duration, animations: {
                fromVC.view.frame = fromFrame
                toVC.view.frame = toFrame
                
            }) { (isCompleted) in
                if isCompleted {
                    self.context?.completeTransition(true)
                }
            }
        }
    }
}
