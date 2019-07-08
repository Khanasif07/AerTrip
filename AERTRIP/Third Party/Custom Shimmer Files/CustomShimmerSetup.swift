//
//  CustomShimmerSetup.swift
//  ShimmerDemo
//
//  Created by RAJAN SINGH on 04/01/19.
//  Copyright © 2019 RAJAN. All rights reserved.
//

import UIKit

//SHIMMER ON UIVIEW
class ViewShimmer: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureShimmer()
    }
}

//SHIMMER ON IMAGE VIEW
class ImageViewShimmer: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureShimmer()
    }
}

//SHIMMER ON UIBUTTON
class ButtonShimmer: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureShimmer()
    }
}

//SHIMMER ON LABEL
class LabelShimmer: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureShimmer()
    }
}


extension UIView {
    
    //SHIMMER CONFIGURATION
    fileprivate func configureShimmer() {
        //SET BACKGROUND IMAGE FOR SELECTED VIEW
        //backgroundColor = UIColor(white: 0, alpha: 0.1)
        self.startShimmer()
    }
    
    //START SHIMMER
    func startShimmer() {
        
        let lightColor = UIColor(white: 0, alpha: 0.1).cgColor
        let darkColor = UIColor.black.cgColor
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [darkColor, lightColor, darkColor]
        gradient.frame = CGRect(x: -bounds.size.width, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint   = CGPoint(x: 1.0, y: 0.525)
        gradient.locations  = [0.4, 0.5, 0.6]
        
        layer.mask = gradient
        
        let animation: CABasicAnimation = CABasicAnimation.init(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue   = [0.8, 0.9, 1.0]
        
        animation.duration = 2.0
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        
        gradient.add(animation, forKey: "shimmer")
        
    }
    
    //STOP SHIMMER
    func stopShimmer() {
        layer.mask = nil
    }
}
