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
    
    func disable(forSeconds: TimeInterval) {
        self.isUserInteractionEnabled = false
        delay(seconds: forSeconds) { [weak self] in
            self?.isUserInteractionEnabled = true
        }
    }
    
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
    func addTargetForAction(_ target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
    
}

extension UIButton {
    func dumpingButtonSelectionAnimation() {
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: AppConstants.kAnimationDuration,
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
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration,
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
    
    func spaceInTextAndImageOfButton(spacing: CGFloat) {
        let insetAmount = spacing / 2
        let writingDirection = UIApplication.shared.userInterfaceLayoutDirection
        let factor: CGFloat = writingDirection == .leftToRight ? 1 : -1
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount*factor, bottom: 0, right: insetAmount*factor)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount*factor, bottom: 0, right: -insetAmount*factor)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
    
    func AttributedFontColorForText(text : String, textColor : UIColor, state: UIControl.State) {
        
        //self.textColor = UIColor.black
        guard let labelString = self.title(for: state) else { return }
        
        let main_string = labelString as NSString
        let range = main_string.range(of: text)
        
        var  attribute = NSMutableAttributedString.init(string: main_string as String)
        if let labelAttributedString = self.attributedTitle(for: state) {
            attribute = NSMutableAttributedString.init(attributedString: labelAttributedString)
        }
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor , range: range)
        // attribute.addAttribute(NSBaselineOffsetAttributeName, value: 0, range: range)
        self.setAttributedTitle(attribute, for: state)
    }
}

