//
//  UserAccountDetailsCell.swift
//  AERTRIP
//
//  Created by Admin on 12/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

class UserAccountDetailsCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var desctiptionLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        desctiptionLabel.textColor = AppColors.themeGray40
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(type : AccountUpdationType) {
        
        self.desctiptionLabel.text = " "
        
        switch type {
        
        case .pan:
            
            headingLabel.text = LocalizedString.PAN.localized
            
        case .aadhar:
            headingLabel.text = LocalizedString.Aadhaar.localized

        case .gSTIN:
            headingLabel.text = LocalizedString.GSTIN.localized

        case .defaultRefundMode:
            headingLabel.text = LocalizedString.Default_Refund_Mode.localized

        case .billingName:
            headingLabel.text = LocalizedString.BillingName.localized

        case .billingAddress:
            headingLabel.text = LocalizedString.BillingAddress.localized

        }
        
        
    }
    
}
