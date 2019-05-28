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
        return AppFonts.SemiBold.withSize(16.0).lineHeight + 20.0
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
        headerView.dateLabelTopConstraint.constant = 15.0
        headerView.dataLabelBottomConstraint.constant = 7.0
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.tableView {
            if let allEvent = self.viewModel.accountDetails[self.viewModel.allDates[section]] as? [AccountDetailEvent] {
                
                return (allEvent.reduce(0) { $0 + $1.numOfRows})
            }
        }
        else {
            if let allEvent = self.viewModel.searchedAccountDetails[self.viewModel.searchedAllDates[section]] as? [AccountDetailEvent] {
                
                return (allEvent.reduce(0) { $0 + $1.numOfRows})
            }
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let allCount = 2
        if (indexPath.row % allCount) == 0 {
            //event header cell + (for top space)
            return 67.0 + 5.0
        }
        else if (indexPath.row % allCount) == 1 {
            //event description cell + (for bottom space)
            return 86.0 + 19.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let (currentEvent, count) = self.getEvent(forIndexPath: indexPath, forTableView: tableView)
        if let event = currentEvent, count > 0 {
            let allCount = 2
            if (indexPath.row % allCount) == 0 {
                //event header cell
                return self.getEventHeaderCell(forData: event)
            }
            else if (indexPath.row % allCount) == 1 {
                //event description cell
                let idx = Int(indexPath.row/allCount)
                let cell = self.getEventDescriptionCell(forData: event) as! AccountOutstandingEventDescriptionCell
                cell.mainContainerBottomConstraint.constant = (idx == (count-1)) ? 5.0 : 10.0
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func getEventHeaderCell(forData: AccountDetailEvent) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountDetailEventHeaderCell.reusableIdentifier) as? AccountDetailEventHeaderCell else {
            return UITableViewCell()
        }
        
        cell.event = forData
        
        cell.isHotelSelected = false
        if let _ = self.viewModel.selectedArrayIndex(forEvent: forData) {
            //already selected
            cell.isHotelSelected = true
        }
        cell.isSelectable = self.currentViewState == .selecting
        
        return cell
    }
    
    func getEventDescriptionCell(forData: AccountDetailEvent) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountOutstandingEventDescriptionCell.reusableIdentifier) as? AccountOutstandingEventDescriptionCell else {
            return UITableViewCell()
        }
        
        cell.event = forData
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let event = self.getEvent(forIndexPath: indexPath, forTableView: tableView).event else {
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
    
    func getEvent(forIndexPath indexPath: IndexPath, forTableView: UITableView) -> (event: AccountDetailEvent?, allCount: Int){
        var allEvent: [AccountDetailEvent] = []
        if forTableView === self.searchTableView {
            guard !self.viewModel.searchedAccountDetails.isEmpty else {
                return (nil, 0)
            }
            allEvent = (self.viewModel.searchedAccountDetails[self.viewModel.searchedAllDates[indexPath.section]] as? [AccountDetailEvent]) ?? []
        }
        else {
            guard !self.viewModel.accountDetails.isEmpty else {
                return (nil, 0)
            }
            allEvent = (self.viewModel.accountDetails[self.viewModel.allDates[indexPath.section]] as? [AccountDetailEvent]) ?? []
        }
        
        guard !allEvent.isEmpty else {
            return (nil, 0)
        }
        
        let allCount = 2
        var currentEvent: AccountDetailEvent?
        if (indexPath.row % allCount) == 0 {
            //event header cell
            currentEvent = allEvent[Int(indexPath.row/allCount)]
        }
        else if (indexPath.row % allCount) == 1 {
            //event description cell
            let idx = Int(indexPath.row/allCount)
            currentEvent = allEvent[idx]
        }
        
        return (currentEvent, allEvent.count)
    }
}
