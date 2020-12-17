//
//  YouAreAllDoneTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 19/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import ActiveLabel
protocol YouAreAllDoneTableViewCellDelegate: class {
    func addToAppleWalletTapped(button: ATButton)
    func addToCallendarTapped()
}

class YouAreAllDoneTableViewCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    weak var delegate: YouAreAllDoneTableViewCellDelegate?
    
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var youAreAllDoneLabel: UILabel!
    @IBOutlet weak var bookingIdAndDetailsLabel: UILabel!
    @IBOutlet weak var addToAppleWalletButton: ATButton!
    @IBOutlet weak var importantNoteLabel: ActiveLabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var tickMarKButton: ATButton!
    @IBOutlet weak var addToCalendarButton: UIButton!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var youareAllDoneTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tickmarkButtonHeightConstraint: NSLayoutConstraint!
    
    
    var handler : (()->())?
    
    //Mark:- Lifecycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        self.addToAppleWalletButton.isLoading = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.addToAppleWalletButton.isLoading = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addToAppleWalletButton.layoutSubviews()
        self.addToAppleWalletButton.layoutIfNeeded()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        //Image
        self.addToAppleWalletButton.setImage(#imageLiteral(resourceName: "AddToAppleWallet"), for: .normal)
        //Font
        self.youAreAllDoneLabel.font = AppFonts.c.withSize(38.0)
        self.configureAppleButton()
        self.addToCalendarButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)

        //Color
        self.youAreAllDoneLabel.textColor = AppColors.themeBlack
        self.addToAppleWalletButton.setTitleColor(AppColors.themeWhite, for: .normal)
        //Text
        self.youAreAllDoneLabel.text = LocalizedString.BookingConfirmed.localized
        self.addToAppleWalletButton.setTitle(LocalizedString.AddToAppleWallet.localized, for: .normal)
        //Button SetUp
        self.appleWalletButtonSetUp()
        self.addToCallendarButtonSetUp()
        self.tickMarKButton.myCornerRadius = self.tickMarKButton.height/2
        
        
    }
    
    private func appleWalletButtonSetUp() {
        self.addToAppleWalletButton.backgroundColor = AppColors.themeBlack
        self.addToAppleWalletButton.cornerradius = 10.0
        self.addToAppleWalletButton.clipsToBounds = true
        self.addToAppleWalletButton.imageView?.size = CGSize(width: 30.0, height: 22.0)
        self.addToAppleWalletButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -20.0, bottom: 0.0, right: 0.0)
        self.addToAppleWalletButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 16, bottom: 0.0, right: 0.0)
    }
    
    private func addToCallendarButtonSetUp() {
        self.addToCalendarButton.backgroundColor = AppColors.themeWhite
        self.addToCalendarButton.cornerradius = 10.0
        self.addToCalendarButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.addToCalendarButton.setTitleColor(AppColors.themeGreen, for: .selected)
        
        self.addToCalendarButton.layer.borderWidth = 1.0
        self.addToCalendarButton.layer.borderColor = AppColors.themeGreen.cgColor
        
        self.addToCalendarButton.setImage( #imageLiteral(resourceName: "AllDoneCalendar") , for: .normal)
        self.addToCalendarButton.setImage( #imageLiteral(resourceName: "AllDoneCalendar") , for: .selected)
        self.addToCalendarButton.setTitle(LocalizedString.AddToCalender.localized, for: .normal)
        self.addToCalendarButton.setTitle(LocalizedString.AddToCalender.localized, for: .selected)
        
        self.addToCalendarButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -10.0, bottom: 0.0, right: 0.0)
        self.addToCalendarButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 16, bottom: 0.0, right: 0.0)
    }
    
    ///AttributeLabelSetup
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
            self.youAreAllDoneLabel.text = LocalizedString.BookingConfirmed.localized
            self.bookingIdAndDetailsLabel.attributedText = self.attributeLabelSetUp(prefixText: LocalizedString.YourBookingIDIs.localized, id: forBookingId , postfixText: LocalizedString.AndAllDetailsWillBeSentToYourEmail.localized)
            self.importantNoteLabel.isHidden = true
            self.addToAppleWalletButton.isHidden = false
            self.addToCalendarButton.isHidden = false
            self.tickMarKButton.isHidden = false
            self.stackViewTopConstraint.constant = 46
            self.stackViewBottomConstraint.constant = 26
            self.youareAllDoneTopConstraint.constant = 28
            self.tickmarkButtonHeightConstraint.constant = 62
        } else {
            self.youAreAllDoneLabel.text = LocalizedString.BookingIsInProcess.localized
        self.bookingIdAndDetailsLabel.attributedText = self.attributeLabelSetUp(prefixText: LocalizedString.YourBookingID.localized, id: forBookingId , postfixText: LocalizedString.AndAllDetailsWillBeSentToYourEmail.localized)
//            self.importantNoteLabel.attributedText = self.attributeLabelSetUp(prefixText: "", prefixTextColor: AppColors.themeRed, prefixFont: AppFonts.SemiBold.withSize(16.0)  , id: LocalizedString.YourBookingIdStmt.localized, middleTextColor: AppColors.themeBlack , middleFont: AppFonts.Regular.withSize(16.0), postfixText: LocalizedString.AertripEmailId.localized , postfixTextColor: AppColors.themeBlack , postfixFont: AppFonts.SemiBold.withSize(16.0), image: #imageLiteral(resourceName: "infoOrange"))
            self.setImportentLabel(withLabel: self.importantNoteLabel)
            self.importantNoteLabel.isHidden = false
            self.addToAppleWalletButton.isHidden = true
            self.addToCalendarButton.isHidden = true
            self.tickMarKButton.isHidden = true
            self.stackViewTopConstraint.constant = 16
            self.stackViewBottomConstraint.constant = 46
            self.youareAllDoneTopConstraint.constant = 0
            self.tickmarkButtonHeightConstraint.constant = 0
            
        }
        self.contentView.layoutIfNeeded()
    }
    
    private func configureAppleButton(){
        self.addToAppleWalletButton.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        self.addToAppleWalletButton.setTitleFont(font: AppFonts.SemiBold.withSize(16), for: .highlighted)
        self.addToAppleWalletButton.setTitleFont(font: AppFonts.SemiBold.withSize(16), for: .normal)
        self.addToAppleWalletButton.setTitleFont(font: AppFonts.SemiBold.withSize(16), for: .selected)
        self.addToAppleWalletButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.addToAppleWalletButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.addToAppleWalletButton.gradientColors = [AppColors.themeBlack, AppColors.themeBlack]
    }
    
    
    func setImportentLabel(withLabel: ActiveLabel){
        
        let seeExample = ActiveType.custom(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        
        
        let allTypes: [ActiveType] = [seeExample]
        let textToDisplay = self.attributeLabelSetUp(prefixText: "", prefixTextColor: AppColors.themeRed, prefixFont: AppFonts.SemiBold.withSize(16.0)  , id: LocalizedString.YourBookingIdStmt.localized, middleTextColor: AppColors.themeBlack , middleFont: AppFonts.Regular.withSize(16.0), postfixText: LocalizedString.AertripEmailId.localized , postfixTextColor: AppColors.themeBlack , postfixFont: AppFonts.SemiBold.withSize(16.0), image: #imageLiteral(resourceName: "infoOrange"))
        withLabel.textColor = AppColors.themeBlack
        withLabel.enabledTypes = allTypes
        withLabel.customize { label in
            label.font = AppFonts.Regular.withSize(16.0)
            label.attributedText = textToDisplay
            for item in allTypes {
                label.customColor[item] = AppColors.themeBlack
                label.customSelectedColor[item] = AppColors.themeBlack
                
            }
            label.highlightFontName = AppFonts.SemiBold.rawValue
            label.highlightFontSize = 16.0
            label.handleCustomTap(for: seeExample) {[weak self] _ in
                self?.handler?()
            }
            
        }
    }
    
    //Mark:- IBActions
    //================
    @IBAction func addToAppleWalletButtonAction(_ sender: ATButton) {
        self.delegate?.addToAppleWalletTapped(button: sender)
    }
    @IBAction func addToCallendarButtonAction(_ sender: Any) {
        self.delegate?.addToCallendarTapped()
    }
}
