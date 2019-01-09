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
    
    // MARK: - Variables
    var indexPath : IndexPath?
    weak var delegate : GroupTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Helper methods
    
    func configureCell(_ indexPath:IndexPath,_ groupName:String) {
        self.indexPath = indexPath
        groupNameTextField.text = groupName
    }
    
    
    @IBAction func deleteCellTapped(_ sender: Any) {
        if let indexPath = indexPath {
            delegate?.deleteCellTapped(indexPath)
        }
    }
    
    
    
    

   
}
