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
    var depositButton: ATButton?
    var currentUserType: UserCreditType {
        return UserInfo.loggedInUser?.userCreditType ?? UserCreditType.statement
    }
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = AppColors.screensBackground.color
        self.tableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        
        self.topNavView.configureNavBar(title: LocalizedString.Accounts.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
        
        if let user = UserInfo.loggedInUser, (user.userCreditType == .statement || user.userCreditType == .billwise) {
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
    private func showDepositOptions() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.PayOnline.localized, LocalizedString.PayOfflineNRegister.localized, LocalizedString.ChequeDemandDraft.localized, LocalizedString.FundTransfer.localized], colors: [AppColors.themeGreen, AppColors.themeGray40, AppColors.themeGreen, AppColors.themeGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            
            switch index {
            case 0:
                //PayOnline
                AppFlowManager.default.moveToAccountOnlineDepositVC(depositItinerary: self.viewModel.itineraryData)
                
            case 2:
                //ChequeDemandDraft
                AppFlowManager.default.moveToAccountOfflineDepositVC(usingFor: .chequeOrDD, paymentModeDetail: self.viewModel.itineraryData?.chequeOrDD, bankMaster: self.viewModel.itineraryData?.bankMaster ?? [])
                printDebug("ChequeDemandDraft")
                
            case 3:
                //FundTransfer
                AppFlowManager.default.moveToAccountOfflineDepositVC(usingFor: .fundTransfer, paymentModeDetail: self.viewModel.itineraryData?.fundTransfer, bankMaster: self.viewModel.itineraryData?.bankMaster ?? [])
                printDebug("FundTransfer")
                
            default:
                printDebug("no need to implement")
            }
        }
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @objc func depositButtonAction(_ sender: ATButton) {
        self.viewModel.getOutstandingPayment()
    }
}

//MARK:- ViewModel Delegate Methods
//MARK:-
extension SpecialAccountDetailsVC: SpecialAccountDetailsVMDelegate {
    func willGetOutstandingPayment() {
        self.depositButton?.isLoading = true
    }
    
    func getOutstandingPaymentSuccess() {
        self.depositButton?.isLoading = false
        self.showDepositOptions()
    }
    
    func getOutstandingPaymentFail() {
        self.depositButton?.isLoading = false
    }
    
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
        AppFlowManager.default.presentAccountChargeInfoVC(usingFor: .chargeInfo)
    }
}
