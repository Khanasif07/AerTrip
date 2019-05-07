//
//  EmptyScreenView.swift
//  AERTRIP
//
//  Created by Admin on 03/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol EmptyScreenViewDelegate: class {
    func firstButtonAction(sender: ATButton)
    func bottomButtonAction(sender: UIButton)
}

extension EmptyScreenViewDelegate {
    func bottomButtonAction(sender: UIButton) {}
}

class EmptyScreenView: UIView {
    
    enum EmptyScreenViewType {
        case hotelPreferences
        case importPhoneContacts
        case importFacebookContacts
        case importGoogleContacts
        case none
        case noTraveller
        case noTravellerWithAddButton
        case noResult
        case noHotelFound
        case noHotelFoundOnFilter
        case noAccountTransection
        case noAccountResult
    }
    
    //MARK:- properties -
    weak var delegate: EmptyScreenViewDelegate?
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
    @IBOutlet weak var firstButton: ATButton!
    @IBOutlet weak var firstButtonContainerView: UIView! {
        didSet {
            firstButtonContainerView.backgroundColor = AppColors.clear
        }
    }
    @IBOutlet weak var containerViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    
    
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
        
        bottomButton.isHidden = true
    }
    
    //MARK:- Private Function -
    @IBAction func firstButtonAction(_ sender: ATButton) {
        self.delegate?.firstButtonAction(sender: sender)
    }
    @IBAction func bottomButtonAction(_ sender: UIButton) {
        self.delegate?.bottomButtonAction(sender: sender)
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
            
        case .noTraveller:
            self.setupForNoTraveller()
            
        case .noTravellerWithAddButton:
            self.setupForNoTravellerWithAddButton()
            
        case .noResult:
            self.setUpNoResult()
            
        case .noHotelFound:
            self.setUpNoHotelFound()
            
        case .noHotelFoundOnFilter:
            self.setUpNoHotelFoundOnFilter()
            
        case .noAccountTransection :
            self.setupForNoAccountTransection()
            
        case .noAccountResult :
            self.setupForNoAccountResult()
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
    
    private func setupForNoAccountTransection() {
        self.firstButton.isHidden = true
        self.mainImageView.image = nil
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.NoTransactions.localized
    }
    
    private func setupForNoAccountResult() {
        self.firstButton.isHidden = true
        self.mainImageView.image = nil
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.Oops.localized
        
        self.searchTextLabel.isHidden = false
        self.searchTextLabel.font = AppFonts.Regular.withSize(18.0)
        self.searchTextLabel.textColor = AppColors.themeGray60
        self.searchTextLabel.text = LocalizedString.NoResultsFound.localized
        
        self.bottomButton.isHidden = false
        self.bottomButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.bottomButton.setTitle(LocalizedString.ClearFilters.localized, for: .normal)
        self.bottomButton.setTitle(LocalizedString.ClearFilters.localized, for: .selected)
        self.bottomButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.bottomButton.setTitleColor(AppColors.themeGreen, for: .selected)
    }
    
    private func setupForNoTraveller() {
        self.firstButton.isHidden = true
        
        self.mainImageView.image = #imageLiteral(resourceName: "ic_no_traveller")
        
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.textFieldTextColor51
        self.messageLabel.text = "Friends that travel together, stay together!"
        
        self.searchTextLabel.isHidden = false
        self.searchTextLabel.font = AppFonts.Regular.withSize(16.0)
        self.searchTextLabel.textColor = AppColors.themeGray60
        self.searchTextLabel.text = "Make a list of your travel companions, and access it on all platforms"
    }
    
    private func setupForNoTravellerWithAddButton() {
        self.firstButton.isHidden = true
        
        self.mainImageView.image = #imageLiteral(resourceName: "ic_no_traveller")
        
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.textFieldTextColor51
        self.messageLabel.text = "Friends that travel together, stay together!"
        
        self.searchTextLabel.isHidden = false
        self.searchTextLabel.font = AppFonts.Regular.withSize(16.0)
        self.searchTextLabel.textColor = AppColors.themeGray60
        self.searchTextLabel.text = "Make a list of your travel companions, and access it on all platforms"
        
        self.bottomButton.isHidden = false
        self.bottomButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.bottomButton.setTitle("\(LocalizedString.Add.localized) \(LocalizedString.Travellers.localized)", for: .normal)
        self.bottomButton.setTitle("\(LocalizedString.Add.localized) \(LocalizedString.Travellers.localized)", for: .selected)
        self.bottomButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.bottomButton.setTitleColor(AppColors.themeGreen, for: .selected)
    }
    
    private func setupForHotelPreferences() {
        self.firstButton.isHidden = true
        self.mainImageView.image = #imageLiteral(resourceName: "hotelEmpty")
        self.messageLabel.font = AppFonts.Regular.withSize(17.0)
        self.messageLabel.textColor = AppColors.themeGray40
        self.messageLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "Tap ", image: #imageLiteral(resourceName: "ic_fav_hotel_text"), endText: " to add a hotel to favorite list", font: AppFonts.Regular.withSize(17.0))//"Tap   to add a hotel to favorite list"
    }
    
    private func setupForImportPhoneContacts() {
        self.firstButton.isHidden = false
        
        self.firstButton.layer.cornerRadius = self.firstButton.height / 2.0
        self.firstButton.setTitle(LocalizedString.AllowContacts.localized, for: .normal)
        self.firstButton.setTitle(LocalizedString.AllowContacts.localized, for: .selected)
        self.firstButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.firstButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.firstButton.isSocial = true
        self.firstButton.shadowColor = AppColors.themeBlack
        
        self.mainImageView.image = #imageLiteral(resourceName: "contactsEmpty")
        self.messageLabel.font = AppFonts.Regular.withSize(14.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.ImportContactMessage.localized
    }
    
    private func setupForImportFacebookContacts() {
        self.firstButton.isHidden = false

        self.firstButton.layer.cornerRadius = self.firstButton.height / 2.0
        self.firstButton.gradientColors = [AppColors.fbButtonBackgroundColor, AppColors.fbButtonBackgroundColor]
        self.firstButton.setTitle(LocalizedString.ConnectWithFB.localized, for: .normal)
        self.firstButton.setTitle(LocalizedString.ConnectWithFB.localized, for: .selected)
        self.firstButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.firstButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.firstButton.setImage(#imageLiteral(resourceName: "facebook"), for: .normal)
        self.firstButton.setImage(#imageLiteral(resourceName: "facebook"), for: .selected)
        self.firstButton.isSocial = true
        self.firstButton.shadowColor = AppColors.themeBlack
        
        self.mainImageView.image = #imageLiteral(resourceName: "facebookEmpty")
        self.messageLabel.font = AppFonts.Regular.withSize(14.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.ImportFacebookMessage.localized
    }
    
    private func setupForImportGoogleContacts() {
        self.firstButton.isHidden = false

        self.firstButton.layer.cornerRadius = self.firstButton.height / 2.0
        self.firstButton.gradientColors = [AppColors.themeWhite, AppColors.themeWhite]
        self.firstButton.setTitle(LocalizedString.ConnectWithGoogle.localized, for: .normal)
        self.firstButton.setTitle(LocalizedString.ConnectWithGoogle.localized, for: .selected)
        self.firstButton.setTitleColor(AppColors.themeBlack, for: .normal)
        self.firstButton.setTitleColor(AppColors.themeBlack, for: .selected)
        self.firstButton.setImage(#imageLiteral(resourceName: "google"), for: .normal)
        self.firstButton.setImage(#imageLiteral(resourceName: "google"), for: .selected)
        self.firstButton.isSocial = true
        self.firstButton.shadowColor = AppColors.themeBlack
        
        self.mainImageView.image = #imageLiteral(resourceName: "googleEmpty")
        self.messageLabel.font = AppFonts.Regular.withSize(14.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.ImportGoogleMessage.localized
    }
    
    private func setUpNoResult() {
        self.containerViewCenterYConstraint.constant = -125
        self.messageLabelTopConstraint.constant = 33
        self.mainImageView.image = #imageLiteral(resourceName: "frequentFlyerEmpty")
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.noResults.localized
        
    }
    
    private func setUpNoHotelFound() {
        self.containerViewCenterYConstraint.constant = 0
        self.messageLabelTopConstraint.constant = 0
        self.mainImageView.image = #imageLiteral(resourceName: "noHotelFound")
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.attributedText = getAttributedBoldText(text: LocalizedString.NoHotelFound.localized, boldText: LocalizedString.NoHotelFoundMessage.localized)
       
    }
    
    private func setUpNoHotelFoundOnFilter() {
        self.containerViewCenterYConstraint.constant = 0
        self.messageLabelTopConstraint.constant = 0
        self.mainImageView.image = #imageLiteral(resourceName: "noHotelFound")
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.attributedText = getAttributedBoldText(text: LocalizedString.NoHotelFoundFilter.localized, boldText: LocalizedString.NoHotelFoundMessageOnFilter.localized)
        
    }
    
    
    private func getAttributedBoldText(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(22.0), .foregroundColor: AppColors.themeBlack])
        attString.addAttributes([
            .font: AppFonts.Regular.withSize(18.0),
            .foregroundColor: AppColors.themeGray60
            ], range:(text as NSString).range(of: boldText))
        return attString
    }
}
