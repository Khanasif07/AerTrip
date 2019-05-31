//
//  AccountOnlineDepositVC.swift
//  AERTRIP
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Razorpay
import UIKit

class AccountOnlineDepositVC: BaseVC {
    // MARK: - IB Outlet
    
    @IBOutlet var topNavView: TopNavigationView!
    @IBOutlet var checkOutTableView: ATTableView!
    @IBOutlet var payButton: UIButton!
    @IBOutlet var loaderContainer: UIView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    let viewModel = AccountOnlineDepositVM()
    let cellIdentifier = "FareSectionHeader"
    
    // MARK: - View Life cycle
    
    override func initialSetup() {
        self.view.backgroundColor = AppColors.themeWhite
        self.checkOutTableView.dataSource = self
        self.checkOutTableView.delegate = self
        self.addFooterView()
        self.payButton.addGredient(isVertical: false)
        self.setUpImage()
        self.setUpNavigationView()
        self.registerXib()
        
        self.loaderContainer.addGredient(isVertical: false)
        self.manageLoader(shouldStart: false)
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
        self.topNavView.configureNavBar(title: LocalizedString.CheckoutTitle.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
    }
    
    // Registe all Xib file to checkOut table view
    private func registerXib() {
        self.checkOutTableView.registerCell(nibName: TermAndPrivacyTableViewCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: FareDetailTableViewCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: TotalPayableNowCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: AccountDepositAmountCell.reusableIdentifier)
    }
    
    private func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 50))
        customView.backgroundColor = AppColors.themeGray04
        self.checkOutTableView.tableFooterView = customView
    }
    
    // Setup Image for Pay Button
    private func setUpImage() {
        self.payButton.setImage(#imageLiteral(resourceName: "whiteBlackLockIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        self.payButton.setImage(#imageLiteral(resourceName: "whiteBlackLockIcon").withRenderingMode(.alwaysOriginal), for: .highlighted)
        self.payButton.bringSubviewToFront(self.payButton.imageView!)
        self.payButton.spaceInTextAndImageOfButton(spacing: 2)
    }
    
    // Upadate All Data on Table View
    func updateAllData() {
        self.updatePayButtonText()
        self.checkOutTableView.reloadData()
    }

    // Get Update Pay Button Text
    func updatePayButtonText() {
        self.payButton.setTitle(" " + LocalizedString.Pay.localized + " " + self.viewModel.totalPayableAmount.amountInDelimeterWithSymbol, for: .normal)
    }

    func manageLoader(shouldStart: Bool) {
        self.indicatorView.style = .white
        self.indicatorView.color = AppColors.themeWhite
        self.indicatorView.startAnimating()
        
        self.loaderContainer.isHidden = !shouldStart
    }
    
    func showPaymentSuccessMessage() {
        var config = BulkEnquirySuccessfulVC.ButtonConfiguration()
        config.text = self.payButton.titleLabel?.text ?? ""
        config.image = #imageLiteral(resourceName: "whiteBlackLockIcon")
        config.cornerRadius = 0.0
        config.textFont = AppFonts.SemiBold.withSize(20.0)
        config.width = self.payButton.width
        config.spaceFromBottom = AppFlowManager.default.safeAreaInsets.bottom
        
        AppFlowManager.default.showAccountDepositSuccessVC(buttonConfig: config, delegate: self)
    }

    //MARK: - Action
    @IBAction func payButtonAction(_ sender: UIButton) {
        self.viewModel.makePayment()
    }
}

extension AccountOnlineDepositVC: BulkEnquirySuccessfulVCDelegate {
    func doneButtonAction() {
        self.sendDataChangedNotification(data: ATNotification.accountPaymentRegister)
        if let vc = AppFlowManager.default.mainNavigationController.viewController(atIndex: 1) {
            AppFlowManager.default.popToViewController(vc, animated: true)
        }
    }
}
