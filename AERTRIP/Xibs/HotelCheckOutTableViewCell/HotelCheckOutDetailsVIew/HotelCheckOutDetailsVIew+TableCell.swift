//
//  HotelCheckOutDetailsVIew+TableCell.swift
//  AERTRIP
//
//  Created by Admin on 02/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//Mark:- Hotel TableView Cells
//============================
extension HotelCheckOutDetailsVIew {
    
    internal func getImageSlideCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell  else { return UITableViewCell() }
        cell.imageUrls = hotelDetails.photos
        cell.delegate = self
        cell.configCell(imageUrls: hotelDetails.photos)
        return cell
    }

    internal func getHotelRatingInfoCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HCDataHotelRatingInfoTableViewCell", for: indexPath) as? HCDataHotelRatingInfoTableViewCell  else { return UITableViewCell() }
        cell.delegate = self
        if let hotelDetails = self.viewModel, let placeData = self.placeModel {
            cell.configHCDetailsCell(hotelData: hotelDetails, placeData: placeData)
        }
        return cell
    }
    
    internal func getHotelInfoAddressCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
        cell.addressInfoTextView.isUserInteractionEnabled = false
        cell.configureAddressCell(hotelData: hotelDetails)
        return cell
    }
    
    internal func getHotelOverViewCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
        cell.addressInfoTextView.isUserInteractionEnabled = false
        cell.configureOverviewCell(hotelData: hotelDetails)
        return cell
    }
    
    internal func getHotelDetailsAmenitiesCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailAmenitiesCell", for: indexPath) as? HotelDetailAmenitiesCell  else { return UITableViewCell() }
        cell.delegate = self
        cell.amenitiesDetails = hotelDetails.amenities
        if self.sectionData[0].contains(.tripAdvisorRatingCell) {
            cell.dividerViewLeadingCons.constant = 16.0
            cell.dividerViewTrailingCons.constant = 16.0
        } else {
            cell.dividerViewLeadingCons.constant = 0.0
            cell.dividerViewTrailingCons.constant = 0.0
        }
        return cell
    }
    
    internal func getTripAdviserCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "TripAdvisorTableViewCell", for: indexPath) as? TripAdvisorTableViewCell  else { return UITableViewCell() }
        return cell
    }
    
    internal func getBedDeailsCell(indexPath: IndexPath, ratesData: Rates , roomData: [RoomsRates: Int]) -> UITableViewCell? {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsBedsTableViewCell", for: indexPath) as? HotelDetailsBedsTableViewCell  else { return nil }
////        cell.delegate = self
////        let key = Array(roomData.keys)[indexPath.row]
////        let value = roomData[key]
//        let key = Array(roomData)[indexPath.row].key
//        let value = Array(roomData)[indexPath.row].value
//        var isOnlyOneRoom: Bool = false
//        if roomData.count == 1 && value == 1 {
//            isOnlyOneRoom = true
//        } else {
//            isOnlyOneRoom = false
//        }
//        cell.configCell(numberOfRooms: value , roomData: key, isOnlyOneRoom: isOnlyOneRoom)
//        if roomData.count == 1 {
//            cell.showHideSetUp(cornerRaduis: 10.0, bookmarkBtnHidden: true, dividerViewHidden: false)
//        } else {
//            if indexPath.row == 0 {
//                cell.showHideSetUp(cornerRaduis: 10.0, bookmarkBtnHidden: true, dividerViewHidden: true)
//            } else if indexPath.row < roomData.count - 1 {
//                cell.showHideSetUp(cornerRaduis: 0.0, bookmarkBtnHidden: true, dividerViewHidden: true)
//            } else {
//                cell.showHideSetUp(cornerRaduis: 0.0, bookmarkBtnHidden: true, dividerViewHidden: false)
//            }
//        }
//        cell.clipsToBounds = true
        let key = Array(roomData)[0].key
        var isOnlyOneRoom: Bool = false
        if roomData.count == 1 {
            isOnlyOneRoom = true
        } else {
            isOnlyOneRoom = false
        }
        cell.configCell(numberOfRooms: roomData.count , roomData: key, isOnlyOneRoom: isOnlyOneRoom)
        cell.containerView.roundTopCorners(cornerRadius: 10.0)
        cell.bookmarkButtonOutlet.isHidden = true
        cell.deviderView.isHidden = false
        return cell
    }
    
    internal func getInclusionCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        if let boardInclusion =  ratesData.inclusion_array[APIKeys.boardType.rawValue] as? [String], !boardInclusion.isEmpty {
            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
            cell.configureCell(ratesData: ratesData)
            cell.clipsToBounds = true
            return cell
        } else if let internetInclusion =  ratesData.inclusion_array[APIKeys.internet.rawValue] as? [String], !internetInclusion.isEmpty {
            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
            cell.configureCell(ratesData: ratesData)
            cell.clipsToBounds = true
            return cell
        }
        return nil
    }
    
    internal func otherInclusionCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        if let otherInclusion =  ratesData.inclusion_array[APIKeys.other_inclusions.rawValue] as? [String], !otherInclusion.isEmpty {
            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
            var isInclusionPresent = false
            if let boardInclusion =  ratesData.inclusion_array[APIKeys.boardType.rawValue] as? [String], !boardInclusion.isEmpty {
                isInclusionPresent = true
            }else if let internetInclusion =  ratesData.inclusion_array[APIKeys.internet.rawValue] as? [String], !internetInclusion.isEmpty {
                isInclusionPresent = true
            }
            cell.configureOtherInclusionCell(otherInclusion: otherInclusion, isInclusionPresent: isInclusionPresent)
            cell.clipsToBounds = true
            return cell
        }
        return nil
    }
    
    internal func getCancellationCell(indexPath: IndexPath, ratesData: Rates) -> HotelDetailsCancelPolicyTableCell? {
        if ratesData.cancellation_penalty != nil {
            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
            cell.configureCancellationCell(ratesData: ratesData, isHotelDetailsScreen: true)
            cell.containerView.roundBottomCorners(cornerRadius: 0.0)
            cell.delegate = self
            if self.allIndexPath.contains(indexPath) {
                cell.allDetailsLabel.isHidden = false
                cell.allDetailsLabel.attributedText = cell.fullPenaltyDetails(ratesData: ratesData)?.trimWhiteSpace()
                cell.infoBtnOutlet.isHidden = false
            }
            else {
                cell.infoBtnOutlet.isHidden = false
                cell.allDetailsLabel.isHidden = true
                cell.allDetailsLabel.attributedText = nil
            }
            cell.shadowViewBottomConstraints.constant = 0.0
            cell.clipsToBounds = true
            return cell
        }
        return nil
    }
    
    internal func getPaymentInfoCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
        cell.containerView.roundBottomCorners(cornerRadius: 00.0)
        cell.delegate = self
        cell.configurePaymentCell(ratesData: ratesData, isHotelDetailsScreen: true)
        if self.allIndexPath.contains(indexPath) {
            cell.allDetailsLabel.isHidden = false
            cell.allDetailsLabel.attributedText = cell.fullPaymentDetails()?.trimWhiteSpace()
            cell.infoBtnOutlet.isHidden = true
        }
        else {
            cell.allDetailsLabel.isHidden = true
            cell.allDetailsLabel.attributedText = nil
            cell.infoBtnOutlet.isHidden = false
        }
        cell.shadowViewBottomConstraints.constant = 0.0
        cell.clipsToBounds = true
        return cell
    }
    
    internal func getNotesCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        if let notesInclusion =  ratesData.inclusion_array[APIKeys.notes_inclusion.rawValue] as? [String], !notesInclusion.isEmpty {
            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
            cell.containerView.roundBottomCorners(cornerRadius: 10.0)
            cell.delegate = self
            cell.configureNotesCell(ratesData: ratesData, isHotelDetailsScreen: true)
            cell.allDetailsLabel.isHidden = true
            cell.descriptionLabel.lineBreakMode = .byWordWrapping
            cell.descriptionLabel.attributedText = cell.fullNotesDetails(ratesData: ratesData)?.trimWhiteSpace()
            if self.allIndexPath.contains(indexPath) {
               // cell.moreInfoContainerView.isHidden = true
                cell.descriptionLabel.numberOfLines = 0
               // cell.moreBtnOutlet.isHidden = true
            }
            else {
               // cell.moreInfoContainerView.isHidden = false
                cell.descriptionLabel.numberOfLines = 0
               // cell.moreBtnOutlet.isHidden = false
            }
            cell.shadowViewBottomConstraints.constant = 26.0
            cell.clipsToBounds = true
            return cell
        }
        return nil
    }
    
    internal func getCheckInOutCell(_ tableView: UITableView, indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCCheckInOutTableViewCell.reusableIdentifier, for: indexPath) as? HCCheckInOutTableViewCell else { return nil }
        cell.configCell(checkInDate: hotelDetails.checkin, checkOutDate: hotelDetails.checkout, totalNights: hotelDetails.no_of_nights)
        return cell
    }
    
    internal func getRoomCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCRoomTableViewCell.reusableIdentifier, for: indexPath) as? HCRoomTableViewCell else { return nil }
        return cell
    }
}
