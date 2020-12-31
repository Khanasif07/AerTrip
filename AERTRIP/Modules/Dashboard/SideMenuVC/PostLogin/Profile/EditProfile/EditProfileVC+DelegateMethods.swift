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
        if sections[indexPath.section] == LocalizedString.Address.localized, indexPath.row != self.viewModel.addresses.count {
            return UITableView.automaticDimension //264.0 + (self.viewModel.addresses.count > 1 ? 10.5 : 0)
        }else  if sections[indexPath.section] == LocalizedString.PassportDetails.localized, indexPath.row == 0  {
            return 60
        }else{
            //            if sections[indexPath.section] == LocalizedString.MoreInformation.localized, indexPath.row == 2 {
            //                return UITableView.automaticDimension
            //            } else {
            return UITableView.automaticDimension
            //        }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case LocalizedString.EmailAddress.localized:
            return self.viewModel.email.count + 1
        case LocalizedString.ContactNumber.localized:
            return self.viewModel.mobile.count + 1
        case LocalizedString.SocialAccounts.localized:
            return self.viewModel.social.count + 1
        case LocalizedString.Address.localized:
            return self.viewModel.addresses.count + 1
        case LocalizedString.MoreInformation.localized:
            return 3
        case LocalizedString.PassportDetails.localized:
            return 3
        case LocalizedString.FlightPreferences.localized:
            return self.ffExtraCount + self.viewModel.frequentFlyer.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case LocalizedString.EmailAddress.localized:
            if indexPath.row == self.viewModel.email.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: addActionCellIdentifier, for: indexPath) as? TableViewAddActionCell else {
                    fatalError("TableViewAddActionCell not found")
                }
                cell.configureCell(LocalizedString.AddEmail.localized)
                cell.topDividerView.isHidden = false
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: editTwoPartCellIdentifier, for: indexPath) as? EditProfileTwoPartTableViewCell else {
                    fatalError("EditProfileTwoPartTableViewCell not found")
                }
                
                cell.editProfilTwoPartTableViewCelldelegate = self
                if indexPath.row == 0, self.viewModel.currentlyUsinfFor == .viewProfile {
                    //make disable
                    cell.rightViewTextField.isEnabled = false
                    cell.deleteButton.isHidden = true
                    cell.leftView.isUserInteractionEnabled = false
                    cell.leftTitleLabel.textColor = AppColors.themeGray40
                    cell.rightViewTextField.textColor = AppColors.themeGray40
                    cell.blackDownImageView.isHidden = true
                } else {
                    //make enable
                    cell.rightViewTextField.delegate = self
                    cell.blackDownImageView.isHidden = false
                }
                
                if self.viewModel.currentlyUsinfFor == .addNewTravellerList {
                    cell.deleteButton.isHidden = self.viewModel.email.count == 1
                }
                
                cell.rightViewTextField.placeholder = LocalizedString.Email.localized
                cell.rightViewTextField.keyboardType = .emailAddress
                cell.email = self.viewModel.email[indexPath.row]
                cell.social = nil
                cell.leftSeparatorView.isHidden = indexPath.row + 1 == self.viewModel.email.count
                cell.rightSeparatorView.isHidden = indexPath.row + 1 == self.viewModel.email.count
                return cell
            }
            
        case LocalizedString.ContactNumber.localized:
            if indexPath.row == self.viewModel.mobile.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: addActionCellIdentifier, for: indexPath) as? TableViewAddActionCell else {
                    fatalError("TableViewAddActionCell not found")
                }
                cell.configureCell(LocalizedString.AddContactNumber.localized)
                cell.topDividerView.isHidden = false
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: editThreePartCellIdentifier, for: indexPath) as? EditProfileThreePartTableViewCell else {
                    fatalError("EditProfileThreePartTableViewCell not found")
                }
                cell.delegate = self
                if indexPath.row == 0 {
                    //make disable
                    cell.deleteButton.isHidden = true
                    cell.leftView.isUserInteractionEnabled = false
                    cell.rightViewTextField.isUserInteractionEnabled = !(self.viewModel.travelData?.id == UserInfo.loggedInUser?.paxId)
                    cell.leftTitleLabel.textColor = AppColors.themeGray40
                    cell.blackDownImageView.isHidden = true
                    
                } else {
                    //make enable
                    cell.deleteButton.isHidden = false
                    cell.blackDownImageView.isHidden = false
                    cell.leftView.isUserInteractionEnabled = true
                    cell.leftTitleLabel.textColor = AppColors.themeBlack
                }
                if self.viewModel.currentlyUsinfFor == .addNewTravellerList && indexPath.row != 0 {
                    cell.deleteButton.isHidden = self.viewModel.mobile.count == 1
                }
                cell.configureCell(self.viewModel.mobile[indexPath.row].isd, self.viewModel.mobile[indexPath.row].label, self.viewModel.mobile[indexPath.row].value)
                cell.leftSeparatorView.isHidden = indexPath.row + 1 == self.viewModel.mobile.count
                cell.middleSeparatorView.isHidden = indexPath.row + 1 == self.viewModel.mobile.count
                cell.rightSeparatorView.isHidden = indexPath.row + 1 == self.viewModel.mobile.count
                return cell
            }
        case LocalizedString.SocialAccounts.localized:
            if indexPath.row == self.viewModel.social.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: addActionCellIdentifier, for: indexPath) as? TableViewAddActionCell else {
                    fatalError("TableViewAddActionCell not found")
                }
                cell.configureCell(LocalizedString.AddSocialAccountId.localized)
                cell.topDividerView.isHidden = false
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: editTwoPartCellIdentifier, for: indexPath) as? EditProfileTwoPartTableViewCell else {
                    fatalError("EditProfileTwoPartTableViewCell not found")
                }
                cell.editProfilTwoPartTableViewCelldelegate = self
                cell.rightViewTextField.placeholder = LocalizedString.SocialProfile.localized
                cell.social = self.viewModel.social[indexPath.row]
                cell.email = nil
                cell.deleteButton.isHidden = self.viewModel.social.count == 1
                cell.leftSeparatorView.isHidden = indexPath.row + 1 == self.viewModel.social.count
                cell.rightSeparatorView.isHidden = indexPath.row + 1 == self.viewModel.social.count
                return cell
            }
            
        case LocalizedString.PassportDetails.localized: // passport details
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HCPanCardTextFieldCell.reusableIdentifier) as? HCPanCardTextFieldCell else {
                    return UITableViewCell()
                }
                
                
                cell.editableTextField.setUpAttributedPlaceholder(placeholderString: passportDetaitTitle[indexPath.row],with: "")
                cell.delegate = self
                cell.editableTextField.text = viewModel.passportNumber
                cell.editableTextField.font = AppFonts.Regular.withSize(18.0)
                cell.editableTextField.textColor = AppColors.themeBlack
                cell.editableTextField.keyboardType = .default
                cell.checkForPanCardValidation = false
                cell.separatorView.isHidden = false
                cell.editableTextField.titleYPadding = 14.0
                cell.editableTextField.hintYPadding = 4.0
                //                if viewModel.canShowErrorForEmailPhone {
                //                    cell.checkForErrorStateOfTextfield()
                //                }
                return cell
            }
            if indexPath.row == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: twoPartEditTableViewCellIdentifier, for: indexPath) as? TwoPartEditTableViewCell else { fatalError("TwoPartEditTableViewCell not found") }
                
                cell.delegate = self
                cell.leftTextField.placeholder = LocalizedString.SelectDate.localized
                cell.rightTextField.placeholder = LocalizedString.SelectDate.localized
                cell.issueDate = viewModel.passportIssueDate.isEmpty ? LocalizedString.SelectDate.localized : viewModel.passportIssueDate
                cell.expiryDate = viewModel.passportExpiryDate.isEmpty ? LocalizedString.SelectDate.localized : viewModel.passportExpiryDate
                cell.leftSeparatorView.isHidden = true
                cell.rightSeparatorView.isHidden = true
                cell.ffData = nil
                
                return cell
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: textEditableCellIdentifier, for: indexPath) as? TextEditableTableViewCell else { fatalError("TextEditableTableViewCell not found") }
                cell.editableTextField.delegate = self
                cell.delegate = self
                cell.editableTextField.isFloatingField = false
                cell.editableTextField.isEnabled = indexPath.row == 0
                cell.downArrowImageView.isHidden = indexPath.row == 0
                if indexPath.row == 0 {
                    cell.editableTextField.placeholder = LocalizedString.passportNo.localized
                }
                cell.editableTextField.isHiddenBottomLine = true
                //index 0: passport no, index 1: passport country
                cell.configureCell(passportDetaitTitle[indexPath.row], (indexPath.row == 0) ? viewModel.passportNumber : viewModel.passportCountryName)
                
                return cell
            }
            
        case LocalizedString.Address.localized:
            
            if indexPath.row == self.viewModel.addresses.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: addActionCellIdentifier, for: indexPath) as? TableViewAddActionCell else {
                    fatalError("TableViewAddActionCell not found")
                }
                
                cell.configureCell(LocalizedString.AddAddress.localized)
                cell.topDividerView.isHidden = true
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: addAddressTableViewCellIdentifier, for: indexPath) as? AddAddressTableViewCell else {
                    fatalError("AddAddressTableViewCell not found")
                }
                cell.delegate = self
                cell.configureCell(addressType: self.viewModel.addresses[indexPath.row].label, addressLineOne: self.viewModel.addresses[indexPath.row].line1, addressLineTwo: self.viewModel.addresses[indexPath.row].line2, cityName: self.viewModel.addresses[indexPath.row].city, postalCode: self.viewModel.addresses[indexPath.row].postalCode, stateName: self.viewModel.addresses[indexPath.row].state, countryName: self.viewModel.addresses[indexPath.row].countryName.isEmpty ? LocalizedString.Select.localized : self.viewModel.addresses[indexPath.row].countryName)
                
                cell.deleteButton.isHidden = self.viewModel.addresses.count <= 1
                //                cell.cellDividerView.defaultBackgroundColor = AppColors.themeGray04
                cell.contentView.backgroundColor = AppColors.themeGray04
                //cell.bottomDivider.isHidden = indexPath.row < (self.viewModel.addresses.count - 1)
                cell.contentView.bringSubviewToFront(cell.bottomDivider)
                cell.hideSepratorView = indexPath.row >= (self.viewModel.addresses.count - 1)
                return cell
            }
            
        case LocalizedString.MoreInformation.localized:
            if indexPath.row == 2 {
                guard let addNotesCell = tableView.dequeueReusableCell(withIdentifier: addNotesTableViewCellIdentifier, for: indexPath) as? AddNotesTableViewCell else {
                    fatalError("AddNotesTableViewCell not found")
                }
                addNotesCell.addNoteTextView.placeholder = LocalizedString.AddNotes.localized
                addNotesCell.delegate = self
                addNotesCell.sepratorView.isHidden = true
                addNotesCell.configureCell(viewModel.notes)
                return addNotesCell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: textEditableCellIdentifier, for: indexPath) as? TextEditableTableViewCell else {
                    fatalError("TextEditableTableViewCell not found") }
                cell.delegate = self
                if moreInformation[indexPath.row].rawValue == LocalizedString.Birthday.rawValue || moreInformation[indexPath.row].rawValue == LocalizedString.Anniversary.rawValue {
                    cell.editableTextField.isEnabled = true
                } else {
                    cell.editableTextField.isEnabled = true
                }
                cell.downArrowImageView.isHidden = true
                
                //index 0: dob, index 1: doa
                cell.configureCell(moreInformation[indexPath.row].rawValue,  (indexPath.row == 0) ? viewModel.dob : viewModel.doa)
                cell.separatorView.isHidden = (indexPath.row + 1 == moreInformation.count) ? true : false
                cell.editableTextField.lineView.isHidden = true
                cell.editableTextField.isHiddenBottomLine = true
                return cell
            }
            
        case LocalizedString.FlightPreferences.localized:
            if indexPath.row >= 2 {
                if indexPath.row == self.viewModel.frequentFlyer.count + (self.ffExtraCount - 1) {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: addActionCellIdentifier, for: indexPath) as? TableViewAddActionCell else {
                        fatalError("TableViewAddActionCell not found")
                    }
                    cell.configureCell(LocalizedString.AddFrequentFlyer.localized)
                    cell.topDividerView.isHidden = false
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: frequentFlyerTableViewCellIdentifier, for: indexPath) as? FrequentFlyerTableViewCell else {
                        fatalError("frequentFlyerTableViewCellIdentifier not found")
                    }
                    cell.delegate = self
                    cell.rightTextField.placeholder = LocalizedString.Number.localized
                    cell.leftTextField.placeholder = LocalizedString.Program.localized
                    cell.leftTitleLabel.text = LocalizedString.Program.localized
                    cell.frequentFlyerLabel.text = LocalizedString.SelectAirline.localized
                    if (indexPath.row - 2) < self.viewModel.frequentFlyer.count {
                        // data cells
                        cell.ffData = self.viewModel.frequentFlyer[indexPath.row - 2]
                    } else if self.ffExtraCount == 4 {
                        // blank cell
                        var frequentFlyer = FrequentFlyer()
                        frequentFlyer.airlineName = LocalizedString.SelectAirline.localized
                        cell.ffData = frequentFlyer
                    }
                    cell.hideSeperator = indexPath.row == self.viewModel.frequentFlyer.count + (self.ffExtraCount - 2)
                    //                    cell.rightTitleLabel.isHidden = true
                    //                    cell.leftSeparatorView.isHidden = indexPath.row == self.viewModel.frequentFlyer.count + (self.ffExtraCount - 2)
                    //                    cell.rightSeparatorView.isHidden = indexPath.row == self.viewModel.frequentFlyer.count + (self.ffExtraCount - 2)
                    
                    cell.deleteButton.isHidden = self.viewModel.frequentFlyer.count == 1 ?  true : false
                    cell.isFFTitleHidden = !(indexPath.row == 2)
                    
                    return cell
                }
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: textEditableCellIdentifier, for: indexPath) as? TextEditableTableViewCell else { fatalError("TextEditableTableViewCell not found") }
                cell.editableTextField.isEnabled = true
                cell.editableTextField.lineView.backgroundColor = AppColors.clear
                cell.editableTextField.isHiddenBottomLine = true
                cell.delegate = self
                cell.downArrowImageView.isHidden = false
                cell.configureCell(flightPreferencesTitle[indexPath.row], indexPath.row == 0 ? (viewModel.seat.isEmpty ? LocalizedString.Select.localized : viewModel.seat) : (viewModel.meal.isEmpty ? LocalizedString.Select.localized : viewModel.meal))
                return cell
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sections[section].localized == LocalizedString.SocialAccounts.localized || sections[section].localized == LocalizedString.FlightPreferences.localized || sections[section].localized == LocalizedString.EmailAddress.localized 
        {
            return 60.0
        } else {
            return 40.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AppConstants.ktableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        headerView.topSeparatorView.isHidden = sections[section].localized == LocalizedString.EmailAddress.localized || sections[section].localized == LocalizedString.FlightPreferences.localized || sections[section].localized == LocalizedString.SocialAccounts.localized ? false : true
        headerView.topDividerHeightConstraint.constant = sections[section].localized == LocalizedString.EmailAddress.localized || sections[section].localized == LocalizedString.FlightPreferences.localized || sections[section].localized == LocalizedString.SocialAccounts.localized ? 0.5 : 0
        
        headerView.headerLabel.text = sections[section].localized
        headerView.backgroundColor = AppColors.themeGray04
        headerView.containerView.backgroundColor = AppColors.themeGray04
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var closePicker = true
        switch sections[indexPath.section] {
        case LocalizedString.EmailAddress.localized:
            if indexPath.row == self.viewModel.email.count {
                self.indexPath = indexPath
                var email = Email()
                email.type = "email"
                var label = LocalizedString.Home.localized
                if self.viewModel.emailTypes.count > 0 , self.viewModel.currentlyUsinfFor == .viewProfile {
                    if self.viewModel.email.count == 1 {
                        label = self.viewModel.emailTypes[0]
                    } else if self.viewModel.email.count == 2 {
                        label = self.viewModel.emailTypes[2]
                    } else {
                        label = self.viewModel.emailTypes[1]
                    }
                } else {
                    if self.viewModel.email.count == 1 {
                        label = self.viewModel.emailTypes[1]
                    } else {
                        label = self.viewModel.emailTypes[0]
                    }
                }
                email.label = label
                self.viewModel.email.append(email)
                //                self.tableView.insertRows(at: [indexPath], with: .bottom)
                //                self.tableView.beginUpdates()
                //                self.tableView.endUpdates()
                tableView.reloadData()
            }
            
        case LocalizedString.SocialAccounts.localized:
            if indexPath.row == self.viewModel.social.count {
                self.indexPath = indexPath
                var social = Social()
                social.label = LocalizedString.Facebook.localized
                self.viewModel.social.append(social)
                //                self.tableView.insertRows(at: [indexPath], with: .bottom)
                //                self.tableView.beginUpdates()
                //                self.tableView.endUpdates()
                tableView.reloadData()
            }
            
        case LocalizedString.Address.localized:
            if indexPath.row == self.viewModel.addresses.count {
                self.indexPath = indexPath
                var address = Address()
                address.label = "Home"
                address.country = LocalizedString.SelectedCountrySymbol.localized
                address.countryName = LocalizedString.selectedCountry.localized
                self.viewModel.addresses.append(address)
                //                self.tableView.insertRows(at: [indexPath], with: .bottom)
                //                self.tableView.beginUpdates()
                //                self.tableView.endUpdates()
                tableView.reloadSection(section: indexPath.section, with: .none)
            }
            
        case LocalizedString.MoreInformation.localized:
            closePicker = false
            if let cell = self.tableView.cellForRow(at: indexPath) as? TextEditableTableViewCell {
                self.handleMoreInformationSectionSelection(indexPath, textField: cell.editableTextField)
            }
            break
            
        case LocalizedString.ContactNumber.localized:
            if indexPath.row == self.viewModel.mobile.count {
                self.indexPath = indexPath
                var mobile = Mobile()
                mobile.label = "Mobile"
                mobile.type = "mobile"
                mobile.isd = "+91"
                self.viewModel.mobile.append(mobile)
                //                self.tableView.insertRows(at: [indexPath], with: .bottom)
                //                self.tableView.beginUpdates()
                //                self.tableView.endUpdates()
                tableView.reloadData()
            }
            
            break
        case LocalizedString.PassportDetails.localized:
            closePicker = false
            self.handlePassportDetailSectionSelection(indexPath)
            
        case LocalizedString.FlightPreferences.localized:
            if 0...1 ~= indexPath.row {
                closePicker = false
                if let cell = self.tableView.cellForRow(at: indexPath) as? TextEditableTableViewCell {
                    self.handleFlightPreferencesSectionSelection(indexPath, textField: cell.editableTextField)
                }
            } else if indexPath.row == (self.viewModel.frequentFlyer.count + (self.ffExtraCount - 1)) {
                self.indexPath = indexPath
                var frequentFlyer = FrequentFlyer()
                frequentFlyer.airlineName = LocalizedString.SelectAirline.localized
                self.viewModel.frequentFlyer.append(frequentFlyer)
                //                self.tableView.insertRows(at: [indexPath], with: .bottom)
                //                self.tableView.beginUpdates()
                //                self.tableView.endUpdates()
                tableView.reloadData()
            }
            
        default:
            break
        }
        if closePicker {
            closeAllPicker(completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch sections[indexPath.section] {
            case LocalizedString.EmailAddress.localized:
                self.viewModel.email.remove(at: indexPath.row)
                //                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            case LocalizedString.SocialAccounts.localized:
                self.viewModel.social.remove(at: indexPath.row)
                //                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                
            case LocalizedString.ContactNumber.localized:
                self.viewModel.mobile.remove(at: indexPath.row)
                //                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            case LocalizedString.FlightPreferences.localized:
                self.viewModel.frequentFlyer.remove(at: indexPath.row - 2)
                //                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                //            case LocalizedString.Address.localized:
                //                 self.viewModel.addresses.remove(at: indexPath.row)
                //                 tableView.reloadData()
                
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch sections[indexPath.section] {
        case LocalizedString.EmailAddress.localized:
            return !((indexPath.row == 0) || indexPath.row == self.viewModel.email.count)
        case LocalizedString.ContactNumber.localized:
            return !(indexPath.row == 0  || indexPath.row == self.viewModel.mobile.count)
            //        case LocalizedString.ContactNumber.localized:
        //            return !((indexPath.row == 0 && self.viewModel.currentlyUsinfFor == .viewProfile) || (indexPath.row == 0 && self.viewModel.currentlyUsinfFor == .travellerList) || (indexPath.row == 0 && self.viewModel.currentlyUsinfFor == .addNewTravellerList)) || (indexPath.row == self.viewModel.mobile.count)
        case LocalizedString.SocialAccounts.localized:
            return !(indexPath.row == self.viewModel.social.count || self.viewModel.social.count == 1)
        case LocalizedString.FlightPreferences.localized:
            return !((indexPath.row < 2) || (indexPath.row == self.viewModel.frequentFlyer.count + (self.ffExtraCount - 1)) || (self.viewModel.frequentFlyer.count <= 1))
        case LocalizedString.Address.localized:
            return false
        case LocalizedString.PassportDetails.localized:
            return false
        case LocalizedString.MoreInformation.localized:
            return false
        default: break
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch sections[section] {
        case LocalizedString.FlightPreferences.localized:
            return self.viewModel.currentlyUsinfFor == .travellerList ? 95 : 35
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        switch sections[section] {
        case LocalizedString.FlightPreferences.localized:
            guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: editProfileFooterTableView) as? EditProfileFooterTableView else {return nil}
            if self.viewModel.currentlyUsinfFor == .travellerList {
                footerView.deleteTravellerView.isHidden = false
                footerView.topSpaceView.isHidden = false
            } else {
                footerView.deleteTravellerView.isHidden = true
                footerView.topSpaceView.isHidden = true
            }
            footerView.deleteBtnHandler = {[weak self] in
                guard let strongSelf = self else {return}
                strongSelf.deleteTravellButtonTapped()
            }
            
            return footerView
        default:
            return nil
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.closeAllPicker(completion: nil)
    }
}

// MARK: - EditProfileImageHeaderViewDelegate Methods

extension EditProfileVC: EditProfileImageHeaderViewDelegate {
    func salutationViewTapped(title: String) {
        printDebug("Selected in unicode switch \(title)")
        editProfileImageHeaderView.genderTitleLabel.text = title
        if title == LocalizedString.Male.localized {
            self.viewModel.salutation =  AppGlobals.shared.getSalutationAsPerGenderAndAge(gender: AppConstants.kmR, dob: self.viewModel.dob, dateFormatter: "yyyy-MM-dd")
        } else {
            self.viewModel.salutation = AppGlobals.shared.getSalutationAsPerGenderAndAge(gender: AppConstants.kmRS, dob: self.viewModel.dob, dateFormatter: "yyyy-MM-dd")
        }
    }
    func textFieldText(_ textfield: UITextField) {
        let text = textfield.text ?? ""
        switch textfield {
        case editProfileImageHeaderView.firstNameTextField:
            editProfileImageHeaderView.firstNameTextField.text = text.removeSpaceAsSentence.substring(to: AppConstants.kNameTextLimit)
            self.viewModel.firstName = text.removeSpaceAsSentence
        case editProfileImageHeaderView.lastNameTextField:
            editProfileImageHeaderView.lastNameTextField.text = text.removeSpaceAsSentence.substring(to: AppConstants.kNameTextLimit)
            self.viewModel.lastName = text.removeSpaceAsSentence
        default:
            break
        }
        if self.viewModel.profilePicture.isEmpty && self.viewModel.filePath.isEmpty {
            setUpProfilePhotoInitials()
        }
        
    }
    
    func selectGroupTapped(_ textfield: UITextField) {
        dismissKeyboard()
        printDebug("select group tapped")
        pickerType = .groups
        if let labels = UserInfo.loggedInUser?.generalPref?.labels,!labels.isEmpty {
            pickerData = labels
            let selectedString = self.viewModel.travelData?.label ?? ""
            openPicker(withSelection: selectedString, textField: textfield)
            textfield.becomeFirstResponder()
        } else {
            AppToast.default.showToastMessage(message: "there are no groups")
        }
    }
    
    func salutationViewTapped() {
        dismissKeyboard()
        if self.viewModel.salutationTypes.count > 0 {
            pickerType = .salutation
            pickerData = self.viewModel.salutationTypes
            // openPicker(withSelection: viewModel.salutation, textField: <#UITextField#>)
        }
    }
    
    func editButtonTapped() {
        dismissKeyboard()
        printDebug("edit button tapped")
        
        if self.viewModel.travelData?.id == UserInfo.loggedInUser?.paxId {
            editLoggedInUserProfilePhoto()
        } else {
            editProfilePhotoForTraveller()
        }
        
    }
    
    
    func editProfilePhotoForTraveller() {
        var buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.TakePhoto.localized, LocalizedString.ChoosePhoto.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        
        if (!self.viewModel.profilePicture.isEmpty) || (!self.viewModel.filePath.isEmpty) {
            buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.TakePhoto.localized, LocalizedString.ChoosePhoto.localized, LocalizedString.RemovePhoto.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen,AppColors.themeRed])
        }
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] _, index in
            
            if index == 0 {
                printDebug("open camera")
                self?.openCamera()
            } else if index == 1 {
                printDebug("Open gallery")
                self?.openGallery()
            } else if index == 2 {
                printDebug("Remove Photo")
                self?.viewModel.profilePicture = ""
                self?.setUpProfilePhotoInitials()
            }
        }
    }
    
    func editLoggedInUserProfilePhoto(){
        var buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.TakePhoto.localized, LocalizedString.ChoosePhoto.localized, LocalizedString.ImportFromFacebook.localized, LocalizedString.ImportFromGoogle.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen, AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        if (!self.viewModel.profilePicture.isEmpty) || (!self.viewModel.filePath.isEmpty) {
            buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.TakePhoto.localized, LocalizedString.ChoosePhoto.localized, LocalizedString.ImportFromFacebook.localized, LocalizedString.ImportFromGoogle.localized, LocalizedString.RemovePhoto.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen, AppColors.themeDarkGreen, AppColors.themeDarkGreen, AppColors.themeRed])
        }
        
        
        _ = PKAlertController.default.presentActionSheet(nil,message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] _, index in
            
            if index == 0 {
                printDebug("open camera")
                self?.openCamera()
            } else if index == 1 {
                printDebug("Open gallery")
                self?.openGallery()
            } else if index == 2 {
                self?.getPhotoFromFacebook()
            } else if index == 3 {
                self?.getPhotoFromGoogle()
            } else if index == 4 {
                printDebug("Remove Photo")
                self?.viewModel.profilePicture = ""
                self?.setUpProfilePhotoInitials()
            }
        }
    }
}

