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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSetup()
        self.setUpText()
        self.setUpColor()
        self.setUpFont()
        
    }
    
    //MARK:-  Helper methods
    
    private func doInitialSetup() {
        self.seeRatesButton.layer.cornerRadius = 5.0
    }
    
    private func setUpText() {
        self.seeRatesButton.setTitle(LocalizedString.SeeRates.localized, for: .normal)
        self.contactUsLabel.text = LocalizedString.ContactUsAertrip.localized
        self.licenseLabel.text = LocalizedString.CopyrightAertrip.localized
    }
    
    private func setUpColor() {
        self.seeRatesButton.titleLabel?.textColor = AppColors.themeWhite
        self.contactUsLabel.textColor = AppColors.themeGray40
        self.licenseLabel.textColor = AppColors.themeGray40
    }
    
    private func setUpFont() {
        self.seeRatesButton.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        self.contactUsLabel.font = AppFonts.Regular.withSize(14.0)
        self.licenseLabel.font = AppFonts.Regular.withSize(14.0)
    }

}
