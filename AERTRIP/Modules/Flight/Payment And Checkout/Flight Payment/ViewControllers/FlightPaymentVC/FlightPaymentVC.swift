//
//  FlightPaymentVC.swift
//  AERTRIP
//
//  Created by Apple  on 03.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightPaymentVC: BaseVC {

    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var checkOutTableView: ATTableView!{
        didSet{
            self.checkOutTableView.contentInset = UIEdgeInsets.zero
            self.checkOutTableView.delegate = self
            self.checkOutTableView.dataSource = self
            self.checkOutTableView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.checkOutTableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.checkOutTableView.backgroundColor = AppColors.screensBackground.color
        }
    }
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    let cellIdentifier = "HotelFareSectionHeader"
    var isWallet: Bool = true // To check if using wallet or Not
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
    
    var viewModel = FlightPaymentVM()
    private var isReloadingAfterFareDipOrIncrease: Bool = false
    // Boolean to check whether coupon is applied or Not
    var isCouponApplied: Bool = false
    // Save applied coupon data
    var appliedCouponData: HCCouponAppliedModel = HCCouponAppliedModel()
    var previousAppliedCoupon: HCCouponModel?
    var convenienceRate: Double = 0
    var convenienceFeesWallet: Double = 0
    // Boolean to check if convenienceFeeToAppliedOrNot
    var isConvenienceFeeApplied: Bool = true//false
    // Boolean to handle  coupon view expanded or not , By Default will be expanded
    var isCouponSectionExpanded: Bool = true
    //Is taxes and fee expended
    var isTaxesAndFeeExpended = true
    
    var isAddonsExpended = true
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkOutTableView.separatorStyle = .none
        self.checkOutTableView.dataSource = self
        self.checkOutTableView.delegate = self
        self.viewModel.delegate = self
        self.viewModel.getItineraryData()
        self.addFooterView()
        self.payButton.addGredient(isVertical: false)
        self.setUpNavigationView()
        self.registerXib()
        self.getAppliedCoupons()
        self.setUpNavigationView()
        self.setupPayButton()
        self.manageLoader()
    }
    
    override func initialSetup() {
        super.initialSetup()
        self.payButton.addGredient(isVertical: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }

    @IBAction func payButtonTapped(_ sender: UIButton) {
        self.loaderView.isHidden = false
        delay(seconds: 1) {
           self.loaderView.isHidden = true
        }
        let vc = FlightPaymentBookingStatusVC.instantiate(fromAppStoryboard: .FlightPayment)
        vc.viewModel.itinerary = self.viewModel.itinerary
        self.navigationController?.pushViewController(vc, animated: true)
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
        self.checkOutTableView.register(UINib(nibName: "HotelFareSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "HotelFareSectionHeader")
        self.checkOutTableView.register(UINib(nibName: "FareBreakupTableViewCell", bundle: nil), forCellReuseIdentifier: "FareBreakupCell")
        // TODO: // will be done after currency KT
        // self.paymentTable.registerCell(nibName: CurrencyOptionCell.reusableIdentifier)
        
        self.checkOutTableView.registerCell(nibName: TotalPayableNowCell.reusableIdentifier)
        self.checkOutTableView.registerCell(nibName: ConvenienceFeeTableViewCell.reusableIdentifier)
    }
    
    // Set up Navigation header
    private func setUpNavigationView() {
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.CheckoutTitle.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
    }

    private func setupPayButton() {
        self.payButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        self.payButton.setImage(#imageLiteral(resourceName: "whiteBlackLockIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        self.payButton.setImage(#imageLiteral(resourceName: "whiteBlackLockIcon").withRenderingMode(.alwaysOriginal), for: .highlighted)
        self.payButton.bringSubviewToFront(self.payButton.imageView!)
        self.payButton.spaceInTextAndImageOfButton(spacing: 2)
        self.payButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.setupPayButtonTitle()
        
    }

    func setupPayButtonTitle(){
        self.payButton.setTitle(" " + LocalizedString.Pay.localized + " " + Double(self.viewModel.itinerary.details.farepr).amountInDelimeterWithSymbol, for: .normal)
        self.payButton.setTitle(" " + LocalizedString.Pay.localized + " " + Double(self.viewModel.itinerary.details.farepr).amountInDelimeterWithSymbol, for: .highlighted)
    }
    
    private func loader(shouldShow: Bool) {
        self.loaderView.isHidden = shouldShow
    }
    
    private func manageLoader() {
        self.activityLoader.style = .white
        self.activityLoader.color = AppColors.themeWhite
        self.activityLoader.startAnimating()
        self.loaderView.addGredient(isVertical: false)
        self.loaderView.isHidden = true
    }
    
    private func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 50))
        customView.backgroundColor = AppColors.themeGray04
        self.checkOutTableView.tableFooterView = customView
    }
    
    private func getAppliedCoupons() {
//        self.previousAppliedCoupon = self.viewModel.itinaryPriceDetail?.coupons.filter { $0.isCouponApplied == true }.first
        
        if self.previousAppliedCoupon != nil {
            self.appliedCouponData.isCouponApplied = self.previousAppliedCoupon?.isCouponApplied ?? false
            self.appliedCouponData.discountsBreakup = self.previousAppliedCoupon?.discountBreakUp
            self.appliedCouponData.couponCode = self.previousAppliedCoupon?.couponCode ?? ""
            self.isCouponApplied = true
//            self.updateAllData()
            self.checkOutTableView.reloadData()
        }
    }
    
    
    func updateAllData(){
        self.checkOutTableView.reloadData()
        self.setupPayButtonTitle()
    }
    
}

