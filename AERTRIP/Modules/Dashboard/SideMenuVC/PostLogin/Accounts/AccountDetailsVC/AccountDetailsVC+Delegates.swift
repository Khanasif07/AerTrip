//
//  AccountDetailsVC+Delegates.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//MARK:- tableView datasource and delegate methods
//MARK:-
extension AccountDetailsVC: UITableViewDataSource, UITableViewDelegate {
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
        return AppFonts.SemiBold.withSize(16.0).lineHeight + 32.0
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
        headerView.dateLabelTopConstraint.constant = 20.0
        headerView.dataLabelBottomConstraint.constant = 7.0
            
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.tableView {
            if let allEvent = self.viewModel.accountDetails[self.viewModel.allDates[section]] as? [AccountDetailEvent] {
                
                return allEvent.count
//                return (allEvent.reduce(0) { $0 + $1.numOfRows})
            }
        }
        else {
            if let allEvent = self.viewModel.searchedAccountDetails[self.viewModel.searchedAllDates[section]] as? [AccountDetailEvent] {
                
                return allEvent.count
//                return (allEvent.reduce(0) { $0 + $1.numOfRows})
            }
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 141.0
//        let allCount = 2
//        if (indexPath.row % allCount) == 0 {
//            //event header cell + (for top space)
//            return 64.0 + 5.0
//        }
//        else if (indexPath.row % allCount) == 1 {
//            //event description cell + (for bottom space)
//            return 67.0 + 10.0
//        }
//        return 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var allEvent: [AccountDetailEvent] = []
        if tableView === self.tableView {
            allEvent = (self.viewModel.accountDetails[self.viewModel.allDates[indexPath.section]] as? [AccountDetailEvent]) ?? []
        }
        else {
            allEvent = (self.viewModel.searchedAccountDetails[self.viewModel.searchedAllDates[indexPath.section]] as? [AccountDetailEvent]) ?? []
        }
        
        guard !allEvent.isEmpty else {
            return UITableViewCell()
        }
        
        return self.getEventCell(forData: allEvent[indexPath.row])
//        let allCount = 2
//        if (indexPath.row % allCount) == 0 {
//            //event header cell
//            return self.getEventHeaderCell(forData: allEvent[Int(indexPath.row/allCount)])
//        }
//        else if (indexPath.row % allCount) == 1 {
//            //event description cell
//            let idx = Int(indexPath.row/allCount)
//            let cell = self.getEventDescriptionCell(forData: allEvent[idx]) as! AccountDetailEventDescriptionCell
//            cell.mainContainerBottomConstraint.constant = (idx == (allEvent.count-1)) ? 5.0 : 10.0
//            return cell
//        }
//
//        return UITableViewCell()
    }
    
    func getEventCell(forData: AccountDetailEvent) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountLedgerEventCell.reusableIdentifier) as? AccountLedgerEventCell else {
            return UITableViewCell()
        }
        
        cell.event = forData
        
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
        var allEvent: [AccountDetailEvent] = []
        if tableView === self.tableView {
            allEvent = (self.viewModel.accountDetails[self.viewModel.allDates[indexPath.section]] as? [AccountDetailEvent]) ?? []
        }
        else {
            allEvent = (self.viewModel.searchedAccountDetails[self.viewModel.searchedAllDates[indexPath.section]] as? [AccountDetailEvent]) ?? []
        }
        
        guard !allEvent.isEmpty else {
            return
        }
        
        let allCount = 2
        
//        let idx = Int(indexPath.row/allCount)
        let idx = indexPath.row

        AppFlowManager.default.moveToAccountLadgerDetailsVC(forEvent: allEvent[idx])
    }
}
