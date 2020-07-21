//
//  HCCouponCodeVC.swift
//  AERTRIP
//
//  Created by Admin on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import IQKeyboardManager

protocol HCCouponCodeVCDelegate: class {
    func appliedCouponData(_ appliedCouponData: HCCouponAppliedModel)
}

protocol FlightCouponCodeVCDelegate: class {
    func appliedCouponData(_ appliedCouponData: FlightItineraryData)
}
class HCCouponCodeVC: BaseVC {
    
    let viewModel = HCCouponCodeVM()
    weak var delegate: HCCouponCodeVCDelegate?

    weak var flightDelegate:FlightCouponCodeVCDelegate?
//    var selectedIndexPath: IndexPath?

    //var selectedIndexPath: IndexPath?

    var currentIndexPath: IndexPath?
    var viewTranslation = CGPoint(x: 0, y: 0)
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var couponTableView: UITableView! {
        didSet {
            self.couponTableView.contentInset = UIEdgeInsets(top: 0, left: 0.0, bottom: 10.0, right: 0.0)
            self.couponTableView.estimatedRowHeight = UITableView.automaticDimension
            self.couponTableView.rowHeight = UITableView.automaticDimension
        }
    }
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var couponTextField: PKFloatLabelTextField! {
        didSet {
            self.couponTextField.delegate = self
            //self.couponTextField.rightViewMode = .whileEditing
            self.couponTextField.autocorrectionType = .no
            self.couponTextField.autocapitalizationType = .allCharacters
            self.couponTextField.adjustsFontSizeToFitWidth = true
            self.couponTextField.textFieldClearBtnSetUp()
            self.couponTextField.clearButtonMode = .always
        }
    }
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateImageView: UIImageView!
    @IBOutlet weak var noCouponsReqLabel: UILabel!
    @IBOutlet weak var bestPriceLabel: UILabel!
    @IBOutlet weak var offerTermsView: UIView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var offerTermsViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var coupanCodeLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var couponInfoTextView: UITextView!
    @IBOutlet weak var dividerView: ATDividerView! 
    @IBOutlet weak var applyCouponButton: UIButton!
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func initialSetup() {
        self.manageLoader()
        self.registerNibs()
        self.couponTableView.delegate = self
        self.couponTableView.dataSource = self
        self.statusBarStyle = .default
        if self.viewModel.product != .flights{
            self.viewModel.getCouponsDetailsApi()
        }
        self.emptyStateImageView.image = #imageLiteral(resourceName: "emptyStateCoupon")
        self.offerTermsView.roundTopCorners(cornerRadius: 10.0)
        self.offerTermsViewSetUp()
        self.registerNibs()
        
        //AddGesture:-
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        offerTermsView.isUserInteractionEnabled = true
        swipeGesture.delegate = self
        self.offerTermsView.addGestureRecognizer(swipeGesture)
    }
    
