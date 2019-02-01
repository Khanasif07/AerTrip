//
//  UIButtonExtension.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 05/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func addRequiredActionToShowAnimation() {
        self.addTarget(self, action: #selector(buttonTapped(_:)), for: UIControl.Event.touchDown)
        self.addTarget(self, action: #selector(buttonTappedReleased(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
    
    @objc private func buttonTappedReleased(_ sender: UIButton) {
        self.transform = CGAffineTransform.identity
    }
}


public extension UIBarButtonItem {
    
    /// SwifterSwift: Add Target to UIBarButtonItem
    ///
    /// - Parameters:
    ///   - target: target.
    ///   - action: selector to run when button is tapped.
    public func addTargetForAction(_ target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
    
}

extension UIButton {
    func dumpingButtonSelectionAnimation() {
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 3.0,
                       options: .allowAnimatedContent,
                       animations: { [weak self] in
                        self?.transform = .identity
            },
                       completion: nil)
    }
    
    func dumbingButtonDeselctionAnimation() {
        self.transform = .identity
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 3.0,
                       options: .allowUserInteraction,
                       animations: {
                        [weak self] in
                        self?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            },
                       completion: nil
        )
    }
}
