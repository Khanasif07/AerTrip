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
        cell.configCell()
        return cell
    }
    
    internal func getEventSharedCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventAdddedTripTableViewCell.reusableIdentifier, for: indexPath) as? EventAdddedTripTableViewCell else { return nil }
        cell.configCell()
        return cell
    }
    
    /* BookingDetails Section Cells */
    internal func getRatingCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCHotelRatingTableViewCell.reusableIdentifier, for: indexPath) as? HCHotelRatingTableViewCell else { return nil }
        cell.configCell()
        return cell
    }
    
    internal func getAddressCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelInfoAddressCell.reusableIdentifier, for: indexPath) as? HotelInfoAddressCell else { return nil }
        cell.hcConfigureAddressCell(address: "Ramada Powai, Powai Saki Vihar Road Mumbai 400 087, Mumbai, India, Pin-code: 400 087")
        cell.deviderView.isHidden = true
        return cell
    }
    
    internal func getPhoneCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCPhoneTableViewCell.reusableIdentifier, for: indexPath) as? HCPhoneTableViewCell else { return nil }
        cell.configCell()
        return cell
    }
    
    internal func getWebSiteCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsInclusionTableViewCell.reusableIdentifier, for: indexPath) as? HotelDetailsInclusionTableViewCell else { return nil }
        cell.configureWebsiteCell(website: "www.ramadapowai.com")
        return cell
    }
    
    internal func getCheckInOutCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCCheckInOutTableViewCell.reusableIdentifier, for: indexPath) as? HCCheckInOutTableViewCell else { return nil }
        cell.configCell()
        return cell
    }
    
    /* Guest Sections Cells */
    internal func getBedDetailsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCBedDetailsTableViewCell.reusableIdentifier, for: indexPath) as? HCBedDetailsTableViewCell else { return nil }
        cell.configCell()
        return cell
    }
    
    internal func getBedTypeCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsInclusionTableViewCell.reusableIdentifier, for: indexPath) as? HotelDetailsInclusionTableViewCell else { return nil }
        cell.configHCBedsCell()
        return cell
    }
    
    
    internal func getInclusionCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsInclusionTableViewCell.reusableIdentifier, for: indexPath) as? HotelDetailsInclusionTableViewCell else { return nil }
        cell.configHCInclusionCell()
        return cell
    }
    
    internal func getOtherInclusionCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsInclusionTableViewCell.reusableIdentifier, for: indexPath) as? HotelDetailsInclusionTableViewCell else { return nil }
        cell.configHCOtherInlusionCell()
        return cell
    }
    
    internal func getCancellationCell(_ tableView: UITableView, indexPath: IndexPath, ratesData: Rates) -> HotelDetailsCancelPolicyTableCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
        cell.delegate = self
        cell.configureNotesCell(ratesData: ratesData, isHotelDetailsScreen: false)
        return cell
        /*
         if ratesData.cancellation_penalty != nil {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
         cell.configureNotesCell(ratesData: ratesData, isHotelDetailsScreen: false)
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
         return cell
         }
         return nil
        */
    }
    
    internal func getPaymentInfoCell(_ tableView: UITableView, indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
        cell.delegate = self
        cell.configureNotesCell(ratesData: ratesData, isHotelDetailsScreen: false)
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
        return cell
    }
    
    internal func getNotesCell(_ tableView: UITableView, indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
        cell.delegate = self
        cell.configureNotesCell(ratesData: ratesData, isHotelDetailsScreen: false)
        return cell
        /*
         if let notesInclusion =  ratesData.inclusion_array[APIKeys.notes_inclusion.rawValue] as? [String], !notesInclusion.isEmpty {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
         cell.delegate = self
         cell.configureNotesCell(ratesData: ratesData, isHotelDetailsScreen: false)
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
         return cell
         }
         return nil
        */
    }
    
    internal func getGuestsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCGuestsTableViewCell.reusableIdentifier, for: indexPath) as? HCGuestsTableViewCell else { return nil }
        cell.configCell()
        return cell
    }
    
    /* TotalCharge Section Cells */
    internal func getTotalChargeCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCTotalChargeTableViewCell.reusableIdentifier, for: indexPath) as? HCTotalChargeTableViewCell else { return nil }
        cell.configCell()
        return cell
    }
    
    internal func getConfirmationVoucherCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCConfirmationVoucherTableViewCell.reusableIdentifier, for: indexPath) as? HCConfirmationVoucherTableViewCell else { return nil }
        cell.configCell()
        return cell
    }
    
    internal func getWhatNextCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCWhatNextTableViewCell.reusableIdentifier, for: indexPath) as? HCWhatNextTableViewCell else { return nil }        
        cell.configCell()
        return cell
    }
}

