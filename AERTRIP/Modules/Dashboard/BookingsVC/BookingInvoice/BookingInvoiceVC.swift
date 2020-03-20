//
//  BookingInvoiceVC.swift
//  AERTRIP
//
//  Created by apple on 20/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingInvoiceVC: BaseVC {
    // MARK: - IBOutlet
    
    @IBOutlet weak var topNavBar: TopNavigationView!
    @IBOutlet weak var invoiceTableView: ATTableView!
    
    // MARK: - Variables
    let viewModel = BookingInvoiceVM()
    let cellIdentifier = "FareSectionHeader"
    var isBaseFareSectionExpanded: Bool = true
    var isGrossFareSectionExpanded: Bool = true
    
    // MARK: - Override methods
    
    override func initialSetup() {
        self.setupNavBar()
        self.registerXib()
        
        self.invoiceTableView.dataSource = self
        self.invoiceTableView.delegate = self
        self.invoiceTableView.reloadData()
    }
    
    override func setupNavBar() {
        self.topNavBar.delegate = self
        self.topNavBar.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.topNavBar.navTitleLabel.textColor = AppColors.textFieldTextColor51
        
        let navTitle = self.viewModel.isForReceipt ? LocalizedString.Receipt.localized : LocalizedString.Booking.localized
        self.topNavBar.configureNavBar(title: navTitle, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: true)
        self.invoiceTableView.backgroundColor = AppColors.themeGray04
    }
    
    // MARK: - Helper methods
    
    private func registerXib() {
        self.invoiceTableView.register(UINib(nibName: AppConstants.ktableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: AppConstants.ktableViewHeaderViewIdentifier)
        self.invoiceTableView.registerCell(nibName: BookingCallTableViewCell.reusableIdentifier)
        self.invoiceTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.invoiceTableView.registerCell(nibName: DiscountCell.reusableIdentifier)
        self.invoiceTableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.cellIdentifier)
        self.invoiceTableView.registerCell(nibName: TotalPayableNowCell.reusableIdentifier)
        self.invoiceTableView.registerCell(nibName: TotalPayableNowWithIconCell.reusableIdentifier)
        self.invoiceTableView.registerCell(nibName: BookingDateVoucherTableViewCell.reusableIdentifier)
        self.invoiceTableView.registerCell(nibName: DownloadInvoiceTableViewCell.reusableIdentifier)
    }
    
    private func getReceiptDetailCell() -> UITableViewCell {
        guard let totalPayableCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "TotalPayableNowWithIconCell") as? TotalPayableNowWithIconCell else {
            fatalError("TotalPayableNowCell not found")
        }
        
        totalPayableCell.topDeviderView.isHidden = true
        totalPayableCell.bottomDeviderView.isHidden = true
        let txt = self.viewModel.voucher?.paymentInfo?.paymentTitle ?? LocalizedString.dash.localized
        totalPayableCell.totalPayableNowLabel.text = txt
        if txt.lowercased().contains("banking"){
            totalPayableCell.paymentImageView.image = AppImage.netBanking
        }else{
            totalPayableCell.paymentImageView.image = AppImage.visa
        }
        
        totalPayableCell.totalPayableNowLabel.font = AppFonts.Regular.withSize(18.0)
        
        totalPayableCell.totalPriceLabel.text = ""
        
        return totalPayableCell
    }
    
    private func getCellForFirstSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let bookingVoucherCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "BookingDateVoucherTableViewCell") as? BookingDateVoucherTableViewCell else {
                fatalError("BookingVoucherTableViewCell not found")
            }
            
            var dateStr = self.viewModel.voucher?.basic?.transactionDateTime?.toString(dateFormat: "EEE, dd MMM yyyy") ?? ""
            dateStr = dateStr.isEmpty ? LocalizedString.dash.localized : dateStr
            
            var voucherStr = self.viewModel.voucher?.basic?.voucherNo ?? ""
            voucherStr = voucherStr.isEmpty ? LocalizedString.dash.localized : voucherStr
            
            bookingVoucherCell.configureCell(date: dateStr, voucher: voucherStr)
            return bookingVoucherCell
        case 1:
            guard let emptyCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as? EmptyTableViewCell else {
                fatalError("EmptyTableViewCell not found")
            }
            return emptyCell
        default:
            return UITableViewCell()
        }
    }
    
    private func handleDiscountArrowAnimation(_ headerView: FareSectionHeader) {
        let rotateTrans = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        if self.isBaseFareSectionExpanded {
            headerView.arrowButton.transform = .identity
        } else {
            headerView.arrowButton.transform = rotateTrans
        }
    }
    
    private func handleDiscountArrowAnimationforSecondSection(_ headerView: FareSectionHeader) {
        let rotateTrans = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        if self.isGrossFareSectionExpanded {
            headerView.arrowButton.transform = .identity
        } else {
            headerView.arrowButton.transform = rotateTrans
        }
    }
    
    private func getCellForSecondSection(_ indexPath: IndexPath) -> UITableViewCell {
        guard let discountCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "DiscountCell") as? DiscountCell else {
            fatalError("DiscountCell not found")
        }
        discountCell.titleLabelLeadingConstraint.constant = 30
        discountCell.titleLabelBottomConstraint.constant = 1
        discountCell.backgroundColor = .red
        let code = self.viewModel.transectionCodes[indexPath.row]
        discountCell.configureCell(title: code.ledgerName, amount: code.amount.delimiterWithSymbol)
        return discountCell
    }
    
    private func getCellForThirdSection(_ indexPath: IndexPath) -> UITableViewCell {
        
        guard let discountCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "DiscountCell") as? DiscountCell else {
            fatalError("DiscountCell not found")
        }
        discountCell.titleLabelLeadingConstraint.constant = 30
        
        let code = self.viewModel.discountCodes[indexPath.row]
        discountCell.configureCell(title: code.ledgerName, amount: code.amount.delimiterWithSymbol)
        return discountCell
    }
    
    private func getCellForFourthSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let totalPayableCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "TotalPayableNowCell") as? TotalPayableNowCell else {
                fatalError("TotalPayableNowCell not found")
            }
            
            let drAttr = NSMutableAttributedString(string: " \(LocalizedString.DebitShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
            let crAttr = NSMutableAttributedString(string: " \(LocalizedString.CreditShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])

            var amount: Double = 0.0
            var ladName: String = LocalizedString.Total.localized
            if self.viewModel.isForReceipt {
                ladName = LocalizedString.Amount.localized
                if let trans = self.viewModel.voucher?.transactions.first {
                    amount = trans.amount
                    //changed the ladger name to amount as per zeplin
                    ladName = LocalizedString.Amount.localized//trans.ledgerName
                }
            }
            else {
                if let trans = self.viewModel.voucher?.transactions.filter({ $0.ledgerName.lowercased().contains("payable")}).first {
                    
                    amount = trans.amount
                    ladName = trans.ledgerName
                }
            }
            
            totalPayableCell.totalPayableNowLabel.text = ladName
            totalPayableCell.totalPayableTextTopConstraint.constant = 5
            totalPayableCell.totalPayableTextBottomConstraint.constant = 17.5
            let grossStr = abs(amount).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(20.0))
            grossStr.append((amount > 0) ? drAttr : crAttr)
            totalPayableCell.totalPriceLabel.attributedText = grossStr
            totalPayableCell.totalPayableNowLabel.font = AppFonts.Regular.withSize(18.0)
            totalPayableCell.topDeviderView.isHidden = false
            totalPayableCell.bottomDeviderView.isHidden = true
            return totalPayableCell
        case 1:
            guard let emptyCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as? EmptyTableViewCell else {
                fatalError("EmptyTableViewCell not found")
            }
            return emptyCell
        case 2:
            guard let downloadInvoiceCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "DownloadInvoiceTableViewCell") as? DownloadInvoiceTableViewCell else {
                fatalError("DownloadInvoiceTableViewCell not found")
            }
            downloadInvoiceCell.topDividerView.isHidden = true
            
            downloadInvoiceCell.titleLabel.text = self.viewModel.isForReceipt ? LocalizedString.DownloadReceipt.localized : LocalizedString.DownloadInvoice.localized
            
            return downloadInvoiceCell
        default:
            return UITableViewCell()
        }
    }
    
    //  return height for first cell
    func getHeightForRowAtFirstSection(_ indexPath: IndexPath) -> CGFloat {
        return [73, 28][indexPath.row]
    }
    
    func getHeightForRowAtSecondSection(_ indexPath: IndexPath) -> CGFloat {
        return 25.0//[24, 24, 24, 24][indexPath.row]
    }
    
    func getHeightForRowAtThirdSection(_ indexPath: IndexPath) -> CGFloat {
        return 24.0//[24][indexPath.row]
    }
    
    func getHeightForRowAtFourthSection(_ indexPath: IndexPath) -> CGFloat {
        return [54, 28, 44][indexPath.row]
    }
}

