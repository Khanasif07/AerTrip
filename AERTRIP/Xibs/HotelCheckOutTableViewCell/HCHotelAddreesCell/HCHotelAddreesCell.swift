//
//  HCHotelAddreesCell.swift
//  AERTRIP
//
//  Created by Admin on 02/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class HCHotelAddreesCell: UITableViewCell {
    // Mark:- Variables
    //================
    
    // Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addressInfoTextView: PKTapAndCopyUITextView! {
        didSet {
            self.addressInfoTextView.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var deviderView: UIView!
    @IBOutlet weak var moreBtnOutlet: UIButton!
    @IBOutlet weak var moreBtnContainerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var infoTextViewTrailingConstraint: NSLayoutConstraint! {
        didSet {
            //self.infoTextViewTrailingConstraint.constant = 0.0
        }
    }
    
    @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shadowView: UIView!
    var isMoreButtonTapped: Bool = false
    // Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.moreBtnOutlet.isUserInteractionEnabled = true
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
        self.deviderView.backgroundColor = AppColors.divider.color
        self.moreBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        
        // Size
        self.addressInfoTextView.font = AppFonts.Regular.withSize(16.0)
        self.moreBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        
        // Text
        self.moreBtnOutlet.setTitle(LocalizedString.More.localized, for: .normal)
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressTapped))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewTapped))
        self.addressInfoTextView.isUserInteractionEnabled = true
        self.addGestureRecognizer(longPressGesture)
        self.addressInfoTextView.addGestureRecognizer(tapGesture)
        
        
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
    
    internal func hcConfigureAddressCell(address: String) {
        self.moreBtnOutlet.isHidden = true
        self.addressInfoTextView.text = address
        self.addressInfoTextView.textColor = AppColors.themeGray60
        
//        self.addressInfoTextView.attributedText = AppGlobals.shared.getTextWithImageWithLink(startText: address, startTextColor: AppColors.themeGray60, middleText: "\n" + LocalizedString.Maps.localized + " ", image: #imageLiteral(resourceName: "send_icon"), endText: "", endTextColor: AppColors.themeGreen, middleTextColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(16.0))
    }
    
    
    internal func setupForAllDoneVC() {
        self.containerLeadingConstraint.constant = 16
        self.containerTrailingConstraint.constant = 16
        self.layoutIfNeeded()
        self.shadowView.addShadow(cornerRadius: 0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 8.0)
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

