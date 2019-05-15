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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                guard let hotelImageSlideCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell else {
                    fatalError("HotelDetailsImgSlideCell not found")
                }
                hotelImageSlideCell.imageUrls = self.viewModel.hotelData.photos
                hotelImageSlideCell.delegate = self
                hotelImageSlideCell.configCell(imageUrls: self.viewModel.hotelData.photos)
                return hotelImageSlideCell
                
            case 2:
                guard let hotelNameCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelNameRatingTableViewCell", for: indexPath) as? HotelNameRatingTableViewCell else {
                    fatalError("HotelNameRatingTableViewCell not found ")
                }
                hotelNameCell.configureCell(hoteName: self.viewModel.hotelData.hname, starRating: self.viewModel.hotelData.star, tripRating: self.viewModel.hotelData.rating)
                
                return hotelNameCell
                
            case 3: //  booking cancellation policy
                guard let bookingCancellationPolicy = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "BookingCancellationPolicyTableViewCell", for: indexPath) as? BookingCancellationPolicyTableViewCell else {
                    fatalError("BookingCancellationPolicyTableViewCell not found")
                }
                return bookingCancellationPolicy
            default:
                return UITableViewCell()
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0, 1, 2, 3: // Room Cell
                guard let roomDetailCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "BookingHDRoomDetailTableViewCell") as? BookingHDRoomDetailTableViewCell else {
                    fatalError("BookingHDRoomDetailTableViewCell not found")
                }
                
                roomDetailCell.configureCell()
                return roomDetailCell
            case 4: // Note Cell
                guard let fareInfoNoteCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "FareInfoNoteTableViewCell") as? FareInfoNoteTableViewCell else {
                    fatalError("FareInfoNoteTableViewCell not found")
                }
                
                fareInfoNoteCell.noteLabel.text = LocalizedString.Notes.localized
                fareInfoNoteCell.configCell(notes: ["Hello", "Hello", "Hello", "Hello", "Hello", "Hello", "Hello", "Hello"])
                return fareInfoNoteCell
                
            case 5:
                // Address Cell
                guard let cell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell else { return UITableViewCell() }
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
                
            case 10:
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
            return 93.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            guard let headerView = self.hotelDetailTableView.dequeueReusableHeaderFooterView(withIdentifier: "BookingHDRoomDetailHeaderView") as? BookingHDRoomDetailHeaderView else {
                fatalError("BookingHDRoomDetailHeaderView not found ")
            }
           headerView.configureCell()
            return headerView
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 4 { // Address Cell {
                self.openMaps()
            } else if indexPath.row == 8  {  // Overview cell {
         AppFlowManager.default.presentHotelDetailsOverViewVC(overViewInfo: self.viewModel.hotelData.info)
            }
        }
    }
}

// MARK:

extension BookingHotelDetailVC: HotelDetailsImgSlideCellDelegate {
    func hotelImageTapAction(at index: Int) {
        //
        printDebug("implement hotel Image tap action ")
    }
    
    func willShowImage(at index: Int, image: UIImage?) {
        //
        printDebug("implement show image")
    }
}

extension BookingHotelDetailVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

extension BookingHotelDetailVC: HotelDetailAmenitiesCellDelegate {
    func viewAllButtonAction() {
        AppFlowManager.default.showHotelDetailAmenitiesVC(hotelDetails: self.viewModel.hotelData)
    }
}
