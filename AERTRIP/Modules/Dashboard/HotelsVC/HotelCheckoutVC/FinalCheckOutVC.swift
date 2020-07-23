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
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var checkOutTableView: ATTableView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var loaderContainer: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var gradientView: UIView!
    
    // MARK: - Properties
    
    let viewModel = FinalCheckoutVM()
    let cellIdentifier = "HotelFareSectionHeader"
    var isWallet: Bool = true // To check if using wallet or Not
//    var gradientColors: [UIColor] = [AppColors.shadowBlue, AppColors.themeGreen] {
//        didSet {
//            self.viewDidLayoutSubviews()
//        }
//    }
//
//    var disabledGradientColors: [UIColor] = [AppColors.themeGray20, AppColors.themeGray20] {
//        didSet {
//            self.viewDidLayoutSubviews()
//        }
//    }
    
    private var isReloadingAfterFareDipOrIncrease: Bool = false
    
    // Boolean to check whether coupon is applied or Not
    var isCouponApplied: Bool = false
    // Save applied coupon data
    var appliedCouponData: HCCouponAppliedModel = HCCouponAppliedModel()
    var previousAppliedCoupon: HCCouponModel?
    var convenienceRate: Double = 0
    var convenienceFeesWallet: Double = 0
    // Boolean to check if convenienceFeeToAppliedOrNot
    var isConvenienceFeeApplied: Bool = false
    
    // Boolean to handle  coupon view expanded or not , By Default will be expanded
    var isCouponSectionExpanded: Bool = true
    
    weak var delegate: FinalCheckOutVCDelegate?
    
    // MARK: - View Life cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }
    
    
    override func initialSetup() {
        self.checkOutTableView.dataSource = self
        self.checkOutTableView.delegate = self
        self.addFooterView()
        //self.setUpImage()
        self.setUpNavigationView()
        self.registerXib()
        self.viewModel.webServiceGetPaymentMethods()
        self.getAppliedCoupons()
        self.viewModel.hotelFormData = HotelsSearchVM.hotelFormData
        
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
        self.payButton.setTitleColor(AppColors.themeWhite, for: .highlighted)

    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    // MARK: - Helper methods
    
    // Set up Navigation header
    private func setUpNavigationView() {
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.CheckoutTitle.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: true)
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
        
        // TODO: // will be done after currency KT
        // self.checkOutTableView.registerCell(nibName: CurrencyOptionCell.reusableIdentifier)
        
        self.checkOutTableView.registerCell(nibName: TotalPayableNowCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: ConvenienceFeeTableViewCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: HotelFareTableViewCell.reusableIdentifier)

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
            emptyCell.topDividerView.isHidden = indexPath.row == 0
            emptyCell.clipsToBounds = true
            return emptyCell
        case 1:
            guard let applyCouponCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: ApplyCouponTableViewCell.reusableIdentifier, for: indexPath) as? ApplyCouponTableViewCell else {
                printDebug("ApplyCouponTableViewCell not found")
                return UITableViewCell()
            }
            if self.isCouponApplied {
                if let discountBreakUp = self.appliedCouponData.discountsBreakup {
                    let saveAmount = discountBreakUp.CACB + discountBreakUp.CPD
                    applyCouponCell.appliedCouponLabel.attributedText =
                        ("\(LocalizedString.Save.localized) \(Double(saveAmount).amountInDelimeterWithSymbol)").asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
                    applyCouponCell.couponView.isHidden = false
                    applyCouponCell.couponLabel.text = LocalizedString.CouponApplied.localized + " \(self.appliedCouponData.couponCode)"
                }
            } else {
                applyCouponCell.couponView.isHidden = true
                applyCouponCell.couponLabel.text = LocalizedString.ApplyCoupon.localized
            }
            applyCouponCell.hideShowLoader(isHidden: !self.viewModel.isApplyingCoupon)//Golu change
            applyCouponCell.delegate = self
            return applyCouponCell
        case 3:
            guard let walletCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.reusableIdentifier, for: indexPath) as? WalletTableViewCell else {
                printDebug("WalletTableViewCell not found")
                return UITableViewCell()
            }
            walletCell.clipsToBounds = true
            walletCell.delegate = self
            walletCell.walletSwitch.isOn = isWallet
            walletCell.amountLabel.attributedText = self.getWalletAmount().amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(16.0))
            return walletCell
        case 5:
            
            guard let fareDetailCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: FareDetailTableViewCell.reusableIdentifier, for: indexPath) as? FareDetailTableViewCell else {
                printDebug("FareDetailTableViewCell not found")
                return UITableViewCell()
            }
            fareDetailCell.setupForFinalCheckOutScreen(text: self.getRoomAndNightText())
            return fareDetailCell
        default:
            return UITableViewCell()
        }
    }
    
    private func getCellForSecondSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            
            guard let hotelFareTableViewCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: HotelFareTableViewCell.reusableIdentifier, for: indexPath) as? HotelFareTableViewCell else {
                printDebug("DiscountCell not found")
                return UITableViewCell()
            }
            hotelFareTableViewCell.delegate = self
            self.handleDiscountArrowAnimation(hotelFareTableViewCell)
            if let discountbreak = self.appliedCouponData.discountsBreakup {
                hotelFareTableViewCell.discountPriceLabel.attributedText = ("-" + "\(Double(discountbreak.CPD).amountInDelimeterWithSymbol)").asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
            }
            
            if self.isCouponApplied {
                hotelFareTableViewCell.discountViewHeightConstraint.constant = 27
                hotelFareTableViewCell.discountTitleLabelTopConstraint.constant = -1
            } else {
                hotelFareTableViewCell.discountViewHeightConstraint.constant = 0
                hotelFareTableViewCell.clipsToBounds = true
            }
            hotelFareTableViewCell.grossPriceLabel.attributedText = "\(self.getGrossAmount().amountInDelimeterWithSymbol)".asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
            return hotelFareTableViewCell
        case 1: // Coupon dicount Cell
            guard let couponDiscountCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: DiscountCell.reusableIdentifier, for: indexPath) as? DiscountCell else {
                printDebug("DiscountCell not found")
                return UITableViewCell()
            }
            if self.isCouponApplied, self.isCouponSectionExpanded {
                if let discountBreakUp = self.appliedCouponData.discountsBreakup {
                    let saveAmount = discountBreakUp.CPD
                    couponDiscountCell.amountLabel.attributedText = ("-" + Double(saveAmount).amountInDelimeterWithSymbol).asStylizedPrice(using: AppFonts.Regular.withSize(14.0))
                    couponDiscountCell.clipsToBounds = true
                }
            } else {
                couponDiscountCell.clipsToBounds = true
                return UITableViewCell()
            }
            return couponDiscountCell
        case 2: // Convenience Fee Cell
            guard let convenieneCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WallletAmountCellTableViewCell.reusableIdentifier, for: indexPath) as? WallletAmountCellTableViewCell else {
                printDebug("WallletAmountCellTableViewCell not found")
                return UITableViewCell()
            }
            convenieneCell.walletAmountLabel.textColor = AppColors.themeBlack
            convenieneCell.aertripWalletTitleLabel.textColor = AppColors.themeBlack
            let amount = isWallet ? self.convenienceFeesWallet : self.convenienceRate
            if self.isConvenienceFeeApplied {
                convenieneCell.aertripWalletTitleLabel.text = LocalizedString.ConvenienceFee.localized
                convenieneCell.walletAmountLabel.attributedText = amount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
                convenieneCell.labelBottomConstraint.constant = self.isWallet ? 0 : 11
                if self.isCouponApplied, self.isCouponSectionExpanded {
                    convenieneCell.labelTopConstraint.constant = 4
                } else {
                    convenieneCell.labelTopConstraint.constant = 11
                }
                return convenieneCell
            } else {
                convenieneCell.clipsToBounds = true
                return UITableViewCell()
            }
            
            // return
            
        case 3: // Aertip Wallet Cell
            
            guard let walletAmountCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WallletAmountCellTableViewCell.reusableIdentifier, for: indexPath) as? WallletAmountCellTableViewCell else {
                printDebug("WallletAmountCellTableViewCell not found")
                return UITableViewCell()
            }
            
            if self.isWallet {
                var amount = getGrossAmount()
                var amountFromWallet: Double = 0.0
                if self.isCouponApplied, let discountBreakUp = self.appliedCouponData.discountsBreakup {
                    amount -= discountBreakUp.CPD
                }
                if amount > self.getWalletAmount() {
                    amountFromWallet = self.getWalletAmount()
                } else {
                    amountFromWallet = amount
                }
                walletAmountCell.walletAmountLabel.attributedText = ("-" + abs(amountFromWallet).amountInDelimeterWithSymbol).asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
                walletAmountCell.clipsToBounds = true
                walletAmountCell.labelBottomConstraint.constant =  11
                 walletAmountCell.labelTopConstraint.constant = self.isWallet ? 4 : 11
                return walletAmountCell
            } else {
                walletAmountCell.clipsToBounds = true
                return UITableViewCell()
            }
            
        case 4: // Total pay now Cell
            guard let totalPayableNowCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TotalPayableNowCell.reusableIdentifier, for: indexPath) as? TotalPayableNowCell else {
                printDebug("TotalPayableNowCell not found")
                return UITableViewCell()
            }
            totalPayableNowCell.topDeviderView.isHidden = false
            totalPayableNowCell.bottomDeviderView.isHidden = false
            totalPayableNowCell.totalPriceLabel.attributedText = self.getTotalPayableAmount().amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(((totalPayableNowCell.currentUsingFor == .totalPayableAmout) ? 20.0 : 16.0)))
            totalPayableNowCell.setupFotFinalCheckoutScreen()
            totalPayableNowCell.bottomDeviderView.isHidden =  !self.isCouponApplied
            return totalPayableNowCell
            
        case 5: // Convenience Fee message Cell
            guard let conveninceCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: ConvenienceFeeTableViewCell.reusableIdentifier, for: indexPath) as? ConvenienceFeeTableViewCell else {
                printDebug("ConvenienceFeeTableViewCell not found")
                return UITableViewCell()
            }
            let amount = self.isWallet ? self.convenienceFeesWallet : self.convenienceRate
            if self.isConvenienceFeeApplied {
                conveninceCell.convenienceFeeLabel.textColor = AppColors.themeBlack
                conveninceCell.convenienceFeeLabel.text = (LocalizedString.convenienceFee1.localized + " \(amount.amountInDelimeterWithSymbol) " + LocalizedString.convenienceFee2.localized)
                conveninceCell.convenienceFeeLabel.asStylizedPrice(text: amount.amountInDelimeterWithSymbol, using: AppFonts.Regular.withSize(14.0))
                return conveninceCell
            } else {
                conveninceCell.clipsToBounds = true
                return UITableViewCell()
            }
            
        case 6: // Final Amount Message cell
            guard let finalAmountCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: FinalAmountTableViewCell.reusableIdentifier, for: indexPath) as? FinalAmountTableViewCell else {
                printDebug("FinalAmountTableViewCell not found")
                return UITableViewCell()
            }
            finalAmountCell.dividerView.isHidden = true
            if self.isCouponApplied {
                if let netAmount = self.viewModel.itinaryPriceDetail?.netAmount, let discountBreakUp = self.appliedCouponData.discountsBreakup {
                    // Net Effective fare
                    let effectiveFare = abs(netAmount.toDouble ?? 0.0 - discountBreakUp.CPD)
                    finalAmountCell.payableWalletMessageLabel.text = (Double(discountBreakUp.CACB).amountInDelimeterWithSymbol + LocalizedString.PayableWalletMessage.localized)
                    finalAmountCell.payableWalletMessageLabel.asStylizedPrice(text: Double(discountBreakUp.CACB).amountInDelimeterWithSymbol, using: AppFonts.Regular.withSize(14.0))
                    finalAmountCell.netEffectiveFareLabel.attributedText = (LocalizedString.NetEffectiveFare.localized + " \(effectiveFare.amountInDelimeterWithSymbol)").asStylizedPrice(using: AppFonts.SemiBold.withSize(14.0))
                }
                
                finalAmountCell.clipsToBounds = true
                return finalAmountCell
            } else {
                finalAmountCell.clipsToBounds = true
                return UITableViewCell()
            }
            
        case 7: // Term and privacy Cell
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
        case 0: // Empty Cell
            return 35.0
        case 4: // Empty Cell
            return (UserInfo.loggedInUser != nil) ? 35.0 : CGFloat.leastNormalMagnitude
        case 1: // Apply Coupon Cell
            return 44.0
        case 2:
            if let _ = UserInfo.loggedInUser {
              return  self.getWalletAmount() > 0 ? 35.0 : CGFloat.leastNormalMagnitude
            }
            return CGFloat.leastNormalMagnitude
        case 3: // Pay by Wallet Cell
            if let _ = UserInfo.loggedInUser {
              return  self.getWalletAmount() > 0 ? 75.0 : CGFloat.leastNormalMagnitude
            }
            return CGFloat.leastNormalMagnitude
        case 5: // Fare Detail Cell
            return UITableView.automaticDimension//80.0
        default:
            return 44 // Default Height Cell
        }
    }
    
    private func getHeightOfRowForSecondSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            if self.isCouponApplied {
                return 60.0
            } else {
                return 28.0
            }
        case 1: // coupond discount cell
            if self.isCouponApplied, self.isCouponSectionExpanded {
                return 20.0
            } else {
                return CGFloat.leastNormalMagnitude
            }
        case 2: // Convenince Fee Cell
            if self.isConvenienceFeeApplied {
                return UITableView.automaticDimension//36.0
            } else {
                return CGFloat.leastNormalMagnitude
            }
            
        case 3: // Wallet amount Cell
            if self.isWallet {
                return UITableView.automaticDimension//40.0
            } else {
                return CGFloat.leastNormalMagnitude
            }
        case 4: // total amount Cell
            return 46.0
            
        case 5: // Convenience Cell Message
            if self.isConvenienceFeeApplied {
                return CGFloat.leastNormalMagnitude//46.0
            } else {
                return CGFloat.leastNormalMagnitude
            }
        case 6: // Final amount message table view Cell
            if self.isCouponApplied {
                return 87.0
            } else {
                return CGFloat.leastNormalMagnitude
            }
            
        case 7: // term and privacy cell
            return 115.0
        default:
            return 44
        }
    }
    
    // Setup Image for Pay Button
    private func setUpImage(showImage: Bool = true) {
        if showImage {
            self.payButton.setImage( #imageLiteral(resourceName: "whiteBlackLockIcon").withRenderingMode(.alwaysOriginal), for: .normal)
            self.payButton.setImage( #imageLiteral(resourceName: "whiteBlackLockIcon").withRenderingMode(.alwaysOriginal), for: .highlighted)
            self.payButton.bringSubviewToFront(self.payButton.imageView!)
            self.payButton.spaceInTextAndImageOfButton(spacing: 2)
        } else {
            self.payButton.setImage(nil, for: .normal)
            self.payButton.setImage(nil, for: .highlighted)
            self.payButton.spaceInTextAndImageOfButton(spacing: 0)
        }
    }
    
    // Upadate All Data on Table View
    func updateAllData() {
        self.updatePayButtonText()
        self.checkOutTableView.reloadData()
    }
    
    // Get Total Payable Amount based on conditions
    private func getTotalPayableAmount() -> Double {
        var payableAmount: Double = self.getGrossAmount()
        if payableAmount > 0.0 {
            if self.isCouponApplied, let discountBreakUp = self.appliedCouponData.discountsBreakup {
                payableAmount -= discountBreakUp.CPD
            }
            let amount = self.isWallet ? self.convenienceFeesWallet : self.convenienceRate
            if self.isConvenienceFeeApplied {
                payableAmount += amount
            }
            self.viewModel.grossTotalPayableAmount = payableAmount
            
            if self.isWallet {
                if payableAmount > self.getWalletAmount() {
                    payableAmount = abs(payableAmount - self.getWalletAmount())
                } else {
                    payableAmount = 0
                }
            }
            
            return payableAmount
            
        } else {
            return 0
        }
    }
    
    // Get Available Wallet Amount
    func getWalletAmount() -> Double {
        if let walletAmount = self.viewModel.paymentDetails?.paymentDetails.wallet {
            return walletAmount
        } else {
            return 0
        }
    }
    
    // Get Update Pay Button Text
    func updatePayButtonText() {
        if self.getTotalPayableAmount() > 0 {
            setUpImage()
            let title = (" " + LocalizedString.Pay.localized + " " + self.getTotalPayableAmount().amountInDelimeterWithSymbol).asStylizedPrice(using: AppFonts.Regular.withSize(22.0))
            self.payButton.setTitle(title.string, for: .normal)
            self.payButton.setTitle(title.string, for: .highlighted)
            
            self.payButton.setAttributedTitle(title, for: .normal)
            self.payButton.setAttributedTitle(title, for: .highlighted)
            self.payButton.AttributedFontColorForText(text: title.string, textColor: .white, state: .normal)
            self.payButton.AttributedFontColorForText(text: title.string, textColor: .white, state: .highlighted)
        } else {
            setUpImage(showImage: false)
            self.payButton.setAttributedTitle(nil, for: .normal)
            self.payButton.setAttributedTitle(nil, for: .highlighted)
            self.payButton.setTitle(LocalizedString.ConfirmBooking.localized, for: .normal)
            self.payButton.setTitle(LocalizedString.ConfirmBooking.localized, for: .highlighted)
        }
    }
    
    // Get Gross Amount for Bill
    
    private func getGrossAmount() -> Double {
        var grossAmount: Double = 0.0
        if self.isReloadingAfterFareDipOrIncrease {
            grossAmount = self.viewModel.itineraryData?.total_fare ?? 0.0
        } else {
            grossAmount = self.viewModel.itinaryPriceDetail?.grossAmount.toDouble ?? 0.0
        }
        return grossAmount
    }
    
    // Get  Text based on number of rooms and nights
    private func getRoomAndNightText() -> String {
        let adultCount = self.viewModel.hotelFormData.adultsCount.count
        var text = ""
        text += adultCount > 1 ? "\(adultCount) Rooms" : "\(adultCount) Room"
        let totalNights = (self.viewModel.hotelFormData.checkOutDate.toDate(dateFormat: "yyyy-MM-dd")!).daysFrom(self.viewModel.hotelFormData.checkInDate.toDate(dateFormat: "yyyy-MM-dd")!)
        text += (totalNights == 1) ? " & \(totalNights) Night" : " & \(totalNights) Nights"
        
        return text
    }
    
    private func loader(shouldShow: Bool) {
        self.loaderContainer.isHidden = shouldShow
    }
    
    private func manageLoader(shouldStart: Bool) {
        self.indicatorView.style = .white
        self.indicatorView.color = AppColors.themeWhite
        self.indicatorView.startAnimating()
        
        self.loaderContainer.isHidden = !shouldStart
        self.view.isUserInteractionEnabled = !shouldStart
    }
    
    // Set Boolean convenience fee to applied or Not
    
    func setConvenienceFeeToBeApplied() {
        if self.isWallet, self.convenienceFeesWallet > 0 {
            self.isConvenienceFeeApplied = true
        } else {
            if self.convenienceRate > 0 {
                self.isConvenienceFeeApplied = true
            } else {
                self.isConvenienceFeeApplied = false
            }
        }
        delay(seconds: 0.3) { [weak self] in
            self?.updateAllData()
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
            return 8
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
//        if section == 0 {
//            return 0
//        } else {
//            if self.isCouponApplied {
//                return 60.0
//            } else {
//                return 28.0
//            }
//        }
        CGFloat.leastNormalMagnitude
    }
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
            
        } else {
            guard let headerView = self.checkOutTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? HotelFareSectionHeader else {
                fatalError("FareSectionHeader not found")
            }
            
            headerView.delegate = self
            self.handleDiscountArrowAnimation(headerView)
            if let discountbreak = self.appliedCouponData.discountsBreakup {
                headerView.discountPriceLabel.attributedText = ("-" + "\(Double(discountbreak.CPD).amountInDelimeterWithSymbol)").asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
            }
            
            if self.isCouponApplied {
                headerView.discountViewHeightConstraint.constant = 27
                headerView.discountTitleLabelTopConstraint.constant = -1
            } else {
                headerView.discountViewHeightConstraint.constant = 0
                headerView.clipsToBounds = true
            }
            headerView.grossPriceLabel.attributedText = "\(self.getGrossAmount().amountInDelimeterWithSymbol)".asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
            return headerView
        }
    }
    */
    
    // Golu changes for  coupon code
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1, indexPath.section == 0 {
            self.moveToCouponVC(indexPath: indexPath)
        }
    }
    
    func moveToCouponVC(indexPath:IndexPath){
        self.manageCouponLoader(isApplying:true)
        self.viewModel.getCouponsDetailsApi {[weak self] (success, couponDetails, error) in
            guard let self = self else {return}
            self.manageCouponLoader(isApplying:false)
            if success{
                AppFlowManager.default.presentHCCouponCodeVC(itineraryId: self.viewModel.itineraryData?.it_id ?? "", vc: self, couponData: couponDetails, couponCode: self.appliedCouponData.couponCode)
            }else{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .hotelsSearch)
            }
        }
        
    }

    
    func manageCouponLoader(isApplying:Bool){
        self.viewModel.isApplyingCoupon = isApplying
        self.view.isUserInteractionEnabled = !isApplying
        self.checkOutTableView.reloadData()
    }
    
     // End
}

