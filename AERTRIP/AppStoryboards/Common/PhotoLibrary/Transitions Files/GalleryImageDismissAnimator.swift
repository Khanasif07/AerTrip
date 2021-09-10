//
//  GalleryImageDismissAnimator.swift
//  AERTRIP
//
//  Created by Apple  on 27.03.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit


class GalleryImageDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let indexPath: IndexPath
    private let finalFrame: CGRect
    private let duration: TimeInterval = 0.5

    init(pageIndex: Int, finalFrame: CGRect) {
        self.indexPath = IndexPath(item: pageIndex, section: 0)
        self.finalFrame = finalFrame
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toVC = transitionContext.viewController(forKey: .to) as? PhotoGalleryVC,
            let fromVC = transitionContext.viewController(forKey: .from) as? SwiftPhotoGallery,
            let swiftPhotoGalleryCell = fromVC.imageCollectionView.cellForItem(at: indexPath) as? SwiftPhotoGalleryCell
            else {
                transitionContext.completeTransition(true)
                return
        }

        let containerView = transitionContext.containerView

        // Determine our original and final frames
        let size = swiftPhotoGalleryCell.imageView.frame.size
        let convertedRect = swiftPhotoGalleryCell.imageView.convert(swiftPhotoGalleryCell.imageView.bounds, to: containerView)
        let originFrame = CGRect(origin: convertedRect.origin, size: size)

        let viewToAnimate = UIImageView(frame: originFrame)
        viewToAnimate.center = CGPoint(x: convertedRect.midX, y: convertedRect.midY)
        viewToAnimate.image = swiftPhotoGalleryCell.imageView.image
        viewToAnimate.contentMode = .scaleAspectFill
        viewToAnimate.clipsToBounds = true

        containerView.addSubview(viewToAnimate)

        toVC.galleryCollection?.cellForItem(at: self.indexPath)?.isHidden = true
        fromVC.view.isHidden = true

        // Animate size and position
        UIView.animate(withDuration: duration, animations: {
            viewToAnimate.frame.size.width = self.finalFrame.width
            viewToAnimate.frame.size.height = self.finalFrame.height
            viewToAnimate.center = CGPoint(x: self.finalFrame.midX, y: self.finalFrame.midY)
        }, completion: { _ in
            toVC.galleryCollection?.cellForItem(at: self.indexPath)?.isHidden = false
            viewToAnimate.removeFromSuperview()
            transitionContext.completeTransition(true)
        })

    }
}
