//
//  BlurView.swift
//  AERTRIP
//
//  Created by Admin on 15/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class BlurView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addBlurEffect(style: .prominent, alpha: 1.0)
        self.backgroundColor = .clear
        //AppColors.themeWhite.withAlphaComponent(0.85)
    }
    

}