// MARK: - TextFieldDelegate methods

extension EditProfileVC {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let inputMode = textField.textInputMode else {
            return false
        }
        if inputMode.primaryLanguage == "emoji" || !(inputMode.primaryLanguage != nil) {
            return false
        }
        
        switch textField {
        case self.editProfileImageHeaderView.firstNameTextField:
            self.editProfileImageHeaderView.firstNameTextField.text = textField.text ?? ""
            if let textFieldString = textField.text?.removeSpaceAsSentence, let swtRange = Range(range, in: textFieldString) {
                let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)
                viewModel.firstName = fullString.removeSpaceAsSentence
            }
            
        case self.editProfileImageHeaderView.lastNameTextField:
            self.editProfileImageHeaderView.lastNameTextField.text = textField.text?.removeSpaceAsSentence ?? ""
            viewModel.lastName = textField.text?.removeSpaceAsSentence ?? ""
            
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
        if let path = compressAndSaveImage(selectedImage, name: "\(UIApplication.shared.uniqueID).jpeg"){
            viewModel.filePath = path
        }
        
        viewModel.imageSource = "aertrip"
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - EditProfileTwoPartTableViewCellDelegate method

extension EditProfileVC: EditProfileTwoPartTableViewCellDelegate {
    func textFieldEndEditing(_ indexPath: IndexPath, _ text: String) {
        self.view.endEditing(true)
        switch sections[indexPath.section] {
        case LocalizedString.EmailAddress.localized:
            if !text.isEmpty && !text.checkValidity(.Email) {
                AppToast.default.showToastMessage(message: LocalizedString.Enter_valid_email_address.localized)
            }
        default:
            break
        }
    }
    
