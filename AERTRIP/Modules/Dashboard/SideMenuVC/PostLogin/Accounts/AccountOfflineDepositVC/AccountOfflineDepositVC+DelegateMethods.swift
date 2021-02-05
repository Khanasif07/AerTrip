//
//  AccountOfflineDepositVC+DelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 01/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import ActiveLabel
import SafariServices
import MobileCoreServices


//MARK: - UITableViewDataSource and UITableViewDelegate
extension AccountOfflineDepositVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 14 : (self.viewModel.userEnteredDetails.uploadedSlips.count + 3)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                //deposit amoutn cell
                return 92.0
                
            case 1, 4, 6:
                //blank gap
                return 35.0
                
            case 2, 5, 7, 8, 9, 10, 11, 12:
                //select bank name and all other data colletion cells
                return 60.0
                
            case 3:
                //see bank details
                return 44.0
                
            case 13:
                //additional note
                return (self.currentUsingAs == .chequeOrDD) ? 100.0 : 103.0
                
            default:
                return 0.0
            }
        }
        else {
            
            if indexPath.row < self.viewModel.userEnteredDetails.uploadedSlips.count {
                //uploaded document type
                return 61.0
            }
            else {
                let newIndex = indexPath.row - self.viewModel.userEnteredDetails.uploadedSlips.count
                if newIndex == 0 {
                    //uploaded deposit slip
                    return (self.currentUsingAs == .chequeOrDD) ? 78.0 : 81.0
                }
                else if newIndex == 1 {
                    //terms of use
                    return 85.0
                }else if newIndex == 2 {
                    //blank gap
                    return 35.0
                }
            }
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                //deposit amoutn cell
                return self.getDepositAmountCell()
                
            case 1, 4, 6:
                //blank gap
                return self.getBlankCell()
                
            case 2:
                //select bank name
                return self.getTextEditableTableViewCell(title: LocalizedString.AertripBankName.localized, value: self.viewModel.userEnteredDetails.aertripBank, placeholder: LocalizedString.SelectBank.localized, isDivider: true, isSelectionEnable: false)
                
            case 3:
                //see bank details
                return self.getSeeBankDetailsCell()
                
            case 5:
                //select bank name
                let selectedTitle = (self.currentUsingAs == .chequeOrDD) ? LocalizedString.ChequeDemandDraft.localized : LocalizedString.FundTransfer.localized
                return self.getTextEditableTableViewCell(title: LocalizedString.ModeOfPayment.localized, value: selectedTitle, placeholder: LocalizedString.ModeOfPayment.localized, isDivider: false, isSelectionEnable: false)
                
            case 7:
                //deposit date
                if self.currentUsingAs == .chequeOrDD {
                    return self.getTextEditableTableViewCell(title: LocalizedString.DraftOrChequeDepositDate.localized, value: self.viewModel.userEnteredDetails.depositDateStr, placeholder: LocalizedString.SelectDate.localized, isDivider: true, isSelectionEnable: false)
                }
                else {
                    return self.getTextEditableTableViewCell(title: LocalizedString.DepositDate.localized, value: self.viewModel.userEnteredDetails.depositDateStr, placeholder: LocalizedString.SelectDate.localized, isDivider: true, isSelectionEnable: false)
                }
                
            case 8:
                if self.currentUsingAs == .chequeOrDD {
                    //chaque/dd numer
                    return self.getFloatableTextFieldCell(value: self.viewModel.userEnteredDetails.ddNum, placeholder: LocalizedString.EnterDraftOrChequeNumber.localized, isDivider: true)
                }
                else {
                    //transfer type
                    return self.getTextEditableTableViewCell(title: LocalizedString.TransferType.localized, value: self.viewModel.userEnteredDetails.transferType, placeholder: "\(LocalizedString.Select.localized) \(LocalizedString.TransferType.localized.lowercased())", isDivider: true, isSelectionEnable: false)
                }
                
            case 9:
                if self.currentUsingAs == .chequeOrDD {
                    //branch details
                    return self.getFloatableTextFieldCell(value: self.viewModel.userEnteredDetails.depositBranchDetail, placeholder: LocalizedString.DepositBranchDetails.localized, isDivider: true)
                }
                else {
                    //UTR Code
                    return self.getFloatableTextFieldCell(value: self.viewModel.userEnteredDetails.utrCode, placeholder: LocalizedString.EnterUTRSwiftCode.localized, isDivider: true)
                }
                
            case 10:
                //your bank
                return self.getTextEditableTableViewCell(title: LocalizedString.YourBank.localized, value: self.viewModel.userEnteredDetails.userBank, placeholder: LocalizedString.SelectBank.localized, isDivider: true, isSelectionEnable: false)
                
            case 11:
                //your account name
                return self.getFloatableTextFieldCell(value: self.viewModel.userEnteredDetails.userAccountName, placeholder: LocalizedString.EnterAccountName.localized, isDivider: true)
                
            case 12:
                //your account number
                return self.getFloatableTextFieldCell(value: self.viewModel.userEnteredDetails.userAccountNum, placeholder: LocalizedString.EnterAccountNumber.localized, isDivider: true)
                
            case 13:
                //additional note
                return self.getTextViewCell(title: LocalizedString.AdditionalNote.localized, value: self.viewModel.userEnteredDetails.additionalNote, placeholder: "(\(LocalizedString.Optional.localized))", isDivider: true)
                
            default:
                return UITableViewCell()
            }
        }
        else {
            
            if indexPath.row < self.viewModel.userEnteredDetails.uploadedSlips.count {
                //uploaded document type
                let urlPath = self.viewModel.userEnteredDetails.uploadedSlips[indexPath.row]
                let title = urlPath.toUrl?.lastPathComponent ?? ""
                
                return self.getFileCell(title: title, size: urlPath.fileSizeWithUnit)
            }
            else {
                let newIndex = indexPath.row - self.viewModel.userEnteredDetails.uploadedSlips.count
                if newIndex == 0 {
                    //uploaded deposit slip
                    return self.getUploadSlipCell()
                }
                else if newIndex == 1 {
                    //terms of use
                    return self.getAgreeTermsCell()
                }else if newIndex == 2 {
                    //blank gap
                    return self.getBlankCell(isBottomDividerHidden: true)
                }
            }
            return UITableViewCell()
        }
    }
    
    func makeFileSelection() {
        let titles = [LocalizedString.Camera.localized, LocalizedString.PhotoLibrary.localized, LocalizedString.Document.localized]
        let ttlClrs = Array(repeating: AppColors.themeDarkGreen, count: titles.count)
        
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: titles, colors: ttlClrs)
        
        _ = PKAlertController.default.presentActionSheet(nil, message: LocalizedString.ChooseOptionToSelect.localized, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] (_, index) in
            guard let strongSelf = self else {return}
            if index == 0 {
                //Camera
                strongSelf.checkAndOpenCamera(delegate: strongSelf)
            }
            else if index == 1 {
                //PhotoLibrary
                strongSelf.checkAndOpenLibrary(delegate: strongSelf)
            }
            else {
                //Document
                strongSelf.openDocumentPicker()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 3 {
            //see bank details
            
            let index = self.selectedBankIndex() ?? 0
            AppFlowManager.default.presentAertripBankDetailsVC(bankDetails: self.viewModel.paymentModeDetails?.types ?? [], currentIndex: index)
        }
        else if indexPath.section == 1 {
            let newIndex = indexPath.row - self.viewModel.userEnteredDetails.uploadedSlips.count
            if newIndex == 0 {
                //add new slip
                self.makeFileSelection()
            }
            else if newIndex == 1 {
                self.viewModel.userEnteredDetails.isAgreeToTerms = !self.viewModel.userEnteredDetails.isAgreeToTerms
            }
            self.checkOutTableView.reloadData()
        }
    }
    
    func getFileCell(title: String, size: String) -> UITableViewCell {
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: OfflineDepositeSlipUoloadCell.reusableIdentifier) as? OfflineDepositeSlipUoloadCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        
        cell.fileNameLabel.text = title
        cell.fileSizeLabel.text = size
        
        cell.iconImageView.image = title.fileIcon
        cell.deleteButton.addTarget(self, action: #selector(self.fileDeleteButtonAction(_:)), for: .touchUpInside)
        cell.imageCenterYConstraint.constant = 4.0
        
        return cell
    }
    
    func getDepositAmountCell() -> UITableViewCell {
        guard let depositCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: AccountDepositAmountCell.reusableIdentifier) as? AccountDepositAmountCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        
        //depositCell.amountTextField.delegate = self
        depositCell.amountTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        depositCell.amount = self.viewModel.userEnteredDetails.depositAmount
        depositCell.delegate = self
        depositCell.usingFor = .offlineDeposite
        if self.currentUsingFor == .addOns{
            depositCell.amountTextField.backgroundColor = AppColors.clear
            depositCell.isUserInteractionEnabled = false
        }
        depositCell.topDividerView.isHidden = false
        return depositCell
    }
    
    func getBlankCell(isBottomDividerHidden: Bool = false) -> UITableViewCell {
        //blank gap
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier) as? EmptyTableViewCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        cell.bottomDividerView.isHidden = isBottomDividerHidden
        cell.clipsToBounds = true
        
        return cell
    }
    
    func getSeeBankDetailsCell() -> UITableViewCell {
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: OfflineDepositeTextImageCell.reusableIdentifier) as? OfflineDepositeTextImageCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        
        cell.isHiddenButton = true
        cell.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        cell.titleLabel.textColor = AppColors.themeGreen
        cell.titleLabel.text = LocalizedString.SeeBankDetails.localized
        cell.dividerView.isHidden = true
        cell.selectButtonTopConstraint.constant = 0.0
        
        return cell
    }
    
    func getUploadSlipCell() -> UITableViewCell {
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: OfflineDepositeTextImageCell.reusableIdentifier) as? OfflineDepositeTextImageCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        
        cell.isHiddenButton = false