    override func setupFonts() {
        self.couponTextField.titleYPadding = 12.0
        self.couponTextField.hintYPadding = 12.0
        self.couponLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.applyButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        self.couponTextField.font = AppFonts.Regular.withSize(18.0)
        self.noCouponsReqLabel.font = AppFonts.Regular.withSize(22.0)
        self.bestPriceLabel.font = AppFonts.Regular.withSize(18.0)
        self.applyCouponButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupTexts() {
        self.couponLabel.text = LocalizedString.Coupons.localized
        self.applyButton.setTitle(LocalizedString.apply.localized, for: .normal)
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        self.noCouponsReqLabel.text = LocalizedString.NoCouponRequired.localized
        self.bestPriceLabel.text = LocalizedString.YouAlreadyHaveBestPrice.localized
        self.applyCouponButton.setTitle(LocalizedString.ApplyCoupon.localized, for: .normal)
    }
    
    override func setupColors() {
        self.couponLabel.textColor = AppColors.themeBlack
        self.applyButton.setTitleColor(AppColors.themeGray20, for: .normal)
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.couponTextField.isHiddenBottomLine = true
        self.couponTextField.setupTextField(placehoder: LocalizedString.EnterCouponCode.localized, keyboardType: .emailAddress, returnType: .done, isSecureText: false)

        self.noCouponsReqLabel.textColor = AppColors.themeBlack
        self.bestPriceLabel.textColor = AppColors.themeGray60
        self.backGroundView.backgroundColor = AppColors.themeGray60.withAlphaComponent(0.6)
        //self.couponValidationTextSetUp(isCouponValid: true)
        self.applyCouponButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    
    private func manageLoader() {
        self.indicator.style = .gray
        self.indicator.tintColor = AppColors.themeGreen
        self.indicator.color = AppColors.themeGreen
        self.indicator.stopAnimating()
        self.hideShowLoader(isHidden:true)
    }
      
       func hideShowLoader(isHidden:Bool){
        DispatchQueue.main.async {
            
            if isHidden{
                self.indicator.stopAnimating()
                self.applyButton.setTitle("Apply", for: .normal)
            }else{
                self.applyButton.setTitle("", for: .normal)
                self.indicator.startAnimating()
            }
        }
       }
    
    //Mark:- Functions
    //================
    private func registerNibs() {
        self.couponTableView.registerCell(nibName: CheckoutCouponCodeTableViewCell.reusableIdentifier)
    }
    
    private func emptyStateSetUp() {
        self.emptyStateView.isHidden = !self.viewModel.searcedCouponsData.isEmpty
        self.couponTableView.isHidden = self.viewModel.searcedCouponsData.isEmpty
        self.couponTableView.reloadData()
    }
    
//    private func couponValidationTextSetUp(isCouponValid: Bool) {
//        if isCouponValid {
//            self.enterCouponLabel.font = AppFonts.Regular.withSize(14.0)
//            self.enterCouponLabel.textColor = AppColors.themeGreen
//        } else {
//            self.enterCouponLabel.font = AppFonts.SemiBold.withSize(14.0)
//            self.enterCouponLabel.textColor = AppColors.themeRed
//        }
//    }
    
    private func offerTermsViewSetUp() {
        self.couponInfoTextView.textColor = AppColors.textFieldTextColor51
        self.discountLabel.textColor = AppColors.themeOrange
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.backGroundViewTapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.backGroundView.addGestureRecognizer(tapGesture)
        self.hideOfferTermsView(animated: false)
    }
    
    ///Show View
    private func showOfferTermsView(animated: Bool) {
        self.backGroundView.isHidden = false
        self.offerTermsView.isHidden = false
        self.view.bringSubviewToFront(self.backGroundView)
        self.view.bringSubviewToFront(self.offerTermsView)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            //self.offerTermsViewHeightConstraints.constant = 209.0 + AppFlowManager.default.safeAreaInsets.bottom
            //self.view.layoutIfNeeded()
            self.offerTermsView.transform = .identity
        }, completion: { [weak self] (isDone) in
            self?.couponTableView.isUserInteractionEnabled = false
        })
    }
    
    ///Hide View
    private func hideOfferTermsView(animated: Bool) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            //self.offerTermsViewHeightConstraints.constant = 0.0
            self.offerTermsView.transform = CGAffineTransform(translationX: 0, y: self.offerTermsView.height + AppFlowManager.default.safeAreaInsets.bottom)
            self.view.layoutIfNeeded()
        }, completion: { [weak self] (isDone) in
            guard let sSelf = self else { return }
            sSelf.couponTableView.isUserInteractionEnabled = true
            sSelf.backGroundView.isHidden = true
            sSelf.offerTermsView.isHidden = true
            sSelf.view.bringSubviewToFront(sSelf.offerTermsView)
            sSelf.view.sendSubviewToBack(sSelf.backGroundView)
        })
    }
    
    
    //Mark:- IBActions
    //================
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyButtonAction(_ sender: UIButton) { self.view.endEditing(true)
        if (self.couponTextField.text == "") {
            AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterCouponCode.localized)
        }
        if !self.viewModel.couponCode.isEmpty {
            printDebug("\(self.viewModel.couponCode) Applied")
            switch self.viewModel.product{
            case .hotels: self.viewModel.applyCouponCode()
            case .flights: self.viewModel.applyFlightCouponCode()
            }
            if self.viewModel.product == .flights{
                self.hideShowLoader(isHidden: false)
            }
        } else {
            //            self.enterCouponLabel.isHidden = false
            //self.couponValidationTextSetUp(isCouponValid: false)
            self.view.endEditing(true)
            AppToast.default.showToastMessage(message: LocalizedString.InvalidCouponCodeText.localized)
            printDebug("Enter a Valid code")
        }
    }
    
    @IBAction func applyCouponButtonAction(_ sender: UIButton) {
        //self.selectedIndexPath = self.currentIndexPath
        self.hideOfferTermsView(animated: true)
        self.applyButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.couponTableView.reloadData()
        if let indexPath = self.currentIndexPath {
            self.viewModel.couponCode = self.viewModel.searcedCouponsData[indexPath.row].couponCode
            switch self.viewModel.product{
            case .hotels: self.viewModel.applyCouponCode()
            case .flights: self.viewModel.applyFlightCouponCode()
            }
        }
    }
    
    @IBAction func backGroundViewTapGesture(_ gesture: UITapGestureRecognizer) {
        self.hideOfferTermsView(animated: true)
    }
}

