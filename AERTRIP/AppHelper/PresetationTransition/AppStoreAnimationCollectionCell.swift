//
//  AppStoreAnimationCollectionCell.swift
//  AERTRIP
//
//  Created by Apple  on 05.02.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class AppStoreAnimationCollectionCell: UICollectionViewCell,TransitionCellTypeDelegate {
    
    var disabledHighlightedAnimation:Bool!
    var selfImage:UIImage?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.selfImage = self.viewScreenShot()
        animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    
    func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        if disabledHighlightedAnimation { return }
        let animationOptions: UIView.AnimationOptions =  []
        if isHighlighted {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: animationOptions, animations: {
                self.transform = CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: animationOptions, animations: {
                self.transform = .identity
            }, completion: completion)
        }
    }
}



class AppStoreAnimationTableViewCell: UITableViewCell,TransitionCellTypeDelegate {
    
    var disabledHighlightedAnimation:Bool!
    var selfImage:UIImage?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.selfImage = self.viewScreenShot()
        animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    
    func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        if disabledHighlightedAnimation { return }
        let animationOptions: UIView.AnimationOptions =  []
        if isHighlighted {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: animationOptions, animations: {
                self.transform = CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: animationOptions, animations: {
                self.transform = .identity
            }, completion: completion)
        }
    }
}
