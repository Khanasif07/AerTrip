//
//  HCBookingDetailsTableViewHeaderFooterView.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCBookingDetailsTableViewHeaderFooterView: UITableViewHeaderFooterView {

    //Mark:- Variables
    //================
    
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var bookingDetailsLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    //Mark:- Lifecycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        //Font
        self.bookingDetailsLabel.font = AppFonts.Regular.withSize(14.0)
        //Text
        self.bookingDetailsLabel.text = LocalizedString.BookingDetails.localized
        //Color
        self.bookingDetailsLabel.textColor = AppColors.themeGray60
    }
}