// MARK: - TopNavigationView Delegate methods

extension FinalCheckOutVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
        self.delegate?.cancelButtonTapped()
    }
}

extension FinalCheckOutVC: FinalCheckoutVMDelegate {
    func willGetBookingReceipt() {
        
    }
    
    func getBookingReceiptSuccess(detail: HotelReceiptModel) {
        self.manageLoader(shouldStart: false)
        if let id = self.viewModel.itineraryData?.it_id {
            AppFlowManager.default.presentYouAreAllDoneVC(forItId: id, bookingIds: self.viewModel.bookingIds, cid: self.viewModel.cId, originLat: self.viewModel.originLat, originLong: self.viewModel.originLong, recieptData: detail)
        }
    }
    
    func getBookingReceiptFail() {
        self.manageLoader(shouldStart: false)
    }
    func getPaymentResonseSuccess(bookingIds: [String], cid: [String]) {
            // send to you are all donr screen
    //        self.manageLoader(shouldStart: false)
            if let id = self.viewModel.itineraryData?.it_id {
                self.viewModel.bookingIds = bookingIds
                self.viewModel.cId = cid
                self.viewModel.getBookingReceipt(bookingIds: bookingIds, itId: id)
                //AppFlowManager.default.presentYouAreAllDoneVC(forItId: id, bookingIds: bookingIds, cid: cid, originLat: self.viewModel.originLat, originLong: self.viewModel.originLong)
            }
        }
    
