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
            print("allDates: \(allDates)")
            print("self.mainSearchBar.text: \(self.mainSearchBar.text)")

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
        return section == 0 ? 44 : 46
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DateTableHeaderView") as? DateTableHeaderView else {
            return nil
        }
        
        headerView.dateLabel.font = AppFonts.SemiBold.withSize(16.0)
        var titleStr = ""
        if tableView === self.tableView {
            titleStr = self.viewModel.allDates[section]
        }
        else {
            titleStr = self.viewModel.searchedAllDates[section]
        }
        headerView.dateLabel.text = titleStr
        headerView.parentView.backgroundColor = AppColors.themeWhite
        headerView.dateLabelTopConstraint.constant = section == 0 ? 16 : 18
        headerView.dataLabelBottomConstraint.constant = 8
        
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
            let cell = self.getEventDescriptionCell(forData: event) as! AccountOutstandingEventDescriptionCell
            return cell
        }
        
        return UITableViewCell()
    }
    
    func getEventDescriptionCell(forData: AccountDetailEvent) -> UITableViewCell {
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var eventSelected: AccountDetailEvent? = nil
        if tableView === self.tableView {
            if let allEvent = self.viewModel.accountDetails[self.viewModel.allDates[indexPath.section]] as? [AccountDetailEvent] {
                
                eventSelected = allEvent[indexPath.row]
            }
        }
        else {
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
        }
        else {
            AppFlowManager.default.moveToAccountLadgerDetailsVC(forEvent: event)
        }
    }
    
}
