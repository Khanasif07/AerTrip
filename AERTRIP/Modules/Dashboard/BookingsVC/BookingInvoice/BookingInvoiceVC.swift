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
    var isDownloadingRecipt = false
    let refreshControl = UIRefreshControl()
    //    var isBaseFareSectionExpanded: Bool = true
    //    var isGrossFareSectionExpanded: Bool = true
    
    // MARK: - Override methods
    
    override func initialSetup() {
        self.invoiceTableView.contentInset = UIEdgeInsets(top: topNavBar.height - 0.5 , left: 0.0, bottom: 10.0, right: 0.0)

        self.setupNavBar()
        self.registerXib()
        
        self.invoiceTableView.dataSource = self
        self.invoiceTableView.delegate = self
        self.invoiceTableView.reloadData()
        
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.refreshControl.tintColor = AppColors.themeGreen
        self.invoiceTableView.refreshControl = refreshControl
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func setupNavBar() {
        self.topNavBar.delegate = self
        self.topNavBar.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.topNavBar.navTitleLabel.textColor = AppColors.textFieldTextColor51
        
        var navTitle = ""
        if self.viewModel.isForReceipt {
            navTitle = LocalizedString.Receipt.localized
        } else {
            navTitle = self.viewModel.voucher?.basic?.event ?? LocalizedString.Booking.localized
        }
//        let navTitle = self.viewModel.isForReceipt ? LocalizedString.Receipt.localized : LocalizedString.Booking.localized
        self.topNavBar.configureNavBar(title: navTitle, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: true)
        self.invoiceTableView.backgroundColor = AppColors.themeGray04
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.viewModel.getBookingDetail()
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

        let paymentMethod = self.viewModel.voucher?.paymentInfo?.method.rawValue ?? LocalizedString.dash.localized
        if paymentMethod == "wallet"{

            if  self.viewModel.voucher?.paymentInfo?.walletName.lowercased() == "mobikwik"{
                totalPayableCell.paymentImageView.image = AppImage.mobikwik

            }
        }else{
            if txt.lowercased().contains("banking"){
                totalPayableCell.paymentImageView.image = AppImage.netBanking
            }else{
                totalPayableCell.paymentImageView.image = AppImage.visa
            }
        }

        totalPayableCell.totalPayableNowLabel.text = txt
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
            bookingVoucherCell.dividerView.isHidden = false
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
    
    private func handleTaxesArrowAnimation(_ headerView: FareSectionHeader) {
        let rotateTrans = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        if self.viewModel.isBaseFareSectionExpanded {
            headerView.arrowButton.transform = .identity
        } else {
            headerView.arrowButton.transform = rotateTrans
        }
    }
    
    private func handleCancellationArrowAnimation(_ headerView: FareSectionHeader) {
        let rotateTrans = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        if self.viewModel.isCancellationSectionExpanded {
            headerView.arrowButton.transform = .identity
        } else {
            headerView.arrowButton.transform = rotateTrans
        }
    }
    private func handleDiscountArrowAnimation(_ headerView: FareSectionHeader) {
        let rotateTrans = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        if self.viewModel.isGrossFareSectionExpanded {
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
        discountCell.titleLabelTopConstraint.constant = 5
        discountCell.backgroundColor = .red
        let code = self.viewModel.transectionCodes[indexPath.row]
        discountCell.configureCellForInvoice(title: code.ledgerName, amount: code.amount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(14.0)))
        return discountCell
    }
    
    private func getCellForCancellationSection(_ indexPath: IndexPath) -> UITableViewCell {
        guard let discountCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "DiscountCell") as? DiscountCell else {
            fatalError("DiscountCell not found")
        }
        discountCell.titleLabelLeadingConstraint.constant = 30
        discountCell.titleLabelBottomConstraint.constant = 1
        discountCell.titleLabelTopConstraint.constant = 5
        discountCell.backgroundColor = .red
        let code = self.viewModel.cancellationCodes[indexPath.row]
        discountCell.configureCellForInvoice(title: code.ledgerName, amount: code.amount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(14.0)))
        return discountCell
    }
    
    private func getCellForThirdSection(_ indexPath: IndexPath) -> UITableViewCell {
        
        guard let discountCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "DiscountCell") as? DiscountCell else {
            fatalError("DiscountCell not found")
        }
        discountCell.titleLabelLeadingConstraint.constant = 30
        discountCell.titleLabelBottomConstraint.constant = 6
        
        let code = self.viewModel.discountCodes[indexPath.row]
        discountCell.configureCellForInvoice(title: code.ledgerName, amount:code.amount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(14.0)))
        return discountCell
    }
    
    private func getCellForFourthSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let totalPayableCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "TotalPayableNowCell") as? TotalPayableNowCell else {
                fatalError("TotalPayableNowCell not found")
            }
            
            let drAttr = NSMutableAttributedString(string: " \(LocalizedString.DebitShort.localized)", attributes: [.font: AppFonts.SemiBold.withSize(16.0)])
            let crAttr = NSMutableAttributedString(string: " \(LocalizedString.CreditShort.localized)", attributes: [.font: AppFonts.SemiBold.withSize(16.0)])
            
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
                //                if let trans = self.viewModel.voucher?.transactions.filter({ $0.ledgerName.lowercased().contains("total")}).first {
                //
                //                    amount = trans.amount
                //                    ladName = trans.ledgerName
                //                }
                let sectionHeader = self.viewModel.sectionHeader[indexPath.section]
                amount = sectionHeader.amount
                ladName = sectionHeader.title
            }
            printDebug("ladName: \(ladName)")
            totalPayableCell.totalPayableNowLabel.text = ladName
            totalPayableCell.totalPayableTextTopConstraint.constant = 8
            totalPayableCell.totalPayableTextBottomConstraint.constant = 13.0
            let grossStr = abs(amount).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(20.0))
            grossStr.append((amount > 0) ? drAttr : crAttr)
            totalPayableCell.totalPriceLabel.attributedText = grossStr
            totalPayableCell.totalPayableNowLabel.font = AppFonts.Regular.withSize(20.0)
            totalPayableCell.topDeviderView.isHidden = false
            totalPayableCell.bottomDeviderView.isHidden = true
            if self.numberOfSections(in: self.invoiceTableView) == 2 {
                totalPayableCell.topDeviderView.isHidden = true
            }
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
            downloadInvoiceCell.showLoader = self.isDownloadingRecipt
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

    func getHeightForRowAtCancellationSection(_ indexPath: IndexPath) -> CGFloat {
        return 25.0//[24, 24, 24, 24][indexPath.row]
    }

    func getHeightForRowAtThirdSection(_ indexPath: IndexPath) -> CGFloat {
        return 24.0//[24][indexPath.row]
    }
    
    func getHeightForRowAtFourthSection(_ indexPath: IndexPath) -> CGFloat {
        return [46, 28, 44][indexPath.row]
    }
}

