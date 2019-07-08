//
//  FlightBookingDetailsVC+Extensions.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import MXParallaxHeader
import SafariServices
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        case .weatherFooterCell:
            return self.getWeatherFooterCell(tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printDebug("\(indexPath.section)")
        
        if (self.viewModel.bookingDetail?.bookingDetail?.note.isEmpty ?? false ) && indexPath.section == 0 {
            if let allCases = self.viewModel.bookingDetail?.cases, !allCases.isEmpty, let rcpt = self.viewModel.bookingDetail?.receipt {
                //cases
                
                AppFlowManager.default.moveToAddOnRequestVC(caseData: allCases[indexPath.row-1], receipt: rcpt)
            }
        }
            
        if !(self.viewModel.bookingDetail?.bookingDetail?.note.isEmpty ?? false ) && indexPath.section == 1 {
            if let allCases = self.viewModel.bookingDetail?.cases, !allCases.isEmpty, let rcpt = self.viewModel.bookingDetail?.receipt {
                //cases
                
                AppFlowManager.default.moveToAddOnRequestVC(caseData: allCases[indexPath.row-1], receipt: rcpt)
            }

        }
       
        if indexPath.section >=  self.viewModel.noOfLegCellAboveLeg  {
            AppFlowManager.default.moveToBookingDetail(bookingDetail: self.viewModel.bookingDetail)
        }
    }
}

extension FlightBookingsDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.RequestAddOnAndFrequentFlyer.localized, LocalizedString.RequestRescheduling.localized, LocalizedString.RequestCancellation.localized, LocalizedString.Download.localized, LocalizedString.ResendConfirmationMail.localized], colors: [self.viewModel.bookingDetail?.addOnRequestAllowed ?? false ? AppColors.themeGreen : AppColors.themeGray40, self.viewModel.bookingDetail?.rescheduleRequestAllowed ?? false ? AppColors.themeGreen : AppColors.themeGray40, self.viewModel.bookingDetail?.cancellationRequestAllowed ?? false ? AppColors.themeGreen : AppColors.themeGray40, AppColors.themeGreen, AppColors.themeGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] _, index in
            
            if index == 0 {
                printDebug("Present Request Add-ons & Freq. Flyer")
                if self?.viewModel.bookingDetail?.addOnRequestAllowed ?? false {
                    self?.presentRequestAddOnFrequentFlyer()
                }
            } else if index == 1 {
                if self?.viewModel.bookingDetail?.rescheduleRequestAllowed ?? false {
                    self?.presentBookingReschedulingVC()
                }
                printDebug("Present Request Reschedulling")
            } else if index == 2 {
                if let bDetail = self?.viewModel.bookingDetail, bDetail.cancellationRequestAllowed, let leg = bDetail.bookingDetail?.leg {
                    //open screen for cancellation request
                    AppFlowManager.default.presentRequestCancellationVC(legs: leg)
                }
                printDebug("Present Request Cancellation")
            } else if index == 3 {
                printDebug("Present Download")
                let endPoints = "https://beta.aertrip.com/api/v1/dashboard/booking-action?type=pdf&booking_id=\(self?.viewModel.bookingDetail?.id ?? "")"
                AppGlobals.shared.viewPdf(urlPath: endPoints, screenTitle: LocalizedString.ETicket.localized)
            } else if index == 4 {
//                AppFlowManager.default.presentConfirmationMailVC(bookindId: self?.viewModel.bookingDetail?.id ?? "")
//                printDebug("Present Resend Confirmation Email")
            }
        }
    }
}

extension FlightBookingsDetailsVC: BookingDocumentsTableViewCellDelegate {
    func downloadDocument(documentDirectory: String, tableIndex: IndexPath, collectionIndex: IndexPath) {
        self.viewModel.currentDocumentPath = documentDirectory
        printDebug(documentDirectory)
        let destinationUrl = URL(fileURLWithPath: documentDirectory)
        printDebug(destinationUrl)
        let document = self.viewModel.bookingDetail?.documents[collectionIndex.item]
        AppNetworking.DOWNLOAD(sourceUrl: document?.sourceUrl ?? "", destinationUrl: destinationUrl, requestHandler: { request in
            printDebug(request)
            document?.downloadingStatus = .downloading
            document?.downloadRequest = request
        }, progressUpdate: { progress in
            document?.progressUpdate?(progress)
        }, success: { [weak self] success in
            guard let sSelf = self else { return }
            document?.downloadingStatus = .downloaded
            UIView.performWithoutAnimation {
                sSelf.bookingDetailsTableView.reloadData()
            }
            printDebug(success)
        }) { [weak self] error in
            guard let sSelf = self else { return }
            document?.downloadingStatus = .notDownloaded
            UIView.performWithoutAnimation {
                sSelf.bookingDetailsTableView.reloadData()
            }
            printDebug(error)
        }
    }
    
