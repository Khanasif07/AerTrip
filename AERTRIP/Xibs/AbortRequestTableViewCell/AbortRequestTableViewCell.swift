//
//  AbortRequestTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 07/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import IQKeyboardManager

protocol AbortRequestTableViewCellDelegate: class {
    func AbortRequestComment(comment: String, textView: UITextView)
}
class AbortRequestTableViewCell: ATTableViewCell {
    
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var addCommentTextView: IQTextView!
    @IBOutlet weak var abortRequestTitleLabel: UILabel!
    @IBOutlet weak var bottomDivider: ATDividerView!
    
    weak var delegate: AbortRequestTableViewCellDelegate?
    
    override func setupFonts() {
        self.abortRequestTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.addCommentTextView.font = AppFonts.Regular.withSize(18.0)
        self.characterCountLabel.font = AppFonts.Regular.withSize(14.0)

    }
    
    /// Setup Colors
    override func setupColors() {
        self.addCommentTextView.tintColor = AppColors.themeGreen
        self.abortRequestTitleLabel.textColor = AppColors.themeBlack
        self.addCommentTextView.placeholderTextColor = AppColors.themeGray20
        self.characterCountLabel.textColor = AppColors.themeGray40
    }
    
    /// Setup Texts
    override func setupTexts() {
        addCommentTextView.placeholder = LocalizedString.EnterComments.localized
        self.abortRequestTitleLabel.text = LocalizedString.AbortTitle.localized
    }
    
    /// Do Inital setup
    
    override func doInitialSetup()  {
        addCommentTextView.layoutSubviews()
        if addCommentTextView.text.isEmpty {
            addCommentTextView.alignTextCenterVerticaly()
        }
        printDebug("addCommentTextView.size: \(addCommentTextView.size)")
        self.addCommentTextView.delegate = self
    }
    
    func configure(comment: String) {
        addCommentTextView.text = comment
        updateCharacterCount()
    }
    
    func updateCharacterCount() {
        let textCount = (addCommentTextView.text ?? "").count
        self.characterCountLabel.text = "\(AppConstants.AbortRequestTextLimit - textCount) \(LocalizedString.CharactersRemaining.localized)"
    }
}
// MARK: - UITextViewDelegate methods
extension AbortRequestTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.AbortRequestComment(comment: textView.text, textView: textView)
        updateCharacterCount()
      //  viewModel.comment = textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let inputMode = textView.textInputMode else {
                   return false
               }
               if inputMode.primaryLanguage == "emoji" || !(inputMode.primaryLanguage != nil) {
                   return false
               }
        let currentString: NSString = textView.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
        
        return newString.length <= AppConstants.AbortRequestTextLimit
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.AbortRequestComment(comment: textView.text, textView: textView)
        updateCharacterCount()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.delegate?.AbortRequestComment(comment: textView.text, textView: textView)
        return true
    }
}
