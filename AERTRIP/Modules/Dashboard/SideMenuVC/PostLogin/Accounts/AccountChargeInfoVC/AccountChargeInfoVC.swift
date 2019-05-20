//
//  AccountChargeInfoVC.swift
//  AERTRIP
//
//  Created by Admin on 06/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AccountChargeInfoVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = AccountChargeInfoVM()
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        
        self.viewModel.fetchData()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let navTitle = (self.viewModel.currentUsingFor == .chargeInfo) ? LocalizedString.Info.localized : LocalizedString.StepsForOfflinePayment.localized
        self.topNavView.configureNavBar(title: navTitle, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        
        self.topNavView.navTitleLabel.textAlignment = (self.viewModel.currentUsingFor == .chargeInfo) ? NSTextAlignment.center : NSTextAlignment.left
        self.topNavView.delegate = self
        
        self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "ic_toast_cross"), selectedImage: #imageLiteral(resourceName: "ic_toast_cross"), normalTitle: " ", selectedTitle: " ")
    }

    
    //MARK:- Methods
    //MARK:- Private
    
    
    //MARK:- Public
    
    
    //MARK:- Action
}

//MARK:- Nav bar delegate methods
//MARK:-
extension AccountChargeInfoVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //cross button action
        self.dismiss(animated: true, completion: nil)
    }
}
