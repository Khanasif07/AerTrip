//
//  HotelBookingsDetailsVC+Extensions.swift
//  AERTRIP
//
//  Created by Admin on 04/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import MXParallaxHeader
import UIKit

// MARK: - Extensions

// MARK: ============

extension HotlelBookingsDetailsVC: UITableViewDelegate, UITableViewDataSource {
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
            return (self.viewModel.bookingDetail?.bookingDetail?.hotelAddress ?? "NA").sizeCount(withFont: AppFonts.Regular.withSize(16.0), bundingSize: CGSize(width: (UIDevice.screenWidth - 50.0), height: 10000.0)).height + 190.0
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
            return self.viewModel.bookingDetail?.billingInfo?.gst.isEmpty ?? true ? CGFloat.leastNonzeroMagnitude : UITableView.automaticDimension
        case .billingAddressCell:
            return UITableView.automaticDimension
        case .flightsOptionsCell:
            return UITableView.automaticDimension
        case .weatherHeaderCell, .weatherInfoCell, .weatherFooterCell:
            return (self.viewModel.bookingDetail?.tripWeatherData.isEmpty ?? true) ? CGFloat.leastNonzeroMagnitude : UITableView.automaticDimension
        case .addToCalenderCell:
            return UITableView.automaticDimension
        case .addToAppleWallet:
            return UITableView.automaticDimension
        case .tripChangeCell:
            return UITableView.automaticDimension
        case .bookAnotherRoomCell:
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
        case .weatherFooterCell:
            return self.getWeatherFooterCell(tableView, indexPath: indexPath)
        case .addToCalenderCell:
            return self.getAddToCalenderCell(tableView, indexPath: indexPath)
        case .addToAppleWallet:
            return self.getAddToWalletCell(tableView, indexPath: indexPath)
        case .tripChangeCell:
            return self.getTripChangeCell(tableView, indexPath: indexPath)
        case .bookAnotherRoomCell:
            return self.getBookAnotherRoomCell(tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printDebug("\(indexPath.section)")
        let currentSection = self.viewModel.sectionDataForHotelDetail[indexPath.section]
        switch currentSection[indexPath.row] {
        case .hotelBookingInfoCell, .roomNameAndTypeCell, .travellersCell :
            AppFlowManager.default.moveToBookingHotelDetailVC(bookingDetail: self.viewModel.bookingDetail,hotelTitle: self.navigationTitleText)
        case .cancellationsReqCell, .addOnRequestCell, .reschedulingRequestCell :
            if let allCases = self.viewModel.bookingDetail?.cases, !allCases.isEmpty, let rcpt = self.viewModel.bookingDetail?.receipt {
            AppFlowManager.default.moveToAddOnRequestVC(caseData: allCases[indexPath.row - 1], receipt: rcpt)
            }
        case .tripChangeCell:
            self.tripChangeIndexPath = indexPath
            AppFlowManager.default.presentSelectTripVC(delegate: self, usingFor: .bookingTripChange, allTrips: self.viewModel.allTrips,tripInfo: self.viewModel.bookingDetail?.tripInfo ?? TripInfo())
        case .addToAppleWallet, .bookAnotherRoomCell :
            AppGlobals.shared.showUnderDevelopment()
        case .addToCalenderCell:
            self.addToCalender()
        case .paymentInfoCell, .bookingCell, .addOnsCell, .cancellationCell, .refundCell,.paymentPendingCell, .paidCell:
            if let rcpt = self.viewModel.bookingDetail?.receipt {
            AppFlowManager.default.moveToBookingVoucherVC(receipt: rcpt, caseId: "")
            }
        default:  break
        }
        
        /*
        if self.viewModel.bookingDetail?.bookingDetail?.note.isEmpty ?? false, indexPath.section == 0, let allCases = self.viewModel.bookingDetail?.cases, !allCases.isEmpty, let rcpt = self.viewModel.bookingDetail?.receipt {
            // cases
            AppFlowManager.default.moveToAddOnRequestVC(caseData: allCases[indexPath.row - 1], receipt: rcpt)
        }
            
        else if !(self.viewModel.bookingDetail?.bookingDetail?.note.isEmpty ?? false), indexPath.section == 1, let allCases = self.viewModel.bookingDetail?.cases, !allCases.isEmpty, let rcpt = self.viewModel.bookingDetail?.receipt {
            // cases
            
            AppFlowManager.default.moveToAddOnRequestVC(caseData: allCases[indexPath.row - 1], receipt: rcpt)
        } else if indexPath.section <= self.viewModel.noOfLegCellAboveLeg {
            AppFlowManager.default.moveToBookingHotelDetailVC(bookingDetail: self.viewModel.bookingDetail,hotelTitle: self.navigationTitleText)
        } else if let _ = self.bookingDetailsTableView.cellForRow(at: indexPath) as? TripChangeTableViewCell {
            printDebug("Trip change table view Cell tapped")
            self.tripChangeIndexPath = indexPath
            AppFlowManager.default.presentSelectTripVC(delegate: self, usingFor: .bookingTripChange, allTrips: self.viewModel.allTrips,tripInfo: self.viewModel.bookingDetail?.tripInfo ?? TripInfo())
        }
        else if let cell = self.bookingDetailsTableView.cellForRow(at: indexPath) as? BookingCommonActionTableViewCell {
            switch cell.usingFor {
            case .addToCalender:
                self.addToCalender()
            case .addToTrips:
                AppGlobals.shared.showUnderDevelopment()
            case .bookSameFlight:
                AppGlobals.shared.showUnderDevelopment()
            case .addToAppleWallet:
                AppGlobals.shared.showUnderDevelopment()
            case .bookAnotherRoom:
                AppGlobals.shared.showUnderDevelopment()
            }
        }
        else if let _ = self.bookingDetailsTableView.cellForRow(at: indexPath) as? PaymentInfoTableViewCell, let rcpt = self.viewModel.bookingDetail?.receipt {
            //move to voucher vc
            AppFlowManager.default.moveToBookingVoucherVC(receipt: rcpt, caseId: "")
        }
 */
    }
}

