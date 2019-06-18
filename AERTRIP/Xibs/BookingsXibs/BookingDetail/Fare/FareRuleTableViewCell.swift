//
//  FareRuleTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import WebKit

class FareRuleTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var fareRulesLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.setUpFont()
        self.setUpTextColor()
    }
    
    func setUpFont() {
        self.routeLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.fareRulesLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    func setUpTextColor() {
        self.routeLabel.textColor = AppColors.themeBlack
        self.fareRulesLabel.textColor = AppColors.themeGray60
    }
    
    
    func configureCell(fareRules: String, ruteString: String) {
        self.routeLabel.text = ruteString
        
        webView.loadHTMLString(fareRules, baseURL: nil)
        
//        let shortText = finalRules.substring(from: 0, to: 10000)
//        self.fareRulesLabel.attributedText = shortText.htmlToAttributedString(withFontSize: 16.0, fontFamily: AppFonts.Regular.withSize(16.0).fontName, fontColor: AppColors.themeGray60)
    }
}
