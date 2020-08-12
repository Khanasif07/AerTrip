//
//  AddAddressTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 02/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AddAddressTableViewCellDelegate:class {
    func addressTypeViewTapped(_ indexPath: IndexPath)
    func countryViewTapped(_ indexPath:IndexPath)
    func addAddressTextField(_ textfield:UITextField,_ indexPath:IndexPath,_ fullString:String)
    func deleteAddressCellTapped(_ indexPath:IndexPath)
}

class AddAddressTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var addressTypeLabel: UILabel!
    @IBOutlet weak var addressLineOneTextField: UITextField!
    
    @IBOutlet weak var addressLineTwoTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var countryLabel:UILabel!
    
    @IBOutlet weak var addressTypeView: UIView!
    @IBOutlet weak var countryView: UIView!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var bottomDivider: ATDividerView!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var seperatorDividerView: ATDividerView!
    @IBOutlet weak var seperatorViewHeightConstraint: NSLayoutConstraint!
    // MARK: - Variables
    weak var delegate:AddAddressTableViewCellDelegate?
    
    var hideSepratorView = false {
        didSet {
            self.mangeSeparatorView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      //self.cellDividerView.defaultHeight = 1.0
        hideSepratorView = true
        seperatorView.backgroundColor = AppColors.greyO4
    }
    
    
    
    
   

    
    // MARK: - Helper methods
    
    func configureCell(addressType type:String, addressLineOne lineOne :String,addressLineTwo lineTwo:String,cityName city :String,postalCode code :String,stateName state:String, countryName country:String) {
        
        self.addressTypeLabel.text = type
        self.addressLineOneTextField.text = lineOne
        self.addressLineOneTextField.delegate = self
        self.addressLineTwoTextField.text = lineTwo
        self.addressLineTwoTextField.delegate = self
        self.cityTextField.text = city
        self.cityTextField.delegate = self
        self.postalCodeTextField.text = code
        self.postalCodeTextField.delegate = self
        self.stateTextField.text = state
        self.stateTextField.delegate = self
        self.countryLabel.text = country
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addressTypeTapped(gesture:)))
        gesture.numberOfTapsRequired = 1
        addressTypeView.isUserInteractionEnabled = true
        addressTypeView.tag = indexPath?.row ?? 0
        addressTypeView.addGestureRecognizer(gesture)
        
        let countryViewGesture = UITapGestureRecognizer(target: self, action: #selector(countryViewTapped(gesture:)))
        countryViewGesture.numberOfTapsRequired = 1
        countryView.isUserInteractionEnabled = true
        countryView.tag = indexPath?.row ?? 0
        countryView.addGestureRecognizer(countryViewGesture)
        
        
        
    }
    
    func mangeSeparatorView() {
        seperatorView.isHidden = hideSepratorView
        seperatorDividerView.isHidden = hideSepratorView
        self.seperatorViewHeightConstraint.constant = hideSepratorView ? 0  : 10
        self.contentView.layoutIfNeeded()
    }
    
    @objc func addressTypeTapped(gesture: UITapGestureRecognizer) {
        if let idxPath = indexPath {
          delegate?.addressTypeViewTapped(idxPath)
        }
    }
    
    @objc func countryViewTapped(gesture: UITapGestureRecognizer) {
        if let idxPath = indexPath {
            delegate?.countryViewTapped(idxPath)
        }
    }
    
    
    @IBAction func deleteCellTapped(_ sender: Any) {
        if let idxPath = indexPath {
            delegate?.deleteAddressCellTapped(idxPath)
        }
    }
    
    
    
    
}


extension AddAddressTableViewCell:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        printDebug("text field text \(textField.text ?? " ")")
        guard let inputMode = textField.textInputMode else {
            return false
        }
        if inputMode.primaryLanguage == "emoji" || !(inputMode.primaryLanguage != nil) {
            return false
        }
        if let idxPath = indexPath {
            if let textFieldString = textField.text, let swtRange = Range(range, in: textFieldString) {
                let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)
                delegate?.addAddressTextField(textField, idxPath, fullString)
            }
        }
        switch textField {
        case self.postalCodeTextField:
            let set = NSCharacterSet.alphanumerics.inverted
            return string.rangeOfCharacter(from: set) == nil
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

