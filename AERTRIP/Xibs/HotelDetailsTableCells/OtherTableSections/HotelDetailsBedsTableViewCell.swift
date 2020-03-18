//
//  HotelDetailsBedsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 13/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelDetailsBedsTableViewCellDelegate: class {
    func bookMarkButtonAction(sender: HotelDetailsBedsTableViewCell)
}

class HotelDetailsBedsTableViewCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    private var typesOfBed = [String]()
    private var bedPickerView = UIPickerView()
    private var selectedRow: Int?
    weak var delegate: HotelDetailsBedsTableViewCellDelegate? = nil
    var genericPickerView: UIView = UIView()
    let pickerSize: CGSize = UIPickerView.pickerSize
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bedTypeLabel: UILabel!
    @IBOutlet weak var bedDiscriptionLabel: UILabel!
    @IBOutlet weak var bookmarkButtonOutlet: UIButton!
    @IBOutlet weak var bedsLabel: UILabel!
    @IBOutlet weak var deviderView: ATDividerView!
    @IBOutlet weak var dividerViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var dropDownTextField: UITextField! {
        didSet {
            self.dropDownTextField.delegate = self
            self.dropDownTextField.tintColor = .clear
        }
    }
    @IBOutlet weak var dropDownStackView: UIStackView!
    
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
        self.shadowView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.5, shadowRadius: 6.0)

//        self.shadowView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize(width: 0.0, height: 5.0), opacity: 0.7, shadowRadius: 5.0)
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        self.bedTypeLabel.textColor = AppColors.themeBlack
        self.bedDiscriptionLabel.textColor = AppColors.themeBlack
        self.bedsLabel.textColor = AppColors.themeBlack
        self.dropDownTextField.textColor = AppColors.themeGreen
        //Size
        self.bedTypeLabel.font = AppFonts.SemiBold.withSize(14.0)
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
        toolbar.layer.borderColor = AppColors.themeBlack.withAlphaComponent(0.3).cgColor
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: LocalizedString.Done.localized, style: .plain, target: self, action: #selector(doneBedPicker))
        let greenAttribute = [NSAttributedString.Key.font: AppFonts.SemiBold.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeGreen] as [NSAttributedString.Key : Any]
        doneButton.setTitleTextAttributes(greenAttribute , for: .normal)
        toolbar.setItems([spaceButton,doneButton], animated: true)
        toolbar.backgroundColor = .clear
        toolbar.barTintColor = AppColors.secondarySystemFillColor
        self.bedPickerView.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.height - bedPickerViewHeight, width: UIScreen.main.bounds.width , height: bedPickerViewHeight)
        self.bedPickerView.frame = CGRect(x: 0, y: 0, width: pickerSize.width, height: pickerSize.height)
        genericPickerView.addSubview(self.bedPickerView)
        genericPickerView.frame = CGRect(x: 0, y: 0, width: pickerSize.width, height: pickerSize.height)
        self.genericPickerView.addBlurEffect(backgroundColor: AppColors.quaternarySystemFillColor, style: .dark, alpha: 1.0)
        genericPickerView.backgroundColor = AppColors.quaternarySystemFillColor
        
        self.bedPickerView.delegate = self
        self.bedPickerView.dataSource = self
        self.bedPickerView.backgroundColor = AppColors.themeWhite
        self.dropDownTextField.inputAccessoryView = toolbar
        self.dropDownTextField.inputView = self.genericPickerView
    }
    
    ///Configure BedSelection Title ImgSetUp
    private func bedSelectionTitleImgSetUp() {
        let dropDownButton = UIButton(type: .custom)
        dropDownButton.frame = CGRect(x: 0, y: 0, width: 20.0, height: 20.0)
        dropDownButton.imageEdgeInsets = UIEdgeInsets(top: 1.0, left: 0.0, bottom: 0.0, right: 0.0)
        dropDownButton.setImage(#imageLiteral(resourceName: "downArrow").withRenderingMode(.alwaysTemplate), for: .normal)
        dropDownButton.imageView?.tintColor = AppColors.themeGreen
        self.dropDownTextField.rightView = dropDownButton
        self.dropDownTextField.rightViewMode = .always
    }
    
    ///Config Cell
    internal func configCell(numberOfRooms: Int , roomData: RoomsRates , isOnlyOneRoom: Bool ) {
        self.typesOfBed.removeAll()
        if isOnlyOneRoom {
            self.bedTypeLabel.text = roomData.name
            self.bedDiscriptionLabel.text = roomData.desc
            self.bedDiscriptionLabel.isHidden = roomData.desc.isEmpty
            self.dropDownStackView.isHidden = roomData.desc.isEmpty
            self.bedDiscriptionLabel.font = AppFonts.SemiBold.withSize(18.0)
            self.bedTypeLabel.font = AppFonts.SemiBold.withSize(18.0)
            self.deviderView.isHidden = false
        } else {
            self.bedTypeLabel.text = "No. of rooms : \(numberOfRooms)"
            self.bedDiscriptionLabel.font = AppFonts.SemiBold.withSize(18.0)
            self.bedTypeLabel.font = AppFonts.SemiBold.withSize(14.0)
            self.bedDiscriptionLabel.isHidden = false
            self.bedDiscriptionLabel.text = roomData.name + " " + roomData.desc
            self.deviderView.isHidden = true
        }
        if let roomBedsTypes = roomData.roomBedTypes {
            for bedType in roomBedsTypes {
                self.typesOfBed.append(bedType.type + "  ")
            }
        }
        if self.typesOfBed.isEmpty {
            self.dropDownStackView.isHidden = true
            self.dropDownTextField.isHidden = true
        } else {
            self.dropDownStackView.isHidden = false
            self.dropDownTextField.isHidden = false
            if self.typesOfBed.count == 1 {
                self.dropDownTextField.rightViewMode = .never
                self.dropDownTextField.isUserInteractionEnabled = false
                self.dropDownTextField.textColor = AppColors.themeBlack
            } else {
                self.dropDownTextField.rightViewMode = .always
                self.dropDownTextField.isUserInteractionEnabled = true
                self.dropDownTextField.textColor = AppColors.themeGreen
            }
            self.dropDownTextField.text = self.typesOfBed[0] + "   "
        }
    }
    
    internal func showHideSetUp(cornerRaduis: CGFloat, bookmarkBtnHidden: Bool, dividerViewHidden: Bool) {
        self.containerView.roundTopCorners(cornerRadius: cornerRaduis)
        self.bookmarkButtonOutlet.isHidden = bookmarkBtnHidden
        self.deviderView.isHidden = dividerViewHidden
    }
    
    //Mark:- IBActions
    //================
    @IBAction func bookmarkButtonAction(_ sender: UIButton) {
        self.delegate?.bookMarkButtonAction(sender: self)
    }
    
    @objc func doneBedPicker(){
        if let selectedRow = self.selectedRow {
            self.dropDownTextField.text = self.typesOfBed[selectedRow]
        }
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
        self.selectedRow = row
        self.dropDownTextField.text = self.typesOfBed[row]
    }
}

extension HotelDetailsBedsTableViewCell: UITextFieldDelegate {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        self.dropDownTextField.inputView = self.bedPickerView
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
