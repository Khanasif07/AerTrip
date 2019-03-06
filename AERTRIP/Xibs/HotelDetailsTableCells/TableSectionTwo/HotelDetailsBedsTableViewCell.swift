//
//  HotelDetailsBedsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 13/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsBedsTableViewCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    private var typesOfBed = [String]()
    private var bedPickerView = UIPickerView()
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bedTypeLabel: UILabel!
    @IBOutlet weak var bedDiscriptionLabel: UILabel!
    @IBOutlet weak var bookmarkButtonOutlet: UIButton!
    @IBOutlet weak var bedsLabel: UILabel!
    @IBOutlet weak var deviderView: ATDividerView!
    @IBOutlet weak var dropDownTextField: UITextField!

    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //Mark:- Methods
    //==============
    ///Configure UI
    private func configureUI() {
        //Color
        self.backgroundColor = AppColors.screensBackground.color
//        self.containerView.shadowOnHotelDetailsTabelCell(color: AppColors.themeGray20, offset: CGSize(width: 0.0, height: 5.0), opacity: 0.7, shadowRadius: 6.0)
        self.containerView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.bedTypeLabel.textColor = AppColors.themeBlack
        self.bedDiscriptionLabel.textColor = AppColors.themeBlack
        self.bedsLabel.textColor = AppColors.themeBlack
        self.dropDownTextField.textColor = AppColors.themeGreen
        //Size
        self.bedTypeLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.bedsLabel.font = AppFonts.Regular.withSize(16.0)
        self.dropDownTextField.font = AppFonts.SemiBold.withSize(16.0)
        self.bedSelectionTitleImgSetUp()
        self.configurePickerView()
    }
    
    ///Configure PickerView
    private func configurePickerView() {
        let bedPickerViewHeight: CGFloat = 217
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.height - 44.0 + 216.0, width: UIScreen.main.bounds.width, height: 44.35)
        let bottomView = UIView()
        bottomView.frame = CGRect(x: 0.0, y: 44.00, width: UIScreen.main.bounds.width, height: 0.35)
        bottomView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
        toolbar.addSubview(bottomView)
//        toolbar.sizeToFit()
//        toolbar.backgroundColor = AppColors.themeGray20
        toolbar.layer.borderColor = AppColors.themeBlack.withAlphaComponent(0.3).cgColor
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: LocalizedString.Done.localized, style: .plain, target: self, action: #selector(doneBedPicker))
        let greenAttribute = [NSAttributedString.Key.font: AppFonts.SemiBold.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeGreen] as [NSAttributedString.Key : Any]
        doneButton.setTitleTextAttributes(greenAttribute , for: .normal)
        toolbar.setItems([spaceButton,doneButton], animated: true)
        self.bedPickerView.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.height - bedPickerViewHeight, width: UIScreen.main.bounds.width , height: bedPickerViewHeight)
        self.bedPickerView.delegate = self
        self.bedPickerView.dataSource = self
        self.bedPickerView.backgroundColor = AppColors.themeWhite
        self.dropDownTextField.inputAccessoryView = toolbar
        self.dropDownTextField.inputView = self.bedPickerView
    }
    
    ///Configure BedSelection Title ImgSetUp
    private func bedSelectionTitleImgSetUp() {
        let dropDownButton = UIButton(type: .custom)
        dropDownButton.frame = CGRect(x: 0, y: 0, width: 20.0, height: 20.0)
        dropDownButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 0.0, bottom: 0.0, right: 0.0)
        dropDownButton.setImage(#imageLiteral(resourceName: "downArrow").withRenderingMode(.alwaysTemplate), for: .normal)
        dropDownButton.imageView?.tintColor = AppColors.themeGreen
        self.dropDownTextField.rightView = dropDownButton
        self.dropDownTextField.rightViewMode = .always
    }
    
    ///Config Cell
    internal func configCell(numberOfRooms: Int , roomData: RoomsRates , isOnlyOneRoom: Bool ) {
        if isOnlyOneRoom {
            self.bedTypeLabel.text = roomData.name + " " + roomData.desc
            self.bedDiscriptionLabel.text = roomData.desc
            self.bedDiscriptionLabel.font = AppFonts.Regular.withSize(14.0)
            self.bedTypeLabel.font = AppFonts.SemiBold.withSize(18.0)
            self.deviderView.isHidden = false
        } else {
            self.bedTypeLabel.text = "No. of rooms : \(numberOfRooms)"
            self.bedDiscriptionLabel.font = AppFonts.SemiBold.withSize(18.0)
            self.bedTypeLabel.font = AppFonts.SemiBold.withSize(14.0)
            self.bedDiscriptionLabel.text = roomData.name + " " + roomData.desc
            self.deviderView.isHidden = true
        }        
        if let roomBedsTypes = roomData.roomBedTypes {
            for bedType in roomBedsTypes {
                self.typesOfBed.append(bedType.type + "  ")
            }
        }
        if self.typesOfBed.isEmpty || (self.typesOfBed.count == 1) {
            self.dropDownTextField.isHidden = true
        } else {
            self.dropDownTextField.isHidden = false
            self.dropDownTextField.text = self.typesOfBed[0] + "   "
        }
    }
    
    //Mark:- IBActions
    //================
    @IBAction func bookmarkButtonAction(_ sender: UIButton) {
    }
    
    @objc func doneBedPicker(){
        self.endEditing(true)
    }
}

//Mark:- UIPickerView Delegate And DataSource
//===========================================
extension HotelDetailsBedsTableViewCell: UIPickerViewDelegate , UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.typesOfBed.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textColor = AppColors.themeBlack
            pickerLabel?.font = AppFonts.Regular.withSize(23.0)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = self.typesOfBed[row]
        pickerLabel?.textColor = AppColors.textFieldTextColor51
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.dropDownTextField.text = self.typesOfBed[row]
    }
}


/*
 if self.typesOfBed.isEmpty || (self.typesOfBed.count == 1) {
 self.dropDownTextField.isHidden = true
 } else {
 self.dropDownTextField.isHidden = false
 //            if self.typesOfBed.count == 1 {
 //                self.dropDownTextField.rightViewMode = .never
 //                self.dropDownTextField.isUserInteractionEnabled = false
 //            } else {
 //                self.dropDownTextField.rightViewMode = .always
 //                self.dropDownTextField.isUserInteractionEnabled = true
 //            }
 self.dropDownTextField.text = self.typesOfBed[0] + "   "
 }
 */
