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
import PassKit

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
        let currentSection = self.viewModel.sectionDataForFlightProductType[indexPath.section]
        switch currentSection[indexPath.row] {
        case .weatherHeaderCell, .weatherInfoCell, .weatherFooterCell:
            return (self.viewModel.bookingDetail?.tripWeatherData.isEmpty ?? true) ? CGFloat.leastNonzeroMagnitude : UITableView.automaticDimension
        case .gstCell:
            return self.viewModel.bookingDetail?.billingInfo?.gst.isEmpty ?? true ? CGFloat.leastNonzeroMagnitude : UITableView.automaticDimension
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
        case .tripChangeCell:
            return self.getTripChangeCell(tableView, indexPath: indexPath)
        case .addToAppleWallet:
            return self.getAddToWalletCell(tableView, indexPath: indexPath)
        case .addToCalenderCell:
            return self.getAddToCalenderCell(tableView, indexPath: indexPath)
        case .bookSameFlightCell:
            return self.getBookSameFlightCell(tableView, indexPath: indexPath)
        case .addToTripCell:
            return self.getAddToTripsCell(tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printDebug("\(indexPath.section)")
        let legCount = (self.viewModel.bookingDetail?.bookingDetail?.leg.count ?? 0)
        
        let currentSection = self.viewModel.sectionDataForFlightProductType[indexPath.section]
        switch currentSection[indexPath.row] {
        case .notesCell:
            AppFlowManager.default.presentBookingNotesVC(overViewInfo: self.viewModel.bookingDetail?.bookingDetail?.note ?? "")
        case .cancellationsReqCell, .addOnRequestCell, .reschedulingRequestCell :
            if let allCases = self.viewModel.bookingDetail?.cases, !allCases.isEmpty, let rcpt = self.viewModel.bookingDetail?.receipt {
                AppFlowManager.default.moveToAddOnRequestVC(caseData: allCases[indexPath.row - 1], receipt: rcpt)
            }
        case .flightCarriersCell, .flightBoardingAndDestinationCell, .travellersPnrStatusTitleCell, .travellersPnrStatusCell:
            AppFlowManager.default.moveToBookingDetail(bookingDetail: self.viewModel.bookingDetail,tripCities: self.viewModel.tripCitiesStr,legSectionTap: indexPath.section - self.viewModel.noOfLegCellAboveLeg, presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: .darkContent)
        case .tripChangeCell:
            AppFlowManager.default.presentSelectTripVC(delegate: self, usingFor: .bookingTripChange, allTrips: self.viewModel.allTrips,tripInfo: self.viewModel.bookingDetail?.tripInfo ?? TripInfo(), dismissalStatusBarStyle: .darkContent)
            self.tripChangeIndexPath = indexPath
        case .addToAppleWallet:
            addToAppleWallet(indexPath: indexPath)
        case .bookSameFlightCell :
//            if let whatNext = self.whatNextForSameFlightBook() {
//                self.bookSameFlightWith(whatNext)
//            }
        break
        case .addToCalenderCell:
//            self.addToCalender()
        break
        case .paymentInfoCell, .bookingCell, .addOnsCell, .cancellationCell, .refundCell, .paidCell://.paymentPendingCell
            if let rcpt = self.viewModel.bookingDetail?.receipt {
                AppFlowManager.default.moveToBookingVoucherVC(receipt: rcpt, bookingId: self.viewModel.bookingId)
            }
        case .paymentPendingCell:
            self.getOutstandingDetails()
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
         }
         
         else if indexPath.section >= self.viewModel.noOfLegCellAboveLeg, indexPath.section <= (self.viewModel.noOfLegCellAboveLeg +  legCount - 1) {
         
         AppFlowManager.default.moveToBookingDetail(bookingDetail: self.viewModel.bookingDetail,tripCities: self.viewModel.tripCitiesStr,legSectionTap: indexPath.section - self.viewModel.noOfLegCellAboveLeg)
         }
         
         else if let _ = self.bookingDetailsTableView.cellForRow(at: indexPath) as? TripChangeTableViewCell {
         printDebug("Trip change table view Cell tapped")
         AppFlowManager.default.presentSelectTripVC(delegate: self, usingFor: .bookingTripChange, allTrips: self.viewModel.allTrips,tripInfo: self.viewModel.bookingDetail?.tripInfo ?? TripInfo())
         self.tripChangeIndexPath = indexPath
         }
         
         // Manage Button action here.
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
         } else if let _ = self.bookingDetailsTableView.cellForRow(at: indexPath) as? HotelInfoAddressCell {
         // notes section
         AppFlowManager.default.presentBookingNotesVC(overViewInfo: self.viewModel.bookingDetail?.bookingDetail?.note ?? "")
         }
         
         */
    }
    
    func getOutstandingDetails(){
        
        self.viewModel.getBookingOutstandingPayment()
    }
    
    
}

