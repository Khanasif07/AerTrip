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
        let stepsH: CGFloat = CGFloat(bookingData.stepsArray?.count ?? 0) * 40.0
        return stepsH + 92.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 53.0
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
          if dateStr.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.isGreaterThan(Date().add(years: 1) ?? Date()) ?? false {
            headerText = dateStr.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.toString(dateFormat: "d MMM yyyy") ?? ""
            } else {
             headerText = dateStr.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.toString(dateFormat: "E, d MMM") ?? ""
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
               AppFlowManager.default.moveToFlightBookingsDetailsVC(bookingId: bookingData.bookingId ?? "")
                
            }
            else if bookingData.productType == .other {
                AppFlowManager.default.moveToOtherBookingsDetailsVC(bookingId: bookingData.bookingId ?? "")
            }
            else {
                //open hotel details
                 AppFlowManager.default.moveToOtherBookingsDetailsVC(bookingId: bookingData.bookingId ?? "")
            }
            
        }
    }
}


extension UpcomingBookingsVC: MyBookingFooterViewDelegate {
    func myBookingFooterView(_ sender: MyBookingFooterView, didChangedPendingActionSwitch isOn: Bool) {
        self.isOnlyPendingAction = isOn
        self.loadSaveData()
    }
}
