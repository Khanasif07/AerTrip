//
//  TermAndPrivacyTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import ActiveLabel
import SafariServices
import UIKit

class TermAndPrivacyTableViewCell: UITableViewCell {
    
    enum UsingFrom {
        case hotelCheckout
        case accountCheckout
        case flightCheckOut
    }
    
    @IBOutlet weak var deviderView: ATDividerView!
    @IBOutlet weak var termAndPrivacyLabel: ActiveLabel!

    var currentUsingFrom = UsingFrom.hotelCheckout {
        didSet {
            self.linkSetupForTermsAndCondition(withLabel: self.termAndPrivacyLabel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSetup()
    }
    
    private func doInitialSetup() {
        self.backgroundColor = AppColors.themeGray04
        self.linkSetupForTermsAndCondition(withLabel: self.termAndPrivacyLabel)
    }
}

extension TermAndPrivacyTableViewCell {
    func linkSetupForTermsAndCondition(withLabel: ActiveLabel) {
        // Commenting fare rules text as It is not required now - discussed with Nitesh.
        
       // let fareDetails = ActiveType.custom(pattern: "\\s\(LocalizedString.FareRules.localized)\\b")
        let fareRules = ActiveType.custom(pattern: "\\s\(LocalizedString.FareRules.localized)\\b")
        let privacyPolicy = ActiveType.custom(pattern: "\\s\(LocalizedString.privacy_policy.localized)\\b")
        let termsOfUse = ActiveType.custom(pattern: "\\s\(LocalizedString.terms_of_use.localized)\\b")
        
        var allTypes: [ActiveType] = []
        var textToDisplay = ""
        if self.currentUsingFrom == .accountCheckout {
            allTypes = [fareRules, privacyPolicy, termsOfUse]
            textToDisplay = LocalizedString.CheckOutFareRulesPrivacyAndPolicyTerms.localized
        }else if self.currentUsingFrom == .flightCheckOut{
            allTypes = [privacyPolicy, termsOfUse]
            textToDisplay = LocalizedString.CheckOutPrivacyAndPolicyTermsFlight.localized
        }
        else {
            allTypes = [privacyPolicy, termsOfUse]
            textToDisplay = LocalizedString.CheckOutPrivacyAndPolicyTerms.localized
        }
        
      //  withLabel.enabledTypes = [fareDetails, privacyPolicy, termsOfUse]
        
        withLabel.enabledTypes = allTypes
        withLabel.customize { [unowned self] label in
            label.font = AppFonts.Regular.withSize(14.0)
            label.text = textToDisplay

            for item in allTypes {
                label.customColor[item] = AppColors.themeGreen
                label.customSelectedColor[item] = AppColors.themeGreen
            }
            
            label.highlightFontName = AppFonts.SemiBold.rawValue
            label.highlightFontSize = 14.0
            
            label.handleCustomTap(for: fareRules) { _ in
                
                guard let url = URL(string: AppConstants.fareRules) else { return }
                AppFlowManager.default.showURLOnATWebView(url, screenTitle: "Fare Rules")
            }
            
            label.handleCustomTap(for: privacyPolicy) { _ in
                
                guard let url = URL(string: AppConstants.privacyPolicy) else { return }
                 AppFlowManager.default.showURLOnATWebView(url, screenTitle: "Privacy Policy")
            }
            
            label.handleCustomTap(for: termsOfUse) { _ in
                
                guard let url = URL(string: AppConstants.termsOfUse) else { return }
                 AppFlowManager.default.showURLOnATWebView(url, screenTitle: "Trems of Use")
            }
        }
    }
}

extension TermAndPrivacyTableViewCell: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        AppFlowManager.default.currentNavigation?.dismiss(animated: true, completion: nil)
    }
}