//Mark:- UITableView Delegate DataSource
//======================================
extension HCCouponCodeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.searcedCouponsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutCouponCodeTableViewCell.reusableIdentifier, for: indexPath) as? CheckoutCouponCodeTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        let model = self.viewModel.searcedCouponsData[indexPath.item]
        if !self.viewModel.couponCode.isEmpty, self.viewModel.couponCode.lowercased() == model.couponCode.lowercased()  {
            cell.checkMarkImageView.image =  #imageLiteral(resourceName: "tick")
            self.viewModel.couponCode = model.couponCode
            self.couponTextField.text = model.couponCode
           // self.couponValidationTextSetUp(isCouponValid: true)
            self.couponTextField.becomeFirstResponder()
        } else {
            cell.checkMarkImageView.image = #imageLiteral(resourceName: "untick")
        }
        cell.configCell(currentCoupon: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCoupon(indexPath: indexPath)
    }
}

extension HCCouponCodeVC {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //        self.enterCouponLabel.isHidden = true
        self.applyButton.setTitleColor(AppColors.themeGray20, for: .normal)
        //self.selectedIndexPath = nil
       // self.couponValidationTextSetUp(isCouponValid: true)
        self.viewModel.couponCode = ""
        self.couponTableView.reloadData()
//        guard let text = textField.text else { return true }
//        let finalText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.viewModel.searchCoupons(searchText: "")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       // self.couponValidationTextSetUp(isCouponValid: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
        let finalText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        printDebug(finalText)
        if finalText.isEmpty {
            self.viewModel.couponCode = ""
            //            self.enterCouponLabel.isHidden = true
            if self.viewModel.couponCode.isEmpty {
                self.applyButton.setTitleColor(AppColors.themeGray20, for: .normal)
            }
            
        } else {
            //            self.enterCouponLabel.isHidden = false
            self.applyButton.setTitleColor(AppColors.themeGreen, for: .normal)
//            for (index,coupon) in self.viewModel.couponsData.enumerated() {
//                if coupon.couponTitle == finalText {
//                    let indexPath = IndexPath(row: index, section: 0)
//                    //self.couponValidationTextSetUp(isCouponValid: true)
//                    if !(self.selectedIndexPath ?? IndexPath() == indexPath) {
//                        self.selectedIndexPath = indexPath
//                        self.viewModel.couponCode = coupon.couponCode
//                        self.couponTableView.reloadData()
//                        return true
//                    }
//                } else {
//                    self.selectedIndexPath = nil
//                    //self.couponValidationTextSetUp(isCouponValid: false)
//                    self.viewModel.couponCode = finalText
//                    self.couponTableView.reloadData()
//                }
//            }
        }
        self.viewModel.couponCode = finalText
        self.viewModel.searchCoupons(searchText: finalText)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.couponTextField.titleTextColour = AppColors.themeGray40
        return true
    }
}

extension HCCouponCodeVC: PassSelectedCoupon {
    func offerTermsInfo(indexPath: IndexPath, bulletedText: NSAttributedString, couponCode: NSAttributedString, discountText: NSAttributedString) {
        self.view.endEditing(true)
        self.currentIndexPath = indexPath
        self.coupanCodeLabel.attributedText = couponCode
        self.discountLabel.attributedText = discountText
        self.couponInfoTextView.attributedText = bulletedText
        self.couponInfoTextView.textColor = AppColors.textFieldTextColor51
        self.showOfferTermsView(animated: true)
        printDebug("offer terms for \(indexPath)")
    }
    
