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
        case noStatementGenrated
        case noAccountResult
        case noUpCommingBooking
        case noCompletedBooking
        case noCanceledBooking
        case noPendingAction
        case noUpCommingBookingFilter
        case noCompletedBookingFilter
        case noCanceledBookingFilter
        case noSeatMapData
        case noMealsData
        case noBaggageData
        case noOthersData
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
//    @IBOutlet weak var messageLabelTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var mainImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var firstbuttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomButtonHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var firstButtonTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var bottomButtonTopConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var mainImageViewLeadingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var mainImageViewTrainlingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var labelsStackView: UIStackView!
    
    @IBOutlet weak var buttonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonTrailingConstraint: NSLayoutConstraint!
    
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
        
        self.addTapGesture()
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(_:)))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tap)
    }
    
    @objc func tapHandler(_ sender: UIGestureRecognizer) {
        AppDelegate.shared.window?.endEditing(true)
        UIApplication.topViewController()?.view.endEditing(true)
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
            
        case .noStatementGenrated :
            self.setupForNoStatementGenrated()
            
        case .noAccountResult :
            self.setupForNoAccountResult()
            
        case .noUpCommingBooking :
            self.setUpNoUpCommingBooking()
            
        case .noPendingAction:
            self.setUpNoPendingAction()
            
        case .noCompletedBooking:
            self.setUpNoCompletedBooking()
            
        case .noCanceledBooking:
            self.setUpNoCanceledBooking()
            
        case .noUpCommingBookingFilter:
            self.setUpNoUpCommingBookingFilter()
            
        case .noCompletedBookingFilter:
            self.setUpNoCompletedBookingFilter()
            
        case .noCanceledBookingFilter:
            self.setUpNoCanceledBookingFilter()
            
        case .noSeatMapData:
            setupForNoSeatMapData()
            
        case .noMealsData:
            self.setupForNoMealsData()
            
        case .noBaggageData:
            self.setupForNoBaggageData()
            
        case .noOthersData:
            self.setupForNoOthersData()
            
        }
        
    }
    
    private func hideFirstButton(isHidden: Bool) {
        self.firstButtonContainerView.isHidden = isHidden
        self.firstbuttonHeightConstraint.constant = isHidden ? 0.0 : 45.0
       // self.firstButtonTopConstraint.constant = isHidden ? 0.0 : 20.0
    }
    
    private func hideBottomButton(isHidden: Bool) {
        self.bottomButton.isHidden = isHidden
        self.bottomButtonHeightConstraint.constant = isHidden ? 0.0 : 45.0
       // self.bottomButtonTopConstraint.constant = isHidden ? 0.0 : 10.0
    }
    
    //MARK: - Tenant My Apartments -
    private func setupForNone() {
        self.hideFirstButton(isHidden: true)
        self.mainImageView.image = nil
        self.messageLabel.font = AppFonts.Regular.withSize(17.0)
        self.messageLabel.textColor = AppColors.themeGray40
        self.messageLabel.text = LocalizedString.noData.localized
    }
    
    private func setupForNoAccountTransection() {
        self.hideFirstButton(isHidden: true)
        self.mainImageView.image = nil
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = " \n\(LocalizedString.NoTransactions.localized)"
    }
    
    private func setupForNoStatementGenrated() {
        self.hideFirstButton(isHidden: true)
        self.mainImageView.image = nil
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.NoStatementGenerated.localized
    }
    
    private func setupForNoAccountResult() {
        self.hideFirstButton(isHidden: true)
        self.mainImageView.image = nil
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.Oops.localized
        
        self.searchTextLabel.isHidden = false
        self.searchTextLabel.font = AppFonts.Regular.withSize(18.0)
        self.searchTextLabel.textColor = AppColors.themeGray60
        self.searchTextLabel.text = LocalizedString.NoResultsFound.localized
        
        self.hideBottomButton(isHidden: false)
        self.bottomButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.bottomButton.setTitle(LocalizedString.ClearFilters.localized, for: .normal)
        self.bottomButton.setTitle(LocalizedString.ClearFilters.localized, for: .selected)
        self.bottomButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.bottomButton.setTitleColor(AppColors.themeGreen, for: .selected)
    }
    
    private func setupForNoTraveller() {
        self.hideFirstButton(isHidden: true)
        
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
        self.hideFirstButton(isHidden: true)
        
        self.mainImageView.image = #imageLiteral(resourceName: "ic_no_traveller")
        
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.textFieldTextColor51
        self.messageLabel.text = "Friends that travel together, stay together!"
        
        self.searchTextLabel.isHidden = false
        self.searchTextLabel.font = AppFonts.Regular.withSize(16.0)
        self.searchTextLabel.textColor = AppColors.themeGray60
        self.searchTextLabel.text = "Make a list of your travel companions, and access it on all platforms"
        
        self.hideBottomButton(isHidden: false)
        self.bottomButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.bottomButton.setTitle("\(LocalizedString.Add.localized) \(LocalizedString.Travellers.localized)", for: .normal)
        self.bottomButton.setTitle("\(LocalizedString.Add.localized) \(LocalizedString.Travellers.localized)", for: .selected)
        self.bottomButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.bottomButton.setTitleColor(AppColors.themeGreen, for: .selected)
    }
    
    private func setupForHotelPreferences() {
        self.hideFirstButton(isHidden: true)
        self.bottomButton.isHidden = true
        self.searchTextLabel.isHidden = true
     //   self.messageLabelTopConstraint.constant = 30
     //   self.mainImageViewTopConstraint.constant = -171
        self.mainImageView.image = #imageLiteral(resourceName: "hotelEmpty")
        self.messageLabel.font = AppFonts.Regular.withSize(18.0)
        self.messageLabel.textColor = AppColors.themeGray40
     //   self.mainImageViewLeadingConstraint.constant = 54.0
     //   self.mainImageViewTrainlingConstraint.constant = 74.0
        self.messageLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "Tap  ", image: #imageLiteral(resourceName: "emptyHotelIcon"), endText: "  to add a hotel to favorite list", font: AppFonts.Regular.withSize(17.0))//"Tap   to add a hotel to favorite list"
    }
    
    private func setupForImportPhoneContacts() {
        self.hideFirstButton(isHidden: false)
        self.bottomButton.isHidden = true
        self.searchTextLabel.isHidden = true
        self.containerStackView.spacing = 26
        
        self.firstbuttonHeightConstraint.constant = 50
        self.buttonLeadingConstraint.constant = 16
        self.buttonTrailingConstraint.constant = 16
        self.firstButton.layoutIfNeeded()
        self.firstButton.setTitle(LocalizedString.AllowContacts.localized, for: .normal)
        self.firstButton.setTitle(LocalizedString.AllowContacts.localized, for: .selected)
        self.firstButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.firstButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.firstButton.setTitleFont(font: AppFonts.SemiBold.withSize(16.0), for: .normal)
        
        self.firstButton.layer.cornerRadius = self.firstButton.height / 2.0
        self.firstButton.shadowColor = AppColors.clear
        self.firstButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
        self.firstButton.isSocial = true
        
        self.mainImageView.image = #imageLiteral(resourceName: "contactsEmpty")
        self.messageLabel.font = AppFonts.Regular.withSize(14.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.ImportContactMessage.localized
    }
    
    private func setupForImportFacebookContacts() {
        self.hideFirstButton(isHidden: false)
        self.bottomButton.isHidden = true
        self.searchTextLabel.isHidden = true
        self.containerStackView.spacing = 26
        
        self.firstbuttonHeightConstraint.constant = 50
        self.buttonLeadingConstraint.constant = 16
        self.buttonTrailingConstraint.constant = 16
        self.firstButton.layoutIfNeeded()
        self.firstButton.gradientColors = [AppColors.fbButtonBackgroundColor, AppColors.fbButtonBackgroundColor]
        self.firstButton.setTitle(LocalizedString.ConnectWithFB.localized, for: .normal)
        self.firstButton.setTitle(LocalizedString.ConnectWithFB.localized, for: .selected)
        self.firstButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.firstButton.setTitleColor(AppColors.themeWhite, for: .selected)
        
        self.firstButton.setTitleFont(font: AppFonts.SemiBold.withSize(16.0), for: .normal)
        self.firstButton.setImage(#imageLiteral(resourceName: "facebook").withRenderingMode(.alwaysOriginal), for: .normal)
        self.firstButton.setImage(#imageLiteral(resourceName: "facebook").withRenderingMode(.alwaysOriginal), for: .selected)
        self.firstButton.layer.cornerRadius = self.firstButton.height / 2.0
        self.firstButton.shadowColor = AppColors.clear
        self.firstButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
        self.firstButton.isSocial = true
        self.mainImageView.image = #imageLiteral(resourceName: "facebookEmpty")
        self.messageLabel.font = AppFonts.Regular.withSize(14.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.ImportFacebookMessage.localized
    }
    
    private func setupForImportGoogleContacts() {
        self.hideFirstButton(isHidden: false)
        self.bottomButton.isHidden = true
        self.searchTextLabel.isHidden = true
        self.containerStackView.spacing = 26
        
        self.firstbuttonHeightConstraint.constant = 50
        self.buttonLeadingConstraint.constant = 16
        self.buttonTrailingConstraint.constant = 16
        self.firstButton.layoutIfNeeded()
        self.firstButton.gradientColors = [AppColors.themeWhite, AppColors.themeWhite]
        self.firstButton.setTitle(LocalizedString.ConnectWithGoogle.localized, for: .normal)
        self.firstButton.setTitle(LocalizedString.ConnectWithGoogle.localized, for: .selected)
        
        self.firstButton.setTitleColor(AppColors.themeBlack, for: .normal)
        self.firstButton.setTitleColor(AppColors.themeBlack, for: .selected)
        
        self.firstButton.setTitleFont(font: AppFonts.SemiBold.withSize(16.0), for: .normal)
        
        self.firstButton.setImage(#imageLiteral(resourceName: "google").withRenderingMode(.alwaysOriginal), for: .normal)
        self.firstButton.setImage(#imageLiteral(resourceName: "google").withRenderingMode(.alwaysOriginal), for: .selected)
        self.firstButton.layer.cornerRadius = self.firstButton.height / 2.0
        self.firstButton.shadowColor = AppColors.clear
        self.firstButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
        
        
        self.firstButton.isSocial = true
        
        self.mainImageView.image = #imageLiteral(resourceName: "googleEmpty")
        self.messageLabel.font = AppFonts.Regular.withSize(14.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.ImportGoogleMessage.localized
    }
    
    private func setUpNoResult() {
        self.bottomButton.isHidden = true
        //self.containerViewCenterYConstraint.constant = -125
        self.containerView.center = self.contentView.center
     //   self.mainImageViewTopConstraint.constant = -25
     //   self.messageLabelTopConstraint.constant = 39
     //   self.firstButtonTopConstraint.constant = 0
        self.firstbuttonHeightConstraint.constant  = 0.0
        self.firstButton.isHidden = true
        self.mainImageView.image = #imageLiteral(resourceName: "frequentFlyerEmpty")
        self.firstButtonContainerView.isHidden = true
        self.backgroundColor = .blue
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.noResults.localized
        self.labelsStackView.spacing = 9
        self.containerStackView.spacing = 33
        self.containerStackView.layoutIfNeeded()
    }
    
    private func setUpNoHotelFound() {
        self.containerViewCenterYConstraint.constant = 0
    //    self.messageLabelTopConstraint.constant = 0
        self.mainImageView.image = #imageLiteral(resourceName: "noHotelFound")
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.attributedText = getAttributedBoldText(text: LocalizedString.NoHotelFound.localized, boldText: LocalizedString.NoHotelFoundMessage.localized)
        self.bottomButton.isHidden = true
        self.searchTextLabel.isHidden = true
    }
    
    private func setUpNoHotelFoundOnFilter() {
        self.containerViewCenterYConstraint.constant = 0
     //   self.messageLabelTopConstraint.constant = 0
        self.mainImageView.image = #imageLiteral(resourceName: "noHotelFound")
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.attributedText = getAttributedBoldText(text: LocalizedString.NoHotelFoundFilter.localized, boldText: LocalizedString.NoHotelFoundMessageOnFilter.localized)
        self.bottomButton.isHidden = true
        self.searchTextLabel.isHidden = true
    }
    
    
    private func getAttributedBoldText(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(22.0), .foregroundColor: AppColors.themeBlack])
        attString.addAttributes([
            .font: AppFonts.Regular.withSize(18.0),
            .foregroundColor: AppColors.themeGray60
        ], range:(text as NSString).range(of: boldText))
        return attString
    }
    
    private func setUpNoUpCommingBooking() {
        //self.containerViewCenterYConstraint.constant = -125
        self.containerView.center = self.contentView.center
      //  self.mainImageViewTopConstraint.constant = -25
      //  self.messageLabelTopConstraint.constant = 39
      //  self.firstButtonTopConstraint.constant = 0
        self.firstbuttonHeightConstraint.constant  = 0.0
        self.firstButton.isHidden = true
        self.bottomButton.isHidden = true
        self.mainImageView.image = #imageLiteral(resourceName: "upcoming_emptystate")
        self.firstButtonContainerView.isHidden = true
        self.bottomButton.isHidden = true
        self.backgroundColor = .blue
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        let message = LocalizedString.YouHaveNoUpcomingBookings.localized + "\n" + LocalizedString.NewDestinationsAreAwaiting.localized
        self.messageLabel.text = message
        self.messageLabel.AttributedFontAndColorForText(atributedText: LocalizedString.NewDestinationsAreAwaiting.localized, textFont: AppFonts.Regular.withSize(18.0), textColor: AppColors.themeGray60)
        self.searchTextLabel.isHidden = true
        self.containerStackView.spacing = 3
    }
    
    private func setUpNoPendingAction() {
        //self.containerViewCenterYConstraint.constant = -125
        self.containerView.center = self.contentView.center
    //    self.mainImageViewTopConstraint.constant = -25
    //    self.messageLabelTopConstraint.constant = 39
    //    self.firstButtonTopConstraint.constant = 0
        self.firstbuttonHeightConstraint.constant  = 0.0
        self.firstButton.isHidden = true
        self.bottomButton.isHidden = true
        self.mainImageView.image = #imageLiteral(resourceName: "upcoming_emptystate")
        self.firstButtonContainerView.isHidden = true
        self.backgroundColor = .blue
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        let message = LocalizedString.YouHaveNoPendingAction.localized + "\n" + LocalizedString.NewDestinationsAreAwaiting.localized
        self.messageLabel.text = message
        self.messageLabel.AttributedFontAndColorForText(atributedText: LocalizedString.NewDestinationsAreAwaiting.localized, textFont: AppFonts.Regular.withSize(18.0), textColor: AppColors.themeGray60)
        self.searchTextLabel.isHidden = true
        self.containerStackView.spacing = 3
    }
    
    private func setUpNoCompletedBooking() {
        //self.containerViewCenterYConstraint.constant = -125
        self.containerView.center = self.contentView.center
     //   self.mainImageViewTopConstraint.constant = -25
     //   self.messageLabelTopConstraint.constant = 39
     //   self.firstButtonTopConstraint.constant = 0
        self.firstbuttonHeightConstraint.constant  = 0.0
        self.firstButton.isHidden = true
        self.bottomButton.isHidden = true
        self.mainImageView.image = #imageLiteral(resourceName: "upcoming_emptystate")
        self.firstButtonContainerView.isHidden = true
        self.backgroundColor = .blue
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        let message = LocalizedString.YouHaveNoCompletedBookings.localized + "\n" + LocalizedString.NewDestinationsAreAwaiting.localized
        self.messageLabel.text = message
        self.messageLabel.AttributedFontAndColorForText(atributedText: LocalizedString.NewDestinationsAreAwaiting.localized, textFont: AppFonts.Regular.withSize(18.0), textColor: AppColors.themeGray60)
        self.searchTextLabel.isHidden = true
        self.containerStackView.spacing = 3
    }
    
    private func setUpNoCanceledBooking() {
        //self.containerViewCenterYConstraint.constant = -125
//        self.containerView.center = self.contentView.center
    //    self.mainImageViewTopConstraint.constant = -25
    //    self.messageLabelTopConstraint.constant = 39
    //    self.firstButtonTopConstraint.constant = 0
        self.firstbuttonHeightConstraint.constant  = 0.0
        self.firstButton.isHidden = true
        self.bottomButton.isHidden = true
        self.mainImageView.image = #imageLiteral(resourceName: "upcoming_emptystate")
        self.firstButtonContainerView.isHidden = true
        self.backgroundColor = .blue
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        let message = LocalizedString.YouHaveNoCancelledBookings.localized + "\n" + LocalizedString.NewDestinationsAreAwaiting.localized
        self.messageLabel.text = message
        self.messageLabel.AttributedFontAndColorForText(atributedText: LocalizedString.NewDestinationsAreAwaiting.localized, textFont: AppFonts.Regular.withSize(18.0), textColor: AppColors.themeGray60)
        self.searchTextLabel.isHidden = true
        self.containerStackView.spacing = 3
    }
    
    private func setUpNoUpCommingBookingFilter() {
        self.hideFirstButton(isHidden: true)
        self.mainImageView.image = nil
        self.mainImageView.isHidden = true
  //      self.messageLabelTopConstraint.constant = 0
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.NoBookingAvailable.localized
        
        self.searchTextLabel.isHidden = false
        self.searchTextLabel.font = AppFonts.Regular.withSize(18.0)
        self.searchTextLabel.textColor = AppColors.themeGray60
        self.searchTextLabel.text = LocalizedString.NoBookingAvailableMessage.localized
        
        self.hideBottomButton(isHidden: false)
        self.bottomButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.bottomButton.setTitle(LocalizedString.ClearFilters.localized, for: .normal)
        self.bottomButton.setTitle(LocalizedString.ClearFilters.localized, for: .selected)
        self.bottomButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.bottomButton.setTitleColor(AppColors.themeGreen, for: .selected)
    }
    
    private func setUpNoCompletedBookingFilter() {
        self.hideFirstButton(isHidden: true)
        self.mainImageView.image = nil
        self.mainImageView.isHidden = true
        //self.messageLabelTopConstraint.constant = 0
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.NoBookingAvailable.localized
        
        self.searchTextLabel.isHidden = false
        self.searchTextLabel.font = AppFonts.Regular.withSize(18.0)
        self.searchTextLabel.textColor = AppColors.themeGray60
        self.searchTextLabel.text = LocalizedString.NoBookingAvailableMessage.localized
        
        self.hideBottomButton(isHidden: false)
        self.bottomButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.bottomButton.setTitle(LocalizedString.ClearFilters.localized, for: .normal)
        self.bottomButton.setTitle(LocalizedString.ClearFilters.localized, for: .selected)
        self.bottomButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.bottomButton.setTitleColor(AppColors.themeGreen, for: .selected)
    }
    
    private func setUpNoCanceledBookingFilter() {
        self.hideFirstButton(isHidden: true)
        self.mainImageView.image = nil
        self.mainImageView.isHidden = true
        //self.messageLabelTopConstraint.constant = 0
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.NoBookingAvailable.localized
        
        self.searchTextLabel.isHidden = false
        self.searchTextLabel.font = AppFonts.Regular.withSize(18.0)
        self.searchTextLabel.textColor = AppColors.themeGray60
        self.searchTextLabel.text = LocalizedString.NoBookingAvailableMessage.localized
        
        self.hideBottomButton(isHidden: false)
        self.bottomButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.bottomButton.setTitle(LocalizedString.ClearFilters.localized, for: .normal)
        self.bottomButton.setTitle(LocalizedString.ClearFilters.localized, for: .selected)
        self.bottomButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.bottomButton.setTitleColor(AppColors.themeGreen, for: .selected)
    }
    
    private func setupForNoSeatMapData() {
        self.hideFirstButton(isHidden: true)
        self.mainImageView.image = #imageLiteral(resourceName: "frequentFlyerEmpty")
        self.containerView.center = self.contentView.center
//        self.mainImageViewTopConstraint.constant = -25
//        self.messageLabelTopConstraint.constant = 39
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.Oops.localized
        
        self.searchTextLabel.isHidden = false
        self.searchTextLabel.font = AppFonts.Regular.withSize(18.0)
        self.searchTextLabel.textColor = AppColors.themeGray60
        self.searchTextLabel.text = LocalizedString.noSeatMapDataDesc.localized
    }
    
    private func setupForNoMealsData() {
        self.hideFirstButton(isHidden: true)
        self.mainImageView.image = #imageLiteral(resourceName: "frequentFlyerEmpty")
        self.containerView.center = self.contentView.center
//        self.mainImageViewTopConstraint.constant = -25
//        self.messageLabelTopConstraint.constant = 39
        self.messageLabel.font = AppFonts.Regular.withSize(22.0)
        self.messageLabel.textColor = AppColors.themeBlack
        self.messageLabel.text = LocalizedString.Oops.localized
        
        self.searchTextLabel.isHidden = false
        self.searchTextLabel.font = AppFonts.Regular.withSize(18.0)
        self.searchTextLabel.textColor = AppColors.themeGray60
        self.searchTextLabel.text = LocalizedString.noMealsDataDesc.localized
    }
    
    private func setupForNoBaggageData() {
          self.hideFirstButton(isHidden: true)
          self.mainImageView.image = #imageLiteral(resourceName: "frequentFlyerEmpty")
          self.containerView.center = self.contentView.center
//          self.mainImageViewTopConstraint.constant = -25
//          self.messageLabelTopConstraint.constant = 39
          self.messageLabel.font = AppFonts.Regular.withSize(22.0)
          self.messageLabel.textColor = AppColors.themeBlack
          self.messageLabel.text = LocalizedString.Oops.localized
          
          self.searchTextLabel.isHidden = false
          self.searchTextLabel.font = AppFonts.Regular.withSize(18.0)
          self.searchTextLabel.textColor = AppColors.themeGray60
          self.searchTextLabel.text = LocalizedString.noBaggageDataDesc.localized
      }
    
    private func setupForNoOthersData() {
          self.hideFirstButton(isHidden: true)
          self.mainImageView.image = #imageLiteral(resourceName: "frequentFlyerEmpty")
          self.containerView.center = self.contentView.center
//          self.mainImageViewTopConstraint.constant = -25
//          self.messageLabelTopConstraint.constant = 39
          self.messageLabel.font = AppFonts.Regular.withSize(22.0)
          self.messageLabel.textColor = AppColors.themeBlack
          self.messageLabel.text = LocalizedString.Oops.localized
          
          self.searchTextLabel.isHidden = false
          self.searchTextLabel.font = AppFonts.Regular.withSize(18.0)
          self.searchTextLabel.textColor = AppColors.themeGray60
          self.searchTextLabel.text = LocalizedString.noOtherseDataDesc.localized
      }
    
}



