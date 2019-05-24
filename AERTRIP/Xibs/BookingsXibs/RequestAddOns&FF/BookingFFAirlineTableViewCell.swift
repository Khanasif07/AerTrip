//
//  BookingFFAirlineTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 22/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookingFFAirlineTableViewCellDelegate: class {
    func textFieldText(_ textField: UITextField)
}

class BookingFFAirlineTableViewCell: ATTableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet weak var airlineImageView: UIImageView!
    @IBOutlet weak var airlineNameLabel: UILabel!
    @IBOutlet weak var airlineNumberTextField: UITextField!
    
    
    // MARK: - Variables
    
    weak var delegate: BookingFFAirlineTableViewCellDelegate?

    
    override func doInitialSetup() {
       
        self.airlineNumberTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    override func setupFonts() {
        self.airlineNumberTextField.delegate = self
        self.airlineNameLabel.font = AppFonts.Regular.withSize(18.0)
        self.airlineNumberTextField.font = AppFonts.Regular.withSize(18.0)
    }
    
   
    override func setupColors() {
        self.airlineNameLabel.textColor = AppColors.themeBlack
        self.airlineNumberTextField.textColor = AppColors.themeBlack
    }
    
    
    func cofigureCell(airlineImage: UIImage,airlineName: String) {
        self.airlineNameLabel.text = airlineName
        self.airlineImageView.image = airlineImage
    }
    
}



extension BookingFFAirlineTableViewCell: UITextFieldDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == " " {
            return false
        }
        
        return true
    }
    
    @objc   func textFieldDidChanged(_ textField:UITextField) {
        self.delegate?.textFieldText(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