extension FlightBookingsDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        if self.viewModel.bookingDetail == nil {
            return
        }
        
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.RequestAddOnAndFrequentFlyer.localized, LocalizedString.RequestRescheduling.localized, LocalizedString.RequestCancellation.localized, LocalizedString.Download.localized, LocalizedString.ResendConfirmationMail.localized, LocalizedString.reloadDetail.localized], colors: [self.viewModel.bookingDetail?.addOnRequestAllowed ?? false ? AppColors.themeDarkGreen : AppColors.themeGray40, self.viewModel.bookingDetail?.rescheduleRequestAllowed ?? false ? AppColors.themeDarkGreen : AppColors.themeGray40, self.viewModel.bookingDetail?.cancellationRequestAllowed ?? false ? AppColors.themeDarkGreen : AppColors.themeGray40, AppColors.themeDarkGreen, AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        
//        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton)
        _ = PKAlertController.default.presentActionSheet(nil, isFromBooking: true, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton){ [weak self] _, index in
            
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
                let endPoints = "\(APIEndPoint.baseUrlPath.rawValue)dashboard/booking-action?type=pdf&booking_id=\(self?.viewModel.bookingDetail?.id ?? "")"
                AppGlobals.shared.viewPdf(urlPath: endPoints, screenTitle: LocalizedString.ETicket.localized)
            } else if index == 4 {
                // Present Resend Confirmation Email  
                AppFlowManager.default.presentConfirmationMailVC(bookindId: self?.viewModel.bookingDetail?.id ?? "", presentingStatusBarStyle: .lightContent)
            }else if index == 5 {
                printDebug("reload result")
                self?.viewModel.getBookingDetail(showProgress: true)
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
    //    func updateForParallexProgress() {
    //        let prallexProgress = self.bookingDetailsTableView.parallaxHeader.progress
    //
    //        printDebug("progress %f \(prallexProgress)")
    //
    //        if prallexProgress <= 0.5 {
    //            self.topNavBar.animateBackView(isHidden: false) { [weak self] _ in
    //                guard let sSelf = self else { return }
    //                sSelf.topNavBar.firstRightButton.isSelected = true
    //                sSelf.topNavBar.leftButton.isSelected = true
    //                sSelf.topNavBar.leftButton.tintColor = AppColors.themeGreen
    //                sSelf.topNavBar.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: sSelf.eventTypeNavigationBarImage, endText: self?.viewModel.tripCitiesStr ?? NSMutableAttributedString(string: ""), font: AppFonts.SemiBold.withSize(18.0))
    //                sSelf.headerView?.bookingIdAndDateLabel.alpha = 0
    //                sSelf.headerView?.bookingIdAndDateTitleLabel.alpha = 0
    //                sSelf.topNavBar.dividerView.isHidden = false
    //            }
    //        } else {
    //            self.topNavBar.animateBackView(isHidden: true) { [weak self] _ in
    //                guard let sSelf = self else { return }
    //                sSelf.topNavBar.firstRightButton.isSelected = false
    //                sSelf.topNavBar.leftButton.isSelected = false
    //                sSelf.topNavBar.leftButton.tintColor = AppColors.themeWhite
    //                sSelf.topNavBar.navTitleLabel.text = ""
    //                sSelf.topNavBar.dividerView.isHidden = true
    //                sSelf.headerView?.bookingIdAndDateLabel.alpha = 1
    //                sSelf.headerView?.bookingIdAndDateTitleLabel.alpha = 1
    //            }
    //        }
    //
    ////
    ////        if prallexProgress <= 0.65 {
    ////            self.topNavBar.backgroundType = .blurMainView(isDark: false)
    ////            self.topNavBar.animateBackView(isHidden: false) { [weak self] _ in
    ////                guard let sSelf = self else { return }
    ////                sSelf.topNavBar.firstRightButton.isSelected = true
    ////                sSelf.topNavBar.leftButton.isSelected = true
    ////                sSelf.topNavBar.leftButton.tintColor = AppColors.themeGreen
    ////                if let tripCities = self?.viewModel.tripCitiesStr {
    ////                     sSelf.topNavBar.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image:  sSelf.eventTypeImage, endText: tripCities, font: AppFonts.SemiBold.withSize(18.0))
    ////                }
    ////
    ////                sSelf.topNavBar.dividerView.isHidden = false
    ////            }
    ////        } else {
    ////            self.topNavBar.backgroundType = .blurMainView(isDark: false)
    ////            self.topNavBar.animateBackView(isHidden: true) { [weak self] _ in
    ////                guard let sSelf = self else { return }
    ////                sSelf.topNavBar.firstRightButton.isSelected = false
    ////                sSelf.topNavBar.leftButton.isSelected = false
    ////                sSelf.topNavBar.leftButton.tintColor = AppColors.themeWhite
    ////                sSelf.topNavBar.navTitleLabel.text = ""
    ////                sSelf.topNavBar.dividerView.isHidden = true
    ////            }
    ////        }
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
                    sSelf.topNavBar.dividerView.isHidden = true
                    sSelf.headerView?.bookingIdAndDateLabel.alpha = 1
                    sSelf.headerView?.bookingIdAndDateTitleLabel.alpha = 1
                }
                
            } else {
                
                self.topNavBar.animateBackView(isHidden: false) { [weak self] _ in
                    guard let sSelf = self else { return }
                    sSelf.topNavBar.firstRightButton.isSelected = true
                    sSelf.topNavBar.leftButton.isSelected = true
                    sSelf.topNavBar.leftButton.tintColor = AppColors.themeGreen
                    sSelf.topNavBar.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: sSelf.eventTypeNavigationBarImage, endText: self?.viewModel.tripCitiesStr ?? NSMutableAttributedString(string: ""), font: AppFonts.SemiBold.withSize(18.0))
                    sSelf.topNavBar.navTitleLabel.textColor = AppColors.themeBlack
                    sSelf.topNavBar.navTitleLabel.lineBreakMode = .byTruncatingMiddle
                    sSelf.headerView?.bookingIdAndDateLabel.alpha = 0
                    sSelf.headerView?.bookingIdAndDateTitleLabel.alpha = 0
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
                sSelf.topNavBar.dividerView.isHidden = true
                sSelf.headerView?.bookingIdAndDateLabel.alpha = 1
                sSelf.headerView?.bookingIdAndDateTitleLabel.alpha = 1
            }
            
        }
        self.isNavBarHidden = false
        
    }
}

