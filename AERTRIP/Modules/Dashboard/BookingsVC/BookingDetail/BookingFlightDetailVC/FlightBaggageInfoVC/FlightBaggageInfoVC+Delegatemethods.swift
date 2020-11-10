//
//  FlightBaggageInfoVC+Delegatemethods.swift
//  AERTRIP
//
//  Created by Admin on 30/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
protocol BaggageDimesionPresentDelegate : NSObjectProtocol{
    func dimesionButtonTapprd(with dimension: Dimension)
}
extension FlightBaggageInfoVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.allBaggageCells.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude//60.0
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingInfoHeaderView else { return nil }
    //
    //        headerView.tripRougteLabel.text = self.viewModel.legDetails[section].title
    //        return headerView
    //
    //    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
//        if self.viewModel.allBaggageCells.count == 1 {
//            return 0
//        } else {
            return 35.0
//        }
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
        switch section {
        case self.viewModel.allBaggageCells.count:
            return 1
        default:
            return self.viewModel.allBaggageCells[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getHeightForBaggageInfo(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCellForBaggageInfo(indexPath)
    }
}

// Delegate methods

extension FlightBaggageInfoVC: BaggageAirlineInfoTableViewCellDelegate {
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
        
        if let obj = detail?.dimension{
//            AppFlowManager.default.presentBaggageInfoVC(dimension: obj)
            self.dimesionDelegate?.dimesionButtonTapprd(with: obj)
        }
    }
}

extension FlightBaggageInfoVC: BookingDetailVMDelegate {
    func willGetBookingFees() {}
    
    func getBookingFeesSuccess() {
        self.tableView.reloadData()
    }
    
    func getBookingFeesFail() {}
}
