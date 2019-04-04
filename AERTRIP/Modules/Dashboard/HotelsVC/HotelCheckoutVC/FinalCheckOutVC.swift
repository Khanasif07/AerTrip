//
//  FinalCheckOutVC.swift
//  AERTRIP
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Razorpay
import UIKit

protocol FinalCheckOutVCDelegate: class {
    func cancelButtonTapped()
}

class FinalCheckOutVC: BaseVC {
    // MARK: - IB Outlet
    
    @IBOutlet var topNavView: TopNavigationView!
    @IBOutlet var checkOutTableView: ATTableView!
    @IBOutlet var payButton: UIButton!
    
    // MARK: - Properties
    
    private(set) var razorpay: Razorpay!
    
    let viewModel = FinalCheckoutVM()
    let cellIdentifier = "FareSectionHeader"
    var isWallet: Bool = true
    private var gradientLayer: CAGradientLayer!
    var gradientColors: [UIColor] = [AppColors.shadowBlue, AppColors.themeGreen] {
        didSet {
            self.viewDidLayoutSubviews()
        }
    }
    
    var disabledGradientColors: [UIColor] = [AppColors.themeGray20, AppColors.themeGray20] {
        didSet {
            self.viewDidLayoutSubviews()
        }
    }
    
    // Boolean to check whether coupon is applied or Not
    var isCouponApplied: Bool = false
    // Save applied coupon data
    var appliedCouponData: HCCouponAppliedModel = HCCouponAppliedModel()
    var previousAppliedCoupon: HCCouponModel?
    var convenienceRate: Double = 0
    var convenienceFeesWallet: Double = 0
    
    weak var delegate: FinalCheckOutVCDelegate?
    
    // MARK: - View Life cycle
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//    }
    
    override func initialSetup() {
        self.razorpay = Razorpay.initWithKey(AppConstants.kRazorpayPublicKey, andDelegateWithData: self)
        
        self.checkOutTableView.dataSource = self
        self.checkOutTableView.delegate = self
        self.addFooterView()
        self.payButton.addGredient()
        self.setUpImage()
        self.setUpNavigationView()
        self.registerXib()
        self.viewModel.webServiceGetPaymentMethods()
        self.getAppliedCoupons()
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
    
    private func getAppliedCoupons() {
        self.previousAppliedCoupon = self.viewModel.itinaryPriceDetail?.coupons.filter { $0.isCouponApplied == true }.first
        
        if self.previousAppliedCoupon != nil {
            self.appliedCouponData.isCouponApplied = self.previousAppliedCoupon?.isCouponApplied ?? false
            self.appliedCouponData.discountsBreakup = self.previousAppliedCoupon?.discountBreakUp
            self.appliedCouponData.couponCode = self.previousAppliedCoupon?.couponCode ?? ""
            self.isCouponApplied = true
            self.updateAllData()
        }
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
            if self.isCouponApplied {
                if let discountBreakUp = self.appliedCouponData.discountsBreakup {
                    let saveAmount = discountBreakUp.CACB + discountBreakUp.CPD
                    applyCouponCell.appliedCouponLabel.text = LocalizedString.Save.localized + " " + AppConstants.kRuppeeSymbol + Double(saveAmount).delimiter
                    applyCouponCell.couponView.isHidden = false
                    applyCouponCell.couponLabel.text = LocalizedString.CouponApplied.localized + self.appliedCouponData.couponCode
                }
            } else {
                applyCouponCell.couponView.isHidden = true
                applyCouponCell.couponLabel.text = LocalizedString.ApplyCoupon.localized
            }
            applyCouponCell.delegate = self
            return applyCouponCell
        case 3:
            guard let walletCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.reusableIdentifier, for: indexPath) as? WalletTableViewCell else {
                printDebug("WalletTableViewCell not found")
                return UITableViewCell()
            }
            walletCell.delegate = self
            walletCell.walletSwitch.isOn = self.getWalletAmount() > 0 && isWallet
            walletCell.amountLabel.text = AppConstants.kRuppeeSymbol + self.getWalletAmount().delimiter
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
            if self.isCouponApplied {
                if let discountBreakUp = self.appliedCouponData.discountsBreakup {
                    let saveAmount = discountBreakUp.CPD
                    couponDiscountCell.amountLabel.text = "-" + AppConstants.kRuppeeSymbol + Double(saveAmount).delimiter
                    couponDiscountCell.clipsToBounds = true
                }
            } else {
                couponDiscountCell.clipsToBounds = true
                return UITableViewCell()
            }
            return couponDiscountCell
        case 1:
            guard let walletAmountCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WallletAmountCellTableViewCell.reusableIdentifier, for: indexPath) as? WallletAmountCellTableViewCell else {
                printDebug("WallletAmountCellTableViewCell not found")
                return UITableViewCell()
            }
            
