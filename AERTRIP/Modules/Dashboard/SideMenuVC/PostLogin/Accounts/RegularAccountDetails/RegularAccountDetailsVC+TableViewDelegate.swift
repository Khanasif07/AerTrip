//
//  RegularAccountDetailsVC+TableViewDelegate.swift
//  AERTRIP
//
//  Created by Appinventiv  on 04/03/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation

extension RegularAccountDetailsVC:UITableViewDelegate, UITableViewDataSource{
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
            return section == 0 ? 45 : 35
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
                titleStr = date.toString(dateFormat: "EEE, dd MMM")
            } else {
                titleStr = date.toString(dateFormat: "dd MMM YYYY")
            }
        }
         headerView.configViewForBooking(date: titleStr, isFirstHeaderView: section == 0 ? true : false)
               return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView === self.tableView {
//            if let allEvent = self.viewModel.accountDetails[self.viewModel.allDates[section]] as? [AccountDetailEvent] {
//
//                return allEvent.count
//            }
//        }
//        else {
//            if let allEvent = self.viewModel.searchedAccountDetails[self.viewModel.searchedAllDates[section]] as? [AccountDetailEvent] {
//
//                return allEvent.count
//            }
//        }

        return self.getAllEvents(with: section, for: tableView).count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var additionalHeight:CGFloat = 0
        if self.getAllEvents(with: indexPath.section, for: tableView).count > indexPath.row{
            
            additionalHeight = (self.getAllEvents(with: indexPath.section, for: tableView)[indexPath.row].currencyRate == nil) ? 0 : 23

            
        }
//        let additionalHeight: CGFloat = (self.getAllEvents(with: indexPath.section, for: tableView)[indexPath.row].currencyRate == nil) ? 0 : 23
        
//        if tableView === self.tableView{
            if indexPath.row == 0 && indexPath.row == self.tableView.numberOfRows(inSection: indexPath.section) - 1{
                return 165 + additionalHeight
            }else if indexPath.row == 0{
                return 157 + additionalHeight
            }else if indexPath.row == self.tableView.numberOfRows(inSection: indexPath.section) - 1{
                return 157 + additionalHeight
            }else{
                return 149 + additionalHeight
            }
//        }else{
//            return 149
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let allEvent = self.getAllEvents(with: indexPath.section, for: tableView)
//        if tableView === self.tableView {
//            allEvent = (self.viewModel.accountDetails[self.viewModel.allDates[indexPath.section]] as? [AccountDetailEvent]) ?? []
//        }
//        else {
//            allEvent = (self.viewModel.searchedAccountDetails[self.viewModel.searchedAllDates[indexPath.section]] as? [AccountDetailEvent]) ?? []
//        }
        guard !allEvent.isEmpty else {
            return UITableViewCell()
        }
        if indexPath.row < allEvent.count{
            return self.getEventCell(forData: allEvent[indexPath.row], indexPath: indexPath, table: tableView)
        }else{
            return UITableViewCell()
        }
    }
    
    func getEventCell(forData: AccountDetailEvent, indexPath: IndexPath, table: UITableView) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: NewAccountLedgerEventCell.reusableIdentifier) as? NewAccountLedgerEventCell else {
            return UITableViewCell()
        }
        
        cell.event = forData
        //cell.clipsToBounds = true
        cell.backgroundColor = AppColors.themeWhite
        if table === self.tableView{
            
            if indexPath.row == 0 && indexPath.row == self.tableView.numberOfRows(inSection: indexPath.section) - 1{
                cell.containerTopConstrain.constant = 16
                cell.containerBottomConstaint.constant = 16
            }else if indexPath.row == 0{
                cell.containerTopConstrain.constant = 16
                cell.containerBottomConstaint.constant = 8
            }else if indexPath.row == self.tableView.numberOfRows(inSection: indexPath.section) - 1{
                cell.containerTopConstrain.constant = 8
                cell.containerBottomConstaint.constant = 16
            }else{
                cell.containerTopConstrain.constant = 8
                cell.containerBottomConstaint.constant = 8
            }
        } else {
            cell.containerTopConstrain.constant = 8
            cell.containerBottomConstaint.constant = 8
        }
        return cell
    }
    
    func getEventHeaderCell(forData: AccountDetailEvent) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountDetailEventHeaderCell.reusableIdentifier) as? AccountDetailEventHeaderCell else {
            return UITableViewCell()
        }
        
        cell.event = forData
        
        return cell
    }
    
    func getEventDescriptionCell(forData: AccountDetailEvent) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountDetailEventDescriptionCell.reusableIdentifier) as? AccountDetailEventDescriptionCell else {
            return UITableViewCell()
        }
        
        cell.event = forData
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printDebug(Date())
        let allEvent = self.getAllEvents(with: indexPath.section, for: tableView)
//        if tableView === self.tableView {
//            allEvent = (self.viewModel.accountDetails[self.viewModel.allDates[indexPath.section]] as? [AccountDetailEvent]) ?? []
//        }
//        else {
//            allEvent = (self.viewModel.searchedAccountDetails[self.viewModel.searchedAllDates[indexPath.section]] as? [AccountDetailEvent]) ?? []
//        }
        
        guard !allEvent.isEmpty else {
            return
        }
        let idx = indexPath.row
        printDebug(Date())

        delay(seconds: 0.0){
            AppFlowManager.default.moveToAccountLadgerDetailsVC(forEvent: allEvent[idx], detailType: .accountLadger)
        }
    }
    
    func getAllEvents(with section: Int, for table :UITableView)-> [AccountDetailEvent]{
        var allEvent: [AccountDetailEvent] = []
        if table === self.tableView {
            allEvent = (self.viewModel.accountDetails[self.viewModel.allDates[section]] as? [AccountDetailEvent]) ?? []
        }
        else {
            allEvent = (self.viewModel.searchedAccountDetails[self.viewModel.searchedAllDates[section]] as? [AccountDetailEvent]) ?? []
        }
        return allEvent
    }
    
    
}
