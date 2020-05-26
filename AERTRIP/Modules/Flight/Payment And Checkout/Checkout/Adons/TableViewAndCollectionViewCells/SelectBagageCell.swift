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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bagageTitleLabel.font = AppFonts.Regular.withSize(18)
        self.priceLabel.font = AppFonts.Regular.withSize(18)
        self.bagageTitleLabel.textColor = UIColor.black
        self.priceLabel.textColor = AppColors.themeGray40
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func populateData(index : Int){
        
        if index == 3{
            self.bagageTitleLabel.text = "10 Kgs - Pre Purchased Excess Baggage"
            self.priceLabel.text = "₹ 8,550"
        }else{
            self.bagageTitleLabel.text = "10 Kgs - Pre Purchased Excess Baggage 10 Kgs - Pre Purchased Excess Baggage"
            self.priceLabel.text = "₹ 807565"
        }
        
        self.layoutIfNeeded()
    }
    
}
