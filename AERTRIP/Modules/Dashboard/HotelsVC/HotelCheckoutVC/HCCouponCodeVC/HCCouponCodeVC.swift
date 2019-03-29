//
//  HCCouponCodeVC.swift
//  AERTRIP
//
//  Created by Admin on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCCouponCodeVC: BaseVC {
    
    let viewModel = HCCouponCodeVM()
    var selectedIndexPath: IndexPath?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var couponTableView: UITableView! {
        didSet {
            self.couponTableView.contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
            self.couponTableView.delegate = self
            self.couponTableView.dataSource = self
            self.couponTableView.estimatedRowHeight = UITableView.automaticDimension
            self.couponTableView.rowHeight = UITableView.automaticDimension
        }
    }
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var enterCouponLabel: UILabel!
    @IBOutlet weak var couponTextField: UITextField! {
        didSet {
            self.couponTextField.delegate = self
            self.couponTextField.rightViewMode = .whileEditing
            self.couponTextField.autocorrectionType = .no
            self.couponTextField.autocapitalizationType = .allCharacters
            self.couponTextField.adjustsFontSizeToFitWidth = true
            self.couponTextField.textFieldClearBtnSetUp()
        }
    }
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateImageView: UIImageView!
    @IBOutlet weak var noCouponsReqLabel: UILabel!
    @IBOutlet weak var bestPriceLabel: UILabel!
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.statusBarStyle = .default
        self.viewModel.getCouponsDetailsApi()
        self.enterCouponLabel.isHidden = true
        self.emptyStateImageView.image = #imageLiteral(resourceName: "emptyStateCoupon")
        self.registerNibs()
    }
    
    override func setupFonts() {
        self.couponLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.applyButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        self.couponTextField.font = AppFonts.Regular.withSize(18.0)
        //        self.enterCouponLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.noCouponsReqLabel.font = AppFonts.Regular.withSize(22.0)
        self.bestPriceLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        self.couponLabel.text = LocalizedString.Coupons.localized
        self.applyButton.setTitle(LocalizedString.apply.localized, for: .normal)
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        self.enterCouponLabel.text = LocalizedString.EnterCouponCode.localized
        self.noCouponsReqLabel.text = LocalizedString.NoCouponRequired.localized
        self.bestPriceLabel.text = LocalizedString.YouAlreadyHaveBestPrice.localized
    }
    
    override func setupColors() {
        self.couponLabel.textColor = AppColors.themeBlack
        self.applyButton.setTitleColor(AppColors.themeGray20, for: .normal)
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.couponTextField.textColor = AppColors.themeBlack
        self.couponTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.EnterCouponCode.localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.themeGray20,NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0)])
        //        self.enterCouponLabel.textColor = AppColors.themeRed
        self.noCouponsReqLabel.textColor = AppColors.themeBlack
        self.bestPriceLabel.textColor = AppColors.themeGray60
        self.couponValidationTextSetUp(isCouponValid: false)
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //Mark:- Functions
    //================
    private func registerNibs() {
        self.couponTableView.registerCell(nibName: CouponCodeTableViewCell.reusableIdentifier)
    }
    
    private func emptyStateSetUp() {
        self.emptyStateView.isHidden = !self.viewModel.couponsData.isEmpty
        self.couponTableView.isHidden = self.viewModel.couponsData.isEmpty
        self.couponTableView.reloadData()
    }
    
    private func couponValidationTextSetUp(isCouponValid: Bool) {
        if isCouponValid {
            self.enterCouponLabel.font = AppFonts.Regular.withSize(14.0)
            self.enterCouponLabel.textColor = AppColors.themeGreen
        } else {
            self.enterCouponLabel.font = AppFonts.SemiBold.withSize(14.0)
            self.enterCouponLabel.textColor = AppColors.themeRed
        }
    }
    
    //Mark:- IBActions
    //================
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        //        AppFlowManager.default.popViewController(animated: true)
    }
    
    @IBAction func applyButtonAction(_ sender: UIButton) {
        if !self.viewModel.couponCode.isEmpty {
            printDebug("\(self.viewModel.couponCode) Applied")
            self.viewModel.applyCouponCode()
        } else {
            printDebug("Select a coupons code")
        }
    }
}

//Mark:- UITableView Delegate DataSource
//======================================
extension HCCouponCodeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.couponsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: CouponCodeTableViewCell.reusableIdentifier, for: indexPath) as? CouponCodeTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        if let selectedIndexPath = self.selectedIndexPath {
            cell.checkMarkImageView.image = (selectedIndexPath == indexPath) ? #imageLiteral(resourceName: "tick") : #imageLiteral(resourceName: "untick")
            self.viewModel.couponCode = self.viewModel.couponsData[indexPath.row].couponCode
        } else {
            cell.checkMarkImageView.image = #imageLiteral(resourceName: "untick")
        }
        cell.configCell(currentCoupon: self.viewModel.couponsData[indexPath.item])
        return cell
    }
}

extension HCCouponCodeVC {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.enterCouponLabel.isHidden = true
        //        if self.selectedIndexPath == nil {
        //            self.applyButton.setTitleColor(AppColors.themeGray20, for: .normal)
        //        } else {
        //            self.applyButton.setTitleColor(AppColors.themeGreen, for: .normal)
        //        }
        self.applyButton.setTitleColor(AppColors.themeGray20, for: .normal)
        self.selectedIndexPath = nil
        self.couponValidationTextSetUp(isCouponValid: false)
        self.viewModel.couponCode = ""
        self.couponTableView.reloadData()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
        let finalText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        print(finalText)
        if finalText.isEmpty {
            self.enterCouponLabel.isHidden = true
            if self.selectedIndexPath == nil {
                self.applyButton.setTitleColor(AppColors.themeGray20, for: .normal)
            }
            self.viewModel.couponCode = ""
        } else {
            self.enterCouponLabel.isHidden = false
            self.applyButton.setTitleColor(AppColors.themeGreen, for: .normal)
            for (index,coupon) in self.viewModel.couponsData.enumerated() {
                if coupon.couponTitle == finalText {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.couponValidationTextSetUp(isCouponValid: true)
                    if !(self.selectedIndexPath ?? IndexPath() == indexPath) {
                        self.selectedIndexPath = indexPath
                        self.viewModel.couponCode = coupon.couponCode
                        self.couponTableView.reloadData()
                    }
                    return true
                } else {
                    self.selectedIndexPath = nil
                    self.couponValidationTextSetUp(isCouponValid: false)
                    self.viewModel.couponCode = ""
                    self.couponTableView.reloadData()
                    return true
                }
            }
        }
        return true
    }
}

extension HCCouponCodeVC: PassSelectedCoupon {
    func selectedCoupon(indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.applyButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.couponTableView.reloadData()
    }
    
    func offerTermsInfo(indexPath: IndexPath) {
        printDebug("offer terms for \(indexPath)")
    }
}


extension HCCouponCodeVC: HCCouponCodeVMDelegate {
    
    func getCouponsDataSuccessful() {
        self.emptyStateSetUp()
    }
    
    func getCouponsDataFailed() {
        self.emptyStateSetUp()
    }
    
    func applyCouponCodeSuccessful() {
        printDebug("Coupon Applied Successful")
    }
    
    func applyCouponCodeFailed() {
        printDebug("Coupon Not Applied")
    }
}