extension FlightBookingsDetailsVC: FlightsOptionsTableViewCellDelegate {
    
    func share() {
        if let url = viewModel.bookingDetail?.shareUrl{
            if !url.isEmpty{
                let textToShare = [ "I have Booked the Flight with Aertrip\n\(url)" ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                
                self.present(activityViewController, animated: true, completion: nil)
            }

        }

    }
    
    func bookSameFlightOrRoom() {
        if let whatNext = self.whatNextForSameFlightBook() {
            self.bookSameFlightWith(whatNext)
        }
    }
    
    func addToTrips() {
        // not needed here
    }
    
    func openWebCheckin() {
        // TODO: - Need to test with when web url is present
        if (self.viewModel.bookingDetail?.additionalInformation?.webCheckins.count ?? 0) > 1 {
            AppFlowManager.default.moveToBookingWebCheckinVC(contactInfo: self.viewModel.bookingDetail?.additionalInformation?.contactInfo, webCheckins: self.viewModel.bookingDetail?.additionalInformation?.webCheckins ?? [])
        } else {
            self.webCheckinServices(url: self.viewModel.bookingDetail?.webCheckinUrl ?? "")
        }
        
        
    }
    
    func openDirections() {
        //
        printDebug("open direction ")
        AppFlowManager.default.moveToBookingDirectionVC(directions: self.viewModel.bookingDetail?.additionalInformation?.directions ?? [])
    }
    
    func openCallDetail() {
        printDebug("open call detail  ")
        AppFlowManager.default.moveToBookingCallVC(contactInfo: self.viewModel.bookingDetail?.additionalInformation?.contactInfo, presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: .darkContent)
    }
    
    func addToCalendar() {
        //        if let start = self.viewModel.bookingDetail?.bookingDetail?.eventStartingDate, let end = self.viewModel.bookingDetail?.bookingDetail?.evenEndingDate {
        //            let bId = self.viewModel.bookingDetail?.bookingDetail?.bookingId ?? ""
        //            AppGlobals.shared.addEventToCalender(title: "\(self.viewModel.tripCitiesStr.string)", startDate: start, endDate: end, notes: "You've a flight booked for '\(self.viewModel.tripCitiesStr.string)'\nFor reference you booking id is '\(self.viewModel.bookingDetail?.bookingDetail?.bookingId ?? "")'", uniqueId: bId)
        //        }
        let bId = self.viewModel.bookingDetail?.bookingDetail?.bookingId ?? ""
        self.viewModel.bookingDetail?.bookingDetail?.leg.forEach({ (leg) in
            leg.flight.forEach { (flightDetail) in
                if let start = flightDetail.calendarDepartDate, let end = flightDetail.calendarArivalDate {
                    let tripCity = "Flight: \(flightDetail.departCity) -> \(flightDetail.arrivalCity)"
                    let flightCode = flightDetail.carrierCode
                    let flightNo = flightDetail.flightNumber
                    let title = tripCity + " (\(flightCode) \(flightNo))"
                    let locaction = "\(flightDetail.departCity) \(flightDetail.departure)"
                    let bookingId = "Booking Id: \(self.viewModel.bookingDetail?.bookingDetail?.bookingId ?? "")"
                    let pnrArray = leg.pax.map { (pax) -> String in
                        pax.pnr
                    }
                    var pnr = pnrArray.joined(separator: ", ")
                    if !pnr.isEmpty {
                        pnr = "\nPNR: \(pnr)"
                    }
                    let notes = bookingId + pnr
                    
                    AppGlobals.shared.addEventToCalender(title: title, startDate: start, endDate: end,location: locaction, notes: notes, uniqueId: bId)
                }
            }
        })
        
    }
    
    func addToAppleWallet(indexPath: IndexPath) {
        
        guard let legs = self.viewModel.bookingDetail?.bookingDetail?.leg, !legs.isEmpty else {return}
        
        
        func addToWallet(FlightId:String) {
            printDebug("Add To Apple Wallet")
            let endPoints = "\(APIEndPoint.pass.path)?booking_id=\(self.viewModel.bookingDetail?.id ?? "")&flight_id=\(FlightId)"
            printDebug("endPoints: \(endPoints)")
            guard let url = URL(string: endPoints) else {return}
            self.viewModel.showWaletLoader = true
            if let cell = self.bookingDetailsTableView.cellForRow(at: indexPath) as? BookingCommonActionTableViewCell {
                cell.actionButton.isLoading = true
            } else {
                self.bookingDetailsTableView.reloadRow(at: indexPath, with: .none)
            }
            AppGlobals.shared.downloadWallet(fileURL: url, showLoader: false) {[weak self] (passUrl) in
                DispatchQueue.main.async {
                    if let localURL = passUrl {
                        printDebug("localURL: \(localURL)")
                        self?.addWallet(passFilePath: localURL)
                    }
                    self?.viewModel.showWaletLoader = false
                    if let cell = self?.bookingDetailsTableView.cellForRow(at: indexPath) as? BookingCommonActionTableViewCell {
                        cell.actionButton.isLoading = false
                    } else {
                        self?.bookingDetailsTableView.reloadRow(at: indexPath, with: .none)
                    }
                }
            }
        }
        
        var result = [(flightName: String, flightId: String)]()
        legs.forEach { (booking) in
            booking.flight.forEach { (flightDetail) in
               let name = "\(flightDetail.departure) → \(flightDetail.arrival)"
                result.append((flightName: name, flightId: flightDetail.flightId))
            }
        }
        
        if result.count > 1{
//            let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: result.map{$0.name}, colors: self.viewModel.availableSeatMaps.map{$0.isSelectedForall ? AppColors.themeGray40 : AppColors.themeGreen})
            let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: result.map{$0.flightName}, colors: result.map{$0.flightName.isEmpty ? AppColors.themeGray40 : AppColors.themeGreen})

            let cencelBtn = PKAlertButton(title: LocalizedString.Cancel.localized, titleColor: AppColors.themeDarkGreen,titleFont: AppFonts.SemiBold.withSize(20))
            _ = PKAlertController.default.presentActionSheet("Select Flight for…",titleFont: AppFonts.SemiBold.withSize(14), titleColor: AppColors.themeGray40, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: cencelBtn) { [weak self] _, index in
                guard let self = self else {return}
                addToWallet(FlightId: result[index].flightId)
            }
        }else{
            addToWallet(FlightId: result.first?.flightId ?? "")
        }
        
        
        
    }
    
