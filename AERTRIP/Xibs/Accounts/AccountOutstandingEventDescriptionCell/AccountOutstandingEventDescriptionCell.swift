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
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var selectButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    
    var event: AccountDetailEvent? {
        didSet {
            self.setData()
        }
    }
    
    var isSelectable: Bool = false {
        didSet {
            self.manageSelectable()
        }
    }
    
    var isHotelSelected: Bool = false {
        didSet {
            self.manageSelectedState()
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
//        self.mainContainerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner ,.layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize(width: 0.0, height: 1.0), opacity: 0.7, shadowRadius: 3.0)
        
        self.mainContainerView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.3), offset: CGSize.zero, opacity: 0.5, shadowRadius: 4.0)

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
        
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        
        self.titleLabel.textColor = AppColors.themeBlack
        
        self.isSelectable = false
    }
    
    private func resetAllText() {
        self.amountValueLabel.text = ""
        self.pendingValueLabel.text = ""
        
        self.amountValueLabel.attributedText = nil
        self.pendingValueLabel.attributedText = nil
        
        self.dateLabel.text = "Due Date:"
        
        self.iconImageView.image = nil
        self.titleLabel.text = ""
        self.titleLabel.attributedText = nil
    }
    
    private func manageSelectable() {
        self.selectButtonHeightConstraint.constant = self.isSelectable ? 22.0 : 0.0
        self.selectButtonLeadingConstraint.constant = self.isSelectable ? 16.0 : 0.0
    }
    
    private func manageSelectedState() {
        self.selectionButton.isSelected = self.isHotelSelected
    }
    
    private func setData() {
        
        guard let event = self.event else {
            self.resetAllText()
            return
        }
        
        self.iconImageView.image = event.iconImage
//        self.titleLabel.text = event.title
        if let atbTxt = event.attributedString{
            self.titleLabel.text = nil
            self.titleLabel.attributedText = atbTxt
        }else{
            self.titleLabel.attributedText = nil
            self.titleLabel.text = event.title
        }
        
        self.titleLabel.AttributedFontAndColorForText(atributedText: LocalizedString.CancellationFor.localized, textFont: AppFonts.Regular.withSize(14), textColor: AppColors.themeRed)
        self.titleLabel.AttributedFontAndColorForText(atributedText: LocalizedString.ReschedulingFor.localized, textFont: AppFonts.Regular.withSize(14), textColor: AppColors.themeRed)

        
        let drAttr = NSMutableAttributedString(string: " \(LocalizedString.DebitShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
        let crAttr = NSMutableAttributedString(string: " \(LocalizedString.CreditShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
        
        let amount = abs(event.amount).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        amount.append((event.amount < 0) ? drAttr : crAttr)
        self.amountValueLabel.attributedText = amount
        
        let pending = abs(event.pendingAmount).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        pending.append((event.pendingAmount > 0) ? drAttr : crAttr)
        self.pendingValueLabel.attributedText = pending
        
        //set date
        let days = event.overDueDays
        let dayStr = (days > 1) ? "days" : "day"
        let overDueText = "Over Due by \(days) \(dayStr)"
        
        let dueText = "Due Date:"
        
        var dateStr = ""
        if let date = event.dueDate {
            dateStr = date.toString(dateFormat: "dd-MM-YYYY") + "  • "//" |"
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
