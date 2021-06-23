//
//  BookingInfoHeaderView.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingInfoHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - IB Outlets
    @IBOutlet weak var tripRougteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.configCell()
    }
    
    func configCell(){
        self.contentView.backgroundColor = AppColors.themeBlack26
        // setup for Font and text Color
        self.tripRougteLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.tripRougteLabel.textColor = AppColors.themeBlack
    }
    


}
