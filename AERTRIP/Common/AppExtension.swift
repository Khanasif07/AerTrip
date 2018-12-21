//
//  AppExtension.swift
//  AERTRIP
//
//  Created by Pramod Kumar on 04/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

extension UIView {
    
    func addGredient(isVertical: Bool = true, cornerRadius: CGFloat = 0.0, colors: [UIColor] = [AppColors.themeGreen, AppColors.shadowBlue]) {
        
        let gradientLayer = CAGradientLayer()
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
}
