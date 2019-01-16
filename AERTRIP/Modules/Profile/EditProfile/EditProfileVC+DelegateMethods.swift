//
//  EditProfileVC+DelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 21/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UITableViewData Source and Delegate methods

extension EditProfileVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections[indexPath.section] == LocalizedString.Address, indexPath.row != self.viewModel.addresses.count {
            return 264.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case LocalizedString.EmailAddress:
            return self.viewModel.email.count + 1
        case LocalizedString.ContactNumber:
            return self.viewModel.mobile.count + 1
        case LocalizedString.SocialAccounts:
            return self.viewModel.social.count + 1
        case LocalizedString.Address:
            return self.viewModel.addresses.count + 1
        case LocalizedString.MoreInformation:
            return informations.count
        case LocalizedString.PassportDetails:
            return 3
        case LocalizedString.FlightPreferences:
            return self.ffExtraCount + self.viewModel.frequentFlyer.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case LocalizedString.EmailAddress:
            if indexPath.row == self.viewModel.email.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: addActionCellIdentifier, for: indexPath) as? TableViewAddActionCell else {
                    fatalError("TableViewAddActionCell not found")
                }
                
                cell.configureCell(LocalizedString.AddEmail.localized)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: editTwoPartCellIdentifier, for: indexPath) as? EditProfileTwoPartTableViewCell else {
                    fatalError("EditProfileTwoPartTableViewCell not found")
                }
                
                cell.editProfilTwoPartTableViewCelldelegate = self
                if indexPath.row == 0, !self.viewModel.isFromTravellerList {
                    cell.rightViewTextField.isEnabled = false
                    cell.deleteButton.isHidden = true
                    cell.leftView.isUserInteractionEnabled = false
                } else {
                    cell.rightViewTextField.delegate = self
                }
                cell.email = self.viewModel.email[indexPath.row]
                cell.social = nil
                cell.mobile = nil
                cell.indexPath = indexPath
                if indexPath.row + 1 == self.viewModel.email.count {
                    cell.leftSeparatorView.isHidden = true
                    cell.rightSeparatorView.isHidden = true
                } else {
                    cell.leftSeparatorView.isHidden = false
                    cell.rightSeparatorView.isHidden = false
                }
                return cell
            }
            
        case LocalizedString.ContactNumber:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: editThreePartCellIdentifier, for: indexPath) as? EditProfileThreePartTableViewCell else {
                fatalError("EditProfileThreePartTableViewCell not found")
            }
            cell.delegate = self
            if indexPath.row == self.viewModel.mobile.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: addActionCellIdentifier, for: indexPath) as? TableViewAddActionCell else {
                    fatalError("TableViewAddActionCell not found")
                }
                cell.configureCell(LocalizedString.AddContactNumber.localized)
                return cell
            } else {
                cell.configureCell(indexPath, self.viewModel.mobile[indexPath.row].isd, self.viewModel.mobile[indexPath.row].label, self.viewModel.mobile[indexPath.row].value)
                if indexPath.row + 1 == self.viewModel.mobile.count {
                    cell.leftSeparatorView.isHidden = true
                    cell.rightSeparatorView.isHidden = true
                } else {
                    cell.leftSeparatorView.isHidden = false
                    cell.rightSeparatorView.isHidden = false
                }
                return cell
            }
        case LocalizedString.SocialAccounts:
            if indexPath.row == self.viewModel.social.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: addActionCellIdentifier, for: indexPath) as? TableViewAddActionCell else {
                    fatalError("TableViewAddActionCell not found")
                }
                cell.configureCell(LocalizedString.AddSocialAccountId.localized)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: editTwoPartCellIdentifier, for: indexPath) as? EditProfileTwoPartTableViewCell else {
                    fatalError("EditProfileTwoPartTableViewCell not found")
                }
                cell.editProfilTwoPartTableViewCelldelegate = self
                cell.social = self.viewModel.social[indexPath.row]
                cell.indexPath = indexPath
                if indexPath.row + 1 == self.viewModel.social.count {
                    cell.leftSeparatorView.isHidden = true
                    cell.rightSeparatorView.isHidden = true
                } else {
                    cell.leftSeparatorView.isHidden = false
                    cell.rightSeparatorView.isHidden = false
                }
                return cell
            }
            
        case LocalizedString.PassportDetails:
            if indexPath.row == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: twoPartEditTableViewCellIdentifier, for: indexPath) as? TwoPartEditTableViewCell else { fatalError("TwoPartEditTableViewCell not found") }
                
                cell.delegate = self
                cell.issueDate = viewModel.passportIssueDate
                cell.expiryDate = viewModel.passportExpiryDate
                cell.ffData = nil
                cell.indexPath = indexPath
                
                return cell
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: textEditableCellIdentifier, for: indexPath) as? TextEditableTableViewCell else { fatalError("TextEditableTableViewCell not found") }
                cell.editableTextField.delegate = self
                cell.delegate = self
                if indexPath.row == 0 {
                    cell.editableTextField.isEnabled = true
                } else {
                    cell.editableTextField.isEnabled = false
                }
                cell.configureCell(indexPath, passportDetaitTitle[indexPath.row], passportDetails[indexPath.row])
                return cell
            }
            
        case LocalizedString.Address:
            
            if indexPath.row == self.viewModel.addresses.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: addActionCellIdentifier, for: indexPath) as? TableViewAddActionCell else {
                    fatalError("TableViewAddActionCell not found")
                }
                cell.configureCell(LocalizedString.AddAddress.localized)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: addAddressTableViewCellIdentifier, for: indexPath) as? AddAddressTableViewCell else {
                    fatalError("AddAddressTableViewCell not found")
                }
                cell.delegate = self
                cell.deleteButton.isHidden = indexPath.row == 0 ? true : false
                cell.configureCell(indexPath, addressType: self.viewModel.addresses[indexPath.row].label, addressLineOne: self.viewModel.addresses[indexPath.row].line1, addressLineTwo: self.viewModel.addresses[indexPath.row].line2, cityName: self.viewModel.addresses[indexPath.row].city, postalCode: self.viewModel.addresses[indexPath.row].postalCode, stateName: self.viewModel.addresses[indexPath.row].state, countryName: self.viewModel.addresses[indexPath.row].countryName)
                
                return cell
            }
            
        case LocalizedString.MoreInformation:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: textEditableCellIdentifier, for: indexPath) as? TextEditableTableViewCell else { fatalError("TextEditableTableViewCell not found") }
            
            cell.delegate = self
            if moreInformation[indexPath.row].rawValue == LocalizedString.Birthday.rawValue || moreInformation[indexPath.row].rawValue == LocalizedString.Anniversary.rawValue {
                cell.editableTextField.isEnabled = false
            } else {
                cell.editableTextField.isEnabled = true
            }
            cell.downArrowImageView.isHidden = true
            cell.configureCell(indexPath, moreInformation[indexPath.row].rawValue, informations[indexPath.row])
            cell.separatorView.isHidden = (indexPath.row + 1 == moreInformation.count) ? true : false
            return cell
            
        case LocalizedString.FlightPreferences:
            if indexPath.row >= 2 {
                if indexPath.row == self.viewModel.frequentFlyer.count + (self.ffExtraCount - 1) {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: addActionCellIdentifier, for: indexPath) as? TableViewAddActionCell else {
                        fatalError("TableViewAddActionCell not found")
                    }
                    cell.configureCell(LocalizedString.AddFrequentFlyer.localized)
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: twoPartEditTableViewCellIdentifier, for: indexPath) as? TwoPartEditTableViewCell else {
                        fatalError("TwoPartEditTableViewCell not found")
                    }
                    cell.delegate = self
                    cell.indexPath = indexPath
                    if (indexPath.row - 2) < self.viewModel.frequentFlyer.count {
                        // data cells
                        cell.ffData = self.viewModel.frequentFlyer[indexPath.row - 2]
                    } else if self.ffExtraCount == 4 {
                        // blank cell
                        cell.ffData = FrequentFlyer()
                    }
                    cell.deleteButton.isHidden = false
                    
                    cell.rightTitleLabel.isHidden = true
                    cell.leftSeparatorView.isHidden = indexPath.row == self.viewModel.frequentFlyer.count + 2
                    cell.rightSeparatorView.isHidden = indexPath.row == self.viewModel.frequentFlyer.count + 2
                    
                    return cell
                }
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: textEditableCellIdentifier, for: indexPath) as? TextEditableTableViewCell else { fatalError("TextEditableTableViewCell not found") }
                cell.editableTextField.isEnabled = false
                cell.configureCell(indexPath, flightPreferencesTitle[indexPath.row], flightDetails[indexPath.row])
                return cell
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        headerView.topSeparatorView.isHidden = true
        
        headerView.headerLabel.text = sections[section].rawValue
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case LocalizedString.EmailAddress:
            if indexPath.row == self.viewModel.email.count {
                self.indexPath = indexPath
                var email = Email()
                email.type = "email"
                self.viewModel.email.append(email)
                tableView.reloadData()
            }
            
        case LocalizedString.SocialAccounts:
            if indexPath.row == self.viewModel.social.count {
                self.indexPath = indexPath
                let social = Social()
                self.viewModel.social.append(social)
                tableView.reloadData()
            }
            
        case LocalizedString.Address:
            if indexPath.row == self.viewModel.addresses.count {
                self.indexPath = indexPath
                let address = Address()
                self.viewModel.addresses.append(address)
                tableView.reloadData()
            }
            
        case LocalizedString.MoreInformation:
            self.handleMoreInformationSectionSelection(indexPath)
            break
            
        case LocalizedString.ContactNumber:
            if indexPath.row == self.viewModel.mobile.count {
                self.indexPath = indexPath
                var mobile = Mobile()
                mobile.label = "Mobile"
                mobile.type = "mobile"
                mobile.isd = "+91"
                
                self.viewModel.mobile.append(mobile)
                tableView.reloadData()
            }
            
            break
        case LocalizedString.PassportDetails:
            self.handlePassportDetailSectionSelection(indexPath)
            
        case LocalizedString.FlightPreferences:
            if 0...1 ~= indexPath.row {
                self.handleFlightPreferencesSectionSelection(indexPath)
            } else if indexPath.row == (self.viewModel.frequentFlyer.count + (self.ffExtraCount - 1)) {
                self.indexPath = indexPath
                self.viewModel.frequentFlyer.append(FrequentFlyer())
                tableView.reloadData()
            }
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch sections[indexPath.section] {
            case LocalizedString.EmailAddress:
                self.viewModel.email.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            case LocalizedString.SocialAccounts:
                self.viewModel.social.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            case LocalizedString.ContactNumber:
                self.viewModel.mobile.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            case LocalizedString.FlightPreferences:
                self.viewModel.frequentFlyer.remove(at: indexPath.row - 2)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            default:
                break
            }
        }
    }
}

