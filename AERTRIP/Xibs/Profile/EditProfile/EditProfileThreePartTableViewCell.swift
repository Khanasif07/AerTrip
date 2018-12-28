//
//  EditProfileThreePartTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 22/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol EditProfileThreePartTableViewCellDelegate:class {
    func editProfileThreePartDeleteCellTapped(_ indexPath: IndexPath)
    func threePartLeftViewTap(_ gesture: UITapGestureRecognizer)
    func middleViewTap(_ gesture: UITapGestureRecognizer)
     func editProfileThreePartTableViewCellTextFieldText(_ indexPath: IndexPath, _ text: String)
    
}

class EditProfileThreePartTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var blackDownImageView: UIImageView!
    @IBOutlet weak var leftSeparatorView: UIView!
    @IBOutlet weak var rightViewTextField: UITextField!
    @IBOutlet weak var rightSeparatorView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    
    // MARK : - Variables
    weak var delegate : EditProfileThreePartTableViewCellDelegate?
    var indexPath:IndexPath?
    
    
    
    // MARK : - View Life cycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         leftView.isUserInteractionEnabled = true
    }
    
    // MARK : - Helper methods
    
    func configureCell(_ indexPath:IndexPath,_ isd:String,_ label : String, _ value: String) {
        self.indexPath = indexPath
        self.leftTitleLabel.text = label
        self.rightViewTextField.text = value
        self.countryCodeLabel.text = isd
        
        self.rightViewTextField.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.leftViewTap(gesture:)))
        gesture.numberOfTapsRequired = 1
        leftView.isUserInteractionEnabled = true
        leftView.tag = indexPath.row
        leftView.addGestureRecognizer(gesture)
        
        let middleViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.middleViewTap(gesture:)))
        middleViewGesture.numberOfTapsRequired = 1
        middleView.isUserInteractionEnabled = true
        middleView.tag = indexPath.row
        middleView.addGestureRecognizer(middleViewGesture)
        
    }
    
    
    @objc  func leftViewTap(gesture: UITapGestureRecognizer) {
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


// MARK:- TextFieldDelegateMethods

extension EditProfileThreePartTableViewCell : UITextFieldDelegate {
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