    func willCallGetPayementMethods() {
        //
    }
    
    func getPaymentsMethodsSuccess() {
        //
        if let razorPay = self.viewModel.paymentDetails?.paymentModes.razorPay {
            self.convenienceRate = razorPay.convenienceFees
            self.convenienceFeesWallet = razorPay.convenienceFeesWallet > 0 ? razorPay.convenienceFeesWallet : 0
            self.setConvenienceFeeToBeApplied()
        }
        self.isWallet = self.getWalletAmount() > 0
        
        self.updateAllData()
        printDebug("Get Success")
    }
    
    func getPaymentMethodsFails(errors: ErrorCodes) {
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
    }
    
    func removeCouponCodeSuccessful(_ appliedCouponData: HCCouponAppliedModel) {
        self.manageCouponLoader(isApplying: false)//Golu Chnages
        self.viewModel.itineraryData = appliedCouponData.itinerary
        self.appliedCouponData = appliedCouponData
        self.isCouponApplied = false
        self.updateAllData()
        printDebug(appliedCouponData)
    }
    
    func removeCouponCodeFailed() {
        self.manageCouponLoader(isApplying: false) //Golu Chnages
        printDebug("Unable to remove Coupon Code")
    }
    
    // payment related methods
    func willFetchRecheckRatesData() {
        self.manageLoader(shouldStart: true)
    }
    
