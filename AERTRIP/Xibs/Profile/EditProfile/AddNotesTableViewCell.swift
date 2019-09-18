//
//  AddNotesTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 16/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AddNotesTableViewCellDelegate: class {
    func textViewText(_ textView: UITextView)
}

class AddNotesTableViewCell: UITableViewCell {
    // MARK: - IB Outlets

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addNoteTextView: PKTextView!
    @IBOutlet weak var sepratorView: ATDividerView!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    var isHiddenBottomView: Bool = false {
        didSet {
            self.manageSeprator()
        }
    }
    
    weak var delegate: AddNotesTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addNoteTextView.delegate = self
        addNoteTextView.placeholder = LocalizedString.AddNotes.localized
        addNoteTextView.placeholderInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        addNoteTextView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        self.manageSeprator()
    }

    func configureCell(_ note: String) {
        titleLabel.text = LocalizedString.Notes.localized
        if !note.isEmpty {
            addNoteTextView.textColor = AppColors.textFieldTextColor51
            addNoteTextView.text = note
        }
    }
    
    private func manageSeprator() {
        self.sepratorView.isHidden = self.isHiddenBottomView
    }
}

extension AddNotesTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewText(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}
