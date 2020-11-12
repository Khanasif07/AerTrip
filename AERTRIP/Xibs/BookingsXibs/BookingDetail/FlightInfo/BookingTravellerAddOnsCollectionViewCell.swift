//
//  BookingTravellerAddOnsCollectionViewCell.swift
//  AERTRIP
//
//  Created by apple on 11/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingTravellerAddOnsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpColor()
    }
    
    private func setUpFont() {
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.titleValueLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    private func setUpColor() {
        self.titleLabel.textColor = AppColors.themeGray40
        self.titleValueLabel.textColor = AppColors.textFieldTextColor51
    }
    
    func configure(title: String, detail: String) {
        self.titleLabel.text = title
        if title == AppConstants.PNR && detail.count > 1 {
            let pnrData = detail.split(separator: "-")
            var pnrNumber = ""
            var status = ""
            if pnrData.count > 1 {
                pnrNumber = "\(pnrData[0])"
                status = "(\(pnrData[1].capitalized))"
            } else {
                pnrNumber = "\(pnrData[0])"
            }
            self.titleValueLabel.attributedText = getAttributedBoldText(text: pnrNumber + " \(status)", boldText: "\(status)")
        } else {
            self.titleValueLabel.text = detail
         }
    }
    
    
    //MARK: - Helper methods
    // Pass complete string in text and bold text
    private func getAttributedBoldText(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), .foregroundColor: AppColors.themeBlack])
        
        attString.addAttributes([
            .font: AppFonts.Regular.withSize(18.0),
            .foregroundColor: boldText == AppConstants.kBooked ?  AppColors.themeGreen : AppColors.themeBlack
            ], range:(text as NSString).range(of: boldText))
        return attString
    }
}
