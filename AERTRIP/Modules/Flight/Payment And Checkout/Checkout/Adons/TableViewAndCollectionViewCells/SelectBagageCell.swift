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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bagageTitleLabel.font = AppFonts.Regular.withSize(18)
        selectedForLabel.font = AppFonts.Regular.withSize(14)
        self.priceLabel.font = AppFonts.Regular.withSize(18)
        quantityLabel.font = AppFonts.SemiBold.withSize(16)
        self.bagageTitleLabel.textColor = UIColor.black
        selectedForLabel.textColor = AppColors.themeGray40
        self.priceLabel.textColor = AppColors.themeGray40
        quantityLabel.textColor = AppColors.themeGreen
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populateData(data : AddonsDataCustom, index : Int){
        let price = "₹ \(data.price)"
        self.priceLabel.text = price
        self.priceLabelWidth.constant = price.getTextWidth(height: 21, font: AppFonts.Regular.withSize(18))
        self.bagageTitleLabel.text = data.ssrName?.name
        
        if data.bagageSelectedFor.isEmpty {
            self.selectedForLabel.text = ""
            //  self.mealForLabelTop.constant = 0
            self.quantityLabel.isHidden = true
        }else{
            // self.mealForLabelTop.constant = 2
            let allNamesArray = data.bagageSelectedFor.map { (contact) -> String in
                return contact.firstName
            }
            let conaSaperatedNames = allNamesArray.joined(separator: ", ")
            self.selectedForLabel.text = "For \(conaSaperatedNames)"
            self.quantityLabel.text = "X\(data.bagageSelectedFor.count)"
            self.quantityLabel.isHidden = false
        }
    }
    
    func populateOtherAdonsData(data : AddonsDataCustom, index : Int){
        let price = "₹ \(data.price)"
        self.priceLabel.text = price
        self.priceLabelWidth.constant = price.getTextWidth(height: 21, font: AppFonts.Regular.withSize(18))
        self.bagageTitleLabel.text = data.ssrName?.name
        
        if data.othersSelectedFor.isEmpty {
            self.selectedForLabel.text = ""
            //  self.mealForLabelTop.constant = 0
            self.quantityLabel.isHidden = true
        }else{
            // self.mealForLabelTop.constant = 2
            let allNamesArray = data.othersSelectedFor.map { (contact) -> String in
                return contact.firstName
            }
            let conaSaperatedNames = allNamesArray.joined(separator: ", ")
            self.selectedForLabel.text = "For \(conaSaperatedNames)"
            self.quantityLabel.text = "X\(data.othersSelectedFor.count)"
            self.quantityLabel.isHidden = false
        }
    }
}
