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
        
        if self.viewModel.bookingDetail?.isMultipleFlight() ?? false{
            return self.viewModel.legDetails.count + 1
        }else{
            return 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //        if let booking = self.viewModel.bookingDetail, !booking.isMultipleFlight(), let _ = self.viewModel.legDetails[section].flight.first?.fbn {
        //            return UITableView.automaticDimension //!fbn.isEmpty ? 114.0 : 74.0
        //        }
        if section == self.viewModel.legDetails.count{
          return  CGFloat.leastNormalMagnitude
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == self.viewModel.legDetails.count{
//            return nil
//        }
        if  self.viewModel.legDetails.indices.contains(section), let flight = self.viewModel.legDetails[section].flight.first {
            
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
                headerView.refundPolicyLabel.text = (flight.departCity) + " → " + (flight.arrivalCity)
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
        //        if let booking = self.viewModel.bookingDetail, booking.isMultipleFlight() {
        //            return self.getNumberOfCellsInFareInfoForMultiFlight()
        //        }
        //        else {
        //            return self.getNumberOfCellsInFareInfoForNormalFlight(forData: self.viewModel.bookingFee.first)
        //        }
        
        if let booking = self.viewModel.bookingDetail, booking.isMultipleFlight() {
            if section == self.viewModel.legDetails.count{
                return 1
            }else{
                return 1
            }
        }else{
            if section == 1{
                return 1
            }else{
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension//getHeightForFareInfo(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if let booking = self.viewModel.bookingDetail, booking.isMultipleFlight() {
        //            return getCellForFareInfoForMultiFlight(indexPath)
        //        }
        //        else {
        //            return getCellForFareInfoForNormalFlight(indexPath)
        //        }
        
        
        if let booking = self.viewModel.bookingDetail, booking.isMultipleFlight(){
            if indexPath.section == self.viewModel.legDetails.count{
                return getNotesCell()
            }else{
                
                //                if indexPath.row == 0{
                //                    return self.getFareInfoWithLegs(at: indexPath)
                //                }else{
                //                    return getCombineFareWithLegs(at: indexPath)
                //                }
                guard  let cell = tableView.dequeueReusableCell(withIdentifier: FareInfoCombineCell.reusableIdentifier, for: indexPath) as? FareInfoCombineCell else {
                    return UITableViewCell()
                }
                cell.flightAdultCount = self.viewModel.flightAdultCount
                cell.flightChildrenCount = self.viewModel.flightChildrenCount
                cell.flightInfantCount = self.viewModel.flightInfantCount
                cell.configureView(model: self.viewModel.bookingFee[indexPath.section])
                cell.combineFareTableView.reloadData()
                //cell.cellHeightDelegate = self
                cell.layoutSubviews()
                cell.layoutIfNeeded()
                let height = cell.combineFareTableView.contentSize.height
                cell.tableViewHeight.constant = (height < 30) ? 30 : height
                cell.layoutSubviews()
                cell.layoutIfNeeded()
                cell.combineFareTableView.reloadData()
                return cell
            }
        }else{
            if indexPath.section == 1{
                return getNotesCell()
            }else{
                //                if indexPath.row == 0{
                //                    return self.getFareInfoCellWithJourney(with: indexPath)
                //                }else if indexPath.row == 2 {
                //                    return self.getChangeAirportCell()
                //                }else{
                //                    return getCombineFareInfoWithJourney(with: indexPath)
                //                }
                guard  let cell = tableView.dequeueReusableCell(withIdentifier: FareInfoCombineCell.reusableIdentifier, for: indexPath) as? FareInfoCombineCell else {
                    return UITableViewCell()
                }
                cell.flightAdultCount = self.viewModel.flightAdultCount
                cell.flightChildrenCount = self.viewModel.flightChildrenCount
                cell.flightInfantCount = self.viewModel.flightInfantCount
                
                cell.configureView(model: self.viewModel.bookingFee[indexPath.section])
                cell.combineFareTableView.reloadData()
                //cell.cellHeightDelegate = self
                cell.layoutSubviews()
                cell.layoutIfNeeded()
                let height = cell.combineFareTableView.contentSize.height
                cell.tableViewHeight.constant = (height < 30) ? 30 : height
                cell.layoutSubviews()
                cell.layoutIfNeeded()
                cell.combineFareTableView.reloadData()
                return cell
            }
        }
        
        //        guard  let cell = tableView.dequeueReusableCell(withIdentifier: FareInfoCommonCell.reusableIdentifier, for: indexPath) as? FareInfoCommonCell else {
        //            return UITableViewCell()
        //        }
        //        cell.configureForCancelation(model: self.viewModel.bookingFee[indexPath.row], indexPath: indexPath)
        //        return cell
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
        
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Bookings.rawValue, params: [AnalyticsKeys.FilterName.rawValue:FirebaseEventLogs.EventsTypeName.BookingsFlightDetailsFareInfoFareRulesOptionSelected, AnalyticsKeys.FilterType.rawValue: "LoggedInUserType", AnalyticsKeys.Values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a"])


        AppFlowManager.default.presentFareBookingRulesVC(forBookingId: self.viewModel.bookingDetail?.id ?? "", legDetails: self.viewModel.bookingDetail?.bookingDetail?.leg.first, bookingFee: self.viewModel.bookingFee.first)
    }
}

extension FlightFareInfoVC: BookingDetailVMDelegate {
    func willGetBookingFees() {}
    
    func getBookingFeesSuccess() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        delay(seconds: 0.5) {
            self.tableView.reloadData()
        }
        delay(seconds: 0.8) {
            self.tableView.reloadData()
        }
    }
    
    func getBookingFeesFail() {}
}