            if self.isWallet {
                var amount = getGrossAmount()
                if self.isCouponApplied, let discountBreakUp = self.appliedCouponData.discountsBreakup {
                    amount -= discountBreakUp.CPD
                } else {
                    amount = self.getGrossAmount()
                }
                walletAmountCell.walletAmountLabel.text = "-" + AppConstants.kRuppeeSymbol + abs(amount).delimiter
                walletAmountCell.clipsToBounds = true
                return walletAmountCell
            } else {
                walletAmountCell.clipsToBounds = true
                return UITableViewCell()
            }
            
            // return
            
        case 2:
            guard let totalPayableNowCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TotalPayableNowCell.reusableIdentifier, for: indexPath) as? TotalPayableNowCell else {
                printDebug("TotalPayableNowCell not found")
                return UITableViewCell()
            }
            totalPayableNowCell.totalPriceLabel.text = AppConstants.kRuppeeSymbol + self.getTotalPayableAmount().delimiter
            return totalPayableNowCell
            
        case 4:
            guard let finalAmountCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: FinalAmountTableViewCell.reusableIdentifier, for: indexPath) as? FinalAmountTableViewCell else {
                printDebug("FinalAmountTableViewCell not found")
                return UITableViewCell()
            }
            if self.isCouponApplied {
                if let netAmount = self.viewModel.itinaryPriceDetail?.netAmount, let discountBreakUp = self.appliedCouponData.discountsBreakup {
                    finalAmountCell.payableWalletMessageLabel.text = AppConstants.kRuppeeSymbol + Double(discountBreakUp.CACB).delimiter + LocalizedString.PayableWalletMessage.localized
                    finalAmountCell.netEffectiveFareLabel.text = LocalizedString.NetEffectiveFare.localized +
                        AppConstants.kRuppeeSymbol + " " + "\(netAmount.toDouble?.delimiter ?? "0.0")"
                }
                finalAmountCell.clipsToBounds = true
                return finalAmountCell
            } else {
                finalAmountCell.clipsToBounds = true
                return UITableViewCell()
            }
            
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
            if self.isCouponApplied {
                return 20.0
            } else {
                return 0.0
            }
        case 1:
            if self.isWallet {
                return 40.0
            } else {
                return 0.0
            }
        case 2:
            return 46.0
        case 3:
            if self.isCouponApplied {
                return 87.0
            } else {
                return 0
            }
            
        case 4:
            return 168.0
        case 5:
            return 115.0
        default:
            return 44
        }
    }
    
    private func setUpImage() {
        self.payButton.setImage(#imageLiteral(resourceName: "whiteBlackLockIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        self.payButton.setImage(#imageLiteral(resourceName: "whiteBlackLockIcon").withRenderingMode(.alwaysOriginal), for: .highlighted)
        self.payButton.bringSubviewToFront(self.payButton.imageView!)
        self.payButton.spaceInTextAndImageOfButton(spacing: 2)
    }
    
    func updateAllData() {
        self.updatePayButtonText()
        self.checkOutTableView.reloadData()
    }
    
    private func getTotalPayableAmount() -> Double {
        if let itinaryPrice = self.viewModel.itinaryPriceDetail {
            var payableAmount = itinaryPrice.grossAmount.toDouble ?? 0.0
            if self.isCouponApplied, let discountBreakUp = self.appliedCouponData.discountsBreakup {
                payableAmount += discountBreakUp.CPD
            } else {}
            if self.isWallet {
                if payableAmount < self.getWalletAmount() {
                    payableAmount = 0
                }
            }
            return payableAmount
            
        } else {
            return 0
        }
    }
    
    private func getWalletAmount() -> Double {
        if let walletAmount = self.viewModel.paymentDetails?.paymentDetails.wallet {
            return walletAmount
        } else {
            return 0
        }
    }
    
    private func updatePayButtonText() {
        if self.getTotalPayableAmount() > 0 {
            self.payButton.setTitle(" " + LocalizedString.Pay.localized + " " + AppConstants.kRuppeeSymbol + self.getTotalPayableAmount().delimiter, for: .normal)
            self.payButton.setTitle(" " + LocalizedString.Pay.localized + " " + AppConstants.kRuppeeSymbol + self.getTotalPayableAmount().delimiter, for: .highlighted)
        } else {
            self.payButton.setTitle(LocalizedString.ConfirmBooking.localized, for: .normal)
            self.payButton.setTitle(LocalizedString.ConfirmBooking.localized, for: .highlighted)
        }
    }
    
    private func getGrossAmount() -> Double {
        if let grossAmount = self.viewModel.itinaryPriceDetail?.grossAmount {
            return grossAmount.toDouble ?? 0.0
        } else {
            return 0
        }
    }
    
    // MARK: - Action
    
    @IBAction func payButtonAction(_ sender: UIButton) {
        self.viewModel.fetchRecheckRatesData()
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
            if self.isCouponApplied {
                return 64.0
            } else {
                return 64.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
            
        } else {
            guard let headerView = self.checkOutTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? FareSectionHeader else {
                fatalError("FareSectionHeader not found")
            }
            
            headerView.delegate = self
            
            if let discountbreak = self.appliedCouponData.discountsBreakup {
                headerView.discountPriceLabel.text = "-" + AppConstants.kRuppeeSymbol + "\(Double(discountbreak.CPD).delimiter)"
            }
            
            headerView.grossPriceLabel.text = AppConstants.kRuppeeSymbol + "\(self.getGrossAmount().delimiter)"
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            AppFlowManager.default.presentHCCouponCodeVC(itineraryId: self.viewModel.itineraryData?.it_id ?? "", vc: self)
        }
    }
}

