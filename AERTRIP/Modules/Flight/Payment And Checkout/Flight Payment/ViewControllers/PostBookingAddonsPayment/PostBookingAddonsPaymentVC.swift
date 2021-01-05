//
//  PostBookingAddonsPaymentVC.swift
//  AERTRIP
//
//  Created by Apple  on 18.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import Razorpay

class PostBookingAddonsPaymentVC: BaseVC{
    
    
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
    var gradientColors: [UIColor] = AppConstants.appthemeGradientColors {
        didSet {
            self.viewDidLayoutSubviews()
        }
    }
    
    var disabledGradientColors: [UIColor] = AppConstants.appthemeDisableGradientColors {
        didSet {
            self.viewDidLayoutSubviews()
        }
    }
    
    var viewModel = PostBookingAddonsPaymentVM()
    var convenienceRate: Double = 0
    var convenienceFeesWallet: Double = 0
    // Boolean to check if convenienceFeeToAppliedOrNot
    var isConvenienceFeeApplied: Bool = false
    var isSeatExpended = true
    var isMealExpended = true
    var isOtherExpended = true
    var isBaggageExpended = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.taxesDataDisplay()
        self.getPaymentsMethodsSuccess()
        self.checkOutTableView.separatorStyle = .none
        self.checkOutTableView.dataSource = self
        self.checkOutTableView.delegate = self
        self.viewModel.delegate = self
        self.addFooterView()
        self.payButton.addGredient(isVertical: false)
        self.setUpNavigationView()
        self.registerXib()
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
        hideShowLoader(isHidden: false)
        self.viewModel.makePayment(forAmount: self.getTotalPayableAmount(), useWallet: self.isWallet)
    }
    
//    func checkForWalletOTP(){
//        if (self.isWallet && self.getWalletAmount() > 100) && (UserInfo.loggedInUser?.isWalletEnable ?? false){
//            let vc = OTPVarificationVC.instantiate(fromAppStoryboard: .OTPAndVarification)
//            vc.modalPresentationStyle = .overFullScreen
//            vc.viewModel.itId = self.viewModel.appliedCouponData.itinerary.id
//            vc.viewModel.varificationType = .walletOtp
//            vc.delegate = self
//            self.present(vc, animated: true, completion: nil)
//        }else{
//            self.viewModel.makePayment(forAmount: self.getTotalPayableAmount(), useWallet: self.isWallet)
//        }
//    }
    
    
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
        self.topNavView.configureNavBar(title: LocalizedString.CheckoutTitle.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: true)
        self.topNavView.isHidden = false
    }
    
    private func setupPayButton() {
        self.payButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        self.payButton.setImage(#imageLiteral(resourceName: "whiteBlackLockIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        self.payButton.setImage(#imageLiteral(resourceName: "whiteBlackLockIcon").withRenderingMode(.alwaysOriginal), for: .highlighted)
        if self.payButton.imageView != nil{
            self.payButton.bringSubviewToFront(self.payButton.imageView!)
        }
        self.payButton.spaceInTextAndImageOfButton(spacing: 2)
        self.payButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.setupPayButtonTitle()
        
    }
    
    func setupPayButtonTitle(){
        let ttl = self.getTotalPayableAmount().amountInDelimeterWithSymbol
        let amount = ttl.asStylizedPrice(using: AppFonts.SemiBold.withSize(20.0))
        amount.addAttributes([.foregroundColor : AppColors.themeWhite], range: NSString(string: ttl).range(of: ttl))
        let attributedTitle = NSMutableAttributedString(string: "  \(LocalizedString.Pay.localized) ", attributes: [.font: AppFonts.SemiBold.withSize(20), .foregroundColor: AppColors.themeWhite])
        attributedTitle.append(amount)
        self.payButton.setAttributedTitle(attributedTitle, for: .normal)
        self.payButton.setAttributedTitle(attributedTitle, for: .highlighted)
    }
    
    private func manageLoader() {
        self.activityLoader.style = .medium//.white
        self.activityLoader.color = AppColors.themeWhite
        self.activityLoader.startAnimating()
        self.loaderView.addGredient(isVertical: false)
        self.loaderView.isHidden = true
    }
    
    func hideShowLoader(isHidden:Bool){
        DispatchQueue.main.async {
            if isHidden{
                self.activityLoader.stopAnimating()
            }else{
                self.activityLoader.startAnimating()
            }
            self.view.isUserInteractionEnabled = isHidden
            self.loaderView.isHidden = isHidden
        }
    }
    
    private func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 23))
        customView.backgroundColor = AppColors.themeGray04
        self.checkOutTableView.tableFooterView = customView
    }
    
    
    
    func updateAllData(){
        self.checkOutTableView.reloadData()
        self.setupPayButtonTitle()
    }
    
    
