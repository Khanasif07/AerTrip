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
    @IBOutlet weak var noteTextView: UILabel!  {
        didSet {
//            self.noteTextView.isEditable = false
//            self.noteTextView.textContainerInset = UIEdgeInsets.zero
//           // self.noteTextView.textContainer.lineFragmentPadding = 0.0
//            self.noteTextView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var notesTopConstraint: NSLayoutConstraint!
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
    override func prepareForReuse() {
        super.prepareForReuse()
        self.noteTextView.attributedText = nil
        self.noteTextView.text = ""
    }
    
    private func doInitialSetup() {
        self.noteTextViewTopConstraint.constant = self.isForBookingPolicyCell ? 10 : 0
        self.noteTextViewBottomConstraint.constant = self.isForBookingPolicyCell ? 12 : 0
    }
    
    
    // MARK: - Helper methods
    
    private func setUpFont() {
        self.noteLabel.font = AppFonts.SemiBold.withSize(16.0)//isForBookingPolicyCell ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(14.0)
    }
    
    private func setUpTextColor() {
        self.noteLabel.textColor = AppColors.themeBlack//isForBookingPolicyCell ?  AppColors.themeBlack : AppColors.themeGray40
    }
    
    
    ///Bulleted Notes Details
    private func bulletedNotesDetails(notes: [String],hotelNotes: Bool) -> NSMutableAttributedString {
        let attributesDictionary = [NSAttributedString.Key.font :  AppFonts.Regular.withSize(14.0) , NSAttributedString.Key.foregroundColor : isForBookingPolicyCell ? AppColors.themeBlack : AppColors.themeBlack]
        let fullAttributedString = NSMutableAttributedString()
        //let paragraphStyle = AppGlobals.shared.createParagraphAttribute(paragraphSpacingBefore: 4.0, isForNotes: true,lineSpacing: 2.0)
        for text in notes {
//            let bulletedString = NSMutableAttributedString()
//            let bulletedAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: hotelNotes ? "●  " : "•  ", attributes: attributesDictionary)
//
//            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\(text)\n", attributes: attributesDictionary)
//            bulletedAttributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, bulletedAttributedString.length))
//            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
//            bulletedString.append(bulletedAttributedString)
//            bulletedString.append(attributedString)
//            fullAttributedString.append(bulletedString)
            
            let dotText = hotelNotes ? "●  " : "•  "
            var formattedString: String = "\(dotText)  \(text)\n"
            if text == notes.last ?? "", hotelNotes{
                formattedString = formattedString.replacingOccurrences(of: "\n", with: "")
            }
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString, attributes: attributesDictionary)
            let paragraphStyle = AppGlobals.shared.createParagraphAttribute(paragraphSpacingBefore: 4.0,isForNotes: true,lineSpacing :2.0, headIndent: hotelNotes ? 20 : 15)
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            fullAttributedString.append(attributedString)
        }
        return fullAttributedString
    }
    
    func configCell(note: String) {
        self.noteTextView.text = note
    }
    
    func configCell(notes: [String], hotelNotes: Bool = false) {
        self.noteTextView.attributedText = notes.isEmpty ? NSAttributedString(string: "-\n") : self.bulletedNotesDetails(notes: notes, hotelNotes: hotelNotes )
        if hotelNotes {
           self.noteLabel.textColor = AppColors.themeGray40
            self.noteLabel.font =  AppFonts.Regular.withSize(14.0)
        }
    }
}