    func textFieldText(_ indexPath: IndexPath, _ text: String) {
        switch self.sections[indexPath.section] {
        case LocalizedString.EmailAddress.localized:
            self.viewModel.email[indexPath.row].value = text
        case LocalizedString.SocialAccounts.localized:
            self.viewModel.social[indexPath.row].value = text
            break
        case LocalizedString.ContactNumber.localized:
            break
        case LocalizedString.FlightPreferences.localized:
            break
        default:
            break
        }
    }
    
    func leftViewTap(_ indexPath: IndexPath, _ gesture: UITapGestureRecognizer, textField: UITextField) {
        guard let indexPathRow = gesture.view?.tag else {
            return
        }
        printDebug(indexPathRow)
        guard indexPathRow >= 0 else {
            printDebug("Array index must be greater than zero. Going to  return")
            return
        }
        self.indexPathRow = indexPathRow
        self.indexPath = indexPath
        if sections[indexPath.section] == LocalizedString.SocialAccounts.localized {
            if self.viewModel.socialTypes.count > 0 {
                pickerData = self.viewModel.socialTypes
                pickerType = .social
                openPicker(withSelection: viewModel.social[indexPath.row].label, textField: textField)
                textField.becomeFirstResponder()
            }
        } else if sections[indexPath.section] == LocalizedString.EmailAddress.localized {
            if self.viewModel.emailTypes.count > 0 {
                pickerData = self.viewModel.emailTypes
                pickerType = .email
                openPicker(withSelection: viewModel.email[indexPath.row].label, textField: textField)
                textField.becomeFirstResponder()
            }
        }
    }
    
