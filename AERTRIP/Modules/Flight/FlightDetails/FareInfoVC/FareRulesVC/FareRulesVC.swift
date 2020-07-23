//
//  FareRulesVC.swift
//  Aertrip
//
//  Created by Monika Sonawane on 20/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class FareRulesVC: UIViewController, UIScrollViewDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dividerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fareRulesLabel: UILabel!
    @IBOutlet weak var fareRulesScrollView: UIScrollView!
    
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

        
        fareRulesScrollView.delegate = self
//        dividerLabel.isHidden = true
        
        if fareRulesData.count > 0{
            let val = fareRulesData[0]
            if val.count > 0{
                let ass = val.allKeys
                
                self.titleLabel.text = (ass[0] as! String)
                
                let vall = val.allValues
                if vall.count > 0{
                    if vall[0] as? String != nil{
                        if vall[0] as! String != "" {
                            var newVal = (vall[0] as! String)
                            
                            if newVal.contains(find: "<h2>"){
                                newVal = newVal.replacingOccurrences(of: "<h2>", with: "<p><h2>")
                            }
                           
                            let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'SourceSansPro'; font-size: 14\">%@</span>", newVal)
                            
                            let attrStr = try! NSMutableAttributedString(
                                data: modifiedFont.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                                options: [  .characterEncoding:String.Encoding.utf8.rawValue,
                                            .documentType: NSAttributedString.DocumentType.html],
                                documentAttributes: nil)

                            self.fareRulesLabel.attributedText = attrStr
                        }else{
                            self.fareRulesLabel.text = "No Information Available"
                        }
                    }else{
                        self.fareRulesLabel.text = "No Information Available"
                    }
                }else{
                    self.fareRulesLabel.text = "No Information Available"
                }
            }else{
                self.titleLabel.text = ""
                self.fareRulesLabel.text = "No Information Available"
            }
        }else{
            self.titleLabel.text = ""
            self.fareRulesLabel.text = "No Information Available"
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.contentOffset.y > 0{
//            dividerLabel.isHidden = false
        }else{
//            dividerLabel.isHidden = true
        }
    }
    
    //MARK:- Button Action
    @IBAction func closeButtonClicked(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
