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
    @IBOutlet var containerView: UIView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var addressInfoTextView: UITextView! {
        didSet {
            self.addressInfoTextView.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet var deviderView: UIView!
    @IBOutlet var moreBtnOutlet: UIButton!
    @IBOutlet var moreBtnContainerView: UIView!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var infoTextViewTrailingConstraint: NSLayoutConstraint! {
        didSet {
            self.infoTextViewTrailingConstraint.constant = 0.0
        }
    }
    
    var isMoreButtonTapped: Bool = false
    // Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    // Mark:- Methods
    //==============
    private func initialSetUp() {
        self.addressInfoTextView.isEditable = false
        self.addressInfoTextView.textContainerInset = UIEdgeInsets.zero
        self.addressInfoTextView.textContainer.lineFragmentPadding = 0.0
        self.configureUI()
    }
    
    /// COnfigure UI
    private func configureUI() {
        // SetUps
        self.moreBtnContainerView.addGradientWithColor(color: AppColors.themeWhite)
        self.moreBtnContainerView.isHidden = true
        
        // Color
        self.addressLabel.textColor = AppColors.themeBlack
        self.deviderView.backgroundColor = AppColors.divider.color
        self.moreBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        
        // Size
        self.addressLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.addressInfoTextView.font = AppFonts.Regular.withSize(18.0)
        self.moreBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        
        // Text
        self.moreBtnOutlet.setTitle(LocalizedString.More.localized, for: .normal)
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
    
 
    
    internal func configureAddressCell(hotelData: HotelDetails = HotelDetails(),isForBooking: Bool = false,address: String = "") {
        self.moreBtnOutlet.isHidden = true
        self.addressLabel.text = LocalizedString.AddressSmallLaters.localized
        if isForBooking {
            self.addressInfoTextView.attributedText = AppGlobals.shared.getTextWithImageWithLink(startText: hotelData.address, startTextColor: AppColors.themeBlack, middleText: " " + LocalizedString.Maps.localized + " ", image: #imageLiteral(resourceName: "send_icon"), endText: "", endTextColor: AppColors.themeGreen, middleTextColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        } else {
            if address.isEmpty {
                self.addressInfoTextView.text = "-"
            } else {
                self.addressInfoTextView.attributedText = AppGlobals.shared.getTextWithImageWithLink(startText: address, startTextColor: AppColors.themeBlack, middleText: " " + LocalizedString.Maps.localized + " ", image: #imageLiteral(resourceName: "send_icon"), endText: "", endTextColor: AppColors.themeGreen, middleTextColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
            }
        }
        
    }
    
    internal func configureOverviewCell(hotelData: HotelDetails = HotelDetails(), isForBooking: Bool = false, overview: String = "") {
        self.moreBtnOutlet.isHidden = false
        self.addressInfoTextView.textContainer.maximumNumberOfLines = 3
        self.addressLabel.text = LocalizedString.Overview.localized
        if isForBooking {
            self.attributeLabelSetUp(overview: overview)
        }
        else {
            self.attributeLabelSetUp(overview: hotelData.info)
        }
    }
    
    internal func hcConfigureAddressCell(address: String) {
        self.moreBtnOutlet.isHidden = true
        self.addressLabel.text = LocalizedString.AddressSmallLaters.localized
        self.addressInfoTextView.attributedText = AppGlobals.shared.getTextWithImageWithLink(startText: address, startTextColor: AppColors.themeBlack, middleText: "  " + LocalizedString.Maps.localized + " ", image: #imageLiteral(resourceName: "send_icon"), endText: "", endTextColor: AppColors.themeGreen, middleTextColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
    }
    
    internal func configureNotesCell(notes: String, isHiddenDivider: Bool = false) {
        self.moreBtnOutlet.isHidden = self.isMoreButtonTapped
        self.addressLabel.font = AppFonts.Regular.withSize(14.0)
        self.addressInfoTextView.font = AppFonts.Regular.withSize(18.0)
        self.addressLabel.textColor = AppColors.themeGray40
        self.addressInfoTextView.textColor = AppColors.themeBlack
        self.addressLabel.text = LocalizedString.capNotes.localized
        self.addressInfoTextView.textContainer.maximumNumberOfLines = self.isMoreButtonTapped ? 0 : 3
        self.addressInfoTextView.isScrollEnabled = false
        let attrText = notes.htmlToAttributedString(withFontSize: 18.0, fontFamily: AppFonts.Regular.withSize(18.0).familyName, fontColor: AppColors.themeBlack)
        self.addressInfoTextView.attributedText = attrText
        self.moreBtnContainerView.isHidden = (self.addressInfoTextView.numberOfLines >= 2) && !self.isMoreButtonTapped ? false : true
        self.deviderView.isHidden = isHiddenDivider
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
            self.moreBtnContainerView.isHidden = true
            self.addressInfoTextView.textContainer.maximumNumberOfLines = 0
            self.isMoreButtonTapped = true
            parentVC.bookingDetailsTableView.reloadData()
        }
        else if let parentVC = self.parentViewController as? HotlelBookingsDetailsVC {
            self.moreBtnContainerView.isHidden = true
            self.addressInfoTextView.textContainer.maximumNumberOfLines = 0
            self.isMoreButtonTapped = true
            parentVC.bookingDetailsTableView.reloadData()
        }
    }
}
