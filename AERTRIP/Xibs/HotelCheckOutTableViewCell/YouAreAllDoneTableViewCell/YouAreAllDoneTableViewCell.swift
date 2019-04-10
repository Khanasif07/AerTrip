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
    @IBOutlet weak var importantNoteLabel: UILabel!
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
    private func attributeLabelSetUp(prefixText: String , prefixTextColor: UIColor = AppColors.themeBlack, prefixFont: UIFont = AppFonts.Regular.withSize(18.0) , id: String, middleTextColor: UIColor = AppColors.themeBlack, middleFont: UIFont = AppFonts.SemiBold.withSize(18.0) ,postfixText: String , postfixTextColor: UIColor = AppColors.themeBlack, postfixFont: UIFont = AppFonts.Regular.withSize(18.0)) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        
        let prefixRegularAttribute = [NSAttributedString.Key.font: prefixFont, NSAttributedString.Key.foregroundColor: prefixTextColor] as [NSAttributedString.Key : Any]
        let prefixRegularAttributedString = NSAttributedString(string: prefixText, attributes: prefixRegularAttribute)
        
        let semiBoldAttribute = [NSAttributedString.Key.font: middleFont, NSAttributedString.Key.foregroundColor: middleTextColor]
        let semiBoldAttributedString = NSAttributedString(string: " \(id) ", attributes: semiBoldAttribute)
        
        let postfixTextRegularAttribute = [NSAttributedString.Key.font: postfixFont, NSAttributedString.Key.foregroundColor: postfixTextColor] as [NSAttributedString.Key : Any]
        let postfixTextRegularAttributedString = NSAttributedString(string: postfixText, attributes: postfixTextRegularAttribute)

        attributedString.append(prefixRegularAttributedString)
        attributedString.append(semiBoldAttributedString)
        attributedString.append(postfixTextRegularAttributedString)
        
        return attributedString
    }

    internal func configCell(forBookingId: String, forCid: String) {
        if !forBookingId.isEmpty {
            self.bookingIdAndDetailsLabel.attributedText = self.attributeLabelSetUp(prefixText: LocalizedString.YourBookingIDIs.localized, id: forBookingId , postfixText: LocalizedString.AndAllDetailsWillBeSentToYourEmail.localized)
            self.thankYouLabel.text = LocalizedString.ThankYouStmtForBookingId.localized
            self.importantNoteLabel.isHidden = true
            self.addToAppleWalletButton.isHidden = false
        } else {
            self.thankYouLabel.text = LocalizedString.ThankYouStmtForCId.localized
            self.bookingIdAndDetailsLabel.attributedText = self.attributeLabelSetUp(prefixText: LocalizedString.YourCaseIDIs.localized, id: forCid, postfixText: LocalizedString.AndAllDetailsWillBeSentToYourEmail.localized)
            self.importantNoteLabel.attributedText = self.attributeLabelSetUp(prefixText: LocalizedString.ImportantNote.localized, prefixTextColor: AppColors.themeRed, prefixFont: AppFonts.SemiBold.withSize(18.0)  , id: LocalizedString.YourBookingIdStmt.localized, middleTextColor: AppColors.themeBlack , middleFont: AppFonts.Regular.withSize(18.0), postfixText: LocalizedString.AertripEmailId.localized , postfixTextColor: AppColors.themeGreen , postfixFont: AppFonts.SemiBold.withSize(18.0))
            self.importantNoteLabel.isHidden = false
            self.addToAppleWalletButton.isHidden = true
        }
    }
    
    //Mark:- IBActions
    //================
    @IBAction func addToAppleWalletButtonAction(_ sender: UIButton) {
        
    }
}
