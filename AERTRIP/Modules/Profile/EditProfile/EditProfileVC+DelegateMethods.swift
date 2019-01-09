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
        if sections[indexPath.section] == LocalizedString.Address, indexPath.row != addresses.count {
            return 264.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case LocalizedString.EmailAddress:
            return email.count + 1
        case LocalizedString.ContactNumber:
            return mobile.count + 1
        case LocalizedString.SocialAccounts:
            return social.count + 1
        case LocalizedString.Address:
            return addresses.count + 1
        case LocalizedString.MoreInformation:
            return informations.count
        case LocalizedString.PassportDetails:
            return 3
        case LocalizedString.FlightPreferences:
            return 3 + frequentFlyer.count
            
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case LocalizedString.EmailAddress:
            if indexPath.row == email.count {
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
                cell.configureCell(indexPath, email[indexPath.row].label, email[indexPath.row].value)
                if indexPath.row + 1 == email.count {
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
            if indexPath.row == mobile.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: addActionCellIdentifier, for: indexPath) as? TableViewAddActionCell else {
                    fatalError("TableViewAddActionCell not found")
                }
                cell.configureCell(LocalizedString.AddContactNumber.localized)
                return cell
            } else {
                cell.configureCell(indexPath, mobile[indexPath.row].isd, mobile[indexPath.row].label, mobile[indexPath.row].value)
                if indexPath.row + 1 == mobile.count {
                    cell.leftSeparatorView.isHidden = true
                    cell.rightSeparatorView.isHidden = true
                } else {
                    cell.leftSeparatorView.isHidden = false
                    cell.rightSeparatorView.isHidden = false
                }
                return cell
            }
        case LocalizedString.SocialAccounts:
            if indexPath.row == social.count {
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
                cell.configureCell(indexPath, social[indexPath.row].label, social[indexPath.row].value)
                if indexPath.row + 1 == social.count {
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
                cell.frequentFlyerView.isHidden = true
                cell.leftTitleLabel.text = LocalizedString.issueDate.rawValue
                cell.rightTitleLabel.text = LocalizedString.expiryDate.rawValue
                cell.deleteButton.isHidden = true
                cell.cofigureCell(indexPath, false, (travelData?.passportIssueDate)!, (travelData?.passportExpiryDate)!, "", "", "")
                cell.leftTextField.isEnabled = false
                cell.rightTextField.isEnabled = false
                
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
            
            if indexPath.row == addresses.count {
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
                cell.configureCell(indexPath, addressType: addresses[indexPath.row].label, addressLineOne: addresses[indexPath.row].line1, addressLineTwo: addresses[indexPath.row].line2, cityName: addresses[indexPath.row].city, postalCode: addresses[indexPath.row].postalCode, stateName: addresses[indexPath.row].state, countryName: addresses[indexPath.row].countryName)
                
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
                if indexPath.row == frequentFlyer.count + 2 {
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
                    
                    if indexPath.row == 2 {
                        cell.cofigureCell(indexPath, true, "", "", "", "", "")
                        cell.deleteButton.isHidden = true
                        
                        cell.rightTitleLabel.isHidden = true
                        return cell
                    } else if frequentFlyer.count > 1 {
                        cell.cofigureCell(indexPath, true, "", "", frequentFlyer[indexPath.row - 2].logoUrl, frequentFlyer[indexPath.row - 2].airlineName, frequentFlyer[indexPath.row - 2].number)
                        cell.deleteButton.isHidden = false
                        
                        cell.rightTitleLabel.isHidden = true
                        
                        if indexPath.row + 1 == frequentFlyer.count {
                            //                        cell.leftSeparatorView.isHidden = true
                            //                        cell.rightSeparatorView.isHidden = true
                        } else {
                            //                        cell.leftSeparatorView.isHidden = false
                            //                        cell.rightSeparatorView.isHidden = false
                        }
                        return cell
                    }
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
        return UITableViewCell()
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
            if indexPath.row == email.count {
                self.indexPath = indexPath
                var email = Email()
                email.type = "email"
                self.email.append(email)
                tableView.beginUpdates()
                insertRowsAtIndexPaths(indexPaths: [indexPath as NSIndexPath], withRowAnimation: .bottom)
                tableView.endUpdates()
            }
            
        case LocalizedString.SocialAccounts:
            if indexPath.row == social.count {
                self.indexPath = indexPath
                let social = Social()
                self.social.append(social)
                tableView.beginUpdates()
                let IndexPathOfLastRow = NSIndexPath(row: self.social.count - 1, section: indexPath.section)
                self.tableView.insertRows(at: [IndexPathOfLastRow as IndexPath], with: UITableView.RowAnimation.top)
                tableView.endUpdates()
            }
            
        case LocalizedString.Address:
            if indexPath.row == addresses.count {
                self.indexPath = indexPath
                let address = Address()
                self.addresses.append(address)
                tableView.beginUpdates()
                let IndexPathOfLastRow = NSIndexPath(row: self.addresses.count - 1, section: indexPath.section)
                self.tableView.insertRows(at: [IndexPathOfLastRow as IndexPath], with: UITableView.RowAnimation.top)
                tableView.endUpdates()
            }
            
        case LocalizedString.MoreInformation:
            self.handleMoreInformationSectionSelection(indexPath)
            break
            
        case LocalizedString.ContactNumber:
            if indexPath.row == self.mobile.count {
                self.indexPath = indexPath
                var mobile = Mobile()
                mobile.label = "Mobile"
                mobile.type = "mobile"
                mobile.isd = "+91"
                
                self.mobile.append(mobile)
                tableView.beginUpdates()
                let IndexPathOfLastRow = NSIndexPath(row: self.mobile.count - 1, section: indexPath.section)
                self.tableView.insertRows(at: [IndexPathOfLastRow as IndexPath], with: UITableView.RowAnimation.top)
                tableView.endUpdates()
            }
            
            break
        case LocalizedString.PassportDetails:
            self.handlePassportDetailSectionSelection(indexPath)
            
        case LocalizedString.FlightPreferences:
            if indexPath.row >= 3 {
                self.indexPath = indexPath
                let frequentFlyer = FrequentFlyer()
                self.frequentFlyer.append(frequentFlyer)
                tableView.beginUpdates()
                let IndexPathOfLastRow = NSIndexPath(row: indexPath.row, section: indexPath.section)
                self.tableView.insertRows(at: [IndexPathOfLastRow as IndexPath], with: UITableView.RowAnimation.top)
                tableView.endUpdates()
            } else {
                self.handleFlightPreferencesSectionSelection(indexPath)
            }
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch sections[indexPath.section] {
            case LocalizedString.EmailAddress:
                self.email.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            case LocalizedString.SocialAccounts:
                self.social.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            case LocalizedString.ContactNumber:
                self.mobile.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            case LocalizedString.FlightPreferences:
                self.frequentFlyer.remove(at: indexPath.row - 2)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            default:
                break
            }
        }
    }
}

// MARK: - EditProfileImageHeaderViewDelegate Methods

extension EditProfileVC: EditProfileImageHeaderViewDelegate {
    func salutationViewTapped() {
        if salutationTypes.count > 0 {
            pickerType = .salutation
            pickerData = salutationTypes
            openPicker()
        }
    }
    
    func editButtonTapped() {
        NSLog("edit buttn tapped")
        let action = AKAlertController.actionSheet(nil, message: nil, sourceView: self.view, buttons: [LocalizedString.TakePhoto.localized, LocalizedString.ChoosePhoto.localized, LocalizedString.ImportFromFacebook.localized, LocalizedString.ImportFromGoogle.localized, LocalizedString.RemovePhoto.localized], tapBlock: { [weak self] _, index in
            
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
            
        })
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
        let milliSec = getCurrentMillis()
        let path = compressAndSaveImage(selectedImage, name: "\(milliSec).jpeg")
        viewModel.filePath = path!
        //  viewModel.imageSource = "aertrip"
        
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
            email[indexPath.row].value = text
        case LocalizedString.SocialAccounts:
            social[indexPath.row].value = text
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
            if self.socialTypes.count > 0 {
                pickerData = self.socialTypes
                pickerType = .social
            }
        } else if sections[indexPath.section] == LocalizedString.EmailAddress {
            if self.emailTypes.count > 0 {
                pickerData = self.emailTypes
                pickerType = .email
            }
        }
        openPicker()
    }
    
    func deleteCellTapped(_ indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) as? EditProfileTwoPartTableViewCell else {
//            fatalError("EditProfileTwoPartTableViewCell not found")
//        }
//        cell.showSwipe(.rightToLeft, animated: true)
//        let cell = tableView.cellForRow(at: indexPath) as! MGSwipeTableCell
//        cell.showSwipe(.leftToRight, animated: true)
//        tableView.reloadData()
        
        _ = AKAlertController.actionSheet(nil, message: LocalizedString.WouldYouLikeToDelete.localized, sourceView: self.view, buttons: [LocalizedString.Delete.localized], tapBlock: { _, index in
            
            if index == 0 {
                switch self.sections[indexPath.section] {
                case LocalizedString.EmailAddress:
                    self.email.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                case LocalizedString.SocialAccounts:
                    self.social.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                case LocalizedString.ContactNumber:
                    self.mobile.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                case LocalizedString.FlightPreferences:
                    self.frequentFlyer.remove(at: indexPath.row - 3)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                case LocalizedString.Address:
                    self.addresses.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    
                default:
                    break
                }
            }
            
        })
    }
}

// MARK: - EditProfileVMDelegate + methods

extension EditProfileVC: EditProfileVMDelegate {
    func getDefaultAirlineSuccess(_ data: [FlyerModel]) {
        self.defaultAirlines = data
    }
    
    func getSuccess() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func willApiCall() {
        //
    }
    
    func getPreferenceListSuccess(_ seatPreferences: [String: String], _ mealPreferences: [String: String]) {
        self.seatPreferences = seatPreferences
        self.mealPreferences = mealPreferences
    }
    
    func getCountryListSuccess(_ countryList: [String: String]) {
        self.countries = countryList
    }
    
    func willGetDetail() {}
    
    func getSuccess(_ addresses: [String], _ emails: [String], _ mobiles: [String], _ salutations: [String], _ socials: [String]) {
        self.addressTypes = addresses
        self.emailTypes = emails
        self.mobileTypes = mobiles
        self.salutationTypes = salutations
        self.socialTypes = socials
    }
    
    func getFail(errors: ErrorCodes) {
        //
    }
}

// MARK: - EditProfileThreePartTableViewCellDelegate

extension EditProfileVC: EditProfileThreePartTableViewCellDelegate {
    func editProfileThreePartTableViewCellTextFieldText(_ indexPath: IndexPath, _ text: String) {
        mobile[indexPath.row].value = text
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
        if self.mobileTypes.count > 0 {
            pickerData = self.mobileTypes
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
            print(indexPathRow)
            guard indexPathRow >= 0 else {
                print("Array index must be greater than zero. Going to  return")
                return
            }
            let indexPath = IndexPath(row: indexPathRow, section: 1)
            
            guard let cell = self?.tableView.cellForRow(at: indexPath) as? EditProfileThreePartTableViewCell else {
                fatalError("EditProfileThreePartTableViewCell not found")
            }
            cell.countryCodeLabel.text = selectedCountry.countryCode
            cell.flagImageView.image = selectedCountry.flagImage
            
            self?.mobile[indexPath.row].isd = selectedCountry.countryCode
            
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
            email[indexPath.row].label = pickerTitle
            viewModel.email = email
        case .contactNumber:
            let indexPath = IndexPath(row: indexPathRow, section: 1)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? EditProfileThreePartTableViewCell else {
                fatalError("EditProfileThreePartTableViewCell not found")
            }
            mobile[indexPath.row].type = pickerTitle
            cell.leftTitleLabel.text = pickerTitle
            viewModel.mobile = mobile
        case .social:
            let indexPath = IndexPath(row: indexPathRow, section: self.indexPath!.section)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? EditProfileTwoPartTableViewCell else {
                fatalError("EditProfileTwoPartTableViewCell not found")
            }
            social[indexPath.row].label = pickerTitle
            cell.leftTitleLabel.text = pickerTitle
            viewModel.social = social
            
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
                viewModel.passportCountry = countries.someKey(forValue: pickerTitle)!
            } else {
                let indexPath = IndexPath(row: (self.indexPath?.row)!, section: (self.indexPath?.section)!)
                guard let cell = self.tableView.cellForRow(at: indexPath) as? AddAddressTableViewCell else { fatalError("AddAddressTableViewCell not found") }
                cell.countryLabel.text = pickerTitle
                addresses[indexPath.row].countryName = pickerTitle
                addresses[indexPath.row].country = countries.someKey(forValue: pickerTitle)!
            }
            
        case .addressTypes:
            let indexPath = IndexPath(row: (self.indexPath?.row)!, section: (self.indexPath?.section)!)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? AddAddressTableViewCell else { fatalError("AddAddressTableViewCell not found") }
            cell.addressTypeLabel.text = pickerTitle
            addresses[indexPath.row].label = pickerTitle
            
        default:
            break
        }
        closePicker()
    }
}

