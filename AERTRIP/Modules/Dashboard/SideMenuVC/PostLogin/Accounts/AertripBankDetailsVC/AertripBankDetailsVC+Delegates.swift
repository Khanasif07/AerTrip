//
//  AertripBankDetailsVC+Delegates.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//MARK:- tableView datasource and delegate methods
//MARK:-
extension AertripBankDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.allBanks.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier) as? EmptyTableViewCell else {
            return nil
        }
        cell.contentView.backgroundColor = AppColors.themeGray04
        cell.bottomDividerView.isHidden = (self.viewModel.allBanks.count - 1) == section
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return [72.0, 50.0, 30.0, 30.0, 30.0, 30.0, 30.0, 75.0][indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bankDetail = self.viewModel.allBanks[indexPath.section]
        switch indexPath.row {
        case 0:
            //title
            return self.getBankTitleCell(title: bankDetail.bankName)
            
        case 1:
            //chaque deposite message
            return self.getDepositeMessageCell()
            
        case 2:
            //a/c number
            return self.getDetailCell(title: LocalizedString.ACNumber.localized, value: bankDetail.accountNumber)
            
        case 3:
            //a/c name
            return self.getDetailCell(title: LocalizedString.ACName.localized, value: bankDetail.accountName)
            
        case 4:
            //branch
            return self.getDetailCell(title: LocalizedString.BankBranch.localized, value: bankDetail.branchName)
            
        case 5:
            //ifsc
            return self.getDetailCell(title: LocalizedString.IFSCCode.localized, value: bankDetail.ifsc)
            
        case 6:
            //a/c type
            return self.getDetailCell(title: LocalizedString.AccountType.localized, value: bankDetail.accType)
            
        case 7:
            //download slip
            return self.getDownloadSlipCell()
        
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 7 && !self.viewModel.allBanks[indexPath.section].depositSlip.isEmpty{
            //download slip
            AppGlobals.shared.viewPdf(urlPath: self.viewModel.allBanks[indexPath.section].depositSlip, screenTitle: "Slip")
        }
    }
    
    func getBankTitleCell(title: String) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: OfflineDepositeTextImageCell.reusableIdentifier) as? OfflineDepositeTextImageCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        
        cell.isHiddenButton = true
        cell.valueLabel.isHidden = true
        cell.titleLabel.font = AppFonts.SemiBold.withSize(22.0)
        cell.titleLabel.textColor = AppColors.themeBlack
        cell.titleLabel.text = title
        cell.dividerView.isHidden = true
        cell.titleTopConstraint.constant = 0.0
        cell.titleBottomConstraint.constant = 8.0
        
        return cell
    }
    
    func getDepositeMessageCell() -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: OfflineDepositeTextImageCell.reusableIdentifier) as? OfflineDepositeTextImageCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        
        cell.isHiddenButton = true
        cell.valueLabel.isHidden = true
        cell.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        cell.titleLabel.textColor = AppColors.themeBlack
        cell.titleLabel.text = LocalizedString.ChequeShouldDepositedInAccount.localized
        cell.dividerView.isHidden = true
        cell.titleTopConstraint.constant = -4.0
        cell.titleBottomConstraint.constant = 0.0
        
        return cell
    }
    
    func getDetailCell(title: String, value: String) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: OfflineDepositeTextImageCell.reusableIdentifier) as? OfflineDepositeTextImageCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        
        cell.isHiddenButton = true
        cell.titleLabel.font = AppFonts.Regular.withSize(16.0)
        cell.titleLabel.textColor = AppColors.themeBlack
        cell.titleLabel.text = title
        
        cell.valueLabel.isHidden = false
        cell.valueLabel.font = AppFonts.SemiBold.withSize(16.0)
        cell.valueLabel.textColor = AppColors.themeTextColor
        cell.valueLabel.text = value.isEmpty ? LocalizedString.dash.localized : value
        
        cell.dividerView.isHidden = true
        cell.titleTopConstraint.constant = 0.0
        cell.titleBottomConstraint.constant = 0.0
        
        return cell
    }
    
    func getDownloadSlipCell() -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: OfflineDepositeTextImageCell.reusableIdentifier) as? OfflineDepositeTextImageCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        
        cell.isHiddenButton = true
        cell.valueLabel.isHidden = true
        cell.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        cell.titleLabel.textColor = AppColors.themeGreen
        cell.titleLabel.text = LocalizedString.DownloadBlankDepositSlip.localized
        cell.dividerView.isHidden = true
        cell.titleTopConstraint.constant = 0.0
        cell.titleBottomConstraint.constant = 0.0
        
        return cell
    }
}
