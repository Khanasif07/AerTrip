//
//  SelectBagageCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SelectBagageCell: UITableViewCell {
    
    @IBOutlet weak var bagageTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var selectedForLabel: UILabel!
    @IBOutlet weak var priceLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var autoSelectedForLabel: UILabel!
    @IBOutlet weak var autoSelectedForBackView: UIView!
    @IBOutlet weak var autoSelectedForTop: NSLayoutConstraint!
    @IBOutlet weak var bottomSeprator: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabelTop: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bagageTitleLabel.font = AppFonts.Regular.withSize(18)
        selectedForLabel.font = AppFonts.Regular.withSize(14)
        self.priceLabel.font = AppFonts.Regular.withSize(18)
        quantityLabel.font = AppFonts.SemiBold.withSize(16)
        self.descriptionLabel.font = AppFonts.Regular.withSize(14)
        
        self.descriptionLabel.textColor = AppColors.themeGray40
        self.bagageTitleLabel.textColor = AppColors.themeBlack
        selectedForLabel.textColor = AppColors.themeGray40
        self.priceLabel.textColor = AppColors.themeGray40
        quantityLabel.textColor = AppColors.themeGreen
        self.selectionStyle = .none
        self.bagageTitleLabel.backgroundColor = AppColors.clear
        self.priceLabel.backgroundColor = AppColors.clear
        self.contentView.backgroundColor = AppColors.themeBlack26
        
        self.autoSelectedForBackView.backgroundColor = AppColors.lightYellowAndGoldenGray
        self.autoSelectedForLabel.textColor = AppColors.grayWhite
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.autoSelectedForBackView.roundedCorners(cornerRadius: 3)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populateData(data : AddonsDataCustom, index : Int){
//        let price = "₹ \(data.price.commaSeprated)"
        self.priceLabel.attributedText = data.price.getConvertedAmount(using: AppFonts.Regular.withSize(18))
       
        self.priceLabelWidth.constant = self.priceLabel.attributedText?.string.getTextWidth(height: 21, font: AppFonts.Regular.withSize(18)) ?? 0
      
        self.bagageTitleLabel.text = data.ssrName?.name
        
        
        if data.addonDescription.isEmpty {
            self.descriptionLabel.text = ""
            self.descriptionLabelTop.constant = 0
            self.descriptionLabel.isHidden = true
        } else {
            self.descriptionLabel.text = data.addonDescription
            self.descriptionLabelTop.constant = 2
            self.descriptionLabel.isHidden = false
        }
        
        
        if data.bagageSelectedFor.isEmpty {
            self.selectedForLabel.text = ""
            self.quantityLabel.isHidden = true
        } else if data.bagageSelectedFor.count == 2{
            
            let allNamesArray = data.bagageSelectedFor.map { (contact) -> String in
                       return contact.firstName
                   }
                   let conaSaperatedNames = allNamesArray.joined(separator: " and ")
                   self.selectedForLabel.text = "For \(conaSaperatedNames)"
            self.selectedForLabel.attributedText = "For \(conaSaperatedNames)".attributeStringWithColors(subString: ["For", "and"], strClr: AppColors.themeGreen, substrClr: AppColors.themeGray40, strFont: AppFonts.SemiBold.withSize(14), subStrFont: AppFonts.Regular.withSize(14))

                   self.quantityLabel.text = "X\(data.bagageSelectedFor.count)"
                   self.quantityLabel.isHidden = false
            
        }else{
            let allNamesArray = data.bagageSelectedFor.map { (contact) -> String in
                return contact.firstName
            }
            let conaSaperatedNames = allNamesArray.joined(separator: ", ").replacingLastOccurrenceOfString(", ", with: " and ", caseInsensitive: true)
            self.selectedForLabel.text = "For \(conaSaperatedNames)"
            self.selectedForLabel.attributedText = "For \(conaSaperatedNames)".attributeStringWithColors(subString: ["For", "and"], strClr: AppColors.themeGreen, substrClr: AppColors.themeGray40, strFont: AppFonts.SemiBold.withSize(14), subStrFont: AppFonts.Regular.withSize(14))
            self.quantityLabel.text = "X\(data.bagageSelectedFor.count)"
            self.quantityLabel.isHidden = false
        }
        
        if data.autoSelectedFor.isEmpty {
             self.autoSelectedForLabel.text = ""
             self.autoSelectedForTop.constant = 0
             self.autoSelectedForBackView.isHidden = true
        }else{
             self.autoSelectedForLabel.text = data.autoSelectedFor
             self.autoSelectedForTop.constant = 11
             self.autoSelectedForBackView.isHidden = false
        }
    }
    
    func populateOtherAdonsData(data : AddonsDataCustom, index : Int){
//        let price = "₹ \(data.price.commaSeprated)"
//        self.priceLabel.text = price
      
        self.priceLabel.attributedText = data.price.getConvertedAmount(using: AppFonts.Regular.withSize(18))

        self.priceLabelWidth.constant = self.priceLabel.attributedText?.string.getTextWidth(height: 21, font: AppFonts.Regular.withSize(18)) ?? 0
        
        self.bagageTitleLabel.text = data.ssrName?.name
        
        if data.addonDescription.isEmpty {
            self.descriptionLabel.text = ""
            self.descriptionLabelTop.constant = 0
            self.descriptionLabel.isHidden = true
        } else {
            self.descriptionLabel.text = data.addonDescription
            self.descriptionLabelTop.constant = 2
            self.descriptionLabel.isHidden = false
        }
        
        if data.othersSelectedFor.isEmpty {
            self.selectedForLabel.text = ""
            //  self.mealForLabelTop.constant = 0
            self.quantityLabel.isHidden = true
        } else if data.bagageSelectedFor.count == 2{
         
            let allNamesArray = data.othersSelectedFor.map { (contact) -> String in
                return contact.firstName
            }
            let conaSaperatedNames = allNamesArray.joined(separator: " and ")
                   self.selectedForLabel.text = "For \(conaSaperatedNames)"
            self.selectedForLabel.attributedText = "For \(conaSaperatedNames)".attributeStringWithColors(subString: ["For", "and"], strClr: AppColors.themeGreen, substrClr: AppColors.themeGray40, strFont: AppFonts.SemiBold.withSize(14), subStrFont: AppFonts.Regular.withSize(14))

            self.quantityLabel.text = "X\(data.othersSelectedFor.count)"
            self.quantityLabel.isHidden = false
            
        }else{
            let allNamesArray = data.othersSelectedFor.map { (contact) -> String in
                return contact.firstName
            }
            let conaSaperatedNames = allNamesArray.joined(separator: ", ").replacingLastOccurrenceOfString(", ", with: " and ", caseInsensitive: true)
            self.selectedForLabel.text = "For \(conaSaperatedNames)"
            self.selectedForLabel.attributedText = "For \(conaSaperatedNames)".attributeStringWithColors(subString: ["For", "and"], strClr: AppColors.themeGreen, substrClr: AppColors.themeGray40, strFont: AppFonts.SemiBold.withSize(14), subStrFont: AppFonts.Regular.withSize(14))

            self.quantityLabel.text = "X\(data.othersSelectedFor.count)"
            self.quantityLabel.isHidden = false
        }
        
        if data.autoSelectedFor.isEmpty {
             self.autoSelectedForLabel.text = ""
             self.autoSelectedForTop.constant = 0
             self.autoSelectedForBackView.isHidden = true
        }else{
             self.autoSelectedForLabel.text = data.autoSelectedFor
             self.autoSelectedForTop.constant = 11
             self.autoSelectedForBackView.isHidden = false
        }
    }
}
