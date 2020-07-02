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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        mealTitleLabel.font = AppFonts.Regular.withSize(18)
        mealForLabel.font = AppFonts.Regular.withSize(14)
        mealAutoSelectedForLabel.font = AppFonts.Regular.withSize(12)
        priceLabel.font = AppFonts.Regular.withSize(18)
        quantityLabel.font = AppFonts.SemiBold.withSize(16)

        quantityLabel.textColor = AppColors.themeGreen
        mealForLabel.textColor = AppColors.themeGray40
        mealAutoSelectedForLabel.textColor = AppColors.themeGray60
        priceLabel.textColor = AppColors.themeGray40
        autoSelectionBackView.roundedCorners(cornerRadius: 3)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     func populateData(data : AddonsDataCustom, index : Int){
        let price = "₹ \(data.price)"
        self.priceLabel.text = price
        self.priceLabelWidth.constant = price.getTextWidth(height: 21, font: AppFonts.Regular.withSize(18))
        self.mealTitleLabel.text = data.ssrName?.name
        
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
    
    func populateData(data : Addons, index : Int){
        let price = "₹ \(data.salePrice)"
        self.priceLabel.text = price
        self.priceLabelWidth.constant = price.getTextWidth(height: 21, font: AppFonts.Regular.withSize(18))
        self.mealTitleLabel.text = data.serviceName
        
        if data.mealsSelectedFor.isEmpty {
            self.mealForLabel.text = ""
            self.mealForLabelTop.constant = 0
            self.quantityLabel.isHidden = true
        }else{
            self.mealForLabelTop.constant = 2
            let allNamesArray = data.mealsSelectedFor.map { (contact) -> String in
                return contact.firstName
            }
            let conaSaperatedNames = allNamesArray.joined(separator: ", ")
            self.mealForLabel.text = "For \(conaSaperatedNames)"
            self.quantityLabel.text = "X\(data.mealsSelectedFor.count)"
            self.quantityLabel.isHidden = false
        }
        
        if index == 3 {
            self.mealAutoSelectedForLabel.text = "Auto Selected for DEL → HYD"
               self.mealAutoSelectedTop.constant = 11
               autoSelectionBackView.isHidden = false
            }else if index == 4 {

                           self.mealAutoSelectedForLabel.text = ""
   
                       self.mealAutoSelectedTop.constant = 0
                       autoSelectionBackView.isHidden = true
        }else {
            
                     self.mealAutoSelectedForLabel.text = ""
                      self.mealAutoSelectedTop.constant = 0
                      autoSelectionBackView.isHidden = true
        }
        
    }
    
}
