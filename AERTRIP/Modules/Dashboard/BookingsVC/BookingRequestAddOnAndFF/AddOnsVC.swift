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
    
    @IBOutlet var addOnTableView: ATTableView!
    
    // MARK: - Variables
    
    let footerViewIdentifier = "BookingInfoEmptyFooterView"
    let headerViewIdentifier = "BookingAddOnHeaderView"
    
    override func initialSetup() {
        self.registerXib()
        self.addOnTableView.dataSource = self
        self.addOnTableView.delegate = self
        self.addOnTableView.reloadData()
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
        
        guard let commontInputTableViewCell = self.addOnTableView.dequeueReusableCell(withIdentifier: "BookingAddCommonInputTableViewCell") as? BookingAddCommonInputTableViewCell else {
            fatalError("BookingAddCommonInputTableViewCell not found")
        }
        
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
            let leg = BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section] ?? Leg()
            let passenger = leg.pax[indexPath.row / 5]
            let name = "\(passenger.salutation) \(passenger.paxName)"
            
            cell.configureCell(profileImage: passenger.profileImage, salutationImage: passenger.salutationImage, passengerName: name)
            return cell
        // Seat Preference or Seat Booking Based on Flight type LCC or GDS
        case 1:
            
            if BookingRequestAddOnsFFVM.shared.isLCC {
                commontInputTableViewCell.configureCell(title: LocalizedString.SeatBookingTitle.localized, placeholderText: LocalizedString.SeatBookingPlaceholder.localized)
                 commontInputTableViewCell.delegate = self
                return commontInputTableViewCell
            } else {
                mealOrPreferencesCell.configureCell(title: LocalizedString.SeatPreferenceTitle.localized)
                return mealOrPreferencesCell
            }
            
        // Meal Preference or Meal Booking Cell Based on Flight type LCC or GDS
        case 2:
            if BookingRequestAddOnsFFVM.shared.isLCC {
                commontInputTableViewCell.configureCell(title: LocalizedString.MealBookingTitle.localized, placeholderText: LocalizedString.MealBookingPlaceholder.localized)
               
                 commontInputTableViewCell.delegate = self
                return commontInputTableViewCell
            } else {
                mealOrPreferencesCell.configureCell(title: LocalizedString.MealPreferenceTitle.localized)
                return mealOrPreferencesCell
            }
            
        // Extra baggage Cell
        case 3:
            commontInputTableViewCell.configureCell(title: LocalizedString.ExtraBaggageTitle.localized, placeholderText: LocalizedString.ExtraBaggagePlacheholder.localized)
               commontInputTableViewCell.delegate = self
            return commontInputTableViewCell
            
        // Other Cell
        case 4:
            commontInputTableViewCell.configureCell(title: LocalizedString.OtherBookingTitle.localized, placeholderText: LocalizedString.OtherBookingPlaceholder.localized)
            commontInputTableViewCell.delegate = self
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
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = addOnTableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingAddOnHeaderView else {
            fatalError(" BookingAddOnHeaderView not  found")
        }
        
        let leg = BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[section]
        let route = leg?.title.split(separator: "-").joined(separator: "→")
        var info: String = leg?.flight.first?.departDate?.toString(dateFormat: "dd MMM YYYY") ?? ""
        
        info += leg?.refundable == 0 ? " | Refundable " : " | Non-refundable "
        info += leg?.reschedulable == 0 ? "| Reschedule " : "| Non-Reschedule "
        headerView.routeLabel.text = route
        headerView.infoLabel.text = info
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = self.addOnTableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as? BookingInfoEmptyFooterView else {
            fatalError("BookingInfoFooterView not found")
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row % 5 {
        case 1:
            if !BookingRequestAddOnsFFVM.shared.isLCC {
                printDebug("Open seat preferences")
               
            }
        case 2:
            if !BookingRequestAddOnsFFVM.shared.isLCC {
                printDebug("Open meal  preferences")
            }
            
            //Extra Baggage
        case 3:
            let cell = tableView.cellForRow(at: indexPath) as? BookingAddCommonInputTableViewCell
            PKMultiPicker.noOfComponent = 1
            PKMultiPicker.openMultiPickerIn(cell?.inputTextField, firstComponentArray:  Array(BookingRequestAddOnsFFVM.shared.mealPreferences.values), secondComponentArray: [], firstComponent: "", secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { (firstSelect, secondSelect) in
                printDebug(firstSelect)
            }
            
            // Other
        case 4:
            let cell = tableView.cellForRow(at: indexPath) as? BookingAddCommonInputTableViewCell
            PKMultiPicker.noOfComponent = 1
            PKMultiPicker.openMultiPickerIn(cell?.inputTextField, firstComponentArray:  Array(BookingRequestAddOnsFFVM.shared.seatPreferences.values), secondComponentArray: [], firstComponent: "", secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { (firstSelect, secondSelect) in
                printDebug(firstSelect)
            }
        default:
            return
        }
    }
}


extension AddOnsVC: BookingAddCommonInputTableViewCellDelegate {
    func textFieldText(textField: UITextField) {
        if let indexPath = self.addOnTableView.indexPath(forItem: textField) {
            let leg = BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[indexPath.section] ?? Leg()
            var passenger = leg.pax[indexPath.row / 5]
            switch indexPath.row % 5 {
                // Seat Booking
            case 1:
                passenger._seat = textField.text ?? ""
               // meal Booking
            case 2:
                   passenger._meal = textField.text ?? ""
                // Extra Baggage
            case 3:
               passenger._baggage = textField.text ?? ""
                
                // Others
            case 4:
                passenger.other = textField.text  ?? ""
                
            default:
                break
            
            }
            printDebug("passenger detail is \(passenger)")
        }
    }
}
