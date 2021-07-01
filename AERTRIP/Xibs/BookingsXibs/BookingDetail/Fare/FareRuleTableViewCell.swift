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
    @IBOutlet weak var routeLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var routeLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var routeLabelHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.setUpFont()
        self.setUpTextColor()
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
    }
    
    func setUpFont() {
        self.routeLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.fareRulesLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    func setUpTextColor() {
        self.routeLabel.textColor = AppColors.themeBlack
        self.fareRulesLabel.textColor = AppColors.themeGray60
    }
    
    
    func configureCell(isForBookingPolicy: Bool = false,fareRules: String, ruteString: String) {
        self.routeLabel.text = ruteString
        if isForBookingPolicy {
            self.routeLabelHeightConstraint.constant = 0
            self.routeLabelTopConstraint.constant = 0
            self.routeLabelBottomConstraint.constant = 0
        }
//        let cssStr = fareRules.htmlCSSCodeString(withFont: AppFonts.Regular.withSize(28.0), isCustomFont: true, fontFileName: "SourceSansPro-Regular", fontColor: isForBookingPolicy ? AppColors.themeBlack : AppColors.themeBlack)
  
        let cssStr = fareRules.htmlCSSCodeString(withFont: AppFonts.Regular.withSize(28.0), isCustomFont: true, fontFileName: AppFonts.Regular.rawValue, fontColor: isForBookingPolicy ? AppColors.themeBlack : AppColors.themeBlack)

        var url = Bundle.main.url(forResource: AppFonts.Regular.rawValue, withExtension: "ttf")
        url?.deleteLastPathComponent()
        webView.loadHTMLString(cssStr, baseURL: url)
    }
    
    func setColorForBookingPolicy(){
        self.contentView.backgroundColor = AppColors.themeWhite
        self.webView.backgroundColor = AppColors.themeWhite
        self.webView.isOpaque = false
    }
    
    
}

extension FareRuleTableViewCell: WKUIDelegate {
    
}


extension FareRuleTableViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        webView.scrollView.isScrollEnabled = true
        webView.evaluateJavaScript("document.body.scrollHeight") { (height, error) in
            if error == nil {
                if let height = height as? Int {
                    printDebug(height)
//                    if let heightInt = Int(height) {
//                        let heightFloat = Float(height)
                    if let parentHeight = self.parentViewController?.view.height, (CGFloat(height) > (parentHeight - 60)){
                        self.webViewHeightConstraint.constant = CGFloat(parentHeight - 60)
                    }else{
                        self.webViewHeightConstraint.constant = CGFloat(height)
                    }
                        
//                    }
                }
            }
        }
//        let height = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")
//        if let height = height {
//            if let heightInt = Int(height) {
//                let heightFloat = Float(heightInt)
//
//                webViewHeightConstraint.constant = CGFloat(heightFloat)
//            }
//        }
        //webView.scalesPageToFit = true
    }

    
}
