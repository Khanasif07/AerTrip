//
//  EmptyScreenView.swift
//  AERTRIP
//
//  Created by Admin on 03/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol EmptyScreenViewDelegate: class {
}

class EmptyScreenView: UIView {
    
    enum EmptyScreenViewType {
        case hotelPreferences
        case importPhoneContacts
        case importFacebookContacts
        case importGoogleContacts
        case none
    }

    //MARK:- properties -
    var delegate: EmptyScreenViewDelegate?
    var vType: EmptyScreenViewType = .none {
        didSet {
            self.initialSetup()
        }
    }
    
    //MARK:- IBOutlets -
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
        self.initialSetup()
    }
    
    init() {
        super.init(frame: .zero)
        
        self.commonInit()
        self.initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
        self.initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupView()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("\(EmptyScreenView.self)", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }

    //MARK:- Private Function -
    @IBAction func firstButtonAction(_ sender: UIButton) {
    }
}

extension EmptyScreenView {
    
    /// - Initial Setup -
    private func initialSetup() {
        self.setupView()
    }
    
    private func setupView() {
        switch self.vType {
        case .hotelPreferences:
            self.setupForHotelPreferences()
            
        case .importPhoneContacts:
            self.setupForImportPhoneContacts()
            
        case .importFacebookContacts:
            self.setupForImportFacebookContacts()
            
        case .importGoogleContacts:
            self.setupForImportGoogleContacts()
            
        case .none:
            self.setupForNone()
        }
    }

    //MARK: - Tenant My Apartments -
    private func setupForNone() {
        self.firstButton.isHidden = true
        self.mainImageView.image = nil
        self.messageLabel.font = AppFonts.Regular.withSize(17.0)
        self.messageLabel.textColor = AppColors.themeGray40
        self.messageLabel.text = LocalizedString.noData.localized
    }
    
    private func setupForHotelPreferences() {
        self.firstButton.isHidden = true
        self.mainImageView.image = #imageLiteral(resourceName: "hotelEmpty")
        self.messageLabel.font = AppFonts.Regular.withSize(17.0)
        self.messageLabel.textColor = AppColors.themeGray40
        self.messageLabel.attributedText = self.getTextWithImage(startText: "Tap ", image: #imageLiteral(resourceName: "saveHotels"), endText: " to add a hotel to favorite list")//"Tap   to add a hotel to favorite list"
    }
    
    private func setupForImportPhoneContacts() {
        self.firstButton.isHidden = false
        self.firstButton.setTitle(LocalizedString.AllowContacts.localized, for: .normal)
        self.firstButton.setTitle(LocalizedString.AllowContacts.localized, for: .selected)
        self.firstButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.firstButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.firstButton.setImage(nil, for: .normal)
        self.firstButton.setImage(nil, for: .selected)
        self.firstButton.addShadow(cornerRadius: self.firstButton.height/2.0, shadowColor: AppColors.themeBlack, backgroundColor: AppColors.themeGreen)

        self.mainImageView.image = #imageLiteral(resourceName: "contactsEmpty")
        self.messageLabel.font = AppFonts.Regular.withSize(14.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.ImportContactMessage.localized
    }
    
    private func setupForImportFacebookContacts() {
        self.firstButton.isHidden = false
        self.firstButton.setTitle(LocalizedString.ConnectWithFB.localized, for: .normal)
        self.firstButton.setTitle(LocalizedString.ConnectWithFB.localized, for: .selected)
        self.firstButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.firstButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.firstButton.setImage(#imageLiteral(resourceName: "facebook"), for: .normal)
        self.firstButton.setImage(#imageLiteral(resourceName: "facebook"), for: .selected)
        self.firstButton.addShadow(cornerRadius: self.firstButton.height/2.0, shadowColor: AppColors.themeBlack, backgroundColor: AppColors.fbButtonBackgroundColor)

        self.mainImageView.image = #imageLiteral(resourceName: "facebookEmpty")
        self.messageLabel.font = AppFonts.Regular.withSize(14.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.ImportFacebookMessage.localized
    }
    
    private func setupForImportGoogleContacts() {
        self.firstButton.isHidden = false
        self.firstButton.setTitle(LocalizedString.ConnectWithGoogle.localized, for: .normal)
        self.firstButton.setTitle(LocalizedString.ConnectWithGoogle.localized, for: .selected)
        self.firstButton.setTitleColor(AppColors.themeBlack, for: .normal)
        self.firstButton.setTitleColor(AppColors.themeBlack, for: .selected)
        self.firstButton.setImage(#imageLiteral(resourceName: "google"), for: .normal)
        self.firstButton.setImage(#imageLiteral(resourceName: "google"), for: .selected)
        self.firstButton.addShadow(cornerRadius: self.firstButton.height/2.0, shadowColor: AppColors.themeBlack, backgroundColor: AppColors.themeWhite)
        
        self.mainImageView.image = #imageLiteral(resourceName: "googleEmpty")
        self.messageLabel.font = AppFonts.Regular.withSize(14.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.ImportGoogleMessage.localized
    }
    
    private func getTextWithImage(startText: String, image: UIImage, endText: String) -> NSMutableAttributedString {
        // create an NSMutableAttributedString that we'll append everything to
        let fullString = NSMutableAttributedString(string: startText)
        
        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = image
        
        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: endText))
        
        return fullString
    }
}
