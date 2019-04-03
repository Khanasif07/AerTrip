//
//  CouponCodeTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
// OffersTerms to textview top will bwe 13

import UIKit

protocol PassSelectedCoupon: class {
    func selectedCoupon(indexPath: IndexPath)
    func offerTermsInfo(indexPath: IndexPath, bulletedText: NSAttributedString, couponCode: NSAttributedString, discountText: NSAttributedString)
}

class CouponCodeTableViewCell: UITableViewCell {

    let price: String = "12.00"
    var discountText: [String] = [LocalizedString.InstantCashBackAppliedText.localized,LocalizedString.WalletCashBackAppliedText.localized]
    weak var delegate: PassSelectedCoupon?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var checkMarkBtnAction: UIButton!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var coupanCodeLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var couponInfoTextView: UITextView! {
        didSet {
            self.couponInfoTextView.isEditable = false
            self.couponInfoTextView.textContainerInset = UIEdgeInsets.zero
            self.couponInfoTextView.textContainer.lineFragmentPadding = 0.0
            self.couponInfoTextView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var offerTermsButton: UIButton!
    @IBOutlet weak var expiryTimeLabel: UILabel!
    @IBOutlet weak var dividerView: UIView! {
        didSet {
            self.dividerView.backgroundColor = AppColors.themeGray10
        }
    }
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        //Text
        self.offerTermsButton.setTitle(LocalizedString.OfferTerms.localized, for: .normal)
        
        //Font
        self.offerTermsButton.titleLabel?.font = AppFonts.SemiBold.withSize(14.0)
        self.expiryTimeLabel.font = AppFonts.Regular.withSize(14.0)
        //Colors
        self.offerTermsButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.discountLabel.textColor = AppColors.themeOrange
        self.expiryTimeLabel.textColor = AppColors.themeGray40
        self.couponInfoTextView.textColor = AppColors.textFieldTextColor51
        //Images
        self.checkMarkImageView.image = #imageLiteral(resourceName: "untick")
    }
    
    ///AttributeLabelSetup
    private func attributeLabelSetUp(couponCode: String) {
        let attributedString = NSMutableAttributedString()
        let grayAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray40] as [NSAttributedString.Key : Any]
        let blackAtrribute = [NSAttributedString.Key.font: AppFonts.SemiBold.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.textFieldTextColor51]
        let greyAttributedString = NSAttributedString(string: LocalizedString.Code.localized, attributes: grayAttribute)
        let blackAttributedString = NSAttributedString(string: " " + couponCode, attributes: blackAtrribute)
        attributedString.append(greyAttributedString)
        attributedString.append(blackAttributedString)
        self.coupanCodeLabel.attributedText = attributedString
    }
    
    ///Bulleted Coupons Details
    private func bulletedCouponsDetails(discountDetails: [String], instantCashBack: Int, walletCashBack: Int) -> NSMutableAttributedString {
        let attributesDictionary = [NSAttributedString.Key.font : AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor : AppColors.textFieldTextColor51]
        let fullAttributedString = NSMutableAttributedString()
        let paragraphStyle = AppGlobals.shared.createParagraphAttribute()
        for (index,text) in discountDetails.enumerated() {
            let bulletedString = NSMutableAttributedString()
            let bulletedAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: "●  ", attributes: attributesDictionary)
            let asStylizedPrice = (index == 0) ? instantCashBack.toString.asStylizedPrice(using: AppFonts.Regular.withSize(14.0)) : walletCashBack.toString.asStylizedPrice(using: AppFonts.Regular.withSize(14.0))
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\(text)\n\n", attributes: attributesDictionary)
            bulletedAttributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, bulletedAttributedString.length))
            asStylizedPrice.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, asStylizedPrice.length))
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            bulletedString.append(bulletedAttributedString)
            bulletedString.append(asStylizedPrice)
            bulletedString.append(attributedString)
            fullAttributedString.append(bulletedString)
        }
        self.couponInfoTextView.textColor = AppColors.textFieldTextColor51
        return fullAttributedString
    }
    
    private func discountTextSetUp(price: String, endText: String) {
        let attributedString = NSMutableAttributedString()
        let orangeAttribut = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeOrange] as [NSAttributedString.Key : Any]
        let startTextAttributedString = NSAttributedString(string: "\(LocalizedString.Save.localized) \(LocalizedString.rupeesText.localized) ", attributes: orangeAttribut)
        let asStylizedPrice = price.asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
        let endTextAttributedString = NSAttributedString(string: endText , attributes: orangeAttribut)
        attributedString.append(startTextAttributedString)
        attributedString.append(asStylizedPrice)
        attributedString.append(endTextAttributedString)
        self.discountLabel.attributedText = attributedString
    }
    
    internal func configCell(currentCoupon: HCCouponModel) {
        self.attributeLabelSetUp(couponCode: currentCoupon.couponTitle)
        self.discountTextSetUp(price: currentCoupon.discountBreakUp?.totalCashBack.toString ?? "" , endText: "")
        self.couponInfoTextView.attributedText = self.bulletedCouponsDetails(discountDetails: discountText, instantCashBack: currentCoupon.discountBreakUp?.CPD ?? 0, walletCashBack: currentCoupon.discountBreakUp?.CACB ?? 0)
    }
    
    //Mark:- IBActions
    //================
    @IBAction func checkMarkButtonAction(_ sender: UIButton) {
        if let tableView = self.superview as? UITableView, let indexPath = tableView.indexPath(forItem: sender), let safeDelegate = self.delegate {
            safeDelegate.selectedCoupon(indexPath: indexPath)
        }
    }
    
    @IBAction func offerTermsButtonAction(_ sender: UIButton) {
        if let tableView = self.superview as? UITableView, let indexPath = tableView.indexPath(forItem: sender), let safeDelegate = self.delegate {
            safeDelegate.offerTermsInfo(indexPath: indexPath, bulletedText: self.couponInfoTextView.attributedText, couponCode: self.coupanCodeLabel.attributedText ?? NSAttributedString(), discountText: self.discountLabel.attributedText ?? NSAttributedString())
        }
    }
}
