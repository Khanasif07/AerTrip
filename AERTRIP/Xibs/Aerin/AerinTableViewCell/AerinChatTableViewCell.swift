//
//  AerinChatTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 08/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AerinChatTableViewCellDelegate: class  {
    func tapToEditButtonTapped(_ textView: UITextView)
}

class AerinChatTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var tapToEditButton: UIButton!
    
    
    // MARK: - Variables
    weak var delegate: AerinChatTableViewCellDelegate?
    
    
    // MARK: - View LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpColor()
        self.setUpText()
    }
    
    
    

    
    @IBAction func tapToEditButtonTapped(_ sender: Any) {
        delegate?.tapToEditButtonTapped(self.chatTextView)
    }
    
    
    private func setUpFont() {
        self.chatTextView.font = AppFonts.Regular.withSize(18.0)
        self.tapToEditButton.titleLabel?.font = AppFonts.Regular.withSize(14.0)
    }
    
    private func setUpColor() {
        self.chatTextView.textColor = AppColors.themeBlack
        self.tapToEditButton.titleLabel?.textColor = AppColors.themeGray60
    }
    
    private func setUpText() {
self.tapToEditButton.setTitle(LocalizedString.TapToEdit.localized, for: .normal)
        
    }
    
    
    
    
}
