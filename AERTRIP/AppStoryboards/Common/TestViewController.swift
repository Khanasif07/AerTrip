//
//  TestViewController.swift
//  AERTRIP
//
//  Created by Appinventiv on 28/08/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func openPopUp(_ sender: Any) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Maps.localized, LocalizedString.Google.localized], colors: [AppColors.themeGreen, AppColors.themeGreen])
        
        
    
        _ = PKAlertController.default.presentActionSheet(LocalizedString.Choose_App.localized, titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, message: nil, messageFont: nil, messageColor: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton, tapBlock: { [weak self] _, index in
            if index == 0 {
                printDebug("Email")
                
            } else if index == 1 {
                printDebug("Share")
                
            } else if index == 2 {
                printDebug("Remove All photo")
            }
        })
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        AppFlowManager.default.mainNavigationController.popViewController(animated: true)
           }
    
    
}
