//
//  SelectDateTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 03/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SelectDateTableViewCellDelegate: class {
    func didSelect(_ sender: SelectDateTableViewCell, date: Date?)
}

class SelectDateTableViewCell: UITableViewCell {
    
    //MARK:- Variables
    //MARK:===========
    weak var delegate: SelectDateTableViewCellDelegate?
    private var datePicker = UIDatePicker()
    var genericPickerView: UIView = UIView()
    let pickerSize: CGSize = UIPickerView.pickerSize
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var newDateLabel: UILabel!
    @IBOutlet weak var selectDateTextField: UITextField! {
        didSet {
            self.selectDateTextField.delegate = self
        }
    }
    
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
        self.selectDateTextField.tintColor = AppColors.themeWhite.withAlphaComponent(0.01)
        //Color
        self.newDateLabel.textColor = AppColors.themeGray40
        self.selectDateTextField.textColor = AppColors.textFieldTextColor51
        self.dropDownButtonSetUp()
        self.configureDatePickerView()
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
    
    ///COnfigure date picker view
    private func configureDatePickerView() {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.height - 44.0 + 216.0, width: UIScreen.main.bounds.width, height: 44.35)
        let bottomView = UIView()
        bottomView.frame = CGRect(x: 0.0, y: 44.00, width: UIScreen.main.bounds.width, height: 0.35)
        bottomView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
        toolbar.addSubview(bottomView)
        //toolbar.layer.borderColor = AppColors.themeBlack.withAlphaComponent(0.3).cgColor
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let greenAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
        doneButton.setTitleTextAttributes(greenAttribute , for: .normal)
        toolbar.setItems([spaceButton,doneButton], animated: true)
//        self.datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.height - pickerViewHeight, width: UIScreen.main.bounds.width , height: pickerViewHeight)
        self.datePicker.minimumDate = Date()
        self.datePicker.maximumDate = Date().add(years: 0, months: 0, days: 29, hours: 0, minutes: 0, seconds: 0)
        self.datePicker.datePickerMode = .date
        self.datePicker.backgroundColor = AppColors.themeWhite
        
        toolbar.backgroundColor = AppColors.secondarySystemFillColor
        toolbar.barTintColor = AppColors.secondarySystemFillColor
        
        datePicker.frame = CGRect(x: 0, y: 0, width: pickerSize.width, height: pickerSize.height)
        genericPickerView.addSubview(self.datePicker)
        genericPickerView.frame = CGRect(x: 0, y: 0, width: pickerSize.width, height: pickerSize.height)
        self.genericPickerView.addBlurEffect(backgroundColor: AppColors.quaternarySystemFillColor, style: .dark, alpha: 1.0)
        
        self.selectDateTextField.inputAccessoryView = toolbar
        self.selectDateTextField.inputView = self.genericPickerView
        self.datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
        self.selectDateTextField.text = LocalizedString.Select.localized//Date().toString(dateFormat: "dd MMM YYYY")
    }
    
    
    //MARK:- IBActions
    //MARK:===========
    @objc func doneDatePicker(){
        self.selectDateTextField.text = datePicker.date.toString(dateFormat: "dd MMM YYYY")
        self.delegate?.didSelect(self, date: datePicker.date)
        self.endEditing(true)
    }
    
    @objc func datePickerValueChanged (_ datePicker: UIDatePicker) {
        self.selectDateTextField.text = datePicker.date.toString(dateFormat: "dd MMM YYYY")
        self.delegate?.didSelect(self, date: datePicker.date)
    }
}

//MARK:- Extensions
//MARK:============

extension SelectDateTableViewCell: UITextFieldDelegate {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        self.selectDateTextField.inputView = self.datePicker
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}