//        cell.containerTopConstraint.constant = 8.0
        cell.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        cell.titleLabel.textColor = AppColors.themeGreen
        cell.titleLabel.text = LocalizedString.UploadDepositConfirmationSlip.localized
        cell.selectionButton.setImage(#imageLiteral(resourceName: "ic_upload_slip"), for: .normal)
        cell.selectButtonTopConstraint.constant = 30.0
        
        return cell
    }
    
    func getAgreeTermsCell() -> UITableViewCell {
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: OfflineDepositeTextImageCell.reusableIdentifier) as? OfflineDepositeTextImageCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        cell.dividerView.isHidden = true
        cell.isHiddenButton = false
        cell.selectionButton.setImage(self.viewModel.userEnteredDetails.isAgreeToTerms ? #imageLiteral(resourceName: "CheckedGreenRadioButton") : #imageLiteral(resourceName: "UncheckedGreenRadioButton"), for: .normal)
        cell.selectButtonTopConstraint.constant = 26.0
        let termsOfUse = ActiveType.custom(pattern: "\\s\(LocalizedString.terms_of_use.localized)\\b")
        
        let allTypes = [termsOfUse]
        cell.titleLabel.enabledTypes = allTypes
        cell.titleLabel.customize { label in
            label.font = AppFonts.Regular.withSize(18.0)
            label.text = LocalizedString.OffileDepositTerms.localized
            label.textColor = AppColors.themeBlack
            
            for item in allTypes {
                label.customColor[item] = AppColors.themeGreen
                label.customSelectedColor[item] = AppColors.themeGreen
            }
            
            label.highlightFontName = AppFonts.SemiBold.rawValue
            label.highlightFontSize = 18.0
            
            label.handleCustomTap(for: termsOfUse) { _ in
                
                guard let url = URL(string: AppKeys.termsOfUse) else { return }
//                let safariVC = SFSafariViewController(url: url)
//                AppFlowManager.default.mainNavigationController.present(safariVC, animated: true, completion: nil)
//                safariVC.delegate = self
                AppFlowManager.default.showURLOnATWebView(url, screenTitle: LocalizedString.terms_of_use.localized)
            }
        }
        return cell
    }
    
    
    func getTextEditableTableViewCell(title: String, value: String = "", placeholder: String, isDivider: Bool, isSelectionEnable: Bool = true) -> UITableViewCell {
        //blank gap
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TextEditableTableViewCell.reusableIdentifier) as? TextEditableTableViewCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        cell.titleLabel.font = AppFonts.Regular.withSize(14.0)
        cell.titleLabel.textColor = AppColors.themeGray40
        cell.titleLabel.text = title
        cell.editableTextField.text = value.isEmpty ? placeholder : value
        cell.editableTextField.placeholder = ""
        cell.editableTextField.isHiddenBottomLine = true
        cell.editableTextField.isSelectionOptionEnabled = isSelectionEnable
        
        cell.separatorView.isHidden = !isDivider
        cell.editableTextField.delegate = self
        cell.editableTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        return cell
    }
    
    func getFloatableTextFieldCell(value: String, placeholder: String, isDivider: Bool) -> UITableViewCell {
        //blank gap
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: HCEmailTextFieldCell.reusableIdentifier) as? HCEmailTextFieldCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        
        cell.editableTextField.titleFont = AppFonts.Regular.withSize(14)
        cell.textFieldTopConstraint.constant = 8.0
        cell.textFiledBottomConstraint.constant = 0.0
        cell.editableTextField.titleYPadding = 0
        cell.editableTextField.hintYPadding = -8
        cell.editableTextField.isHiddenBottomLine = true
        cell.editableTextField.text = value//symbol
        cell.editableTextField.setUpAttributedPlaceholder(placeholderString: placeholder, with: "")
        cell.separatorView.isHidden = !isDivider
        cell.editableTextField.delegate = self
        cell.editableTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        
        return cell
    }
    
    func getTextViewCell(title: String, value: String = "", placeholder: String, isDivider: Bool) -> UITableViewCell {
        //blank gap
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: AddNotesTableViewCell.reusableIdentifier) as? AddNotesTableViewCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        
        cell.titleLabel.text = title
        cell.addNoteTextView.text = value
        cell.addNoteTextView.placeholder = placeholder
        cell.addNoteTextView.textColor = AppColors.themeBlack
        //cell.addNoteTextView.placeholderInsets = .zero
        cell.sepratorView.isHidden = !isDivider
        cell.addNoteTextView.delegate = self
        //cell.addNoteTextView.textContainerInset = .zero
        
        return cell
    }
}

