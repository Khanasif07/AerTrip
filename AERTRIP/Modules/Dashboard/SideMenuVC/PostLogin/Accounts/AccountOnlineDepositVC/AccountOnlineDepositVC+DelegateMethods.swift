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
            //deposit amount cell
            guard let depositCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: AccountDepositAmountCell.reusableIdentifier, for: indexPath) as? AccountDepositAmountCell else {
                printDebug("Cell not found")
                return UITableViewCell()
            }
            
            depositCell.delegate = self
            depositCell.amount = self.viewModel.depositAmount
            
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
            fareDetailCell.dividerView.isHidden = true
            return fareDetailCell
            
        case 3:
            //deposit amount
            guard let totalPayableNowCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TotalPayableNowCell.reusableIdentifier, for: indexPath) as? TotalPayableNowCell else {
                printDebug("TotalPayableNowCell not found")
                return UITableViewCell()
            }
            
            totalPayableNowCell.currentUsingFor = .normal
            totalPayableNowCell.totalPayableNowLabel.text = LocalizedString.DepositAmount.localized
            
            totalPayableNowCell.totalPriceLabel.attributedText = self.viewModel.depositAmount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(16.0))
            
            totalPayableNowCell.topDeviderView.isHidden = true
            totalPayableNowCell.bottomDeviderView.isHidden = true
            totalPayableNowCell.totalPayableTextTopConstraint.constant = -4.0
            totalPayableNowCell.totalPayableTextBottomConstraint.constant = 12.0
            return totalPayableNowCell
            
        case 4:
            //conv fee amount
            guard let totalPayableNowCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TotalPayableNowCell.reusableIdentifier, for: indexPath) as? TotalPayableNowCell else {
                printDebug("TotalPayableNowCell not found")
                return UITableViewCell()
            }
            
            totalPayableNowCell.currentUsingFor = .normal
            totalPayableNowCell.totalPayableNowLabel.text = LocalizedString.ConvenienceFeeNonRefundable.localized
            
            totalPayableNowCell.totalPriceLabel.attributedText = self.viewModel.feeAmount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(16.0))
            
            totalPayableNowCell.topDeviderView.isHidden = true
            totalPayableNowCell.bottomDeviderView.isHidden = true
            totalPayableNowCell.totalPayableTextTopConstraint.constant = -4.0
            totalPayableNowCell.totalPayableTextBottomConstraint.constant = 12.0
            return totalPayableNowCell
            
        case 5:
            // Total pay now Cell
            guard let totalPayableNowCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TotalPayableNowCell.reusableIdentifier, for: indexPath) as? TotalPayableNowCell else {
                printDebug("TotalPayableNowCell not found")
                return UITableViewCell()
            }
            totalPayableNowCell.totalPriceLabel.attributedText = self.viewModel.totalPayableAmount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(20.0))
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
            return 110.0
            
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


extension AccountOnlineDepositVC: AccountDepositAmountCellDelegate {
    func amountDidChanged(amount: Double, amountString: String) {
        self.viewModel.depositItinerary?.partPaymentAmount = amount
        self.updatePayButtonText()
        self.checkOutTableView.reloadData()
    }
}

// MARK: - TopNavigationView Delegate methods

extension AccountOnlineDepositVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

extension AccountOnlineDepositVC: AccountOnlineDepositVMDelegate {
    func willMakePayment() {
        self.manageLoader(shouldStart: true)
    }
    
    func makePaymentSuccess(options: JSONDictionary) {
        self.manageLoader(shouldStart: false)
        self.initializePayment(withOptions: options)
    }
    
    func makePaymentFail() {
        self.manageLoader(shouldStart: false)
    }
}
