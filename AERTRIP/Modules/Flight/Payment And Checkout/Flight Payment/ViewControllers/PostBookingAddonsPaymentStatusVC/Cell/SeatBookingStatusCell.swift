//
//  SeatBookingStatusCell.swift
//  AERTRIP
//
//  Created by Apple  on 25.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SeatBookingStatusCell: UITableViewCell {
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var youAreAllDoneLabel: UILabel!
    @IBOutlet weak var bookingIdAndDetailsLabel: UILabel!
    @IBOutlet weak var importantNoteLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var tickMarKButton: ATButton!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var youareAllDoneTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tickmarkButtonHeightConstraint: NSLayoutConstraint!
    
    //Mark:- Lifecycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        self.setColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setColor()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        //Font
        self.youAreAllDoneLabel.font = AppFonts.c.withSize(38.0)
        //Color
        self.youAreAllDoneLabel.textColor = AppColors.themeBlack
        //Text
        self.youAreAllDoneLabel.text = "Seats Booked"
        self.tickMarKButton.myCornerRadius = self.tickMarKButton.height/2
        self.tickMarKButton.setImage(AppImages.Checkmark, for: .normal)
        
        
    }
    
    private func setColor(){
        self.contentView.backgroundColor = AppColors.themeBlack26
    }
    
    ///AttributeLabelSetup
    //Congratulations, your seat booking is successful.
    //Your booking ID is 2324354657 and all details have been sent to your email.
    private func attributeLabelSetUp(prefixText: String , prefixTextColor: UIColor = AppColors.themeBlack, prefixFont: UIFont = AppFonts.Regular.withSize(16.0) , id: String, middleTextColor: UIColor = AppColors.themeBlack, middleFont: UIFont = AppFonts.SemiBold.withSize(16.0) ,postfixText: String , postfixTextColor: UIColor = AppColors.themeBlack, postfixFont: UIFont = AppFonts.Regular.withSize(16.0), image: UIImage? = nil) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        
        let prefixRegularAttribute = [NSAttributedString.Key.font: prefixFont, NSAttributedString.Key.foregroundColor: prefixTextColor] as [NSAttributedString.Key : Any]
        let prefixRegularAttributedString = NSAttributedString(string: prefixText, attributes: prefixRegularAttribute)
        
        let semiBoldAttribute = [NSAttributedString.Key.font: middleFont, NSAttributedString.Key.foregroundColor: middleTextColor]
        let semiBoldAttributedString = NSAttributedString(string: " \(id) ", attributes: semiBoldAttribute)
        
        let postfixTextRegularAttribute = [NSAttributedString.Key.font: postfixFont, NSAttributedString.Key.foregroundColor: postfixTextColor] as [NSAttributedString.Key : Any]
        let postfixTextRegularAttributedString = NSAttributedString(string: postfixText, attributes: postfixTextRegularAttribute)
        if let img = image {
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = img
            image1Attachment.bounds = CGRect(x: 0, y: -3, width: img.size.width, height: img.size.height)
            let image1String = NSMutableAttributedString(attachment: image1Attachment)
            attributedString.append(image1String)
            
        }
        
        attributedString.append(prefixRegularAttributedString)
        attributedString.append(semiBoldAttributedString)
        attributedString.append(postfixTextRegularAttributedString)
        
        return attributedString
    }

    internal func configCell(forBookingId: String, forCid: String, isBookingPending: Bool) {
        if !isBookingPending {
            self.youAreAllDoneLabel.text = "Seats Booked"
            self.bookingIdAndDetailsLabel.attributedText = self.attributeLabelSetUp(prefixText: "Congratulations, your seat booking is successful.\nYour booking ID is ", id: forBookingId , postfixText: LocalizedString.AndAllDetailsWillBeSentToYourEmail.localized)
            self.tickMarKButton.setImage(AppImages.Checkmark, for: .normal)
            self.importantNoteLabel.isHidden = true
            self.tickMarKButton.isHidden = false
            self.stackViewTopConstraint.constant = 0
            self.stackViewBottomConstraint.constant = 22
            self.youareAllDoneTopConstraint.constant = 28
            self.tickmarkButtonHeightConstraint.constant = 62
        } else {
            self.youAreAllDoneLabel.text = LocalizedString.BookingIsInProcess.localized
        self.bookingIdAndDetailsLabel.attributedText = self.attributeLabelSetUp(prefixText: LocalizedString.YourBookingID.localized, id: forBookingId , postfixText: LocalizedString.AndAllDetailsWillBeSentToYourEmail.localized)
            self.importantNoteLabel.attributedText = self.attributeLabelSetUp(prefixText: "", prefixTextColor: AppColors.themeRed, prefixFont: AppFonts.SemiBold.withSize(16.0)  , id: LocalizedString.YourBookingIdStmt.localized, middleTextColor: AppColors.themeBlack , middleFont: AppFonts.Regular.withSize(16.0), postfixText: LocalizedString.AertripEmailId.localized , postfixTextColor: AppColors.themeBlack , postfixFont: AppFonts.SemiBold.withSize(16.0), image: AppImages.infoOrange)
            self.importantNoteLabel.isHidden = false
            self.tickMarKButton.isHidden = true
            self.stackViewTopConstraint.constant = 16
            self.stackViewBottomConstraint.constant = 0
            self.youareAllDoneTopConstraint.constant = 0
            self.tickmarkButtonHeightConstraint.constant = 0
            
        }
        self.dividerView.isHidden = true
        self.contentView.layoutIfNeeded()
    }

}
