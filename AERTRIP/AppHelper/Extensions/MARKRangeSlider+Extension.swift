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
        self.trackImage = UIImage(named: "greyColorTrack")
        self.leftThumbImage = UIImage(named: "sliderHandle")
        self.rightThumbImage = UIImage(named: "sliderHandle")
        self.rangeImage = UIImage(named: "greenBlueRangeImage")
    }
}

