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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = self.viewModel.sectionDataForOtherProductType[indexPath.section]
        switch currentSection[indexPath.row] {
        case .policyDetailCell:
            return UITableView.automaticDimension//35.0
        case .gstCell:
            return self.viewModel.bookingDetail?.billingInfo?.gst.isEmpty ?? true ? CGFloat.leastNonzeroMagnitude : UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printDebug("\(indexPath.section)")
        
        if let _ = tableView.cellForRow(at: indexPath) as? PaymentInfoTableViewCell, let rcpt = self.viewModel.bookingDetail?.receipt {
            //move to voucher vc
            AppFlowManager.default.moveToBookingVoucherVC(receipt: rcpt, bookingId: self.viewModel.bookingId)
        }
    }
}

extension OtherBookingsDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.ProcessCancellation.localized, LocalizedString.SpecialRequest.localized, LocalizedString.Download.localized, LocalizedString.ResendConfirmationEmail.localized], colors: [AppColors.themeGreen, AppColors.themeGreen, AppColors.themeGreen, AppColors.themeGreen])
        //        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton, tapBlock: { _, index in
        //            switch index {
        //            case 0:
        //                printDebug("0")
        //            case 1:
        //                printDebug("1")
        //            case 2:
        //                printDebug("2")
        //            case 3:
        //                printDebug("3")
        //            default:
        //                printDebug("default")
        //            }
        //        })
    }
}

extension OtherBookingsDetailsVC: BookingDocumentsTableViewCellDelegate {
    func downloadDocument(documentDirectory: String, tableIndex: IndexPath, collectionIndex: IndexPath) {
        self.viewModel.currentDocumentPath = documentDirectory
        printDebug(documentDirectory)
        let destinationUrl = URL(fileURLWithPath: documentDirectory)
        printDebug(destinationUrl)
        guard let documentDownloadingData = self.viewModel.bookingDetail?.documents else { return }
        AppNetworking.DOWNLOAD(sourceUrl: documentDownloadingData[collectionIndex.item].sourceUrl, destinationUrl: destinationUrl, requestHandler: { [weak self] request in
            guard let sSelf = self else { return }
            printDebug(request)
            documentDownloadingData[collectionIndex.item].downloadingStatus = .downloading
            documentDownloadingData[collectionIndex.item].downloadRequest = request
            }, progressUpdate: { [weak self] progress in
                guard self != nil else { return }
                documentDownloadingData[collectionIndex.item].progressUpdate?(progress)
            }, success: { [weak self] success in
                guard let sSelf = self else { return }
                documentDownloadingData[collectionIndex.item].downloadingStatus = .downloaded
                UIView.performWithoutAnimation {
                    sSelf.dataTableView.reloadData()
                }
                printDebug(success)
        }) { [weak self] error in
            guard let sSelf = self else { return }
            documentDownloadingData[collectionIndex.item].downloadingStatus = .notDownloaded
            UIView.performWithoutAnimation {
                sSelf.dataTableView.reloadData()
            }
            printDebug(error)
        }
    }
    
    func cancelDownloadDocument(itemIndexPath: IndexPath) {
        printDebug("Downloading Stop")
        guard let documentDownloadingData = self.viewModel.bookingDetail?.documents else { return }
        documentDownloadingData[itemIndexPath.item].downloadRequest?.cancel()
    }
}

// MARK: - ScrollView Delegate

//==========================
extension OtherBookingsDetailsVC: MXParallaxHeaderDelegate {
    //    func updateForParallexProgress() {
    //        let prallexProgress = self.dataTableView.parallaxHeader.progress
    //        printDebug("progress %f \(prallexProgress)")
    //        if prallexProgress <= 0.65 {
    //            self.topNavBar.animateBackView(isHidden: false) { [weak self] _ in
    //                guard let sSelf = self else { return }
    //                sSelf.topNavBar.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: sSelf.eventTypeImage, endText: self?.viewModel.bookingDetail?.bookingDetail?.title ?? "", font: AppFonts.SemiBold.withSize(18.0), isEndTextBold: true)
    //                sSelf.headerView?.bookingIdAndDateTitleLabel.alpha = 0
    //                sSelf.headerView?.bookingIdAndDateLabel.alpha = 0
    //                sSelf.topNavBar.dividerView.isHidden = false
    //            }
    //        } else {
    //            self.topNavBar.animateBackView(isHidden: true) { [weak self] _ in
    //                guard let sSelf = self else { return }
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
        
        let prallexProgress = self.dataTableView.parallaxHeader.progress
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
                    sSelf.topNavBar.navTitleLabel.text = ""
                    sSelf.headerView?.bookingIdAndDateTitleLabel.alpha = 1
                    sSelf.headerView?.bookingIdAndDateLabel.alpha = 1
                    sSelf.topNavBar.dividerView.isHidden = true
                }
                
            } else {
                
                self.topNavBar.animateBackView(isHidden: false) { [weak self] _ in
                    guard let sSelf = self else { return }
                    sSelf.topNavBar.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: sSelf.eventTypeImage, endText: self?.viewModel.bookingDetail?.bookingDetail?.title ?? "", font: AppFonts.SemiBold.withSize(18.0), isEndTextBold: true)
                    sSelf.headerView?.bookingIdAndDateTitleLabel.alpha = 0
                    sSelf.headerView?.bookingIdAndDateLabel.alpha = 0
                    sSelf.topNavBar.dividerView.isHidden = false
                }
            }
        } else {
            
            self.topNavBar.animateBackView(isHidden: true) { [weak self] _ in
                guard let sSelf = self else { return }
                sSelf.topNavBar.navTitleLabel.text = ""
                sSelf.headerView?.bookingIdAndDateTitleLabel.alpha = 1
                sSelf.headerView?.bookingIdAndDateLabel.alpha = 1
                sSelf.topNavBar.dividerView.isHidden = true
            }
            
        }
        self.isNavBarHidden = false
        
    }
}

// MARK: -

extension OtherBookingsDetailsVC: BookingProductDetailVMDelegate {
    func willGetBookingDetail(showProgress: Bool) {
        if showProgress {
        self.headerView?.startProgress()
        }
        //AppGlobals.shared.startLoading()
    }
    
    func getBookingDetailSucces(showProgress: Bool) {
        if showProgress {
        self.headerView?.stopProgress()
        }
        self.refreshControl.endRefreshing()
        self.configureTableHeaderView()
        self.dataTableView.delegate = self
        self.dataTableView.dataSource = self
        self.viewModel.getSectionDataForOtherProductType()
        self.dataTableView.reloadData()
        //AppGlobals.shared.stopLoading()
    }
    
    func getBookingDetailFaiure(error: ErrorCodes,showProgress: Bool) {
        AppToast.default.showToastMessage(message: LocalizedString.SomethingWentWrong.localized)
        if showProgress {
        self.headerView?.stopProgress()
        }
        self.refreshControl.endRefreshing()
        //AppGlobals.shared.stopLoading()
    }
    
    func willGetTripOwner() {
        
    }
    func getBTripOwnerSucces() {
       self.dataTableView.reloadData()
    }
    func getTripOwnerFaiure(error: ErrorCodes) {
        self.dataTableView.reloadData()
    }
    
    func getBookingOutstandingPaymentSuccess() {
        self.showDepositOptions()
    }
    
    func getBookingOutstandingPaymentFail() {
//        self.payButtonRef?.isLoading = false
    }
    
}
