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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpTextColor()
      
    }
    
    
    // MARK: - Helper methods
    
    private func setUpFont() {
        self.noteLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    private func setUpTextColor() {
        self.noteLabel.textColor = AppColors.themeGray60
    }
    
    
    ///Bulleted Notes Details
    private func bulletedNotesDetails(notes: [String]) -> NSMutableAttributedString {
        let attributesDictionary = [NSAttributedString.Key.font : AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor : AppColors.textFieldTextColor51]
        let fullAttributedString = NSMutableAttributedString()
        let paragraphStyle = AppGlobals.shared.createParagraphAttribute(paragraphSpacingBefore:  0.0)
        for (_,text) in notes.enumerated() {
            let bulletedString = NSMutableAttributedString()
            let bulletedAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: "●  ", attributes: attributesDictionary)
            
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\(text)\n", attributes: attributesDictionary)
            bulletedAttributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, bulletedAttributedString.length))
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            bulletedString.append(bulletedAttributedString)
            bulletedString.append(attributedString)
            fullAttributedString.append(bulletedString)
        }
        self.noteTextView.textColor = AppColors.textFieldTextColor51
        return fullAttributedString
    }
    
    
    
     func configCell(notes: [String]) {
        self.noteTextView.attributedText = self.bulletedNotesDetails(notes: notes)
    }

    
}
