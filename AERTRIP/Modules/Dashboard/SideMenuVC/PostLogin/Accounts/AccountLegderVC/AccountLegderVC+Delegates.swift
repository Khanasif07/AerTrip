//
//  AccountLegderVC+Delegates.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//MARK:- tableView datasource and delegate methods
//MARK:-
extension AccountLegderVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.allDates.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AppFonts.SemiBold.withSize(16.0).lineHeight + 32.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DateTableHeaderView") as? DateTableHeaderView else {
            return nil
        }
        
        headerView.dateLabel.font = AppFonts.SemiBold.withSize(16.0)
        headerView.dateLabel.text = self.viewModel.allDates[section]
        headerView.parentView.backgroundColor = AppColors.themeWhite
        headerView.dateLabelTopConstraint.constant = 20.0
        headerView.dataLabelBottomConstraint.constant = 7.0
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let allEvent = self.viewModel.accountLedger[self.viewModel.allDates[section]] as? [AccountDetailEvent] {
            
            return (allEvent.reduce(0) { $0 + $1.numOfRows})
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let allCount = 2
        if (indexPath.row % allCount) == 0 {
            //event header cell + (for top space)
            return 64.0 + 5.0
        }
        else if (indexPath.row % allCount) == 1 {
            //event description cell + (for bottom space)
            return 67.0 + 10.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let allEvent = self.viewModel.accountLedger[self.viewModel.allDates[indexPath.section]] as? [AccountDetailEvent] else {
            return UITableViewCell()
        }
        
        let allCount = 2
        if (indexPath.row % allCount) == 0 {
            //event header cell
            return self.getEventHeaderCell(forData: allEvent[Int(indexPath.row/allCount)])
        }
        else if (indexPath.row % allCount) == 1 {
            //event description cell
            let idx = Int(indexPath.row/allCount)
            let cell = self.getEventDescriptionCell(forData: allEvent[idx]) as! AccountDetailEventDescriptionCell
            cell.mainContainerBottomConstraint.constant = (idx == (allEvent.count-1)) ? 5.0 : 10.0
            return cell
        }
        
        return UITableViewCell()
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
}
