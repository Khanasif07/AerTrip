//
//  YouAreAllDoneTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 19/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class YouAreAllDoneTableViewCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var aertripLogoImgView: UIImageView!
    @IBOutlet weak var aertripTitleImgView: UIImageView!
    @IBOutlet weak var youAreAllDoneLabel: UILabel!
    @IBOutlet weak var bookingIdAndDetailsLabel: UILabel!
    @IBOutlet weak var thankYouLabel: UILabel!
    @IBOutlet weak var addToAppleWalletButton: UIButton!
    @IBOutlet weak var dividerView: ATDividerView!
    
    //Mark:- Lifecycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        //Image
        self.aertripLogoImgView.image = #imageLiteral(resourceName: "AertripLogoBlack")
        self.aertripTitleImgView.image = #imageLiteral(resourceName: "AertripTextLogo")
        self.addToAppleWalletButton.setImage(#imageLiteral(resourceName: "AddToAppleWallet"), for: .normal)
        //Font
        self.youAreAllDoneLabel.font = AppFonts.SemiBold.withSize(34.0)
        self.thankYouLabel.font = AppFonts.Regular.withSize(16.0)
        self.addToAppleWalletButton.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        //Color
        self.youAreAllDoneLabel.textColor = AppColors.themeBlack
        self.thankYouLabel.textColor = AppColors.themeGray40
        self.addToAppleWalletButton.setTitleColor(AppColors.themeWhite, for: .normal)
        //Text
        self.youAreAllDoneLabel.text = LocalizedString.YouAreAllDoneLabel.localized
        self.addToAppleWalletButton.setTitle(LocalizedString.AddToAppleWallet.localized, for: .normal)
        //Button SetUp
        self.appleWalletButtonSetUp()
    }
    
    private func appleWalletButtonSetUp() {
        self.addToAppleWalletButton.backgroundColor = AppColors.themeBlack
        self.addToAppleWalletButton.cornerRadius = 10.0
        self.addToAppleWalletButton.clipsToBounds = true
        self.addToAppleWalletButton.imageView?.size = CGSize(width: 30.0, height: 22.0)
        self.addToAppleWalletButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -20.0, bottom: 0.0, right: 0.0)
        self.addToAppleWalletButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 16, bottom: 0.0, right: 0.0)
    }
    
    ///AttributeLabelSetup
    private func attributeLabelSetUp(prefixText: String, bookingId: String, postfixText: String) {
        let attributedString = NSMutableAttributedString()
        
        let prefixRegularAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
        let prefixRegularAttributedString = NSAttributedString(string: prefixText, attributes: prefixRegularAttribute)
        
        let semiBoldAttribute = [NSAttributedString.Key.font: AppFonts.SemiBold.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack]
        let semiBoldAttributedString = NSAttributedString(string: " " + bookingId + " ", attributes: semiBoldAttribute)
        
        let postfixTextRegularAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
        let postfixTextRegularAttributedString = NSAttributedString(string: postfixText, attributes: postfixTextRegularAttribute)

        attributedString.append(prefixRegularAttributedString)
        attributedString.append(semiBoldAttributedString)
        attributedString.append(postfixTextRegularAttributedString)
        
        self.bookingIdAndDetailsLabel.attributedText = attributedString
    }
    
    internal func configCell(forBookingId: String) {
        self.attributeLabelSetUp(prefixText: LocalizedString.YourBookingIDIs.localized, bookingId: forBookingId, postfixText: LocalizedString.AndAllDetailsWillBeSentToYourEmail.localized)
    }
    
    //Mark:- IBActions
    //================
    @IBAction func addToAppleWalletButtonAction(_ sender: UIButton) {
        
    }
}
