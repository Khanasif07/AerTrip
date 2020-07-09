//
//  MealPreferenceCell.swift
//  Aertrip
//
//  Created by Apple  on 06.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class MealPreferenceCell: UITableViewCell {
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var airlineImage: UIImageView!
    @IBOutlet weak var airlineNameLabel: UILabel!
    @IBOutlet weak var programView: UIView!
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var programTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var bottomSeparatorView: UIView!
    @IBOutlet weak var leadingOfSeparatorView: NSLayoutConstraint!
    @IBOutlet weak var trailingOfSeparatorView: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellLargeTitleHeight: NSLayoutConstraint!
    var passenger = ATContact()
    var cellIndexPath = IndexPath()
    var index = 0
    var type = "meal"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        configureInitialUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureInitialUI(){
        cellTitleLabel.font = AppFonts.Regular.withSize(14)
        cellTitleLabel.textColor = AppColors.themeGray40
        airlineNameLabel.font = AppFonts.Regular.withSize(18)
        airlineNameLabel.textColor = AppColors.themeBlack
        programTextField.font = AppFonts.Regular.withSize(18)
        numberTextField.font = AppFonts.Regular.withSize(18)
        numberTextField.setUpAttributedPlaceholder(placeholderString: "Number", with: "", foregroundColor: AppColors.themeBlack)
        numberTextField.delegate = self
        programTextField.delegate = self
        
    }
    
    
    func configureForMealPreference(with passenger: ATContact, at indexPath: IndexPath){
        self.numberView.isHidden = true
        self.programView.isHidden = false
        self.cellIndexPath = indexPath
        self.passenger = passenger
        self.index = indexPath.row - 1
        self.type = "meal"
        self.programTextField.setUpAttributedPlaceholder(placeholderString: "Select", with: "", foregroundColor: AppColors.themeBlack,isChnagePlacehoder:true)
        self.airlineNameLabel.text = self.passenger.mealPreference[index].journeyTitle
        self.programTextField.text = self.passenger.mealPreference[index].mealPreference
        self.airlineImage.setImageWithUrl(self.passenger.mealPreference[index].airlineLogo, placeholder: UIImage(), showIndicator: false)
        self.cellTitleLabel.text = (index == 0) ? "Meal Preference" : ""
        self.titleTopConstraint.constant = (index == 0) ? 16.0 : 0.0
        self.titleBottomConstraint.constant = (index == 0) ? 6.0 : 0.0
        self.cellLargeTitleHeight.constant = (index == 0) ? 20.0 : 0.0
        self.leadingOfSeparatorView.constant = (index == passenger.mealPreference.count - 1) ? 16 : 52
        self.bottomSeparatorView.isHidden = false
    }
    
    func configureForFlyer(with passenger: ATContact, at indexPath: IndexPath){
        self.numberView.isHidden = false
        self.programView.isHidden = true
        self.cellIndexPath = indexPath
        self.passenger = passenger
        self.programTextField.setUpAttributedPlaceholder(placeholderString: "Program", with: "", foregroundColor: AppColors.themeBlack, isChnagePlacehoder:true)
        self.index = (indexPath.row - passenger.mealPreference.count - 1)
        self.type = "ff"
        self.airlineNameLabel.text = self.passenger.frequentFlyer[index].airlineName
        self.programTextField.text = self.passenger.frequentFlyer[index].program
        self.airlineImage.setImageWithUrl(self.passenger.frequentFlyer[index].logoUrl, placeholder: UIImage(), showIndicator: false)
        self.numberTextField.text = self.passenger.frequentFlyer[index].number
        self.numberTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        self.cellTitleLabel.text = (index == 0) ? "Frequent Flyer" : ""
        self.titleTopConstraint.constant = (index == 0) ? 8.0 : 0.0
        self.titleBottomConstraint.constant = (index == 0) ? 6.0 : 0.0
        self.cellLargeTitleHeight.constant = (index == 0) ? 20.0 : 0.0
        self.leadingOfSeparatorView.constant = (index == passenger.frequentFlyer.count - 1) ? 16 : 52
        self.bottomSeparatorView.isHidden = (index == passenger.frequentFlyer.count - 1)
    }

}

extension MealPreferenceCell: UITextFieldDelegate{
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       
        if textField == programTextField{
            var listData = [String]()
            if self.type == "meal"{
                listData = Array(self.passenger.mealPreference[index].preference.values)
            }else{
                listData = []
            }
            
            PKMultiPicker.noOfComponent = 1
            PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: listData, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { [unowned self]  (firstSelect, secondSelect) in
                if self.type == "meal"{
                    GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].mealPreference[self.index].mealPreference = firstSelect
                    GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].mealPreference[self.index].preferenceCode = self.passenger.mealPreference[self.index].preference.someKey(forValue: firstSelect) ?? ""
                    textField.text = firstSelect
                }else{
                    
                }
                
            }
            textField.tintColor = AppColors.clear
        }
        return true
            
       
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        if (textField.text?.removeAllWhiteSpacesAndNewLines.isEmpty ?? true){
            textField.text = ""
        }
        GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].frequentFlyer[self.index].number = textField.text ?? ""
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
