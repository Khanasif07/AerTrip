//
//  SocialLoginNavigationTransition.swift
//  AERTRIP
//
//  Created by Admin on 29/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

open class SocialLoginNavigationTransition: NSObject {
    
    open var duration = 0.5
    
    open var transitionMode: ATTransitionMode = .present

}

extension SocialLoginNavigationTransition: UIViewControllerAnimatedTransitioning {
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
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
        
        let containerView = transitionContext.containerView
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
    }
}
