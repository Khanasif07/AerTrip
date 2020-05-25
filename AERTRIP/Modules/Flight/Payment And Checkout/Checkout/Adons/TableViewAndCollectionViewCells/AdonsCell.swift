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
        descriptionLabel.font = AppFonts.Regular.withSize(14)
        complementLabel.font = AppFonts.Regular.withSize(12)
        
        headingLabel.textColor = UIColor.black
        descriptionLabel.textColor = AppColors.themeGray60
        complementLabel.textColor = AppColors.themeGreen

//        complementLabel.setBorder(borderWidth: 1, borderColor: AppColors.themeGreen)
//        complementLabel.roundedCorners(cornerRadius: 3)
        
    complementBackView.setBorder(borderWidth: 1, borderColor: AppColors.themeGreen)
    complementBackView.roundedCorners(cornerRadius: 3)

//        complementBackView.isHidden = true
        
//        complementLabel
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    func populateData(type : AdonsVM.AdonsType){
        
        switch type {
        case .meals:
            self.headingLabel.text = LocalizedString.Meals.localized
            self.addOnImageView.image = #imageLiteral(resourceName: "meals")

        case .baggage:
            self.headingLabel.text = LocalizedString.Baggage.localized
            
            let heading = "\(LocalizedString.Baggage.localized) 25, 15, 10, 5… kgs jhgghjg jhkhkjhkhkhkjhkjhkhkh  kjhjkh"
            self.addOnImageView.image = #imageLiteral(resourceName: "baggage")
        self.headingLabel.attributedText = heading.attributeStringWithColors(subString: LocalizedString.Baggage.localized, strClr: AppColors.themeGreen, substrClr: UIColor.black, strFont: AppFonts.SemiBold.withSize(16), subStrFont: AppFonts.SemiBold.withSize(18))
            
        case .seat:
            self.headingLabel.text = LocalizedString.Seat.localized
            self.addOnImageView.image = #imageLiteral(resourceName: "seats")

        case .otheres:
            self.headingLabel.text = LocalizedString.Others.localized
            self.addOnImageView.image = #imageLiteral(resourceName: "others")

        }
    }
    
}
