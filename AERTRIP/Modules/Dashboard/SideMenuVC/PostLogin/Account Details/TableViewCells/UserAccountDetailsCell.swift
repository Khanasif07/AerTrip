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
    
    func populateData(type : AccountUpdationType, details : UserAccountDetail) {
        
        self.desctiptionLabel.text = " "
        
        switch type {
        
        case .pan:
            
            headingLabel.text = LocalizedString.PAN.localized
            desctiptionLabel.text = details.pan.isEmpty ? "-" : details.pan

        case .aadhar:
            headingLabel.text = LocalizedString.Aadhaar.localized
            desctiptionLabel.text = details.aadhar.isEmpty ? "-" : details.aadhar

        case .gSTIN:
            headingLabel.text = LocalizedString.GSTIN.localized
            desctiptionLabel.text = details.gst.isEmpty ? "-" : details.gst

        case .defaultRefundMode:
            headingLabel.text = LocalizedString.Default_Refund_Mode.localized
            desctiptionLabel.text = details.refundMode.lowercased() == LocalizedString.Wallet.localized.lowercased() ? LocalizedString.Wallet.localized : LocalizedString.Chosen_Mode_Of_Payment.localized
            
        case .billingName:
            headingLabel.text = LocalizedString.BillingName.localized
            desctiptionLabel.text = details.billingName.isEmpty ? "-" : details.billingName

        case .billingAddress:
            headingLabel.text = LocalizedString.BillingAddress.localized
            desctiptionLabel.text = details.billingAddressString.isEmpty ? "-" : details.billingAddressString

        }
        
        
    }
    
}
