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
    
    enum UsingToPaymentFor {
        case accountDeposit
        case addOns
    }
    
    // MARK: - IB Outlet
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var checkOutTableView: ATTableView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var loaderContainer: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var gradientView: UIView!
    
    // MARK: - Properties
    var currentUsingFor: UsingToPaymentFor = UsingToPaymentFor.accountDeposit
    
    let viewModel = AccountOnlineDepositVM()
    let cellIdentifier = "FareSectionHeader"
    
    // MARK: - View Life cycle
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.loaderContainer.addGredient(isVertical: false)
        self.gradientView.addGredient(isVertical: false)
    }
    
    override func initialSetup() {
        self.view.backgroundColor = AppColors.themeWhite
        self.checkOutTableView.dataSource = self
        self.checkOutTableView.delegate = self
        self.addFooterView()
        self.setUpImage()
        self.setUpNavigationView()
        self.registerXib()
        self.payButton.backgroundColor = AppColors.clear
        self.loaderContainer.backgroundColor = AppColors.clear
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
       // self.payButton.setTitle(" " + LocalizedString.Pay.localized + " " + self.viewModel.totalPayableAmount.amountInDelimeterWithSymbol, for: .normal)
        
        let title = (" " + LocalizedString.Pay.localized + " " + self.viewModel.totalPayableAmount.amountInDelimeterWithSymbol).asStylizedPrice(using: AppFonts.Regular.withSize(22.0))
        self.payButton.setTitle(title.string, for: .normal)
        self.payButton.setTitle(title.string, for: .highlighted)

        self.payButton.setAttributedTitle(title, for: .normal)
        self.payButton.setAttributedTitle(title, for: .highlighted)
        self.payButton.AttributedFontColorForText(text: title.string, textColor: .white, state: .normal)
        self.payButton.AttributedFontColorForText(text: title.string, textColor: .white, state: .highlighted)
    }

    func manageLoader(shouldStart: Bool) {
        self.indicatorView.style = .white
        self.indicatorView.color = AppColors.themeWhite
        self.indicatorView.startAnimating()
        
        self.loaderContainer.isHidden = !shouldStart
    }
    
    func showPaymentSuccessMessage() {
        if self.currentUsingFor == .addOns {
//            AppFlowManager.default.showAddonRequestSent(buttonTitle:LocalizedString.Done.localized, delegate: self)
            
            var config = BulkEnquirySuccessfulVC.ButtonConfiguration()
            config.text = self.payButton.titleLabel?.text ?? ""
            config.image = #imageLiteral(resourceName: "whiteBlackLockIcon")
            config.cornerRadius = 0.0
            config.textFont = AppFonts.SemiBold.withSize(20.0)
            config.width = self.payButton.width
            config.buttonHeight = self.gradientView.height
            config.spaceFromBottom = AppFlowManager.default.safeAreaInsets.bottom
              AppFlowManager.default.showAddonRequestSent(buttonConfig: config, delegate: self)
        }
        else {
            var config = BulkEnquirySuccessfulVC.ButtonConfiguration()
            config.text = self.payButton.titleLabel?.text ?? ""
            config.image = #imageLiteral(resourceName: "whiteBlackLockIcon")
            config.cornerRadius = 0.0
            config.textFont = AppFonts.SemiBold.withSize(20.0)
            config.width = self.payButton.width
            config.spaceFromBottom = AppFlowManager.default.safeAreaInsets.bottom
            
            AppFlowManager.default.showAccountDepositSuccessVC(buttonConfig: config, delegate: self)
        }
    }

    //MARK: - Action
    @IBAction func payButtonAction(_ sender: UIButton) {
        if self.viewModel.isValidAmount() {
            self.viewModel.makePayment()
        }
    }
}

extension AccountOnlineDepositVC: BulkEnquirySuccessfulVCDelegate {
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
