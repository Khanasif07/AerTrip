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
    func offerTermsInfo(indexPath: IndexPath)
}

class CouponCodeTableViewCell: UITableViewCell {
    
    var discountText: [String] = ["$ 10.00 (₹ 660) instant cashback will be applied to this booking.","$ 2.00 (₹ 132) will be credited to your Aertrip Walle within few hours of successful payment / travel date."]
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
    private func bulletedCouponsDetails(discountDetails: [String]) -> NSMutableAttributedString {
        let attributesDictionary = [NSAttributedString.Key.font : AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor : AppColors.textFieldTextColor51]
        let fullAttributedString = NSMutableAttributedString()
        let paragraphStyle = AppGlobals.shared.createParagraphAttribute()
        for text in discountDetails {
            let formattedString: String = "●  \(text)\n"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString, attributes: attributesDictionary)
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            fullAttributedString.append(attributedString)
        }
        return fullAttributedString
    }
    
    internal func configCell() {
        self.attributeLabelSetUp(couponCode: "AERHDFC")
        self.couponInfoTextView.attributedText = self.bulletedCouponsDetails(discountDetails: discountText)
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
            safeDelegate.offerTermsInfo(indexPath: indexPath)
        }
    }
    
}
