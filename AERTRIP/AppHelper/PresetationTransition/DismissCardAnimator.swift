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
        let fromCell: AppStoreAnimationCollectionCell
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
        let screens: (cardDetail: HotelDetailsVC, home: HotelResultVC?) = (
            ctx.viewController(forKey: .from)! as! HotelDetailsVC,
            ctx.viewController(forKey: .to)! as? HotelResultVC
        )
        var hideCell  = false
        let cardDetailView = ctx.view(forKey: .from)!
        cardDetailView.backgroundColor = UIColor.clear
        
        let snap = params.fromCell.snapshotView(afterScreenUpdates: false) ?? UIView()

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

        func animateCardViewBackToPlace() {
            stretchCardToFillBottom.isActive = true
            cardDetailView.transform = CGAffineTransform.identity
            animatedContainerTopConstraint.constant = self.params.fromCardFrameWithoutTransform.minY
            animatedContainerWidthConstraint.constant = self.params.fromCardFrameWithoutTransform.width
            animatedContainerHeightConstraint.constant = self.params.fromCardFrameWithoutTransform.height
            container.layoutIfNeeded()
            if !hideCell{
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
            hideCell  = true
            cell.alpha = 0.0
        }
        screens.cardDetail.imageView.image = self.params.img
        
        UIView.animate(withDuration: transitionDuration(using: ctx), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            screens.cardDetail.headerView.firstRightButton.isHidden = true
            screens.cardDetail.headerView.leftButton.isHidden = true
            screens.cardDetail.headerView.isHidden = true
            screens.cardDetail.footerView.isHidden = true
            screens.cardDetail.imageView.isHidden = false
            screens.cardDetail.imageView.layer.cornerRadius = 10
            screens.cardDetail.imageView.clipsToBounds = true
            screens.cardDetail.imageView.contentMode = .scaleAspectFill
            animateCardViewBackToPlace()
        }) { (finished) in
            completeEverything()
        }

        UIView.animate(withDuration: transitionDuration(using: ctx) * 0.6) {
            screens.cardDetail.hotelTableView.contentOffset = .zero
        }
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
