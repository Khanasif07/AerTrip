//
//  FlightInfoVC+Delegatemethods.swift
//  AERTRIP
//
//  Created by Admin on 30/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

extension FlightInfoVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.legDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingInfoHeaderView else { return nil }
        
        headerView.tripRougteLabel.text = self.viewModel.legDetails[section].title
        return headerView
        
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
        let detailsC = self.viewModel.legDetails[section].flight.reduce(into: 0) { $0 += $1.numberOfCellFlightInfo }
        return self.viewModel.legDetails[section].pax.isEmpty ? detailsC : (detailsC + 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getHeightForFlightInfo(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCellForFlightInfo(indexPath)
    }
}

// Delegate methods

extension FlightInfoVC: BaggageAirlineInfoTableViewCellDelegate {
    func dimensionButtonTapped(_ dimensionButton: UIButton) {
        printDebug("Dimension Button Tapped ")
        var detail: BaggageInfo?
        if let cell = self.tableView.cell(forItem: dimensionButton) as? BaggageAirlineInfoTableViewCell {
            if let obj = cell.flightDetail?.baggage?.cabinBg?.infant {
                detail = obj
            }
            if let obj = cell.flightDetail?.baggage?.cabinBg?.child {
                detail = obj
            }
            if let obj = cell.flightDetail?.baggage?.cabinBg?.adult {
                detail = obj
            }
        }
        
        if let obj = detail?.dimension {
            AppFlowManager.default.presentBaggageInfoVC(dimension: obj)
        }
    }
}

// Route Fare info table View cell Delegate methods
extension FlightInfoVC: RouteFareInfoTableViewCellDelegate {
    func viewDetailsButtonTapped(_ sender: UIButton) {
        printDebug("View Details Button Tapped")
        if let indexPath = self.tableView.indexPath(forItem: sender) {
            AppFlowManager.default.presentBookingFareInfoDetailVC(usingFor: .both, forBookingId: self.viewModel.bookingDetail?.id ?? "", legDetails: self.viewModel.bookingDetail?.bookingDetail?.leg[indexPath.section], bookingFee: self.viewModel.bookingFee[indexPath.section])
        }
    }
}

// MARK: - Fare Info header view Delegate

extension FlightInfoVC: FareInfoHeaderViewDelegate {
    func fareButtonTapped(_ sender: UIButton) {
        printDebug("fare info butto n tapped")
        AppFlowManager.default.presentBookingFareInfoDetailVC(usingFor: .fareRules, forBookingId: self.viewModel.bookingDetail?.id ?? "", legDetails: self.viewModel.bookingDetail?.bookingDetail?.leg.first, bookingFee: self.viewModel.bookingFee.first)
    }
}

extension FlightInfoVC: BookingDetailVMDelegate {
    func willGetBookingFees() {}
    
    func getBookingFeesSuccess() {
        self.tableView.reloadData()
    }
    
    func getBookingFeesFail() {}
}
