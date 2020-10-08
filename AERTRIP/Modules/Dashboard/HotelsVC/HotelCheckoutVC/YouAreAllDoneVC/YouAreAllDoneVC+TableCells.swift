//
//  YouAreAllDoneVC+TableCells.swift
//  AERTRIP
//
//  Created by Admin on 26/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//Mark:- UITableView Cell
//=======================
extension YouAreAllDoneVC {
    
    /* AllDone Section Cells */
    internal func getAllDoneCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YouAreAllDoneTableViewCell.reusableIdentifier, for: indexPath) as? YouAreAllDoneTableViewCell else { return nil }
        cell.configCell(forBookingId: self.viewModel.hotelReceiptData?.booking_number ?? "", forCid: self.viewModel.cId.first ?? LocalizedString.na.localized, isBookingPending: (self.viewModel.hotelReceiptData?.booking_status ?? .pending) == .pending)
        cell.delegate = self
        cell.addToAppleWalletButton.isLoading = self.viewModel.showWaletLoader
        return cell
    }
    
    internal func getEventSharedCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventAdddedTripTableViewCell.reusableIdentifier, for: indexPath) as? EventAdddedTripTableViewCell else { return nil }
        
        cell.configCell(tripName: self.viewModel.hotelReceiptData?.trip_details?.name ?? "")
        cell.changeBtnHandler = {[weak self] in
            guard let strongSelf = self else {return}
            AppFlowManager.default.selectTrip(strongSelf.viewModel.hotelReceiptData?.trip_details, tripType: .bookingTripChange, presentingStatusBarStyle: strongSelf.statusBarStyle, dismissalStatusBarStyle: strongSelf.statusBarStyle) { [weak self] (tripModel, tripDetail) in
                guard let strongSelf = self else {return}
                printDebug(tripDetail)
                if let detail = tripDetail {
                    strongSelf.viewModel.hotelReceiptData?.trip_details = detail
                    strongSelf.allDoneTableView.reloadData()
                }
            }
        }
        return cell
    }
    
    /* BookingDetails Section Cells */
    internal func getRatingCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCHotelRatingTableViewCell.reusableIdentifier, for: indexPath) as? HCHotelRatingTableViewCell else { return nil }
        cell.configCell(hotelName: self.viewModel.hotelReceiptData?.hname ?? "", hotelRating: self.viewModel.hotelReceiptData?.star ?? 0.0, tripAdvisorRating: self.viewModel.hotelReceiptData?.rating ?? 0.0)
        return cell
    }
    
    internal func getAddressCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCHotelAddreesCell.reusableIdentifier, for: indexPath) as? HCHotelAddreesCell else { return nil }
        cell.hcConfigureAddressCell(address: self.viewModel.hotelReceiptData?.address ?? "")
        cell.setupForAllDoneVC()
        cell.moreBtnOutlet.isHidden = true
        cell.deviderView.isHidden = true
        cell.addressInfoTextView.isUserInteractionEnabled = false
        return cell
    }
    
    internal func getPhoneCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCPhoneTableViewCell.reusableIdentifier, for: indexPath) as? HCPhoneTableViewCell else { return nil }
        cell.configCell(countryImage: #imageLiteral(resourceName: "ne"), phoneNumber: "+91 1234567890")
        return cell
    }
    
    internal func getWebSiteCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsInclusionTableViewCell.reusableIdentifier, for: indexPath) as? HotelDetailsInclusionTableViewCell else { return nil }
        cell.configureWebsiteCell(website: "www.ramadapowai.com")
        return cell
    }
    
    internal func getCheckInOutCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCCheckInOutTableViewCell.reusableIdentifier, for: indexPath) as? HCCheckInOutTableViewCell else { return nil }
        cell.topDividerView.isHidden = self.viewModel.sectionData[indexPath.section].contains(.webSiteCell) ? true : false
        cell.configCell(checkInDate: self.viewModel.hotelReceiptData?.checkin ?? "", checkOutDate: self.viewModel.hotelReceiptData?.checkout ?? "", totalNights: self.viewModel.hotelReceiptData?.num_nights ?? 0)
        cell.setupForAllDoneVC()
        return cell
    }
    
    /* Guest Sections Cells */
    internal func getBedDetailsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCBedDetailsTableViewCell.reusableIdentifier, for: indexPath) as? HCBedDetailsTableViewCell else { return nil }
        let index: String = (self.viewModel.hotelReceiptData?.rooms.count ?? 0 > 0) ? "\(indexPath.section - 1)" : ""
        if let passenger = self.viewModel.hotelReceiptData?.travellers[indexPath.section - 2] {
        cell.configCell(roomData: self.viewModel.hotelReceiptData?.rooms[indexPath.row] ?? Room(), index: index, passengers: passenger)
        }
        let isLast = (self.viewModel.hotelReceiptData?.travellers.count ?? 0) ==  (indexPath.section - 1)
        cell.setupForLastCell(isLastCell: isLast)
        return cell
    }
    
    internal func getBedTypeCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsInclusionTableViewCell.reusableIdentifier, for: indexPath) as? HotelDetailsInclusionTableViewCell else { return nil }
        cell.configHCBedsCell(bedDetails: "2 Single Beds")
        return cell
    }
    
    
    internal func getInclusionCell(_ tableView: UITableView, indexPath: IndexPath, roomData: Room) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsInclusionTableViewCell.reusableIdentifier, for: indexPath) as? HotelDetailsInclusionTableViewCell else { return nil }
        cell.configHCInclusionCell(roomInclusions: roomData.inclusions)
        return cell
    }
    
    internal func getOtherInclusionCell(_ tableView: UITableView, indexPath: IndexPath, roomData: Room) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsInclusionTableViewCell.reusableIdentifier, for: indexPath) as? HotelDetailsInclusionTableViewCell else { return nil }
        cell.configHCOtherInlusionCell(roomInclusions: roomData.inclusions)
        return cell
    }
    
    internal func getCancellationCell(_ tableView: UITableView, indexPath: IndexPath, roomData: Room) -> HotelDetailsCancelPolicyTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
        cell.fullHCPenaltyDetails(isRefundable: self.viewModel.hotelReceiptData?.isRefundable ?? false , isHotelDetailsScreen: false)
        cell.delegate = self
        cell.clipsToBounds = true
        if self.allIndexPath.contains(indexPath) {
            cell.allDetailsLabel.isHidden = false
            cell.allDetailsLabel.attributedText = cell.HCPenaltyDetailsExplanation(canclNotes: roomData.cancellation_policy)
            cell.infoBtnOutlet.isHidden = true
        }
        else {
            cell.infoBtnOutlet.isHidden = false
            cell.allDetailsLabel.isHidden = true
            cell.allDetailsLabel.attributedText = nil
        }
        return cell
    }
    
    internal func getPaymentInfoCell(_ tableView: UITableView, indexPath: IndexPath, roomData: Room) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
        cell.delegate = self
        cell.clipsToBounds = true
        cell.configureHCPaymentCell(isHotelDetailsScreen: false)
        return cell
    }
    
    internal func getNotesCell(_ tableView: UITableView, indexPath: IndexPath, roomData: Room) -> UITableViewCell? {
        if let notesInclusion =  roomData.inclusions[APIKeys.notes_inclusion.rawValue] as? [String], !notesInclusion.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
            cell.delegate = self
            cell.configureHCNotesCell(notesInclusion: notesInclusion, isHotelDetailsScreen: false)
            if self.allIndexPath.contains(indexPath) {
                cell.descriptionLabel.text = ""
                cell.clipsToBounds = true
                cell.allDetailsLabel.isHidden = false
               // cell.moreInfoContainerView.isHidden = true
                cell.allDetailsLabel.attributedText = cell.fullHCNotesDetails(notesInclusion: notesInclusion).trimWhiteSpace()
              //  cell.moreBtnOutlet.isHidden = true
            }
            else {
              //  cell.moreInfoContainerView.isHidden = false
                cell.allDetailsLabel.isHidden = true
                cell.allDetailsLabel.attributedText = nil
              //  cell.moreBtnOutlet.isHidden = false
            }
            return cell
        }
        return nil
    }
    
    internal func getGuestsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCGuestsTableViewCell.reusableIdentifier, for: indexPath) as? HCGuestsTableViewCell else { return nil }
        cell.delegate = self
        cell.travellers = self.viewModel.hotelReceiptData?.travellers[indexPath.section - 2] ?? [TravellersList]()
        cell.guestsCollectionView.reloadData()
        return cell
    }
    
    /* TotalCharge Section Cells */
    internal func getTotalChargeCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCTotalChargeTableViewCell.reusableIdentifier, for: indexPath) as? HCTotalChargeTableViewCell else { return nil }
        cell.dividerView.isHidden = self.viewModel.sectionData[indexPath.section].contains(.confirmationVoucherCell) ? false : true
        cell.configCell(mode: self.viewModel.hotelReceiptData?.payment_details?.mode ?? "", totalCharge: (self.viewModel.hotelReceiptData?.payment_details?.info?.payment_amount ?? 0.0).amountInDelimeterWithSymbol)
        return cell
    }
    
    internal func getConfirmationVoucherCell(_ tableView: UITableView, indexPath: IndexPath) -> HCConfirmationVoucherTableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCConfirmationVoucherTableViewCell.reusableIdentifier, for: indexPath) as? HCConfirmationVoucherTableViewCell else { return nil }
        cell.configCell()
        return cell
    }
    
    internal func getWhatNextCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCWhatNextTableViewCell.reusableIdentifier, for: indexPath) as? HCWhatNextTableViewCell else { return nil }
        cell.delegate = self
        guard let receipt = self.viewModel.hotelReceiptData else{return cell}
        let whtNextNew = receipt.whatNext.filter{$0.product != ""}
        cell.suggetionImage = #imageLiteral(resourceName: "hotel_green_icon")
        cell.configCellwith(whtNextNew, usedFor: "hotel", isNeedToAdd: !self.viewModel.bookingIds.isEmpty)
        cell.whatNextStackView.isHidden = self.viewModel.bookingIds.isEmpty
        cell.selectedWhatNext = {[weak self] index in
            self?.tapOnSeletedWhatNext(index: index)
        }
        return cell
    }
}
