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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else if section == 1 {
            return 11
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return getHeightForRowSecondSection(indexPath)
        } else {
            return getHeightForRowFirstSection(indexPath)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: // Hotel  Image Slide Cell
                guard let hotelImageSlideCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell else {
                    fatalError("HotelDetailsImgSlideCell not found")
                }
                hotelImageSlideCell.imageUrls = self.viewModel.hotelData.photos
                hotelImageSlideCell.delegate = self
                hotelImageSlideCell.configCell(imageUrls: self.viewModel.hotelData.photos)
                return hotelImageSlideCell
                
            case 1: // Hotel Name Rating Cell
                guard let hotelNameCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelNameRatingTableViewCell", for: indexPath) as? HotelNameRatingTableViewCell else {
                    fatalError("HotelNameRatingTableViewCell not found ")
                }
                hotelNameCell.configureCell(hoteName: self.viewModel.hotelData.hname, starRating: self.viewModel.hotelData.star, tripRating: self.viewModel.hotelData.rating)
                
                return hotelNameCell
                
            case 2: //  booking cancellation policy cell
                guard let bookingCancellationPolicy = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "BookingCancellationPolicyTableViewCell", for: indexPath) as? BookingCancellationPolicyTableViewCell else {
                    fatalError("BookingCancellationPolicyTableViewCell not found")
                }
                bookingCancellationPolicy.delegate = self
                return bookingCancellationPolicy
                
            case 3: // Hotel checkin chekcout cell
                guard let checkInCheckOutCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "BookingCheckinCheckOutTableViewCell") as? BookingCheckinCheckOutTableViewCell else {
                     fatalError("BookingCheckinCheckOutTableViewCell not found")
                }
                checkInCheckOutCell.configureCell()
                return checkInCheckOutCell
             default:
                return UITableViewCell()
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0, 1, 2: // Room Cell
                guard let roomDetailCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "BookingHDRoomDetailTableViewCell") as? BookingHDRoomDetailTableViewCell else {
                    fatalError("BookingHDRoomDetailTableViewCell not found")
                }                
                roomDetailCell.configureCell()
                return roomDetailCell
            case 3: // Note Cell
                guard let fareInfoNoteCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "FareInfoNoteTableViewCell") as? FareInfoNoteTableViewCell else {
                    fatalError("FareInfoNoteTableViewCell not found")
                }
                fareInfoNoteCell.isForBookingPolicyCell = false
                fareInfoNoteCell.noteLabel.text = LocalizedString.Notes.localized
                fareInfoNoteCell.configCell(notes: ["Hello", "Hello", "Hello", "Hello", "Hello", "Hello", "Hello", "Hello"])
                return fareInfoNoteCell
                
            case 4: // Guest Cell
                guard let guestCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "BookingTravellerTableViewCell") as? BookingTravellerTableViewCell else {
                    fatalError("BookingTravellerTableViewCell not found")
                }
                guestCell.titleLabel.text = LocalizedString.Guests.localized
                return guestCell
            case 5:
                // Address Cell
                guard let cell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell else { return UITableViewCell() }
                cell.deviderView.isHidden = true
                cell.configureAddressCell(hotelData: self.viewModel.hotelData)
                return cell
                
            case 6, 7: // Phone web Cell
                guard let cell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "BookingHDWebPhoneTableViewCell", for: indexPath) as? BookingHDWebPhoneTableViewCell else { return UITableViewCell() }
                cell.configureCell()
                return cell
                
            case 8: // Overview Cell
                guard let cell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell else { return UITableViewCell() }
                cell.configureOverviewCell(hotelData: self.viewModel.hotelData)
                return cell
            case 9: // Amentities Cell
                guard let cell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelDetailAmenitiesCell", for: indexPath) as? HotelDetailAmenitiesCell else { return UITableViewCell() }
                cell.delegate = self
                cell.amenitiesDetails = self.viewModel.hotelData.amenities
                
                return cell
                
            case 10: // Trip Advisor Cell
                guard let cell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "TripAdvisorTableViewCell", for: indexPath) as? TripAdvisorTableViewCell else { return UITableViewCell() }
                
                return cell
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
             return 35.0
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            guard let headerView = self.hotelDetailTableView.dequeueReusableHeaderFooterView(withIdentifier: "BookingHDRoomDetailHeaderView") as? BookingHDRoomDetailHeaderView else {
                fatalError("BookingHDRoomDetailHeaderView not found ")
            }
            headerView.configureCell()
            return headerView
        }
        
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
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
                AppFlowManager.default.presentHotelDetailsOverViewVC(overViewInfo: self.viewModel.hotelData.info)
            } else if indexPath.row == 10 {
                let locid = self.viewModel.hotelData.locid
                AppFlowManager.default.presentHotelDetailsTripAdvisorVC(hotelId: self.viewModel.hotelData.hid)
                printDebug(locid + "location id is empty")
            }
        } else {
            if indexPath.row == 1 {
                AppFlowManager.default.moveToVoucherVC()
            } else if indexPath.row == 3 {
                AppFlowManager.default.moveToAddOnRequestVC(self.viewModel.hotelData)
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
    func viewAllButtonAction() {
        AppFlowManager.default.showHotelDetailAmenitiesVC(hotelDetails: self.viewModel.hotelData)
    }
}

// Booking Cancellation policy Delegate methods

extension BookingHotelDetailVC: BookingCancellationPolicyTableViewCellDelegate {
    func bookingPolicyButtonTapped() {
        AppFlowManager.default.presentPolicyVC(.bookingPolicy)
    }
    
    func cancellationPolicyButonTapped() {
        AppFlowManager.default.presentPolicyVC(.cancellationPolicy)
    }
}



// Booking Select trip Trip

extension BookingHotelDetailVC: SelectTripVCDelegate {
    func selectTripVC(sender: SelectTripVC, didSelect trip: TripModel, tripDetails: TripDetails?) {
        //
    }
    
    
}
