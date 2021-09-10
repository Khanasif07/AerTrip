//
//  GSTINListCell.swift
//  Aertrip
//
//  Created by Apple  on 14.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class GSTINListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFontAndColor()
    }
    


    func setupFontAndColor(){
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.font = AppFonts.Regular.withSize(18)
        self.subtitleLabel.textColor = AppColors.themeGray60
        self.subtitleLabel.font = AppFonts.Regular.withSize(14)
        self.editButton.setTitle("Edit", for: .normal)
        self.editButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.editButton.titleLabel?.font = AppFonts.Regular.withSize(14)
        self.selectionStyle = .none
    }
    
    func configureCell(with gSTIN: GSTINModel){
        self.titleLabel.text = gSTIN.billingName
        self.subtitleLabel.text = "\(gSTIN.companyName)\nGSTIN - \(gSTIN.GSTInNo)"
    }
    
}