extension AccountOfflineDepositVC: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        AppFlowManager.default.mainNavigationController.dismiss(animated: true, completion: nil)
    }
    
    func selectedBankIndex()-> Int?{
        let index = self.viewModel.paymentModeDetails?.allBanksName.firstIndex(of: self.viewModel.userEnteredDetails.aertripBank)
        return index
    }
    
}


//MARK:- Image picker controller delegate methods
//MARK:-
extension AccountOfflineDepositVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage, let imgData = selectedImage.pngData() else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let urlPath = AppGlobals.shared.saveImage(data: imgData, fileNameWithExtension: "slip.jpeg")
        
        self.viewModel.userEnteredDetails.addSlip(urlPath: urlPath)
        
        picker.dismiss(animated: true) {
            self.checkOutTableView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK:- TopNavigationView Delegate methods
extension AccountOfflineDepositVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        AppFlowManager.default.presentAccountChargeInfoVC(usingFor: .offlinePaymentSteps)
    }
}

extension AccountOfflineDepositVC {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let indexPath = self.checkOutTableView.indexPath(forItem: textField) {
            if indexPath.section == 0 {
                switch indexPath.row {
                    
                case 2:
                    //select bank name
                    PKMultiPicker.noOfComponent = 1
                    PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: self.viewModel.paymentModeDetails?.allBanksName ?? [], secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { [unowned self] (firstSelect, secondSelect) in
                        textField.text = firstSelect
                        self.viewModel.userEnteredDetails.aertripBank = firstSelect
                    }
                    textField.tintColor = AppColors.clear
                                        
                    case 5:
                    //select mode of payment
                    PKMultiPicker.noOfComponent = 1
                    PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: [LocalizedString.FundTransfer.localized, LocalizedString.ChequeDemandDraft.localized], secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { [unowned self] (firstSelect, secondSelect) in
                        textField.text = firstSelect
                        if firstSelect == LocalizedString.ChequeDemandDraft.localized {
                            self.currentUsingAs = .chequeOrDD
                        } else {
                            self.currentUsingAs = .fundTransfer
                        }
                        
                    }
                    textField.tintColor = AppColors.clear
                    
                case 7:
                    //deposit date
                    let selected = (textField.text ?? "").toDate(dateFormat: "dd-MM-yyyy")
                    PKDatePicker.openDatePickerIn(textField, outPutFormate: "dd-MM-yyyy", mode: .date, minimumDate: nil, maximumDate: Date(), selectedDate: selected, appearance: .light, toolBarTint: AppColors.themeGreen) { [unowned self] (dateStr) in
                        textField.text = dateStr
                        self.viewModel.userEnteredDetails.depositDate = dateStr.toDate(dateFormat: "dd-MM-yyyy")
                    }
                    textField.tintColor = AppColors.clear
                case 8:
                    
                    if self.currentUsingAs == .fundTransfer {
                        var pickerValue = ["Same Bank Transfer", "NEFT", "IMPS"]
                        if self.viewModel.userEnteredDetails.depositAmount >= 200000{
                            pickerValue.append("RTGS")
                        }
                        //transfer type
                        PKMultiPicker.noOfComponent = 1
                        PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: pickerValue, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { [unowned self] (firstSelect, secondSelect) in
                            textField.text = firstSelect
                            self.viewModel.userEnteredDetails.transferType = firstSelect
                        }
                        textField.tintColor = AppColors.clear
                    }
                    
                case 10:
                    //select your bank name
                    PKMultiPicker.noOfComponent = 1
                    PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: self.viewModel.bankMaster, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { [unowned self] (firstSelect, secondSelect) in
                        textField.text = firstSelect
                        self.viewModel.userEnteredDetails.userBank = firstSelect
                    }
                    textField.tintColor = AppColors.clear
                default:
                    printDebug("")
                    return true
                }
            }
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let indexPath = self.checkOutTableView.indexPath(forItem: textField) {
            if indexPath.section == 0 {
                
                switch indexPath.row {
                case 0:
                    //deposit amoutn cell
                    self.viewModel.userEnteredDetails.depositAmount = (textField.text ?? "").removeAllWhitespaces.toDouble ?? 0.0
                    
                case 8:
                    if self.currentUsingAs == .chequeOrDD {
                        //chaque/dd numer
                        self.viewModel.userEnteredDetails.ddNum = (textField.text ?? "").removeAllWhitespaces
                    }
                    
                case 9:
                    if self.currentUsingAs == .chequeOrDD {
                        //branch details
                        self.viewModel.userEnteredDetails.depositBranchDetail = (textField.text ?? "").removeAllWhitespaces
                    }
                    else {
                        //UTR Code
                        self.viewModel.userEnteredDetails.utrCode = (textField.text ?? "").removeAllWhitespaces
                    }
                    
                case 11:
                    //your account name
                    self.viewModel.userEnteredDetails.userAccountName = (textField.text ?? "").removeAllWhitespaces
                    
                case 12:
                    //your account number
                    self.viewModel.userEnteredDetails.userAccountNum = (textField.text ?? "").removeAllWhitespaces
                    
                default:
                    printDebug("")
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let indexPath = self.checkOutTableView.indexPath(forItem: textView) {
            if indexPath.section == 0, indexPath.row == 13 {
                //additional note
                self.viewModel.userEnteredDetails.additionalNote = (textView.text ?? "").removeAllWhitespaces
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let indexPath = self.checkOutTableView.indexPath(forItem: textField) {
            if indexPath.section == 0 && indexPath.row == 5 {
                self.checkOutTableView.reloadData()
            }
        }
    }
    
}

extension AccountOfflineDepositVC: AccountDepositAmountCellDelegate {
    func amountDidChanged(amount: Double, amountString: String) {
        self.viewModel.userEnteredDetails.depositAmount = amount
        if self.viewModel.userEnteredDetails.depositAmount < 200000, self.viewModel.userEnteredDetails.transferType == "RTGS"{
            self.viewModel.userEnteredDetails.transferType = ""
            self.checkOutTableView.reloadData()
        }
    }
}

extension AccountOfflineDepositVC: AccountOfflineDepositVMDelegate {
    func willRegisterPayment() {
        self.manageLoader(shouldStart: true)
    }
    
    func registerPaymentSuccess() {
        self.manageLoader(shouldStart: false)
        self.showPaymentSuccessMessage()
    }
    
    func registerPaymentFail() {
        self.manageLoader(shouldStart: false)
    }
}


extension AccountOfflineDepositVC: UIDocumentPickerDelegate {
    func openDocumentPicker() {
        let types: [String] = [kUTTypePDF as String]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // you get from the urls parameter the urls from the files selected
        if let url = urls.first {
            let urlPath = AppGlobals.shared.saveFileToDocument(fromUrl: url)
            self.viewModel.userEnteredDetails.addSlip(urlPath: urlPath)
            self.checkOutTableView.reloadData()
        }
    }
}
