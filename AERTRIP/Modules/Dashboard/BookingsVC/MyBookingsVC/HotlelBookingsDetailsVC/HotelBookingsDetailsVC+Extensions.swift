//
//  HotelBookingsDetailsVC+Extensions.swift
//  AERTRIP
//
//  Created by Admin on 04/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import MXParallaxHeader

//MARK:- Extensions
//MARK:============
extension HotlelBookingsDetailsVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionDataForHotelDetail.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sectionDataForHotelDetail[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = self.viewModel.sectionDataForHotelDetail[indexPath.section]
        switch currentSection[indexPath.row] {
        case .hotelBookingInfoCell:
            return 230.0
        case .roomNameAndTypeCell:
            return UITableView.automaticDimension
        case .travellersCell:
            return UITableView.automaticDimension
        case .notesCell:
            return UITableView.automaticDimension
        case .requestCell:
            return UITableView.automaticDimension
        case .cancellationsReqCell:
            return UITableView.automaticDimension
        case .addOnRequestCell:
            return UITableView.automaticDimension
        case .reschedulingRequestCell:
            return UITableView.automaticDimension
        case .documentCell:
            return 241.0
        case .paymentInfoCell:
            return UITableView.automaticDimension
        case .bookingCell:
            return UITableView.automaticDimension
        case .addOnsCell:
            return UITableView.automaticDimension
        case .cancellationCell:
            return UITableView.automaticDimension
        case .refundCell:
            return UITableView.automaticDimension
        case .paymentPendingCell:
            return UITableView.automaticDimension
        case .paidCell:
            return UITableView.automaticDimension
        case .nameCell:
            return UITableView.automaticDimension
        case .emailCell:
            return UITableView.automaticDimension
        case .mobileCell:
            return UITableView.automaticDimension
        case .gstCell:
            return UITableView.automaticDimension
        case .billingAddressCell:
            return UITableView.automaticDimension
        case .flightsOptionsCell:
            return UITableView.automaticDimension
        case .weatherHeaderCell:
            return UITableView.automaticDimension
        case .weatherInfoCell:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = self.viewModel.sectionDataForHotelDetail[indexPath.section]
        switch currentSection[indexPath.row] {
        case .hotelBookingInfoCell:
            return getHotelBookingAddressDetailsCell(tableView, indexPath: indexPath)
        case .roomNameAndTypeCell:
            return getTitleWithSubTitleCell(tableView, indexPath: indexPath)
        case .travellersCell:
            return getTravellersDetailsCell(tableView, indexPath: indexPath)
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
        printDebug("\(indexPath.section)")
        AppFlowManager.default.moveToBookingHotelDetailVC()
    
    }
}

extension HotlelBookingsDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.ProcessCancellation.localized,LocalizedString.SpecialRequest.localized,LocalizedString.Download.localized,LocalizedString.ResendConfirmationEmail.localized], colors: [AppColors.themeGreen,AppColors.themeGreen,AppColors.themeGreen,AppColors.themeGreen])
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


extension HotlelBookingsDetailsVC: BookingDocumentsTableViewCellDelegate {
    
    func downloadDocument(documentDirectory: String, tableIndex: IndexPath, collectionIndex: IndexPath) {
        
        guard let url = self.viewModel.bookingDetail?.documents[collectionIndex.item].sourceUrl else {
            return
        }
        self.viewModel.currentDocumentPath = documentDirectory
        printDebug(documentDirectory)
        let destinationUrl = URL(fileURLWithPath: documentDirectory)
        printDebug(destinationUrl)
        AppNetworking.DOWNLOAD(sourceUrl: url, destinationUrl: destinationUrl, requestHandler: { [weak self] (request) in
            guard let sSelf = self else { return }
            printDebug(request)
            sSelf.viewModel.bookingDetail?.documents[collectionIndex.item].downloadingStatus = .downloading
            sSelf.viewModel.bookingDetail?.documents[collectionIndex.item].downloadRequest = request
            }, progressUpdate: { [weak self] progress in
                guard let sSelf = self else { return }
                sSelf.viewModel.bookingDetail?.documents[collectionIndex.item].progressUpdate?(progress)
            }, success: { [weak self] (success) in
                guard let sSelf = self else { return }
                sSelf.viewModel.bookingDetail?.documents[collectionIndex.item].downloadingStatus = .downloaded
                UIView.performWithoutAnimation {
                    sSelf.bookingDetailsTableView.reloadData()
                }
                printDebug(success)
        }) { [weak self] (error) in
            guard let sSelf = self else { return }
            sSelf.viewModel.bookingDetail?.documents[collectionIndex.item].downloadingStatus = .notDownloaded
            UIView.performWithoutAnimation {
                sSelf.bookingDetailsTableView.reloadData()
            }
            printDebug(error)
        }
    }
    
    func cancelDownloadDocument(itemIndexPath: IndexPath) {
        printDebug("Downloading Stop")
        self.viewModel.bookingDetail?.documents[itemIndexPath.item].downloadRequest?.cancel()
    }
}

//MARK:- ScrollView Delegate
//==========================
extension HotlelBookingsDetailsVC : MXParallaxHeaderDelegate {
    func updateForParallexProgress() {
        
        let prallexProgress = self.bookingDetailsTableView.parallaxHeader.progress
        
        printDebug("progress %f \(prallexProgress)")

        if prallexProgress <= 0.5 {
            self.topNavBar.animateBackView(isHidden: false) { [weak self](isDone) in
                guard let sSelf = self else { return }
                sSelf.topNavBar.firstRightButton.isSelected = true
                sSelf.topNavBar.leftButton.isSelected = true
                sSelf.topNavBar.leftButton.tintColor = AppColors.themeGreen
                sSelf.topNavBar.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: sSelf.eventTypeImage, endText: "BOM → DEL", font: AppFonts.SemiBold.withSize(18.0), isEndTextBold: true)
                sSelf.topNavBar.dividerView.isHidden = false
            }
        } else {
            self.topNavBar.animateBackView(isHidden: true) { [weak self](isDone) in
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

extension HotlelBookingsDetailsVC: FlightsOptionsTableViewCellDelegate {
    func openWebCheckin() {
        // TODO: - Need to test with when web url is present
        self.webCheckinServices(url: self.viewModel.bookingDetail?.webCheckinUrl ?? "")
    }
    
    func openDirections() {
        //
    }
    
    func openCallDetail() {
        //
    }
    
    func addToCalender() {
        AppGlobals.shared.addEventToCalender(title: "Event Detail", notes: "Booking flight Event", startDate: self.viewModel.bookingDetail?.bookingDetail?.eventStartingDate, endDate: self.viewModel.bookingDetail?.bookingDetail?.evenEndingDate)
    }
    
    func addToAppleWallet() {
        printDebug("Add To Apple Wallet")
    }
    
    func webCheckinServices(url: String) {
        // TODO: - Need to be synced with backend Api key
        guard let url = url.toUrl else { return }
        AppFlowManager.default.showURLOnATWebView(url, screenTitle: "Web Checkin")
    }
}

extension HotlelBookingsDetailsVC: WeatherHeaderTableViewCellDelegate {
    func seeAllWeathers() {
        printDebug("See All Weathers")
    }
}
