//
//  SeeExampleHeaderView.swift
//  AERTRIP
//
//  Created by Apple  on 06.07.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import ActiveLabel

class SeeExampleHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: ActiveLabel!

    var hanler : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.linkSetupForTitleLabel(withLabel: self.titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bgView = UIView(frame: self.frame)
        bgView.backgroundColor = AppColors.themeWhite
        self.backgroundView = bgView
    }
    
    
    func linkSetupForTitleLabel(withLabel: ActiveLabel) {
        // Commenting fare rules text as It is not required now - discussed with Nitesh.
        
        // let fareDetails = ActiveType.custom(pattern: "\\s\(LocalizedString.FareRules.localized)\\b")
        let seeExample = ActiveType.custom(pattern: "\\sSee Example\\b")
        
        
        let allTypes: [ActiveType] = [seeExample]
        let textToDisplay = "Enter names and info as they appear on your Passport/Government issued ID. See Example"
        
        
        //  withLabel.enabledTypes = [fareDetails, privacyPolicy, termsOfUse]
        withLabel.textColor = AppColors.themeGray40
        withLabel.enabledTypes = allTypes
        withLabel.customize { label in
            label.font = AppFonts.Regular.withSize(14.0)
            label.text = textToDisplay
            for item in allTypes {
                label.customColor[item] = AppColors.themeGreen
                label.customSelectedColor[item] = AppColors.themeGreen
            }
            label.highlightFontName = AppFonts.SemiBold.rawValue
            label.highlightFontSize = 14.0
            label.handleCustomTap(for: seeExample) { _ in
                self.hanler?()
            }
            
        }
    }
}
