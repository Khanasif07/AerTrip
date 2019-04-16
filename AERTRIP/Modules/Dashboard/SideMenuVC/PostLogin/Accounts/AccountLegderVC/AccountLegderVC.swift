//
//  AccountLegderVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AccountLegderVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = AccountLegderVM()
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.topNavView.configureNavBar(title: LocalizedString.AccountsLegder.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: true)
        
        self.topNavView.delegate = self
        
        self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "ic_three_dots"), selectedImage: #imageLiteral(resourceName: "ic_three_dots"))
        self.topNavView.configureSecondRightButton(normalImage: #imageLiteral(resourceName: "ic_hotel_filter"), selectedImage: #imageLiteral(resourceName: "ic_hotel_filter_applied"))
        
        //add search view in tableView header
        self.tableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
        self.tableView.registerCell(nibName: AccountDetailEventHeaderCell.reusableIdentifier)
        self.tableView.registerCell(nibName: AccountDetailEventDescriptionCell.reusableIdentifier)
        
        self.topNavView.firstRightButton.isEnabled = false
        self.topNavView.secondRightButton.isEnabled = false
        self.viewModel.getAccountLedger()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func setupFonts() {
    }
    
    override func setupTexts() {
    }
    
    override func setupColors() {
        self.tableView.backgroundColor = AppColors.themeWhite
    }
    
    //MARK:- Methods
    //MARK:- Private
    
    
    //MARK:- Public
    func reloadList() {
        self.tableView.reloadData()
    }
    
    //MARK:- Action
}

//MARK:- Nav bar delegate methods
//MARK:-
extension AccountLegderVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //back button action
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //dots button action
    }
    
    func topNavBarSecondRightButtonAction(_ sender: UIButton) {
        //filter button action
    }
}


//MARK:- View model delegate methods
//MARK:-
extension AccountLegderVC: AccountLegderVMDelegate {
    func willGetAccountLedger() {
    }
    
    func getAccountLedgerSuccess() {
        self.topNavView.firstRightButton.isEnabled = true
        self.topNavView.secondRightButton.isEnabled = true
        self.reloadList()
    }
    
    func getAccountLedgerFail() {
    }
}
