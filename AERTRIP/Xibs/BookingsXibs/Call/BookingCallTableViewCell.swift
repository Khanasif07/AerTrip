//
//  BookingCallTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 20/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

enum CallCellType {
    case aertrip
    case airlines
    case airports
    case none
    case email
}

class BookingCallTableViewCell: ATTableViewCell {
    // MARK: - IBOutlet
    
    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var dividerView: ATDividerView!
    @IBOutlet var imageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var imageViewCenterConstraint: NSLayoutConstraint!
    
    // MARK: - Override methods
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        self.phoneLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.phoneLabel.textColor = AppColors.themeGray40
    }
    
    func configureCell(image: UIImage, title: String, phoneLabel: String, cellType: CallCellType = .none, email: String = "") {
        if cellType == .none {
            self.cellImageView.image = image
            self.titleLabel.text = title
            self.phoneLabel.text = phoneLabel
        } else {
            self.cellImageView.image = image
            let fullText: String = title + "\n" + email
            self.titleLabel.attributedText = self.getAttributedBoldText(text: fullText, boldText: email)
            self.phoneLabel.text = phoneLabel
        }
    }
    
    // MARK: - Helper methods
    
    private func getAttributedBoldText(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), .foregroundColor: AppColors.themeBlack])
        
        attString.addAttributes([
            .font: AppFonts.SemiBold.withSize(14.0),
            .foregroundColor: AppColors.themeGreen
        ], range: (text as NSString).range(of: boldText))
        
        return attString
    }
}
