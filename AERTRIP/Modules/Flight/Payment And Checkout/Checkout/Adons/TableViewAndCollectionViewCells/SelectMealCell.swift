//
//  SelectMealCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SelectMealCell: UITableViewCell {

    @IBOutlet weak var mealTitleLabel: UILabel!
    @IBOutlet weak var mealForLabel: UILabel!
    @IBOutlet weak var mealAutoSelectedForLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var autoSelectionBackView: UIView!
    @IBOutlet weak var mealForLabelTop: NSLayoutConstraint!
    @IBOutlet weak var mealAutoSelectedTop: NSLayoutConstraint!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabelTop: NSLayoutConstraint!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        mealTitleLabel.font = AppFonts.Regular.withSize(18)
        mealForLabel.font = AppFonts.Regular.withSize(14)
        mealAutoSelectedForLabel.font = AppFonts.Regular.withSize(12)
        priceLabel.font = AppFonts.Regular.withSize(18)
        quantityLabel.font = AppFonts.SemiBold.withSize(16)
        descriptionLabel.font = AppFonts.Regular.withSize(14)
        
        descriptionLabel.textColor = AppColors.themeGray40
        quantityLabel.textColor = AppColors.themeGreen
        mealForLabel.textColor = AppColors.themeGray40
        mealAutoSelectedForLabel.textColor = AppColors.themeGray60
        priceLabel.textColor = AppColors.themeGray40
        priceLabel.backgroundColor = AppColors.clear
        mealTitleLabel.textColor = AppColors.themeBlack
        mealTitleLabel.backgroundColor = AppColors.clear
        self.contentView.backgroundColor = AppColors.themeBlack26
        self.autoSelectionBackView.backgroundColor = AppColors.lightYellowAndGoldenGray
        self.mealAutoSelectedForLabel.textColor = AppColors.grayWhite

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        autoSelectionBackView.roundedCorners(cornerRadius: 3)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     func populateData(data : AddonsDataCustom, index : Int){
//        let price = "₹ \(data.price.commaSeprated)"
//        self.priceLabel.text = price
        
       let priceAttrString = data.price.getConvertedAmount(using: AppFonts.Regular.withSize(18))
        
        self.priceLabel.attributedText = priceAttrString
        
        self.priceLabelWidth.constant = priceAttrString.string.getTextWidth(height: 21, font: AppFonts.Regular.withSize(18))
        
        self.mealTitleLabel.text = data.ssrName?.name
                
        if data.addonDescription.isEmpty {
            self.descriptionLabel.text = ""
            self.descriptionLabelTop.constant = 0
        } else{
            self.descriptionLabel.text = data.addonDescription
            self.descriptionLabelTop.constant = 2
        }
        
        if data.mealsSelectedFor.isEmpty {
               self.mealForLabel.text = ""
               self.mealForLabelTop.constant = 0
               self.quantityLabel.isHidden = true
        } else if data.mealsSelectedFor.count == 2 {
            
            self.mealForLabelTop.constant = 2
            let allNamesArray = data.mealsSelectedFor.map { (contact) -> String in
                return contact.firstName
             }
            let conaSaperatedNames = allNamesArray.joined(separator: " and ")
            self.quantityLabel.text = "X\(data.mealsSelectedFor.count)"
            self.quantityLabel.isHidden = false
            self.mealForLabel.text = "For \(conaSaperatedNames)"
                      
            self.mealForLabel.attributedText = "For \(conaSaperatedNames)".attributeStringWithColors(subString: ["For", "and"], strClr: AppColors.themeGreen, substrClr: AppColors.themeGray40, strFont: AppFonts.SemiBold.withSize(14), subStrFont: AppFonts.Regular.withSize(14))
            
        }else{
               self.mealForLabelTop.constant = 2
               let allNamesArray = data.mealsSelectedFor.map { (contact) -> String in
                   return contact.firstName
               }
               let conaSaperatedNames = allNamesArray.joined(separator: ", ").replacingLastOccurrenceOfString(", ", with: " and ", caseInsensitive: true)
               self.quantityLabel.text = "X\(data.mealsSelectedFor.count)"
               self.quantityLabel.isHidden = false
            self.mealForLabel.text = "For \(conaSaperatedNames)"
            
            self.mealForLabel.attributedText = "For \(conaSaperatedNames)".attributeStringWithColors(subString: ["For", "and"], strClr: AppColors.themeGreen, substrClr: AppColors.themeGray40, strFont: AppFonts.SemiBold.withSize(14), subStrFont: AppFonts.Regular.withSize(14))
            
           }
        
        if data.autoSelectedFor.isEmpty {
             self.mealAutoSelectedForLabel.text = ""
             self.mealAutoSelectedTop.constant = 0
             self.autoSelectionBackView.isHidden = true
        }else{
             self.mealAutoSelectedForLabel.text = data.autoSelectedFor
             self.mealAutoSelectedTop.constant = 11
             self.autoSelectionBackView.isHidden = false
        }
        
    }
    
}