//    func getListingController(){
//        if let nav = self.navigationController?.presentingViewController?.presentingViewController as? UINavigationController{
//            nav.dismiss(animated: true) {
//                delay(seconds: 0.0) {
//                    if let vc = nav.viewControllers.first(where: {$0.isKind(of: FlightResultBaseViewController.self)}) as? FlightResultBaseViewController{
//                        nav.popToViewController(vc, animated: true)
//                        vc.searchApiResult(chnageData: self.viewModel.baggageData)
//                    }
//                }
//            }
//        }
//    }
    
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
    
    // Get Available Wallet Amount
    func getWalletAmount() -> Double {
//        if let walletAmount = Double(self.viewModel.addonsDetails.walletBalance) {
            return Double(self.viewModel.addonsDetails.walletBalance)
//        } else {
//            return 0
//        }
    }
    
    // Get Total Payable Amount based on conditions
    private func getTotalPayableAmount() -> Double {
        var payableAmount: Double = Double(self.viewModel.addonsDetails.netAmount)
        if payableAmount > 0.0 {
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
    
}


//MARK: Navigation view back button tapped
extension PostBookingAddonsPaymentVC : TopNavigationViewDelegate, HotelFareSectionHeaderDelegate{
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func headerViewTapped(_ view:UITableViewHeaderFooterView){
        checkOutTableView.beginUpdates()
        switch self.viewModel.sectionHeader[view.tag]{
        case .Meal: self.isMealExpended = !self.isMealExpended
        case .Seat: self.isSeatExpended = !self.isSeatExpended
        case .Baggage: self.isBaggageExpended = !self.isBaggageExpended
        case .Other: self.isOtherExpended = !self.isOtherExpended
        default: break;
        }
        self.checkOutTableView.reloadSections([view.tag], with: .automatic)
        checkOutTableView.endUpdates()
    }
}


extension PostBookingAddonsPaymentVC:PostBookingAddonsPaymentVMDelegate{
    
    func willMakePayment() {
        hideShowLoader(isHidden: false)
    }
    
    func getPaymentsMethodsSuccess(){
//        if
        let razorPay = self.viewModel.addonsDetails.paymentModes.razorPay //{
            self.convenienceRate = razorPay.convenienceFees
            self.convenienceFeesWallet = razorPay.convenienceFeesWallet > 0 ? razorPay.convenienceFeesWallet : 0
            self.setConvenienceFeeToBeApplied()
//        }
        self.isWallet = self.getWalletAmount() > 0
        
        self.updateAllData()
    }
    func getPaymentMethodsFails(errors: ErrorCodes){
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .flights)
        hideShowLoader(isHidden: true)
    }
    
    func makePaymentSuccess(options: JSONDictionary, shouldGoForRazorPay: Bool) {
        hideShowLoader(isHidden: false)
        if shouldGoForRazorPay {
            self.initializePayment(withOptions: options)
        } else {
            // payment successfully made through wallet, send to the You are all done
            if let bIds = options[APIKeys.id.rawValue] as? String {
                self.getPaymentResonseSuccess(bookingIds: [bIds], cid: [])
            } else if let cIds = options[APIKeys.cid.rawValue] as? [String] {
                self.getPaymentResonseSuccess(bookingIds: [], cid: cIds)
            }
        }
    }
    
    func makePaymentFail(error: ErrorCodes) {
        hideShowLoader(isHidden: true)
//        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
        AppToast.default.showToastMessage(message: "Make Payment Failed")
    }
    
    func willGetPaymentResonse() {
        hideShowLoader(isHidden: false)
    }
    
    func getPaymentResonseSuccess(bookingIds: [String], cid: [String]) {
        // send to you are all done screen
//        hideShowLoader(isHidden: true)
//        print(bookingIds)
        let vc = PostBookingAddonsPaymentStatusVC.instantiate(fromAppStoryboard: .FlightPayment)
        vc.viewModel.bookingIds = self.viewModel.bookingIds
        vc.viewModel.itId = self.viewModel.addonsDetails.id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getPaymentResonseFail(error: ErrorCodes) {
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .payment)
        hideShowLoader(isHidden: true)
    }
    
    
}


