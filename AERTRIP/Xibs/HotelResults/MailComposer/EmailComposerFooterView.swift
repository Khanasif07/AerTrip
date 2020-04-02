//
//  EmailComposerFooterView.swift
//  AERTRIP
//
//  Created by apple on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class EmailComposerFooterView: UIView {
    @IBOutlet weak var seeRatesButton: ATButton!
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var socialIconStackView: UIStackView!
    @IBOutlet weak var licenseLabel: UILabel!
    
    class func instanceFromNib() -> EmailComposerFooterView {
        return UINib(nibName: "EmailComposerFooterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmailComposerFooterView
    }
    
    // MARK: - View LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSetup()
        self.setUpText()
        self.setUpColor()
        self.setUpFont()
    }
    
    // MARK: -  Helper methods
    
    private func doInitialSetup() {
        self.seeRatesButton.layer.cornerRadius = 5.0
        self.seeRatesButton.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.seeRatesButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
        self.seeRatesButton.isUserInteractionEnabled = false
    }
    
    private func setUpText() {
        self.seeRatesButton.setTitle(LocalizedString.SeeRates.localized, for: .normal)
        self.contactUsLabel.text = LocalizedString.ContactUsAertrip.localized
        self.licenseLabel.attributedText = self.getAttributeBoldTextForHotelName(text: AppConstants.kCopyrightSymbol + LocalizedString.CopyrightAertrip.localized, boldText: AppConstants.kCopyrightSymbol)
    }
    
    private func setUpColor() {
        self.seeRatesButton.titleLabel?.textColor = AppColors.themeWhite
        self.contactUsLabel.textColor = AppColors.themeGray40
        self.licenseLabel.textColor = AppColors.themeGray40
    }
    
    private func setUpFont() {
        self.seeRatesButton.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        self.contactUsLabel.font = AppFonts.Regular.withSize(14.0)
//        self.licenseLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    private func getAttributeBoldTextForHotelName(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), .foregroundColor: UIColor.black])
        
        attString.addAttributes([
            .font: AppFonts.Regular.withSize(18.0),
            .foregroundColor: AppColors.themeGreen
        ], range: (text as NSString).range(of: boldText))
        return attString
    }
}
