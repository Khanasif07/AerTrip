//
//  AdonsCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 22/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class AdonsCell: UITableViewCell {

    @IBOutlet var addOnImageView : UIImageView!
    @IBOutlet var headingLabel : UILabel!
    @IBOutlet var descriptionLabel : UILabel!
    @IBOutlet var complementLabel : UILabel!
    @IBOutlet var arrowButton : UIButton!
    @IBOutlet weak var complementBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        headingLabel.font = AppFonts.SemiBold.withSize(18)
        descriptionLabel.font = AppFonts.Regular.withSize(isSEDevice ? 12 : 14)
        complementLabel.font = AppFonts.Regular.withSize(12)
        headingLabel.textColor = AppColors.themeBlack
        descriptionLabel.textColor = AppColors.themeGray60
        headingLabel.lineBreakMode = .byTruncatingMiddle
        complementLabel.textColor = AppColors.themeGreen
        complementBackView.setBorder(borderWidth: 1, borderColor: AppColors.themeGreen)
        complementBackView.roundedCorners(cornerRadius: 3)
        self.contentView.backgroundColor = AppColors.themeWhite
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func populateData(data : AdonsVM.AddonsData){
               self.complementLabel.text = data.shouldShowComp ? data.complementString : ""
               self.complementBackView.isHidden = !data.shouldShowComp

        switch data.addonsType {
               case .meals:
                   self.addOnImageView.image = AppImages.mealsAddon
                   self.headingLabel.text = data.heading
                self.headingLabel.attributedText = data.heading.attributeStringWithColors(subString: LocalizedString.Meals.localized, strClr: AppColors.themeGreen, substrClr: AppColors.themeBlack, strFont: AppFonts.SemiBold.withSize(16), subStrFont: AppFonts.SemiBold.withSize(18))
                self.descriptionLabel.attributedText = data.description

               case .baggage:
                   self.addOnImageView.image = AppImages.baggageAddon
                self.headingLabel.attributedText = data.heading.attributeStringWithColors(subString: LocalizedString.Baggage.localized, strClr: AppColors.themeGreen, substrClr: AppColors.themeBlack, strFont: AppFonts.SemiBold.withSize(16), subStrFont: AppFonts.SemiBold.withSize(18))
                   self.descriptionLabel.attributedText = data.description

               case .seat:
                   self.addOnImageView.image = AppImages.seatsAddon
                   self.headingLabel.text = data.heading
                    self.headingLabel.attributedText = data.heading.attributeStringWithColors(subString: LocalizedString.Seat.localized, strClr: AppColors.themeGreen, substrClr: AppColors.themeBlack, strFont: AppFonts.SemiBold.withSize(16), subStrFont: AppFonts.SemiBold.withSize(18))
                   self.descriptionLabel.attributedText = data.description
        
               case .otheres:
                   self.addOnImageView.image = AppImages.othersAddon
                   self.headingLabel.attributedText = data.heading.attributeStringWithColors(subString: LocalizedString.Other.localized, strClr: AppColors.themeGreen, substrClr: AppColors.themeBlack, strFont: AppFonts.SemiBold.withSize(16), subStrFont: AppFonts.SemiBold.withSize(18))
                   self.descriptionLabel.attributedText = data.description
               }
    }
    
    func populateData(type : AdonsVM.AdonsType, data : (heading : String,desc : String,complement : String, shouldShowComp : Bool)){
        
        self.headingLabel.text = data.heading
        self.descriptionLabel.text = data.desc
        self.complementLabel.text = data.shouldShowComp ? data.complement : ""
        self.complementBackView.isHidden = !data.shouldShowComp

        switch type {
        case .meals:
            self.addOnImageView.image = AppImages.mealsAddon
            
        case .baggage:
            self.addOnImageView.image = AppImages.baggageAddon
            let heading = "\(LocalizedString.Baggage.localized) 25, 15, 10, 5, 16, 34, 20 kg"
       
            self.headingLabel.attributedText = heading.attributeStringWithColors(subString: LocalizedString.Baggage.localized, strClr: AppColors.themeGreen, substrClr: UIColor.black, strFont: AppFonts.SemiBold.withSize(16), subStrFont: AppFonts.SemiBold.withSize(18))

        case .seat:
            self.addOnImageView.image = AppImages.seatsAddon
 
        case .otheres:
            self.addOnImageView.image = AppImages.othersAddon
        }

    }
    
}
