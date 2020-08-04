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
    func getCellForFetchtHotelDetail(_ indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let hotelImageSlideCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell else {
                fatalError("HotelDetailsImgSlideCell not found")
            }
            
            hotelImageSlideCell.imageUrls = [""]
            hotelImageSlideCell.delegate = self
            hotelImageSlideCell.configCell(imageUrls: [""])
            hotelImageSlideCell.pageControl.radius = 5.0
            hotelImageSlideCell.pageControl.tintColor = AppColors.themeWhite70
            return hotelImageSlideCell
        case 1:
            guard let hotelNameCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelNameRatingTableViewCell", for: indexPath) as? HotelNameRatingTableViewCell else {
                fatalError("HotelNameRatingTableViewCell not found ")
            }
            hotelNameCell.configureCell(hoteName: self.viewModel.hotelName, starRating: self.viewModel.hotelStarRating, tripRating: self.viewModel.taRating)
            return hotelNameCell
        case 2:
            guard let cell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelDetailsLoaderTableViewCell", for: indexPath) as? HotelDetailsLoaderTableViewCell  else { return UITableViewCell() }
            cell.activityIndicator.startAnimating()
            return cell
        default: return UITableViewCell()
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
            hotelImageSlideCell.pageControl.radius = 5.0
            hotelImageSlideCell.pageControl.tintColor = AppColors.themeWhite70
            return hotelImageSlideCell
            
        case 1: // Hotel Name Rating Cell
            guard let hotelNameCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelNameRatingTableViewCell", for: indexPath) as? HotelNameRatingTableViewCell else {
                fatalError("HotelNameRatingTableViewCell not found ")
            }
            //            hotelNameCell.starRatingViewLeadingConst.constant = 0
            //            hotelNameCell.mainStackBtmConst.constant = 20.0
            //            hotelNameCell.stackViewTopConstraint.constant = 16.0
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
        case 0: // Confirmation No.
            roomDetailCell.configureCell(title: "Confirmation No.", text: self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].bookingId ?? "")
            return roomDetailCell
            
        case 1: // Beds Cell
            roomDetailCell.configureCell(title: "Beds", text: self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].bedType ?? "")
            return roomDetailCell
            
        case 2: // Inclusion Cell
            roomDetailCell.configureCell(title: "Inclusions", text: self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].includes?.inclusionString ?? "")
            return roomDetailCell
            
        case 3: // Other inclusion cell
            roomDetailCell.configureCell(title: "Other Inclusions", text: self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].includes?.otherInclsionString ?? "")
            return roomDetailCell
        case 4: // Note Cell
            guard let fareInfoNoteCell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "FareInfoNoteTableViewCell") as? FareInfoNoteTableViewCell else {
                fatalError("FareInfoNoteTableViewCell not found")
            }
            
            fareInfoNoteCell.isForBookingPolicyCell = false
            fareInfoNoteCell.noteTextViewTopConstraint.constant = 7
            fareInfoNoteCell.noteLabel.text = LocalizedString.Notes.localized
            fareInfoNoteCell.configCell(notes: self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].includes?.notes ?? [],hotelNotes: true)
            fareInfoNoteCell.noteTextView.lineBreakMode = .byWordWrapping
            fareInfoNoteCell.noteTextViewBottomConstraint.constant = 16
            return fareInfoNoteCell
            
        case 5: // Guest Cell
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
            if !(self.viewModel.bookingDetail?.bookingDetail?.phoneDetail ?? "").isEmpty  && !(self.viewModel.bookingDetail?.bookingDetail?.overViewData ?? "").isEmpty {
                cell.deviderView.isHidden = true
            } else if !(self.viewModel.bookingDetail?.bookingDetail?.phoneDetail ?? "").isEmpty {
                cell.deviderView.isHidden = true
            }
            //cell.deviderView.isHidden = true
            cell.addressLblTopConst.constant = 16
            cell.configureAddressCell(isForBooking: true, address: self.viewModel.bookingDetail?.bookingDetail?.hotelAddressDetail ?? "")
            cell.addressInfoTextView.isUserInteractionEnabled = true
            cell.addressInfoTextView.isSelectable = false
            cell.addressInfoTextView.isEditable = false
            return cell
            
        case 1: // Phone Detail Cell
            phoneWebCommonCell.configureCell(title: "Phone", text: self.viewModel.bookingDetail?.bookingDetail?.phoneDetail ?? "")
            if (self.viewModel.bookingDetail?.bookingDetail?.websiteDetail ?? "").isEmpty {
               phoneWebCommonCell.deviderBottomConstraint.constant = 10
            }
            return phoneWebCommonCell
            
        // Website Detail Cell
        case 2:
            phoneWebCommonCell.configureCell(title: "Website", text: self.viewModel.bookingDetail?.bookingDetail?.websiteDetail ?? "")
            phoneWebCommonCell.deviderBottomConstraint.constant = 10
            return phoneWebCommonCell
        case 3: // Overview Cell
            guard let cell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell else { return UITableViewCell() }
            cell.configureOverviewCell(isForBooking: true, overview: self.viewModel.bookingDetail?.bookingDetail?.overViewData ?? "")
            cell.addressInfoTextView.isUserInteractionEnabled = false
