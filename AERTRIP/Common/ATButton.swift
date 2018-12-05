//
//  ATButton.swift
//  AERTRIP
//
//  Created by Admin on 04/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class ATButton: UIButton {
    
    var shadowLayer: CAShapeLayer!
    var gradientLayer: CAGradientLayer!
    
    var shadowColor: UIColor = .darkGray {
        didSet {
            self.layoutSubviews()
        }
    }
    
    var gradientColors: [UIColor] = [AppColors.shadowBlue, AppColors.themeGreen] {
        didSet {
            self.layoutSubviews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addRequiredAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addRequiredAction()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadowLayer()
        self.addGradientLayer()
    }
    
    private func addShadowLayer() {
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = shadowColor.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 7.0)
            shadowLayer.shadowOpacity = 0.4
            shadowLayer.shadowRadius = 5.0
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    private func addGradientLayer() {
        if gradientLayer == nil {
            
            gradientLayer = CAGradientLayer()
            
            gradientLayer.frame = self.bounds
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
            gradientLayer.cornerRadius = self.cornerRadius
            gradientLayer.masksToBounds = true
            
            gradientLayer.colors = gradientColors.map { (clr) -> CGColor in
                clr.cgColor
            }
            
            self.layer.insertSublayer(gradientLayer, at: 1)
        }
    }
    
    private func addRequiredAction() {
        self.addTarget(self, action: #selector(buttonPressed(_:)), for: UIControl.Event.touchDown)
        self.addTarget(self, action: #selector(buttonReleased(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        self.transform = CGAffineTransform.identity
    }
}

