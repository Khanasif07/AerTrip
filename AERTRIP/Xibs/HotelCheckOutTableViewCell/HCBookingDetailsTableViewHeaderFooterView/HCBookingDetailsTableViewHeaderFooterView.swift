//
//  HCBookingDetailsTableViewHeaderFooterView.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HCBookingDetailsTableViewHeaderFooterViewDelegate: class {
    func emailIternaryButtonTapped()
}

class HCBookingDetailsTableViewHeaderFooterView: UITableViewHeaderFooterView {

    //Mark:- Variables
    //================
    weak var delegate: HCBookingDetailsTableViewHeaderFooterViewDelegate?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var bookingDetailsLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailIternaryButton: UIButton!
    
    //Mark:- Lifecycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        
        containerView.backgroundColor = AppColors.themeWhite//AppColors.themeGray04
        
        //Font
        self.bookingDetailsLabel.font = AppFonts.Regular.withSize(14.0)
        //Text
        self.bookingDetailsLabel.text = LocalizedString.BookingDetails.localized
        //Color
        self.bookingDetailsLabel.textColor = AppColors.themeGray60
        
        self.emailIternaryButton.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        self.emailIternaryButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.emailIternaryButton.setTitle(LocalizedString.EmailItinerary.localized, for: .normal)

    }
    @IBAction func emailIternaryBtnTapped(_ sender: Any) {
        self.delegate?.emailIternaryButtonTapped()
    }
}