    func selectedCoupon(indexPath: IndexPath) {
        let model = self.viewModel.searcedCouponsData[indexPath.item]
        if !self.viewModel.couponCode.isEmpty, self.viewModel.couponCode.lowercased() == model.couponCode.lowercased() {
            self.applyButton.setTitleColor(AppColors.themeGray20, for: .normal)
            //self.selectedIndexPath = nil
            //self.couponValidationTextSetUp(isCouponValid: true)
            self.couponTextField.text = ""
            self.viewModel.couponCode = ""
            self.couponTextField.titleTextColour = AppColors.themeGray40
        } else {
            self.couponTextField.text = model.couponCode
            self.viewModel.couponCode = model.couponCode
            //self.selectedIndexPath = indexPath
            self.applyButton.setTitleColor(AppColors.themeGreen, for: .normal)
        }
        guard let text = self.couponTextField.text else { return }
        let finalText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.viewModel.searchCoupons(searchText: finalText)
        self.couponTableView.reloadData()
    }
}


extension HCCouponCodeVC: HCCouponCodeVMDelegate {
    func searchedCouponsDataSuccessful() {
        self.emptyStateSetUp()
    }
    
    
    func getCouponsDataSuccessful() {
//        if !self.viewModel.couponCode.isEmpty {
//            for (index,coupon) in self.viewModel.searcedCouponsData.enumerated() {
//                if coupon.couponCode == self.viewModel.couponCode {
//                    let indexPath = IndexPath(row: index, section: 0)
//                    if !(self.selectedIndexPath ?? IndexPath() == indexPath) {
//                        self.selectedIndexPath = indexPath
//                        self.emptyStateSetUp()
//                        return
//                    }
//                }
//            }
//        }
        self.emptyStateSetUp()
    }
    
    func getCouponsDataFailed() {
        self.emptyStateSetUp()
    }
    
    func applyCouponCodeSuccessful() {
        printDebug("Coupon Applied Successful")
        switch self.viewModel.product{
        case .hotels:
            if let safeDelegate = self.delegate , let appliedCouponData = self.viewModel.appliedCouponData {
                safeDelegate.appliedCouponData(appliedCouponData)
                self.dismiss(animated: true, completion: nil)
            }
        case .flights:
            if let safeDelegate = self.flightDelegate , let appliedCouponData = self.viewModel.appliedDataForFlight {
                safeDelegate.appliedCouponData(appliedCouponData)
                self.dismiss(animated: true, completion: nil)
                self.hideShowLoader(isHidden: true)
            }
        }
        
    }
    
    func applyCouponCodeFailed(errors: ErrorCodes) {
        self.couponTextField.titleTextColour = AppColors.themeRed
        printDebug("Coupon Not Applied")
        self.hideShowLoader(isHidden: true)
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
    }
}
extension HCCouponCodeVC {
//Handle Swipe Gesture
@objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
    printDebug("sender.state.rawValue: \(sender.state.rawValue)")
    func reset() {
        if viewTranslation.y > self.offerTermsView.height/2 {
            hideOfferTermsView(animated: true)
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.offerTermsView.transform = .identity
        })
    }
    
    func moveView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.offerTermsView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
        })
    }
    
    guard let direction = sender.direction, direction.isVertical, direction == .down
        else {
            printDebug("sender.direction: \(sender.direction)")
        reset()
        return
    }
    let velocity = sender.velocity(in: offerTermsView).y
    
    switch sender.state {
    case .changed:
        printDebug("changed")
        viewTranslation = sender.translation(in: self.offerTermsView)
        moveView()
    case .ended:
        printDebug("ended")
        if viewTranslation.y < self.offerTermsView.height/2 || velocity < 1000 {
            reset()
        } else {
            hideOfferTermsView(animated: true)
        }
    case .cancelled:
        printDebug("cancelled")
        reset()
    case .failed:
        printDebug("failed")
        reset()
    default:
        break
    }
    printDebug("viewTranslation: \(viewTranslation)")
}
}
