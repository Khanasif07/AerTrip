//
//  BookingRequestNoteTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 16/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingRequestNoteTableViewCell: ATTableViewCell {

    
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var noteInfoTextView: UITextView! {
        didSet {
            self.noteInfoTextView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var moreBtnOutlet: UIButton!
    @IBOutlet weak var moreBtnContainerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var infoTextViewTrailingConstraint: NSLayoutConstraint! {
        didSet {
            self.infoTextViewTrailingConstraint.constant = 20.0
        }
    }
    
    ///AttributeLabelSetup
    private func attributeLabelSetUp(overview: String) {
        let attrText = overview.htmlToAttributedString(withFontSize: 18.0, fontFamily: AppFonts.Regular.withSize(18.0).familyName, fontColor: AppColors.themeBlack)
        self.noteInfoTextView.attributedText = attrText
        self.moreBtnContainerView.isHidden = (self.noteInfoTextView.numberOfLines >= 3 ) ? false : true
    }
    
    
    
    override func setupColors() {
    
        self.noteLabel.textColor = AppColors.themeGray40
        self.moreBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        
    }
    
    override func setupTexts() {
        self.noteLabel.text = LocalizedString.NotesCapitalised.localized
        self.moreBtnOutlet.setTitle(LocalizedString.More.localized, for: .normal)
    }
    
    override func setupFonts() {
        //Size
        self.noteLabel.font = AppFonts.Regular.withSize(14.0)
        self.noteInfoTextView.font = AppFonts.Regular.withSize(18.0)
        self.moreBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func doInitialSetup() {
        self.noteInfoTextView.isEditable = false
        self.noteInfoTextView.textContainerInset = UIEdgeInsets.zero
        self.noteInfoTextView.textContainer.lineFragmentPadding = 0.0
        self.configureUI()
    }
    
     func configureNoteCell(hotelData: HotelDetails) {
        self.moreBtnOutlet.isHidden = false
        self.noteInfoTextView.textContainer.maximumNumberOfLines = 3
        self.attributeLabelSetUp(overview: hotelData.info)
    }
    
    @IBAction func moreButtonAction(_ sender: UIButton) {
        printDebug("More")
        if let parentVC = self.parentViewController as? HotelDetailsVC {
            AppFlowManager.default.presentHotelDetailsOverViewVC(overViewInfo: parentVC.viewModel.hotelData?.info ?? "")
        }
    }
    
    
    
    ///COnfigure UI
    private func configureUI() {
        //SetUps
        self.moreBtnContainerView.addGradientWithColor(color: AppColors.themeWhite)
        self.moreBtnContainerView.isHidden = true
    }
    
}
