//
//  AccountOfflineDepositVC.swift
//  AERTRIP
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Razorpay
import UIKit

class AccountOfflineDepositVC: BaseVC {
    
    enum UsingToPaymentFor {
        case accountDeposit
        case addOns
    }
    
    enum UsingForPayBy {
        case chequeOrDD
        case fundTransfer
    }
    
    //MARK: - IB Outlet
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var checkOutTableView: ATTableView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var loaderContainer: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var paymentButtonContainerView: UIView!
    
    // MARK: - Properties
    var currentUsingAs: UsingForPayBy = UsingForPayBy.chequeOrDD
    var currentUsingFor: UsingToPaymentFor = UsingToPaymentFor.accountDeposit
    let viewModel = AccountOfflineDepositVM()
    
    // MARK: - View Life cycle
    
    override func initialSetup() {
        
        self.view.backgroundColor = AppColors.themeWhite
        self.checkOutTableView.dataSource = self
        self.checkOutTableView.delegate = self
        self.addFooterView()
        self.payButton.addGredient(isVertical: false)
        self.setUpNavigationView()
        self.registerXib()
        
        self.loaderContainer.addGredient(isVertical: false)
        self.manageLoader(shouldStart: false)
        //for header blur
        self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        topNavView.backgroundColor = AppColors.clear
        
        self.viewModel.userEnteredDetails.isForFundTransfer = self.currentUsingAs == .fundTransfer
    }
    
    override func setupFonts() {
        self.payButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupTexts() {
        self.updatePayButtonText()
    }
    
    override func setupColors() {
        self.payButton.setTitleColor(AppColors.themeWhite, for: .normal)
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    // MARK: - Helper methods
    
    // Set up Navigation header
    private func setUpNavigationView() {
        self.topNavView.delegate = self
        
        let navTitle = (self.currentUsingAs == .chequeOrDD) ? LocalizedString.ChequeDemandDraft.localized : LocalizedString.FundTransfer.localized
        
        self.topNavView.configureNavBar(title: navTitle, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "ic_account_info"), selectedImage: #imageLiteral(resourceName: "ic_account_info"))
    }
    
    // Registe all Xib file to checkOut table view
    private func registerXib() {
        self.checkOutTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: AccountDepositAmountCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: TextEditableTableViewCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: HCEmailTextFieldCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: AddNotesTableViewCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: OfflineDepositeTextImageCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: OfflineDepositeSlipUoloadCell.reusableIdentifier)
    }
    
    private func addFooterView() {
        self.paymentButtonContainerView.frame = CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: 50.0)
        self.checkOutTableView.tableFooterView = self.paymentButtonContainerView
    }

    // Upadate All Data on Table View
    func updateAllData() {
        self.updatePayButtonText()
        self.checkOutTableView.reloadData()
    }

    // Get Update Pay Button Text
    private func updatePayButtonText() {
        self.payButton.setTitle("\(LocalizedString.Register.localized) \(LocalizedString.Payment.localized)", for: .normal)
    }

    func manageLoader(shouldStart: Bool) {
        self.indicatorView.style = .white
        self.indicatorView.color = AppColors.themeWhite
        self.indicatorView.startAnimating()
        
        self.loaderContainer.isHidden = !shouldStart
    }
    
    func showPaymentSuccessMessage() {
        if self.currentUsingFor == .addOns {
            AppFlowManager.default.showAddonRequestSent(buttonTitle:LocalizedString.Done.localized, delegate: self)
        }
        else {
            var config = BulkEnquirySuccessfulVC.ButtonConfiguration()
            config.text = "\(LocalizedString.Register.localized) \(LocalizedString.Payment.localized)"
            config.textFont = AppFonts.SemiBold.withSize(20.0)
            config.cornerRadius = 0.0
            config.width = self.payButton.width
            config.spaceFromBottom = AppFlowManager.default.safeAreaInsets.bottom
            
            AppFlowManager.default.showAccountDepositSuccessVC(buttonConfig: config, delegate: self)
        }
    }

    //MARK: - Action
    @IBAction func payButtonAction(_ sender: UIButton) {
        if self.viewModel.userEnteredDetails.isDataVarified {
            self.viewModel.registerPayment(currentUsingAs: self.currentUsingAs)
        }
    }
    
    @objc func fileDeleteButtonAction(_ sender: UIButton) {
        
        if let indexPath = self.checkOutTableView.indexPath(forItem: sender), indexPath.section == 1, indexPath.row < self.viewModel.userEnteredDetails.uploadedSlips.count {
            
            let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Delete.localized], colors: [AppColors.themeRed])
            
            _ = PKAlertController.default.presentActionSheet(nil, message: LocalizedString.WouldYouLikeToDelete.localized, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
                
                if index == 0 {
                    self.viewModel.userEnteredDetails.removeSlip(atIndex: indexPath.row)
                    self.checkOutTableView.reloadData()
                }
            }
        }
    }
}

extension AccountOfflineDepositVC: BulkEnquirySuccessfulVCDelegate {
    func doneButtonAction() {
        if self.currentUsingFor == .addOns {
            for vc in AppFlowManager.default.mainNavigationController.viewControllers {
                if vc.isKind(of: FlightBookingsDetailsVC.self) {
                    AppFlowManager.default.popToViewController(vc, animated: true)
                    break
                }
            }
        }
        else {
            self.sendDataChangedNotification(data: ATNotification.accountPaymentRegister)
            if let vc = AppFlowManager.default.mainNavigationController.viewController(atIndex: 1) {
                AppFlowManager.default.popToViewController(vc, animated: true)
            }
        }
    }
}