//            cell.moreViewBottomConstraint.constant = 20.5
//            cell.dividerBottomConstraint.constant = 0.5
//            cell.deviderView.backgroundColor = AppColors.divider.color
            //cell.clipsToBounds = true
            return cell
        case 4: // Amentities Cell
            guard let cell = self.hotelDetailTableView.dequeueReusableCell(withIdentifier: "HotelDetailAmenitiesCell", for: indexPath) as? HotelDetailAmenitiesCell else { return UITableViewCell() }
            cell.delegate = self
            cell.amenitiesDetails = self.viewModel.bookingDetail?.bookingDetail?.amenities
            cell.dividerView.isHidden = (self.viewModel.bookingDetail?.bookingDetail?.taLocationID.isEmpty ?? false)
            cell.amenitiesTopConstraint.constant = 16
            cell.containerHeightConstraint.constant = 123
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
    
    func getHeightForRowFetchtHotelDetail(_ indexPath: IndexPath) -> CGFloat {
        return [UITableView.automaticDimension, UITableView.automaticDimension,200][indexPath.row]
    }
    
    func getHeightForRowFirstSection(_ indexPath: IndexPath) -> CGFloat {
        return [UITableView.automaticDimension, UITableView.automaticDimension, UITableView.automaticDimension, 104.0][indexPath.row]
    }
    
    func getHeightForRoomSection(_ indexPath: IndexPath) -> CGFloat {
        let inclusionCellHeight:CGFloat = (self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].includes?.inclusionString == "-") ? CGFloat.leastNormalMagnitude : 60.0
        let otherInclusionCellHeight:CGFloat =  (self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].includes?.otherInclsionString == "-"  ) ? CGFloat.leastNormalMagnitude : 60.0
        let confirmationHeight = (self.viewModel.bookingDetail?.bookingStatus ?? .pending) == .booked ? 60 : CGFloat.leastNormalMagnitude
        return [confirmationHeight, 60, inclusionCellHeight, otherInclusionCellHeight, (self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - 1].includes?.notes ?? []).isEmpty ? CGFloat.leastNormalMagnitude : UITableView.automaticDimension, 160][indexPath.row]
    }
    
    func getHeightForLastSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            // Address Cell
            //return (self.viewModel.bookingDetail?.bookingDetail?.hotelAddressDetail ?? "").isEmpty ? CGFloat.leastNormalMagnitude : UITableView.automaticDimension
            
            if let address = self.viewModel.bookingDetail?.bookingDetail?.hotelAddressDetail, !address.isEmpty {
                let text = address + "\nMaps 1234"
                let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 33.0, height: 10000.0))
                return size.height + 46.5
                    + 13  + 2.0//y of textview 46.5 + bottom space 14.0 + 7.0
            }
            return CGFloat.leastNormalMagnitude
        case 1:
            // Phone detail cell
            return (self.viewModel.bookingDetail?.bookingDetail?.phoneDetail ?? "").isEmpty ? CGFloat.leastNormalMagnitude : UITableView.automaticDimension
            
        case 2: // Website
            return (self.viewModel.bookingDetail?.bookingDetail?.websiteDetail ?? "").isEmpty ? CGFloat.leastNormalMagnitude : UITableView.automaticDimension
        case 3:// overview
            //            return (self.viewModel.bookingDetail?.bookingDetail?.overViewData ?? "").isEmpty ? CGFloat.leastNormalMagnitude : UITableView.automaticDimension
            if let info = self.viewModel.bookingDetail?.bookingDetail?.overViewData, !info.isEmpty {
                let textView = UITextView()
                textView.frame.size = CGSize(width: UIDevice.screenWidth - 32.0, height: 100.0)
                textView.font = AppFonts.Regular.withSize(18)
                textView.text = info
                if textView.numberOfLines >= 3{
                    if let lineHeight = textView.font?.lineHeight{
                        return ((3 * lineHeight) + 62)
                    }
                }else{
                    let text = (self.viewModel.bookingDetail?.bookingDetail?.hotelAddressDetail ?? "") + "Maps    "
                    let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
                    return size.height + 46.5
                        + 13.0  + 2.0//y of textview 46.5 + bottom space 14.0 + 7.0
                }
            }
            return CGFloat.leastNormalMagnitude
        case 4: // amentities
            return (self.viewModel.bookingDetail?.bookingDetail?.amenities == nil) ? CGFloat.leastNormalMagnitude : UITableView.automaticDimension
        case 5:
            return (self.viewModel.bookingDetail?.bookingDetail?.taLocationID.isEmpty ?? false) ? CGFloat.leastNormalMagnitude : 46.0
        default:
            return UITableView.automaticDimension
        }
    }
}
