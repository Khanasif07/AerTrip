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
        self.contentView.backgroundColor = AppColors.themeBlack26
        
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
    
    
    func getFareInfoAttributedNote() -> NSMutableAttributedString
    {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.headIndent = 15
        style.paragraphSpacingBefore = 16
        
        let str1 = "IMPORTANT".capitalized
        let str2 = "\n•    Above mentioned charges are per passenger per sector, applicable only on refundable fares.\n•    Total Cancellation Charges displayed above include Cancellation Fees, RAF & GST.\n•    Total Rescheduling Charges = Rescheduling Fees as above + Fare Difference + Differences in Taxes (if any).\n•    In case of no-show or if the ticket is not cancelled or amended within the stipulated time, no refund is applicable.\n•    Airlines do not accept cancellation/rescheduling requests 1-75 hours before departure the flight, depending on the airline, fare basis and booking fare policy. You must raise a request at least 2 hours before the airline request time.\n•    In case of restricted fares, no amendments and/or cancellation may be allowed.\n•    In case of combo fares or round-trip special fares or tickets booked under special discounted fares, cancellation of a partial journey may not be allowed. In certain cases, cancellation or amendment of future sectors may be allowed only if the previous sectors are flown."
        let str3 = "\n\nDISCLAIMER".capitalized
        let str4 = "\n•    Above mentioned charges are indicative, subject to currency fluctuations and can change without prior notice. They need to be re-confirmed before making any amendments or cancellation. Aertrip does not guarantee or warrant this information."
        let font = AppFonts.SemiBold.withSize(16)
        let fontSuper = AppFonts.Regular.withSize(14)
        
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font])
        let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper])
        
        let attString2:NSMutableAttributedString = NSMutableAttributedString(string: str3, attributes: [.font:font])
        let attString3:NSMutableAttributedString = NSMutableAttributedString(string: str4, attributes: [.font:fontSuper])
        
        attString.append(attString1)
        attString.append(attString2)
        attString.append(attString3)
        
        attString.addAttributes([NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor: AppColors.themeBlack], range: NSRange(location: 0, length: attString.string.count))
        let stl = NSMutableParagraphStyle()
        stl.alignment = .left
        stl.headIndent = 15
        stl.paragraphSpacingBefore = 3
        attString.addAttributes([.paragraphStyle: stl], range: NSString(string:(str1 + str2 + str3 + str4)).range(of: str3))
        return attString
    }
}