// MARK: - TopNavigationView Delegate methods

extension FinalCheckOutVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
        self.delegate?.cancelButtonTapped()
    }
}

extension FinalCheckOutVC: FinalCheckoutVMDelegate {
    func willCallGetPayementMethods() {
        //
    }
    
    func getPaymentsMethodsSuccess() {
        //
        if let razorPay = self.viewModel.paymentDetails?.paymentModes.razorPay {
            self.convenienceRate = razorPay.convenienceFees
            self.convenienceFeesWallet = razorPay.convenienceFeesWallet > 0 ? razorPay.convenienceFeesWallet : 0
        }
        
        self.updateAllData()
        printDebug("Get Success")
    }
    
    func getPaymentMethodsFails(errors: ErrorCodes) {
        //
    }
    
    func removeCouponCodeSuccessful(_ appliedCouponData: HCCouponAppliedModel) {
        self.viewModel.itineraryData = appliedCouponData.itinerary
        self.isCouponApplied = false
        self.updateAllData()
        printDebug(appliedCouponData)
    }
    
    func removeCouponCodeFailed() {
        printDebug("Unable to remove Coupon Code")
    }
    
    // payment related methods
    func willFetchRecheckRatesData() {}
    
    func fetchRecheckRatesDataSuccess(recheckedData: ItineraryData) {
        if let oldAmount = viewModel.itineraryData?.total_fare {
            let newAmount = recheckedData.total_fare
            
            let diff = newAmount - oldAmount
            if diff > 0 {
                // increased
                FareUpdatedPopUpVC.showPopUp(isForIncreased: true, decreasedAmount: 0.0, increasedAmount: diff, totalUpdatedAmount: newAmount, continueButtonAction: { [weak self] in
                    guard let sSelf = self else { return }
                    sSelf.viewModel.makePayment()
                }, goBackButtonAction: { [weak self] in
                    guard let sSelf = self else { return }
                    sSelf.topNavBarLeftButtonAction(sSelf.topNavView.leftButton)
                })
            } else if diff < 0 {
                // dipped
                FareUpdatedPopUpVC.showPopUp(isForIncreased: false, decreasedAmount: -diff, increasedAmount: 0, totalUpdatedAmount: 0, continueButtonAction: nil, goBackButtonAction: nil)
                self.viewModel.makePayment()
            }
        }
    }
    
    func willMakePayment() {}
    
    func makePaymentSuccess(options: JSONDictionary) {
        self.initializePayment(withOptions: options)
        AppToast.default.showToastMessage(message: "make Payment done")
    }
    
    func makePaymentFail() {
        AppToast.default.showToastMessage(message: "make Payment faild")
    }
}

extension FinalCheckOutVC: HCCouponCodeVCDelegate {
    func appliedCouponData(_ appliedCouponData: HCCouponAppliedModel) {
        printDebug(appliedCouponData)
        self.appliedCouponData = appliedCouponData
        self.isCouponApplied = true
        delay(seconds: 0.3) { [weak self] in
            self?.updateAllData()
        }
    }
}
