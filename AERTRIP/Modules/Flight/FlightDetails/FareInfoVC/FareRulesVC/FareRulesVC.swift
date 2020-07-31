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
    var fareRulesData = [NSDictionary]()
    
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
            let ass = val.allKeys
            
            self.titleLabel.text = (ass[0] as! String)
            
            let vall = val.allValues
            if vall.count > 0{
                if vall[0] as? String != nil{
                    if vall[0] as! String != "" {
                        let newVal = (vall[0] as! String)
                        
                        let cssStr = newVal.htmlCSSCodeString(withFont: AppFonts.Regular.withSize(28.0), isCustomFont: true, fontFileName: "SourceSansPro-Regular", fontColor: AppColors.themeBlack)
                        
                        var url = Bundle.main.url(forResource: "SourceSansPro-Regular", withExtension: "ttf")
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

//extension String{
//    func htmlCSSCodeString(withFont font: UIFont? = nil, isCustomFont: Bool = false, fontFileName: String? = nil, fontColor: UIColor? = nil) -> String {
//           
//           /**********************************************************************
//               ************ If isCustomFont 'true' ***********
//            
//            Genrate the @font-face by using : https://www.web-font-generator.com/
//            Step 1: Open website.
//            Step 2: Upload you custom font file.
//            Step 3: Check "I'm uploading a font that is legal for web embedding. I checked with the author and/or EULA."
//            Step 4: "Generate Web Font"
//            Step 5: Download files.
//            Step 6: Copy .ttf, .eot,.svg, .woff in to your buldel with the same name.
//            
//            Note-1: If isCustomFont is true than must pass that name in 'fontFileName' param.
//            
//            Note-2:
//               When loding the string on WKWebView, then must pass the base url as bulel url.
//            
//            Ex:
//            var url = Bundle.main.url(forResource: "SourceSansPro-Regular", withExtension: "ttf")
//            url?.deleteLastPathComponent()
//            webView.loadHTMLString(<string returned by this method>, baseURL: url)
//           
//           **********************************************************************/
//           
//           let tempFont = font ?? UIFont.systemFont(ofSize: 15.0)
//
//           var stringTags = "<!DOCTYPE html>"
//           stringTags += "<html>"
//           stringTags += "<head>"
//           stringTags += "<style>"
//           stringTags += "@font-face {"
//           stringTags += "font-family: \(tempFont.fontName);"
//           if isCustomFont, let fimeName = fontFileName {
//               guard let eotPath = Bundle.main.path(forResource: fimeName, ofType: "eot"), let woffPath = Bundle.main.path(forResource: fimeName, ofType: "woff"), let ttfPath = Bundle.main.path(forResource: fimeName, ofType: "ttf"), let svgPath = Bundle.main.path(forResource: fimeName, ofType: "svg") else {
//                   fatalError("Please check any of (.ttf, .eot,.svg, .woff) file is missing. Read hint above.")
//               }
//               stringTags += "src: url(\(eotPath)) format(embedded-opentype),"
//               stringTags += "url(\(woffPath)) format(woff),"
//               stringTags += "url(\(ttfPath))  format(truetype),"
//               stringTags += "url(\(svgPath)) format(svg);"
//           }
//           stringTags += "}"
//           
//           stringTags += "* {"
//           stringTags += "font-family: \(tempFont.fontName) !important;"
//           stringTags += "font-size: \(Int(tempFont.pointSize))pt !important;"
//           if let color = fontColor {
//               stringTags += "color: #\(color.hexString!) !important;"
//           }
//           stringTags += "}"
//           stringTags += "</style>"
//           stringTags += "</head>"
//           stringTags += "<body>"
//           
//           stringTags += "\(self)"
//           
//           stringTags += "</body>"
//           stringTags += "</html>"
//           
//           return stringTags
//       }
//}


//extension UIColor{
//    var hexString:String? {
//        if let components = self.cgColor.components {
//            let r = components[0]
//            let g = components[1]
//            let b = components[2]
////            return  String(format: "%02X%02X%02X", arguments:[ (Int)(r  255), (Int)(g  255), (Int)(b * 255)])
//
//            return String.init(format: "%02X%02X%02X", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
//        }
//        return nil
//    }
//}


