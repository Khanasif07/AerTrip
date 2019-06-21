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
        self.webView.uiDelegate = self
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
        
        let cssStr = fareRules.htmlCSSCodeString(withFont: AppFonts.Regular.withSize(28.0), isCustomFont: true, fontFileName: "SourceSansPro-Regular", fontColor: AppColors.themeGray60)
        
        var url = Bundle.main.url(forResource: "SourceSansPro-Regular", withExtension: "ttf")
        url?.deleteLastPathComponent()
        webView.loadHTMLString(cssStr, baseURL: url)
    }
}

extension FareRuleTableViewCell: WKUIDelegate {
    
}
