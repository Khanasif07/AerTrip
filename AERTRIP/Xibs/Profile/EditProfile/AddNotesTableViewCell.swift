//
//  AddNotesTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 16/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AddNotesTableViewCellDelegate: class {
    func textViewText(_ text: String)
}

class AddNotesTableViewCell: UITableViewCell {
    // MARK: - IB Outlets

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addNoteTextView: UITextView!

    // MARK: - Variables

    weak var delegate: AddNotesTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        addNoteTextView.delegate = self
        addNoteTextView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        addNoteTextView.text = LocalizedString.AddNotes.localized
        addNoteTextView.textColor = UIColor.lightGray
    }

    func configureCell(_ note: String) {
        titleLabel.text = LocalizedString.Notes.localized
        if !note.isEmpty {
            addNoteTextView.textColor = AppColors.textFieldTextColor
            addNoteTextView.text = note
        }
    }
}

extension AddNotesTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewText(textView.text)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if addNoteTextView.text == LocalizedString.AddNotes.localized {
            addNoteTextView.text = nil
            addNoteTextView.textColor = AppColors.textFieldTextColor
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = LocalizedString.AddNotes.localized
            textView.textColor = UIColor.lightGray
        }
    }
}
