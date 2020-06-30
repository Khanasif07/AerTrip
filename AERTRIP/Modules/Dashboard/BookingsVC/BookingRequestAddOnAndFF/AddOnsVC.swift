//
//  AddOnsVC.swift
//  AERTRIP
//
//  Created by apple on 21/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AddOnsVC: BaseVC {
    // MARK: - IBOutlet
    
    @IBOutlet weak var addOnTableView: ATTableView!
    
    // MARK: - Variables
    
    let footerViewIdentifier = "BookingInfoEmptyFooterView"
    let headerViewIdentifier = "BookingAddOnHeaderView"
    
    override func initialSetup() {
        self.registerXib()
        self.addOnTableView.dataSource = self
        self.addOnTableView.delegate = self
        self.addOnTableView.reloadData()
        self.addOnTableView.backgroundColor = AppColors.themeGray04
    }
    
    func registerXib() {
        self.addOnTableView.register(UINib(nibName: self.footerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.footerViewIdentifier)
        self.addOnTableView.register(UINib(nibName: self.headerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.headerViewIdentifier)
        self.addOnTableView.registerCell(nibName: BookingAddOnPassengerTableViewCell.reusableIdentifier)
        self.addOnTableView.registerCell(nibName: BookingFFMealTableViewCell.reusableIdentifier)
        self.addOnTableView.registerCell(nibName: BookingAddCommonInputTableViewCell.reusableIdentifier)
    }
    
    // MARK: - Get Cell for First section
    
    func getCellForSection(_ indexPath: IndexPath) -> UITableViewCell {
        guard let mealOrPreferencesCell = self.addOnTableView.dequeueReusableCell(withIdentifier: "BookingFFMealTableViewCell") as? BookingFFMealTableViewCell else {
            fatalError("BookingFFMealTableViewCell not found")
        }
        mealOrPreferencesCell.delegate = self
        
        guard let commontInputTableViewCell = self.addOnTableView.dequeueReusableCell(withIdentifier: "BookingAddCommonInputTableViewCell") as? BookingAddCommonInputTableViewCell else {
            fatalError("BookingAddCommonInputTableViewCell not found")
        }
        commontInputTableViewCell.delegate = self
        switch indexPath.row % 5 {
        case 0:
            guard let cell = self.addOnTableView.dequeueReusableCell(withIdentifier: "BookingAddOnPassengerTableViewCell") as? BookingAddOnPassengerTableViewCell else {
                fatalError("BookingAddOnPassengerTableViewCell not found")
            }
            if indexPath.row == 0 {
                cell.topConstraint.constant = 0
            } else {
                cell.topConstraint.constant = 16
            }
            let user = BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5]
            var age = ""
            let dob = user?.dob ?? ""
            if !dob.isEmpty {
                age = AppGlobals.shared.getAgeLastString(dob: dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            }
            cell.configureCell(profileImage: user?.profileImage ?? "", salutationImage: AppGlobals.shared.getEmojiIcon(dob: dob, salutation: (user?.salutation ?? ""), dateFormatter: Date.DateFormat.yyyy_MM_dd.rawValue), passengerName: user?.paxName ?? "", age: age)
            return cell
        // Seat Preference or Seat Booking Based on Flight type LCC or GDS
        case 1:
            
            if BookingRequestAddOnsFFVM.shared.isLCC {
                commontInputTableViewCell.configureCell(title: LocalizedString.SeatBookingTitle.localized, placeholderText: LocalizedString.SeatBookingPlaceholder.localized, text: BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].seat ?? "")
                
                return commontInputTableViewCell
            } else {
                mealOrPreferencesCell.configureCell(title: LocalizedString.SeatPreferenceTitle.localized, text: BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].seatPreferences ?? "")
                return mealOrPreferencesCell
            }
            
        // Meal Preference or Meal Booking Cell Based on Flight type LCC or GDS
        case 2:
            if BookingRequestAddOnsFFVM.shared.isLCC {
                commontInputTableViewCell.configureCell(title: LocalizedString.MealBookingTitle.localized, placeholderText: LocalizedString.MealBookingPlaceholder.localized, text: BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].meal ?? "")
                
                return commontInputTableViewCell
            } else {
                mealOrPreferencesCell.configureCell(title: LocalizedString.MealPreferenceTitle.localized, text: BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].mealPreferenes ?? "")
                return mealOrPreferencesCell
            }
            
        // Extra baggage Cell
        case 3:
            commontInputTableViewCell.configureCell(title: LocalizedString.ExtraBaggageTitle.localized, placeholderText: LocalizedString.ExtraBaggagePlacheholder.localized, text: BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].baggage ?? "")
            commontInputTableViewCell.characterCountLabel.isHidden = false
            return commontInputTableViewCell
            
        // Other Cell
        case 4:
            let extraCellCount = 4 * (BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax.count ?? 0)
            let paxCount = BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax.count ?? 0
            commontInputTableViewCell.configureCell(title: LocalizedString.OtherBookingTitle.localized, placeholderText: LocalizedString.OtherBookingPlaceholder.localized, text: BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].other ?? "")
            commontInputTableViewCell.dividerView.isHidden = (indexPath.row == (extraCellCount + paxCount) - 1)
            return commontInputTableViewCell
           
        default:
            return UITableViewCell()
        }
    }
}

