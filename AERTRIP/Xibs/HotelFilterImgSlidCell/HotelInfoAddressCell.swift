//
//  HotelInfoAddressCell.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelInfoAddressCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    let address = "Ramada Powai, Powai Saki Vihar Road Mumbai 400 087, Mumbai, India, Pin-code: 400 087"
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressInfoTextView: UITextView!
    @IBOutlet weak var deviderView: UIView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    //Mark:- Methods
    //==============
    private func initialSetUp() {
        self.addressInfoTextView.isEditable = false
        self.addressInfoTextView.textContainerInset = UIEdgeInsets.zero
        self.addressInfoTextView.textContainer.lineFragmentPadding = 0.0
        self.configureUI()
    }
    
    private func configureUI() {
        //Color
        self.addressLabel.textColor = AppColors.themeBlack
        self.deviderView.backgroundColor = AppColors.divider.color
        
        //Size
        self.addressLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.addressInfoTextView.font = AppFonts.Regular.withSize(18.0)
        
        //Text
        self.addressLabel.text = LocalizedString.AddressSmallLaters.localized
        self.addressInfoTextView.attributedText = AppGlobals.shared.getTextWithImageWithLink(startText: address, startTextColor: AppColors.themeBlack, middleText: " " + LocalizedString.Maps.localized + " ", image: #imageLiteral(resourceName: "send_icon"), endText: "", endTextColor: AppColors.themeGreen, middleTextColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
    }
    
    
    //Mark:- IBActions
    //================
    @IBAction func mapButtonAction(_ sender: Any) {
        printDebug("maps")
    }
    
}
