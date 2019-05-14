//
//  BookingDetailVC+Delegatemethods.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit


extension BookingDetailVC : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.bookingDetailType {
        case .flightInfo:
            return 1
        case .baggage:
            return 2
        case .fareInfo:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.bookingDetailType {
        case .flightInfo:
            return 9
        case .baggage:
            if section == 0 {
                return 11
            } else {
                return 4
            }
        case .fareInfo:
            return 15
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.bookingDetailType {
        case .flightInfo:
            return getHeightForFlightInfoRowFirstSection(indexPath)
        case .baggage:
            if indexPath.section == 0 {
                return self.getHeightForBaggageInfoRowFirstSection(indexPath)
            } else {
                return self.getHeightForBaggageInfoRowSecondSection(indexPath)
            }
        case .fareInfo:
            return UITableView.automaticDimension
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch self.bookingDetailType {
        case .flightInfo:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingInfoHeaderView else { return nil }
            headerView.tripRougteLabel.text = "Mumbai" + LocalizedString.ForwardArrow.localized + "Delhi"
            return headerView
        case .baggage:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingInfoHeaderView else { return nil }
            headerView.tripRougteLabel.text = "DEL" + LocalizedString.ForwardArrow.localized + "BEL"
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
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as? BookingInfoEmptyFooterView else {
            fatalError("BookingInfoFooterView not found")
        }
        return footerView
    }
}


// Delegate methods

extension BookingDetailVC : BaggageAirlineInfoTableViewCellDelegate {
    func dimensionButtonTapped(_ dimensionButton: UIButton) {
            printDebug("Dimension Button Tapped ")
        AppFlowManager.default.presentBaggageInfoVC()
        
    }

}

// Route Fare info table View cell Delegate methods

extension BookingDetailVC: RouteFareInfoTableViewCellDelegate {
    func viewDetailsButtonTapped() {
        printDebug("View Details Button Tapped")
    }
    
}
