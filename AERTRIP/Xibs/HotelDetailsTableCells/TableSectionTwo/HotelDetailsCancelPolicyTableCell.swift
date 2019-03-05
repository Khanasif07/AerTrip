//
//  HotelDetailsCancelPolicyTableCell.swift
//  AERTRIP
//
//  Created by Admin on 13/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol GetFullInfoDelegate: class {
    func expandCell(expandHeight: CGFloat, indexPath: IndexPath)
}

class HotelDetailsCancelPolicyTableCell: UITableViewCell {
    
    //Mark: Variables
    //===============
    internal weak var delegate: GetFullInfoDelegate?
    internal var ratesData: Rates?
    internal var currentIndexPath:IndexPath?
    
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
    ///Configure UI
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
    
    ///Full Penalty Details
    private func fullPenaltyDetails() -> NSMutableAttributedString? {
        self.cancelTitle.text = LocalizedString.CancellationPolicy.localized
        if let ratesData = self.ratesData, let cancellationInfo = ratesData.cancellation_penalty {
            let attributedString = NSMutableAttributedString()
            if cancellationInfo.is_refundable {
//                let fullRefundableData = ratesData.getFullRefundableData()
//                guard fullRefundableData.is_refundable == true else { return nil }
                for penaltyData in ratesData.penalty_array! {
                    
                    let dotAttributes = [NSAttributedString.Key.font: AppFonts.Regular.withSize(13.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack]
                    let dotAttributedString = NSAttributedString(string: "● ", attributes: dotAttributes)
                    attributedString.append(dotAttributedString)
                    let blackAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.textFieldTextColor51] as [NSAttributedString.Key : Any]
                    
                    let string = self.attributedPenaltyString(roomPrice: ratesData.price, isRefundable: penaltyData.is_refundable, toDate: penaltyData.to, fromDate: penaltyData.from, penalty: penaltyData.penalty)
                    let blackAttributedString = NSAttributedString(string: string, attributes: blackAttribute)
                    attributedString.append(blackAttributedString)
                    //self.cancelDescriptionLabel.attributedText = attributedString
                }
                return attributedString
            } else {
                let blackAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray60] as [NSAttributedString.Key : Any]
                let blackAttributedString = NSAttributedString(string: LocalizedString.NonRefundableExplanation.localized, attributes: blackAttribute)
                attributedString.append(blackAttributedString)
                //self.cancelDescriptionLabel.attributedText = attributedString
                return attributedString
            }
        }
        return nil
    }
    
    ///Attributed Penalty String
    private func attributedPenaltyString(roomPrice: Double ,isRefundable: Bool ,toDate: String, fromDate: String, penalty: Int) -> String {
        var startingDate: String = ""
        var endingDate: String = ""
        if !toDate.isEmpty {
            endingDate = Date.getDateFromString(stringDate: toDate, currentFormat: "yyyy-MM-dd HH:mm:ss", requiredFormat: "E, dd MMM yyyy hh.mm aa") ?? ""
        }
        if !fromDate.isEmpty {
            startingDate = Date.getDateFromString(stringDate: fromDate, currentFormat: "yyyy-MM-dd HH:mm:ss", requiredFormat: "E, dd MMM yyyy hh.mm aa") ?? ""
        }
        var penaltyString: String = ""
        if isRefundable {
            if !toDate.isEmpty && fromDate.isEmpty && penalty == 0 {
                penaltyString = "Full Refund: If you cancel by \(endingDate)\n"
                return penaltyString
            } else if !toDate.isEmpty && !fromDate.isEmpty && penalty != 0 {
                penaltyString = "Cancellation fee of \(LocalizedString.rupeesText.localized) \(penalty) will be charged if you cancel from \(startingDate) to \(endingDate)\n"
                return penaltyString
            } else if toDate.isEmpty && !fromDate.isEmpty && penalty != 0 {
                penaltyString = "Cancellation fee of \(LocalizedString.rupeesText.localized) \(penalty) will be charged if you cancel on \(startingDate) or later\n"
                return penaltyString
            }
        } else {
            if penalty == Int(roomPrice) && !fromDate.isEmpty {
                penaltyString = "Non Refundable from  \(startingDate)\n"
                return penaltyString
            } else if penalty == Int(roomPrice) && !fromDate.isEmpty {
                penaltyString = "Cancellation fee of \(LocalizedString.rupeesText.localized) \(penalty) will be charged if you cancel on \(startingDate) or later\n"
                return penaltyString
            }
        }
        return penaltyString
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
    
    ///Configure Payment Cell
    internal func configurePaymentCell(ratesData: Rates) {
        self.cancelTitle.text = LocalizedString.PaymentPolicy.localized
        if !ratesData.payment_info.isEmpty {
            self.infoBtnOutlet.isHidden = true
            let dotAttributes = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray60]
            let dotAttributedString = NSAttributedString(string: ratesData.payment_info, attributes: dotAttributes)
            self.cancelDescriptionLabel.attributedText = dotAttributedString
        } else {
            self.infoBtnOutlet.isHidden = false
            self.cancelDescriptionLabel.text = LocalizedString.FullPaymentNow.localized
        }
    }
    
    //Mark:- IBActions
    //================
    @IBAction func infoBtnAction(_ sender: UIButton) {
        if let penalyDetails = self.fullPenaltyDetails() {
            self.cancelDescriptionLabel.attributedText = penalyDetails
            let size = penalyDetails.string.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
            if let safeDelegate = self.delegate , let indexPath = self.currentIndexPath {
                self.infoBtnOutlet.isHidden = true
                safeDelegate.expandCell(expandHeight: size.height, indexPath: indexPath)
            }
        }
    }
}
