//
//  AccountOnlineDepositVC+DelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 01/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit


// MARK: - UITableViewDataSource and UITableViewDelegate
extension AccountOnlineDepositVC: UITableViewDataSource, UITableViewDelegate {
    
    private func getCellForFirstSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            //deposit amoutn cell
            guard let depositCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: AccountDepositAmountCell.reusableIdentifier, for: indexPath) as? AccountDepositAmountCell else {
                printDebug("Cell not found")
                return UITableViewCell()
            }
            
            return depositCell
            
        case 1:
            //blank gap
            guard let emptyCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier, for: indexPath) as? EmptyTableViewCell else {
                printDebug("Cell not found")
                return UITableViewCell()
            }
            emptyCell.clipsToBounds = true
            return emptyCell
            
        case 2:
            //fare details
            guard let fareDetailCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: FareDetailTableViewCell.reusableIdentifier, for: indexPath) as? FareDetailTableViewCell else {
                printDebug("FareDetailTableViewCell not found")
                return UITableViewCell()
            }
            fareDetailCell.fareDetailTitleLabel.text = LocalizedString.Breakup.localized
            fareDetailCell.numberOfRoomAndLabel.text = ""
            return fareDetailCell
            
        case 3:
            //deposit amount
            guard let totalPayableNowCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TotalPayableNowCell.reusableIdentifier, for: indexPath) as? TotalPayableNowCell else {
                printDebug("TotalPayableNowCell not found")
                return UITableViewCell()
            }
            
            totalPayableNowCell.currentUsingFor = .normal
            totalPayableNowCell.totalPayableNowLabel.text = LocalizedString.DepositAmount.localized
            
            totalPayableNowCell.totalPriceLabel.text = self.viewModel.depositAmount.amountInDelimeterWithSymbol
            
            totalPayableNowCell.topDeviderView.isHidden = true
            totalPayableNowCell.bottomDeviderView.isHidden = true
            totalPayableNowCell.totalPayableTextBottomConstraint.constant = 16.0
            return totalPayableNowCell
            
        case 4:
            //conv fee amount
            guard let totalPayableNowCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TotalPayableNowCell.reusableIdentifier, for: indexPath) as? TotalPayableNowCell else {
                printDebug("TotalPayableNowCell not found")
                return UITableViewCell()
            }
            
            totalPayableNowCell.currentUsingFor = .normal
            totalPayableNowCell.totalPayableNowLabel.text = LocalizedString.ConvenienceFeeNonRefundable.localized
            
            totalPayableNowCell.totalPriceLabel.text = self.viewModel.feeAmount.amountInDelimeterWithSymbol
            
            totalPayableNowCell.topDeviderView.isHidden = true
            totalPayableNowCell.bottomDeviderView.isHidden = true
            totalPayableNowCell.totalPayableTextBottomConstraint.constant = 16.0
            return totalPayableNowCell
            
        case 5:
            // Total pay now Cell
            guard let totalPayableNowCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TotalPayableNowCell.reusableIdentifier, for: indexPath) as? TotalPayableNowCell else {
                printDebug("TotalPayableNowCell not found")
                return UITableViewCell()
            }
            totalPayableNowCell.totalPriceLabel.text = self.viewModel.totalPayableAmount.amountInDelimeterWithSymbol
            totalPayableNowCell.topDeviderView.isHidden = false
            totalPayableNowCell.bottomDeviderView.isHidden = true
            return totalPayableNowCell
            
        case 6:
            // Term and privacy Cell
            guard let termAndPrivacCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TermAndPrivacyTableViewCell.reusableIdentifier, for: indexPath) as? TermAndPrivacyTableViewCell else {
                return UITableViewCell()
            }
            termAndPrivacCell.currentUsingFrom = .accountCheckout
            return termAndPrivacCell
            
        default:
            return UITableViewCell()
        }
    }
    
    private func getHeightOfRowForFirstSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            //deposit amoutn cell
            return 92.0
            
        case 1:
            //blank gap
            return 35.0
            
        case 2:
            //fare details
            return 50.0
            
        case 3:
            //deposit amount
            return 29.0
            
        case 4:
            //conv fee amount
            return 29.0
            
        case 5:
            // Total pay now Cell
            return 46.0
            
        case 6:
            // Term and privacy Cell
            return 120.0
            
        default:
            return 0.0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getCellForFirstSection(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.getHeightOfRowForFirstSection(indexPath)
    }
}

// MARK: - TopNavigationView Delegate methods

extension AccountOnlineDepositVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

extension AccountOnlineDepositVC: AccountOnlineDepositVMDelegate {
    
}


//extension AccountOnlineDepositVC : WalletTableViewCellDelegate {
//    func valueForSwitch(isOn: Bool) {
//        self.isWallet = (getWalletAmount() <= 0) ? false : isOn
//        self.setConvenienceFeeToBeApplied()
//        
//    }
//}
//
//
//extension AccountOnlineDepositVC : ApplyCouponTableViewCellDelegate {
//    func removeCouponTapped() {
//        printDebug("Remove coupon tapped")
//        self.viewModel.removeCouponCode()
//    }
//}
//
//extension AccountOnlineDepositVC : FareSectionHeaderDelegate {
//    func headerViewTapped() {
//        printDebug("Header View Tapped")
//        if self.isCouponApplied {
//            if self.isCouponSectionExpanded {
//                  self.isCouponSectionExpanded = false
//            } else {
//                self.isCouponSectionExpanded = true
//            }
//          self.checkOutTableView.reloadData()
//        }
//    }
//}
//
//
