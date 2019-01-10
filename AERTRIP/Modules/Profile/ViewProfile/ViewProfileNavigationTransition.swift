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
    //    private var logoFrameOnSideMenuVC: CGRect = CGRect.zero
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
        
        
        if let fromVC = transitionContext?.viewController(forKey: .from) as? PKSideMenuController, let sideMenu = fromVC.menuViewController as? SideMenuVC {
            
            sideMenu.profileContainerView.isHidden = true
            self.snapshot = fromVC.view.snapshotView(afterScreenUpdates: true) ?? UIView()
            sideMenu.profileContainerView.isHidden = false
        }
        if let fromVC = transitionContext?.viewController(forKey: .from) as? ViewProfileVC {
            
            fromVC.profileImageHeaderView?.isHidden = true
            self.snapshot = fromVC.view.snapshotView(afterScreenUpdates: true) ?? UIView()
            fromVC.profileImageHeaderView?.isHidden = false
            fromVC.profileImageHeaderView?.profileImageViewHeightConstraint.constant = 100.0
            fromVC.profileImageHeaderView?.profileImageView.cornerRadius = 50.0
        }
        
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
                let toVC = transitionContext.viewController(forKey: .to) as? ViewProfileVC, let sideMenu = fromVC.menuViewController as? SideMenuVC, let profileView = sideMenu.profileContainerView else {
                    transitionContext.completeTransition(false)
                    return
            }
            
            toVC.profileImageHeaderView?.isHidden = true
            toVC.profileImageHeaderView = profileView
            
            containerView.addSubview(snapshot)
            fromVC.view.removeFromSuperview()
            
            toVC.view.frame = CGRect(x: UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            containerView.addSubview(toVC.view)
            
            profileView.removeFromSuperview()
            containerView.addSubview(profileView)
            
            let snapFrame = CGRect(x: -UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            let viewFrame = CGRect(x: 0.0, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            let profileFrame = CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: UIDevice.screenHeight*0.48)
            
            profileView.emailIdLabel.isHidden = false
            profileView.mobileNumberLabel.isHidden = false
            profileView.backgroundImageView.isHidden = false
            profileView.gradientView.isHidden = false
            profileView.dividerView.isHidden = false
            
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: { [weak self] in
                    self?.snapshot.frame = snapFrame
                    toVC.view.frame = viewFrame
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                    profileView.frame = profileFrame
                    profileView.profileContainerView.transform = CGAffineTransform.identity
                    profileView.emailIdLabel.alpha = 1.0
                    profileView.mobileNumberLabel.alpha = 1.0
                    profileView.backgroundImageView.alpha = 1.0
                    profileView.gradientView.alpha = 1.0
                    profileView.dividerView.alpha = 1.0
                    profileView.layoutSubviews()
                })
                
            }, completion: { _ in
                profileView.removeFromSuperview()
                profileView.frame.origin = .zero
                toVC.setupParallaxHeader()
                self.context?.completeTransition(true)
            })
            
//            UIView.animate(withDuration: duration, animations: { [weak self] in
//                self?.snapshot.frame = snapFrame
//                toVC.view.frame = viewFrame
//                profileView.frame = profileFrame
//                profileView.profileContainerView.transform = CGAffineTransform.identity
//                profileView.emailIdLabel.alpha = 1.0
//                profileView.mobileNumberLabel.alpha = 1.0
//                profileView.backgroundImageView.alpha = 1.0
//                profileView.gradientView.alpha = 1.0
//                profileView.dividerView.alpha = 1.0
//                profileView.layoutSubviews()
//
//            }) { (isCompleted) in
//                if isCompleted {
//                    profileView.removeFromSuperview()
//                    profileView.frame.origin = .zero
//                    toVC.setupParallaxHeader()
//                    self.context?.completeTransition(true)
//                }
//            }
        }
        else {
            //handel pop animation
            guard let fromVC = transitionContext.viewController(forKey: .from) as? ViewProfileVC,
                let toVC = transitionContext.viewController(forKey: .to) as? PKSideMenuController, let sideMenu = toVC.menuViewController as? SideMenuVC, let profileView = sideMenu.profileContainerView else {
                    transitionContext.completeTransition(false)
                    return
            }
            
            fromVC.profileImageHeaderView?.isHidden = true
            profileView.isHidden = false
            
            containerView.addSubview(snapshot)
            fromVC.view.removeFromSuperview()
            
            toVC.view.frame = CGRect(x: -UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            containerView.addSubview(toVC.view)
            
            fromVC.deSetupParallaxHeader()
            containerView.addSubview(profileView)
            
            let snapFrame = CGRect(x: UIDevice.screenWidth, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            let viewFrame = CGRect(x: 0.0, y: 0.0, width: toVC.view.width, height: toVC.view.height)
            let profileFrame = CGRect(x: sideMenu.sideMenuTableView.x, y: 50.0, width: sideMenu.sideMenuTableView.width, height: UIDevice.screenHeight*0.22)
            
            profileView.gradientView.alpha = 0.0
            profileView.gradientView.isHidden = true
            
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                    self.snapshot.frame = snapFrame
                    toVC.view.frame = viewFrame
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                    profileView.frame = profileFrame
                    profileView.emailIdLabel.alpha = 0.0
                    profileView.mobileNumberLabel.alpha = 0.0
                    profileView.backgroundImageView.alpha = 0.0
                    profileView.gradientView.alpha = 0.0
                    profileView.dividerView.alpha = 0.0
                })
                
            }, completion: { _ in
                profileView.emailIdLabel.isHidden = true
                profileView.mobileNumberLabel.isHidden = true
                profileView.backgroundImageView.isHidden = true
                profileView.gradientView.isHidden = true
                profileView.dividerView.isHidden = true
                
                profileView.removeFromSuperview()
                profileView.frame = CGRect(x: 0.0, y: 50.0, width: sideMenu.sideMenuTableView.width, height: UIDevice.screenHeight*0.22)
                sideMenu.sideMenuTableView.addSubview(profileView)
                
                self.context?.completeTransition(true)
            })
            
            
            //            UIView.animate(withDuration: duration, animations: {
            //                self.snapshot.frame = snapFrame
            //                toVC.view.frame = viewFrame
            //                profileView.frame = profileFrame
            //                profileView.emailIdLabel.alpha = 0.0
            //                profileView.mobileNumberLabel.alpha = 0.0
            //                profileView.backgroundImageView.alpha = 0.0
            //                profileView.gradientView.alpha = 0.0
            //                profileView.dividerView.alpha = 0.0
            //                profileView.layoutIfNeeded()
            //
            //            }) { (isCompleted) in
            //                if isCompleted {
            //                    profileView.emailIdLabel.isHidden = true
            //                    profileView.mobileNumberLabel.isHidden = true
            //                    profileView.backgroundImageView.isHidden = true
            //                    profileView.gradientView.isHidden = true
            //                    profileView.dividerView.isHidden = true
            //
            //                    profileView.removeFromSuperview()
            //                    profileView.frame = CGRect(x: 0.0, y: 50.0, width: sideMenu.sideMenuTableView.width, height: UIDevice.screenHeight*0.22)
            //                    sideMenu.sideMenuTableView.addSubview(profileView)
            //
            //                    self.context?.completeTransition(true)
            //                }
            //            }
        }
    }
}
