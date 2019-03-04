//
//  HotelDetailsCancelPolicyTableCell.swift
//  AERTRIP
//
//  Created by Admin on 13/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsCancelPolicyTableCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelTitle: UILabel!
    @IBOutlet weak var cancelDescriptionLabel: UILabel!
    @IBOutlet weak var infoBtnOutlet: UIButton!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        //UIColor
        self.backgroundColor = AppColors.screensBackground.color
//        self.containerView.shadowOnHotelDetailsTabelCell(color: AppColors.themeGray20, offset: CGSize(width: 0.0, height: 5.0), opacity: 0.7, shadowRadius: 6.0)
        self.containerView.layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        
        ///Font
        self.cancelTitle.font = AppFonts.Regular.withSize(14.0)
        self.cancelDescriptionLabel.font = AppFonts.Regular.withSize(18.0)
        self.infoBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(14.0)
        
        ///TextColor
        self.cancelTitle.textColor = AppColors.themeGray40
        self.cancelDescriptionLabel.textColor = AppColors.textFieldTextColor51
        self.infoBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    ///AttributeLabelSetup
    private func attributeLabelSetUp(text: String) {
        let attributedString = NSMutableAttributedString()
        let greenAtrribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeGreen]
        let greenAttributedString = NSAttributedString(string: LocalizedString.FreeCancellation.localized, attributes: greenAtrribute)

        let blackAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.textFieldTextColor51] as [NSAttributedString.Key : Any]
        let blackAttributedString = NSAttributedString(string: " by " + text, attributes: blackAttribute)

        attributedString.append(greenAttributedString)
        attributedString.append(blackAttributedString)
        self.cancelDescriptionLabel.attributedText = attributedString
    }
    ///ConfigureCell
    internal func configureCancellationCell(ratesData: Rates) {
        self.cancelTitle.text = LocalizedString.CancellationPolicy.localized
        if let cancellationInfo = ratesData.cancellation_penalty, cancellationInfo.is_refundable {
            let fullRefundableData = ratesData.getFullRefundableData()
            guard fullRefundableData.is_refundable == true else { return }
            let cancelDesc = Date.getDateFromString(stringDate: fullRefundableData.to, currentFormat: "yyyy-MM-dd HH:mm:ss", requiredFormat: "dd MMM’ yy")
            self.attributeLabelSetUp(text: cancelDesc ?? "")
        } else {
            self.cancelDescriptionLabel.text = LocalizedString.NonRefundable.localized
        }
    }
    
    internal func configurePaymentCell(ratesData: Rates) {
        self.cancelTitle.text = LocalizedString.PaymentPolicy.localized
        if !ratesData.payment_info.isEmpty {
            self.cancelDescriptionLabel.text = ratesData.payment_info
        } else {
            self.cancelDescriptionLabel.text = LocalizedString.FullPaymentNow.localized
        }
    }
    
    
    //Mark:- IBActions
    //================
    @IBAction func infoBtnAction(_ sender: UIButton) {
        
    }
}
