//
//  HotelFilterResultsVC+TableCell.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//MARK:- Hotel TableView Cells
//MARK:-
extension HotelDetailsVC {
    
    internal func getImageSlideCellWithInfo(indexPath: IndexPath, hotelInfo: HotelSearched) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell  else { return UITableViewCell() }
        if let imageUrls = hotelInfo.thumbnail {
            cell.imageUrls = imageUrls
            cell.configCell(imageUrls: imageUrls)
        }
        cell.delegate = self
        return cell
    }
    
    internal func getHotelRatingCellWithInfo(indexPath: IndexPath, hotelInfo: HotelSearched) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelRatingInfoCell", for: indexPath) as? HotelRatingInfoCell  else { return UITableViewCell() }
        if let placeData = self.viewModel.placeModel {
            cell.configureCell(hotelData: hotelInfo, placeData: placeData)
        }
        return cell
    }
    
    internal func getLoaderCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsLoaderTableViewCell", for: indexPath) as? HotelDetailsLoaderTableViewCell  else { return UITableViewCell() }
        cell.activityIndicator.startAnimating()
        return cell
    }
    
    internal func getImageSlideCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell  else { return UITableViewCell() }
        cell.imageUrls = hotelDetails.photos
        cell.delegate = self
        cell.configCell(imageUrls: hotelDetails.photos)
        return cell
    }
    
    internal func getHotelRatingInfoCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelRatingInfoCell", for: indexPath) as? HotelRatingInfoCell  else { return UITableViewCell() }
        cell.delegate = self
        if let hotelDetails = self.viewModel.hotelInfo, let placeData = self.viewModel.placeModel {
            cell.configureCell(hotelData: hotelDetails, placeData: placeData)
        }
        return cell
    }
    
    internal func getHotelInfoAddressCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
        cell.configureAddressCell(hotelData: hotelDetails)
        cell.addressInfoTextView.isUserInteractionEnabled = true
        cell.addressInfoTextView.isSelectable = false
        cell.addressInfoTextView.isEditable = false
        return cell
    }
    
    internal func getHotelOverViewCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
