//
//  HotelInfoAddressCell.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelInfoAddressCell: UITableViewCell {
    // Mark:- Variables
    //================
    
    // Mark:- IBOutlets
    //================
    @IBOutlet weak var addressLblTopConst: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressInfoTextView: PKTapAndCopyUITextView! {
        didSet {
            self.addressInfoTextView.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var moreViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var deviderView: ATDividerView!
    @IBOutlet weak var moreBtnOutlet: UIButton!
    @IBOutlet weak var moreBtnContainerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var infoTextViewTrailingConstraint: NSLayoutConstraint! {
        didSet {
            self.infoTextViewTrailingConstraint.constant = 0.0
        }
    }
    
    @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerBottomConstraint: NSLayoutConstraint!
    
    var isMoreButtonTapped: Bool = false
    // Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
        setColorsForBooking()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.configureUI()
        self.moreBtnOutlet.isUserInteractionEnabled = true
        addressInfoTextView.textContainer.lineBreakMode = .byTruncatingTail
    }
    // Mark:- Methods
    //==============
    private func initialSetUp() {
        self.addressInfoTextView.isEditable = false
        self.addressInfoTextView.textContainerInset = UIEdgeInsets.zero
        self.addressInfoTextView.textContainer.lineFragmentPadding = 0.0
        self.configureUI()
        self.addGestures()
    }
    
    /// COnfigure UI
    private func configureUI() {
        // SetUps
//        self.moreBtnContainerView.addGredient(isVertical: false, colors: [.white, UIColor.white.withAlphaComponent(0)])
        self.gradientView.backgroundColor = .clear
        self.gradientView.addGredient(isVertical: false, colors: [AppColors.themeBlack26.withAlphaComponent(0), AppColors.themeBlack26])
        self.moreBtnContainerView.isHidden = true
        
        // Color
        self.addressLabel.textColor = AppColors.themeBlack
        //self.deviderView.backgroundColor = AppColors.divider.color
        self.moreBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        self.backgroundColor = AppColors.clear
        self.contentView.backgroundColor = AppColors.clear
        
        
        // Size
        self.addressLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.addressInfoTextView.font = AppFonts.Regular.withSize(18.0)
        self.moreBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        
        // Text
        self.moreBtnOutlet.setTitle(LocalizedString.More.localized, for: .normal)
        
    }
    
    private func addGestures(){
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressTapped))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewTapped))
        self.addressInfoTextView.isUserInteractionEnabled = true
        self.addGestureRecognizer(longPressGesture)
        self.addressInfoTextView.addGestureRecognizer(tapGesture)
        
        addressInfoTextView.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    /// AttributeLabelSetup
    private func attributeLabelSetUp(overview: String) {
//        let attributedString = NSMutableAttributedString()
//        let blackAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
//        let blackAttributedString = NSAttributedString(string: overview, attributes: blackAttribute)
//        attributedString.append(blackAttributedString)
//
        let attrText = overview.htmlToAttributedString(withFontSize: 18.0, fontFamily: AppFonts.Regular.withSize(18.0).familyName, fontColor: AppColors.themeBlack)
        self.addressInfoTextView.attributedText = attrText
        self.moreBtnContainerView.isHidden = (self.addressInfoTextView.numberOfLines >= 3) ? false : true
    }
    
    @objc func longPressTapped() {
        printDebug("Long press ")
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.setTargetRect(CGRect(x: self.addressInfoTextView.center.x, y: self.addressInfoTextView.center.y, width: 0.0, height: 0.0), in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    
    @objc func textViewTapped() {
        if let parentVC = self.parentViewController as? HotelDetailsVC {
            parentVC.openMap()
        }else if let parentVC = self.parentViewController as? BookingHotelDetailVC{
            parentVC.openMaps()
        }
    }
    
    func setColorsForBooking(){
        self.contentView.backgroundColor = AppColors.themeBlack26
        self.moreBtnOutlet.backgroundColor = AppColors.themeBlack26
//        self.moreBtnContainerView.backgroundColor = AppColors.themeBlack26
        
    }
 
    
    internal func configureAddressCell(hotelData: HotelDetails = HotelDetails(),isForBooking: Bool = false,address: String = "") {
        addressInfoTextView.textContainer.lineBreakMode = .byWordWrapping
        self.addressInfoTextView.textContainer.maximumNumberOfLines = 0
        self.moreBtnOutlet.isHidden = true
        self.addressLabel.text = LocalizedString.AddressSmallLaters.localized
        if isForBooking {
            if address.isEmpty {
                self.addressInfoTextView.text = "-"
            } else {
                self.addressInfoTextView.attributedText = AppGlobals.shared.getTextWithImageWithLink(startText: address, startTextColor: AppColors.themeBlack, middleText: "\n" + LocalizedString.Maps.localized + " ", image: AppImages.send_icon, endText: "", endTextColor: AppColors.themeGreen, middleTextColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
            }
        } else {
                self.addressInfoTextView.attributedText = AppGlobals.shared.getTextWithImageWithLink(startText: hotelData.address, startTextColor: AppColors.themeBlack, middleText: "\n" + LocalizedString.Maps.localized + " ", image: AppImages.send_icon, endText: "", endTextColor: AppColors.themeGreen, middleTextColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
            
        }
    }
    
    internal func configureOverviewCell(hotelData: HotelDetails = HotelDetails(), isForBooking: Bool = false, overview: String = "") {
        self.containerView.layoutIfNeeded()
        self.moreBtnOutlet.isHidden = false
        self.addressInfoTextView.textContainer.maximumNumberOfLines = 3
        self.addressLabel.text = LocalizedString.Overview.localized
        if isForBooking {
            self.addressInfoTextView.attributedText = AppGlobals.shared.getTextWithImageWithLink(startText:  overview, startTextColor: AppColors.themeBlack, middleText: " ", image: AppImages.send_icon, endText: "", endTextColor: AppColors.themeGreen, middleTextColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
             self.moreBtnContainerView.isHidden = (self.addressInfoTextView.numberOfLines >= 3) ? false : true
            self.attributeLabelSetUp(overview: overview)
            self.moreBtnOutlet.isUserInteractionEnabled = false
        }
        else {
            self.addressInfoTextView.attributedText = AppGlobals.shared.getTextWithImageWithLink(startText:  hotelData.info, startTextColor: AppColors.themeBlack, middleText: " ", image: AppImages.send_icon, endText: "", endTextColor: AppColors.themeGreen, middleTextColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
             self.moreBtnContainerView.isHidden = (self.addressInfoTextView.numberOfLines >= 3) ? false : true
            self.attributeLabelSetUp(overview: hotelData.info)
            self.moreBtnOutlet.isUserInteractionEnabled = false
        }
    }
    
    internal func hcConfigureAddressCell(address: String) {
        self.moreBtnOutlet.isHidden = true
        self.addressLabel.text = LocalizedString.AddressSmallLaters.localized
        self.addressInfoTextView.attributedText = AppGlobals.shared.getTextWithImageWithLink(startText: address, startTextColor: AppColors.themeBlack, middleText: "\n" + LocalizedString.Maps.localized + " ", image: AppImages.send_icon, endText: "", endTextColor: AppColors.themeGreen, middleTextColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
    }
    
    internal func configureNotesCell(notes: String, isHiddenDivider: Bool = false) {
        self.containerView.layoutIfNeeded()
        self.moreBtnOutlet.isHidden = false
        self.addressInfoTextView.textContainer.maximumNumberOfLines = 3
        self.addressLabel.text = LocalizedString.Overview.localized
        self.addressInfoTextView.attributedText = AppGlobals.shared.getTextWithImageWithLink(startText:  notes, startTextColor: AppColors.themeBlack, middleText: " ", image: AppImages.send_icon, endText: "", endTextColor: AppColors.themeGreen, middleTextColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
         self.moreBtnContainerView.isHidden = (self.addressInfoTextView.numberOfLines >= 3) ? false : true
        self.attributeLabelSetUp(overview: notes)
        self.moreBtnOutlet.isUserInteractionEnabled = false
        
//        self.moreBtnOutlet.isHidden = self.isMoreButtonTapped
        self.addressLabel.font = AppFonts.Regular.withSize(14.0)
//        self.addressInfoTextView.font = AppFonts.Regular.withSize(18.0)
        self.addressLabel.textColor = AppColors.themeGray40
//        self.addressInfoTextView.textColor = AppColors.themeBlack
        self.addressLabel.text = LocalizedString.capNotes.localized
//        self.addressInfoTextView.textContainer.maximumNumberOfLines = self.isMoreButtonTapped ? 0 : 3
//        self.addressInfoTextView.isScrollEnabled = false
//        let attrText = notes.htmlToAttributedString(withFontSize: 18.0, fontFamily: AppFonts.Regular.withSize(18.0).familyName, fontColor: AppColors.themeBlack)
//        self.addressInfoTextView.attributedText = attrText
//        self.moreBtnContainerView.isHidden = (self.addressInfoTextView.numberOfLines >= 3) && !self.isMoreButtonTapped ? false : true
        self.deviderView.isHidden = isHiddenDivider
    }
    
    internal func setupForAllDoneVC() {
        self.containerLeadingConstraint.constant = 16
        self.containerTrailingConstraint.constant = 16
        self.layoutIfNeeded()
        self.containerView.addShadow(cornerRadius: 0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
    }
    
    // Mark:- IBActions
    //================
//    @IBAction func mapButtonAction(_ sender: UIButton) {
//        printDebug("Go To Maps")
//    }
    
    @IBAction func moreButtonAction(_ sender: UIButton) {
        printDebug("More")
        if let parentVC = self.parentViewController as? HotelDetailsVC {
            AppFlowManager.default.presentHotelDetailsOverViewVC(overViewInfo: parentVC.viewModel.hotelData?.info ?? "")
        }
        else if let parentVC = self.parentViewController as? FlightBookingsDetailsVC {
//            self.moreBtnContainerView.isHidden = true
//            self.addressInfoTextView.textContainer.maximumNumberOfLines = 0
//            self.isMoreButtonTapped = true
//            parentVC.bookingDetailsTableView.reloadData()
            AppFlowManager.default.presentBookingNotesVC(overViewInfo: parentVC.viewModel.bookingDetail?.bookingDetail?.note ?? "")
        }
        else if let parentVC = self.parentViewController as? HotlelBookingsDetailsVC {
            self.moreBtnContainerView.isHidden = true
            self.addressInfoTextView.textContainer.maximumNumberOfLines = 0
            self.isMoreButtonTapped = true
            parentVC.bookingDetailsTableView.reloadData()
        }
    }
}

