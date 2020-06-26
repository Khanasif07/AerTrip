//
//  UpcomingBookingVC+UITableViewMethods.swift
//  AERTRIP
//
//  Created by apple on 29/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

// MARK: - Table view datasource and delegate methods

extension UpcomingBookingsVC: UITableViewDataSource, UITableViewDelegate {
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
        let totalSteps = bookingData.stepsArray?.count ?? 0
        let stepsH: CGFloat = CGFloat(totalSteps) * 40.0
        var cellHeight: CGFloat = stepsH + 98.0 + (totalSteps > 0 ? 1 : 0)
        if indexPath.row == 0 {
             cellHeight += 8.0
        }
        if  let sections = self.fetchedResultsController.sections {
            let sectionInfo = sections[indexPath.section]
            if indexPath.row ==  (sectionInfo.numberOfObjects - 1) {
                 cellHeight += 8.0
            }
        }
        return cellHeight
//        return stepsH + 98.0 + (totalSteps > 0 ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30//section == 0 ? 44.0 : 36
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DateTableHeaderView.className) as? DateTableHeaderView else { return nil }
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderCellIdentifier) as? TravellerListTableViewSectionView else {
            return nil
        }
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
        headerView.headerLabel.text = headerText
//        headerView.configViewForBooking(date: headerText, isFirstHeaderView: section == 0)
        headerView.topSepratorView.isHidden = section == 0 ? true : false
//        headerView.bottomDividerView.isHidden = false
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookingData = fetchedResultsController.object(at: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OthersBookingTableViewCell.reusableIdentifier, for: indexPath) as? OthersBookingTableViewCell else { return UITableViewCell() }
        if  let sections = self.fetchedResultsController.sections {
            let sectionInfo = sections[indexPath.section]
            cell.isLastCellInSection =  indexPath.row ==  (sectionInfo.numberOfObjects - 1)
        } else {
            cell.isLastCellInSection = false
        }
        cell.isFirstCellInSection = indexPath.row == 0
        cell.bookingData = bookingData
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismissKeyboard()
        let bookingData = fetchedResultsController.object(at: indexPath)
        if let bookingId = bookingData.bookingId, !bookingId.isEmpty {
            if bookingData.productType == .flight {
               AppFlowManager.default.moveToFlightBookingsDetailsVC(bookingId: bookingData.bookingId ?? "",tripCitiesStr: bookingData.flightBookingTitle)
                
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


extension UpcomingBookingsVC: MyBookingFooterViewDelegate {
    func myBookingFooterView(_ sender: MyBookingFooterView, didChangedPendingActionSwitch isOn: Bool) {
        self.isOnlyPendingAction = isOn
        self.isComingFromFilter = true
        self.loadSaveData()
        self.reloadTable()
    }
}
