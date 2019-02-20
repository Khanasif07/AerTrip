//
//  CustomMarker.swift
//  AERTRIP
//
//  Created by apple on 18/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class CustomMarker: UIView {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceView: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        doInitialSetup()
    }
    
    class func instanceFromNib() -> CustomMarker {
        return UINib(nibName: "CustomMarker", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CustomMarker
    }
    
    
    func doInitialSetup() {
        priceView.layer.cornerRadius = 8.0
        priceView.layer.borderColor = AppColors.themeGreen.cgColor
        priceView.layer.borderWidth = 1.0
        priceLabel.font = AppFonts.SemiBold.withSize(16.0)
        priceLabel.textColor = AppColors.themeGreen
    }
}
