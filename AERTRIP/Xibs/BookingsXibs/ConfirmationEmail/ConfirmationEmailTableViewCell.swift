//
//  ConfirmationEmailTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 06/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class ConfirmationEmailTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var toEmailTextView: ATEmailSelectorTextView!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailHeightConatraint: NSLayoutConstraint!

    
    // MARK: - Properties
    
    weak var delegate: EmailComposeerHeaderViewDelegate?
    
    
    // MARK: - View LifeCycel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSeup()
        self.setUpText()
        self.setUpColor()
        self.setUpFont()
    }
    
    // MARK: - Helper methods
    
    private func doInitialSeup() {
        self.toEmailTextView.delegate = self
        self.toEmailTextView.textContainerInset = UIEdgeInsets.zero
        //        self.toEmailTextView.textContainer.lineFragmentPadding = 0
        
    }
    
    private func setUpText() {
        self.toLabel.text = LocalizedString.To.localized
        self.messageLabel.text = LocalizedString.Message.localized
        self.toEmailTextView.placeholder = LocalizedString.EnterEmail.localized
    }
    
    private func setUpFont() {
        self.toLabel.font = AppFonts.Regular.withSize(14.0)
        self.messageLabel.font = AppFonts.Regular.withSize(14.0)
        // to Email Text View font
        self.toEmailTextView.inactiveTagFont = AppFonts.Regular.withSize(18.0)
        self.toEmailTextView.activeTagFont = AppFonts.Regular.withSize(18.0)
        self.toEmailTextView.tagSeparatorFont = AppFonts.Regular.withSize(18.0)
    }
    
    private func setUpColor() {
        self.toLabel.textColor = AppColors.themeGray40
        self.messageLabel.textColor = AppColors.themeGray40
        self.toEmailTextView.activeTagBackgroundColor = AppColors.themeGreen
        self.toEmailTextView.inactiveTagFontColor = AppColors.themeGreen
        self.toEmailTextView.activeTagFontColor = AppColors.themeWhite
        self.toEmailTextView.tagSeparatorColor = AppColors.themeGreen
        if #available(iOS 13, *) {
        }else{
            self.toEmailTextView.placeholderTextColor = AppColors.themeGray40
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction func openContactScreenTapped(_ sender: Any) {
        self.delegate?.openContactScreen()
    }
}

// MARK: - UITextViewDelegate methods

// MARK: - UITextViewDelegate  Methods

extension ConfirmationEmailTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.textViewText(emailTextView: textView)
        //self.delegate?.updateHeightOfHeader(self, textView)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == " " {
            return false
        }
        return true
    }
    
    
}
