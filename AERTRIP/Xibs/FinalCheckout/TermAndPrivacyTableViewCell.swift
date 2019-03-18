//
//  TermAndPrivacyTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import ActiveLabel
import SafariServices


class TermAndPrivacyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var termAndPrivacyLabel: ActiveLabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSetup()
 
    }

    private func doInitialSetup() {
        self.linkSetupForTermsAndCondition(withLabel: self.termAndPrivacyLabel)
    }
   
    
}


extension TermAndPrivacyTableViewCell {
    func linkSetupForTermsAndCondition(withLabel : ActiveLabel) {
        
        let fareDetails =  ActiveType.custom(pattern: "\\s\(LocalizedString.FareDetails.localized)\\b")
        let privacyPolicy  = ActiveType.custom(pattern: "\\s\(LocalizedString.privacy_policy.localized)\\b")
        let termsOfUse     = ActiveType.custom(pattern: "\\s\(LocalizedString.terms_of_use.localized)\\b")
        
        withLabel.enabledTypes = [fareDetails,privacyPolicy,termsOfUse]
        withLabel.customize { (label) in
            
            label.text = LocalizedString.CheckOutPrivacyAndPolicyTerms.localized
            label.customColor[fareDetails] = AppColors.themeGreen
            label.customSelectedColor[fareDetails] = AppColors.themeGreen
            label.customColor[privacyPolicy] = AppColors.themeGreen
            label.customSelectedColor[privacyPolicy] = AppColors.themeGreen
            label.customColor[termsOfUse] = AppColors.themeGreen
            label.customSelectedColor[termsOfUse] = AppColors.themeGreen
            
            label.handleCustomTap(for:fareDetails) { element in
                
                guard let url = URL(string: AppConstants.termsOfUse) else {return}
                let safariVC = SFSafariViewController(url: url)
                AppFlowManager.default.mainNavigationController.present(safariVC, animated: true, completion: nil)
                safariVC.delegate = self
            }
            
            label.handleCustomTap(for: privacyPolicy) { element in
                
                guard let url = URL(string: AppConstants.privacyPolicy) else {return}
                let safariVC = SFSafariViewController(url: url)
               AppFlowManager.default.mainNavigationController.present(safariVC, animated: true, completion: nil)
                safariVC.delegate = self
            }
            
            label.handleCustomTap(for: termsOfUse) { element in
                
                guard let url = URL(string: AppConstants.termsOfUse) else {return}
                let safariVC = SFSafariViewController(url: url)
                AppFlowManager.default.mainNavigationController.present(safariVC, animated: true, completion: nil)
                safariVC.delegate = self
            }
        }
        
        
       
    }
    
    
}

extension TermAndPrivacyTableViewCell : SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        AppFlowManager.default.mainNavigationController.dismiss(animated: true, completion: nil)
    }
}
