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
    case webcheckin
}

class BookingCallTableViewCell: ATTableViewCell {
    // MARK: - IBOutlet
    
    @IBOutlet weak var dividerViewLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var airportCodeLabel: UILabel!
    @IBOutlet weak var imageViewCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    // MARK: - Override methods
    @IBOutlet weak var imageViewTrailingConstraing: NSLayoutConstraint!
    @IBOutlet weak var airportCodeLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageView: UIImageView!
    
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
        self.rightImageView.image = nil
        self.airportCodeLabel.isHidden = true
        switch cellType {
        case .none:
            self.cellImageView.image = AppImages.upwardAertripLogo//#imageLiteral(resourceName: "aertripGreenLogo")
            self.titleLabel.text = title
            self.phoneLabel.text = phoneLabel.count == 14 ?  phoneLabel.prefix(9) + " " + phoneLabel.suffix(5) : phoneLabel
        case .email:
            self.cellImageView.image = AppImages.headPhoneIcon
            let fullText: String = title + "\n" + email
            self.titleLabel.numberOfLines = 2
            self.titleLabel.attributedText = self.getAttributedBoldText(text: fullText, boldText: email)
            self.phoneLabel.text = phoneLabel.count == 14 ?  phoneLabel.prefix(9) + " " + phoneLabel.suffix(5) : phoneLabel
        case .airlines:
            if !code.isEmpty {
                let imageUrl = AppGlobals.shared.getAirlineCodeImageUrl(code: code)
                self.cellImageView.setImageWithUrl(imageUrl, placeholder: AppPlaceholderImage.default, showIndicator: true)
            }
            self.titleLabel.text = title
            self.phoneLabel.text = phoneLabel.count == 14 ?  phoneLabel.prefix(9) + " " + phoneLabel.suffix(5) : phoneLabel
        case .airports:
            self.airportCodeLabel.isHidden = false
            self.cellImageView.isHidden = true
            self.airportCodeLabel.text = code
            self.titleLabel.text = title
            self.phoneLabel.text = phoneLabel.count == 14 ?  phoneLabel.prefix(9) + " " + phoneLabel.suffix(5) : phoneLabel
            
        case .webcheckin:
            if !code.isEmpty {
                let imageUrl = AppGlobals.shared.getAirlineCodeImageUrl(code: code)
                self.cellImageView.setImageWithUrl(imageUrl, placeholder: AppPlaceholderImage.default, showIndicator: true)
            }
            self.titleLabel.text = title
            self.phoneLabel.text = ""
            
            self.rightImageView.image = UIImage(named: "send_icon")?.withRenderingMode(.alwaysTemplate)
            self.rightImageView.tintColor = AppColors.themeGray60
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
