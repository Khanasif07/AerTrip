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
    var previousAppliedCoupon: HCCouponModel?
    var convenienceRate: Double = 0
    var convenienceFeesWallet: Double = 0
    // Boolean to check if convenienceFeeToAppliedOrNot
    var isConvenienceFeeApplied: Bool = false
    // Boolean to handle  coupon view expanded or not , By Default will be expanded
    var isCouponSectionExpanded: Bool = true
    //Is taxes and fee expended
    var isTaxesAndFeeExpended = true
    var isAddonsExpended = true
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.taxesDataDisplay()
        self.checkOutTableView.separatorStyle = .none
        self.viewModel.taxesDataDisplay()
        self.checkOutTableView.dataSource = self
        self.checkOutTableView.delegate = self
        self.viewModel.delegate = self
        self.viewModel.webServiceGetPaymentMethods()
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
//        delay(seconds: 1) {
//           self.loaderView.isHidden = true
//        }
//        let vc = FlightPaymentBookingStatusVC.instantiate(fromAppStoryboard: .FlightPayment)
//        vc.viewModel.itinerary = self.viewModel.itinerary
//        self.navigationController?.pushViewController(vc, animated: true)
        
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
        let amount = self.getTotalPayableAmount().amountInDelimeterWithSymbol
        let title = " \(LocalizedString.Pay.localized)  \(amount)"
        self.payButton.setTitle(title , for: .normal)
        self.payButton.setTitle(title, for: .highlighted)
    }
    
    private func manageLoader() {
        self.activityLoader.style = .white
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
            self.loaderView.isHidden = isHidden
        }
    }
    
    private func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 50))
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
        if diff > 0 {
            // increased
            FareUpdatedPopUpVC.showPopUp(isForIncreased: true, decreasedAmount: 0.0, increasedAmount: Double(diff), totalUpdatedAmount: Double(amount), continueButtonAction: { [weak self] in
                guard let self = self else { return }
                self.viewModel.makePayment(forAmount: self.getTotalPayableAmount(), useWallet: self.isWallet)
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
            self.viewModel.makePayment(forAmount: self.getTotalPayableAmount(), useWallet: self.isWallet)
        }
    }
    func getListingController(){
        if let nav = self.navigationController?.presentingViewController?.presentingViewController as? UINavigationController{
            nav.dismiss(animated: true) {
                delay(seconds: 0.0) {
                    if let vc = nav.viewControllers.first(where: {$0.isKind(of: FlightResultBaseViewController.self)}) as? FlightResultBaseViewController{
                        nav.popToViewController(vc, animated: true)
                        vc.searchApiResult()
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
            return walletAmount
        } else {
            return 0
        }
    }
    
    // Get Total Payable Amount based on conditions
    private func getTotalPayableAmount() -> Double {
        var payableAmount: Double = Double(self.viewModel.itinerary.details.fare.totalPayableNow.value)
        if payableAmount > 0.0 {
            if self.isCouponApplied, let discountBreakUp = self.viewModel.appliedCouponData.discountsBreakup {
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
        printDebug(appliedCouponData)
        self.viewModel.appliedCouponData = appliedCouponData
        self.isCouponApplied = true
        self.viewModel.taxesDataDisplay()
        delay(seconds: 0.3) { [weak self] in
            self?.updateAllData()
        }
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
    
    func getPaymentsMethodsSuccess(){
        if let razorPay = self.viewModel.paymentDetails?.paymentModes.razorPay {
            self.convenienceRate = razorPay.convenienceFees
            self.convenienceFeesWallet = razorPay.convenienceFeesWallet > 0 ? razorPay.convenienceFeesWallet : 0
            self.setConvenienceFeeToBeApplied()
        }
        self.isWallet = self.getWalletAmount() > 0
        
        self.updateAllData()
    }
    func getPaymentMethodsFails(errors: ErrorCodes){
        
    }
    
    func removeCouponCodeSuccessful(_ appliedCouponData: FlightItineraryData){
        self.viewModel.appliedCouponData = appliedCouponData
        self.isCouponApplied = false
        self.viewModel.taxesDataDisplay()
        self.updateAllData()
        printDebug(appliedCouponData)
    }
    
    func removeCouponCodeFailed() {
        printDebug("Unable to remove Coupon Code")
    }
    
    func reconfirmationResponse(_ success:Bool){
        if success{
            self.viewModel.taxesDataDisplay()
            self.updateAllData()
            self.showFareUpdatePopup()
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
    
    func makePaymentFail() {
        self.hideShowLoader(isHidden:true)
        AppToast.default.showToastMessage(message: "Make Payment Failed")
    }
    
    func willGetPaymentResonse() {
        self.hideShowLoader(isHidden:false)
    }
    
    func getPaymentResonseSuccess(bookingIds: [String], cid: [String]) {
        // send to you are all donr screen
       self.hideShowLoader(isHidden:true)
        print(bookingIds)
        let vc = FlightPaymentBookingStatusVC.instantiate(fromAppStoryboard: .FlightPayment)
        vc.viewModel.apiBookingIds = bookingIds
        vc.viewModel.itId = self.viewModel.itinerary.id
        vc.viewModel.bookingObject = self.viewModel.bookingObject
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getPaymentResonseFail() {
        self.hideShowLoader(isHidden:true)
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
        self.viewModel.removeCouponCode()
    }
}

extension FlightPaymentVC : RazorpayPaymentCompletionProtocolWithData {
    
    func initializePayment(withOptions options: JSONDictionary) {
        let razorpay: RazorpayCheckout = RazorpayCheckout.initWithKey(AppConstants.kRazorpayPublicKey, andDelegateWithData: self)
        //razorpay.open(options)
        razorpay.open(options, displayController: self)
    }
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        self.hideShowLoader(isHidden: true)
        AppToast.default.showToastMessage(message: "Sorry! payment was faild.\nPlease try again.")
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        //payment success by razorpay
        if let res = response as? JSONDictionary {
            self.viewModel.getPaymentResonse(forData: res, isRazorPayUsed: true)
        }
    }
}
