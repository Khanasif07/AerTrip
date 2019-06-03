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
    
    @IBOutlet var topNavBar: TopNavigationView!
    @IBOutlet var invoiceTableView: ATTableView!
    
    // MARK: - Variables
    
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
        self.topNavBar.configureNavBar(title: LocalizedString.Booking.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: true)
    }
    
    // MARK: - Helper methods
    
    private func registerXib() {
        self.invoiceTableView.register(UINib(nibName: AppConstants.ktableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: AppConstants.ktableViewHeaderViewIdentifier)
        self.invoiceTableView.registerCell(nibName: BookingCallTableViewCell.reusableIdentifier)
        self.invoiceTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.invoiceTableView.registerCell(nibName: DiscountCell.reusableIdentifier)
        self.invoiceTableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.cellIdentifier)
        self.invoiceTableView.registerCell(nibName: TotalPayableNowCell.reusableIdentifier)
        self.invoiceTableView.registerCell(nibName: BookingDateVoucherTableViewCell.reusableIdentifier)
        self.invoiceTableView.registerCell(nibName: DownloadInvoiceTableViewCell.reusableIdentifier)
    }
    
    private func getCellForFirstSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let bookingVoucherCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "BookingDateVoucherTableViewCell") as? BookingDateVoucherTableViewCell else {
                fatalError("BookingVoucherTableViewCell not found")
            }
            
            bookingVoucherCell.configureCell(date: "Fri, 24 Mar 2017", voucher: "S/18-19/2503")
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
        switch indexPath.row {
        case 0:
            discountCell.configureCell(title: "Carrier Imposed Misc Fees", amount: " ₹ 70")
            return discountCell
        case 1:
            discountCell.configureCell(title: "Passenger Service Fee", amount: " ₹ 142")
            return discountCell
        case 2:
            discountCell.configureCell(title: "User Development Fees", amount: " ₹ 154")
            return discountCell
        case 3:
            discountCell.configureCell(title: "Airline GST/K3", amount: " ₹  ₹ 294")
            discountCell.titleLabelBottomConstraint.constant = 0
            return discountCell
            
        default:
            return UITableViewCell()
        }
    }
    
    private func getCellForThirdSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let discountCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "DiscountCell") as? DiscountCell else {
                fatalError("DiscountCell not found")
            }
            discountCell.configureCell(title: "Pricing Policy Discount", amount: " ₹ 70")
            discountCell.titleLabelBottomConstraint.constant = 10
            discountCell.titleLabelTopConstraint.constant = -10
            return discountCell
        case 1:
            guard let totalPayableCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "TotalPayableNowCell") as? TotalPayableNowCell else {
                fatalError("TotalPayableNowCell not found")
            }
            totalPayableCell.totalPriceLabel.text = "₹ 67,144"
            totalPayableCell.bottomDeviderView.isHidden = true
            return totalPayableCell
        case 2:
            guard let emptyCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as? EmptyTableViewCell else {
                fatalError("EmptyTableViewCell not found")
            }
            return emptyCell
        case 3:
            guard let downloadInvoiceCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "DownloadInvoiceTableViewCell") as? DownloadInvoiceTableViewCell else {
                fatalError("DownloadInvoiceTableViewCell not found")
            }
            downloadInvoiceCell.topDividerView.isHidden = true
            return downloadInvoiceCell
        default:
            return UITableViewCell()
        }
    }
    
    private func getCellForFourthSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let totalPayableCell = self.invoiceTableView.dequeueReusableCell(withIdentifier: "TotalPayableNowCell") as? TotalPayableNowCell else {
                fatalError("TotalPayableNowCell not found")
            }
            totalPayableCell.totalPriceLabel.text = "₹ 67,144"
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
        return [24, 24, 24, 24][indexPath.row]
    }
    
    func getHeightForRowAtThirdSection(_ indexPath: IndexPath) -> CGFloat {
        return [24][indexPath.row]
    }
    
    func getHeightForRowAtFourthSection(_ indexPath: IndexPath) -> CGFloat {
        return [46, 28, 44][indexPath.row]
    }
    
    func openActionSheet() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.RequestAddOnAndFrequentFlyer.localized, LocalizedString.RequestRescheduling.localized, LocalizedString.RequestCancellation.localized, LocalizedString.Download.localized, LocalizedString.ResendConfirmationMail.localized], colors: [AppColors.themeGreen, AppColors.themeGreen, AppColors.themeGreen, AppColors.themeGreen, AppColors.themeGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] _, index in
            
            if index == 0 {
                printDebug("Present Request Add-ons & Freq. Flyer")
                self?.presentRequestAddOnFrequentFlyer()
            } else if index == 1 {
                self?.presentBookingReschedulingVC()
                printDebug("Present Request Reschedulling")
            } else if index == 2 {
                AppFlowManager.default.presentBookingReschedulingVC(usingFor: .cancellation)
                printDebug("Present Request Cancellation")
            } else if index == 3 {
                printDebug("Present Download")
            } else if index == 4 {
                printDebug("Present Resend Confirmation Email")
            }
        }
    }
    
    private func presentRequestAddOnFrequentFlyer() {
        AppFlowManager.default.presentBookingReuqestAddOnVC()
    }
    
    private func presentBookingReschedulingVC() {
        AppFlowManager.default.presentBookingReschedulingVC()
    }
}

// MARK: - UITableViewDataSource and  UITableViewDelegate methods

extension BookingInvoiceVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            
            return self.isBaseFareSectionExpanded ? 4 : 0
        case 2:
            return self.isGrossFareSectionExpanded ? 1 : 0
        case 3:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            guard let headerView = self.invoiceTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? FareSectionHeader else {
                fatalError("FareSectionHeader not found")
            }
            headerView.delegate = self
            headerView.isDownArrow = false
            self.handleDiscountArrowAnimation(headerView)
            headerView.discountPriceLabel.text = "\(Double(660).amountInDelimeterWithSymbol)"
            headerView.grossFareTitleLabel.text = "Base Fare"
            headerView.discountsTitleLabel.text = "Taxes and Fees"
            headerView.bottomViewTopConstraint.constant = 2
            headerView.grossFareTopConstraint.constant = 10
            headerView.arrowButtonLeadingConstraint.constant = 4
            headerView.grossPriceLabel.text = "\(Double(1200).amountInDelimeterWithSymbol)"
            headerView.tag = section
            return headerView
            
        } else if section == 2 {
            guard let headerView = self.invoiceTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? FareSectionHeader else {
                fatalError("FareSectionHeader not found")
            }
            headerView.arrowButton.transform = CGAffineTransform(rotationAngle: CGFloat(2 * Double.pi))
            headerView.isDownArrow = false
            self.handleDiscountArrowAnimationforSecondSection(headerView)
            headerView.discountPriceLabel.text = "\(Double(660).amountInDelimeterWithSymbol)"
            headerView.cellTopViewHeightConstraint.constant = 60
            headerView.discountViewHeightConstraint.constant = 27
            headerView.bottomViewBottomConstraint.constant = 10
            headerView.grossFareTopConstraint.constant = 0
            headerView.arrowButtonLeadingConstraint.constant = 4
            headerView.grossFareTitleLabel.text = "Gross Fare"
            headerView.discountsTitleLabel.text = "Discounts"
            headerView.delegate = self
            
            headerView.grossPriceLabel.text = "\(Double(660).amountInDelimeterWithSymbol)"
            headerView.tag = section
            return headerView
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 64.0
        case 2:
            return 64.0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 0 {
            self.openActionSheet()
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
