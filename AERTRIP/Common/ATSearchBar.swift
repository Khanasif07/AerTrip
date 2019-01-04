//
//  ATSearchBar.swift
//  AERTRIP
//
//  Created by Admin on 03/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ATSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialSetup()
    }
    
    
    private func initialSetup() {
        self.backgroundImage = UIImage()
        
        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = AppColors.themeGray04
            textField.font = AppFonts.Regular.withSize(17.0)
            textField.tintColor = AppColors.themeGreen
        }
        
        self.placeholder = LocalizedString.searchHotelName.localized
    }
}