extension PostBookingAddonsPaymentVC : WalletTableViewCellDelegate {
    func valueForSwitch(isOn: Bool) {
        self.isWallet = (getWalletAmount() <= 0) ? false : isOn
        self.setConvenienceFeeToBeApplied()
    }
}


extension PostBookingAddonsPaymentVC : RazorpayPaymentCompletionProtocolWithData {
    
    func initializePayment(withOptions options: JSONDictionary) {
        let razorpay: RazorpayCheckout = RazorpayCheckout.initWithKey(AppKeys.kRazorpayPublicKey, andDelegateWithData: self)
        //razorpay.open(options)
        razorpay.open(options, displayController: self)
    }
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        hideShowLoader(isHidden: true)
        AppToast.default.showToastMessage(message: LocalizedString.paymentFails.localized)//"Sorry! payment was faild.\nPlease try again.")
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        //payment success by razorpay
        if let res = response as? JSONDictionary {
            self.viewModel.getPaymentResonse(forData: res, isRazorPayUsed: true)
        }
    }
}




//MARK:- Tableview delegate and datasource.
extension PostBookingAddonsPaymentVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionTableCell.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch self.viewModel.sectionHeader[section]{
        case .CouponsAndWallet, .TotalPaybleAndTC: return nil
        default: return self.getHeaderAddons(section)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.viewModel.sectionHeader[section]{
        case .CouponsAndWallet, .TotalPaybleAndTC: return CGFloat.leastNonzeroMagnitude
        case .Meal: return self.viewModel.mealData.isEmpty ? CGFloat.leastNonzeroMagnitude : 27
        case .Seat: return self.viewModel.seatData.isEmpty ? CGFloat.leastNonzeroMagnitude : 27
        case .Baggage: return self.viewModel.baggageData.isEmpty ? CGFloat.leastNonzeroMagnitude : 27
        case .Other: return self.viewModel.otherData.isEmpty ? CGFloat.leastNonzeroMagnitude : 27
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.viewModel.sectionHeader[section]{
        case .Meal: return isMealExpended ? self.viewModel.sectionTableCell[section].count : 0
        case .Seat: return isSeatExpended ? self.viewModel.sectionTableCell[section].count : 0
        case .Baggage: return isBaggageExpended ? self.viewModel.sectionTableCell[section].count : 0
        case .Other: return isOtherExpended ? self.viewModel.sectionTableCell[section].count : 0
        default: return self.viewModel.sectionTableCell[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.viewModel.sectionHeader[indexPath.section]{
        case .CouponsAndWallet: return self.getHeightOfRowForFirstSection(indexPath)
        case .TotalPaybleAndTC: return self.getHeightOfRowForThirdSection(indexPath)
        default: return 20
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.sectionHeader[indexPath.section] {
        case .CouponsAndWallet:return self.getCellForCouponAndWalletSection(indexPath)
        case .TotalPaybleAndTC: return self.getCellForTotalPaybleAndTCSection(indexPath)
        default: return self.getCellAddonsSection(indexPath)
        }
    }
    
    func handleDiscountArrowAnimation(_ headerView: HotelFareSectionHeader) {
        let rotateTrans = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        switch self.viewModel.sectionHeader[headerView.tag]{
        case .Seat:
            headerView.arrowButton.transform = (self.isSeatExpended) ? .identity : rotateTrans
        case .Meal:
            headerView.arrowButton.transform = (self.isMealExpended) ? .identity : rotateTrans
        case .Baggage:
            headerView.arrowButton.transform = (self.isBaggageExpended) ? .identity : rotateTrans
        case .Other:
            headerView.arrowButton.transform = (self.isOtherExpended) ? .identity : rotateTrans
        default:break
        }
    }
    
}
//MARK:- Tableview cell,height,Headers
extension PostBookingAddonsPaymentVC{
    
    func getHeaderAddons(_ section:Int)-> UITableViewHeaderFooterView?{
        guard let headerView = self.checkOutTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? HotelFareSectionHeader else {
            return nil
        }
        headerView.grossFareTitleLabel.text = ""
        headerView.grossPriceLabel.text = ""
        headerView.tag = section
        headerView.delegate = self
        headerView.grossFareTitleTopConstraint.constant = 0
        self.handleDiscountArrowAnimation(headerView)
        headerView.arrowButton.isUserInteractionEnabled = false
        
        switch self.viewModel.sectionHeader[section] {
        case .Seat:
            if !self.viewModel.seatData.isEmpty{
                headerView.discountsTitleLabel.text = "Seat"
                headerView.discountPriceLabel.text = "\(Double(self.viewModel.addonsDetails.details.addonsSum["seat"] ?? 0).amountInDelimeterWithSymbol)"
            }else{
                return nil
            }
        case .Meal:
            if !self.viewModel.mealData.isEmpty{
                headerView.discountsTitleLabel.text = "Meal"
                headerView.discountPriceLabel.text = "\(Double(self.viewModel.addonsDetails.details.addonsSum["meal"] ?? 0).amountInDelimeterWithSymbol)"
            }else{
                return nil
            }
        case .Baggage:
            if !self.viewModel.baggageData.isEmpty{
                headerView.discountsTitleLabel.text = "Baggage"
                headerView.discountPriceLabel.text = "\(Double(self.viewModel.addonsDetails.details.addonsSum["baggage"] ?? 0).amountInDelimeterWithSymbol)"
            }else{
                return nil
            }
        case .Other:
            if !self.viewModel.otherData.isEmpty{
                headerView.discountsTitleLabel.text = "Other"
                headerView.discountPriceLabel.text = "\(Double(self.viewModel.addonsDetails.details.addonsSum["special"] ?? 0).amountInDelimeterWithSymbol)"
            }else{
                return nil
            }
        default:return nil
        }
        return headerView
    }
    
    
    
    func getHeightOfRowForFirstSection(_ indexPath: IndexPath) -> CGFloat {
        switch self.viewModel.sectionTableCell[indexPath.section][indexPath.row] {
        case .EmptyCell:
            return 35.0
        case .WalletCell:
            return 75.0
        case .FareBreakupCell:
            return 44.0
        default: return UITableView.automaticDimension
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
        case 3: // term and privacy cell
            return 60.0//115.0
        default:
            return 44
        }
    }
}

extension PostBookingAddonsPaymentVC{
    
    func getCellForCouponAndWalletSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.sectionTableCell[indexPath.section][indexPath.row] {
        case .EmptyCell:
            guard let emptyCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier, for: indexPath) as? EmptyTableViewCell else {
                printDebug("Cell not found")
                return UITableViewCell()
            }
            emptyCell.clipsToBounds = true
            return emptyCell
        case .WalletCell:
            guard let walletCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.reusableIdentifier, for: indexPath) as? WalletTableViewCell else {
                printDebug("WalletTableViewCell not found")
                return UITableViewCell()
            }
            walletCell.clipsToBounds = true
            walletCell.delegate = self
            walletCell.walletSwitch.isOn = isWallet
            walletCell.amountLabel.text = self.getWalletAmount().amountInDelimeterWithSymbol
            return walletCell
        case .FareBreakupCell:
            
            guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: "FareBreakupCell") as? FareBreakupTableViewCell else {return UITableViewCell()}
            cell.titleLabel.text = "Add-ons Breakup"
            cell.selectionStyle = .none
            cell.adultCountDisplayView.isHidden = true
            cell.adultCountDisplayViewWidth.constant =  0
            cell.adultCountLabel.text = ""
            cell.childrenCountDisplayView.isHidden = true
            cell.childrenCountDisplayViewWidth.constant = 0
            cell.childrenCountLabel.text =  ""
            cell.infantCountDisplayView.isHidden = true
            cell.infantCountDisplayViewWidth.constant = 0
            cell.infantCountLabel.text = ""
            return cell
        default:
            return UITableViewCell()
        }
    }

    func getCellAddonsSection(_ indexPath: IndexPath)->UITableViewCell{
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: DiscountCell.reusableIdentifier, for: indexPath) as? DiscountCell else { return UITableViewCell()}
        let title:NSAttributedString
        let amount:String
        switch self.viewModel.sectionHeader[indexPath.section] {
        case .Seat:
            title = self.viewModel.seatData[indexPath.row].fligtRoute
            amount = (Double(self.viewModel.seatData[indexPath.row].addonsDetails.price) ?? 0.0).amountInDelimeterWithSymbol
        case .Meal:
            title = self.viewModel.mealData[indexPath.row].fligtRoute
            amount = (Double(self.viewModel.mealData[indexPath.row].addonsDetails.price) ?? 0.0).amountInDelimeterWithSymbol
        case .Baggage:
            title = self.viewModel.baggageData[indexPath.row].fligtRoute
            amount = (Double(self.viewModel.baggageData[indexPath.row].addonsDetails.price) ?? 0.0).amountInDelimeterWithSymbol
        case .Other:
            title = self.viewModel.otherData[indexPath.row].fligtRoute
            amount = (Double(self.viewModel.otherData[indexPath.row].addonsDetails.price) ?? 0.0).amountInDelimeterWithSymbol
        default:
            title = NSAttributedString(string: "")
            amount = ""
        }
        cell.configureForAddons(title: title, amount: amount)
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
        case 1: // Aertip Wallet Cell
            
            guard let walletAmountCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WallletAmountCellTableViewCell.reusableIdentifier, for: indexPath) as? WallletAmountCellTableViewCell else {
                printDebug("WallletAmountCellTableViewCell not found")
                return UITableViewCell()
            }
            walletAmountCell.callForReuse()
            if self.isWallet {
                let amount = Double(self.viewModel.addonsDetails.netAmount)
                var amountFromWallet: Double = 0.0
                if amount > self.getWalletAmount() {
                    amountFromWallet = self.getWalletAmount()
                } else {
                    amountFromWallet = amount
                }
                walletAmountCell.walletAmountLabel.text = "-" + abs(amountFromWallet).amountInDelimeterWithSymbol
                walletAmountCell.clipsToBounds = true
                walletAmountCell.labelTopConstraint.constant = 0.0
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
            totalPayableNowCell.bottomDeviderView.isHidden = true
            totalPayableNowCell.totalPayableTextTopConstraint.constant = 12.0
            totalPayableNowCell.totalPayableTextBottomConstraint.constant = 12.0
            totalPayableNowCell.totalPriceLabel.attributedText = self.getTotalPayableAmount().amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
            return totalPayableNowCell
        case 3:
            guard let termAndPrivacCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TermAndPrivacyTableViewCell.reusableIdentifier, for: indexPath) as? TermAndPrivacyTableViewCell else {
                return UITableViewCell()
            }
             termAndPrivacCell.currentUsingFrom = .flightCheckOut
            return termAndPrivacCell
        default:
            return UITableViewCell()
        }
    }
    
}


