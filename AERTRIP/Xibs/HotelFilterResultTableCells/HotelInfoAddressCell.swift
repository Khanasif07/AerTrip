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
    let overview = "With a stay at Le Sutra, you'll be centrally located in Mumbai, convenient to Lilavati Hospital and Mt. Mary Church. This spacing"
    
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
    }
    
    ///AttributeLabelSetup
    private func attributeLabelSetUp() {
        let attributedString = NSMutableAttributedString()
        let blackAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
        let blackAttributedString = NSAttributedString(string: self.overview, attributes: blackAttribute)
        let greenAtrribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeGreen]
        let greenAttributedString = NSAttributedString(string: " " + LocalizedString.More.localized, attributes: greenAtrribute)
        attributedString.append(blackAttributedString)
        attributedString.append(greenAttributedString)
        self.addressInfoTextView.attributedText = attributedString
    }

    
    internal func configureAddressCell() {
        self.addressLabel.text = LocalizedString.AddressSmallLaters.localized
        self.addressInfoTextView.attributedText = AppGlobals.shared.getTextWithImageWithLink(startText: address, startTextColor: AppColors.themeBlack, middleText: " " + LocalizedString.Maps.localized + " ", image: #imageLiteral(resourceName: "send_icon"), endText: "", endTextColor: AppColors.themeGreen, middleTextColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
    }
    
    internal func configureOverviewCell() {
        self.addressLabel.text = LocalizedString.Overview.localized
        self.attributeLabelSetUp()
    }
    
    
    
    //Mark:- IBActions
    //================
    @IBAction func mapButtonAction(_ sender: Any) {
        printDebug("maps")
    }
    
}
