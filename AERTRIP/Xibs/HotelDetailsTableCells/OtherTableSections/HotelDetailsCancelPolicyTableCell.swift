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
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var allDetailsLabel: UILabel!
    @IBOutlet weak var infoBtnOutlet: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var shadowViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowViewBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.descriptionLabel.attributedText = nil
        self.allDetailsLabel.attributedText = nil
        self.descriptionLabel.text = ""
        self.allDetailsLabel.text = ""
    }
    
    //Mark:- Functions
    //================
    ///Configure UI
    private func configUI() {
        self.allDetailsLabel.isHidden = true
//        self.shadowView.addShadow(cornerRadius: 0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        let shadow = AppShadowProperties()
        self.shadowView.addShadow(cornerRadius: 0, maskedCorners: [], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
        //UIColor
        self.backgroundColor = .clear//AppColors.screensBackground.color
        ///Font
        self.descriptionLabel.font = AppFonts.Regular.withSize(16.0)
        self.infoBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(14.0)
        //self.moreBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(14.0)
        ///TextColor
        self.descriptionLabel.textColor = AppColors.themeBlack
        self.infoBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        // self.moreBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        //Text
        // self.moreBtnOutlet.setTitle(LocalizedString.More.localized, for: .normal)
    }
    
    
    
    ///AttributeLabelSetup
    /// Asif Change
    private func attributeLabelSetUp( roomPrice: Double , toDate: String, fromDate: String, penalty: Int) {
        let attributedString = NSMutableAttributedString()
        let orangeAtrribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(16.0), NSAttributedString.Key.foregroundColor: AppColors.themeOrange]
        let blackAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(16.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
        var startingDate: String = ""
        var endingDate: String = ""
        if !toDate.isEmpty {
            endingDate = Date.getDateFromString(stringDate: toDate, currentFormat: "yyyy-MM-dd HH:mm:ss", requiredFormat: "E, d MMM yyyy hh:mm aa") ?? ""
        }
        if !fromDate.isEmpty {
            startingDate = Date.getDateFromString(stringDate: fromDate, currentFormat: "yyyy-MM-dd HH:mm:ss", requiredFormat: "E, d MMM yyyy hh:mm aa") ?? ""
        }
        if (!toDate.isEmpty && fromDate.isEmpty && penalty == 0) || (!toDate.isEmpty && !fromDate.isEmpty && penalty == 0) {
            let cancelDesc: String = Date.getDateFromString(stringDate: toDate, currentFormat: "yyyy-MM-dd HH:mm:ss", requiredFormat: "d MMM’ yy") ?? ""
            let greenAttributedString = NSAttributedString(string: LocalizedString.FreeCancellation.localized, attributes: orangeAtrribute)
            let blackAttributedString = NSAttributedString(string: " by " + cancelDesc , attributes: blackAttribute)
            attributedString.append(greenAttributedString)
            attributedString.append(blackAttributedString)
        } else if !toDate.isEmpty && !fromDate.isEmpty && penalty != 0 {
            /// Asif Change
            //            let greenAttributedString = NSAttributedString(string: "Cancellation fee of \(LocalizedString.rupeesText.localized) ", attributes: orangeAtrribute)
            //            let blackAttributedString = NSAttributedString(string: "\(penalty) will be charged if you cancel from \(startingDate) to \(endingDate)\n" + endingDate, attributes: blackAttribute)
            //            attributedString.append(greenAttributedString)
            let blackAttributedString = NSAttributedString(string: "Part Refundable", attributes: blackAttribute)
            attributedString.append(blackAttributedString)
        } else if toDate.isEmpty && !fromDate.isEmpty && penalty != 0 {
            let greenAttributedString = NSAttributedString(string: "Cancellation fee of \(LocalizedString.rupeesText.localized) ", attributes: orangeAtrribute)
            let blackAttributedString = NSAttributedString(string: "\(penalty) will be charged if you cancel on \(startingDate) or later\n" + endingDate, attributes: blackAttribute)
            attributedString.append(greenAttributedString)
            attributedString.append(blackAttributedString)
        } else {
            printDebug("no case found")
            printDebug(toDate)
            printDebug(fromDate)
            printDebug(penalty)

        }
        self.descriptionLabel.attributedText = attributedString
    }
    
    private func constraintSetUp(isHotelDetailsScreen: Bool) {
        if isHotelDetailsScreen {
            self.shadowViewLeadingConstraint.constant = 16.0
            self.shadowViewTrailingConstraint.constant = 16.0
        } else {
            self.shadowView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.clear, offset: CGSize(width: 0.0, height: 0.0), opacity: 0.0, shadowRadius: 0.0)
            self.shadowViewLeadingConstraint.constant = 0.0
            self.shadowViewTrailingConstraint.constant = 0.0
        }
    }
    
    ///Full Penalty Details
    /// Asif Change ====
    internal func fullPenaltyDetails(ratesData: Rates) -> NSMutableAttributedString? {
        if let cancellationInfo = ratesData.cancellation_penalty {
            if cancellationInfo.is_refundable {
                let attributesDictionary = [NSAttributedString.Key.font : AppFonts.Regular.withSize(14.0),NSAttributedString.Key.foregroundColor: AppColors.themeGray60] as [NSAttributedString.Key : Any]
                let fullAttributedString = NSMutableAttributedString()
                let array = ratesData.penalty_array ?? []
                for (index, penaltyData) in array.enumerated() {
                    let string = self.attributedPenaltyString(roomPrice: ratesData.price, isRefundable: penaltyData.is_refundable, toDate: penaltyData.to, fromDate: penaltyData.from, penalty: penaltyData.penalty)
                    //\u{2022}
                    let formattedString: String = index == (array.count - 1) ? "\(string)" : "\(string)\n\n"
                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString, attributes: attributesDictionary)
                    let paragraphStyle = AppGlobals.shared.createParagraphAttribute(paragraphSpacingBefore: -4.1, isForNotes: false)
                    attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
                    //                    attributedString.addAttributes([
                    //                        .font: AppFonts.c.withSize(10.0),
                    //                        .foregroundColor: AppColors.themeGray20
                    //                    ], range: ("\(string)\n" as NSString).range(of: LocalizedString.rupeesText.localized))
                    fullAttributedString.append(attributedString)
                }
                return fullAttributedString
            } else {
                let attributedString = NSMutableAttributedString()
                let blackAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray60] as [NSAttributedString.Key : Any]
                let blackAttributedString = NSAttributedString(string: LocalizedString.NonRefundableExplanation.localized, attributes: blackAttribute)
                attributedString.append(blackAttributedString)
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
            endingDate = Date.getDateFromString(stringDate: toDate, currentFormat: "yyyy-MM-dd HH:mm:ss", requiredFormat: "E, d MMM yyyy hh:mm aa") ?? ""
        }
        if !fromDate.isEmpty {
            startingDate = Date.getDateFromString(stringDate: fromDate, currentFormat: "yyyy-MM-dd HH:mm:ss", requiredFormat: "E, d MMM yyyy hh:mm aa") ?? ""
        }
        var penaltyString: String = ""
        if isRefundable {
            if (!toDate.isEmpty && fromDate.isEmpty && penalty == 0) || !toDate.isEmpty && !fromDate.isEmpty && penalty == 0 {
                penaltyString = "Full Refund: If you cancel by \(endingDate)\n"
                return penaltyString
            } else if !toDate.isEmpty && !fromDate.isEmpty && penalty != 0 {
                penaltyString = "Cancellation fee of \(Double(penalty).amountInDelimeterWithSymbol) will be charged if you cancel from \(startingDate) to \(endingDate)\n"
                return penaltyString
            } else if toDate.isEmpty && !fromDate.isEmpty && penalty != 0 {
                penaltyString = "Cancellation fee of \(Double(penalty).amountInDelimeterWithSymbol) will be charged if you cancel on \(startingDate) or later\n"
                return penaltyString
            }
        } else {
            
            if(penalty != 0 && penalty >= Int(roomPrice) &&
                !fromDate.isEmpty && toDate.isEmpty) {
                penaltyString = "Non Refundable from  \(startingDate)\n"
                return penaltyString
            } else if(penalty != 0 && penalty != Int(roomPrice) &&
                        !fromDate.isEmpty && toDate.isEmpty) {
                penaltyString = "Cancellation fee of \(Double(penalty).amountInDelimeterWithSymbol) will be charged if you cancel on \(startingDate) or later\n"
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
                let formattedString: String = "•  \(note)\n"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString, attributes: attributesDictionary)
                let paragraphStyle = AppGlobals.shared.createParagraphAttribute(paragraphSpacingBefore: 4.0,isForNotes: true,lineSpacing :2.0)
                attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
                fullAttributedString.append(attributedString)
            }
            return fullAttributedString
        }
        return nil
    }
    
    ///Configure Cancellation Cell
    internal func configureCancellationCell(ratesData: Rates , isHotelDetailsScreen: Bool) {
        self.constraintSetUp(isHotelDetailsScreen: isHotelDetailsScreen)
        //        self.moreInfoContainerView.isHidden = true
        self.infoBtnOutlet.isHidden = false
        if let cancellationInfo = ratesData.cancellation_penalty, cancellationInfo.is_refundable {
            self.descriptionLabel.text = ""
            if let firstRefundableData = ratesData.penalty_array?.first {
                self.attributeLabelSetUp(roomPrice: ratesData.price , toDate: firstRefundableData.to, fromDate: firstRefundableData.from, penalty: firstRefundableData.penalty)
                if (self.descriptionLabel.text ?? "").isEmpty {
                    self.infoBtnOutlet.isHidden = true
                }
            } else {
                self.infoBtnOutlet.isHidden = true
            }
        } else {
            self.textSetUpForCancellation(text: LocalizedString.NonRefundable.localized)
        }
    }
    
    ///Text SetUp For Cancellation
    private func textSetUpForCancellation(text: String) {
        self.descriptionLabel.font = AppFonts.Regular.withSize(16.0)
        self.descriptionLabel.textColor =  AppColors.themeBlack
        self.descriptionLabel.text = text
    }
    
    
    ///Configure Payment Cell
    internal func configurePaymentCell(ratesData: Rates, isHotelDetailsScreen: Bool) {
        self.constraintSetUp(isHotelDetailsScreen: isHotelDetailsScreen)
        //        self.moreInfoContainerView.isHidden = true
        
        if !ratesData.payment_info.isEmpty && ratesData.payment_info != "payment_now" {
            self.infoBtnOutlet.isHidden = true
            let paymentAttributes = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray60]
            let paymentAttributedString = NSAttributedString(string: ratesData.payment_info, attributes: paymentAttributes)
            self.descriptionLabel.attributedText = paymentAttributedString
        } else {
            self.infoBtnOutlet.isHidden = false
            self.descriptionLabel.font = AppFonts.Regular.withSize(16.0)
            self.descriptionLabel.textColor = AppColors.themeGray60
            self.descriptionLabel.text = LocalizedString.FullPaymentNow.localized
        }
    }
    
    ///Configure Notes Cell
    internal func configureNotesCell(ratesData: Rates, isHotelDetailsScreen: Bool) {
        self.constraintSetUp(isHotelDetailsScreen: isHotelDetailsScreen)
        if let notesInclusion =  ratesData.inclusion_array[APIKeys.notes_inclusion.rawValue] as? [String] {
            
            self.infoBtnOutlet.isHidden = true
            //            self.moreInfoContainerView.isHidden = false
            self.descriptionLabel.textColor = AppColors.themeBlack
            //let attributedString = NSMutableAttributedString()
            //
            self.stackViewBottomConstraint.constant = 16
            let attributesDictionary = [NSAttributedString.Key.font : AppFonts.Regular.withSize(14.0)]
            let fullAttributedString = NSMutableAttributedString()
            for (note) in notesInclusion {
                var formattedString: String = "•  \(note)\n"
                if note == notesInclusion.last ?? ""{
                    formattedString = "•  \(note)"
                }
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString, attributes: attributesDictionary)
                let paragraphStyle = AppGlobals.shared.createParagraphAttribute(paragraphSpacingBefore: 4.0, isForNotes: true,lineSpacing: 2.0)
                attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
                fullAttributedString.append(attributedString)
            }
            
            // fullAttributedString.append(attributedString)
            //
            //            let dotAttributes = [NSAttributedString.Key.font: AppFonts.Regular.withSize(13.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack]
            //            let dotAttributedString = NSAttributedString(string: "  ", attributes: dotAttributes)
            //            attributedString.append(dotAttributedString)
            //            let blackAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
            //            let blackAttributedString = NSAttributedString(string: notesInclusion.first ?? "", attributes: blackAttribute)
            //            attributedString.append(blackAttributedString)
            self.descriptionLabel.attributedText = fullAttributedString
            //self.descriptionLabel.AttributedFontAndColorForText(atributedText: "●", textFont: AppFonts.Regular.withSize(8.0), textColor: AppColors.themeBlack)
        }
    }
    
    ///Configure Notes Cell
    internal func configureHCNotesCell(notesInclusion: [String], isHotelDetailsScreen: Bool) {
        self.constraintSetUp(isHotelDetailsScreen: isHotelDetailsScreen)
        self.infoBtnOutlet.isHidden = true
        self.descriptionLabel.textColor = AppColors.themeBlack
        let attributedString = NSMutableAttributedString()
        let dotAttributes = [NSAttributedString.Key.font: AppFonts.Regular.withSize(10.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack]
        let dotAttributedString = NSAttributedString(string: "●  ", attributes: dotAttributes)
        attributedString.append(dotAttributedString)
        let blackAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
        let blackAttributedString = NSAttributedString(string: notesInclusion.first ?? "", attributes: blackAttribute)
        attributedString.append(blackAttributedString)
        self.descriptionLabel.attributedText = attributedString
    }
    
    ///Full Notes Details
    internal func fullHCNotesDetails(notesInclusion: [String]) -> NSMutableAttributedString {
        let attributesDictionary = [NSAttributedString.Key.font : AppFonts.Regular.withSize(14.0)]
        let fullAttributedString = NSMutableAttributedString()
        for (note) in notesInclusion {
            let formattedString: String = "●  \(note)\n"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString, attributes: attributesDictionary)
            let paragraphStyle = AppGlobals.shared.createParagraphAttribute(isForNotes: true)
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            fullAttributedString.append(attributedString)
        }
        return fullAttributedString
    }
    
    ///Configure Payment Cell
    internal func configureHCPaymentCell(isHotelDetailsScreen: Bool) {
        self.constraintSetUp(isHotelDetailsScreen: isHotelDetailsScreen)
        //        self.moreInfoContainerView.isHidden = true
        self.infoBtnOutlet.isHidden = true
        self.allDetailsLabel.isHidden = true
        self.descriptionLabel.font = AppFonts.Regular.withSize(16.0)
        self.descriptionLabel.textColor = AppColors.textFieldTextColor51
        self.descriptionLabel.text = LocalizedString.FullPaymentNow.localized
        self.allDetailsLabel.textAlignment = .left
    }
    
    ///Full Penalty Details
    internal func fullHCPenaltyDetails(isRefundable: Bool, isHotelDetailsScreen: Bool) {
        self.constraintSetUp(isHotelDetailsScreen: isHotelDetailsScreen)
        //        self.moreInfoContainerView.isHidden = true
        //        self.moreBtnOutlet.isHidden = true
        let attributedString = NSMutableAttributedString()
        let blackAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.textFieldTextColor51] as [NSAttributedString.Key : Any]
        var blackAttributedString: NSAttributedString
        if isRefundable {
            blackAttributedString = NSAttributedString(string: LocalizedString.Refundable.localized, attributes: blackAttribute)
        } else {
            blackAttributedString = NSAttributedString(string: LocalizedString.NonRefundable.localized, attributes: blackAttribute)
        }
        attributedString.append(blackAttributedString)
        self.descriptionLabel.attributedText = attributedString
    }
    
    ///Full Penalty Details
    internal func HCPenaltyDetailsExplanation(canclNotes: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let blackAttribute =  [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray60]
        let blackAttributedString = NSAttributedString(string: canclNotes, attributes: blackAttribute)
        attributedString.append(blackAttributedString)
        return attributedString
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