    private func addWallet(passFilePath: URL) {
        // let filePath = Bundle.main.path(forResource: "DealsPasses", ofType: "pkpass")!
        guard let passData = try? Data(contentsOf: passFilePath) else {return}
        do {
            let newpass = try PKPass.init(data: passData)
            let addController =  PKAddPassesViewController(pass: newpass)
            addController?.delegate = self
            self.present(addController!, animated: true)
        } catch {
            printDebug(error)
        }
    }
    
    
}
extension FlightBookingsDetailsVC: PKAddPassesViewControllerDelegate {
    
}

extension FlightBookingsDetailsVC: WeatherHeaderTableViewCellDelegate {
    func seeAllWeathers(seeAllButton: UIButton) {
        self.viewModel.isSeeAllWeatherButtonTapped = true
        if let _ = self.bookingDetailsTableView.indexPath(forItem: seeAllButton) {
            self.viewModel.getSectionDataForFlightProductType()
            delay(seconds: 0.5) { [weak self] in
                self?.bookingDetailsTableView.reloadData()
            }
        }
    }
}

// MARK: - BookingProductDetailVM methods

extension FlightBookingsDetailsVC: BookingProductDetailVMDelegate {
    func willGetBookingDetail(showProgress: Bool) {
        //AppGlobals.shared.startLoading()
        if showProgress {
        self.headerView?.startProgress()
        }
    }
    
