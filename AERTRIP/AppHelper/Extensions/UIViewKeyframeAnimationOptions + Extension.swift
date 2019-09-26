//
//  UIViewKeyframeAnimationOptions + Extension.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/09/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation


extension UIView.KeyframeAnimationOptions {
    
    init(animationOptions: UIView.AnimationOptions) {
       rawValue = animationOptions.rawValue
    }
    
}
