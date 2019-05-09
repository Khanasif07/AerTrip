//
//  AccountOutstandingEventDescriptionCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AccountOutstandingEventDescriptionCell: UITableViewCell {
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var amountValueLabel: UILabel!
    @IBOutlet weak var pendingTitleLabel: UILabel!
    @IBOutlet weak var pendingValueLabel: UILabel!
    @IBOutlet weak var mainContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    
    var event: AccountDetailEvent? {
        didSet {
            self.setData()
        }
    }
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.setFontAndColor()
    }
    
    private func setFontAndColor() {
        
        self.mainContainerView.backgroundColor = AppColors.themeWhite
        self.mainContainerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner ,.layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize(width: 0.0, height: 1.0), opacity: 0.7, shadowRadius: 3.0)
        
        self.clipsToBounds = true
        
        self.backgroundColor = AppColors.themeWhite
        
        self.amountTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.pendingTitleLabel.font = AppFonts.Regular.withSize(14.0)
        
        self.amountValueLabel.font = AppFonts.Regular.withSize(18.0)
        self.pendingValueLabel.font = AppFonts.Regular.withSize(18.0)
        
        self.amountTitleLabel.textColor = AppColors.themeGray40
        self.pendingTitleLabel.textColor = AppColors.themeGray40
        
        self.amountValueLabel.textColor = AppColors.themeBlack
        self.pendingValueLabel.textColor = AppColors.themeBlack
        
        self.amountTitleLabel.text = LocalizedString.Amount.localized
        self.pendingTitleLabel.text = LocalizedString.Pending.localized
    }
    
    private func resetAllText() {
        self.amountValueLabel.text = ""
        self.pendingValueLabel.text = ""
        
        self.amountValueLabel.attributedText = nil
        self.pendingValueLabel.attributedText = nil
        
        self.dateLabel.text = "Due Date:"
    }
    
    private func setData() {
        
        guard let event = self.event else {
            self.resetAllText()
            return
        }
        
        let drAttr = NSMutableAttributedString(string: " \(LocalizedString.DebitShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
        let crAttr = NSMutableAttributedString(string: " \(LocalizedString.CreditShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
        
        let amount = event.amount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        amount.append(drAttr)
        self.amountValueLabel.attributedText = amount
        
        let pending = event.pendingAmount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        pending.append(crAttr)
        self.pendingValueLabel.attributedText = pending
        
        //set date
        let days = event.overDueDays
        let dayStr = (days > 1) ? "days" : "day"
        let overDueText = "Over Due by \(days) \(dayStr)"
        
        let dueText = "Due Date:"
        
        var dateStr = ""
        if let date = event.dueDate {
            dateStr = date.toString(dateFormat: "dd-MM-YYYY") + " |"
        }
        
        let finalText = "\(dueText) \(dateStr) \(overDueText)"
        
        let dateAttributedString = NSMutableAttributedString(string: finalText, attributes: [
            .font: AppFonts.Regular.withSize(14.0),
            .foregroundColor: AppColors.themeGray40
            ])
        
        //date beautify
        if let dateRange = finalText.range(of: dateStr)?.asNSRange(inString: finalText) {
            dateAttributedString.addAttribute(.foregroundColor, value: AppColors.themeBlack, range: dateRange)
        }
        
        //days beautify
        if let overDueRange = finalText.range(of: overDueText)?.asNSRange(inString: finalText) {
            dateAttributedString.addAttribute(.foregroundColor, value: AppColors.themeRed, range: overDueRange)
        }
        
        self.dateLabel.attributedText = dateAttributedString
    }
}
