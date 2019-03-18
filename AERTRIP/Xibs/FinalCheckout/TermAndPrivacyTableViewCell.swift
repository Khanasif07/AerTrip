//
//  TermAndPrivacyTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TermAndPrivacyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var termAndPrivacyLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSetup()
 
    }

    private func doInitialSetup() {
        let attributedString = NSMutableAttributedString(string: "By proceeding you agree to the Fare Rules, Privacy Policy and Terms of Use of Aertrip.\n\nYou will be re-directed to a Payment Gateway website and returned back on completing the payment transaction.", attributes: [
            .font: UIFont(name: "SourceSansPro-Regular", size: 14.0)!,
            .foregroundColor: UIColor.black
            ])
        attributedString.addAttributes([
            .font: AppFonts.SemiBold.withSize(14.0),
            .foregroundColor: AppColors.themeGreen
            ], range: NSRange(location: 31, length: 10))
        attributedString.addAttributes([
            .font: AppFonts.SemiBold.withSize(14.0),
            .foregroundColor: AppColors.themeGreen
            ], range: NSRange(location: 43, length: 14))
        attributedString.addAttributes([
            .font: AppFonts.SemiBold.withSize(14.0),
            .foregroundColor: AppColors.themeGreen
            ], range: NSRange(location: 62, length: 12))
        self.termAndPrivacyLabel.attributedText = attributedString
    }
   
    
}
