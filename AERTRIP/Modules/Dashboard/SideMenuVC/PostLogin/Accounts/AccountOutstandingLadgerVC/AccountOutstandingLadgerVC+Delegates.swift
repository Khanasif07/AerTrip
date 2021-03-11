//
//  AccountOutstandingLadgerVC+Delegates.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//MARK:- tableView datasource and delegate methods
//MARK:-
extension AccountOutstandingLadgerVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView === self.tableView {
            return self.viewModel.allDates.count
        }
        else {
            let allDates = self.viewModel.searchedAllDates
            if (self.mainSearchBar.text ?? "").isEmpty {
                self.searchTableView.isHidden = allDates.isEmpty
            }
            else {
                self.searchTableView.isHidden = false
                self.searchTableView.backgroundView?.isHidden = !allDates.isEmpty
            }
            return allDates.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView{
            return section == 0 ? 45 : 35
        }else{
            return section == 0 ? 45 : 35 //CGFloat.leastNonzeroMagnitude
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DateTableHeaderView") as? DateTableHeaderView else {
            return nil
        }
        
        //headerView.headerLabel.font = AppFonts.SemiBold.withSize(16.0)
        var titleStr = ""
        if tableView === self.tableView {
            titleStr = self.viewModel.allDates[section]
        }
        else {
            titleStr = self.viewModel.searchedAllDates[section]
        }
        if let date = titleStr.toDate(dateFormat: "YYYY-MM-dd") {
            if date.isCurrentYear {
                titleStr = date.toString(dateFormat: "EEE dd MMM")
            } else {
                titleStr = date.toString(dateFormat: "dd MMM YYYY")
            }
        }
        
         headerView.configViewForBooking(date: titleStr, isFirstHeaderView: section == 0 ? true : false)
                      return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.tableView {
            if let allEvent = self.viewModel.accountDetails[self.viewModel.allDates[section]] as? [AccountDetailEvent] {
                
                return allEvent.count
            }
        }
        else {
            if let allEvent = self.viewModel.searchedAccountDetails[self.viewModel.searchedAllDates[section]] as? [AccountDetailEvent] {
                
                return allEvent.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var event: AccountDetailEvent? = nil
        if tableView === self.tableView {
            if let allEvent = self.viewModel.accountDetails[self.viewModel.allDates[indexPath.section]] as? [AccountDetailEvent] {
                
                event = allEvent[indexPath.row]
            }
        }
        else {
            if let allEvent = self.viewModel.searchedAccountDetails[self.viewModel.searchedAllDates[indexPath.section]] as? [AccountDetailEvent] {
                
                event = allEvent[indexPath.row]
            }
        }
        
        if let event = event {
            guard let cell = self.getEventDescriptionCell(forData: event, index: indexPath, table: tableView) as? AccountOutstandingEventDescriptionCell else {return UITableViewCell()}
            return cell
        }
        
        return UITableViewCell()
    }
    
    func getEventDescriptionCell(forData: AccountDetailEvent,  index: IndexPath, table: UITableView) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountOutstandingEventDescriptionCell.reusableIdentifier) as? AccountOutstandingEventDescriptionCell else {
            return UITableViewCell()
        }
        
        cell.event = forData
        cell.isHotelSelected = false
        if let _ = self.viewModel.selectedArrayIndex(forEvent: forData) {
            //already selected
            cell.isHotelSelected = true
        }
        cell.isSelectable = self.currentViewState == .selecting
        
        //        cell.clipsToBounds = true
        //        cell.backgroundColor = AppColors.themeWhite
        cell.mainContainerView.backgroundColor = AppColors.themeWhite
        
        if table === self.tableView{
            if index.row == 0 &&  index.row == self.tableView.numberOfRows(inSection: index.section) - 1{
                cell.containerTopConstraint.constant = 16
                cell.mainContainerBottomConstraint.constant = 16
            }else if index.row == 0{
                cell.containerTopConstraint.constant = 16
                cell.mainContainerBottomConstraint.constant = 8
            }else if index.row == self.tableView.numberOfRows(inSection: index.section) - 1{
                cell.containerTopConstraint.constant = 8
                cell.mainContainerBottomConstraint.constant = 16
            }else{
                cell.containerTopConstraint.constant = 8
                cell.mainContainerBottomConstraint.constant = 8
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var eventSelected: AccountDetailEvent? = nil
        
        if tableView === self.tableView {
            if let allEvent = self.viewModel.accountDetails[self.viewModel.allDates[indexPath.section]] as? [AccountDetailEvent] {
                
                eventSelected = allEvent[indexPath.row]
            }
        } else {
            if let allEvent = self.viewModel.searchedAccountDetails[self.viewModel.searchedAllDates[indexPath.section]] as? [AccountDetailEvent] {
                
                eventSelected = allEvent[indexPath.row]
            }
        }
        guard let event = eventSelected else {
            return
        }
        
        if self.currentViewState == .selecting {
            if let index = self.viewModel.selectedArrayIndex(forEvent: event) {
                //already selected
                self.viewModel.selectedEvent.remove(at: index)
            }
            else {
                //select it
                self.viewModel.selectedEvent.append(event)
            }
            self.reloadList()
        } else {
            AppFlowManager.default.moveToAccountLadgerDetailsVC(forEvent: event, detailType: .outstandingLadger)
        }
    }
    
//    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
//        currentViewState = .selecting
//        return true
//    }
    
}