    func fetchRecheckRatesDataSuccess(recheckedData: ItineraryData) {
        self.manageLoader(shouldStart: false)
        if let oldAmount = viewModel.itineraryData?.total_fare {
            let newAmount = recheckedData.total_fare
            
            let diff = newAmount - oldAmount
            
            // update UI
            isReloadingAfterFareDipOrIncrease = diff != 0
            viewModel.itineraryData = recheckedData
            updateAllData()
            
            if diff > 0 {
                // increased
                FareUpdatedPopUpVC.showPopUp(isForIncreased: true, decreasedAmount: 0.0, increasedAmount: diff, totalUpdatedAmount: newAmount, continueButtonAction: { [weak self] in
                    guard let sSelf = self else { return }
                    sSelf.viewModel.makePayment(forAmount: sSelf.getTotalPayableAmount(), useWallet: sSelf.isWallet)
                }, goBackButtonAction: { [weak self] in
                    guard let sSelf = self else { return }
                    sSelf.topNavBarLeftButtonAction(sSelf.topNavView.leftButton)
                })
            } else if diff < 0 {
                // dipped
                FareUpdatedPopUpVC.showPopUp(isForIncreased: false, decreasedAmount: -diff, increasedAmount: 0, totalUpdatedAmount: 0, continueButtonAction: nil, goBackButtonAction: nil)
                self.viewModel.makePayment(forAmount: self.getTotalPayableAmount(), useWallet: self.isWallet)
            } else {
                self.viewModel.makePayment(forAmount: self.getTotalPayableAmount(), useWallet: self.isWallet)
            }
        }
    }
    
