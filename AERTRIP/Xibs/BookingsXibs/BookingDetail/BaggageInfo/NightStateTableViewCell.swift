//
//  NightStateTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class NightStateTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
 
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var topBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.topBackgroundView.layer.cornerRadius = 12.0
        self.topBackgroundView.layer.borderWidth = 0.2
         self.topBackgroundView.layer.borderColor = AppColors.themeGray20.cgColor
        self.topBackgroundView.backgroundColor = AppColors.themeGray04
    }
    
    func configureCell(image:UIImage,status: String,time: String) {
        self.imageview.image = image
        self.titleLabel.attributedText = self.getAttributedBoldText(text: status, boldText: time)
    }
    
    
    // MARK: - Helper methods
    
    private func getAttributedBoldText(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), .foregroundColor: AppColors.themeBlack])
        
        attString.addAttributes([
            .font: AppFonts.SemiBold.withSize(14.0),
            .foregroundColor: AppColors.themeBlack
            ], range: (text as NSString).range(of: boldText))
        
        return attString
    }

    
    
}
