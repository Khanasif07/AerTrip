//
//  FareInfoNoteTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FareInfoNoteTableViewCell: UITableViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!  {
        didSet {
            self.noteTextView.isEditable = false
            self.noteTextView.textContainerInset = UIEdgeInsets.zero
            self.noteTextView.textContainer.lineFragmentPadding = 0.0
            self.noteTextView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var noteTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteTextViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    // this is the case for the booking policy
    var isForBookingPolicyCell: Bool = false {
        didSet {
            self.setUpFont()
            self.setUpTextColor()
            self.doInitialSetup()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    private func doInitialSetup() {
        self.noteTextViewTopConstraint.constant = self.isForBookingPolicyCell ? 10 : 0
        self.noteTextViewBottomConstraint.constant = self.isForBookingPolicyCell ? 12 : 0
    }
    
    
    // MARK: - Helper methods
    
    private func setUpFont() {
        self.noteLabel.font = isForBookingPolicyCell ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(14.0)
    }
    
    private func setUpTextColor() {
        self.noteLabel.textColor = isForBookingPolicyCell ?  AppColors.themeBlack : AppColors.themeGray40
    }
    
    
    ///Bulleted Notes Details
    private func bulletedNotesDetails(notes: [String]) -> NSMutableAttributedString {
        let attributesDictionary = [NSAttributedString.Key.font : isForBookingPolicyCell ? AppFonts.Regular.withSize(18.0) : AppFonts.Regular.withSize(14.0) , NSAttributedString.Key.foregroundColor : isForBookingPolicyCell ? AppColors.themeBlack : AppColors.themeBlack]
        let fullAttributedString = NSMutableAttributedString()
        let paragraphStyle = AppGlobals.shared.createParagraphAttribute(paragraphSpacingBefore: 4.0, isForNotes: true,lineSpacing: 2.0)
        for text in notes {
            let bulletedString = NSMutableAttributedString()
            let bulletedAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: "●  ", attributes: attributesDictionary)
            
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\(text)\n", attributes: attributesDictionary)
            bulletedAttributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, bulletedAttributedString.length))
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            bulletedString.append(bulletedAttributedString)
            bulletedString.append(attributedString)
            fullAttributedString.append(bulletedString)
        }
        return fullAttributedString
    }
    
    func configCell(note: String) {
        self.noteTextView.text = note
    }
    
    func configCell(notes: [String]) {
        self.noteTextView.attributedText = notes.isEmpty ? NSAttributedString(string: "-\n") : self.bulletedNotesDetails(notes: notes)
    }
}
