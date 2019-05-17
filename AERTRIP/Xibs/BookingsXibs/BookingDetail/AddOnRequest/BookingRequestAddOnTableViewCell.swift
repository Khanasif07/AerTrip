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
    
    
    
    
    
    func configureCell() {
        self.messageImageView.image = UIImage(named: "emailIcon")
        self.dotImageView.image = #imageLiteral(resourceName: "greenDot")
        self.titleLabel.text = "Flight Addon request registered  - B/18-19/1040"
        self.messageLabel.text = "Suddenly today when I was online, but not using my Hotmail account, all the contents of…"
        self.timeStampLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "12:45 PM  ", image: UIImage(named: "hotelCheckoutForwardArrow")!, endText: "", font: AppFonts.Regular.withSize(16.0))
    }

   

   
    
}
