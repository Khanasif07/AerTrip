//
//  FlightBookingDetailsVC+Extensions.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import MXParallaxHeader
import UIKit

// MARK: - Extensions

// MARK: ============

extension FlightBookingsDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionDataForFlightProductType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sectionDataForFlightProductType[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = self.viewModel.sectionDataForFlightProductType[indexPath.section]
        switch currentSection[indexPath.row] {
        case .notesCell:
            return self.getNotesCell(tableView, indexPath: indexPath)
        case .requestCell:
            return self.getRequestsCell(tableView, indexPath: indexPath)
        case .cancellationsReqCell:
            return self.getCancellationsRequestCell(tableView, indexPath: indexPath)
        case .addOnRequestCell:
            return self.getAddOnRequestCell(tableView, indexPath: indexPath)
        case .reschedulingRequestCell:
            return self.getReschedulingRequestCell(tableView, indexPath: indexPath)
        case .flightCarriersCell:
            return self.getFlightCarriersCell(tableView, indexPath: indexPath)
        case .flightBoardingAndDestinationCell:
            return self.getFlightBoardingAndDestinationCell(tableView, indexPath: indexPath)
        case .travellersPnrStatusTitleCell:
            return self.getTravellersPnrStatusTitleCell(tableView, indexPath: indexPath)
        case .travellersPnrStatusCell:
            return self.getTravellersPnrStatusCell(tableView, indexPath: indexPath)
        case .documentCell:
            return self.getBookingDocumentsCell(tableView, indexPath: indexPath)
        case .paymentInfoCell:
            return self.getPaymentInfoCell(tableView, indexPath: indexPath)
        case .bookingCell:
            return self.getBookingCell(tableView, indexPath: indexPath)
        case .addOnsCell:
            return self.getAddOnsCell(tableView, indexPath: indexPath)
        case .cancellationCell:
            return self.getCancellationCell(tableView, indexPath: indexPath)
        case .refundCell:
            return self.getRefundCell(tableView, indexPath: indexPath)
        case .paymentPendingCell:
            return self.getPaymentPendingCell(tableView, indexPath: indexPath)
        case .paidCell:
            return self.getPaidCell(tableView, indexPath: indexPath)
        case .nameCell:
            return self.getNameCell(tableView, indexPath: indexPath)
        case .emailCell:
            return self.getEmailCell(tableView, indexPath: indexPath)
        case .mobileCell:
            return self.getMobileCell(tableView, indexPath: indexPath)
        case .gstCell:
            return self.getGstCell(tableView, indexPath: indexPath)
        case .billingAddressCell:
            return self.getBillingAddressCell(tableView, indexPath: indexPath)
        case .flightsOptionsCell:
            return self.getFlightsOptionsCell(tableView, indexPath: indexPath)
        case .weatherHeaderCell:
            return self.getWeatherHeaderCell(tableView, indexPath: indexPath)
        case .weatherInfoCell:
            return self.getWeatherInfoCell(tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppFlowManager.default.moveToBookingDetail(tripCitiesStr: self.viewModel.bookingDetail?.tripCitiesStr, bookingId: self.viewModel.bookingId, ledData: self.viewModel.bookingDetail?.bookingDetail?.leg ?? [])
    }
}

extension FlightBookingsDetailsVC: TopNavigationViewDelegate {
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

extension FlightBookingsDetailsVC: BookingDocumentsTableViewCellDelegate {
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
                sSelf.bookingDetailsTableView.reloadData()
            }
            printDebug(success)
        }) { [weak self] error in
            guard let sSelf = self else { return }
            sSelf.viewModel.documentDownloadingData[collectionIndex.item].downloadingStatus = .notDownloaded
            UIView.performWithoutAnimation {
                sSelf.bookingDetailsTableView.reloadData()
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
extension FlightBookingsDetailsVC: MXParallaxHeaderDelegate {
    func updateForParallexProgress() {
        let prallexProgress = self.bookingDetailsTableView.parallaxHeader.progress
        
        printDebug("progress %f \(prallexProgress)")
        
        if prallexProgress <= 0.65 {
            self.topNavBar.backgroundType = .blurMainView(isDark: false)
            self.topNavBar.animateBackView(isHidden: false) { [weak self] _ in
                guard let sSelf = self else { return }
                sSelf.topNavBar.firstRightButton.isSelected = true
                sSelf.topNavBar.leftButton.isSelected = true
                sSelf.topNavBar.leftButton.tintColor = AppColors.themeGreen
                sSelf.topNavBar.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: sSelf.eventTypeImage, endText: "BOM → DEL", font: AppFonts.SemiBold.withSize(18.0), isEndTextBold: true)
                sSelf.topNavBar.dividerView.isHidden = false
            }
        } else {
            self.topNavBar.backgroundType = .blurMainView(isDark: false)
            self.topNavBar.animateBackView(isHidden: true) { [weak self] _ in
                guard let sSelf = self else { return }
                sSelf.topNavBar.firstRightButton.isSelected = false
                sSelf.topNavBar.leftButton.isSelected = false
                sSelf.topNavBar.leftButton.tintColor = AppColors.themeWhite
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

extension FlightBookingsDetailsVC: FlightsOptionsTableViewCellDelegate {
    func addToCalender() {
        printDebug("Add To Calender")
    }
    
    func addToAppleWallet() {
        printDebug("Add To Apple Wallet")
    }
}

extension FlightBookingsDetailsVC: WeatherHeaderTableViewCellDelegate {
    func seeAllWeathers() {
        printDebug("See All Weathers")
    }
}

// MARK: - BookingProductDetailVM methods

extension FlightBookingsDetailsVC: BookingProductDetailVMDelegate {
    func willGetBookingDetail() {
        AppGlobals.shared.startLoading()
    }
    
    func getBookingDetailSucces() {
        AppGlobals.shared.stopLoading()
        self.configureTableHeaderView()
        self.bookingDetailsTableView.delegate = self
        self.bookingDetailsTableView.dataSource = self
        self.viewModel.getSectionDataForFlightProductType()
        self.bookingDetailsTableView.reloadData()
    }
    
    func getBookingDetailFaiure() {
        AppGlobals.shared.stopLoading()
    }
}