    func deleteCellTapped(_ indexPath: IndexPath) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Delete.localized], colors: [AppColors.themeRed])
        
        self.closeAllPicker(completion: nil)
        
        switch self.sections[indexPath.section] {
        case LocalizedString.EmailAddress.localized:
            if self.viewModel.email[indexPath.row].value.isEmpty {
                self.viewModel.email.remove(at: indexPath.row)
                self.tableView.reloadData()
                return
            }
            
        case LocalizedString.SocialAccounts.localized:
            if self.viewModel.social[indexPath.row].value.isEmpty {
                self.viewModel.social.remove(at: indexPath.row)
                self.tableView.reloadData()
                return
            }
        default:
            break
        }
        
        _ = PKAlertController.default.presentActionSheet(nil, message: LocalizedString.WouldYouLikeToDelete.localized, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            
            if index == 0 {
                switch self.sections[indexPath.section] {
                case LocalizedString.EmailAddress.localized:
                    self.viewModel.email.remove(at: indexPath.row)
                    self.tableView.reloadData()
                case LocalizedString.SocialAccounts.localized:
                    self.viewModel.social.remove(at: indexPath.row)
                    self.tableView.reloadData()
                case LocalizedString.ContactNumber.localized:
                    self.viewModel.mobile.remove(at: indexPath.row)
                    self.tableView.reloadData()
                case LocalizedString.FlightPreferences.localized:
                    if (indexPath.row - 2) < self.viewModel.frequentFlyer.count {
                        // delete ff data from array
                        self.viewModel.frequentFlyer.remove(at: indexPath.row - 2)
                    } else {
                        // delete blank cell data from array
                        self.ffExtraCount = 3
                    }
                    self.tableView.reloadData()
                case LocalizedString.Address.localized:
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
    func willCallDeleteTravellerAPI() {
        //
        self.startLoading()
    }
    
    func deleteTravellerAPISuccess() {
        for viewController in self.navigationController?.viewControllers ?? [] {
            if viewController is TravellerListVC {
                AppFlowManager.default.popToViewController(viewController, animated: true)
                self.sendDataChangedNotification(data: ATNotification.travellerDeleted)
            }
        }
        self.stopLoading()
    }
    
    func deleteTravellerAPIFailure() {
        //
        self.stopLoading()
    }
    
    func getDefaultAirlineSuccess(_ data: [FlyerModel]) {
        self.viewModel.defaultAirlines = data
    }
    
    func getSuccess() {
        self.stopLoading()
        self.sendDataChangedNotification(data: ATNotification.profileSavedOnServer)
        self.topNavBarLeftButtonAction(UIButton())
    }
    
    func willApiCall() {
        self.startLoading()
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
        self.stopLoading()
        if AppGlobals.shared.isNetworkRechable() {
            AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
        }
        else {
            AppToast.default.showToastMessage(message: LocalizedString.NoInternet.localized)
        }
    }
}

// MARK: - EditProfileThreePartTableViewCellDelegate

extension EditProfileVC: EditProfileThreePartTableViewCellDelegate {
    
    func editProfileThreePartTableViewCellTextFieldText(_ textField: UITextField, _ indexPath: IndexPath, _ text: String, isValide: Bool) {
        
        let final = text.substring(to: AppConstants.kMaxPhoneLength-1)
        textField.text = final
        self.viewModel.mobile[indexPath.row].value = final
        self.viewModel.mobile[indexPath.row].isValide = isValide
    }
    
    func editProfileThreePartDeleteCellTapped(_ indexPath: IndexPath) {
        guard indexPath.row != 0 else {return}
        self.indexPath = indexPath
        if self.viewModel.mobile[indexPath.row].value.isEmpty {
            self.viewModel.mobile.remove(at: indexPath.row)
            self.tableView.reloadData()
        } else {
            self.deleteCellTapped(indexPath)
        }
    }
    
    func threePartLeftViewTap(_ indexPath: IndexPath,_ gesture: UITapGestureRecognizer, textField: UITextField) {
        guard let indexPathRow = gesture.view?.tag else {
            return
        }
        printDebug(indexPathRow)
        guard indexPathRow >= 0 else {
            printDebug("Array index must be greater than zero. Going to  return")
            return
        }
        self.indexPathRow = indexPathRow
        self.indexPath = indexPath
        if self.viewModel.mobileTypes.count > 0 {
            pickerData = self.viewModel.mobileTypes
            pickerType = .contactNumber
            openPicker(withSelection: viewModel.mobile[indexPath.row].label, textField: textField)
            textField.becomeFirstResponder()
        }
    }
    
    func middleViewTap(_ indexPath: IndexPath,_ gesture: UITapGestureRecognizer) {
        
        //self.closeGenricAndDatePicker(completion: nil)
        
        PKCountryPickerSettings.shouldShowCountryCode = true
        PKCountryPicker.default.chooseCountry(onViewController: self, preSelectedCountry: PKCountryPicker.default.getCountryData(forISDCode: self.viewModel.mobile[indexPath.row].isd)) { [weak self] (selectedCountry,closePicker) in
            printDebug("selected country data: \(selectedCountry)")
            
            guard let cell = self?.tableView.cellForRow(at: indexPath) as? EditProfileThreePartTableViewCell else {
                fatalError("EditProfileThreePartTableViewCell not found")
            }
            cell.countryCodeLabel.text = selectedCountry.countryCode
            cell.flagImageView.image = selectedCountry.flagImage
            //            cell.rightViewTextField.defaultRegion = selectedCountry.ISOCode
            //            cell.rightViewTextField.text = cell.rightViewTextField.nationalNumber
            
            self?.viewModel.mobile[indexPath.row].isd = selectedCountry.countryCode
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
        self.pickerTitle = pickerData[row]
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        printDebug("selected data \(pickerData[row])")
        pickerTitle = pickerData[row]
        
        // changes for picker
        valueChangedGenericPicker()
    }
}

// MARK: - TwoPartEditTableViewCellDelegate methods

extension EditProfileVC: TwoPartEditTableViewCellDelegate {
    func twoPartEditTextField(_ indexPath: IndexPath, _ fullString: String) {
        // moved to FrequentFlyerTableViewCellDelegate
        //        if self.viewModel.frequentFlyer.count <= indexPath.row - 2 {
        //            self.viewModel.frequentFlyer.append(FrequentFlyer(json: [:]))
        //        }
        //        self.viewModel.frequentFlyer[indexPath.row - 2].number = fullString
    }
    
    func twoPartDeleteCellTapped(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        self.deleteCellTapped(indexPath)
    }
    
    func twoPartEditLeftViewTap(_ indexPath: IndexPath, textField: UITextField) {
        self.indexPath = indexPath
        if sections[indexPath.section] == LocalizedString.FlightPreferences.localized {
            // moved to FrequentFlyerTableViewCellDelegate
            // AppFlowManager.default.moveToFFSearchVC(defaultAirlines: self.viewModel.defaultAirlines, delegate: self)
            
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            viewType = .leftView
            let expiryDate = formatter.date(from: viewModel.passportExpiryDate)
            var maxDate = Date()
            if let date = expiryDate, let newDate = date.add(days: -1) {
                maxDate = newDate
            }
            showDatePicker(formatter.date(from: viewModel.passportIssueDate),nil, maximumDate: maxDate, textField: textField)
            //textField.becomeFirstResponder()
        }
    }
    
    func rightViewTap(_ indexPath: IndexPath, textField: UITextField) {
        if sections[indexPath.section] == LocalizedString.FlightPreferences.localized {} else {
            self.indexPath = indexPath
            viewType = .rightView
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            let issueDate = formatter.date(from: viewModel.passportIssueDate)
            var minDate = Date()
            if let date = issueDate, let newDate = date.add(days: 1) {
                minDate = newDate
            }
            showDatePicker(formatter.date(from: viewModel.passportExpiryDate),minDate, maximumDate: nil, textField: textField)
            //textField.becomeFirstResponder()
        }
    }
}
// MARK: - FrequentFlyerTableViewCellDelegate methods

extension EditProfileVC: FrequentFlyerTableViewCellDelegate {
    func frequentFlyerTaped(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        if sections[indexPath.section] == LocalizedString.FlightPreferences.localized {
            if viewModel.currentlyUsinfFor == .addNewTravellerList {
                presentFFSearchVC(defaultAirlines: self.viewModel.defaultAirlines, delegate: self)
            } else {
                AppFlowManager.default.moveToFFSearchVC(defaultAirlines: self.viewModel.defaultAirlines, delegate: self)
            }
        }
        
    }
    
    func programTextField(_ indexPath: IndexPath) {
        dismissKeyboard()
        AppToast.default.showToastMessage(message: LocalizedString.UnderDevelopment.localized)
        
        //        if self.viewModel.salutationTypes.count > 0 {
        //            pickerType = .salutation
        //            pickerData = self.viewModel.salutationTypes
        //            openPicker(withSelection: viewModel.salutation)
        //        }
    }
    
    func numberTextField(_ indexPath: IndexPath, _ number: String) {
        if self.viewModel.frequentFlyer.count <= indexPath.row - 2 {
            self.viewModel.frequentFlyer.append(FrequentFlyer(json: [:]))
        }
        self.viewModel.frequentFlyer[indexPath.row - 2].number = number
    }
    
}

// MARK: - SearchVC delegate methods

extension EditProfileVC: SearchVCDelegate {
    func frequentFlyerSelected(_ flyer: FlyerModel) {
        printDebug("flyer model \(flyer)")
        if let indexPath = self.indexPath {
            let str = flyer.value
            let strToReplaced = " (\(flyer.iata))"
            let replacedString = str.replacingOccurrences(of: strToReplaced, with: "")
            if (indexPath.row - 2) >= self.viewModel.frequentFlyer.count {
                self.viewModel.frequentFlyer.append(FrequentFlyer(json: [:]))
            }
            self.ffExtraCount = 3
            
            self.viewModel.frequentFlyer[indexPath.row - (self.ffExtraCount - 1)].logoUrl = flyer.logoUrl
            self.viewModel.frequentFlyer[indexPath.row - (self.ffExtraCount - 1)].airlineName = replacedString
            self.viewModel.frequentFlyer[indexPath.row - (self.ffExtraCount - 1)].airlineCode = flyer.iata
            self.tableView.reloadData()
        }
    }
}

// MARK: - TextEditableTableViewCellDelegate methods

extension EditProfileVC: TextEditableTableViewCellDelegate, HCPanCardTextFieldCellDelegate {
    func textEditableTableViewCellTextFieldText(_ indexPath: IndexPath, _ text: String) {
        switch sections[indexPath.section] {
        case LocalizedString.MoreInformation.localized:
            // viewModel.notes = text
            break
        case LocalizedString.PassportDetails.localized:
            if indexPath.row == 0, let cell = self.tableView.cellForRow(at: indexPath) as? HCPanCardTextFieldCell {
                let final = text.substring(to: AppConstants.kPassportNoLimit-1)
                viewModel.passportNumber = final
                cell.editableTextField.text = final
            }
        default:
            break
        }
    }
    
    func textEditableTableViewCellDidTapped(_ indexPath: IndexPath, textField: UITextField) {
        switch sections[indexPath.section] {
        case LocalizedString.MoreInformation.localized:
            self.handleMoreInformationSectionSelection(indexPath, textField: textField)
        case LocalizedString.FlightPreferences.localized:
            if 0...1 ~= indexPath.row {
                if let cell = self.tableView.cellForRow(at: indexPath) as? TextEditableTableViewCell {
                    self.handleFlightPreferencesSectionSelection(indexPath, textField: cell.editableTextField)
                }
            } else if indexPath.row == (self.viewModel.frequentFlyer.count + (self.ffExtraCount - 1)) {
                self.indexPath = indexPath
                var frequentFlyer = FrequentFlyer()
                frequentFlyer.airlineName = LocalizedString.SelectAirline.localized
                self.viewModel.frequentFlyer.append(frequentFlyer)
                //                self.tableView.insertRows(at: [indexPath], with: .bottom)
                //                self.tableView.beginUpdates()
                //                self.tableView.endUpdates()
                tableView.reloadData()
            }
        default:
            self.closeAllPicker(completion: nil)
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
            printDebug("addressLineTwoTextField")
            self.viewModel.addresses[indexPath.row].line1 = fullString
        case cell?.addressLineTwoTextField:
            printDebug("addressLineTwoTextField")
            self.viewModel.addresses[indexPath.row].line2 = fullString
        case cell?.cityTextField:
            printDebug("cityTextField")
            self.viewModel.addresses[indexPath.row].city = fullString
        case cell?.postalCodeTextField:
            printDebug("postalCodeTextField")
            self.viewModel.addresses[indexPath.row].postalCode = fullString
        case cell?.stateTextField:
            printDebug("stateTextField")
            self.viewModel.addresses[indexPath.row].state = fullString
        default:
            break
        }
    }
    
    func addressTypeViewTapped(_ indexPath: IndexPath, textField: UITextField) {
        printDebug("Address view Tapped")
        self.indexPath = indexPath
        if self.viewModel.addressTypes.count > 0 {
            pickerType = .addressTypes
            let addressTypes = self.viewModel.addressTypes
            pickerData = addressTypes
            openPicker(withSelection: viewModel.addresses[indexPath.row].label, textField: textField)
            textField.becomeFirstResponder()
        }
    }
    
    func countryViewTapped(_ indexPath: IndexPath) {
        printDebug("country view tapped")
        self.indexPath = indexPath
        PKCountryPickerSettings.shouldShowCountryCode = false
        if self.viewModel.countries.count > 0 {
            pickerType = .country
            pickerData = Array(self.viewModel.countries.values)
            // AppConstants.kIndianIsdCode
            let prevSectdContry = PKCountryPicker.default.getCountryData(forISOCode: self.viewModel.addresses[indexPath.row].country.isEmpty ? "IN" : self.viewModel.addresses[indexPath.row].country )
            //self.closeGenricAndDatePicker(completion: nil)
            PKCountryPicker.default.chooseCountry(onViewController: self, preSelectedCountry: prevSectdContry) { [weak self] (selectedCountry,closePicker)  in
                printDebug("selected country data: \(selectedCountry)")
                
                guard let cell = self?.tableView.cellForRow(at: indexPath) as? AddAddressTableViewCell else {
                    fatalError("AddAddressTableViewCell not found")
                }
                cell.countryLabel.text = selectedCountry.countryEnglishName
                self?.viewModel.addresses[indexPath.row].countryName = selectedCountry.countryEnglishName
                self?.viewModel.addresses[indexPath.row].country = selectedCountry.ISOCode
            }
        }
    }
}

extension EditProfileVC: AddNotesTableViewCellDelegate {
    func textViewWillBecomeActive(_ textView: UITextView) {
        guard  let cell = textView.tableViewCell as? AddNotesTableViewCell  else {
            return
        }
        guard let indexPath = self.tableView.indexPath(for: cell) else {return}
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func textViewText(_ textView: UITextView) {
        
        if textView.numberOfLines >= 10 {
            textView.isScrollEnabled = false
            textView.isScrollEnabled = true
            let location = textView.text.count - 1
            _ = NSMakeRange(location, 1)
            //textView.scrollRangeToVisible(bottom)
            printDebug(textView.selectedRange)
        } else {
            tableView.beginUpdates()
            textView.isScrollEnabled = false
            tableView.endUpdates()
        }
        self.viewModel.notes = textView.text.removeLeadingTrailingWhitespaces
        
    }
}

extension EditProfileVC {
    func presentFFSearchVC(defaultAirlines: [FlyerModel], delegate: SearchVCDelegate?) {
        let controller = FFSearchVC.instantiate(fromAppStoryboard: .Profile)
        controller.modalPresentationStyle = .fullScreen
        controller.delgate = delegate
        controller.defaultAirlines = defaultAirlines
        self.present(controller, animated: true, completion: nil)
    }
}


/*
 self.viewModel.notes = textView.text
 guard let cell = textView.tableViewCell as? AddNotesTableViewCell else { return }
 UIView.setAnimationsEnabled(false)
 self.tableView.beginUpdates()
 cell.contentView.layoutIfNeeded()
 let location = textView.text.count - 1
 let bottom = NSMakeRange(location, 1)
 textView.scrollRangeToVisible(bottom)
 self.view.layoutIfNeeded()
 self.tableView.endUpdates()
 UIView.setAnimationsEnabled(true)
 */
// https://stackoverflow.com/questions/38714272/how-to-make-uitextview-height-dynamic-according-to-text-length