// MARK: - EditProfileImageHeaderViewDelegate Methods

extension EditProfileVC: EditProfileImageHeaderViewDelegate {
    func selectGroupTapped() {
        printDebug("select group tapped")
        if let groups = UserInfo.loggedInUser?.generalPref?.labels, groups.count > 0 {
            pickerType = .groups
            pickerData = groups
            openPicker()
        }
    }
    
    func salutationViewTapped() {
        if self.viewModel.salutationTypes.count > 0 {
            pickerType = .salutation
            pickerData = self.viewModel.salutationTypes
            openPicker()
        }
    }
    
    func editButtonTapped() {
        printDebug("edit button tapped")
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.TakePhoto.localized, LocalizedString.ChoosePhoto.localized, LocalizedString.ImportFromFacebook.localized, LocalizedString.ImportFromGoogle.localized, LocalizedString.RemovePhoto.localized], colors: [AppColors.themeGreen, AppColors.themeGreen, AppColors.themeGreen, AppColors.themeGreen, AppColors.themeRed])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] _, index in
            
            if index == 0 {
                NSLog("open camera")
                self?.openCamera()
            } else if index == 1 {
                NSLog("Open gallery")
                self?.openGallery()
            } else if index == 2 {
                NSLog("")
                self?.getPhotoFromFacebook()
            } else if index == 3 {
                self?.getPhotoFromGoogle()
            }
        }
    }
}

