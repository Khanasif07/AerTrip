//
//  SelectDateTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 03/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class SelectDateTableViewCell: UITableViewCell {

    //MARK:- Variables
    //MARK:===========
    
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var newDateLabel: UILabel!
    @IBOutlet weak var selectDateTextField: UITextField!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //MARK:- Functions
    //MARK:===========
    ///Configure UI , Font , Text and Colors
    private func configureUI() {
        //Text
        self.newDateLabel.text = LocalizedString.newDepartingDate.localized
        //Font
        self.newDateLabel.font = AppFonts.Regular.withSize(14.0)
        self.selectDateTextField.font = AppFonts.Regular.withSize(18.0)
        //Color
        self.newDateLabel.textColor = AppColors.themeGray40
        self.selectDateTextField.textColor = AppColors.textFieldTextColor51
        self.dropDownButtonSetUp()
    }
    
    ///Configure drop down button setup
    private func dropDownButtonSetUp() {
        let dropDownButton = UIButton(type: .custom)
        dropDownButton.frame = CGRect(x: 0, y: 0, width: 20.0, height: 20.0)
        dropDownButton.imageEdgeInsets = UIEdgeInsets(top: 1.0, left: 0.0, bottom: 0.0, right: 0.0)
        dropDownButton.setImage(#imageLiteral(resourceName: "downArrow"), for: .normal)
        self.selectDateTextField.rightView = dropDownButton
        self.selectDateTextField.rightViewMode = .always
    }

    
    //MARK:- IBActions
    //MARK:===========
    
}

//MARK:- Extensions
//MARK:============
