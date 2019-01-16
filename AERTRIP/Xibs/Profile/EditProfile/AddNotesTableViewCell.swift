//
//  AddNotesTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 16/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AddNotesTableViewCellDelegate: class {
    func textViewText(_ text:String)
}

class AddNotesTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addNoteTextView: UITextView!
    

    // MARK: - Variables
    weak var delegate : AddNotesTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        addNoteTextView.delegate = self
    }

  
    func configureCell( _ note : String) {
        titleLabel.text = LocalizedString.Notes.localized
        addNoteTextView.text = note
    }
    
}

extension AddNotesTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewText(textView.text)
    }
}
