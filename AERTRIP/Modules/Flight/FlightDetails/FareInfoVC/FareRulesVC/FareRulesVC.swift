//
//  FareRulesVC.swift
//  Aertrip
//
//  Created by Monika Sonawane on 20/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit
import WebKit

class FareRulesVC: UIViewController, UIScrollViewDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dividerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fareRulesLabel: UILabel!
    @IBOutlet weak var fareRulesScrollView: UIScrollView!
    @IBOutlet weak var webView: WKWebView!
    
    //MARK:- Variable Declaration
    var fareRulesData = [JSONDictionary]()
    
    //MARK:- Initialise View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.backgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.addSubview(blurEffectView)
        
        let val = fareRulesData[0]
        if val.count > 0{
            let keys = val.keys
            
            if keys.count > 0{
                self.titleLabel.text = keys.first ?? ""
            }else{
                self.titleLabel.text = ""
            }
            
            let vall = val.values
            if vall.count > 0{
                if vall.first as? String != nil{
                    if vall.first as! String != "" {
                        let newVal = (vall.first as! String)
                        
//                        let cssStr = newVal.htmlCSSCodeString(withFont: AppFonts.Regular.withSize(28.0), isCustomFont: true, fontFileName: "SourceSansPro-Regular", fontColor: AppColors.themeBlack)
//
                        
                        let cssStr = newVal.htmlCSSCodeString(withFont: AppFonts.Regular.withSize(28.0), isCustomFont: true, fontFileName: AppFonts.Regular.rawValue, fontColor: AppColors.themeBlack)
                        var url = Bundle.main.url(forResource: AppFonts.Regular.rawValue, withExtension: "ttf")
                        url?.deleteLastPathComponent()
                        webView.loadHTMLString(cssStr, baseURL: url)
                    }
                }
            }
        }
    }
    
    //MARK:- Button Action
    @IBAction func closeButtonClicked(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
