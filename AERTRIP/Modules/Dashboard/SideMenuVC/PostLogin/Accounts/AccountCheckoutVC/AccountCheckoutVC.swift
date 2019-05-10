//
//  AccountCheckoutVC.swift
//  AERTRIP
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Razorpay
import UIKit

class AccountCheckoutVC: BaseVC {
    // MARK: - IB Outlet
    
    @IBOutlet var topNavView: TopNavigationView!
    @IBOutlet var checkOutTableView: ATTableView!
    @IBOutlet var payButton: UIButton!
    @IBOutlet var loaderContainer: UIView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    let viewModel = AccountCheckoutVM()
    let cellIdentifier = "FareSectionHeader"
    
    // MARK: - View Life cycle
    
    override func initialSetup() {
        self.checkOutTableView.dataSource = self
        self.checkOutTableView.delegate = self
        self.addFooterView()
        self.payButton.addGredient(isVertical: false)
        self.setUpImage()
        self.setUpNavigationView()
        self.registerXib()
        
        self.loaderContainer.addGredient()
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
    
    
    private func getCellForFirstSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            //deposit amoutn cell
            guard let depositCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: AccountDepositAmountCell.reusableIdentifier, for: indexPath) as? AccountDepositAmountCell else {
                printDebug("Cell not found")
                return UITableViewCell()
            }

            return depositCell
            
        case 1:
            //blank gap
            guard let emptyCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier, for: indexPath) as? EmptyTableViewCell else {
                printDebug("Cell not found")
                return UITableViewCell()
            }
            emptyCell.clipsToBounds = true
            return emptyCell
            
        case 2:
            //fare details
            guard let fareDetailCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: FareDetailTableViewCell.reusableIdentifier, for: indexPath) as? FareDetailTableViewCell else {
                printDebug("FareDetailTableViewCell not found")
                return UITableViewCell()
            }
            fareDetailCell.fareDetailTitleLabel.text = LocalizedString.Breakup.localized
            fareDetailCell.numberOfRoomAndLabel.text = ""
            return fareDetailCell
            
        case 3:
            //deposit amount
            guard let totalPayableNowCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TotalPayableNowCell.reusableIdentifier, for: indexPath) as? TotalPayableNowCell else {
                printDebug("TotalPayableNowCell not found")
                return UITableViewCell()
            }
            
            totalPayableNowCell.currentUsingFor = .normal
            totalPayableNowCell.totalPayableNowLabel.text = LocalizedString.DepositAmount.localized
            
            totalPayableNowCell.totalPriceLabel.text = self.viewModel.depositAmount.amountInDelimeterWithSymbol
            
            totalPayableNowCell.topDeviderView.isHidden = true
            totalPayableNowCell.bottomDeviderView.isHidden = true
            totalPayableNowCell.totalPayableTextBottomConstraint.constant = 16.0
            return totalPayableNowCell
            
        case 4:
            //conv fee amount
            guard let totalPayableNowCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TotalPayableNowCell.reusableIdentifier, for: indexPath) as? TotalPayableNowCell else {
                printDebug("TotalPayableNowCell not found")
                return UITableViewCell()
            }
            
            totalPayableNowCell.currentUsingFor = .normal
            totalPayableNowCell.totalPayableNowLabel.text = LocalizedString.ConvenienceFeeNonRefundable.localized
            
            totalPayableNowCell.totalPriceLabel.text = self.viewModel.feeAmount.amountInDelimeterWithSymbol
            
            totalPayableNowCell.topDeviderView.isHidden = true
            totalPayableNowCell.bottomDeviderView.isHidden = true
            totalPayableNowCell.totalPayableTextBottomConstraint.constant = 16.0
            return totalPayableNowCell
            
        case 5:
            // Total pay now Cell
            guard let totalPayableNowCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TotalPayableNowCell.reusableIdentifier, for: indexPath) as? TotalPayableNowCell else {
                printDebug("TotalPayableNowCell not found")
                return UITableViewCell()
            }
            totalPayableNowCell.totalPriceLabel.text = self.viewModel.totalPayableAmount.amountInDelimeterWithSymbol
            totalPayableNowCell.topDeviderView.isHidden = false
            totalPayableNowCell.bottomDeviderView.isHidden = true
            return totalPayableNowCell
            
        case 6:
            // Term and privacy Cell
            guard let termAndPrivacCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TermAndPrivacyTableViewCell.reusableIdentifier, for: indexPath) as? TermAndPrivacyTableViewCell else {
                return UITableViewCell()
            }
            termAndPrivacCell.currentUsingFrom = .accountCheckout
            return termAndPrivacCell
            
        default:
            return UITableViewCell()
        }
    }
    
    private func getHeightOfRowForFirstSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            //deposit amoutn cell
            return 92.0
            
        case 1:
            //blank gap
            return 35.0
            
        case 2:
            //fare details
            return 50.0
            
        case 3:
            //deposit amount
            return 29.0
            
        case 4:
            //conv fee amount
            return 29.0
            
        case 5:
            // Total pay now Cell
            return 46.0
            
        case 6:
            // Term and privacy Cell
            return 120.0
            
        default:
            return 0.0
        }
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
    private func updatePayButtonText() {
        self.payButton.setTitle(" " + LocalizedString.Pay.localized + " " + self.viewModel.totalPayableAmount.amountInDelimeterWithSymbol, for: .normal)
    }

    private func manageLoader(shouldStart: Bool) {
        self.indicatorView.style = .white
        self.indicatorView.color = AppColors.themeWhite
        self.indicatorView.startAnimating()
        
        self.loaderContainer.isHidden = !shouldStart
    }

    //MARK: - Action
    @IBAction func payButtonAction(_ sender: UIButton) {
        self.manageLoader(shouldStart: true)
        
        delay(seconds: 1.0) {[weak self] in
            self?.manageLoader(shouldStart: false)
            AppFlowManager.default.showAccountDepositSuccessVC(buttonTitle: "  \(self?.viewModel.totalPayableAmount.amountInDelimeterWithSymbol ?? "")")
        }
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension AccountCheckoutVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getCellForFirstSection(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.getHeightOfRowForFirstSection(indexPath)
    }
}

// MARK: - TopNavigationView Delegate methods

extension AccountCheckoutVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

extension AccountCheckoutVC: AccountCheckoutVMDelegate {
    
}