// MARK: - UITableViewDataSource and  UITableViewDelegate methods

extension BookingInvoiceVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.isForReceipt {
            return 3
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.isForReceipt {
            return [2,1,3][section]
        }
        else {
            let transC = self.isBaseFareSectionExpanded ? self.viewModel.transectionCodes.count : 0
            let disC = self.isGrossFareSectionExpanded ? self.viewModel.discountCodes.count : 0
            return [2,transC,disC,3][section]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.isForReceipt {
            switch indexPath.section {
            case 0:
                return self.getCellForFirstSection(indexPath)
            case 1:
                return self.getReceiptDetailCell()
            case 2:
                return self.getCellForFourthSection(indexPath)
            default:
                return UITableViewCell()
            }
        }
        else {
            switch indexPath.section {
            case 0:
                return self.getCellForFirstSection(indexPath)
            case 1:
                return self.getCellForSecondSection(indexPath)
            case 2:
                return self.getCellForThirdSection(indexPath)
            case 3:
                return self.getCellForFourthSection(indexPath)
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.viewModel.isForReceipt {
            return nil
        }
        else if section == 1 {
            guard let headerView = self.invoiceTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? FareSectionHeader else {
                fatalError("FareSectionHeader not found")
            }
            headerView.delegate = self
            headerView.isDownArrow = false
            self.handleDiscountArrowAnimation(headerView)
            
            if let trans = self.viewModel.voucher?.transactions.filter({ $0.ledgerName.lowercased().contains("base")}).first {
                headerView.grossFareTitleLabel.text = trans.ledgerName
                headerView.grossPriceLabel.text = "\(trans.amount.delimiterWithSymbol)"
            }
            else {
                headerView.grossFareTitleLabel.text = "Base Fare"
                headerView.grossPriceLabel.text = "\(Double(0).delimiterWithSymbol)"
            }
            
            if let trans = self.viewModel.voucher?.transactions.filter({ $0.ledgerName.lowercased().contains("taxes")}).first {
                headerView.discountContainer.isHidden = false
                headerView.discountsTitleLabel.text = trans.ledgerName
                headerView.discountPriceLabel.text = "\(trans.amount.delimiterWithSymbol)"
            }
            else {
                headerView.discountContainer.isHidden = false
                headerView.discountsTitleLabel.text = "Taxes and Fees"
                headerView.discountPriceLabel.text = "\(Double(0).delimiterWithSymbol)"
            }
            
            headerView.tag = section
            return headerView
            
        } else if section == 2 {
            guard let headerView = self.invoiceTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? FareSectionHeader else {
                fatalError("FareSectionHeader not found")
            }
            headerView.arrowButton.transform = CGAffineTransform(rotationAngle: CGFloat(2 * Double.pi))
            headerView.isDownArrow = false
            self.handleDiscountArrowAnimationforSecondSection(headerView)
            
            if let trans = self.viewModel.voucher?.transactions.filter({ $0.ledgerName.lowercased().contains("gross")}).first {
                headerView.grossFareTitleLabel.text = trans.ledgerName
                headerView.grossPriceLabel.text = "\(trans.amount.delimiterWithSymbol)"
            }
            else {
                headerView.grossFareTitleLabel.text = "Gross Fare"
                headerView.grossPriceLabel.text = "\(Double(0).delimiterWithSymbol)"
            }
            
            if let trans = self.viewModel.voucher?.transactions.filter({ $0.ledgerName.lowercased().contains("discounts")}).first {
                headerView.discountContainer.isHidden = false
                headerView.discountsTitleLabel.text = trans.ledgerName
                headerView.discountPriceLabel.text = "\(trans.amount.delimiterWithSymbol)"
            }
            else {
                headerView.discountContainer.isHidden = true
            }
            
            headerView.delegate = self
            
            headerView.tag = section
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.viewModel.isForReceipt {
            return 0
        }
        else {
            switch section {
            case 1:
                return 64.0
            case 2:
                if let _ = self.viewModel.voucher?.transactions.filter({ $0.ledgerName.lowercased().contains("discounts")}).first {
                    return 64.0
                }
                return 32.0
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.viewModel.isForReceipt {
            switch indexPath.section {
            case 0:
                return self.getHeightForRowAtFirstSection(indexPath)
            case 1:
                return 45.0
            case 2:
                return self.getHeightForRowAtFourthSection(indexPath)
            default:
                return 0
            }
        }
        else {
            switch indexPath.section {
            case 0:
                return self.getHeightForRowAtFirstSection(indexPath)
            case 1:
                return self.getHeightForRowAtSecondSection(indexPath)
            case 2:
                return self.getHeightForRowAtThirdSection(indexPath)
            case 3:
                return self.getHeightForRowAtFourthSection(indexPath)
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3, indexPath.row == 2 {
            //download invoice
            if let bID = self.viewModel.voucher?.basic?.transactionId, !bID.isEmpty {
                AppGlobals.shared.viewPdf(urlPath: "\(APIEndPoint.baseUrlPath.path)dashboard/download-voucher?id=\(bID)", screenTitle: "Booking Invoice")
            }
        }
        else if indexPath.section == 2, indexPath.row == 2 {
            //download receipt
            if let bID = self.viewModel.voucher?.basic?.transactionId, !bID.isEmpty {
                AppGlobals.shared.viewPdf(urlPath: "\(APIEndPoint.baseUrlPath.path)dashboard/download-voucher?id=\(bID)", screenTitle: "Receipt Voucher")
            }
        }
    }
}

// MARK: - Top Navigation View Delegate methods

extension BookingInvoiceVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

extension BookingInvoiceVC: FareSectionHeaderDelegate {
    func headerViewTapped(_ view: UITableViewHeaderFooterView) {
        let section = view.tag
        if section == 1 {
            if self.isBaseFareSectionExpanded {
                self.isBaseFareSectionExpanded = false
            } else {
                self.isBaseFareSectionExpanded = true
            }
        } else if section == 2 {
            if self.isGrossFareSectionExpanded {
                self.isGrossFareSectionExpanded = false
            } else {
                self.isGrossFareSectionExpanded = true
            }
        }
        self.invoiceTableView.reloadData()
    }
}
