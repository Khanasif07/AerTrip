//
//  EditProfileTwoPartTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 22/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol EditProfileTwoPartTableViewCellDelegate:class {
    func deleteCellTapped(_ indexPath: IndexPath)
    func leftViewTap()
}

class EditProfileTwoPartTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var blackDownImageView: UIImageView!
    @IBOutlet weak var leftSeparatorView: UIView!
    @IBOutlet weak var rightViewTextField: UITextField!
    @IBOutlet weak var rightSeparatorView: UIView!
    
    
    // MARK : - Variables
    weak var delegate : EditProfileTwoPartTableViewCellDelegate?
    var indexPath:IndexPath?
    
    
    // MARK : - View Life cycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.leftViewTap(_:)))
        leftView.isUserInteractionEnabled = true
        leftView.addGestureRecognizer(tap)
    }
    
    // MARK : - Helper methods
    
    func configureCell(_ indexPath:IndexPath,_ label : String, _ value: String) {
        self.indexPath = indexPath
        self.leftTitleLabel.text = label
        self.rightViewTextField.text = value
    }
    
    
  @objc  func leftViewTap(_ sender: UITapGestureRecognizer) {
        delegate?.leftViewTap()
    }

    
    // MARK: - IB Actions
    
    @IBAction func deleteCellButtonTapped(_ sender: Any) {
        if let indexPath = indexPath {
            delegate?.deleteCellTapped(indexPath)
        }
    }
    
    
}
