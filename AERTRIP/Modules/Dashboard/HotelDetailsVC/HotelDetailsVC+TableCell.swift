//
//  HotelFilterResultsVC+TableCell.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//Mark:- Hotel TableView Cells
//============================
extension HotelDetailsVC {
    
    internal func getImageSlideCellWithInfo(indexPath: IndexPath, hotelInfo: HotelSearched) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell  else { return UITableViewCell() }
        cell.configCell(hotelData: hotelInfo)
        return cell
    }
    
    internal func getHotelRatingCellWithInfo(indexPath: IndexPath, hotelInfo: HotelSearched) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelRatingInfoCell", for: indexPath) as? HotelRatingInfoCell  else { return UITableViewCell() }
        if let placeData = self.viewModel.placeModel {
            cell.configureCell(hotelData: hotelInfo, placeData: placeData)
        } else {
            cell.configureCell(hotelData: hotelInfo)
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
        cell.configCellForHotelDetail(hotelData: hotelDetails)
        return cell
    }
    
   internal func getHotelRatingInfoCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelRatingInfoCell", for: indexPath) as? HotelRatingInfoCell  else { return UITableViewCell() }
        if let hotelDetails = self.viewModel.hotelInfo, let placeData = self.viewModel.placeModel {
            cell.configureCell(hotelData: hotelDetails, placeData: placeData)
        } else if let hotelInfo = self.viewModel.hotelInfo {
            cell.configureCell(hotelData: hotelInfo)
        }
        return cell
    }
    
   internal func getHotelInfoAddressCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
        cell.configureAddressCell(hotelData: hotelDetails)
        return cell
    }
    
   internal func getHotelOverViewCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
        cell.configureOverviewCell(hotelData: hotelDetails)
        return cell
    }
    
   internal func getHotelDetailsAmenitiesCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailAmenitiesCell", for: indexPath) as? HotelDetailAmenitiesCell  else { return UITableViewCell() }
        cell.amenitiesDetails = hotelDetails.amenities
        return cell
    }
    
   internal func getTripAdviserCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "TripAdvisorTableViewCell", for: indexPath) as? TripAdvisorTableViewCell  else { return UITableViewCell() }
        return cell
    }
    
   internal func getBedDeailsCell(indexPath: IndexPath, ratesData: Rates , roomData: [RoomsRates: Int]) -> UITableViewCell? {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsBedsTableViewCell", for: indexPath) as? HotelDetailsBedsTableViewCell  else { return nil }
        let key = Array(roomData.keys)[indexPath.row]
        let value = roomData[key]
        var isOnlyOneRoom: Bool = false
        if roomData.count == 1 && value == 1 {
            isOnlyOneRoom = true
        } else {
            isOnlyOneRoom = false
        }
        cell.configCell(numberOfRooms: value ?? 0 , roomData: key, isOnlyOneRoom: isOnlyOneRoom)
        if indexPath.row == 0 {
            cell.containerView.roundTopCornersByClipsToBounds(cornerRadius: 10.0)
            //            cell.containerView.shadowOnHotelDetailsTabelCell(color: AppColors.themeGray20, offset: CGSize(width: 0.0, height: 5.0), opacity: 0.7, shadowRadius: 6.0
        } else if indexPath.row == roomData.count - 1 {
            cell.containerView.roundTopCornersByClipsToBounds(cornerRadius: 0.0)
            cell.deviderView.isHidden = false
        }
        return cell
    }
    
   internal func getInclusionCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        if let boardInclusion =  ratesData.inclusion_array[APIKeys.boardType.rawValue] as? [String], !boardInclusion.isEmpty {
            guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
            cell.configureCell(ratesData: ratesData)
            return cell
        } else if let internetInclusion =  ratesData.inclusion_array[APIKeys.internet.rawValue] as? [String], !internetInclusion.isEmpty {
            guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
            cell.configureCell(ratesData: ratesData)
            return cell
        }
        return nil
    }
    
   internal func otherInclusionCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        if let otherInclusion =  ratesData.inclusion_array[APIKeys.other_inclusions.rawValue] as? [String], !otherInclusion.isEmpty {
            guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
            cell.configureOtherInclusionCell(otherInclusion: otherInclusion)
            return cell
        }
        return nil
    }
    
   internal func getCancellationCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        if ratesData.cancellation_penalty != nil {
            guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsCancelPolicyTableCell", for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
            cell.configureCancellationCell(ratesData: ratesData)
            cell.delegate = self
            cell.ratesData = ratesData
            cell.currentIndexPath = indexPath
            return cell
        }
        return nil
    }
    
   internal func getPaymentInfoCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsCancelPolicyTableCell", for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
        cell.configurePaymentCell(ratesData: ratesData)
        return cell
        
    }
    
   internal func getNotesCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        if let notesInclusion =  ratesData.inclusion_array[APIKeys.notes_inclusion.rawValue] as? [String], !notesInclusion.isEmpty {
            guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "NotesTableCell", for: indexPath) as? NotesTableCell  else { return nil }
            cell.noteLabel.text = notesInclusion.first
            return cell
        }
        return nil
    }
    
   internal func getCheckOutCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        guard let cell = self.hotelTableView.dequeueReusableCell(withIdentifier: "HotelDetailsCheckOutTableViewCell", for: indexPath) as? HotelDetailsCheckOutTableViewCell  else { return nil }
        cell.hotelFeesLabel.text = LocalizedString.rupeesText.localized + " \(ratesData.price)"
        return cell
    }
}

