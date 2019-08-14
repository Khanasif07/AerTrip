//
//  ATCardView.swift
//
//
//  Created by Pramod Kumar on 08/02/19.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class ATCardView: UIView {

    var shadowRadius: CGFloat = 5
    var myCornerRadius: CGFloat = 10
    var shadowOffsetWidth: Int = 0
    var shadowOffsetHeight: Int = 0
    var shadowColor: UIColor = AppColors.themeBlack
    var shadowOpacity: Float = 0.4

    override func layoutSubviews() {
        super.layoutSubviews()
        
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowRadius = shadowRadius
        layer.cornerRadius = myCornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = nil
    }
}
