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
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var allDetailsLabel: UILabel!
    @IBOutlet weak var infoBtnOutlet: UIButton!
    @IBOutlet weak var moreInfoContainerView: UIView! {
        didSet {
            self.moreInfoContainerView.addGradientWithColor(color: AppColors.themeWhite)
        }
    }
    @IBOutlet weak var moreBtnOutlet: UIButton!
    @IBOutlet weak var shadowView: UIView!
    
    
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
        self.allDetailsLabel.isHidden = true
        //UIColor
        self.backgroundColor = AppColors.screensBackground.color
        self.containerView.layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        ///Font
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.descriptionLabel.font = AppFonts.Regular.withSize(18.0)
        self.infoBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(14.0)
        self.moreBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(14.0)
        ///TextColor
        self.titleLabel.textColor = AppColors.themeGray40
        self.descriptionLabel.textColor = AppColors.textFieldTextColor51
        self.infoBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        self.moreBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        //Text
        self.moreBtnOutlet.setTitle(LocalizedString.More.localized, for: .normal)
    }
    
    ///AttributeLabelSetup
    private func attributeLabelSetUp(text: String) {
        let attributedString = NSMutableAttributedString()
        let greenAtrribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeGreen]
        let greenAttributedString = NSAttributedString(string: LocalizedString.FreeCancellation.localized, attributes: greenAtrribute)
        let blackAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
        let blackAttributedString = NSAttributedString(string: " by " + text, attributes: blackAttribute)
        attributedString.append(greenAttributedString)
        attributedString.append(blackAttributedString)
        self.descriptionLabel.attributedText = attributedString
    }
    
    ///Full Penalty Details
    internal func fullPenaltyDetails(ratesData: Rates) -> NSMutableAttributedString? {
        if let cancellationInfo = ratesData.cancellation_penalty {
            if cancellationInfo.is_refundable {
                let attributesDictionary = [NSAttributedString.Key.font : AppFonts.Regular.withSize(14.0)]
                let fullAttributedString = NSMutableAttributedString()
                for penaltyData in ratesData.penalty_array! {
                    let string = self.attributedPenaltyString(roomPrice: ratesData.price, isRefundable: penaltyData.is_refundable, toDate: penaltyData.to, fromDate: penaltyData.from, penalty: penaltyData.penalty)
                    //\u{2022}
                    let formattedString: String = "●  \(string)\n"
                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString, attributes: attributesDictionary)
                    let paragraphStyle = AppGlobals.shared.createParagraphAttribute()
                    attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
                    fullAttributedString.append(attributedString)
                }
                return fullAttributedString
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
    
    ///Full Payment Details
    internal func fullPaymentDetails() -> NSMutableAttributedString? {
        let attributedString = NSMutableAttributedString()
        let blackAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray60] as [NSAttributedString.Key : Any]
        let blackAttributedString = NSAttributedString(string: LocalizedString.FullPaymentExplanation.localized, attributes: blackAttribute)
        attributedString.append(blackAttributedString)
        return attributedString
    }
    
    ///Full Notes Details
    internal func fullNotesDetails(ratesData: Rates) -> NSMutableAttributedString? {
        if let notesInclusion = ratesData.inclusion_array[APIKeys.notes_inclusion.rawValue] as? [String] {
            let attributesDictionary = [NSAttributedString.Key.font : AppFonts.Regular.withSize(14.0)]
            let fullAttributedString = NSMutableAttributedString()
            for (note) in notesInclusion {
                let formattedString: String = "●  \(note)\n"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString, attributes: attributesDictionary)
//                attributedString.addAttribute(.font, value: AppFonts.Regular.withSize(7.0), range: (formattedString as NSString).range(of: "●"))
                let paragraphStyle = AppGlobals.shared.createParagraphAttribute()
                attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
                fullAttributedString.append(attributedString)
            }
            return fullAttributedString
        }
        return nil
    }
    
    ///Configure Cancellation Cell
    internal func configureCancellationCell(ratesData: Rates) {
        self.moreInfoContainerView.isHidden = true
        self.titleLabel.text = LocalizedString.CancellationPolicy.localized
        if let cancellationInfo = ratesData.cancellation_penalty, cancellationInfo.is_refundable {
            let fullRefundableData = ratesData.getFullRefundableData()
            guard fullRefundableData.is_refundable == true else {
                self.textSetUpForCancellation(text: LocalizedString.PartRefundable.localized, isBtnHidden: false)
                return
            }
            let cancelDesc = Date.getDateFromString(stringDate: fullRefundableData.to, currentFormat: "yyyy-MM-dd HH:mm:ss", requiredFormat: "dd MMM’ yy")
            self.attributeLabelSetUp(text: cancelDesc ?? "")
            self.infoBtnOutlet.isHidden = false
        } else {
            self.textSetUpForCancellation(text: LocalizedString.NonRefundableExplanation.localized, isBtnHidden: true)
        }
    }
    
    private func textSetUpForCancellation(text: String, isBtnHidden: Bool) {
        self.infoBtnOutlet.isHidden = isBtnHidden
        self.descriptionLabel.font = AppFonts.Regular.withSize(18.0)
        self.descriptionLabel.textColor = AppColors.textFieldTextColor51
        self.descriptionLabel.text = text
    }
    
    
    ///Configure Payment Cell
    internal func configurePaymentCell(ratesData: Rates) {
        self.moreInfoContainerView.isHidden = true
        self.titleLabel.text = LocalizedString.PaymentPolicy.localized
        if !ratesData.payment_info.isEmpty {
            self.infoBtnOutlet.isHidden = true
            let paymentAttributes = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray60]
            let paymentAttributedString = NSAttributedString(string: ratesData.payment_info, attributes: paymentAttributes)
            self.descriptionLabel.attributedText = paymentAttributedString
        } else {
            self.infoBtnOutlet.isHidden = false
            self.descriptionLabel.font = AppFonts.Regular.withSize(18.0)
            self.descriptionLabel.textColor = AppColors.textFieldTextColor51
            self.descriptionLabel.text = LocalizedString.FullPaymentNow.localized
        }
    }
    
    ///Configure Notes Cell
    internal func configureNotesCell(ratesData: Rates) {
        if let notesInclusion =  ratesData.inclusion_array[APIKeys.notes_inclusion.rawValue] as? [String] {
            self.infoBtnOutlet.isHidden = true
            self.moreInfoContainerView.isHidden = false
            self.titleLabel.text = LocalizedString.Notes.localized
            self.titleLabel.font = AppFonts.Regular.withSize(14.0)
            self.descriptionLabel.textColor = AppColors.themeBlack
            let attributedString = NSMutableAttributedString()
            let dotAttributes = [NSAttributedString.Key.font: AppFonts.Regular.withSize(13.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack]
            let dotAttributedString = NSAttributedString(string: "●  ", attributes: dotAttributes)
            attributedString.append(dotAttributedString)
            let blackAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
            let blackAttributedString = NSAttributedString(string: notesInclusion.first ?? "", attributes: blackAttribute)
            attributedString.append(blackAttributedString)
            self.descriptionLabel.attributedText = attributedString
        }
    }
    
    //Mark:- IBActions
    //================
    @IBAction func infoBtnAction(_ sender: UIButton) {
        if let tableView = self.superview as? UITableView, let indexPath = tableView.indexPath(forItem: sender), let safeDelegate = self.delegate {
            safeDelegate.expandCell(expandHeight: size.height, indexPath: indexPath)
        }
    }
    
    @IBAction func moreBtnAction(_ sender: UIButton) {
        if let tableView = self.superview as? UITableView, let indexPath = tableView.indexPath(forItem: sender), let safeDelegate = self.delegate {
            safeDelegate.expandCell(expandHeight: size.height, indexPath: indexPath)
        }
    }
}
