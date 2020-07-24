//
//  HotelCheckoutDetailVC+TableCell.swift
//  AERTRIP
//
//  Created by Admin on 29/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

//Mark:- Hotel TableView Cells
//============================
extension HotelCheckoutDetailVC {
    
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
        cell.configureOverviewCell(hotelData: hotelDetails)
        cell.addressInfoTextView.isUserInteractionEnabled = false
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
        cell.clipsToBounds = true
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
            cell.configureOtherInclusionCell(otherInclusion: otherInclusion)
            cell.clipsToBounds = true
            return cell
        }
        return nil
    }
    
    internal func getCancellationCell(indexPath: IndexPath, ratesData: Rates) -> HotelDetailsCancelPolicyTableCell? {
        if ratesData.cancellation_penalty != nil {
            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
            cell.configureCancellationCell(ratesData: ratesData, isHotelDetailsScreen: true)
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
            cell.clipsToBounds = true
            cell.shadowViewBottomConstraints.constant = 0.0
            cell.containerView.layer.cornerRadius = 0
            cell.containerView.layer.maskedCorners = []
            return cell
        }
        return nil
    }
    
    internal func getNotesCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        if let notesInclusion =  ratesData.inclusion_array[APIKeys.notes_inclusion.rawValue] as? [String], !notesInclusion.isEmpty {
            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
            cell.delegate = self
            cell.configureNotesCell(ratesData: ratesData, isHotelDetailsScreen: true)
            cell.allDetailsLabel.isHidden = true
            cell.descriptionLabel.lineBreakMode = .byWordWrapping
            cell.descriptionLabel.attributedText = cell.fullNotesDetails(ratesData: ratesData)?.trimWhiteSpace()
            if self.allIndexPath.contains(indexPath) {
                cell.descriptionLabel.numberOfLines = 0
            }
            else {
                cell.descriptionLabel.numberOfLines = 0
            }
            cell.shadowViewBottomConstraints.constant = 26.0
            cell.containerView.layer.cornerRadius = 10
            cell.containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
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
