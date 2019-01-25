//
//  ATDividerView.swift
//  AERTRIP
//
//  Created by Admin on 21/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

open class ATDividerView: UIView {
    
    init() {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: 1.0))
        self.initialSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetup()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: 1.0))
        
        self.initialSetup()
    }
    
    func initialSetup() {
        self.backgroundColor = AppColors.themeGray20        
    }
}
