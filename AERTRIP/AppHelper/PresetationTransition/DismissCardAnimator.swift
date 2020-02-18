//
//  DismissCardAnimator.swift
//  DemoCollectionAnimation
//
//  Created by Apple  on 03.02.20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

final class DismissCardAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    struct Params {
        let fromCardFrame: CGRect
        let fromCardFrameWithoutTransform: CGRect
        let fromCell: TransitionCellTypeDelegate
        let img:UIImage?
    }

    struct Constants {
        static let relativeDurationBeforeNonInteractive: TimeInterval = 0.5
        static let minimumScaleBeforeNonInteractive: CGFloat = 0.8
    }

    private let params: Params

    init(params: Params) {
        self.params = params
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return GlobalConstants.dismissalAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let ctx = transitionContext
        let container = ctx.containerView
        
        let toVC = ctx.viewController(forKey: .to)!.children.first(where: {$0.isKind(of: HotelResultVC.self)}) as? HotelResultVC
        
        var fromVC = ctx.viewController(forKey: .from) as? HotelDetailsVC
        
        let screens: (cardDetail: HotelDetailsVC, home: HotelResultVC?) = (
            (fromVC != nil) ? fromVC! : ctx.viewController(forKey: .from)?.children.first as! HotelDetailsVC ,
            (toVC == nil) ? ctx.viewController(forKey: .to) as? HotelResultVC : toVC
        )
        var isCellHidden  = false
        let cardDetailView = (fromVC != nil) ? ctx.view(forKey: .from)! : screens.cardDetail.view!
        cardDetailView.backgroundColor = UIColor.clear

        let animatedContainerView = UIView()
        if GlobalConstants.isEnabledDebugAnimatingViews {
            animatedContainerView.layer.borderColor = UIColor.yellow.cgColor
            animatedContainerView.layer.borderWidth = 4
            cardDetailView.layer.borderColor = UIColor.red.cgColor
            cardDetailView.layer.borderWidth = 2
        }
        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardDetailView.translatesAutoresizingMaskIntoConstraints = false
        container.removeConstraints(container.constraints)
        container.addSubview(animatedContainerView)
        animatedContainerView.addSubview(cardDetailView)
        cardDetailView.edges(to: animatedContainerView)

        animatedContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        let animatedContainerTopConstraint = animatedContainerView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0)
        let animatedContainerWidthConstraint = animatedContainerView.widthAnchor.constraint(equalToConstant: cardDetailView.frame.width)
        let animatedContainerHeightConstraint = animatedContainerView.heightAnchor.constraint(equalToConstant: cardDetailView.frame.height)
        NSLayoutConstraint.activate([animatedContainerTopConstraint, animatedContainerWidthConstraint, animatedContainerHeightConstraint])

        // Fix weird top inset
        let topTemporaryFix = screens.cardDetail.imageView.topAnchor.constraint(equalTo: cardDetailView.topAnchor)
  
        topTemporaryFix.isActive = GlobalConstants.isEnabledWeirdTopInsetsFix
        container.layoutIfNeeded()

        let stretchCardToFillBottom = screens.cardDetail.imageView.bottomAnchor.constraint(equalTo: cardDetailView.bottomAnchor)

        func setupForDismiss(){
            screens.cardDetail.headerView.firstRightButton.isHidden = true
            screens.cardDetail.headerView.leftButton.isHidden = true
            screens.cardDetail.headerView.isHidden = true
            screens.cardDetail.footerView.isHidden = true
            screens.cardDetail.imageView.isHidden = false
            screens.cardDetail.imageView.layer.cornerRadius = 10
            screens.cardDetail.imageView.clipsToBounds = true
            screens.cardDetail.imageView.contentMode = .scaleAspectFill
            
            if let vc = toVC{
                vc.switchContainerView.layer.opacity = 0
                
            }
        }
        
        
        func animateCardViewBackToPlace() {
            stretchCardToFillBottom.isActive = true
            cardDetailView.transform = CGAffineTransform.identity
            animatedContainerTopConstraint.constant = self.params.fromCardFrameWithoutTransform.minY
            animatedContainerWidthConstraint.constant = self.params.fromCardFrameWithoutTransform.width
            animatedContainerHeightConstraint.constant = self.params.fromCardFrameWithoutTransform.height
            container.layoutIfNeeded()
            if !isCellHidden{
                screens.cardDetail.hotelTableView.isHidden = true
            }
        }

        func completeEverything() {
            let success = !ctx.transitionWasCancelled
            animatedContainerView.removeConstraints(animatedContainerView.constraints)
            animatedContainerView.removeFromSuperview()
            if success {
                cardDetailView.removeFromSuperview()
                self.params.fromCell.isHidden = false
                if let vc = toVC{
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                        vc.switchContainerView.layer.opacity = 1
                    }, completion: nil)
                }
            } else {
                topTemporaryFix.isActive = false
                stretchCardToFillBottom.isActive = false
                cardDetailView.removeConstraint(topTemporaryFix)
                cardDetailView.removeConstraint(stretchCardToFillBottom)
                container.removeConstraints(container.constraints)
                container.addSubview(cardDetailView)
                cardDetailView.edges(to: container)
            }
            ctx.completeTransition(success)
        }
        if let cell = screens.cardDetail.hotelTableView.cellForRow(at: [0,0]) as? HotelDetailsImgSlideCell{
            cell.contentView.isHidden = true
            cell.isHidden = true
            isCellHidden  = true
            cell.alpha = 0.0
        }
        
//        fadeInWithAnimation(layer: screens.cardDetail.imageView.layer, duration: 1.5, from: 1, to: 0)
        
        screens.cardDetail.imageView.image = self.params.img
        
        UIView.animate(withDuration: transitionDuration(using: ctx), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            setupForDismiss()
            animateCardViewBackToPlace()
        }) { (finished) in
            completeEverything()
        }

        UIView.animate(withDuration: transitionDuration(using: ctx) * 0.6) {
            screens.cardDetail.hotelTableView.contentOffset = .zero
        }
    }
    
    func fadeInWithAnimation(layer:CALayer, duration:Double,from:Any, to: Any){
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = from
        animation.toValue = to
        animation.repeatCount = 0
        animation.autoreverses = false
        animation.duration = duration
        layer.add(animation, forKey: nil)
    }
    
    
}


extension UIView{
    func viewScreenShot() -> UIImage? {
        var screenshotImage :UIImage?
        let layer = self.layer
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, UIScreen.main.scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshotImage
    }
}