extension AddOnsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let extraCellCount = 4 * (BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[section].pax.count ?? 0)
        let paxCount = BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[section].pax.count ?? 0
        return extraCellCount + paxCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getCellForSection(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 67.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 5 == 0 {
            return indexPath.row == 0 ? 44 : 60
        }
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = addOnTableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingAddOnHeaderView else {
            fatalError(" BookingAddOnHeaderView not  found")
        }
        
        let leg = BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[section]
        let route = leg?.title.split(separator: "-").joined(separator: "→")
        var info: String = leg?.flight.first?.departDate?.toString(dateFormat: "dd MMM YYYY") ?? ""
        
        info += leg?.refundable == 1 ? " | Refundable " : " | Non-refundable "
        info += leg?.reschedulable == 1 ? "| Reschedulable " : "| Non-reschedulable "
        headerView.routeLabel.text = route
        headerView.infoLabel.text = info
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = self.addOnTableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as? BookingInfoEmptyFooterView else {
            fatalError("BookingInfoFooterView not found")
        }
        let totalSection = BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg.count ?? 0
        footerView.bottomDividerView.isHidden = (totalSection - 1) == section
        return footerView
    }
}

extension AddOnsVC: BookingAddCommonInputTableViewCellDelegate {
    func textFieldText(textField: UITextField) {
        guard let indexPath = self.addOnTableView.indexPath(forItem: textField) else {
            fatalError("indexPath not found")
        }
        let cell = self.addOnTableView.cellForRow(at: indexPath) as? BookingAddCommonInputTableViewCell
        
        switch indexPath.row % 5 {
        // Seat Booking
        case 1:
            BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].seat = textField.text ?? ""
            cell?.inputTextField.text = textField.text ?? ""
        // meal Booking
        case 2:
            BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].meal = textField.text ?? ""
            cell?.inputTextField.text = textField.text ?? ""
        // Extra Baggage
        case 3:
            BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].baggage = textField.text ?? ""
            cell?.inputTextField.text = textField.text ?? ""
        // Others
        case 4:
            BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].other = textField.text ?? ""
            cell?.inputTextField.text = textField.text ?? ""
            cell?.dividerView.isHidden =  true
        default:
            break
        }
    }
}

extension AddOnsVC: BookingFFMealTableViewCellDelegate {
    func textFieldEditing(textfield: UITextField) {
        guard let indexPath = self.addOnTableView.indexPath(forItem: textfield) else {
            fatalError("indexPath not found")
        }
        let cell = self.addOnTableView.cellForRow(at: indexPath) as? BookingFFMealTableViewCell
        switch indexPath.row % 5 {
        // Seat Booking
        case 1:
            PKMultiPicker.noOfComponent = 1
            var seatPreferences = Array(BookingRequestAddOnsFFVM.shared.seatPreferences.values)
            seatPreferences.insert(LocalizedString.Select.localized, at: 0)
            PKMultiPicker.openMultiPickerIn(cell?.selectedMealPreferenceTextField, firstComponentArray: seatPreferences, secondComponentArray: [], firstComponent: cell?.selectedMealPreferenceTextField.text ?? "", secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { [weak cell] firstSelect, _ in
                if LocalizedString.Select.localized != firstSelect {
                BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].seatPreferences = firstSelect
                cell?.selectedMealPreferenceTextField.text = firstSelect
                BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].seatPreferences = firstSelect
                } else {
                    cell?.selectedMealPreferenceTextField.text = firstSelect
                    BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].seatPreferences = ""
                }
            }
            
        // meal Booking
        case 2:
            PKMultiPicker.noOfComponent = 1
            var mealPreferences = Array(BookingRequestAddOnsFFVM.shared.mealPreferences.values.sorted())
            mealPreferences.insert(LocalizedString.Select.localized, at: 0)
            PKMultiPicker.openMultiPickerIn(cell?.selectedMealPreferenceTextField, firstComponentArray: mealPreferences, secondComponentArray: [], firstComponent: cell?.selectedMealPreferenceTextField.text ?? "", secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { [weak cell] firstSelect, _ in
                if LocalizedString.Select.localized != firstSelect {
                cell?.selectedMealPreferenceTextField.text = firstSelect
                BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].mealPreferenes = firstSelect
                } else {
                    cell?.selectedMealPreferenceTextField.text = firstSelect
                    BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section].pax[indexPath.row / 5].mealPreferenes = ""
                }
            }
        default:
            break
        }
    }
}