    func willMakePayment() {
        self.manageLoader(shouldStart: true)
    }
    
    func makePaymentSuccess(options: JSONDictionary, shouldGoForRazorPay: Bool) {
        self.manageLoader(shouldStart: false)
        if shouldGoForRazorPay {
            self.initializePayment(withOptions: options)
        } else {
            // payment successfully maid through wallet, send to the You are all done
            if let bIds = options[APIKeys.booking_id.rawValue] as? [String] {
                self.getPaymentResonseSuccess(bookingIds: bIds, cid: [])
            } else if let cIds = options[APIKeys.cid.rawValue] as? [String] {
                self.getPaymentResonseSuccess(bookingIds: [], cid: cIds)
            }
        }
    }
    
    func makePaymentFail() {
        self.manageLoader(shouldStart: false)
        AppToast.default.showToastMessage(message: "Make Payment Failed")
    }
    
    func willGetPaymentResonse() {
        self.manageLoader(shouldStart: true)
    }
    
    
    
    func getPaymentResonseFail() {
        self.manageLoader(shouldStart: false)
    }
    
    private func handleDiscountArrowAnimation(_ headerView: HotelFareTableViewCell) {
        let rotateTrans = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        if self.isCouponSectionExpanded {
            headerView.arrowButton.transform = .identity
        } else {
            headerView.arrowButton.transform = rotateTrans
        }
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