// MARK: - TextFieldDelegate methods

extension EditProfileVC {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.editProfileImageHeaderView.firstNameTextField:
            self.editProfileImageHeaderView.firstNameTextField.text = textField.text ?? ""
            if let textFieldString = textField.text, let swtRange = Range(range, in: textFieldString) {
                let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)
                viewModel.firstName = fullString
            }
            
        case self.editProfileImageHeaderView.lastNameTextField:
            self.editProfileImageHeaderView.lastNameTextField.text = textField.text ?? ""
            viewModel.lastName = textField.text ?? ""
            
        default:
            break
        }
        
        return true
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.editProfileImageHeaderView.firstNameTextField:
            self.editProfileImageHeaderView.firstNameTextField.resignFirstResponder()
        case self.editProfileImageHeaderView.lastNameTextField:
            self.editProfileImageHeaderView.lastNameTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileVC {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        editProfileImageHeaderView.profileImageView.image = selectedImage
        let path = compressAndSaveImage(selectedImage, name: "\(UIApplication.shared.uniqueID).jpeg")
        viewModel.filePath = path!
        viewModel.imageSource = "aertrip"
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - EditProfileTwoPartTableViewCellDelegate method

extension EditProfileVC: EditProfileTwoPartTableViewCellDelegate {
    func textFieldEndEditing(_ indexPath: IndexPath, _ text: String) {
        self.view.endEditing(true)
        if !text.checkValidity(.Email) {
            AppToast.default.showToastMessage(message: LocalizedString.Enter_valid_email_address.rawValue, vc: self)
        }
    }
    
    func textFieldText(_ indexPath: IndexPath, _ text: String) {
        switch self.sections[indexPath.section] {
        case LocalizedString.EmailAddress:
            self.viewModel.email[indexPath.row].value = text
        case LocalizedString.SocialAccounts:
            self.viewModel.social[indexPath.row].value = text
            break
        case LocalizedString.ContactNumber:
            break
        case LocalizedString.FlightPreferences:
            break
        default:
            break
        }
    }
    
    func leftViewTap(_ indexPath: IndexPath, _ gesture: UITapGestureRecognizer) {
        guard let indexPathRow = gesture.view?.tag else {
            return
        }
        print(indexPathRow)
        guard indexPathRow >= 0 else {
            print("Array index must be greater than zero. Going to  return")
            return
        }
        self.indexPathRow = indexPathRow
        self.indexPath = indexPath
        if sections[indexPath.section] == LocalizedString.SocialAccounts {
            if self.viewModel.socialTypes.count > 0 {
                pickerData = self.viewModel.socialTypes
                pickerType = .social
            }
        } else if sections[indexPath.section] == LocalizedString.EmailAddress {
            if self.viewModel.emailTypes.count > 0 {
                pickerData = self.viewModel.emailTypes
                pickerType = .email
            }
        }
        openPicker()
    }
    
    func deleteCellTapped(_ indexPath: IndexPath) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Delete.localized], colors: [AppColors.themeRed])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: LocalizedString.WouldYouLikeToDelete.localized, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            
            if index == 0 {
                switch self.sections[indexPath.section] {
                case LocalizedString.EmailAddress:
                    self.viewModel.email.remove(at: indexPath.row)
                    self.tableView.reloadData()
                case LocalizedString.SocialAccounts:
                    self.viewModel.social.remove(at: indexPath.row)
                    self.tableView.reloadData()
                case LocalizedString.ContactNumber:
                    self.viewModel.mobile.remove(at: indexPath.row)
                    self.tableView.reloadData()
                case LocalizedString.FlightPreferences:
                    if (indexPath.row - 2) < self.viewModel.frequentFlyer.count {
                        // delete ff data from array
                        self.viewModel.frequentFlyer.remove(at: indexPath.row - 2)
                    } else {
                        // delete blank cell data from array
                        self.ffExtraCount -= 1
                    }
                    self.tableView.reloadData()
                case LocalizedString.Address:
                    self.viewModel.addresses.remove(at: indexPath.row)
                    self.tableView.reloadData()
                    
                default:
                    break
                }
            }
        }
    }
}

