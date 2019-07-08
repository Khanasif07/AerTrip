//
//  BookingHotelDetailVC+DelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource and UITableViewDeleagate methods

extension BookingHotelDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        // 2 is added here: one for hotelimages cell,checkInCheckOut,rating and other for Adress,phone,website,overview and amenities
        return 2 + (self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // hotelImages cell,checkInCeckOut,ratings etc
        if section == 0 {
            return 4
            
        // Room data details
        } else if section >= 1, section <= self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0 {
            return 5
           // Adress,phone,website,overview and amenities
        } else if section == ((self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0) + 1) {
            return 5
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height for hotelImages cell,checkInCeckOut,ratings etc
        if indexPath.section == 0 {
            return getHeightForRowFirstSection(indexPath)
            // height for room details cell
        } else if indexPath.section >= 1, indexPath.section <= self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0 {
            return getHeightForRoomSection(indexPath)
            // Adress,phone,website,overview and amenities
        } else if indexPath.section == ((self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0) + 1) {
            return UITableView.automaticDimension
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         // height for hotelImages cell,checkInCeckOut,ratings etc
        if indexPath.section == 0 {
          return getCellForFirstSection(indexPath)
             // height for room details cell
        } else if indexPath.section >= 1, indexPath.section <= self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0 {
            return getCellForRoomSection(indexPath)
            // Adress,phone,website,overview and amenities
        } else if indexPath.section == ((self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0) + 1) {
            return getCellForLastSection(indexPath)
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section >= 1 && section <= self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0   {
            return UITableView.automaticDimension
        } else {
           return 0
        }
    }
    
    // header for footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if  section == ((self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0) + 1) {
            return 35.0
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 93.0
    }
    
    
    
   
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Room Data Header section
        if section >= 1 && section <= self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0  {
            guard let headerView = self.hotelDetailTableView.dequeueReusableHeaderFooterView(withIdentifier: "BookingHDRoomDetailHeaderView") as? BookingHDRoomDetailHeaderView else {
                fatalError("BookingHDRoomDetailHeaderView not found ")
            }
            let roomTitle: String = "\(LocalizedString.Room.localized) \(section) \(((self.viewModel.bookingDetail?.bookingDetail?.roomDetails[section - 1].voucher) ?? "").isEmpty ? "" : "-")  \(self.viewModel.bookingDetail?.bookingDetail?.roomDetails[section - 1].voucher ?? "") "
            headerView.configureHeader(roomTitle: roomTitle, roomType: self.viewModel.bookingDetail?.bookingDetail?.roomDetails[section - 1].roomType ?? "", roomDescription: self.viewModel.bookingDetail?.bookingDetail?.roomDetails[section - 1].description ?? "")
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == ((self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0) + 1) {
            guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as? BookingInfoEmptyFooterView else {
                fatalError("BookingInfoFooterView not found")
            }
            return footerView
           
        }
      
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 5 { // Address Cell {
                self.openMaps()
            } else if indexPath.row == 8 { // Overview cell {
                // AppFlowManager.default.presentHotelDetailsOverViewVC(overViewInfo: self.viewModel.hotelData.info)
            } else if indexPath.row == 10 {
                //   let locid = self.viewModel.hotelData.locid
                //  AppFlowManager.default.presentHotelDetailsTripAdvisorVC(hotelId: self.viewModel.hotelData.hid)
                // printDebug(locid + "location id is empty")
            }
        }
    }
}

// MARK:

extension BookingHotelDetailVC: HotelDetailsImgSlideCellDelegate {
    func hotelImageTapAction(at index: Int) {
        //
        printDebug("implement hotel Image tap action ")
        
        AppFlowManager.default.presentSelectTripVC(delegate: self)
    }
    
    func willShowImage(at index: Int, image: UIImage?) {
        //
        printDebug("implement show image")
    }
}

// Top Navigation View Delegate
extension BookingHotelDetailVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

// HotelDetailAmenitiesCellDelegate methods

extension BookingHotelDetailVC: HotelDetailAmenitiesCellDelegate {
    // TODO: - Amentities data not coming
    func viewAllButtonAction() {
        // AppFlowManager.default.showHotelDetailAmenitiesVC(hotelDetails: self.viewModel.hotelData)
    }
}

// Booking Cancellation policy Delegate methods

extension BookingHotelDetailVC: BookingCancellationPolicyTableViewCellDelegate {
    func bookingPolicyButtonTapped() {
        AppFlowManager.default.presentPolicyVC(.bookingPolicy, bookingDetail: self.viewModel.bookingDetail)
    }
    
    func cancellationPolicyButonTapped() {
        AppFlowManager.default.presentPolicyVC(.cancellationPolicy, bookingDetail: self.viewModel.bookingDetail)
    }
}

// Booking Select trip Trip

extension BookingHotelDetailVC: SelectTripVCDelegate {
    func selectTripVC(sender: SelectTripVC, didSelect trip: TripModel, tripDetails: TripDetails?) {
        //
    }
}
