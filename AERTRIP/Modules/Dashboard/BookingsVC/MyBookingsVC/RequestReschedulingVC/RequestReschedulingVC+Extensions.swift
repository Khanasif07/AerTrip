//
//  RequestReschedulingVC+Extensions.swift
//  AERTRIP
//
//  Created by Admin on 05/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension RequestReschedulingVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sectionData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.sectionData[indexPath.section][indexPath.row] {
        case .flightDetailsCell:
            return getFlightDetailsCell(tableView, indexPath: indexPath)
        case .selectDateCell:
            return getSelectDateTableViewCell(tableView, indexPath: indexPath)
        case .preferredFlightNoCell:
            return getPreferredFlightNoCell(tableView, indexPath: indexPath)
        case .emptyCell:
            return getEmptyTableCell(tableView, indexPath: indexPath)
        case .customerExecutiveCell:
            return getCustomerContactCellTableViewCell(tableView, indexPath: indexPath)
        case .totalNetRefundCell:
            return getTotalRefundCell(tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow(tableView, indexPath: indexPath)
    }
}

extension RequestReschedulingVC: BookingTopNavBarWithSubtitleDelegate {
    
    func leftButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RequestReschedulingVC: HCSpecialRequestTextfieldCellDelegate {
    func didPassSpecialRequestAndAirLineText(infoText: String, indexPath: IndexPath) {
        printDebug(infoText)
        printDebug(indexPath)
    }
}
