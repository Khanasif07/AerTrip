//
//  MARKRangeSlider+Extension.swift
//  Aertrip
//
//  Created by  hrishikesh on 06/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit



extension MARKRangeSlider {
    
    func setupThemeImages() {
        self.disableOverlapping = true
        self.pushable = true
        self.trackImage = AppImages.greyColorTrack
        self.leftThumbImage = AppImages.sliderHandle
        self.rightThumbImage = AppImages.sliderHandle
        self.rangeImage = AppImages.greenBlueRangeImage
    }
}

