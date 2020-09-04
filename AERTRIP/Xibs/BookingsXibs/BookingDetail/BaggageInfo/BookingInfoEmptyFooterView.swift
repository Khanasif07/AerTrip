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
    
    @IBOutlet weak var footerBackgroundView: UIView!
    @IBOutlet weak var topDividerTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var topDividerView: ATDividerView!
    @IBOutlet weak var bottomDividerView: ATDividerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.footerBackgroundView.backgroundColor = AppColors.themeGray04
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.bottomDividerView.isHidden = false
    }
}
