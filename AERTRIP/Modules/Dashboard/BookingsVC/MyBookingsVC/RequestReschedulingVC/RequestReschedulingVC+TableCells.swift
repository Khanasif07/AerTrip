//
//  RequestReschedulingVC+TableCells.swift
//  AERTRIP
//
//  Created by Admin on 05/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//MARK:- Extensions
//MARK:============
extension RequestReschedulingVC {
    
    func getFlightDetailsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParallelLabelsTableViewCell.reusableIdentifier, for: indexPath) as? ParallelLabelsTableViewCell else { return UITableViewCell() }
        cell.configureCell(leftTitle: "Mumbai → Delhi", rightTitle: "3 Passengers", topConstraint: 10.0, bottomConstraint: 11.0, leftTitleFont: AppFonts.SemiBold.withSize(22.0), rightTitleFont: AppFonts.Regular.withSize(16.0), rightTitleTextColor: AppColors.themeGray40)
        return cell
    }
    
    func getSelectDateTableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectDateTableViewCell.reusableIdentifier, for: indexPath) as? SelectDateTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func getPreferredFlightNoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCSpecialRequestTextfieldCell.reusableIdentifier, for: indexPath) as? HCSpecialRequestTextfieldCell else { return UITableViewCell() }
        cell.delegate = self
        cell.topDividerViewLeadingConstraints.constant = 16.0
        cell.bottomDividerViewLeadingConstraints.constant = 0.0
        cell.bottomDividerViewTrailingConstraints.constant = 0.0
        cell.containerViewHeightConstraint.constant = 60.0
        cell.configCell(placeHolderText: LocalizedString.preferredFlightNo.localized)
        return cell
    }
    
    func getEmptyTableCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier, for: indexPath) as? EmptyTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = AppColors.themeGray20
        cell.topDividerView.isHidden = true
        return cell
    }
    
    func getCustomerContactCellTableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomerContactCellTableViewCell.reusableIdentifier, for: indexPath) as? CustomerContactCellTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = AppColors.themeGray20
        return cell
    }
    
    func getTotalRefundCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParallelLabelsTableViewCell.reusableIdentifier, for: indexPath) as? ParallelLabelsTableViewCell else { return UITableViewCell() }
        cell.configureCell(leftTitle: "Total Net Refund", rightTitle: "₹ 1,47,000")
        return cell
    }
    
}
