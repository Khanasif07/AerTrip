//
//  BookingHotelDetailVC+HelperMethods.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension BookingHotelDetailVC {
    func openMaps() {
        // setting source and destination latitute logitude same for now
        
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.OpenInMaps.localized, LocalizedString.OpenInGoogleMaps.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            if index == 0 {
                // TODO: Need to manage the  and test marker on Map
                AppGlobals.shared.openAppleMap(originLat: "", originLong: "", destLat: self.viewModel.bookingDetail?.bookingDetail?.latitude ?? "", destLong: self.viewModel.bookingDetail?.bookingDetail?.longitude ?? "")
            } else {
                self.openGoogleMapWithMarker()
//                AppGlobals.shared.openGoogleMaps(originLat: "", originLong: "", destLat: self.viewModel.bookingDetail?.bookingDetail?.latitude ?? "", destLong: self.viewModel.bookingDetail?.bookingDetail?.longitude ?? "")
            }
        }
    }
    
    
    
    func openGoogleMapWithMarker(){
        let lat = self.viewModel.bookingDetail?.bookingDetail?.latitude ?? ""
        let long = self.viewModel.bookingDetail?.bookingDetail?.longitude ?? ""
        
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            let urlStr = "comgooglemaps://?q=\(lat),\(long)&zoom=12"
            if let url = URL(string: urlStr), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            AppToast.default.showToastMessage(message: "Google Maps is not installed on your device.")
        }
        
    }
    
    func getCellForFirstSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: // Hotel  Image Slide Cell
            guard let hotelImageSlideCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell else {
                fatalError("HotelDetailsImgSlideCell not found")
            }
            
            hotelImageSlideCell.imageUrls = self.viewModel.bookingDetail?.bookingDetail?.completePhotos ?? []
            hotelImageSlideCell.delegate = self
            hotelImageSlideCell.configCell(imageUrls: self.viewModel.bookingDetail?.bookingDetail?.completePhotos ?? [])
            return hotelImageSlideCell
            
        case 1: // Hotel Name Rating Cell
            guard let hotelNameCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelNameRatingTableViewCell", for: indexPath) as? HotelNameRatingTableViewCell else {
                fatalError("HotelNameRatingTableViewCell not found ")
            }
            hotelNameCell.starRatingViewLeadingConst.constant = 0
            hotelNameCell.mainStackBtmConst.constant = 20.0
            hotelNameCell.configureCell(hoteName: self.viewModel.bookingDetail?.bookingDetail?.hotelName ?? "", starRating: self.viewModel.bookingDetail?.bookingDetail?.hotelStarRating ?? 0.0, tripRating: self.viewModel.bookingDetail?.bookingDetail?.taRating ?? 0.0)
            
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
            checkInCheckOutCell.configureCell(checkInDate: self.viewModel.bookingDetail?.bookingDetail?.checkIn, checkOutDate: self.viewModel.bookingDetail?.bookingDetail?.checkOut, totalNights: self.viewModel.bookingDetail?.bookingDetail?.nights ?? 0)
            return checkInCheckOutCell
        default:
            return UITableViewCell()
        }
    }
    
    func getCellForRoomSection(_ indexPath: IndexPath) -> UITableViewCell {
        guard let roomDetailCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "BookingHDRoomDetailTableViewCell") as? BookingHDRoomDetailTableViewCell else {
            fatalError("BookingHDRoomDetailTableViewCell not found")
        }
        switch indexPath.row {
        case 0: // Beds Cell
            roomDetailCell.configureCell(title: "Beds", text: self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].bedType ?? "")
            return roomDetailCell
            
        case 1: // Inclusion Cell
            roomDetailCell.configureCell(title: "Inclusions", text: self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].includes?.inclusionString ?? "")
            return roomDetailCell
            
        case 2: // Other inclusion cell
            roomDetailCell.configureCell(title: "Other Inclusions", text: self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].includes?.otherInclsionString ?? "")
            return roomDetailCell
        case 3: // Note Cell
            guard let fareInfoNoteCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "FareInfoNoteTableViewCell") as? FareInfoNoteTableViewCell else {
                fatalError("FareInfoNoteTableViewCell not found")
            }
          
            fareInfoNoteCell.isForBookingPolicyCell = false
            fareInfoNoteCell.noteTextViewTopConstraint.constant = 10
            fareInfoNoteCell.noteLabel.text = LocalizedString.Notes.localized
            fareInfoNoteCell.configCell(notes: self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].includes?.notes ?? [])
            return fareInfoNoteCell
            
        case 4: // Guest Cell
            guard let guestCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "BookingHotelsDetailsTravellerTableCell") as? BookingHotelsDetailsTravellerTableCell else {
                fatalError("BookingTravellerTableViewCell not found")
            }
            guestCell.guestDetails = self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].guest ?? []
            guestCell.isForBooking = true
            guestCell.titleLabel.text = LocalizedString.Guests.localized
            guestCell.isToShowBottomView = false
            return guestCell
            
        default: return UITableViewCell()
        }
    }
    
    func getCellForLastSection(_ indexPath: IndexPath) -> UITableViewCell {
        guard let phoneWebCommonCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "BookingHDWebPhoneTableViewCell") as? BookingHDWebPhoneTableViewCell else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            // Address Cell
            guard let cell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell else { return UITableViewCell() }
            cell.deviderView.isHidden = true
            cell.addressLblTopConst.constant = 10.5
            cell.configureAddressCell(isForBooking: true, address: self.viewModel.bookingDetail?.bookingDetail?.hotelAddressDetail ?? "")
            return cell
            
        case 1: // Phone Detail Cell
            phoneWebCommonCell.configureCell(title: "Phone", text: self.viewModel.bookingDetail?.bookingDetail?.phoneDetail ?? "")
            return phoneWebCommonCell
            
        // Website Detail Cell
        case 2:
            phoneWebCommonCell.configureCell(title: "Website", text: self.viewModel.bookingDetail?.bookingDetail?.websiteDetail ?? "")
            return phoneWebCommonCell
        case 3: // Overview Cell
            guard let cell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell else { return UITableViewCell() }
            cell.configureOverviewCell(isForBooking: true, overview: self.viewModel.bookingDetail?.bookingDetail?.overViewData ?? "")
            cell.clipsToBounds = true
            return cell
        case 4: // Amentities Cell
            guard let cell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelDetailAmenitiesCell", for: indexPath) as? HotelDetailAmenitiesCell else { return UITableViewCell() }
            cell.delegate = self
            cell.amenitiesDetails = self.viewModel.bookingDetail?.bookingDetail?.amenities
            return cell
            
        case 5: // Trip Advisor Cell
            guard let cell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "TripAdvisorTableViewCell", for: indexPath) as? TripAdvisorTableViewCell else { return UITableViewCell() }
            
            return cell
        default: return UITableViewCell()
        }
    }
    
    func getHeightForRowSecondSection(_ indexPath: IndexPath) -> CGFloat {
        return [60, 60, 60, UITableView.automaticDimension, 180, UITableView.automaticDimension, UITableView.automaticDimension, UITableView.automaticDimension, UITableView.automaticDimension, UITableView.automaticDimension, UITableView.automaticDimension][indexPath.row]
    }
    
    func getHeightForRowFirstSection(_ indexPath: IndexPath) -> CGFloat {
        return [222.5, 100, UITableView.automaticDimension, 145.0][indexPath.row]
    }
    
    func getHeightForRoomSection(_ indexPath: IndexPath) -> CGFloat {
        let inclusionCellHeight:CGFloat = (self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].includes?.inclusionString == "-") ? 0.0 : 60.0
        let otherInclusionCellHeight:CGFloat =  (self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].includes?.otherInclsionString == "-"  ) ? 0.0 : 60.0
       
        return [60, inclusionCellHeight, otherInclusionCellHeight, (self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].includes?.notes ?? []).isEmpty ? 0 : UITableView.automaticDimension, 187][indexPath.row]
    }
    
    func getHeightForLastSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            // Address Cell
            return (self.viewModel.bookingDetail?.bookingDetail?.hotelAddressDetail ?? "").isEmpty ? 0 : UITableView.automaticDimension
        case 1:
            // Phone detail cell
             return (self.viewModel.bookingDetail?.bookingDetail?.phoneDetail ?? "").isEmpty ? 0 : UITableView.automaticDimension
            
        case 2: // Website
             return (self.viewModel.bookingDetail?.bookingDetail?.websiteDetail ?? "").isEmpty ? 0 : UITableView.automaticDimension
        case 3:// overview
            return (self.viewModel.bookingDetail?.bookingDetail?.overViewData ?? "").isEmpty ? 0 : UITableView.automaticDimension
        case 4: // amentities
            return (self.viewModel.bookingDetail?.bookingDetail?.amenities == nil) ? 0 : 132.0
        case 5:
            return (self.viewModel.bookingDetail?.bookingDetail?.taLocationID.isEmpty ?? false) ? 0 : 46.0
        default:
            return UITableView.automaticDimension
        }
    }
}
