//
//  BookingVoucherVC.swift
//  AERTRIP
//
//  Created by apple on 17/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingVoucherVC: BaseVC {
    
    // MARK:- IBOutlet
    @IBOutlet weak var voucherTableView: ATTableView!
    @IBOutlet weak var topNavigationView: TopNavigationView!
    
    
    var payButtonRef: ATButton?
    // MARK:- Variables
    let viewModel = BookingVoucherVM()
    
    // MARK:- View life cycle
    
    override func initialSetup() {
        self.voucherTableView.dataSource = self
        self.voucherTableView.delegate = self
        self.registerXib()
    }
    
    // MARK:- Helper methods
    
    override func setupNavBar() {
        self.topNavigationView.configureNavBar(title: LocalizedString.Vouchers.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: true)
        
        self.topNavigationView.delegate = self
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    func registerXib() {
        self.voucherTableView.registerCell(nibName: BookingVoucherTableViewCell.reusableIdentifier)
        self.voucherTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.voucherTableView.reloadData()
    }
    
    private func showDepositOptions() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.PayOnline.localized, LocalizedString.PayOfflineNRegister.localized, LocalizedString.ChequeDemandDraft.localized, LocalizedString.FundTransfer.localized], colors: [AppColors.themeDarkGreen, AppColors.themeGray40, AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            
            switch index {
            case 0:
                //PayOnline
                AppFlowManager.default.moveToAccountOnlineDepositVC(depositItinerary: self.viewModel.itineraryData, usingToPaymentFor: .addOns)
                
            case 2:
                //ChequeDemandDraft
                AppFlowManager.default.moveToAccountOfflineDepositVC(usingFor: .chequeOrDD, usingToPaymentFor: .addOns, paymentModeDetail: self.viewModel.itineraryData?.chequeOrDD, netAmount: self.viewModel.itineraryData?.netAmount ?? 0.0, bankMaster: self.viewModel.itineraryData?.bankMaster ?? [])
                printDebug("ChequeDemandDraft")
                
            case 3:
                //FundTransfer
                AppFlowManager.default.moveToAccountOfflineDepositVC(usingFor: .fundTransfer, usingToPaymentFor: .addOns, paymentModeDetail: self.viewModel.itineraryData?.fundTransfer, netAmount: self.viewModel.itineraryData?.netAmount ?? 0.0, bankMaster: self.viewModel.itineraryData?.bankMaster ?? [])
                printDebug("FundTransfer")
                
            default:
                printDebug("no need to implement")
            }
        }
    }
}


// MARK: - Top navigation view Delegate methods

extension BookingVoucherVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}


// MARK: - UITableViewSource and UITableViewViewDelegate

extension BookingVoucherVC: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rcpt = self.viewModel.receipt else {
            return 0
        }
        
        if let amount = self.viewModel.receipt?.totalAmountDue, amount != 0.0 {
            return [rcpt.otherVoucher.count, rcpt.receiptVoucher.count, 1][section]
        }
        return [rcpt.otherVoucher.count, rcpt.receiptVoucher.count, 0][section]
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let rcpt = self.viewModel.receipt else {
            return 0
        }
        
        switch section {
        case 0:
            return rcpt.otherVoucher.isEmpty ? 0 : 10.0
            
        case 1:
            return rcpt.receiptVoucher.isEmpty ? 0 : 10.0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard section < 2, let emptyCell = self.voucherTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as? EmptyTableViewCell else {
            return nil
        }
        
        if section == 1, let amount = self.viewModel.receipt?.totalAmountDue {
            emptyCell.bottomDividerView.isHidden = !(amount != 0.0)
        }
        
        return emptyCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let voucherCell = self.voucherTableView.dequeueReusableCell(withIdentifier: "BookingVoucherTableViewCell") as? BookingVoucherTableViewCell else {
            fatalError("BookingVoucherTableViewCell not found ")
        }
        
        if indexPath.section == 0 {
            //booking
            voucherCell.voucherData = self.viewModel.receipt?.otherVoucher[indexPath.row] ?? Voucher()
            if let count = self.viewModel.receipt?.otherVoucher.count {
                voucherCell.dividerView.isHidden = (indexPath.row == (count - 1))
            }
            voucherCell.titleLabel.text = "Booking"
        }
        else if indexPath.section == 1 {
            //receipt
            voucherCell.voucherData = self.viewModel.receipt?.receiptVoucher[indexPath.row] ?? Voucher()
            if let count = self.viewModel.receipt?.receiptVoucher.count {
                voucherCell.dividerView.isHidden = (indexPath.row == (count - 1))
            }
        }
        else {
            //pay
            voucherCell.amount = self.viewModel.receipt?.totalAmountDue ?? 0.0
        }
        
        voucherCell.payButtonAction = { button in
            AppGlobals.shared.showUnderDevelopment()
            if !self.viewModel.caseId.isEmpty {
                button.isLoading = true
                self.payButtonRef = button
                self.viewModel.getAddonPaymentItinerary()
            }
        }
        
        return voucherCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //booking
            //open booking details
            if let vchr = self.viewModel.receipt?.otherVoucher[indexPath.row] {
                AppFlowManager.default.moveToBookingInvoiceVC(forVoucher: vchr)
            }
        }
        else if indexPath.section == 1 {
            //receipt
            //open receipt details
            if let vchr = self.viewModel.receipt?.receiptVoucher[indexPath.row] {
                AppFlowManager.default.moveToBookingInvoiceVC(forVoucher: vchr)
            }
        }
    }
}


extension BookingVoucherVC: BookingVoucherVMDelegate {
    func getAddonPaymentItinerarySuccess() {
        self.payButtonRef?.isLoading = false
        self.showDepositOptions()
    }
    
    func getAddonPaymentItineraryFail() {
        self.payButtonRef?.isLoading = false
    }
}
