//
//  EditProfileThreePartTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 22/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol EditProfileThreePartTableViewCellDelegate: class {
    func editProfileThreePartDeleteCellTapped(_ indexPath: IndexPath)
    func threePartLeftViewTap(_ gesture: UITapGestureRecognizer)
    func middleViewTap(_ gesture: UITapGestureRecognizer)
    func editProfileThreePartTableViewCellTextFieldText(_ indexPath: IndexPath, _ text: String)
}

class EditProfileThreePartTableViewCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet var leftView: UIView!
    @IBOutlet var leftTitleLabel: UILabel!
    @IBOutlet var blackDownImageView: UIImageView!
    @IBOutlet var leftSeparatorView: UIView!
    @IBOutlet var rightViewTextField: UITextField!
    @IBOutlet var rightSeparatorView: UIView!
    @IBOutlet var deleteButton: UIButton!
    
    @IBOutlet var middleView: UIView!
    @IBOutlet var flagImageView: UIImageView!
    @IBOutlet var countryCodeLabel: UILabel!
    
    // MARK: - Variables
    
    weak var delegate: EditProfileThreePartTableViewCellDelegate?
    var indexPath: IndexPath?
    
    // MARK: - View Life cycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftView.isUserInteractionEnabled = true
    }
    
    // MARK: - Helper methods
    
    func configureCell(_ indexPath: IndexPath, _ isd: String, _ label: String, _ value: String) {
        self.indexPath = indexPath
        leftTitleLabel.text = label
        rightViewTextField.text = value
        countryCodeLabel.text = isd
        
        if indexPath.row == 0 {
            leftView.isUserInteractionEnabled = false
            middleView.isUserInteractionEnabled = false
            rightViewTextField.isEnabled = false
            deleteButton.isHidden = true
        } else {
            rightViewTextField.delegate = self
            let gesture = UITapGestureRecognizer(target: self, action: #selector(leftViewTap(gesture:)))
            gesture.numberOfTapsRequired = 1
            leftView.isUserInteractionEnabled = true
            leftView.tag = indexPath.row
            leftView.addGestureRecognizer(gesture)
            
            let middleViewGesture = UITapGestureRecognizer(target: self, action: #selector(middleViewTap(gesture:)))
            middleViewGesture.numberOfTapsRequired = 1
            middleView.isUserInteractionEnabled = true
            middleView.tag = indexPath.row
            middleView.addGestureRecognizer(middleViewGesture)
        }
    }
    
    @objc func leftViewTap(gesture: UITapGestureRecognizer) {
        delegate?.threePartLeftViewTap(gesture)
    }
    
    @objc func middleViewTap(gesture: UITapGestureRecognizer) {
        NSLog("middle view tapped")
        delegate?.middleViewTap(gesture)
    }
    
    // MARK: - IB Actions
    
    @IBAction func deleteCellButtonTapped(_ sender: Any) {
        if let indexPath = indexPath {
            delegate?.editProfileThreePartDeleteCellTapped(indexPath)
        }
    }
}

// MARK: - TextFieldDelegateMethods

extension EditProfileThreePartTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSLog("text field text \(textField.text ?? " ")")
        if let indexPath = indexPath {
            if let textFieldString = textField.text, let swtRange = Range(range, in: textFieldString) {
                let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)
                delegate?.editProfileThreePartTableViewCellTextFieldText(indexPath, fullString)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
