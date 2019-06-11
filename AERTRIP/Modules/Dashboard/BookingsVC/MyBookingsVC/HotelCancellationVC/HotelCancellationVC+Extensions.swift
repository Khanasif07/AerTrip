//
//  HotelCancellationVC+Extensions.swift
//  AERTRIP
//
//  Created by Admin on 05/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension HotelCancellationVC: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.bookedHotelData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BookingReschedulingHeaderView") as? BookingReschedulingHeaderView else { return nil }
        headerView.delegate = self
        headerView.selectedButton.isUserInteractionEnabled = false
        let image = self.viewModel.isAllRoomSelected ? #imageLiteral(resourceName: "tick") : #imageLiteral(resourceName: "untick")
        headerView.selectedButton.setImage(image, for: .normal)
        headerView.routeLabel.text = self.viewModel.hotelName
        headerView.infoLabel.text = self.viewModel.bookingDateAndRefundableStatus
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelCancellationRoomInfoTableViewCell.reusableIdentifier, for: indexPath) as? HotelCancellationRoomInfoTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        let hotelData = self.viewModel.bookedHotelData[indexPath.row]
        cell.configureCell(roomNumber: "\(LocalizedString.Room.localized) \(hotelData.roomNumber)", roomName: hotelData.roomName , guestNames: hotelData.roomGuest, isRoomSelected: hotelData.isChecked, isExpanded: hotelData.isExpanded)
        cell.topDividerViewLeadingConstraint.constant = (indexPath.row == self.viewModel.bookedHotelData.count - 1) ? 0.0 : 63.0
        cell.bottomDividerViewLeadingConstraint.constant = (indexPath.row == self.viewModel.bookedHotelData.count - 1) ? 0.0 : 63.0
        cell.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.viewModel.bookedHotelData.count {
            return 0
        } else {
            return self.viewModel.bookedHotelData[indexPath.row].isExpanded ? 214.0 : 61
        }
    }
}

extension HotelCancellationVC: BookingTopNavBarWithSubtitleDelegate {
    func rightButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension HotelCancellationVC: BookingReschedulingHeaderViewDelegate {
    
    func headerViewTapped(_ view: UITableViewHeaderFooterView) {
        if !self.viewModel.isAllRoomSelected {
            for index in 0...(self.viewModel.bookedHotelData.count - 1) {
                self.viewModel.bookedHotelData[index].isChecked = true
                printDebug(self.viewModel.bookedHotelData[index].isChecked)
            }
        } else {
            for index in 0...(self.viewModel.bookedHotelData.count - 1) {
                self.viewModel.bookedHotelData[index].isChecked = false
                printDebug(self.viewModel.bookedHotelData[index].isChecked)
            }
        }
        self.viewModel.isAllRoomSelected = !self.viewModel.isAllRoomSelected
        self.isAnyRoomSelected()
        self.hotelCancellationTableView.reloadData()
    }
}

extension HotelCancellationVC: HotelCancellationRoomInfoTableViewCellDelegate {
    
    func selectRoomForCancellation(for indexPath: IndexPath) {
        self.viewModel.bookedHotelData[indexPath.row].isChecked = !self.viewModel.bookedHotelData[indexPath.row].isChecked
        printDebug("\(indexPath)\(self.viewModel.bookedHotelData[indexPath.row].isChecked)")
        self.viewModel.isAllRoomSelected = self.allRoomIsSelectedOrNot()
        self.isAnyRoomSelected()
        self.hotelCancellationTableView.reloadData()
    }
    
    func cellExpand(for indexPath: IndexPath) {
        self.viewModel.bookedHotelData[indexPath.row].isExpanded = !self.viewModel.bookedHotelData[indexPath.row].isExpanded
        printDebug("\(indexPath)\(self.viewModel.bookedHotelData[indexPath.row].isExpanded)")
        self.isAnyRoomSelected()
        self.hotelCancellationTableView.reloadData()
    }
}

