//
//  AccountOfflineDepositVC+DelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 01/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit


//MARK: - UITableViewDataSource and UITableViewDelegate
extension AccountOfflineDepositVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 12 : (self.viewModel.uploadedDocs.count + 2)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                //deposit amoutn cell
                return 92.0
                
            case 1, 4:
                //blank gap
                return 35.0
                
            case 2, 5, 6, 7, 8, 9, 10:
                //select bank name and all other data colletion cells
                return 60.0
                
            case 3:
                //see bank details
                return 44.0
                
            case 11:
                //additional note
                return 100.0
                
            default:
                return 0.0
            }
        }
        else {
            
            if indexPath.row < self.viewModel.uploadedDocs.count {
                //uploaded document type
                return 55.0
            }
            else {
                let newIndex = indexPath.row - self.viewModel.uploadedDocs.count
                if newIndex == 0 {
                    //uploaded deposit slip
                    return 78.0
                }
                else if newIndex == 1 {
                    //terms of use
                    return 110.0
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
                
            case 1, 4:
                //blank gap
                return self.getBlankCell()
                
            case 2:
                //select bank name
                return self.getTextEditableTableViewCell(title: LocalizedString.AertripBankName.localized, value: self.viewModel.userEnteredDetails.aertripBank, placeholder: LocalizedString.SelectBank.localized, isDivider: true)
                
            case 3:
                //see bank details
                return self.getSeeBankDetailsCell()
                
            case 5:
                //deposit date
                if self.currentUsingAs == .chequeOrDD {
                    return self.getTextEditableTableViewCell(title: LocalizedString.DraftOrChequeDepositDate.localized, value: self.viewModel.userEnteredDetails.depositDateStr, placeholder: LocalizedString.SelectDate.localized, isDivider: true)
                }
                else {
                    return self.getTextEditableTableViewCell(title: LocalizedString.DepositDate.localized, value: self.viewModel.userEnteredDetails.depositDateStr, placeholder: LocalizedString.SelectDate.localized, isDivider: true)
                }
                
            case 6:
                if self.currentUsingAs == .chequeOrDD {
                    //chaque/dd numer
                    return self.getFloatableTextFieldCell(value: self.viewModel.userEnteredDetails.ddNum, placeholder: LocalizedString.EnterDraftOrChequeNumber.localized, isDivider: true)
                }
                else {
                    //transfer type
                    return self.getTextEditableTableViewCell(title: LocalizedString.TransferType.localized, value: self.viewModel.userEnteredDetails.transferType, placeholder: "\(LocalizedString.Select.localized) \(LocalizedString.TransferType.localized.lowercased())", isDivider: true)
                }
                
            case 7:
                if self.currentUsingAs == .chequeOrDD {
                    //branch details
                    return self.getFloatableTextFieldCell(value: self.viewModel.userEnteredDetails.depositBranchDetail, placeholder: LocalizedString.DepositBranchDetails.localized, isDivider: true)
                }
                else {
                    //UTR Code
                    return self.getFloatableTextFieldCell(value: self.viewModel.userEnteredDetails.utrCode, placeholder: LocalizedString.EnterUTRSwiftCode.localized, isDivider: true)
                }
                
            case 8:
                //your bank
                return self.getTextEditableTableViewCell(title: LocalizedString.YourBank.localized, value: self.viewModel.userEnteredDetails.userBank, placeholder: LocalizedString.SelectBank.localized, isDivider: true)
                
            case 9:
                //your account name
                return self.getFloatableTextFieldCell(value: self.viewModel.userEnteredDetails.userAccountName, placeholder: LocalizedString.EnterAccountName.localized, isDivider: true)
                
            case 10:
                //your account number
                return self.getFloatableTextFieldCell(value: self.viewModel.userEnteredDetails.userAccountNum, placeholder: LocalizedString.EnterAccountNumber.localized, isDivider: true)
                
            case 11:
                //additional note
                return self.getTextViewCell(title: LocalizedString.AdditionalNote.localized, value: self.viewModel.userEnteredDetails.additionalNote, placeholder: "(\(LocalizedString.Optional.localized))", isDivider: true)
                
            default:
                return UITableViewCell()
            }
        }
        else {
            
            if indexPath.row < self.viewModel.uploadedDocs.count {
                //uploaded document type
                return self.getFileCell(title: self.viewModel.uploadedDocs[indexPath.row], size: "230.05 KB")
            }
            else {
                let newIndex = indexPath.row - self.viewModel.uploadedDocs.count
                if newIndex == 0 {
                    //uploaded deposit slip
                    return self.getUploadSlipCell()
                }
                else if newIndex == 1 {
                    //terms of use
                    return self.getAgreeTermsCell()
                }
            }
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 3 {
            //see bank details
            AppFlowManager.default.presentAertripBankDetailsVC()
        }
        else if indexPath.section == 1 {
            let newIndex = indexPath.row - self.viewModel.uploadedDocs.count
            if newIndex == 0 {
                //add new slip
                if !self.viewModel.uploadedDocs.contains("slip.pdf") {
                    self.viewModel.uploadedDocs.append("slip.pdf")
                }
                else if !self.viewModel.uploadedDocs.contains("slip.jpg") {
                    self.viewModel.uploadedDocs.append("slip.jpg")
                }
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
        
        cell.iconImageView.image = title.hasSuffix("pdf") ? #imageLiteral(resourceName: "ic_file_pdf") : #imageLiteral(resourceName: "ic_file_img")
        cell.deleteButton.addTarget(self, action: #selector(self.fileDeleteButtonAction(_:)), for: .touchUpInside)

        return cell
    }
    
    func getDepositAmountCell() -> UITableViewCell {
        guard let depositCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: AccountDepositAmountCell.reusableIdentifier) as? AccountDepositAmountCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        
        return depositCell
    }
    
    func getBlankCell() -> UITableViewCell {
        //blank gap
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier) as? EmptyTableViewCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
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
        
        cell.isHiddenButton = false
        cell.titleLabel.font = AppFonts.Regular.withSize(18.0)
        cell.titleLabel.textColor = AppColors.themeTextColor
        cell.titleLabel.text = LocalizedString.OffileDepositTerms.localized
        cell.selectionButton.setImage(self.viewModel.userEnteredDetails.isAgreeToTerms ? #imageLiteral(resourceName: "tick") : #imageLiteral(resourceName: "untick"), for: .normal)
        cell.selectButtonTopConstraint.constant = 26.0
        
        return cell
    }

    
    func getTextEditableTableViewCell(title: String, value: String = "", placeholder: String, isDivider: Bool) -> UITableViewCell {
        //blank gap
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TextEditableTableViewCell.reusableIdentifier) as? TextEditableTableViewCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        
        cell.titleLabel.text = value.isEmpty ? title : value
        cell.editableTextField.text = placeholder
        cell.separatorView.isHidden = !isDivider

        return cell
    }
    
    func getFloatableTextFieldCell(value: String, placeholder: String, isDivider: Bool) -> UITableViewCell {
        //blank gap
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: HCEmailTextFieldCell.reusableIdentifier) as? HCEmailTextFieldCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        
        cell.textFieldTopConstraint.constant = 8.0
        cell.textFiledBottomConstraint.constant = 0.0
        cell.editableTextField.isHiddenBottomLine = true
        cell.editableTextField.text = value
        cell.editableTextField.placeholder = placeholder
        cell.separatorView.isHidden = !isDivider
        
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
        cell.addNoteTextView.placeholderInsets = .zero
        cell.sepratorView.isHidden = !isDivider
        
        return cell
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

extension AccountOfflineDepositVC: AccountOfflineDepositVMDelegate {
    
}
