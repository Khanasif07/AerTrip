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
    
    @IBOutlet var airportCodeLabel: UILabel!
    @IBOutlet var imageViewCenterConstraint: NSLayoutConstraint!
    
    // MARK: - Override methods
    
    override func setupFonts() {
        self.airportCodeLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        self.phoneLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.airportCodeLabel.textColor = AppColors.themeGreen
        self.titleLabel.textColor = AppColors.themeBlack
        self.phoneLabel.textColor = AppColors.themeGray40
    }
    
    func configureCell(code: String = "", title: String, phoneLabel: String, cellType: CallCellType = .none, email: String = "") {
        self.airportCodeLabel.isHidden = true
        switch cellType {
        case .none:
            self.cellImageView.image = #imageLiteral(resourceName: "aertripGreenLogo")
            self.titleLabel.text = title
            self.phoneLabel.text = phoneLabel
        case .email:
            self.cellImageView.image = #imageLiteral(resourceName: "aertripGreenLogo")
            let fullText: String = title + "\n" + email
            self.titleLabel.attributedText = self.getAttributedBoldText(text: fullText, boldText: email)
            self.phoneLabel.text = phoneLabel
        case .airlines:
            if !code.isEmpty {
                let imageUrl = AppGlobals.shared.getAirlineCodeImageUrl(code: code)
                self.cellImageView.setImageWithUrl(imageUrl, placeholder: AppPlaceholderImage.default, showIndicator: true)
            }
            self.titleLabel.text = title
            self.phoneLabel.text = phoneLabel
        case .airports:
            self.airportCodeLabel.isHidden = false
            self.cellImageView.isHidden = true
            self.airportCodeLabel.text = code
            self.titleLabel.text = title
            self.phoneLabel.text = phoneLabel
        default:
            break
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
