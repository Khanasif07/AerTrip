//
//  TravellerListTableViewSectionView.swift
//  AERTRIP
//
//  Created by apple on 04/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TravellerListTableViewSectionView: UITableViewHeaderFooterView {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var topSepratorView: ATDividerView!
    @IBOutlet weak var bottomSepratorView: ATDividerView!
    @IBOutlet weak var containerView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        headerLabel.textColor = AppColors.blackAndThemeGray

    }
    func configureCell(_ title: String) {
        headerLabel.text = title.capitalizedFirst()
    }
    
    func clearDividerAndBackgroundColor() {
        topSepratorView.isHidden = true
        bottomSepratorView.isHidden = true
        containerView.backgroundColor = AppColors.themeWhite
    }
}
