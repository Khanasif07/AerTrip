//
//  GroupTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 08/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol GroupTableViewCellDelegate : class {
    func deleteCellTapped(_ indexPath:IndexPath)
}

class GroupTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var groupCountLabel: UILabel!
    @IBOutlet weak var reorderButton: UIButton!
    @IBOutlet weak var dividerView: ATDividerView!
    
    // MARK: - Variables
    weak var delegate : GroupTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        groupNameTextField.font = AppFonts.Regular.withSize(18.0)
        groupNameTextField.textColor = AppColors.themeBlack
        
        groupCountLabel.font = AppFonts.Regular.withSize(18.0)
        groupCountLabel.textColor = AppColors.themeGray40
    }
    
    // MARK: - Helper methods
    
    func configureCell(_ groupName: String, _ totalContactsCount: Int) {
        groupNameTextField.text = groupName
        
        groupCountLabel.text = "\(totalContactsCount)"
    }
    
    
    @IBAction func deleteCellTapped(_ sender: Any) {
        if let idxPath = indexPath {
            delegate?.deleteCellTapped(idxPath)
        }
    }
}
