//
//  UpdateAccountDetailsVC.swift
//  AERTRIP
//
//  Created by Appinventiv  on 12/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

class UpdateAccountDetailsVC: BaseVC {
    @IBOutlet weak var navView: TopNavigationView!
    @IBOutlet weak var accountTableView: ATTableView!
    
    var viewModel = UpdateAccountDetailsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.accountTableView.backgroundColor = AppColors.themeGray04
        self.accountTableView.delegate = self
        self.accountTableView.dataSource = self
    }
    
    func registerCell(){
        self.accountTableView.registerCell(nibName: UpdateAccountDropdownCell.reusableIdentifier)
        self.accountTableView.registerCell(nibName: UpdateAccountTextFieldCell.reusableIdentifier)
        self.accountTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
    }
    
    override func setupNavBar() {
        super.setupNavBar()
        navView.delegate = self
        let title:String
        switch self.viewModel.updationType {
        case .billingName, .billingAddress, .defaultRefundMode:
            title = self.viewModel.updationType.rawValue
        case .aadhar: title = "Aadhar"
        case .pan: title = "PAN"
        case .gSTIN: title = "GSTIN"
        }
        navView.configureNavBar(title: title, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        navView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.DoneWithSpace.localized, selectedTitle: LocalizedString.DoneWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        navView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.CancelWithSpace.localized, selectedTitle: LocalizedString.CancelWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        navView.dividerView.isHidden = false
    }
    

}

//MARK: TableView Delegates and DataSource
extension UpdateAccountDetailsVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 0) ? 35 : UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            guard  let cell = self.accountTableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier) as? EmptyTableViewCell else {
                fatalError("EmptyTableViewCell not found.")
            }
            return cell
        }else{
            switch self.viewModel.updationType {
            case .billingAddress, .defaultRefundMode:
                guard  let cell = self.accountTableView.dequeueReusableCell(withIdentifier: UpdateAccountDropdownCell.reusableIdentifier) as? UpdateAccountDropdownCell else {
                    fatalError("UpdateAccountDropdownCell not found.")
                }
                cell.setPlaceHolderAndDelegate(with: self.viewModel.updationType.rawValue, textFieldDelegate: self)
                return cell
            case .billingName, .aadhar, .pan, .gSTIN:
                guard  let cell = self.accountTableView.dequeueReusableCell(withIdentifier: UpdateAccountTextFieldCell.reusableIdentifier) as? UpdateAccountTextFieldCell else {
                    fatalError("UpdateAccountTextFieldCell not found.")
                }
                cell.setPlaceHolderAndDelegate(with: self.viewModel.updationType.rawValue, textFieldDelegate: self, isForAadhar: (self.viewModel.updationType == .aadhar))
                return cell
            }
        }
    }
    
}

//MARK: Navigation Delegates
extension UpdateAccountDetailsVC:TopNavigationViewDelegate{
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navView.activityIndicatorView.startAnimating()
        switch self.viewModel.updationType{
        case .aadhar, .billingName, .gSTIN, .pan:
            let validate = self.viewModel.isValidDetails(with: self.viewModel.updateValue)
            if validate.success{
                self.viewModel.updateAccountDetails(self.viewModel.updateValue)
            }else{
                AppToast.default.showToastMessage(message: validate.msg)
            }
        case .billingAddress, .defaultRefundMode: break;
        }
    }
    
}

extension UpdateAccountDetailsVC: UpdateAccountDetailsVMDelegates{
    func updateAccountDetailsSuccess() {
        self.navView.activityIndicatorView.stopAnimating()
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateAccountDetailsFailure(errorCode: ErrorCodes) {
        self.navView.activityIndicatorView.stopAnimating()
        AppGlobals.shared.showErrorOnToastView(withErrors: errorCode, fromModule: .profile)
    }
    
    
}

//MARK: UITextField Delegates

extension UpdateAccountDetailsVC{
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch self.viewModel.updationType{
        case .billingAddress:
            PKMultiPicker.noOfComponent = 1
            let selectionArray = [String]()
            PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: selectionArray, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { [unowned self] (firstSelect, secondSelect) in
                textField.text = firstSelect
//                self.viewModel.userEnteredDetails.aertripBank = firstSelect
            }
            textField.tintColor = AppColors.clear
        case .defaultRefundMode:
            PKMultiPicker.noOfComponent = 1
            let selectionArray = [String]()
            PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: selectionArray, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { [unowned self] (firstSelect, secondSelect) in
                textField.text = firstSelect
//                self.viewModel.userEnteredDetails.aertripBank = firstSelect
            }
            textField.tintColor = AppColors.clear
        case .aadhar, .billingName,.gSTIN,.pan: return true
            
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.updateValue = textField.text ?? ""
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        
    }
    
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func getOnlyIntiger(_ str: String)->String{
        let newStr = str.lowercased()
        let okayChars = Set("1234567890")
        return newStr.filter {okayChars.contains($0) }
    }
}