// MARK: - EditProfileVMDelegate + methods

extension EditProfileVC: EditProfileVMDelegate {
    func getDefaultAirlineSuccess(_ data: [FlyerModel]) {
        self.viewModel.defaultAirlines = data
    }
    
    func getSuccess() {
        if self.viewModel.isFromTravellerList, !self.viewModel.isFromViewProfile {
            dismiss(animated: true, completion: nil)
        } else {
            AppFlowManager.default.popViewController(animated: true)
        }
    }
    
    func willApiCall() {
        //
    }
    
    func getPreferenceListSuccess(_ seatPreferences: [String: String], _ mealPreferences: [String: String]) {
        self.viewModel.seatPreferences = seatPreferences
        self.viewModel.mealPreferences = mealPreferences
    }
    
    func getCountryListSuccess(_ countryList: [String: String]) {
        self.viewModel.countries = countryList
    }
    
    func willGetDetail() {}
    
    func getSuccess(_ addresses: [String], _ emails: [String], _ mobiles: [String], _ salutations: [String], _ socials: [String]) {
        self.viewModel.addressTypes = addresses
        self.viewModel.emailTypes = emails
        self.viewModel.mobileTypes = mobiles
        self.viewModel.salutationTypes = salutations
        self.viewModel.socialTypes = socials
    }
    