//MARK:- Tableview delegate and datasource.
extension FlightPaymentVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionTableCell.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch self.viewModel.sectionHeader[section]{
        case .Taxes:
            guard let headerView = self.checkOutTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? HotelFareSectionHeader else {
                return nil
            }
            headerView.tag = section
            headerView.delegate = self
            self.handleDiscountArrowAnimation(headerView)
            headerView.grossFareTitleTopConstraint.constant = 0
            headerView.grossFareTitleLabel.text = "Base Fare"
            headerView.discountsTitleLabel.text = "Taxes and Fees"
            headerView.discountPriceLabel.text = "\(Double(self.viewModel.itinerary.details.fare.taxes.value).amountInDelimeterWithSymbol)"
            headerView.grossPriceLabel.text = "\(Double(self.viewModel.itinerary.details.fare.bf.value).amountInDelimeterWithSymbol)"
            return headerView
        case .Discount:
            guard let headerView = self.checkOutTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? HotelFareSectionHeader, self.isCouponApplied else {
                return nil
            }
            headerView.grossFareTitleLabel.text = ""
            headerView.grossPriceLabel.text = ""
            headerView.tag = section
            headerView.delegate = self
            headerView.grossFareTitleTopConstraint.constant = 0
            self.handleDiscountArrowAnimation(headerView)
            if let discountbreak = self.appliedCouponData.discountsBreakup {
                headerView.discountPriceLabel.text = "-\(Double(discountbreak.CPD).amountInDelimeterWithSymbol)"
            }else{
                 headerView.discountPriceLabel.text = "₹0"
            }
            return headerView
        case .Addons:return self.getHeaderAddons(section)
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.viewModel.sectionHeader[section]{
        case .Taxes: return 53.0
        case .Discount: return self.isCouponApplied ? 27 : 0
        case .Addons: return 27
        default: return CGFloat.leastNonzeroMagnitude
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.viewModel.sectionHeader[section]{
        case .Taxes: return  isTaxesAndFeeExpended ? self.viewModel.sectionTableCell[section].count : 0
        case .Discount: return isCouponSectionExpanded ? self.viewModel.sectionTableCell[section].count : 0
        case .Addons: return isAddonsExpended ? self.viewModel.sectionTableCell[section].count : 0
        default: return self.viewModel.sectionTableCell[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.viewModel.sectionHeader[indexPath.section]{
        case .CouponsAndWallet: return self.getHeightOfRowForFirstSection(indexPath)
        case .Taxes,.Discount,.Addons: return  20
        case .TotalPaybleAndTC: return self.getHeightOfRowForThirdSection(indexPath)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.sectionHeader[indexPath.section] {
        case .CouponsAndWallet:return self.getCellForCouponAndWalletSection(indexPath)
        case .Taxes: return self.getCellForTaxesSection(indexPath)
        case.Discount: return self.getCellForDiscountSection(indexPath)
        case .Addons: return self.getCellAddonsSection(indexPath)
        case .TotalPaybleAndTC: return self.getCellForTotalPaybleAndTCSection(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1, indexPath.section == 0 {
            AppFlowManager.default.presentHCCouponCodeVC(itineraryId: self.viewModel.itinerary.id, vc: self, couponCode: self.appliedCouponData.couponCode, product: "flights")
        }
    }
    
    func handleDiscountArrowAnimation(_ headerView: HotelFareSectionHeader) {
        let rotateTrans = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        switch self.viewModel.sectionHeader[headerView.tag]{
        case .Taxes:
            headerView.arrowButton.transform = (self.isTaxesAndFeeExpended) ? .identity : rotateTrans
        case .Discount:
            headerView.arrowButton.transform = (self.isCouponSectionExpanded) ? .identity : rotateTrans
        case .Addons:
            headerView.arrowButton.transform = (self.isAddonsExpended) ? .identity : rotateTrans
        default:break
        }
       
    }
    
}
//MARK:- Tableview cell,height,Headers
extension FlightPaymentVC{
    
    func getHeaderAddons(_ section:Int)-> UITableViewHeaderFooterView?{
        guard !self.viewModel.addonsData.isEmpty else {return nil}
        guard let headerView = self.checkOutTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? HotelFareSectionHeader, self.isCouponApplied else {
            return nil
        }
        headerView.grossFareTitleLabel.text = ""
        headerView.grossPriceLabel.text = ""
        headerView.tag = section
        headerView.delegate = self
        headerView.grossFareTitleTopConstraint.constant = 0
        self.handleDiscountArrowAnimation(headerView)
        headerView.discountsTitleLabel.text = "Addons"
        headerView.discountPriceLabel.text = "\(Double(self.viewModel.itinerary.details.fare.addons?.value ?? 0).amountInDelimeterWithSymbol)"
        return headerView
    }
    
    func getCellForCouponAndWalletSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.sectionTableCell[indexPath.section][indexPath.row] {
        case .EmptyCell:
            guard let emptyCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier, for: indexPath) as? EmptyTableViewCell else {
                printDebug("Cell not found")
                return UITableViewCell()
            }
            emptyCell.clipsToBounds = true
            return emptyCell
        case .CouponCell:
            guard let applyCouponCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: ApplyCouponTableViewCell.reusableIdentifier, for: indexPath) as? ApplyCouponTableViewCell else {
                printDebug("ApplyCouponTableViewCell not found")
                return UITableViewCell()
            }
            if self.isCouponApplied {
                if let discountBreakUp = self.appliedCouponData.discountsBreakup {
                    let saveAmount = discountBreakUp.CACB + discountBreakUp.CPD
                    applyCouponCell.appliedCouponLabel.text = LocalizedString.Save.localized + " " + Double(saveAmount).amountInDelimeterWithSymbol
                    applyCouponCell.couponView.isHidden = false
                    applyCouponCell.couponLabel.text = LocalizedString.CouponApplied.localized + self.appliedCouponData.couponCode
                }else{
                    applyCouponCell.appliedCouponLabel.text = LocalizedString.Save.localized 
                    applyCouponCell.couponView.isHidden = false
                    applyCouponCell.couponLabel.text = LocalizedString.CouponApplied.localized
                }
            } else {
                applyCouponCell.couponView.isHidden = true
                applyCouponCell.couponLabel.text = LocalizedString.ApplyCoupon.localized
            }
            //            applyCouponCell.delegate = self
            return applyCouponCell
        case .WalletCell:
            guard let walletCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.reusableIdentifier, for: indexPath) as? WalletTableViewCell else {
                printDebug("WalletTableViewCell not found")
                return UITableViewCell()
            }
            walletCell.clipsToBounds = true
            //            walletCell.delegate = self
            walletCell.walletSwitch.isOn = isWallet
            //            walletCell.amountLabel.text = self.getWalletAmount().amountInDelimeterWithSymbol
            return walletCell
        case .FareBreakupCell:
            
            guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: "FareBreakupCell") as? FareBreakupTableViewCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            let noAdult = (self.viewModel.itinerary.searchParams.adult.toInt == 0)
            cell.adultCountDisplayView.isHidden = noAdult
            cell.adultCountDisplayViewWidth.constant = noAdult ? 0 : 25
            cell.adultCountLabel.text = noAdult ? "" : self.viewModel.itinerary.searchParams.adult
            let noChild = (self.viewModel.itinerary.searchParams.child.toInt == 0)
            cell.childrenCountDisplayView.isHidden = noChild
            cell.childrenCountDisplayViewWidth.constant = (noChild) ? 0 : 35
            cell.childrenCountLabel.text = (noChild) ? "" : self.viewModel.itinerary.searchParams.child
            let noInfant = (self.viewModel.itinerary.searchParams.infant.toInt == 0)
            cell.infantCountDisplayView.isHidden = noInfant
            cell.infantCountDisplayViewWidth.constant = noInfant ? 0 : 35
            cell.infantCountLabel.text = noInfant ? "" : self.viewModel.itinerary.searchParams.infant
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func getCellForTaxesSection(_ indexPath: IndexPath)->UITableViewCell{
        
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: DiscountCell.reusableIdentifier, for: indexPath) as? DiscountCell else { return UITableViewCell()}
        let title = self.viewModel.taxAndFeesData[indexPath.row].name
        let amount = Double(self.viewModel.taxAndFeesData[indexPath.row].value).amountInDelimeterWithSymbol
        cell.configureCell(title: title, amount: amount)
        return cell
    }
    func getCellForDiscountSection(_ indexPath: IndexPath)->UITableViewCell{
        
        guard let couponDiscountCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: DiscountCell.reusableIdentifier, for: indexPath) as? DiscountCell else {
            printDebug("DiscountCell not found")
            return UITableViewCell()
        }
        if self.isCouponApplied, self.isCouponSectionExpanded {
            if let discountBreakUp = self.appliedCouponData.discountsBreakup {
                let saveAmount = discountBreakUp.CPD
                couponDiscountCell.amountLabel.text = "-" + Double(saveAmount).amountInDelimeterWithSymbol
                couponDiscountCell.clipsToBounds = true
            }
        } else {
            couponDiscountCell.clipsToBounds = true
            return UITableViewCell()
        }
        return couponDiscountCell
    }
    
    
    func getCellAddonsSection(_ indexPath: IndexPath)->UITableViewCell{
        
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: DiscountCell.reusableIdentifier, for: indexPath) as? DiscountCell else { return UITableViewCell()}
        let title = self.viewModel.addonsData[indexPath.row].name
        let amount = Double(self.viewModel.addonsData[indexPath.row].value).amountInDelimeterWithSymbol
        cell.configureCell(title: title, amount: amount)
        return cell
    }
    
    func getCellForTotalPaybleAndTCSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {

        case 0: // Convenience Fee Cell
            guard let convenieneCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WallletAmountCellTableViewCell.reusableIdentifier, for: indexPath) as? WallletAmountCellTableViewCell else {
                printDebug("WallletAmountCellTableViewCell not found")
                return UITableViewCell()
            }
            convenieneCell.walletAmountLabel.textColor = AppColors.themeBlack
            convenieneCell.aertripWalletTitleLabel.textColor = AppColors.themeBlack
            let amount = isWallet ? self.convenienceFeesWallet : self.convenienceRate
            if self.isConvenienceFeeApplied {
                convenieneCell.aertripWalletTitleLabel.text = LocalizedString.ConvenienceFee.localized
                convenieneCell.walletAmountLabel.text = amount.amountInDelimeterWithSymbol
                return convenieneCell
            } else {
                convenieneCell.clipsToBounds = true
                return UITableViewCell()
            }
            
            // return
            
        case 1: // Aertip Wallet Cell
            
            guard let walletAmountCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WallletAmountCellTableViewCell.reusableIdentifier, for: indexPath) as? WallletAmountCellTableViewCell else {
                printDebug("WallletAmountCellTableViewCell not found")
                return UITableViewCell()
            }
            walletAmountCell.callForReuse()
            if self.isWallet {
                var amount = Double(self.viewModel.itinerary.details.farepr)
                var amountFromWallet: Double = 0.0
                if self.isCouponApplied, let discountBreakUp = self.appliedCouponData.discountsBreakup {
                    amount -= discountBreakUp.CPD
                }
                if amount > 345.0{//self.getWalletAmount() {
                    amountFromWallet = 345.0//self.getWalletAmount()
                } else {
                    amountFromWallet = amount
                }
                walletAmountCell.walletAmountLabel.text = "-" + abs(amountFromWallet).amountInDelimeterWithSymbol
                walletAmountCell.clipsToBounds = true
                return walletAmountCell
            } else {
                walletAmountCell.clipsToBounds = true
                return UITableViewCell()
            }
            
        case 2: // Total pay now Cell
            guard let totalPayableNowCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TotalPayableNowCell.reusableIdentifier, for: indexPath) as? TotalPayableNowCell else {
                printDebug("TotalPayableNowCell not found")
                return UITableViewCell()
            }
            totalPayableNowCell.topDeviderView.isHidden = false
            totalPayableNowCell.bottomDeviderView.isHidden = false
            totalPayableNowCell.totalPriceLabel.text = Double(self.viewModel.itinerary.details.fare.totalPayableNow.value).amountInDelimeterWithSymbol //self.getTotalPayableAmount().amountInDelimeterWithSymbol
            return totalPayableNowCell
        case 3: // Convenience Fee message Cell
            guard let conveninceCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: ConvenienceFeeTableViewCell.reusableIdentifier, for: indexPath) as? ConvenienceFeeTableViewCell else {
                printDebug("ConvenienceFeeTableViewCell not found")
                return UITableViewCell()
            }
            let amount = self.isWallet ? self.convenienceFeesWallet : self.convenienceRate
            if self.isConvenienceFeeApplied {
                conveninceCell.convenienceFeeLabel.textColor = AppColors.themeBlack
                conveninceCell.convenienceFeeLabel.text = LocalizedString.convenienceFee1.localized + " \(amount.amountInDelimeterWithSymbol) " + LocalizedString.convenienceFee2.localized
                return conveninceCell
            } else {
                conveninceCell.clipsToBounds = true
                return UITableViewCell()
            }
            
        case 4: // Final Amount Message cell
            guard let finalAmountCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: FinalAmountTableViewCell.reusableIdentifier, for: indexPath) as? FinalAmountTableViewCell else {
                printDebug("FinalAmountTableViewCell not found")
                return UITableViewCell()
            }
            if self.isCouponApplied {
                if /*let netAmount = self.viewModel.itinaryPriceDetail?.netAmount, */let discountBreakUp = self.appliedCouponData.discountsBreakup {
                    // Net Effective fare
                    let netAmount = "\(self.viewModel.itinerary.details.farepr)"
                    let effectiveFare = abs(netAmount.toDouble ?? 0.0 - discountBreakUp.CPD)
                    finalAmountCell.payableWalletMessageLabel.text = Double(discountBreakUp.CACB).amountInDelimeterWithSymbol + LocalizedString.PayableWalletMessage.localized
                    finalAmountCell.netEffectiveFareLabel.text = LocalizedString.NetEffectiveFare.localized + "\(effectiveFare.amountInDelimeterWithSymbol)"
                }
                finalAmountCell.clipsToBounds = true
                return finalAmountCell
            } else {
                finalAmountCell.clipsToBounds = true
                return UITableViewCell()
            }
            
        case 5: // Term and privacy Cell
            guard let termAndPrivacCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TermAndPrivacyTableViewCell.reusableIdentifier, for: indexPath) as? TermAndPrivacyTableViewCell else {
                return UITableViewCell()
            }
            return termAndPrivacCell
        default:
            return UITableViewCell()
        }
    }
    
    func getHeightOfRowForFirstSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 2: // Empty Cell
            return 35.0
        case 4: // Empty Cell
            return (UserInfo.loggedInUser != nil) ? 35.0 : 0.0
        case 1: // Apply Coupon Cell
            return 44.0
        case 3: // Pay by Wallet Cell
            return (UserInfo.loggedInUser != nil) ? 75.0 : 0.0
            //        case 5: // Fare Detail Cell
        //            return 80.0
        default:
            return 44 // Default Height Cell
        }
    }
    
    func getHeightOfRowForThirdSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: // Convenince Fee Cell
            if self.isConvenienceFeeApplied {
                return 36.0
            } else {
                return 0.0
            }
            
        case 1: // Wallet amount Cell
            if self.isWallet {
                return 40.0
            } else {
                return 0.0
            }
        case 2: // total amount Cell
            return 46.0
            
        case 3: // Convenience Cell Message
            if self.isConvenienceFeeApplied {
                return 46.0
            } else {
                return 0.0
            }
        case 4: // Final amount message table view Cell
            if self.isCouponApplied {
                return 87.0
            } else {
                return 0
            }
        case 5: // term and privacy cell
            return 115.0
        default:
            return 44
        }
    }
    
    
}
//MARK: Navigation view back button tapped
extension FlightPaymentVC : TopNavigationViewDelegate, HotelFareSectionHeaderDelegate{
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func headerViewTapped(_ view:UITableViewHeaderFooterView){
        checkOutTableView.beginUpdates()
        switch self.viewModel.sectionHeader[view.tag]{
            
        case .Taxes: self.isTaxesAndFeeExpended = !self.isTaxesAndFeeExpended
        case .Discount: self.isCouponSectionExpanded = !self.isCouponSectionExpanded
        case .Addons: self.isAddonsExpended = !self.isAddonsExpended
        default: break;
        }
        self.checkOutTableView.reloadSections([view.tag], with: .automatic)
        checkOutTableView.endUpdates()
    }
}


//MARK:- Coupon selection delegate
extension FlightPaymentVC: HCCouponCodeVCDelegate {
    func appliedCouponData(_ appliedCouponData: HCCouponAppliedModel) {
        printDebug(appliedCouponData)
        self.appliedCouponData = appliedCouponData
        self.isCouponApplied = true
//        delay(seconds: 0.3) { [weak self] in
//            self?.updateAllData()
//        }
    }
}

extension FlightPaymentVC:FlightPaymentVMDelegate{
    
    func fetchingItineraryData() {
        AppGlobals.shared.startLoading()
        self.updateAllData()
    }
    
    func responseFromIteneraryData(success: Bool, error: Error?) {
        AppGlobals.shared.stopLoading()
        if success{
            self.updateAllData()
        }
    }
    
}

