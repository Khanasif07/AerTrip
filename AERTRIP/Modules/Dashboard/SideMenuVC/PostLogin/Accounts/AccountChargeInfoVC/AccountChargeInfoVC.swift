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
    @IBOutlet weak var topNavBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: BlurView!
    
    
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
        
        self.topNavBarHeightConstraint.constant = (self.viewModel.currentUsingFor == .chargeInfo) ? 44.0 : 60.0
        let navTitle = (self.viewModel.currentUsingFor == .chargeInfo) ? LocalizedString.Info.localized : LocalizedString.StepsForOfflinePayment.localized
        self.topNavView.configureNavBar(title: navTitle, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        
        self.topNavView.delegate = self
        
        self.topNavView.configureFirstRightButton(normalImage: AppImages.ic_toast_cross, selectedImage: AppImages.ic_toast_cross, normalTitle: " ", selectedTitle: " ")
        
        //for header blur
        topNavView.backgroundColor = .clear
        self.view.backgroundColor = AppColors.themeBlack26.withAlphaComponent(0.85)
        if #available(iOS 13.0, *) {
            topNavBarHeightConstraint.constant = 56
        } else {
            self.view.backgroundColor = AppColors.themeBlack26
        }
        self.tableView.backgroundColor = AppColors.themeBlack26
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if (self.viewModel.currentUsingFor == .offlinePaymentSteps) {
            self.topNavView.titleLeadingConstraint.constant = 16.0
            self.topNavView.navTitleLabel.font = AppFonts.SemiBold.withSize(22.0)
            self.topNavView.navTitleLabel.textAlignment = .left
        }
        else {
            self.topNavView.navTitleLabel.textAlignment = .center
        }
        
        if tableView.contentInset.top != blurView.height {
            tableView.contentInset = UIEdgeInsets(top: blurView.height, left: 0, bottom: 0, right: 0)
        }
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