    func getFail(errors: ErrorCodes) {
        //
    }
}

// MARK: - EditProfileThreePartTableViewCellDelegate

extension EditProfileVC: EditProfileThreePartTableViewCellDelegate {
    func editProfileThreePartTableViewCellTextFieldText(_ indexPath: IndexPath, _ text: String, isValide: Bool) {
        self.viewModel.mobile[indexPath.row].value = text
        self.viewModel.mobile[indexPath.row].isValide = isValide
    }
    
    func editProfileThreePartDeleteCellTapped(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        self.deleteCellTapped(indexPath)
    }
    
    func threePartLeftViewTap(_ gesture: UITapGestureRecognizer) {
        guard let indexPathRow = gesture.view?.tag else {
            return
        }
        print(indexPathRow)
        guard indexPathRow >= 0 else {
            print("Array index must be greater than zero. Going to  return")
            return
        }
        self.indexPathRow = indexPathRow
        if self.viewModel.mobileTypes.count > 0 {
            pickerData = self.viewModel.mobileTypes
            pickerType = .contactNumber
            openPicker()
        }
    }
    
    func middleViewTap(_ gesture: UITapGestureRecognizer) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
        PKCountryPicker.default.chooseCountry(onViewController: self) { [weak self] selectedCountry in
            printDebug("selected country data: \(selectedCountry)")
            guard let indexPathRow = gesture.view?.tag else {
                return
            }
            printDebug(indexPathRow)
            guard indexPathRow >= 0 else {
                printDebug("Array index must be greater than zero. Going to  return")
                return
            }
            let indexPath = IndexPath(row: indexPathRow, section: 1)
            
            guard let cell = self?.tableView.cellForRow(at: indexPath) as? EditProfileThreePartTableViewCell else {
                fatalError("EditProfileThreePartTableViewCell not found")
            }
            cell.countryCodeLabel.text = selectedCountry.countryCode
            cell.flagImageView.image = selectedCountry.flagImage
            cell.rightViewTextField.defaultRegion = selectedCountry.ISOCode
            cell.rightViewTextField.text = cell.rightViewTextField.nationalNumber
            
            self?.viewModel.mobile[indexPath.row].isd = selectedCountry.countryCode
            
            PKCountryPicker.default.closePicker()
        }
    }
}

// MARK: - UIPickerViewDelegate and UIPickerViewDataSource methods

