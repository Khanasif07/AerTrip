//
//  FinalCheckOutVC.swift
//  AERTRIP
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FinalCheckOutVC: BaseVC {
    // MARK: - IB Outlet
    
    @IBOutlet var topNavView: TopNavigationView!
    @IBOutlet var checkOutTableView: ATTableView!
    @IBOutlet var payButton: ATButton!
    
    
    
    // MARK: - Properties
    
    let cellIdentifier = "FareSectionHeader"
    let viewModel = FinalCheckoutVM()
    var isWallet: Bool = false
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationView()
        self.registerXib()
        self.viewModel.webServiceGetPaymentMethods()
    }
    
    override func initialSetup() {
        self.checkOutTableView.dataSource = self
        self.checkOutTableView.delegate = self
        self.addFooterView()
    }
    
    override func setupFonts() {
        self.payButton.fontForTitle = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupTexts() {
        self.payButton.setTitle(" " + LocalizedString.Pay.localized + " " + AppConstants.kRuppeeSymbol + Double(60000).delimiter, for: .normal)
    }
    
    override func setupColors() {
        self.payButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.payButton.setImage(#imageLiteral(resourceName: "whiteBlackLockIcon"), for: .normal)
        self.payButton.spaceInTextAndImageOfButton(spacing: 2)
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    
    // MARK: - Helper methods
    
    // Set up Navigation header
    private func setUpNavigationView() {
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.CheckoutTitle.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.CancelWithSpace.localized, selectedTitle: LocalizedString.CancelWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.DoneWithSpace.localized, selectedTitle: LocalizedString.DoneWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
    }
    
    // Registe all Xib file to checkOut table view
    private func registerXib() {
        self.checkOutTableView.registerCell(nibName: ApplyCouponTableViewCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: WalletTableViewCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: TermAndPrivacyTableViewCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: FareDetailTableViewCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: DiscountCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: WallletAmountCellTableViewCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: FinalAmountTableViewCell.reusableIdentifier)
        self.checkOutTableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.cellIdentifier)
        self.checkOutTableView.registerCell(nibName: CurrencyOptionCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: TotalPayableNowCell.reusableIdentifier)
    }
    
    private func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 50))
        customView.backgroundColor = AppColors.themeGray04
        self.checkOutTableView.tableFooterView = customView
    }
    
    private func getCellForFirstSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 2, 4:
            guard let emptyCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier, for: indexPath) as? EmptyTableViewCell else {
                printDebug("Cell not found")
                return UITableViewCell()
            }
            return emptyCell
        case 1:
            guard let applyCouponCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: ApplyCouponTableViewCell.reusableIdentifier, for: indexPath) as? ApplyCouponTableViewCell else {
                printDebug("ApplyCouponTableViewCell not found")
                return UITableViewCell()
            }
            return applyCouponCell
        case 3:
            guard let walletCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.reusableIdentifier, for: indexPath) as? WalletTableViewCell else {
                printDebug("WalletTableViewCell not found")
                return UITableViewCell()
            }
            walletCell.delegate = self
            if let walletAmount = self.viewModel.paymentDetails?.paymentDetails.wallet {
                  walletCell.amountLabel.text = AppConstants.kRuppeeSymbol +  walletAmount.delimiter
            }
            return walletCell
        case 5:
            
            guard let fareDetailCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: FareDetailTableViewCell.reusableIdentifier, for: indexPath) as? FareDetailTableViewCell else {
                printDebug("FareDetailTableViewCell not found")
                return UITableViewCell()
            }
            return fareDetailCell
        default:
            return UITableViewCell()
        }
    }
    
    private func getCellForSecondSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let couponDiscountCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: DiscountCell.reusableIdentifier, for: indexPath) as? DiscountCell else {
                printDebug("DiscountCell not found")
                return UITableViewCell()
            }
            return couponDiscountCell
        case 1:
            guard let walletAmountCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WallletAmountCellTableViewCell.reusableIdentifier, for: indexPath) as? WallletAmountCellTableViewCell else {
                printDebug("WallletAmountCellTableViewCell not found")
                return UITableViewCell()
            }
//            if isWallet {
//                return walletAmountCell
//            } else {
//               return UITableViewCell()
//            }
           
            return walletAmountCell

           
           // return
            
        case 2:
            guard let totalPayableNowCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TotalPayableNowCell.reusableIdentifier, for: indexPath) as? TotalPayableNowCell else {
                printDebug("TotalPayableNowCell not found")
                return UITableViewCell()
            }
            return totalPayableNowCell
            
        case 3:
            guard let finalAmountCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: FinalAmountTableViewCell.reusableIdentifier, for: indexPath) as? FinalAmountTableViewCell else {
                printDebug("FinalAmountTableViewCell not found")
                return UITableViewCell()
            }
            if let netAmount = self.viewModel.itinaryPriceDetail?.netAmount {
                finalAmountCell.netEffectiveFareLabel.text = LocalizedString.NetEffectiveFare.localized + netAmount
            }
            return finalAmountCell
            
        case 4:
            guard let currencyOptionCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: CurrencyOptionCell.reusableIdentifier, for: indexPath) as? CurrencyOptionCell else {
                printDebug("CurrencyOptionCell not found")
                return UITableViewCell()
            }
            return currencyOptionCell
        case 5:
            guard let termAndPrivacCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TermAndPrivacyTableViewCell.reusableIdentifier, for: indexPath) as? TermAndPrivacyTableViewCell else {
                return UITableViewCell()
            }
            return termAndPrivacCell
        default:
            return UITableViewCell()
        }
    }
    
    private func getHeightOfRowForFirstSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 2, 4:
            return 35.0
        case 1:
            return 44.0
        case 3:
            return 75.0
        case 5:
            return 80.0
        default:
            return 44
        }
    }
    
    private func getHeightOfRowForSecondSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 20.0
        case 1:
            if isWallet {
                return 40.0
            } else {
               return 0.0
            }
        case 2:
            return 46.0
        case 3:
            return 87.0
        case 4:
            return 168.0
        case 5:
            return 115.0
        default:
            return 44
        }
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension FinalCheckOutVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return self.getCellForFirstSection(indexPath)
        } else {
            return self.getCellForSecondSection(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.getHeightOfRowForFirstSection(indexPath)
        } else {
            return self.getHeightOfRowForSecondSection(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 64
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
            
        } else {
            guard let headerView = self.checkOutTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? FareSectionHeader else {
                fatalError("FareSectionHeader not found")
            }
            
            if let grossAmount = self.viewModel.itinaryPriceDetail?.grossAmount {
                 headerView.grossPriceLabel.text = AppConstants.kRuppeeSymbol + grossAmount
            }
           
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            AppFlowManager.default.presentHCCouponCodeVC()
        }
    }
}

// MARK: - TopNavigationView Delegate methods

extension FinalCheckOutVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

extension FinalCheckOutVC : FinalCheckoutVMDelegate {
    func willCallGetPayementMethods() {
        //
    }
    
    func getPaymentsMethodsSuccess() {
        //
        self.checkOutTableView.reloadData()
        printDebug("Get Success")
    }
    
    func getPaymentMethodsFails(errors: ErrorCodes) {
        //
    }
    
    
}
