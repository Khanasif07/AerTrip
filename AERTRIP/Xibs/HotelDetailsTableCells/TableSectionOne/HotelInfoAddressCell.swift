//
//  HotelInfoAddressCell.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelInfoAddressCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    let address = "Ramada Powai, Powai Saki Vihar Road Mumbai 400 087, Mumbai, India, Pin-code: 400 087"
    let overview = "With a stay at Le Sutra, you'll be centrally located in Mumbai, convenient to Lilavati Hospital and Mt. Mary Church. This spacing"
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressInfoTextView: UITextView!
    @IBOutlet weak var deviderView: UIView!
    @IBOutlet weak var moreBtnOutlet: UIButton!
    @IBOutlet weak var moreBtnContainerView: UIView!
    @IBOutlet weak var infoTextViewTrailingConstraint: NSLayoutConstraint! {
        didSet {
            self.infoTextViewTrailingConstraint.constant = 0.0
        }
    }
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    //Mark:- Methods
    //==============
    private func initialSetUp() {
        self.addressInfoTextView.isEditable = false
        self.addressInfoTextView.textContainerInset = UIEdgeInsets.zero
        self.addressInfoTextView.textContainer.lineFragmentPadding = 0.0
        self.configureUI()
    }
    
    ///COnfigure UI
    private func configureUI() {
        //SetUps
        self.moreBtnContainerView.addGradientWithColor(color: AppColors.themeWhite)
        self.moreBtnContainerView.isHidden = true
        
        //Color
        self.addressLabel.textColor = AppColors.themeBlack
        self.deviderView.backgroundColor = AppColors.divider.color
        self.moreBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        
        //Size
        self.addressLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.addressInfoTextView.font = AppFonts.Regular.withSize(18.0)
        self.moreBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        
        //Text
        self.moreBtnOutlet.setTitle(LocalizedString.More.localized, for: .normal)
    }
    
    ///AttributeLabelSetup
    private func attributeLabelSetUp() {
        let attributedString = NSMutableAttributedString()
        let blackAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
        let blackAttributedString = NSAttributedString(string: self.overview, attributes: blackAttribute)
        attributedString.append(blackAttributedString)
        self.addressInfoTextView.attributedText = attributedString
        self.moreBtnContainerView.isHidden = (self.addressInfoTextView.numberOfLines() == 3 ) ? false : true
    }

    
    internal func configureAddressCell() {
        self.addressLabel.text = LocalizedString.AddressSmallLaters.localized
        self.addressInfoTextView.attributedText = AppGlobals.shared.getTextWithImageWithLink(startText: address, startTextColor: AppColors.themeBlack, middleText: " " + LocalizedString.Maps.localized + " ", image: #imageLiteral(resourceName: "send_icon"), endText: "", endTextColor: AppColors.themeGreen, middleTextColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
    }
    
    internal func configureOverviewCell() {
        //self.infoTextViewTrailingConstraint.constant = -self.moreBtnOutlet.frame.origin.y
        self.addressInfoTextView.textContainer.maximumNumberOfLines = 3
        self.addressLabel.text = LocalizedString.Overview.localized
        self.attributeLabelSetUp()
    }
    
    
    
    //Mark:- IBActions
    //================
    @IBAction func mapButtonAction(_ sender: UIButton) {
        printDebug("Go To Maps")
    }
    
    @IBAction func moreButtonAction(_ sender: UIButton) {
        printDebug("More")
    }
    
}
