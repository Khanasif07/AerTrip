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
        
        let legD = self.viewModel.legsWithSelection[indexPath.section]
        cell.configureCell(leftTitle: legD.title, rightTitle: "\(legD.selectedPaxs.count) \(LocalizedString.Passenger.localized)\((legD.selectedPaxs.count > 1) ? "s" : "")", topConstraint: 10.0, bottomConstraint: 11.0, leftTitleFont: AppFonts.SemiBold.withSize(22.0), rightTitleFont: AppFonts.Regular.withSize(16.0), rightTitleTextColor: AppColors.themeGray40)
        return cell
    }
    
    func getSelectDateTableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectDateTableViewCell.reusableIdentifier, for: indexPath) as? SelectDateTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        return cell
    }
    
    func getPreferredFlightNoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCSpecialRequestTextfieldCell.reusableIdentifier, for: indexPath) as? HCSpecialRequestTextfieldCell else { return UITableViewCell() }
        cell.delegate = self
        cell.bottomDividerViewLeadingConstraints.constant = 0.0
        cell.bottomDividerViewTrailingConstraints.constant = 0.0
        cell.topDividerViewLeadingConstraints.constant = 16.0
        cell.containerViewHeightConstraint.constant = 60.0
        cell.configCell(placeHolderText: LocalizedString.preferredFlightNo.localized)
        return cell
    }
    
    func getEmptyTableCell(_ tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier) as? EmptyTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = AppColors.themeGray20
        cell.topDividerView.isHidden = true
        return cell
    }
    
    func getCustomerContactCellTableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomerContactCellTableViewCell.reusableIdentifier, for: indexPath) as? CustomerContactCellTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = AppColors.themeGray20
        cell.dividerView.isHidden = true
        return cell
    }
    
    func getTotalRefundCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParallelLabelsTableViewCell.reusableIdentifier, for: indexPath) as? ParallelLabelsTableViewCell else { return UITableViewCell() }
        cell.configureCell(leftTitle: "Total Net Refund", rightTitle: self.viewModel.totRefund.delimiterWithSymbol)
        return cell
    }
    
}
