//
//  AccountDetailsVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AccountDetailsVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var balanceContainerView: UIView!
    @IBOutlet weak var balanceTextLabel: UILabel!
    @IBOutlet weak var balanceAmountLabel: UILabel!
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet var searchContainerView: UIView!
    @IBOutlet weak var blankSpaceView: UIView!
    @IBOutlet weak var searchBarContainerView: UIView!
    @IBOutlet weak var searchBar: ATSearchBar!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = AccountDetailsVM()
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.topNavView.configureNavBar(title: LocalizedString.Accounts.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: false)
        
        self.topNavView.delegate = self
        
        self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "ic_three_dots"), selectedImage: #imageLiteral(resourceName: "ic_three_dots"))
        self.topNavView.configureSecondRightButton(normalImage: #imageLiteral(resourceName: "ic_hotel_filter"), selectedImage: #imageLiteral(resourceName: "ic_hotel_filter_applied"))
        
        //add search view in tableView header
        self.tableView.tableHeaderView = self.searchContainerView
        self.tableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
        
        self.searchBar.isMicEnabled = true
        
        self.topNavView.firstRightButton.isEnabled = false
        self.topNavView.secondRightButton.isEnabled = false
        self.viewModel.getAccountDetails()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func setupFonts() {
        self.balanceTextLabel.font = AppFonts.Regular.withSize(14.0)
        self.balanceAmountLabel.font = AppFonts.SemiBold.withSize(28.0)
    }
    
    override func setupTexts() {
        self.balanceTextLabel.text = LocalizedString.Balance.localized
        self.balanceAmountLabel.text = "\(AppConstants.kRuppeeSymbol) \(18992.0.delimiter)"
        
        self.searchBar.placeholder = LocalizedString.search.localized
    }
    
    override func setupColors() {
        self.balanceTextLabel.textColor = AppColors.themeGray40
        
        self.blankSpaceView.backgroundColor = AppColors.themeGray04
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
extension AccountDetailsVC: TopNavigationViewDelegate {
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
extension AccountDetailsVC: AccountDetailsVMDelegate {
    func willGetAccountDetails() {
    }
    
    func getAccountDetailsSuccess() {
        self.topNavView.firstRightButton.isEnabled = true
        self.topNavView.secondRightButton.isEnabled = true
        self.reloadList()
    }
    
    func getAccountDetailsFail() {
    }
}
