//
//  SpecialAccountDetailsVC.swift
//  AERTRIP
//
//  Created by Admin on 06/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class SpecialAccountDetailsVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = SpecialAccountDetailsVM()
    
    //MARK:- Private
    var currentUserType: UserInfo.UserType {
        return UserInfo.loggedInUser?.userType ?? UserInfo.UserType.statement
    }
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = AppColors.screensBackground.color
        self.tableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        
        self.topNavView.configureNavBar(title: LocalizedString.Accounts.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
        
        if let user = UserInfo.loggedInUser, (user.userType == .statement || user.userType == .billWise) {
            self.topNavView.configureNavBar(title: LocalizedString.Accounts.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        }
        
        self.topNavView.delegate = self
        
        self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "ic_account_info"), selectedImage: #imageLiteral(resourceName: "ic_account_info"))
        
        self.viewModel.fetchScreenDetails()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- Methods
    //MARK:- Private
    
    
    //MARK:- Public
    
    
    //MARK:- Action
}

//MARK:- ViewModel Delegate Methods
//MARK:-
extension SpecialAccountDetailsVC: SpecialAccountDetailsVMDelegate {
    func willFetchScreenDetails() {
    }
    
    func fetchScreenDetailsSuccess() {
        self.tableView.reloadData()
    }
    
    func fetchScreenDetailsFail() {
    }
}

//MARK:- Nav bar delegate methods
//MARK:-
extension SpecialAccountDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //back button action
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //info button action
        AppFlowManager.default.presentAccountChargeInfoVC()
    }
}