extension EditProfileVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NSLog("selected data \(pickerData[row])")
        let pickerTitle = pickerData[row]
        switch pickerType {
        case .salutation:
            editProfileImageHeaderView.salutaionLabel.text = pickerTitle
            viewModel.salutation = pickerTitle
        case .email:
            let indexPath = IndexPath(row: indexPathRow, section: 0)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? EditProfileTwoPartTableViewCell else {
                fatalError("EditProfileTwoPartTableViewCell not found")
            }
            cell.leftTitleLabel.text = pickerTitle
            self.viewModel.email[indexPath.row].label = pickerTitle
        case .contactNumber:
            let indexPath = IndexPath(row: indexPathRow, section: 1)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? EditProfileThreePartTableViewCell else {
                fatalError("EditProfileThreePartTableViewCell not found")
            }
            self.viewModel.mobile[indexPath.row].type = pickerTitle
            cell.leftTitleLabel.text = pickerTitle
        case .social:
            let indexPath = IndexPath(row: indexPathRow, section: self.indexPath!.section)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? EditProfileTwoPartTableViewCell else {
                fatalError("EditProfileTwoPartTableViewCell not found")
            }
            self.viewModel.social[indexPath.row].label = pickerTitle
            cell.leftTitleLabel.text = pickerTitle
            
        case .seatPreference:
            let indexPath = IndexPath(row: (self.indexPath?.row)!, section: (self.indexPath?.section)!)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? TextEditableTableViewCell else { fatalError("TextEditableTableViewCell not found") }
            cell.editableTextField.text = pickerTitle
            viewModel.seat = pickerTitle
            
        case .mealPreference:
            let indexPath = IndexPath(row: (self.indexPath?.row)!, section: (self.indexPath?.section)!)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? TextEditableTableViewCell else { fatalError("TextEditableTableViewCell not found") }
            cell.editableTextField.text = pickerTitle
            viewModel.meal = pickerTitle
            
        case .country:
            if sections[(self.indexPath?.section)!] == LocalizedString.PassportDetails {
                let indexPath = IndexPath(row: (self.indexPath?.row)!, section: (self.indexPath?.section)!)
                guard let cell = self.tableView.cellForRow(at: indexPath) as? TextEditableTableViewCell else { fatalError("TextEditableTableViewCell not found") }
                cell.editableTextField.text = pickerTitle
                viewModel.passportCountryName = pickerTitle
                if let countryCode = self.viewModel.countries.someKey(forValue: pickerTitle) {
                    viewModel.passportCountry = countryCode
                }
                
                passportDetails[self.indexPath?.row ?? 1] = pickerTitle
            } else {
                let indexPath = IndexPath(row: (self.indexPath?.row)!, section: (self.indexPath?.section)!)
                guard let cell = self.tableView.cellForRow(at: indexPath) as? AddAddressTableViewCell else { fatalError("AddAddressTableViewCell not found") }
                cell.countryLabel.text = pickerTitle
                self.viewModel.addresses[indexPath.row].countryName = pickerTitle
                self.viewModel.addresses[indexPath.row].country = self.viewModel.countries.someKey(forValue: pickerTitle)!
            }
            
        case .addressTypes:
            let indexPath = IndexPath(row: (self.indexPath?.row)!, section: (self.indexPath?.section)!)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? AddAddressTableViewCell else { fatalError("AddAddressTableViewCell not found") }
            cell.addressTypeLabel.text = pickerTitle
            self.viewModel.addresses[indexPath.row].label = pickerTitle
            
        case .groups:
            editProfileImageHeaderView.groupLabel.text = pickerTitle
            viewModel.label = pickerTitle
        }
        closePicker()
    }
}

// MARK: - TwoPartEditTableViewCellDelegate methods

extension EditProfileVC: TwoPartEditTableViewCellDelegate {
    func twoPartEditTextField(_ indexPath: IndexPath, _ fullString: String) {
        self.viewModel.frequentFlyer[indexPath.row - 2].number = fullString
    }
    
    func twoPartDeleteCellTapped(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        self.deleteCellTapped(indexPath)
    }
    
