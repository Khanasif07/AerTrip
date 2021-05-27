//
//  HotelCancellationVC+Extensions.swift
//  AERTRIP
//
//  Created by Admin on 05/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension HotelCancellationVC: UITableViewDelegate , UITableViewDataSource {
    
    private func updateViewOnSelection() {
        
        //manage title
        if self.viewModel.selectedRooms.isEmpty {
            self.topNavBar.subTitleLabel.text = LocalizedString.SelectHotelOrRoomsForCancellation.localized
        }
        else {
            self.topNavBar.subTitleLabel.text = "\(self.viewModel.selectedRooms.count) \(LocalizedString.Room.localized.lowercased())\((self.viewModel.selectedRooms.count == 1) ? "" : "s") \(LocalizedString.Selected.localized.lowercased())"
        }
        
        //manage continue button
        if self.viewModel.selectedRooms.isEmpty {
            self.cancellationButtonOutlet.setTitleColor(AppColors.themeWhite.withAlphaComponent(0.5), for: .normal)
            self.cancellationButtonOutlet.isUserInteractionEnabled = false
            self.totalNetRefundContainerView.isHidden = true
        }
        else {
            self.cancellationButtonOutlet.setTitleColor(AppColors.themeWhite.withAlphaComponent(1.0), for: .normal)
            self.cancellationButtonOutlet.isUserInteractionEnabled = true
            self.totalNetRefundContainerView.isHidden = false
            self.totalNetRefundLabelAmountLabel.text = self.viewModel.netRefundAmount.delimiterWithSymbol
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.updateViewOnSelection()
        return self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let rooms = self.viewModel.bookingDetail?.bookingDetail?.roomDetails, let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BookingReschedulingHeaderView") as? BookingReschedulingHeaderView else { return nil }
        headerView.delegate = self
        let image = (rooms.count == self.viewModel.selectedRooms.count) ? AppImages.CheckedGreenRadioButton : AppImages.UncheckedGreenRadioButton
        headerView.selectedButton.setImage(image, for: .normal)
        headerView.routeLabel.text = self.viewModel.hotelName
        headerView.infoLabel.text = self.viewModel.bookingDateAndRefundableStatus
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let rooms = self.viewModel.bookingDetail?.bookingDetail?.roomDetails, let cell = tableView.dequeueReusableCell(withIdentifier: HotelCancellationRoomInfoTableViewCell.reusableIdentifier, for: indexPath) as? HotelCancellationRoomInfoTableViewCell else { return UITableViewCell() }
        cell.delegate = self

        let roomD = rooms[indexPath.row]
        
        let isRoomSelected = self.viewModel.selectedRooms.contains(where: { $0.rid == roomD.rid })
        let isExpanded = self.expandedIndexPaths.contains(indexPath)
        
        cell.configureCell(roomNumber: "\(LocalizedString.Room.localized) \(indexPath.row+1)", roomDetails: roomD, isRoomSelected: isRoomSelected, isExpanded: isExpanded)
        
        cell.topDividerViewLeadingConstraint.constant = (indexPath.row == (rooms.count - 1)) ? 0.0 : 56.0
        cell.bottomDividerViewLeadingConstraint.constant = (indexPath.row == (rooms.count - 1)) ? 0.0 : 56.0
        cell.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.expandedIndexPaths.contains(indexPath), let rooms = self.viewModel.bookingDetail?.bookingDetail?.roomDetails {
            //calculate
            let roomD = rooms[indexPath.row]
            return roomD.guest.map { $0.fullName }.joined(separator: ", ").sizeCount(withFont: AppFonts.Regular.withSize(16.0), bundingSize: CGSize(width: UIDevice.screenWidth - 68.0, height: 10000.0)).height + 173.0
        }
        
        guard let rooms = self.viewModel.bookingDetail?.bookingDetail?.roomDetails else {return 60.5}
        if (indexPath.row == (rooms.count - 1)){
            return (rooms.count == 1) ? 59.8 : 59.5
        }else{
            return 60.5
        }
        //60.5
    }
}

extension HotelCancellationVC: BookingTopNavBarWithSubtitleDelegate {
    func rightButtonAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension HotelCancellationVC: BookingReschedulingHeaderViewDelegate {
    func selectAllButtonAction(_ sender: UIButton) {
        self.updateSelectAll()
    }
    
    func updateSelectAll(){
        guard let rooms = self.viewModel.bookingDetail?.bookingDetail?.roomDetails else { return}
        
        if rooms.count == self.viewModel.selectedRooms.count {
            //deselect all
            self.viewModel.selectedRooms.removeAll()
        }
        else {
            //select all
            self.viewModel.selectedRooms = rooms
        }
        self.hotelCancellationTableView.reloadData()
    }
    
}

extension HotelCancellationVC: HotelCancellationRoomInfoTableViewCellDelegate {
    
    func selectRoomForCancellation(for indexPath: IndexPath) {
        
        guard let rooms = self.viewModel.bookingDetail?.bookingDetail?.roomDetails else { return}

        let roomD = rooms[indexPath.row]
        
        if let idx = self.viewModel.selectedRooms.firstIndex(where: { $0.rid == roomD.rid }) {
            self.viewModel.selectedRooms.remove(at: idx)
        }
        else {
            self.viewModel.selectedRooms.append(roomD)
        }
        self.hotelCancellationTableView.reloadData()
    }
    
    func cellExpand(for indexPath: IndexPath) {

        if let idx = self.expandedIndexPaths.firstIndex(of: indexPath) {
            self.expandedIndexPaths.remove(at: idx)
        }
        else {
            self.expandedIndexPaths.append(indexPath)
        }
        self.hotelCancellationTableView.reloadData()
    }
}

