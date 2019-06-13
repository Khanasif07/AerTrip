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
            return self.viewModel.legDetails.count
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
            if let fbn = self.viewModel.legDetails.first?.flight.first?.fbn, !fbn.isEmpty {
                return 114.0
            }
            return 74.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch self.bookingDetailType {
        case .flightInfo, .baggage:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingInfoHeaderView else { return nil }
            
            headerView.tripRougteLabel.text = self.viewModel.legDetails[section].title
            return headerView
            
        case .fareInfo:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.fareInfoHeaderViewIdentifier) as? FareInfoHeaderView else { return nil }
            
            let titleTxt = self.viewModel.legDetails.first?.flight.first?.fbn ?? ""
            headerView.titleLabel.text = titleTxt
            headerView.dividerView.isHidden = titleTxt.isEmpty
            
            headerView.refundPolicyLabel.text = "Refund Policy"
            headerView.delegate = self
            headerView.fareRulesButton.setTitle(LocalizedString.FareRules.localized, for: .normal)
            
            var infoText = "We do not have information regarding refundability/reschedulability"
            if let leg = self.viewModel.legDetails.first {
                if leg.refundable == 1 {
                    infoText = "Refundable"
                }
                else if leg.refundable == -9 {
                    infoText = LocalizedString.na.localized
                }
                else {
                    infoText = "Non-refundable"
                }
                
                
                if leg.reschedulable == 1 {
                    infoText += infoText.isEmpty ? "Reschedulable" : " • Reschedulable"
                }
                else if leg.refundable == -9 {
                    infoText += infoText.isEmpty ? LocalizedString.na.localized : " • \(LocalizedString.na.localized)"
                }
                else {
                    infoText += infoText.isEmpty ? "Non-reschedulable" : " • Non-reschedulable"
                }
            }
            
            headerView.infoLabel.text = infoText
            
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
                let detailsC = self.viewModel.legDetails[section].flight.reduce(into: 0) { $0 += $1.numberOfCellFlightInfo}
                return self.viewModel.legDetails[section].pax.isEmpty ? detailsC : (detailsC + 1)
            
        case .baggage:
                let detailsC = self.viewModel.legDetails[section].flight.reduce(into: 0) { $0 += $1.numberOfCellBaggage}
                return detailsC
            
        case .fareInfo:
            return self.getNumberOfCellsInFareInfo(forData: self.viewModel.bookingFee)
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


extension BookingFlightDetailVC: BookingDetailVMDelegate {
    func willGetBookingFees() {
    }
    
    func getBookingFeesSuccess() {
        self.reloadDetails()
    }
    
    func getBookingFeesFail() {
    }
    
    func legDetailsSuccess() {
        self.reloadDetails()
        self.viewModel.getBookingFees()
    }
}
