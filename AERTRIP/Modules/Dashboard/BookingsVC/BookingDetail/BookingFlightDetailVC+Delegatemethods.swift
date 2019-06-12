//
//  BookingDetailVC+Delegatemethods.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit


extension BookingFlightDetailVC : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.bookingDetailType {
        case .flightInfo, .baggage:
            return self.viewModel.bookingDetail?.bookingDetail?.leg.count ?? 0
        case .fareInfo:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch self.bookingDetailType {
        case .flightInfo:
            return 44.0
        case .baggage:
            return 60.0
        case .fareInfo:
            return 114.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch self.bookingDetailType {
        case .flightInfo, .baggage:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingInfoHeaderView else { return nil }
            
            var title = ""
            if let allLeg = self.viewModel.bookingDetail?.bookingDetail?.leg {
                title = allLeg[section].title
            }
            headerView.tripRougteLabel.text = title
            return headerView
            
        case .fareInfo:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.fareInfoHeaderViewIdentifier) as? FareInfoHeaderView else { return nil }
            headerView.titleLabel.text = "Economy Saver (SS50322)"
            headerView.refundPolicyLabel.text = "Refund Policy"
            headerView.delegate = self
            headerView.fareRulesButton.setTitle(LocalizedString.FareRules.localized, for: .normal)
            headerView.infoLabel.text = "Non-refundable • Non-reschedulable"
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as? BookingInfoEmptyFooterView else {
            fatalError("BookingInfoFooterView not found")
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.bookingDetailType {
        case .flightInfo:
            
            if let leg = self.viewModel.bookingDetail?.bookingDetail?.leg[section] {
                let detailsC = leg.flight.reduce(into: 0) { $0 += $1.numberOfCellFlightInfo}
                return leg.pax.isEmpty ? detailsC : (detailsC + 1)
            }
            return 0
            
        case .baggage:
            if let leg = self.viewModel.bookingDetail?.bookingDetail?.leg[section] {
                let detailsC = leg.flight.reduce(into: 0) { $0 += $1.numberOfCellBaggage}
                return detailsC
            }
            return 0
            
        case .fareInfo:
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.bookingDetailType {
        case .flightInfo:
            return getHeightForFlightInfo(indexPath)
        case .baggage:
            return getHeightForBaggageInfo(indexPath)
        case .fareInfo:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        switch self.bookingDetailType {
        case .flightInfo:
            return getCellForFlightInfo(indexPath)
        case .baggage:
            return getCellForBaggageInfo(indexPath)
        case .fareInfo:
            return getCellForFareInfo(indexPath)
        }
    }
}


// Delegate methods

extension BookingFlightDetailVC : BaggageAirlineInfoTableViewCellDelegate {
    func dimensionButtonTapped(_ dimensionButton: UIButton) {
            printDebug("Dimension Button Tapped ")
        var detail: CabinBgInfo?
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

extension BookingFlightDetailVC: RouteFareInfoTableViewCellDelegate {
    func viewDetailsButtonTapped() {
        printDebug("View Details Button Tapped")
    }
    
}


extension BookingFlightDetailVC: BookingProductDetailVMDelegate {
    func willGetBookingDetail() {
        
    }
    
    func getBookingDetailSucces() {
        self.reloadDetails()
    }
    
    func getBookingDetailFaiure() {
        
    }
}