    func twoPartEditLeftViewTap(_ indexPath: IndexPath, _ gesture: UITapGestureRecognizer) {
        self.indexPath = indexPath
        if sections[indexPath.section] == LocalizedString.FlightPreferences {
            let controller = SearchVC.instantiate(fromAppStoryboard: .Profile)
            controller.delgate = self
            controller.defaultAirlines = self.viewModel.defaultAirlines
            self.present(controller, animated: true, completion: nil)
            
        } else {
            viewType = .leftView
            showDatePicker()
        }
    }
    
    func rightViewTap(_ indexPath: IndexPath, _ gesture: UITapGestureRecognizer) {
        if sections[indexPath.section] == LocalizedString.FlightPreferences {} else {
            self.indexPath = indexPath
            viewType = .rightView
            showDatePicker()
        }
    }
}

// MARK: - SearchVC delegate methods

extension EditProfileVC: SearchVCDelegate {
    func frequentFlyerSelected(_ flyer: FlyerModel) {
        NSLog("flyer model \(flyer)")
        if let indexPath = self.indexPath {
            let str = flyer.value
            let strToReplaced = " (\(flyer.iata))"
            let replacedString = str.replacingOccurrences(of: strToReplaced, with: "")
            if (indexPath.row - 2) >= self.viewModel.frequentFlyer.count {
                self.viewModel.frequentFlyer.append(FrequentFlyer(json: [:]))
                self.ffExtraCount -= 1
            }
            self.viewModel.frequentFlyer[indexPath.row - (self.ffExtraCount - 1)].logoUrl = flyer.logoUrl
            self.viewModel.frequentFlyer[indexPath.row - (self.ffExtraCount - 1)].airlineName = replacedString
            self.viewModel.frequentFlyer[indexPath.row - (self.ffExtraCount - 1)].airlineCode = flyer.iata
            self.tableView.reloadData()
        }
    }
}

// MARK: - TextEditableTableViewCellDelegate methods

extension EditProfileVC: TextEditableTableViewCellDelegate {
    func textEditableTableViewCellTextFieldText(_ indexPath: IndexPath, _ text: String) {
        switch sections[indexPath.section] {
        case LocalizedString.MoreInformation:
            viewModel.notes = text
        case LocalizedString.PassportDetails:
            if indexPath.row == 0 {
                viewModel.passportNumber = text
            }
        default:
            break
        }
    }
}

// Mark

extension EditProfileVC: AddAddressTableViewCellDelegate {
    func deleteAddressCellTapped(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        self.deleteCellTapped(indexPath)
    }
    
    func addAddressTextField(_ textfield: UITextField, _ indexPath: IndexPath, _ fullString: String) {
        let cell = tableView.cellForRow(at: indexPath) as? AddAddressTableViewCell
        switch textfield {
        case cell?.addressLineOneTextField:
            NSLog("addressLineTwoTextField")
            self.viewModel.addresses[indexPath.row].line1 = fullString
        case cell?.addressLineTwoTextField:
            NSLog("addressLineTwoTextField")
            self.viewModel.addresses[indexPath.row].line2 = fullString
        case cell?.cityTextField:
            NSLog("cityTextField")
            self.viewModel.addresses[indexPath.row].city = fullString
        case cell?.postalCodeTextField:
            NSLog("postalCodeTextField")
            self.viewModel.addresses[indexPath.row].postalCode = fullString
        case cell?.stateTextField:
            NSLog("stateTextField")
            self.viewModel.addresses[indexPath.row].state = fullString
        default:
            break
        }
    }
    
    func addressTypeViewTapped(_ indexPath: IndexPath) {
        NSLog("Address view Tapped")
        self.indexPath = indexPath
        if self.viewModel.addressTypes.count > 0 {
            pickerType = .addressTypes
            let addressTypes = self.viewModel.addressTypes
            pickerData = addressTypes
            openPicker()
        }
    }
    
    func countryViewTapped(_ indexPath: IndexPath) {
        NSLog("country view tapped")
        self.indexPath = indexPath
        if self.viewModel.countries.count > 0 {
            pickerType = .country
            pickerData = Array(self.viewModel.countries.values)
            openPicker()
        }
    }
}