//        cell.addressInfoTextView.isSelectable = false
        cell.configureOverviewCell(hotelData: hotelDetails)
        return cell
    }
    
    internal func getHotelDetailsAmenitiesCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailAmenitiesCell", for: indexPath) as? HotelDetailAmenitiesCell  else { return UITableViewCell() }
        cell.delegate = self
        cell.amenitiesDetails = hotelDetails.amenities
        if self.viewModel.hotelDetailsTableSectionData[0].contains(.tripAdvisorRatingCell) {
            cell.dividerViewLeadingCons.constant = 16.0
            cell.dividerViewTrailingCons.constant = 16.0
        } else {
            cell.dividerViewLeadingCons.constant = 0.0
            cell.dividerViewTrailingCons.constant = 0.0
        }
        return cell
    }
    
    internal func getTripAdviserCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "TripAdvisorTableViewCell", for: indexPath) as? TripAdvisorTableViewCell  else { return UITableViewCell() }
        return cell
    }
    
    internal func getSearchBarTagCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsSearchTagTableCell") as? HotelDetailsSearchTagTableCell  else { return UITableViewCell() }
        cell.availableTagsForFilterartion = self.viewModel.permanentTagsForFilteration
        if let amenities = hotelDetails.amenities {
            let tags = amenities.basic + amenities.other
            cell.allTagsForFilteration = tags
        }
        cell.tagCollectionView.reloadData()
        return cell
    }
    
    internal func getBedDeailsCell(indexPath: IndexPath, ratesData: Rates , roomData: [RoomsRates: Int]) -> UITableViewCell? {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsBedsTableViewCell", for: indexPath) as? HotelDetailsBedsTableViewCell  else { return nil }
        
        cell.delegate = self
        let key = Array(roomData.keys)[indexPath.row]
        let value = roomData[key]
        var isOnlyOneRoom: Bool = false
        if roomData.count == 1 && value == 1 {
            isOnlyOneRoom = true
        } else {
            isOnlyOneRoom = false
        }
        cell.configCell(numberOfRooms: value ?? 0 , roomData: key, isOnlyOneRoom: isOnlyOneRoom)
        if roomData.count == 1 {
            cell.showHideSetUp(cornerRaduis: 10.0, bookmarkBtnHidden: false, dividerViewHidden: false)
        } else {
            if indexPath.row == 0 {
                cell.showHideSetUp(cornerRaduis: 10.0, bookmarkBtnHidden: false, dividerViewHidden: true)
            } else if indexPath.row < roomData.count - 1 {
                cell.showHideSetUp(cornerRaduis: 0.0, bookmarkBtnHidden: true, dividerViewHidden: true)
            } else {
                cell.showHideSetUp(cornerRaduis: 0.0, bookmarkBtnHidden: true, dividerViewHidden: false)
            }
        }
        cell.clipsToBounds = true
        return cell
    }
    
    internal func getInclusionCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        if let boardInclusion =  ratesData.inclusion_array[APIKeys.boardType.rawValue] as? [String], !boardInclusion.isEmpty {
            guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
            cell.configureCell(ratesData: ratesData)
            cell.clipsToBounds = true
            return cell
        } else if let internetInclusion =  ratesData.inclusion_array[APIKeys.internet.rawValue] as? [String], !internetInclusion.isEmpty {
            guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
            cell.configureCell(ratesData: ratesData)
            cell.clipsToBounds = true
            return cell
        }
        return nil
    }
    
    internal func otherInclusionCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        if let otherInclusion =  ratesData.inclusion_array[APIKeys.other_inclusions.rawValue] as? [String], !otherInclusion.isEmpty {
            guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
            cell.configureOtherInclusionCell(otherInclusion: otherInclusion)
            cell.clipsToBounds = true
            return cell
        }
        return nil
    }
    
    internal func getCancellationCell(indexPath: IndexPath, ratesData: Rates) -> HotelDetailsCancelPolicyTableCell? {
        if ratesData.cancellation_penalty != nil {
            guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
            cell.configureCancellationCell(ratesData: ratesData, isHotelDetailsScreen: true)
            cell.delegate = self
            if self.allIndexPath.contains(indexPath) {
                cell.allDetailsLabel.isHidden = false
                cell.allDetailsLabel.attributedText = cell.fullPenaltyDetails(ratesData: ratesData)?.trimWhiteSpace()
                cell.infoBtnOutlet.isHidden = true
            }
            else {
                cell.allDetailsLabel.isHidden = true
                cell.allDetailsLabel.attributedText = nil
            }
            cell.clipsToBounds = true
            return cell
        }
        return nil
    }
    
    internal func getPaymentInfoCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
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
        cell.clipsToBounds = true
        return cell
    }
    
    internal func getNotesCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        if let notesInclusion =  ratesData.inclusion_array[APIKeys.notes_inclusion.rawValue] as? [String], !notesInclusion.isEmpty {
            guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
            cell.delegate = self
            cell.configureNotesCell(ratesData: ratesData, isHotelDetailsScreen: true)
            if self.allIndexPath.contains(indexPath) {
                cell.descriptionLabel.text = ""
                cell.allDetailsLabel.isHidden = false
                cell.moreInfoContainerView.isHidden = true
                cell.allDetailsLabel.attributedText = cell.fullNotesDetails(ratesData: ratesData)?.trimWhiteSpace()
                cell.moreBtnOutlet.isHidden = true
            }
            else {
                cell.moreInfoContainerView.isHidden = false
                cell.allDetailsLabel.isHidden = true
                cell.allDetailsLabel.attributedText = nil
                cell.moreBtnOutlet.isHidden = false
            }
            cell.clipsToBounds = true
            return cell
        }
        return nil
    }
    
    internal func getCheckOutCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsCheckOutTableViewCell", for: indexPath) as? HotelDetailsCheckOutTableViewCell  else { return nil }
        cell.shadowViewBottomConstraints.constant = (indexPath.section  == self.viewModel.hotelDetailsTableSectionData.count - 1 ) ? 16.0 : 8.0
        cell.hotelFeesLabel.text = ratesData.price.amountInDelimeterWithSymbol
        cell.clipsToBounds = true
        return cell
    }
    
    internal func getHotelDetailsEmptyStateCell(indexPath: IndexPath) -> HotelDetailsEmptyStateTableCell? {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: HotelDetailsEmptyStateTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsEmptyStateTableCell  else { return nil }
        return cell
    }
}
