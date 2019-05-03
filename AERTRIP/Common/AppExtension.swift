//
//  AppExtension.swift
//  AERTRIP
//
//  Created by Pramod Kumar on 04/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

extension UIView {
    
    func removeGredient() {
        if let layers = self.layer.sublayers {
            for layer in layers {
                if (layer.name ?? "") == "gradientLayer" {
                    layer.removeFromSuperlayer()
                    break
                }
            }
        }
    }
    
    func addGredient(isVertical: Bool = true, cornerRadius: CGFloat = 0.0, colors: [UIColor] = [AppColors.themeGreen, AppColors.shadowBlue]) {
        removeGredient()
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientLayer"
        gradientLayer.frame = self.bounds
        var cgColors = colors.map { (clr) -> CGColor in
            clr.cgColor
        }
        
        if isVertical {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        else {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            cgColors.reverse()
        }
        
//        gradientLayer.cornerRadius = cornerRadius
//        gradientLayer.masksToBounds = true
        
        gradientLayer.colors = cgColors
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addGradientWithColor(color: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color.cgColor, color.cgColor]
        gradient.opacity = 0.1
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addShadow(withColor color: UIColor = AppColors.themeGreen, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addDropShadow(withColor color: UIColor = AppColors.themeGreen) {
        layer.shadowRadius = 5.0
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        layer.shadowRadius = 5.0
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
    }
    
    func addCardShadow(withColor color: UIColor = AppColors.themeBlack) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
    }
    
    func addBlurEffect(backgroundColor: UIColor = AppColors.clear, style: UIBlurEffect.Style = UIBlurEffect.Style.light, alpha: CGFloat = 0.5) {
        
        let blurV = getBlurView()
        blurV.alpha = alpha
        blurV.backgroundColor = backgroundColor
        self.insertSubview(blurV, at: 0)
    }
    
    func getBlurView(style: UIBlurEffect.Style = UIBlurEffect.Style.light) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
}


extension UIView {
    private var shadowLayer: CAShapeLayer? {
        var temp: CAShapeLayer? = nil
        if let allLayers = self.layer.sublayers {
            for obj in allLayers {
                if let lay = obj as? CAShapeLayer, lay.name == "shadowWithCorner" {
                    temp = lay
                    break
                }
            }
        }
        return temp
    }
    
    func addShadow(cornerRadius: CGFloat, shadowColor: UIColor = .black, backgroundColor: UIColor = .white, offset: CGSize = CGSize(width: -1.0, height: 2.0)) {
        let newLayer: CAShapeLayer!
        if shadowLayer == nil {
            newLayer = CAShapeLayer()
            newLayer.name = "shadowWithCorner"
            layer.insertSublayer(newLayer, at: 0)
        }
        else {
            newLayer = shadowLayer
        }
        
        guard let _ = newLayer else {return}
        
        self.backgroundColor = UIColor.clear
        newLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        newLayer.fillColor = backgroundColor.cgColor
        newLayer.shadowColor = shadowColor.cgColor
        newLayer.shadowPath  = newLayer.path
        newLayer.shadowOffset = offset
        newLayer.shadowOpacity = 0.2
        newLayer.shadowRadius = 4
    }
}
