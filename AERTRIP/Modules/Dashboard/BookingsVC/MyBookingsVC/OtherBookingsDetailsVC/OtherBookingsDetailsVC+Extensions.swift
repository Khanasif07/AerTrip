//
//  OtherBookingsDetailsVC+Extensions.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import MXParallaxHeader
import UIKit

// MARK: - Extensions

// MARK: ============

extension OtherBookingsDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionDataForOtherProductType.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sectionDataForOtherProductType[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = self.viewModel.sectionDataForOtherProductType[indexPath.section]
        switch currentSection[indexPath.row] {
        case .insurenceCell:
            let cell = self.getInsurenceCell(tableView, indexPath: indexPath)
            return cell
        case .policyDetailCell:
            let cell = self.getPolicyDetailCell(tableView, indexPath: indexPath)
            return cell
        case .travellersDetailCell:
            let cell = self.getTravellersDetailsCell(tableView, indexPath: indexPath)
            return cell
        case .documentCell:
            let cell = self.getBookingDocumentsCell(tableView, indexPath: indexPath)
            return cell
        case .paymentInfoCell:
            let cell = self.getPaymentInfoCell(tableView, indexPath: indexPath)
            return cell
        case .bookingCell:
            let cell = self.getBookingCell(tableView, indexPath: indexPath)
            return cell
        case .paidCell:
            let cell = self.getPaidCell(tableView, indexPath: indexPath)
            return cell
        case .nameCell:
            let cell = self.getNameCell(tableView, indexPath: indexPath)
            return cell
        case .emailCell:
            let cell = self.getEmailCell(tableView, indexPath: indexPath)
            return cell
        case .mobileCell:
            let cell = self.getMobileCell(tableView, indexPath: indexPath)
            return cell
        case .gstCell:
            let cell = self.getGstCell(tableView, indexPath: indexPath)
            return cell
        case .billingAddressCell:
            let cell = self.getBillingAddressCell(tableView, indexPath: indexPath)
            return cell
        }
    }
}

extension OtherBookingsDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.ProcessCancellation.localized, LocalizedString.SpecialRequest.localized, LocalizedString.Download.localized, LocalizedString.ResendConfirmationEmail.localized], colors: [AppColors.themeGreen, AppColors.themeGreen, AppColors.themeGreen, AppColors.themeGreen])
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton, tapBlock: { _, index in
            switch index {
            case 0:
                printDebug("0")
            case 1:
                printDebug("1")
            case 2:
                printDebug("2")
            case 3:
                printDebug("3")
            default:
                printDebug("default")
            }
        })
    }
}

extension OtherBookingsDetailsVC: BookingDocumentsTableViewCellDelegate {
    func downloadDocument(documentDirectory: String, tableIndex: IndexPath, collectionIndex: IndexPath) {
        self.viewModel.currentDocumentPath = documentDirectory
        printDebug(documentDirectory)
        let destinationUrl = URL(fileURLWithPath: documentDirectory)
        printDebug(destinationUrl)
        AppNetworking.DOWNLOAD(sourceUrl: self.viewModel.documentDownloadingData[collectionIndex.item].sourceUrl, destinationUrl: destinationUrl, requestHandler: { [weak self] request in
            guard let sSelf = self else { return }
            printDebug(request)
            sSelf.viewModel.documentDownloadingData[collectionIndex.item].downloadingStatus = .downloading
            sSelf.viewModel.documentDownloadingData[collectionIndex.item].downloadRequest = request
        }, progressUpdate: { [weak self] progress in
            guard let sSelf = self else { return }
            sSelf.viewModel.documentDownloadingData[collectionIndex.item].progressUpdate?(progress)
        }, success: { [weak self] success in
            guard let sSelf = self else { return }
            sSelf.viewModel.documentDownloadingData[collectionIndex.item].downloadingStatus = .downloaded
            UIView.performWithoutAnimation {
                sSelf.dataTableView.reloadData()
            }
            printDebug(success)
        }) { [weak self] error in
            guard let sSelf = self else { return }
            sSelf.viewModel.documentDownloadingData[collectionIndex.item].downloadingStatus = .notDownloaded
            UIView.performWithoutAnimation {
                sSelf.dataTableView.reloadData()
            }
            printDebug(error)
        }
    }

    func cancelDownloadDocument(itemIndexPath: IndexPath) {
        printDebug("Downloading Stop")
        self.viewModel.documentDownloadingData[itemIndexPath.item].downloadRequest?.cancel()
    }
}

// MARK: - ScrollView Delegate

//==========================
extension OtherBookingsDetailsVC: MXParallaxHeaderDelegate {
    func updateForParallexProgress() {
        let prallexProgress = self.dataTableView.parallaxHeader.progress
        printDebug("progress %f \(prallexProgress)")
        if prallexProgress <= 0.65 {
            self.topNavBar.animateBackView(isHidden: false) { [weak self] _ in
                guard let sSelf = self else { return }
                sSelf.topNavBar.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: sSelf.eventTypeImage, endText: self?.viewModel.bookingDetail?.bookingDetail?.title ?? "", font: AppFonts.SemiBold.withSize(18.0), isEndTextBold: true)
                sSelf.topNavBar.dividerView.isHidden = false
            }
        } else {
            self.topNavBar.animateBackView(isHidden: true) { [weak self] _ in
                guard let sSelf = self else { return }
                sSelf.topNavBar.navTitleLabel.text = ""
                sSelf.topNavBar.dividerView.isHidden = true
            }
        }
        self.headerView?.layoutIfNeeded()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateForParallexProgress()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateForParallexProgress()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.updateForParallexProgress()
    }
}

// MARK: -

extension OtherBookingsDetailsVC: BookingProductDetailVMDelegate {
    func willGetBookingDetail() {
        AppGlobals.shared.startLoading()
    }

    func getBookingDetailSucces() {
        self.configureTableHeaderView()
        self.dataTableView.delegate = self
        self.dataTableView.dataSource = self
        self.viewModel.getSectionDataForOtherProductType()
        self.dataTableView.reloadData()
        AppGlobals.shared.stopLoading()
    }

    func getBookingDetailFaiure() {
        AppGlobals.shared.stopLoading()
    }
}