// MARK: - UITableViewDataSource and  UITableViewDelegate methods

extension BookingInvoiceVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.isForReceipt {
            return 3
        }
        return self.viewModel.sectionHeader.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.isForReceipt {
            return [2,1,3][section]
        }
        else {
            switch self.viewModel.sectionHeader[section].section {
            case .taxes:
                return self.viewModel.isBaseFareSectionExpanded ? self.viewModel.sectionHeader[section].rowCount : 0
            case .discount:
                return self.viewModel.isGrossFareSectionExpanded ? self.viewModel.sectionHeader[section].rowCount : 0
            case .cancellation:
                return self.viewModel.isCancellationSectionExpanded ? self.viewModel.sectionHeader[section].rowCount : 0
            default:
                return self.viewModel.sectionHeader[section].rowCount
            }
            
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
            switch self.viewModel.sectionHeader[indexPath.section].section {
            case .details:
                return self.getCellForFirstSection(indexPath)
            case .taxes:
                return self.getCellForSecondSection(indexPath)
            case .cancellation:
                return self.getCellForCancellationSection(indexPath)
            case .discount:
                return self.getCellForThirdSection(indexPath)
            case .total:
                return self.getCellForFourthSection(indexPath)
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.viewModel.isForReceipt {
            return nil
        } else  {
            let sectionHeader = self.viewModel.sectionHeader[section]
            guard let headerView = self.invoiceTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? FareSectionHeader else {
                fatalError("FareSectionHeader not found")
            }
            headerView.delegate = self
            headerView.isDownArrow = false
            headerView.discountContainer.isHidden = true
            headerView.topStackView.isHidden = false
            
            //headerView.stackViewTopConstriant.constant = 5.5
            headerView.topBackgroundView.backgroundColor = AppColors.themeWhite
            headerView.tag = section
            
            func showDataOnTopHeader() {
                headerView.grossFareTitleLabel.text = sectionHeader.title
                headerView.grossPriceLabel.attributedText = sectionHeader.amount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
            }
            func showDataOnBottomHeader() {
                headerView.topStackView.isHidden = true
                headerView.discountContainer.isHidden = false
                headerView.discountsTitleLabel.text = sectionHeader.title
                headerView.discountPriceLabel.attributedText = sectionHeader.amount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
            }
            
            switch sectionHeader.section {
            case .details,.total: return nil
            case .taxes:
                self.handleTaxesArrowAnimation(headerView)
                showDataOnBottomHeader()
            case .cancellation:
                self.handleCancellationArrowAnimation(headerView)
                showDataOnBottomHeader()
            case .discount:
                self.handleDiscountArrowAnimation(headerView)
                showDataOnBottomHeader()
            default:
                showDataOnTopHeader()
            }
            return headerView
        }
        /*
         if section == 1 {
         guard let headerView = self.invoiceTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? FareSectionHeader else {
         fatalError("FareSectionHeader not found")
         }
         headerView.delegate = self
         headerView.isDownArrow = false
         self.handleDiscountArrowAnimation(headerView)
         headerView.stackViewTopConstriant.constant = 5.5
         if let trans = self.viewModel.voucher?.transactions.filter({ $0.ledgerName.lowercased().contains("base")}).first {
         headerView.grossFareTitleLabel.text = trans.ledgerName
         headerView.grossPriceLabel.attributedText = self.getSuscriptDecimal(trans.amount)
         }
         else {
         headerView.grossFareTitleLabel.text = "Base Fare"
         headerView.grossPriceLabel.attributedText = self.getSuscriptDecimal(0)
         }
         
         if let trans = self.viewModel.voucher?.transactions.filter({ $0.ledgerName.lowercased().contains("taxes")}).first {
         headerView.discountContainer.isHidden = false
         headerView.discountsTitleLabel.text = trans.ledgerName
         headerView.discountPriceLabel.attributedText = self.getSuscriptDecimal(trans.amount)
         }
         else {
         headerView.discountContainer.isHidden = false
         headerView.discountsTitleLabel.text = "Taxes and Fees"
         headerView.discountPriceLabel.attributedText = self.getSuscriptDecimal(0)
         }
         headerView.topBackgroundView.backgroundColor = AppColors.themeWhite
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
         headerView.grossPriceLabel.attributedText = self.getSuscriptDecimal(trans.amount)
         }
         else {
         headerView.grossFareTitleLabel.text = "Gross Fare"
         headerView.grossPriceLabel.attributedText = self.getSuscriptDecimal(0)
         }
         
         if let trans = self.viewModel.voucher?.transactions.filter({ $0.ledgerName.lowercased().contains("discounts")}).first {
         headerView.discountContainer.isHidden = false
         headerView.discountsTitleLabel.text = trans.ledgerName
         headerView.discountPriceLabel.attributedText = self.getSuscriptDecimal(trans.amount)
         }
         else {
         headerView.discountContainer.isHidden = true
         }
         
         headerView.delegate = self
         headerView.topBackgroundView.backgroundColor = AppColors.themeWhite
         headerView.tag = section
         return headerView
         }
         */
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.viewModel.isForReceipt {
            return 0
        }
        else {
            switch self.viewModel.sectionHeader[section].section {
            case .details, .total: return CGFloat.leastNormalMagnitude
            default: return 32.0
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
            switch self.viewModel.sectionHeader[indexPath.section].section {
            case .details:
                return self.getHeightForRowAtFirstSection(indexPath)
            case .taxes:
                return self.getHeightForRowAtSecondSection(indexPath)
            case .cancellation:
                return self.getHeightForRowAtCancellationSection(indexPath)
            case .discount:
                return self.getHeightForRowAtThirdSection(indexPath)
            case .total:
                return self.getHeightForRowAtFourthSection(indexPath)
            default:
                return CGFloat.leastNormalMagnitude
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.isForReceipt {
            if indexPath.section == 2, indexPath.row == 2 {
                //download receipt
                if let bID = self.viewModel.voucher?.basic?.transactionId, !bID.isEmpty {
                    self.isDownloadingRecipt = true
                    if let cell = self.invoiceTableView.cellForRow(at: indexPath) as? DownloadInvoiceTableViewCell{
                        cell.showLoader = true
                    }
                    AppGlobals.shared.viewPdf(urlPath: "\(APIEndPoint.baseUrlPath.path)dashboard/download-voucher?id=\(bID)", screenTitle: "Receipt Voucher", showLoader: false, complition: { [weak self] (status) in
                        self?.isDownloadingRecipt = false
                        self?.invoiceTableView.reloadData()
                    })
                }
            }
        } else {
            if self.viewModel.sectionHeader[indexPath.section].section == .total, indexPath.row == 2 {
                //download invoice
                if let bID = self.viewModel.voucher?.bookingId, !bID.isEmpty, let voucherType =  self.viewModel.voucher?.basic?.voucherType, let transactionId = self.viewModel.voucher?.basic?.transactionId, let eventName = self.viewModel.voucher?.basic?.event {
                    var documentURL = ""
                    self.isDownloadingRecipt = true
                    if let cell = self.invoiceTableView.cellForRow(at: indexPath) as? DownloadInvoiceTableViewCell{
                        cell.showLoader = true
                    }
                    switch voucherType {
                    case "reschedule_sales_return_jv", "sales_return_jv":
                        documentURL = "\(APIEndPoint.baseUrlPath.path)dashboard/credit-note-download?transaction_id=\(transactionId)&booking_id=\(bID)"
                    case "sales_addon":
                        documentURL = "\(APIEndPoint.baseUrlPath.path)dashboard/download-voucher?id=\(transactionId)"
                    default:
                        documentURL = "\(APIEndPoint.baseUrlPath.path)dashboard/booking-action?booking_id=\(bID)&doc=invoice&type=pdf"
                    }
                    
                    AppGlobals.shared.viewPdf(urlPath: documentURL, screenTitle: "\(eventName) Invoice", showLoader: false, complition: { [weak self] (status) in
                        self?.isDownloadingRecipt = false
                        self?.invoiceTableView.reloadData()
                    })
                }
            }
        }
 
    }
    
    
    func getSuscriptDecimal(_ amount:Double, fontSize:CGFloat = 16.0)-> NSAttributedString{
        
        let str = "\(amount.delimiterWithSymbolTill2Places)".asStylizedPrice(using: AppFonts.Regular.withSize(fontSize))
        return str
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
        let section = self.viewModel.sectionHeader[view.tag].section
        if section == .taxes {
            if self.viewModel.isBaseFareSectionExpanded {
                self.viewModel.isBaseFareSectionExpanded = false
            } else {
                self.viewModel.isBaseFareSectionExpanded = true
            }
        } else  if section == .cancellation {
            if self.viewModel.isCancellationSectionExpanded {
                self.viewModel.isCancellationSectionExpanded = false
            } else {
                self.viewModel.isCancellationSectionExpanded = true
            }
        } else if section == .discount {
            if self.viewModel.isGrossFareSectionExpanded {
                self.viewModel.isGrossFareSectionExpanded = false
            } else {
                self.viewModel.isGrossFareSectionExpanded = true
            }
        }
        self.invoiceTableView.reloadData()
    }
}
extension BookingInvoiceVC: BookingInvoiceVMDelegate {
    func willGetBookingDetail() {
        
    }
    
    func getBookingDetailSucces(model: BookingDetailModel) {
        NotificationCenter.default.post(name: .bookingDetailFetched, object: model)
        self.refreshControl.endRefreshing()
        self.invoiceTableView.reloadData()
    }
    
    func getBookingDetailFaiure(error: ErrorCodes) {
        self.refreshControl.endRefreshing()
        AppToast.default.showToastMessage(message: LocalizedString.SomethingWentWrong.localized)
    }
    
}