    func cancelDownloadDocument(itemIndexPath: IndexPath) {
        printDebug("Downloading Stop")
        let document = self.viewModel.bookingDetail?.documents[itemIndexPath.item]
        document?.downloadRequest?.cancel()
    }
}

// MARK: - ScrollView Delegate

//==========================
extension FlightBookingsDetailsVC: MXParallaxHeaderDelegate {
    func updateForParallexProgress() {
        let prallexProgress = self.bookingDetailsTableView.parallaxHeader.progress
        
        printDebug("progress %f \(prallexProgress)")
        
        if prallexProgress <= 0.5 {
            self.topNavBar.animateBackView(isHidden: false) { [weak self] _ in
                guard let sSelf = self else { return }
                sSelf.topNavBar.firstRightButton.isSelected = true
                sSelf.topNavBar.leftButton.isSelected = true
                sSelf.topNavBar.leftButton.tintColor = AppColors.themeGreen
                sSelf.topNavBar.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: sSelf.eventTypeImage, endText: "BOM → DEL", font: AppFonts.SemiBold.withSize(18.0), isEndTextBold: true)
                sSelf.topNavBar.dividerView.isHidden = false
            }
        } else {
            self.topNavBar.animateBackView(isHidden: true) { [weak self] _ in
                guard let sSelf = self else { return }
                sSelf.topNavBar.firstRightButton.isSelected = false
                sSelf.topNavBar.leftButton.isSelected = false
                sSelf.topNavBar.leftButton.tintColor = AppColors.themeWhite
                sSelf.topNavBar.navTitleLabel.text = ""
                sSelf.topNavBar.dividerView.isHidden = true
            }
        }
        
//
//        if prallexProgress <= 0.65 {
//            self.topNavBar.backgroundType = .blurMainView(isDark: false)
//            self.topNavBar.animateBackView(isHidden: false) { [weak self] _ in
//                guard let sSelf = self else { return }
//                sSelf.topNavBar.firstRightButton.isSelected = true
//                sSelf.topNavBar.leftButton.isSelected = true
//                sSelf.topNavBar.leftButton.tintColor = AppColors.themeGreen
//                if let tripCities = self?.viewModel.tripCitiesStr {
//                     sSelf.topNavBar.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image:  sSelf.eventTypeImage, endText: tripCities, font: AppFonts.SemiBold.withSize(18.0))
//                }
//
//                sSelf.topNavBar.dividerView.isHidden = false
//            }
//        } else {
//            self.topNavBar.backgroundType = .blurMainView(isDark: false)
//            self.topNavBar.animateBackView(isHidden: true) { [weak self] _ in
//                guard let sSelf = self else { return }
//                sSelf.topNavBar.firstRightButton.isSelected = false
//                sSelf.topNavBar.leftButton.isSelected = false
//                sSelf.topNavBar.leftButton.tintColor = AppColors.themeWhite
//                sSelf.topNavBar.navTitleLabel.text = ""
//                sSelf.topNavBar.dividerView.isHidden = true
//            }
//        }
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
    func openWebCheckin() {
        // TODO: - Need to test with when web url is present
        self.webCheckinServices(url: self.viewModel.bookingDetail?.webCheckinUrl ?? "")
    }
    
    func openDirections() {
        //
        printDebug("open direction ")
        AppFlowManager.default.moveToBookingDirectionVC(directions: self.viewModel.bookingDetail?.additionalInformation?.directions ?? [])
    }
    
    func openCallDetail() {
        printDebug("open call detail  ")
        AppFlowManager.default.moveToBookingCallVC(contactInfo: self.viewModel.bookingDetail?.additionalInformation?.contactInfo)
    }
    
    func addToCalender() {
        AppGlobals.shared.addEventToCalender(title: "Event Detail", notes: "Booking flight Event", startDate: self.viewModel.bookingDetail?.bookingDetail?.eventStartingDate, endDate: self.viewModel.bookingDetail?.bookingDetail?.evenEndingDate)
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

// MARK: -

extension FlightBookingsDetailsVC: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        AppFlowManager.default.mainNavigationController.dismiss(animated: true, completion: nil)
    }
}
