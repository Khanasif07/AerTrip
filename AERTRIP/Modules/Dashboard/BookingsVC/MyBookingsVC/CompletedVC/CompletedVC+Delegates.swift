//
//  CompletedVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//Mark:- Extensions
//=================
extension CompletedVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            printDebug("No sections in fetchedResultsController")
            return 0
        }
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let bookingData = fetchedResultsController.object(at: indexPath)
        let stepsH: CGFloat = CGFloat(bookingData.stepsArray?.count ?? 0) * 40.0
        return stepsH + 92.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DateTableHeaderView.className) as? DateTableHeaderView else { return nil }
        
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        
        let aSection = sections[section]
        let dateStr = aSection.name
        /*  logic to show header text : - if date is greater than 1 year date format  shoulr be d MMM yyyy
         else
         
         */
        var headerText  = ""
        if let date = dateStr.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss") {
            let format = date.isCurrentYear ? "E, d MMM" : "d MMM yyyy"
            headerText = date.toString(dateFormat: format)
        }
        headerView.dateLabel.text = headerText
        headerView.dateLabelTopConstraint.constant = 11.0
        headerView.contentView.backgroundColor = AppColors.themeWhite
        headerView.backgroundColor = AppColors.themeWhite
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookingData = fetchedResultsController.object(at: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OthersBookingTableViewCell.reusableIdentifier, for: indexPath) as? OthersBookingTableViewCell else { return UITableViewCell() }
        
        cell.bookingData = bookingData
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookingData = fetchedResultsController.object(at: indexPath)
        if let bookingId = bookingData.bookingId, !bookingId.isEmpty {
            if bookingData.productType == .flight {
                AppFlowManager.default.moveToFlightBookingsDetailsVC(bookingId: bookingId,tripCitiesStr: bookingData.tripCitiesStr )
            }
            else if bookingData.productType == .other {
                AppFlowManager.default.moveToOtherBookingsDetailsVC(bookingId: bookingData.bookingId ?? "")
            }
            else {
                //open hotel details
                 AppFlowManager.default.moveToHotelBookingsDetailsVC(bookingId: bookingData.bookingId ?? "")
            }
            
        }
    }
    
}

extension CompletedVC {

    internal func getSpaceCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SpaceTableViewCell.reusableIdentifier, for: indexPath) as? SpaceTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = AppColors.themeWhite
        return cell
    }
}

extension CompletedVC: MyBookingFooterViewDelegate {
    func myBookingFooterView(_ sender: MyBookingFooterView, didChangedPendingActionSwitch isOn: Bool) {
        self.isOnlyPendingAction = isOn
        self.loadSaveData()
        self.reloadTable()
    }
}