// MARK: - TwoPartEditTableViewCellDelegate methods

extension EditProfileVC: TwoPartEditTableViewCellDelegate {
    func twoPartEditTextField(_ indexPath: IndexPath, _ fullString: String) {
        frequentFlyer[indexPath.row - 2].number = fullString
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
            controller.defaultAirlines = self.defaultAirlines
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
            guard let cell = tableView.cellForRow(at: indexPath) as? TwoPartEditTableViewCell else {
                fatalError("TwoPartEditTableViewCell not found")
            }
            let str = flyer.value
            let strToReplaced = " (\(flyer.iata))"
            let replacedString = str.replacingOccurrences(of: strToReplaced, with: "")
            cell.cofigureCell(indexPath, true, "", "", flyer.logoUrl, replacedString, flyer.value)
            frequentFlyer[indexPath.row - 2].logoUrl = flyer.logoUrl
            frequentFlyer[indexPath.row - 2].airlineName = replacedString
            frequentFlyer[indexPath.row - 2].airlineCode = flyer.iata
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
            addresses[indexPath.row].line1 = fullString
        case cell?.addressLineTwoTextField:
            NSLog("addressLineTwoTextField")
            addresses[indexPath.row].line2 = fullString
        case cell?.cityTextField:
            NSLog("cityTextField")
            addresses[indexPath.row].city = fullString
        case cell?.postalCodeTextField:
            NSLog("postalCodeTextField")
            addresses[indexPath.row].postalCode = fullString
        case cell?.stateTextField:
            NSLog("stateTextField")
            addresses[indexPath.row].state = fullString
        default:
            break
        }
    }
    
    func addressTypeViewTapped(_ indexPath: IndexPath) {
        NSLog("Address view Tapped")
        self.indexPath = indexPath
        if addressTypes.count > 0 {
            pickerType = .addressTypes
            let addressTypes = self.addressTypes
            pickerData = addressTypes
            openPicker()
        }
    }
    
    func countryViewTapped(_ indexPath: IndexPath) {
        NSLog("country view tapped")
        self.indexPath = indexPath
        if self.countries.count > 0 {
            pickerType = .country
            pickerData = Array(self.countries.values)
            openPicker()
        }
    }
}