extension HotlelBookingsDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.ProcessCancellation.localized, LocalizedString.SpecialRequest.localized, LocalizedString.Download.localized, LocalizedString.ResendConfirmationEmail.localized], colors: [self.viewModel.bookingDetail?.cancellationRequestAllowed ?? false ? AppColors.themeDarkGreen : AppColors.themeGray40, self.viewModel.bookingDetail?.specialRequestAllowed ?? false ? AppColors.themeDarkGreen : AppColors.themeGray40, AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton, tapBlock: {[weak self]  _, index in
            switch index {
            case 0:
                if let bdtl = self?.viewModel.bookingDetail, bdtl.cancellationRequestAllowed {
                    printDebug("Process Cancellation")
                    AppFlowManager.default.presentToHotelCancellationVC(bookingDetail: bdtl)
                }
                else {
                    printDebug("Process Cancellation not allowed")
                }
                
            case 1:
                if let bdtl = self?.viewModel.bookingDetail, bdtl.specialRequestAllowed {
                    AppFlowManager.default.moveToSpecialRequestVC(forBookingId: bdtl.bookingDetail?.bookingId ?? "")
                    printDebug("Special Request")
                }
                else {
                    printDebug("Special Request not allowed")
                }
                
            case 2:
                printDebug("Download ")
                let endPoint = "https://beta.aertrip.com/api/v1/dashboard/booking-action?type=pdf&booking_id=\(self?.viewModel.bookingDetail?.id ?? "")"
                AppGlobals.shared.viewPdf(urlPath: endPoint, screenTitle: LocalizedString.Voucher.localized)
            case 3:
                printDebug("Resend Confirmation mail ")
                AppFlowManager.default.presentConfirmationMailVC(bookindId: self?.viewModel.bookingDetail?.id ?? "")
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
        
        AppNetworking.DOWNLOAD(sourceUrl: url, destinationUrl: destinationUrl, requestHandler: { [weak self] request in
            guard let sSelf = self else { return }
            printDebug(request)
            sSelf.viewModel.bookingDetail?.documents[collectionIndex.item].downloadingStatus = .downloading
            sSelf.viewModel.bookingDetail?.documents[collectionIndex.item].downloadRequest = request
        }, progressUpdate: { [weak self] progress in
            guard let sSelf = self else { return }
            sSelf.viewModel.bookingDetail?.documents[collectionIndex.item].progressUpdate?(progress)
        }, success: { [weak self] success in
            guard let sSelf = self else { return }
            sSelf.viewModel.bookingDetail?.documents[collectionIndex.item].downloadingStatus = .downloaded
            UIView.performWithoutAnimation {
                sSelf.bookingDetailsTableView.reloadData()
            }
            printDebug(success)
        }) { [weak self] error in
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

// MARK: - ScrollView Delegate

//==========================
extension HotlelBookingsDetailsVC: MXParallaxHeaderDelegate {
    
  
//    func updateForParallexProgress() {
//        let prallexProgress = self.bookingDetailsTableView.parallaxHeader.progress
//
//        printDebug("progress %f \(prallexProgress)")
//        if prallexProgress <= 0.5 {
//            self.topNavBar.animateBackView(isHidden: false) { [weak self] _ in
//                guard let sSelf = self else { return }
//                sSelf.topNavBar.firstRightButton.isSelected = true
//                sSelf.topNavBar.leftButton.isSelected = true
//                sSelf.topNavBar.leftButton.tintColor = AppColors.themeGreen
//
//                sSelf.topNavBar.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: sSelf.eventTypeImage, endText: self?.navigationTitleText ?? "", font: AppFonts.SemiBold.withSize(18.0), isEndTextBold: true)
//                sSelf.headerView?.bookingIdAndDateTitleLabel.alpha = 0
//                sSelf.headerView?.bookingIdAndDateLabel.alpha = 0
//                sSelf.topNavBar.dividerView.isHidden = false
//            }
//        } else {
//            self.topNavBar.animateBackView(isHidden: true) { [weak self] _ in
//                guard let sSelf = self else { return }
//                sSelf.topNavBar.firstRightButton.isSelected = false
//                sSelf.topNavBar.leftButton.isSelected = false
//                sSelf.topNavBar.leftButton.tintColor = AppColors.themeWhite
//                sSelf.topNavBar.navTitleLabel.text = ""
//                sSelf.headerView?.bookingIdAndDateTitleLabel.alpha = 1
//                sSelf.headerView?.bookingIdAndDateLabel.alpha = 1
//                sSelf.topNavBar.dividerView.isHidden = true
//            }
//        }
//        self.headerView?.layoutIfNeeded()
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateForParallexProgress()
    }

    @objc func updateForParallexProgress() {
        
        let prallexProgress = self.bookingDetailsTableView.parallaxHeader.progress
        printDebug("intial progress value \(prallexProgress)")
        
        printDebug("progress value \(prallexProgress)")
        
        
        if isScrollingFirstTime && prallexProgress > 1.0 {
            maxValue = prallexProgress
            minValue = abs(1 - prallexProgress)
            finalMaxValue = Int(maxValue * 100)
            isScrollingFirstTime = false
            printDebug("minvalue \(minValue) and maxValue \(maxValue)")
        }
        //
        //
        if minValue...maxValue ~= prallexProgress {
            printDebug("progress value \(prallexProgress)")
            let intValue =  finalMaxValue - Int(prallexProgress * 100)
            
            printDebug(" int value \(intValue)")
            let newProgress: Float = (Float(1) - (Float(1.3)  * (Float(intValue) / 100)))
            
            printDebug("new progress value \(newProgress)")
            
            
            printDebug("CGFloat progress  Value is \(newProgress.toCGFloat.roundTo(places: 3))")
            
            self.currentProgressIntValue = intValue
            self.currentProgress = newProgress.toCGFloat
            
        }
        //
        if prallexProgress  <= 0.7 {
            if isNavBarHidden {
                
                self.topNavBar.animateBackView(isHidden: true) { [weak self] _ in
                    guard let sSelf = self else { return }
                    sSelf.topNavBar.firstRightButton.isSelected = false
                    sSelf.topNavBar.leftButton.isSelected = false
                    sSelf.topNavBar.leftButton.tintColor = AppColors.themeWhite
                    sSelf.topNavBar.navTitleLabel.text = ""
                    sSelf.headerView?.bookingIdAndDateTitleLabel.alpha = 1
                    sSelf.headerView?.bookingIdAndDateLabel.alpha = 1
                    sSelf.topNavBar.dividerView.isHidden = true
                }
                
            } else {
                
                self.topNavBar.animateBackView(isHidden: false) { [weak self] _ in
                    guard let sSelf = self else { return }
                    sSelf.topNavBar.firstRightButton.isSelected = true
                    sSelf.topNavBar.leftButton.isSelected = true
                    sSelf.topNavBar.leftButton.tintColor = AppColors.themeGreen
                    
                    sSelf.topNavBar.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: sSelf.eventTypeImage, endText: self?.navigationTitleText ?? "", font: AppFonts.SemiBold.withSize(18.0), isEndTextBold: true)
                    sSelf.headerView?.bookingIdAndDateTitleLabel.alpha = 0
                    sSelf.headerView?.bookingIdAndDateLabel.alpha = 0
                    sSelf.topNavBar.dividerView.isHidden = false
                }
            }
        } else {
            
            self.topNavBar.animateBackView(isHidden: true) { [weak self] _ in
                guard let sSelf = self else { return }
                sSelf.topNavBar.firstRightButton.isSelected = false
                sSelf.topNavBar.leftButton.isSelected = false
                sSelf.topNavBar.leftButton.tintColor = AppColors.themeWhite
                sSelf.topNavBar.navTitleLabel.text = ""
                sSelf.headerView?.bookingIdAndDateTitleLabel.alpha = 1
                sSelf.headerView?.bookingIdAndDateLabel.alpha = 1
                sSelf.topNavBar.dividerView.isHidden = true
            }
            
        }
        self.isNavBarHidden = false
        
    }
}

extension HotlelBookingsDetailsVC: FlightsOptionsTableViewCellDelegate {
    func addToTrips() {
        AppGlobals.shared.showUnderDevelopment()
    }
    
    func openWebCheckin() {
        // No web checking in case of hotel
    }
    
    func openDirections() {
        
        // Need to Booking Direction VC
        AppGlobals.shared.redirectToMap(sourceView: self.view, originLat: "", originLong: "", destLat: self.viewModel.bookingDetail?.bookingDetail?.latitude ?? "", destLong: self.viewModel.bookingDetail?.bookingDetail?.longitude ?? "")
    }
    
    func openCallDetail() {
        AppFlowManager.default.moveToBookingCallVC(contactInfo: self.viewModel.bookingDetail?.additionalInformation?.contactInfo,usingFor: .hotel,hotel: self.viewModel.bookingDetail?.bookingDetail?.hotelName ?? "")
    }
    
    func addToCalender() {
        if let start = self.viewModel.bookingDetail?.bookingDetail?.eventStartingDate, let end = self.viewModel.bookingDetail?.bookingDetail?.evenEndingDate {
            let bId = self.viewModel.bookingDetail?.bookingDetail?.bookingId ?? ""
            
            let title = "Hotel: \(self.viewModel.bookingDetail?.bookingDetail?.hotelName ?? ""), \(self.viewModel.bookingDetail?.bookingDetail?.city ?? "")"
            let location = self.viewModel.bookingDetail?.bookingDetail?.hotelAddress ?? ""
            let bookingId = "Booking Id: \(self.viewModel.bookingDetail?.bookingDetail?.bookingId ?? "")"
            let confirmationCode = "Confirmation Code: \(self.viewModel.bookingDetail?.bookingDetail?.bookingId ?? "")"
            // confirmation code pending to append
            let notes = bookingId //+ "\n \(confirmationCode)"
            
            AppGlobals.shared.addEventToCalender(title: title, startDate: start, endDate: end, location: location,  notes: notes, uniqueId: bId)
        }
    }
    
    func addToAppleWallet() {
        AppGlobals.shared.showUnderDevelopment()
    }
    
    func webCheckinServices(url: String) {
        // TODO: - Need to be synced with backend Api key
        guard let url = url.toUrl else { return }
        AppFlowManager.default.showURLOnATWebView(url, screenTitle: "Web Checkin")
    }
}

extension HotlelBookingsDetailsVC: WeatherHeaderTableViewCellDelegate {
    func seeAllWeathers(seeAllButton: UIButton) {
        self.viewModel.isSeeAllWeatherButtonTapped = true
        if let _ = self.bookingDetailsTableView.indexPath(forItem: seeAllButton) {
            self.viewModel.getSectionDataForHotelDetail()
            delay(seconds: 0.5) { [weak self] in
                self?.bookingDetailsTableView.reloadData()
            }
        }
    }
}

// MARK: - Select Trip VC delegate Api

extension HotlelBookingsDetailsVC: SelectTripVCDelegate {
    func selectTripVC(sender: SelectTripVC, didSelect trip: TripModel, tripDetails: TripDetails?) {
        printDebug("\(trip)")
        self.updatedTripDetail = trip
        self.viewModel.bookingDetail?.tripInfo?.eventId = tripDetails?.event_id ?? ""
        self.viewModel.bookingDetail?.tripInfo?.tripId = tripDetails?.trip_id ?? ""
        self.viewModel.bookingDetail?.tripInfo?.name = tripDetails?.name ?? ""
        AppToast.default.showToastMessage(message: LocalizedString.HotelTripChangeMessage.localized + "\(trip.name)")
        if let indexPath = self.tripChangeIndexPath {
            self.bookingDetailsTableView.reloadRow(at: indexPath, with: .none)
        }
        self.viewModel.getTripOwnerApi()
    }
}
