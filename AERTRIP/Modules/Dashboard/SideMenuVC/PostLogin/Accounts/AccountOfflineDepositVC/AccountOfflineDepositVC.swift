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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.paymentButtonContainerView.addGredient(isVertical: false)
    }
    
    override func initialSetup() {
        
        self.view.backgroundColor = AppColors.themeWhite
        self.checkOutTableView.dataSource = self
        self.checkOutTableView.delegate = self
        self.setUpNavigationView()
        self.registerXib()
        
        self.loaderContainer.backgroundColor = .clear
        self.manageLoader(shouldStart: false)
        //for header blur
        self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        topNavView.backgroundColor = AppColors.clear
        
       
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
        
        let navTitle = LocalizedString.PayOfflineNRegister.localized //(self.currentUsingAs == .chequeOrDD) ? LocalizedString.ChequeDemandDraft.localized : LocalizedString.FundTransfer.localized
        
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
        self.payButton.isHidden = shouldStart
        self.loaderContainer.isHidden = !shouldStart
    }
    
    func showPaymentSuccessMessage() {
        if self.currentUsingFor == .addOns {
            var config = BulkEnquirySuccessfulVC.ButtonConfiguration()
            config.text = "\(LocalizedString.Register.localized) \(LocalizedString.Payment.localized)"
            config.textFont = AppFonts.SemiBold.withSize(20.0)
            config.cornerRadius = 0.0
            config.width = self.payButton.width
            config.buttonHeight = self.paymentButtonContainerView.height
            config.spaceFromBottom = AppFlowManager.default.safeAreaInsets.bottom
            //AppFlowManager.default.showAddonRequestSent(buttonConfig: config, delegate: self)
            AppFlowManager.default.showAccountDepositSuccessVC(buttonConfig: config, delegate: self, flow: .accountDeposit)
        }
        else {
            var config = BulkEnquirySuccessfulVC.ButtonConfiguration()
            config.text = "\(LocalizedString.Register.localized) \(LocalizedString.Payment.localized)"
            config.textFont = AppFonts.SemiBold.withSize(20.0)
            config.cornerRadius = 0.0
            config.width = self.payButton.width
            config.spaceFromBottom = AppFlowManager.default.safeAreaInsets.bottom
            
            AppFlowManager.default.showAccountDepositSuccessVC(buttonConfig: config, delegate: self, flow: .accountDeposit)
        }
    }

    //MARK: - Action
    @IBAction func payButtonAction(_ sender: UIButton) {
         self.viewModel.userEnteredDetails.isForFundTransfer = self.currentUsingAs == .fundTransfer
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
//        if self.currentUsingFor == .addOns {
            /*
            for vc in AppFlowManager.default.mainNavigationController.viewControllers {
                if vc.isKind(of: FlightBookingsDetailsVC.self) {
                    AppFlowManager.default.popToViewController(vc, animated: true)
                    break
                } else if vc.isKind(of: HotlelBookingsDetailsVC.self) {
                    AppFlowManager.default.popToViewController(vc, animated: true)
                }
            }
            */
            AppFlowManager.default.goToDashboard()
//        }
//        else {
//            self.sendDataChangedNotification(data: ATNotification.accountPaymentRegister)
//            if let vc = AppFlowManager.default.mainNavigationController.viewController(atIndex: 1) {
//                AppFlowManager.default.popToViewController(vc, animated: true)
//            }
//        }
    }
}
