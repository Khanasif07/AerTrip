//
//  FlightPaymentVC.swift
//  AERTRIP
//
//  Created by Apple  on 03.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import Razorpay

class FlightPaymentVC: BaseVC {

    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var checkOutTableView: ATTableView!{
        didSet{
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
    var isWallet: Bool = false // To check if using wallet or Not
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
    
    var viewModel = FlightPaymentVM()
    private var isReloadingAfterFareDipOrIncrease: Bool = false
    // Boolean to check whether coupon is applied or Not
    var isCouponApplied: Bool = false
    var previousAppliedCoupon: HCCouponModel?
    var convenienceRate: Double = 0
    var convenienceFeesWallet: Double = 0
    // Boolean to check if convenienceFeeToAppliedOrNot
    var isConvenienceFeeApplied: Bool = false
    // Boolean to handle  coupon view expanded or not , By Default will be expanded
    var isCouponSectionExpanded: Bool = false
    //Is taxes and fee expended
    var isTaxesAndFeeExpended = false
    var isAddonsExpended = false
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkOutTableView.contentInset = UIEdgeInsets(top: topNavView.height - 1, left: 0, bottom: 0, right: 0)
        self.viewModel.taxesDataDisplay()
        self.checkOutTableView.separatorStyle = .none
        self.viewModel.taxesDataDisplay()
        self.checkOutTableView.dataSource = self
        self.checkOutTableView.delegate = self
        self.viewModel.delegate = self
        self.viewModel.webServiceGetPaymentMethods(isWalletChnaged: false)
//        self.viewModel.getItineraryData()
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
        self.hideShowLoader(isHidden:false)
        self.viewModel.reconfirmationAPI()
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
        if self.getTotalPayableAmount() != 0.0{
            let ttl = self.getTotalPayableAmount().amountInDelimeterWithSymbol
            let amount = ttl.asStylizedPrice(using: AppFonts.SemiBold.withSize(20.0))
            amount.addAttributes([.foregroundColor : AppColors.themeWhite], range: NSString(string: ttl).range(of: ttl))
            let attributedTitle = NSMutableAttributedString(string: "  \(LocalizedString.Pay.localized) ", attributes: [.font: AppFonts.SemiBold.withSize(20), .foregroundColor: AppColors.themeWhite])
            attributedTitle.append(amount)
            self.payButton.setTitle(nil, for: .normal)
            self.payButton.setTitle(nil, for: .highlighted)
            self.payButton.setImage(#imageLiteral(resourceName: "whiteBlackLockIcon").withRenderingMode(.alwaysOriginal), for: .normal)
            self.payButton.setImage(#imageLiteral(resourceName: "whiteBlackLockIcon").withRenderingMode(.alwaysOriginal), for: .highlighted)
            self.payButton.setAttributedTitle(attributedTitle, for: .normal)
            self.payButton.setAttributedTitle(attributedTitle, for: .highlighted)
        }else{
            self.payButton.setImage(nil, for: .normal)
            self.payButton.setImage(nil, for: .highlighted)
            self.payButton.setAttributedTitle(nil, for: .normal)
            self.payButton.setAttributedTitle(nil, for: .highlighted)
            self.payButton.setTitle(LocalizedString.ConfirmBooking.localized, for: .normal)
            self.payButton.setTitle(LocalizedString.ConfirmBooking.localized, for: .highlighted)
        }
    }
    
    private func manageLoader() {
        self.activityLoader.style = .medium//.white
        self.activityLoader.color = AppColors.themeWhite
        self.activityLoader.startAnimating()
        self.loaderView.addGredient(isVertical: false)
        self.hideShowLoader(isHidden:true)
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
    
    func updateConvenienceFee(){
        if let razorPay = self.viewModel.paymentDetails?.paymentModes.razorPay {
            self.convenienceRate = razorPay.convenienceFees
            self.convenienceFeesWallet = razorPay.convenienceFeesWallet > 0 ? razorPay.convenienceFeesWallet : 0
            self.setConvenienceFeeToBeApplied()
        }
    }
    
    private func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 23))
        customView.backgroundColor = AppColors.themeGray04
        self.checkOutTableView.tableFooterView = customView
    }
    
    private func getAppliedCoupons() {
        if self.viewModel.appliedCouponData.isCouponAppied ?? false{
            var coupon = HCCouponModel()
            coupon.isCouponApplied = true
            coupon.couponCode = self.viewModel.appliedCouponData.couponCode ?? ""
            coupon.discountBreakUp = self.viewModel.appliedCouponData.discountsBreakup
            self.previousAppliedCoupon = coupon
        }
        
        if self.previousAppliedCoupon != nil {
            self.viewModel.appliedCouponData.isCouponAppied = self.previousAppliedCoupon?.isCouponApplied ?? false
            self.viewModel.appliedCouponData.discountsBreakup = self.previousAppliedCoupon?.discountBreakUp
            self.viewModel.appliedCouponData.couponCode = self.previousAppliedCoupon?.couponCode ?? ""
            self.isCouponApplied = true
            self.updateAllData()
        }
    }
    
    
    func updateAllData(){
        self.checkOutTableView.reloadData()
        self.setupPayButtonTitle()
    }
    
    func showFareUpdatePopup(){
        let diff = self.viewModel.itinerary.priceChange
        let amount = self.viewModel.itinerary.details.farepr
        if diff != 0{
            self.viewModel.taxesDataDisplay()
            self.updateAllData()
        }
        if diff > 0 {
            // increased
            self.view.isUserInteractionEnabled = true
            FareUpdatedPopUpVC.showPopUp(isForIncreased: true, decreasedAmount: 0.0, increasedAmount: Double(diff), totalUpdatedAmount: Double(amount), continueButtonAction: { [weak self] in
                guard let self = self else { return }
                self.view.isUserInteractionEnabled = false
//                self.viewModel.makePayment(forAmount: self.getTotalPayableAmount(), useWallet: self.isWallet)
                self.checkForWalletOTP()
                }, goBackButtonAction: { [weak self] in
                    guard let self = self else { return }
                    self.getListingController()
            })
        }
        else if diff < 0{
            // dipped
            FareUpdatedPopUpVC.showPopUp(isForIncreased: false, decreasedAmount: Double(-diff), increasedAmount: 0, totalUpdatedAmount: 0, continueButtonAction: nil, goBackButtonAction: nil)
//            delay(seconds: 5.0) { [weak self] in
//                guard let self = self else { return }
//            }
        }else{
            self.checkForWalletOTP()
//            self.viewModel.makePayment(forAmount: self.getTotalPayableAmount(), useWallet: self.isWallet)
        }
    }
    
    
    func checkForWalletOTP(){
        if (self.isWallet && self.getWalletAmount() > 100) && (UserInfo.loggedInUser?.isWalletEnable ?? false){
            let vc = OTPVarificationVC.instantiate(fromAppStoryboard: .OTPAndVarification)
            vc.modalPresentationStyle = .overFullScreen
            vc.viewModel.itId = self.viewModel.appliedCouponData.itinerary.id
            vc.viewModel.varificationType = .walletOtp
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }else{
            self.viewModel.makePayment(forAmount: self.getTotalPayableAmount(), useWallet: self.isWallet)
        }
    }
    
    
    func getListingController(){
        if let nav = self.navigationController?.presentingViewController?.presentingViewController as? UINavigationController{
            nav.dismiss(animated: true) {
                delay(seconds: 0.0) {
                    if let vc = nav.viewControllers.first(where: {$0.isKind(of: FlightResultBaseViewController.self)}) as? FlightResultBaseViewController{
//                        nav.popToViewController(vc, animated: true)
                        vc.searchApiResult(flightItinary: self.viewModel.appliedCouponData)
                    }
                }
            }
        }
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
    
    // Get Available Wallet Amount
    func getWalletAmount() -> Double {
        if let walletAmount = self.viewModel.paymentDetails?.paymentDetails.wallet {
            return walletAmount.roundTo(places: 2)
        } else {
            return 0
        }
    }
    
    // Get Total Payable Amount based on conditions
    func getTotalPayableAmount() -> Double {
        var payableAmount: Double = Double(self.viewModel.itinerary.details.fare.totalPayableNow.value)
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
extension FlightPaymentVC: FlightCouponCodeVCDelegate {
    func appliedCouponData(_ appliedCouponData: FlightItineraryData) {
        self.viewModel.appliedCouponData = appliedCouponData
        self.isCouponApplied = self.viewModel.appliedCouponData.isCouponAppied ?? false
        self.viewModel.taxesDataDisplay()
        self.viewModel.webServiceGetPaymentMethods(isWalletChnaged: true)
//        self.viewModel.updateConvenienceFee()
//        self.updateConvenienceFee()
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
    
    func responseFromIteneraryData(success: Bool, error: ErrorCodes) {
        AppGlobals.shared.stopLoading()
        if success{
            self.updateAllData()
        }else{
            AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
        }
    }
    
    func willGetPaymetMenthods(){
        self.hideShowLoader(isHidden: false)
    }
    
    func getPaymentsMethodsSuccess(_ isWalletChnaged: Bool){
        self.hideShowLoader(isHidden: true)
        self.updateConvenienceFee()
        if !isWalletChnaged{
            self.isWallet = self.getWalletAmount() > 0
        }
        self.updateAllData()
    }
    func getPaymentMethodsFails(error: ErrorCodes){
        self.hideShowLoader(isHidden: true)
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
    }
    
    func removeCouponCodeSuccessful(_ appliedCouponData: FlightItineraryData){
        self.viewModel.isApplyingCoupon = false
        self.view.isUserInteractionEnabled = true
        self.viewModel.appliedCouponData = appliedCouponData
        self.isCouponApplied = false
        self.viewModel.taxesDataDisplay()
        self.viewModel.webServiceGetPaymentMethods(isWalletChnaged: true)
//        self.viewModel.updateConvenienceFee()
//        self.updateConvenienceFee()
//        self.updateAllData()
        printDebug(appliedCouponData)
    }
    
    func removeCouponCodeFailed(error: ErrorCodes) {
        self.viewModel.isApplyingCoupon = false
        self.view.isUserInteractionEnabled = true
        self.checkOutTableView.reloadData()
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
    }
    
    func reconfirmationResponse(_ success:Bool, error: ErrorCodes){
        if success{
            self.showFareUpdatePopup()
        }else{
            self.hideShowLoader(isHidden:true)
            AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
        }
    }
    
    func willMakePayment() {
        self.hideShowLoader(isHidden:false)
    }
    
    func makePaymentSuccess(options: JSONDictionary, shouldGoForRazorPay: Bool) {
        self.hideShowLoader(isHidden:false)
        if shouldGoForRazorPay {
            self.initializePayment(withOptions: options)
        } else {
            // payment successfully made through wallet, send to the You are all done
            if let bIds = options[APIKeys.booking_id.rawValue] as? [String] {
                self.getPaymentResonseSuccess(bookingIds: bIds, cid: [])
            } else if let cIds = options[APIKeys.cid.rawValue] as? [String] {
                self.getPaymentResonseSuccess(bookingIds: [], cid: cIds)
            }
        }
    }
    
    func makePaymentFail(error: ErrorCodes) {
        self.hideShowLoader(isHidden:true)
        if ((error.first ?? 0) != 2){
            AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .payment)
        }else{
            AppFlowManager.default.moveToPaymentAmountHigh()
//            let vc = OnlinePaymentLimitVC.instantiate(fromAppStoryboard: .FlightPayment)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func willGetPaymentResonse() {
        self.hideShowLoader(isHidden:false)
    }
    
    func getPaymentResonseSuccess(bookingIds: [String], cid: [String]) {
        // send to you are all donr screen
       self.hideShowLoader(isHidden:true)
        printDebug(bookingIds)
        let vc = FlightPaymentBookingStatusVC.instantiate(fromAppStoryboard: .FlightPayment)
        vc.viewModel.apiBookingIds = bookingIds
        vc.viewModel.itId = self.viewModel.itinerary.id
        vc.viewModel.bookingObject = self.viewModel.bookingObject
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getPaymentResponseWithPendingPayment(_ p: String, id: String) {
        self.viewModel.getItineraryDetails(with: id){[weak self] (success, data, error) in
            guard let self = self else {return}
            if let data = data{
                let vc = FlightPaymentPendingVC.instantiate(fromAppStoryboard: .FlightPayment)
                vc.viewModel.itId = id
                vc.viewModel.itinerary = data
                vc.viewModel.product = .flight
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.hideShowLoader(isHidden: true)
                self.view.isUserInteractionEnabled = true
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
            }
        }
    }
    
    func getPaymentResonseFail(error: ErrorCodes) {
        self.hideShowLoader(isHidden:true)
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
    }
      
    
}


extension FlightPaymentVC : WalletTableViewCellDelegate {
    func valueForSwitch(isOn: Bool) {
        self.isWallet = (getWalletAmount() <= 0) ? false : isOn
        self.setConvenienceFeeToBeApplied()
    }
}

extension FlightPaymentVC : ApplyCouponTableViewCellDelegate {
    func removeCouponTapped() {
        printDebug("Remove coupon tapped")
        self.viewModel.isApplyingCoupon = true
        self.view.isUserInteractionEnabled = false
        self.checkOutTableView.reloadData()
        self.viewModel.removeCouponCode()
    }
}

extension FlightPaymentVC : RazorpayPaymentCompletionProtocolWithData {
    
    func initializePayment(withOptions options: JSONDictionary) {
        let razorpay: RazorpayCheckout = RazorpayCheckout.initWithKey(AppKeys.kRazorpayPublicKey, andDelegateWithData: self)
        //razorpay.open(options)
        razorpay.open(options, displayController: self)
    }
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        self.hideShowLoader(isHidden: true)
        AppToast.default.showToastMessage(message: LocalizedString.paymentFails.localized)//"Sorry! payment was faild.\nPlease try again.")
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        //payment success by razorpay
        if let res = response as? JSONDictionary {
            self.viewModel.getPaymentResonse(forData: res, isRazorPayUsed: true)
        }
    }
}


//MARK:- OTP Varification validation.

extension FlightPaymentVC : OtpConfirmationDelegate{
    func otpValidationCompleted(_ isSuccess: Bool) {
        if isSuccess{
            self.viewModel.makePayment(forAmount: self.getTotalPayableAmount(), useWallet: self.isWallet)
        }else{
            self.hideShowLoader(isHidden:true)
            self.view.isUserInteractionEnabled = true
            self.isWallet =  false
            self.setConvenienceFeeToBeApplied()
            self.updateAllData()
        }
    }
}

