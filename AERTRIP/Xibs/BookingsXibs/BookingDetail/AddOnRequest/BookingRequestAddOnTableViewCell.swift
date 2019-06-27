//
//  BookingRequestAddOnTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 16/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingRequestAddOnTableViewCell: ATTableViewCell {
    
    
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var dotImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var communicationData: BookingCaseHistory.Communication? {
        didSet {
            self.configureCell()
        }
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.timeStampLabel.font = AppFonts.Regular.withSize(16.0)
        self.messageLabel.font = AppFonts.Regular.withSize(16.0)
        
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.timeStampLabel.textColor = AppColors.themeGray140
       self.messageLabel.textColor = AppColors.themeGray140
    }
    
    private func configureCell() {
        self.messageImageView.image = #imageLiteral(resourceName: "bookingEmailIcon")
        self.dotImageView.image = nil// #imageLiteral(resourceName: "greenDot")
        self.titleLabel.text = communicationData?.subject ?? LocalizedString.dash.localized
        self.messageLabel.text = LocalizedString.dash.localized
        self.timeStampLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "\(communicationData?.commDate?.toString(dateFormat: "HH:mm aa") ?? "")  ", image: #imageLiteral(resourceName: "hotelCheckoutForwardArrow"), endText: "", font: AppFonts.Regular.withSize(16.0))
    }
}
