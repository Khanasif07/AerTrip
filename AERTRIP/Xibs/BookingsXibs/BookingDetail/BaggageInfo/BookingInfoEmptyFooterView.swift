//
//  BookingInfoEmptyFooterView.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingInfoEmptyFooterView: UITableViewHeaderFooterView {
    // MARK: - IB Outlet
    
    @IBOutlet var footerBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.footerBackgroundView.backgroundColor = AppColors.themeGray04
    }
}
