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
        
        headingLabel.lineBreakMode = .byTruncatingMiddle
        complementLabel.textColor = AppColors.themeGreen
        complementBackView.setBorder(borderWidth: 1, borderColor: AppColors.themeGreen)
        complementBackView.roundedCorners(cornerRadius: 3)

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    
    func populateData(data : AdonsVM.AddonsData){
               self.complementLabel.text = data.shouldShowComp ? data.complementString : ""
               self.complementBackView.isHidden = !data.shouldShowComp

        
        switch data.addonsType {
               case .meals:
                   self.addOnImageView.image = #imageLiteral(resourceName: "meals")
                   
//                   "\(data.heading) x\(AddonsDataStore.shared.)"
                   
                   self.headingLabel.text = data.heading
                   self.descriptionLabel.text = data.description

               case .baggage:
                   self.addOnImageView.image = #imageLiteral(resourceName: "baggage")
                   let heading = "\(LocalizedString.Baggage.localized) 25, 15, 10, 5, 16, 34, 20 kg"
              
                   self.headingLabel.attributedText = heading.attributeStringWithColors(subString: LocalizedString.Baggage.localized, strClr: AppColors.themeGreen, substrClr: UIColor.black, strFont: AppFonts.SemiBold.withSize(16), subStrFont: AppFonts.SemiBold.withSize(18))

               case .seat:
                   self.addOnImageView.image = #imageLiteral(resourceName: "seats")
                   self.headingLabel.text = data.heading
                   self.descriptionLabel.text = data.description
        
               case .otheres:
                   self.addOnImageView.image = #imageLiteral(resourceName: "others")
                   self.headingLabel.text = data.heading
                   self.descriptionLabel.text = data.description
               }
    }
    
    func populateData(type : AdonsVM.AdonsType, data : (heading : String,desc : String,complement : String, shouldShowComp : Bool)){
        
        self.headingLabel.text = data.heading
        self.descriptionLabel.text = data.desc
        self.complementLabel.text = data.shouldShowComp ? data.complement : ""
        self.complementBackView.isHidden = !data.shouldShowComp

        switch type {
        case .meals:
            self.addOnImageView.image = #imageLiteral(resourceName: "meals")
            
        case .baggage:
            self.addOnImageView.image = #imageLiteral(resourceName: "baggage")
            let heading = "\(LocalizedString.Baggage.localized) 25, 15, 10, 5, 16, 34, 20 kg"
       
            self.headingLabel.attributedText = heading.attributeStringWithColors(subString: LocalizedString.Baggage.localized, strClr: AppColors.themeGreen, substrClr: UIColor.black, strFont: AppFonts.SemiBold.withSize(16), subStrFont: AppFonts.SemiBold.withSize(18))

        case .seat:
            self.addOnImageView.image = #imageLiteral(resourceName: "seats")
 
        case .otheres:
            self.addOnImageView.image = #imageLiteral(resourceName: "others")
        }

    }
    
}
