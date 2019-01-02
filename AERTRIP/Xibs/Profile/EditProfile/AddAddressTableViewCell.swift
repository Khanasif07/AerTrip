//
//  AddAddressTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 02/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AddAddressTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var addressTypeLabel: UILabel!
    @IBOutlet weak var addressLineOneTextField: UITextField!
    
    @IBOutlet weak var addressLineTwoTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var countryLabel:UILabel!
    
    
    @IBOutlet weak var cellDividerViewHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    // MARK: - Helper methods
    
    func configureCell(addressType type:String, addressLineOne lineOne :String,addressLineTwo lineTwo:String,cityName city :String,postalCode code :String,stateName state:String, countryName country:String) {
        self.addressTypeLabel.text = type
        self.addressLineOneTextField.text = lineOne
        self.addressLineTwoTextField.text = lineTwo
        self.cityTextField.text = city
        self.postalCodeTextField.text = code
        self.stateTextField.text = state
        self.countryLabel.text = country
        
    }
    
    
    
}
