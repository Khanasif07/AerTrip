//
//  FlightFareInfoVC+Delegatemethods.swift
//  AERTRIP
//
//  Created by Admin on 30/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

extension FlightFareInfoVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.viewModel.bookingDetail?.isMultipleFlight() ?? false {
            return self.viewModel.legDetails.count
        }
        else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let booking = self.viewModel.bookingDetail, !booking.isMultipleFlight(), let _ = self.viewModel.legDetails[section].flight.first?.fbn {
            return UITableView.automaticDimension //!fbn.isEmpty ? 114.0 : 74.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let booking = self.viewModel.bookingDetail, !booking.isMultipleFlight(), let flight = self.viewModel.legDetails[section].flight.first {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.fareInfoHeaderViewIdentifier) as? FareInfoHeaderView else { return nil }
            
            let cc = flight.cc
            let fbn = flight.fbn
            var bc = flight.bc
            if bc != ""{
                bc =  " (" + bc + ")"
            }
            var displayTitle = ""
            if fbn != ""{
                displayTitle = fbn.capitalized + bc
            }else{
                displayTitle = cc.capitalized + bc
            }
            
            headerView.dividerView.isHidden = false
            headerView.delegate = self
            headerView.fareRulesButton.setTitle(LocalizedString.FareRules.localized, for: .normal)
            if self.viewModel.legDetails.count == 1 {
                headerView.refundPolicyLabel.text = displayTitle
                headerView.infoLabel.isHidden = true
            } else {
                headerView.refundPolicyLabel.text = (flight.departure) + " → " + (flight.arrival)
                headerView.infoLabel.text = displayTitle
                headerView.infoLabel.isHidden = false
            }
            
            
//            var infoText = "We do not have information regarding refundability/reschedulability"
//            if let leg = self.viewModel.legDetails.first {
//                if leg.refundable == 1 {
//                    infoText = "Refundable"
//                }
//                else if leg.refundable == -9 {
//                    infoText = LocalizedString.na.localized
//                }
//                else {
//                    infoText = "Non-refundable"
//                }
//
//                if leg.reschedulable == 1 {
//                    infoText += infoText.isEmpty ? "Reschedulable" : " • Reschedulable"
//                }
//                else if leg.refundable == -9 {
//                    infoText += infoText.isEmpty ? LocalizedString.na.localized : " • \(LocalizedString.na.localized)"
//                }
//                else {
//                    infoText += infoText.isEmpty ? "Non-reschedulable" : " • Non-reschedulable"
//                }
//            }
            
//            headerView.infoLabel.text = infoText
            
            return headerView
        }
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as? BookingInfoEmptyFooterView else {
            fatalError("BookingInfoFooterView not found")
        }
        
        let totalSection = self.numberOfSections(in: self.tableView) - 1
        footerView.bottomDividerView.isHidden = totalSection == section
        return footerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let booking = self.viewModel.bookingDetail, booking.isMultipleFlight() {
            return self.getNumberOfCellsInFareInfoForMultiFlight()
        }
        else {
            return self.getNumberOfCellsInFareInfoForNormalFlight(forData: self.viewModel.bookingFee.first)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getHeightForFareInfo(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let booking = self.viewModel.bookingDetail, booking.isMultipleFlight() {
            return getCellForFareInfoForMultiFlight(indexPath)
        }
        else {
            return getCellForFareInfoForNormalFlight(indexPath)
        }
    }
}

// Route Fare info table View cell Delegate methods
extension FlightFareInfoVC: RouteFareInfoTableViewCellDelegate {
    func viewDetailsButtonTapped(_ sender: UIButton) {
        printDebug("View Details Button Tapped")
        if let indexPath = self.tableView.indexPath(forItem: sender) {
            AppFlowManager.default.presentBookingFareInfoDetailVC(usingFor: .both, forBookingId: self.viewModel.bookingDetail?.id ?? "", legDetails: self.viewModel.bookingDetail?.bookingDetail?.leg[indexPath.section], bookingFee: self.viewModel.bookingFee[indexPath.section])
        }
    }
}

// MARK: - Fare Info header view Delegate

extension FlightFareInfoVC: FareInfoHeaderViewDelegate {
    func fareButtonTapped(_ sender: UIButton) {
        printDebug("fare info butto n tapped")
        AppFlowManager.default.presentBookingFareInfoDetailVC(usingFor: .fareRules, forBookingId: self.viewModel.bookingDetail?.id ?? "", legDetails: self.viewModel.bookingDetail?.bookingDetail?.leg.first, bookingFee: self.viewModel.bookingFee.first)
    }
}

extension FlightFareInfoVC: BookingDetailVMDelegate {
    func willGetBookingFees() {}
    
    func getBookingFeesSuccess() {
        self.tableView.reloadData()
    }
    
    func getBookingFeesFail() {}
}
