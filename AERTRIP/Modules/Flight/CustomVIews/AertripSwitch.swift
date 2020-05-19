//
//  AertripSwitch.swift
//  Aertrip
//
//  Created by Hrishikesh Devhare on 11/08/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class AertripSwitch: UIControl {

    public var onTintColor = UIColor.AertripColor {
        didSet {
            self.setupUI()
        }
    }
    public var offTintColor = UIColor.white {
        didSet {
            self.setupUI()
        }
    }
    public var cornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }
    public var thumbTintColor = UIColor.white {
        didSet {
            self.thumbView.backgroundColor = self.thumbTintColor
        }
    }
    

    public var thumbCornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }

    public var thumbSize = CGSize.zero {
        didSet {
            self.layoutSubviews()
        }
    }
    public var padding: CGFloat = 1.0 {
        didSet {
            self.layoutSubviews()
        }
    }

    public var isOn = true {
        didSet {
            self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
            self.thumbImageView.image = self.isOn ? UIImage(named:"pushpin") :  UIImage(named:"pushpin-gray")
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            
        }
    }
    public var animationDuration: Double = 0.5
    
    fileprivate var thumbView = UIView(frame: CGRect.zero)
    fileprivate var thumbImageView = UIImageView(frame: CGRect.zero)
    fileprivate var onPoint = CGPoint.zero
    fileprivate var offPoint = CGPoint.zero
    fileprivate var isAnimating = false
    
    private func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    
    func setupUI() {
        self.clear()
        self.clipsToBounds = false
        
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 4)
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
      
        self.thumbView.backgroundColor = .white
        self.thumbView.isUserInteractionEnabled = false
        self.addSubview(self.thumbView)
        
        
        self.thumbImageView.image = self.isOn ? UIImage(named:"pushpin") :  UIImage(named:"pushpin-gray")
        self.thumbImageView.frame = CGRect(x: 0 , y: 0 , width: 28.0, height: 28.0)
        self.thumbView.addSubview(self.thumbImageView)
        self.thumbView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        self.thumbView.layer.borderWidth = 0.5
        
        self.thumbView.layer.shadowOffset = CGSize(width: 0.0, height: 4)
        self.thumbView.layer.shadowRadius = 4.0
        self.thumbView.layer.shadowOpacity = 1.0
        self.thumbView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        
    }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isAnimating {
            self.layer.cornerRadius = 15.5
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            
            
            // thumb managment
            
            let thumbSize =  CGSize(width:28.0 , height: 28.0)
            let yPostition = CGFloat(1.5)
            
            self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yPostition)
            self.offPoint = CGPoint(x: self.padding, y: yPostition)
            
            self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
            
            self.thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
            
        }
        
    }
    
    private func animate() {
        self.isAnimating = true
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseOut,
                                                             UIView.AnimationOptions.beginFromCurrentState], animations: {
                                                                self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
                                                                
                                                                self.thumbImageView.image = self.isOn ? UIImage(named:"pushpin") :  UIImage(named:"pushpin-gray")
                                                                self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        }, completion: { _ in
            self.isAnimating = false
            self.sendActions(for: UIControl.Event.valueChanged)
        })
    }
    
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        self.isOn = !self.isOn
        self.animate()
        return true
    }

}