    func getBookingDetailSucces(showProgress: Bool) {
        //AppGlobals.shared.stopLoading()
        if showProgress {
        self.headerView?.stopProgress()
        }
        self.refreshControl.endRefreshing()
        self.configureTableHeaderView(hideDivider: showProgress)
        self.bookingDetailsTableView.delegate = self
        self.bookingDetailsTableView.dataSource = self
        self.viewModel.getSectionDataForFlightProductType()
        self.bookingDetailsTableView.reloadData()
        // get All trip owned API
        self.viewModel.getTripOwnerApi()
    }
    
    func getBookingDetailFaiure(error: ErrorCodes,showProgress: Bool) {
        if showProgress {
            self.headerView?.stopProgress()
        }
        self.refreshControl.endRefreshing()
        AppToast.default.showToastMessage(message: LocalizedString.SomethingWentWrong.localized)
        //AppGlobals.shared.stopLoading()
    }
    func willGetTripOwner() {
        
    }
    func getBTripOwnerSucces() {
        self.bookingDetailsTableView.reloadData()
    }
    func getTripOwnerFaiure(error: ErrorCodes) {
        self.bookingDetailsTableView.reloadData()
    }
    
    func getBookingOutstandingPaymentSuccess() {
        self.showDepositOptions()
    }
    
    func getBookingOutstandingPaymentFail() {
//        self.payButtonRef?.isLoading = false
    }
}

// MARK: -

extension FlightBookingsDetailsVC: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        AppFlowManager.default.mainNavigationController.dismiss(animated: true, completion: nil)
    }
}

// MARK: -

extension FlightBookingsDetailsVC: SelectTripVCDelegate {
    func selectTripVC(sender: SelectTripVC, didSelect trip: TripModel, tripDetails: TripDetails?) {
        printDebug("trip: \(trip)")
        printDebug("tripDetails: \(tripDetails)")
        self.updatedTripDetail = trip
        self.viewModel.bookingDetail?.tripInfo?.eventId = tripDetails?.event_id ?? ""
        self.viewModel.bookingDetail?.tripInfo?.tripId = tripDetails?.trip_id ?? ""
        self.viewModel.bookingDetail?.tripInfo?.name = tripDetails?.name ?? ""
        AppToast.default.showToastMessage(message: LocalizedString.FlightTripChangeMessage.localized + "\(trip.name)")
        if let indexPath = self.tripChangeIndexPath {
            self.bookingDetailsTableView.reloadRow(at: indexPath, with: .none)
        }
        self.viewModel.getTripOwnerApi()
    }
}

// MARK: - AddonRequestVC Delegate methods

extension FlightBookingsDetailsVC: BookingRequestAddOnsFFVCDelegate {
    func addOnAndFFUpdated() {
        self.viewModel.getBookingDetail(showProgress: true)
    }
    
    
}
/*
 https://stackoverflow.com/questions/39927087/unable-to-add-pass-to-apple-wallet
 */
