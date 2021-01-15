//
//  UpdateAccountDetailsVC.swift
//  AERTRIP
//
//  Created by Appinventiv  on 12/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

protocol GetUpdatedAccountDetailsBack : NSObjectProtocol {
    
    func updatedDetails(details : UserAccountDetail)
    
}

class UpdateAccountDetailsVC: BaseVC {
    @IBOutlet weak var navView: TopNavigationView!
    @IBOutlet weak var accountTableView: ATTableView!
    
    var viewModel = UpdateAccountDetailsVM()
    weak var delegate : GetUpdatedAccountDetailsBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.accountTableView.backgroundColor = AppColors.themeGray04
        self.accountTableView.rowHeight = UITableView.automaticDimension
        self.accountTableView.estimatedRowHeight = 50
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
        self.viewModel.delegate = self
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
        setInitialValues()
    }
    
    func manageLoader(isNeeded: Bool){
        self.navView.isToShowIndicatorView = isNeeded
        self.navView.firstRightButton.isHidden = isNeeded
        if isNeeded{
            self.navView.activityIndicatorView.startAnimating()
        }else{
            self.navView.activityIndicatorView.stopAnimating()
        }
        
    }
    
    
    func setInitialValues(){
        
        switch self.viewModel.updationType {
        case .pan:
            self.viewModel.updateValue = self.viewModel.details.pan
            
        case .billingName :
            
            self.viewModel.updateValue = self.viewModel.details.billingName

        case .aadhar:
            
            self.viewModel.updateValue = self.viewModel.details.aadhar
            
        case .gSTIN:
            
            self.viewModel.updateValue = self.viewModel.details.gst
            
        case .defaultRefundMode:
            
            self.viewModel.setSelectedMode(selectedVal: self.viewModel.details.refundMode)

        case .billingAddress:
            self.viewModel.updateValue = self.viewModel.details.billingAddress.label

        }
        
        self.accountTableView.reloadData()
        
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
                cell.updateTextField.text = self.viewModel.updateValue
                cell.addressView.isHidden = self.viewModel.updationType != .billingAddress
                cell.addressLabel.text = self.viewModel.details.billingAddressString
                
                return cell
                
                
          
            case .billingName, .aadhar, .pan, .gSTIN:
                guard  let cell = self.accountTableView.dequeueReusableCell(withIdentifier: UpdateAccountTextFieldCell.reusableIdentifier) as? UpdateAccountTextFieldCell else {
                    fatalError("UpdateAccountTextFieldCell not found.")
                }
                cell.setPlaceHolderAndDelegate(with: self.viewModel.updationType.rawValue, textFieldDelegate: self, isForAadhar: (self.viewModel.updationType == .aadhar))
                cell.updateTextField.text = self.viewModel.updateValue
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
        
        let validate = self.viewModel.isValidDetails(with: self.viewModel.updateValue)
        
        switch self.viewModel.updationType{
        case .aadhar, .billingName, .gSTIN, .pan:
 
            if validate.success{
                self.manageLoader(isNeeded: true)
                self.viewModel.updateAccountDetails(self.viewModel.updateValue)
            }else{
                AppToast.default.showToastMessage(message: validate.msg)
            }
            
        case .defaultRefundMode:
        
            if validate.success{
                self.manageLoader(isNeeded: true)
                self.viewModel.updateRefundModes()
            }else{
                AppToast.default.showToastMessage(message: validate.msg)
            }
            
            
        case .billingAddress:
            
            if validate.success{
                self.manageLoader(isNeeded: true)
                self.viewModel.updateAccountDetails("\(self.viewModel.details.billingAddress.id)")
            }else{
                AppToast.default.showToastMessage(message: validate.msg)
            }
            
        break;
        }
    }
    
}

extension UpdateAccountDetailsVC: UpdateAccountDetailsVMDelegates{
    func updateAccountDetailsSuccess() {
        self.manageLoader(isNeeded: false)
        self.delegate?.updatedDetails(details: self.viewModel.details)
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateAccountDetailsFailure(errorCode: ErrorCodes) {
        self.manageLoader(isNeeded: false)
        AppGlobals.shared.showErrorOnToastView(withErrors: errorCode, fromModule: .profile)
    }
    
    
}

//MARK: UITextField Delegates

extension UpdateAccountDetailsVC{

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch self.viewModel.updationType{
        case .billingAddress:
            textField.tintColor = AppColors.clear

            PKMultiPicker.noOfComponent = 1
            let selectionArray = self.viewModel.details.addresses.map { $0.label }
            
            PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: selectionArray, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen, doneBlock: {_,_ in }) { [weak self] (index1, index2) in
                
                guard let ind = index1, let weakSelf = self else { return }
        
                textField.text = selectionArray[ind]
                weakSelf.viewModel.updateValue = selectionArray[ind]
                weakSelf.viewModel.details.billingAddress = weakSelf.viewModel.details.addresses[ind]
                
                guard let cell = weakSelf.accountTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? UpdateAccountDropdownCell else { return }
                cell.addressLabel.text = weakSelf.viewModel.details.billingAddressString
                
            }
            
        case .defaultRefundMode:
            PKMultiPicker.noOfComponent = 1
            let selectionArray = self.viewModel.paymentOptions
            PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: selectionArray, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { [weak self] (firstSelect, secondSelect) in
                textField.text = firstSelect

                self?.viewModel.setSelectedMode(selectedVal: firstSelect)
                
            }
            textField.tintColor = AppColors.clear
            
            

        case .aadhar, .billingName,.gSTIN,.pan: return true
            
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.updateValue = (textField.text ?? "").removeLeadingTrailingWhitespaces
        self.accountTableView.reloadData()

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
