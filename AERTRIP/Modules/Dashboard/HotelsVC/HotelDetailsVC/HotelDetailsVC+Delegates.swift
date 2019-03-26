//
//  HotelDetailsVC+Delegates.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//Mark:- UITableView Delegate And Datasource
//==========================================
extension HotelDetailsVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.hotelData != nil {
            return self.viewModel.ratesData.isEmpty ? 3 : self.viewModel.ratesData.count + 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.hotelData != nil {
            switch section {
            case 0:
                return 6
            case 1:
                return 1
            default:
                self.updateStickyFooterView()
                if self.viewModel.ratesData.isEmpty {
                    return 1
                } else {
                    return self.viewModel.tableViewRowCell[section-2].count
                }
            }
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let hotelDetails = self.viewModel.hotelData {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    let cell = self.getImageSlideCell(indexPath: indexPath, hotelDetails: hotelDetails)
                    return cell
                case 1:
                    let cell = self.getHotelRatingInfoCell(indexPath: indexPath, hotelDetails: hotelDetails)
                    return cell
                case 2:
                    let cell = self.getHotelInfoAddressCell(indexPath: indexPath, hotelDetails: hotelDetails)
                    return cell
                case 3:
                    let cell = self.getHotelOverViewCell(indexPath: indexPath, hotelDetails: hotelDetails)
                    return cell
                case 4:
                    let cell = self.getHotelDetailsAmenitiesCell(indexPath: indexPath, hotelDetails: hotelDetails)
                    return cell
                case 5:
                    let cell = self.getTripAdviserCell(indexPath: indexPath, hotelDetails: hotelDetails)
                    return cell
                default:
                    return UITableViewCell()
                }
            } else if indexPath.section == 1 {
                let cell = self.getSearchBarTagCell(indexPath: indexPath, hotelDetails: hotelDetails)
                return cell
            }
            else {
                if self.viewModel.ratesData.isEmpty {
                    if let cell = self.getHotelDetailsEmptyStateCell(indexPath: indexPath) {
                        return cell
                    }
                } else {
                    
                    let currentRatesData = self.viewModel.ratesData[indexPath.section - 2]
                    let currentRoomData = self.viewModel.roomRates[indexPath.section - 2]
                    let tableViewRowCell = self.viewModel.tableViewRowCell[indexPath.section - 2]
                    
                    switch tableViewRowCell[indexPath.row] {
                    case .roomBedsType:
                        if let cell = self.getBedDeailsCell(indexPath: indexPath, ratesData: currentRatesData, roomData: currentRoomData){
                            return cell
                        }
                    case .inclusion:
                        if let cell = self.getInclusionCell(indexPath: indexPath, ratesData: currentRatesData) {
                            return cell
                        }
                    case .otherInclusion:
                        if let cell = self.otherInclusionCell(indexPath: indexPath, ratesData: currentRatesData) {
                            return cell
                        }
                    case .cancellationPolicy:
                        if let cell = self.getCancellationCell(indexPath: indexPath, ratesData: currentRatesData) {
                            return cell
                        }
                    case .paymentPolicy:
                        if let cell = self.getPaymentInfoCell(indexPath: indexPath, ratesData: currentRatesData) {
                            return cell
                        }
                    case .notes:
                        if let cell = self.getNotesCell(indexPath: indexPath, ratesData: currentRatesData) {
                            return cell
                        }
                    case .checkOut:
                        if let cell = self.getCheckOutCell(indexPath: indexPath, ratesData: currentRatesData) {
                            return cell
                        }
                    }
                }
            }
        } else {
            guard let hotelInfo = self.viewModel.hotelInfo else { return UITableViewCell() }
            switch indexPath.row {
            case 0:
                let cell = self.getImageSlideCellWithInfo(indexPath: indexPath, hotelInfo: hotelInfo)
                return cell
            case 1:
                let cell = self.getHotelRatingCellWithInfo(indexPath: indexPath, hotelInfo: hotelInfo)
                return cell
            case 2:
                let cell = self.getLoaderCell(indexPath: indexPath)
                return cell
            default: return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if (tableView.cellForRow(at: indexPath) as? HotelInfoAddressCell) != nil {
                if indexPath.row == 2 {
                    self.redirectToMap()
                } else if indexPath.row == 3 {
                    AppFlowManager.default.presentHotelDetailsOverViewVC(overViewInfo: self.viewModel.hotelData?.info ?? "")
                }
            } else if (tableView.cellForRow(at: indexPath) as? TripAdvisorTableViewCell) != nil {
                AppFlowManager.default.presentHotelDetailsTripAdvisorVC(hotelId: self.viewModel.hotelData?.hid ?? "")
            }
        }
        else if let _ = tableView.cellForRow(at: indexPath) as? HotelDetailsCheckOutTableViewCell {
            AppFlowManager.default.proccessIfUserLoggedIn(verifyingFor: .loginVerificationForCheckout) { [weak self](isGuest) in
                guard let sSelf = self else {return}
                AppFlowManager.default.moveToHCDataSelectionVC(sid: sSelf.viewModel.hotelSearchRequest?.sid ?? "", hid: sSelf.viewModel.hotelInfo?.hid ?? "", qid: sSelf.viewModel.ratesData[indexPath.section-2].qid)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeaderView(tableView: tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeaderView(tableView: tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return self.heightForFooterView(tableView: tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.heightForFooterView(tableView: tableView, section: section)
    }
}

//Mark:- HotelDetailDelegate
//==========================
extension HotelDetailsVC: HotelDetailDelegate {
    
    func willSaveHotelWithTrip() {
        
    }
    
    func saveHotelWithTripSuccess(trip: TripModel) {
        let message = trip.isDefault ? "Added to default trip" : "Added to \(trip.name) trip"
        AppToast.default.showToastMessage(message: message, onViewController: self)
    }
    
    func getHotelDetailsSuccess() {
        self.filterdHotelData(tagList: self.viewModel.selectedTags)
        let index = IndexPath(row: 2, section: 0)
        if let cell = self.hotelTableView.cellForRow(at: index) as? HotelDetailsLoaderTableViewCell {
            cell.activityIndicator.stopAnimating()
        }
        self.hotelTableView.reloadData()
    }
    
    func getHotelDetailsFail() {
        let index = IndexPath(row: 2, section: 0)
        if let cell = self.hotelTableView.cellForRow(at: index) as? HotelDetailsLoaderTableViewCell {
            cell.activityIndicator.stopAnimating()
            delay(seconds: AppConstants.kAnimationDuration) {
                cell.activityIndicator.isHidden = true
            }
        }
        AppToast.default.showToastMessage(message: LocalizedString.InformationUnavailable.localized, onViewController: self, buttonTitle: LocalizedString.ReloadResults.localized, buttonImage: nil, buttonAction: self.completion)
        printDebug("API Parsing Failed")
    }
    
    func updateFavouriteSuccess(withMessage: String) {
        self.hotelTableView.reloadData()
        self.sendDataChangedNotification(data: self)
        let buttonImage: UIImage = self.viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
        self.headerView.leftButton.setImage(buttonImage, for: .normal)
        self.delegate?.hotelFavouriteUpdated()
    }
    
    func updateFavouriteFail(errors:ErrorCodes) {
        AppNetworking.hideLoader()
        let buttonImage: UIImage = self.viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
        self.headerView.leftButton.setImage(buttonImage, for: .normal)
        if errors.contains(array: [-1]) {
            AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
        } else {
             AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
        }
        
    }
    
    func getHotelDistanceAndTimeSuccess() {
        if let placeModel = self.viewModel.placeModel {
            if !(placeModel.durationValue/60 < 10) {
                self.viewModel.mode = .driving
                self.viewModel.getHotelDistanceAndTimeInfo()
            }
        }
        self.hotelTableView.reloadData()
    }
    
    func getHotelDistanceAndTimeFail() {
        printDebug("time and distance not found")
    }
}

//Mark:- ScrollView Delegate
//==========================
extension HotelDetailsVC {
    private func manageHeaderView(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if (hotelImageHeight - headerView.height) < yOffset {
            //show
            self.headerView.navTitleLabel.text = self.viewModel.hotelInfo?.hotelName
            self.headerView.animateBackView(isHidden: false, completion: nil)
            let selectedFevImage: UIImage = self.viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "save_icon_green")
            self.headerView.leftButton.setImage(selectedFevImage, for: .normal)
            self.headerView.firstRightButton.setImage(#imageLiteral(resourceName: "black_cross"), for: .normal)
        }
        else {
            //hide
            self.headerView.navTitleLabel.text = ""
            self.headerView.animateBackView(isHidden: true, completion: nil)
            let buttonImage: UIImage = self.viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
            self.headerView.leftButton.setImage(buttonImage, for: .normal)
            self.headerView.firstRightButton.setImage(#imageLiteral(resourceName: "CancelButtonWhite"), for: .normal)
        }
    }
    
    func manageBottomRateView(_ scrollView: UIScrollView) {
        if hotelTableView.numberOfSections > 2 {
            let rows = hotelTableView.numberOfRows(inSection: 2)
            let indexPath = IndexPath(row: rows-1, section: 2)
            let extra = UIDevice.isIPhoneX ? UIApplication.shared.statusBarFrame.height : 0.0
            var finalY: CGFloat = 0.0
            if let cell = hotelTableView.cellForRow(at: indexPath) as? HotelDetailsCheckOutTableViewCell {
                
                finalY = self.view.convert(cell.contentView.frame, to: hotelTableView).origin.y + UIApplication.shared.statusBarFrame.height + 10.0
                if self.initialStickyPosition <= 0.0 {
                    self.initialStickyPosition = finalY
                }
                
                let bottomCons = (scrollView.contentOffset.y - self.initialStickyPosition)
                if 0...self.footerView.height ~= bottomCons {
                    self.stickyBottomConstraint.constant = -(bottomCons)
                }
                else if self.initialStickyPosition <= 0.0 {
                    self.stickyBottomConstraint.constant = 0.0
                }
                else if (self.initialStickyPosition + self.footerView.height) < finalY {
                    self.stickyBottomConstraint.constant = -(self.footerView.height)
                }
            }
            else {
                if (self.initialStickyPosition + self.footerView.height) > scrollView.contentOffset.y {
                    self.stickyBottomConstraint.constant = 0.0
                }
                self.initialStickyPosition = -1.0
            }
        }
        else {
            self.stickyBottomConstraint.constant = 0.0
        }
        self.oldScrollPosition = scrollView.contentOffset
    }
    
    private func closeOnScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        printDebug(yOffset)
        if -(yOffset) >= didsmissOnScrollPosition {
            //close
            self.hideOnScroll()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.manageHeaderView(scrollView)
        self.manageBottomRateView(scrollView)
        self.closeOnScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            self.closeOnScroll(scrollView)
            self.manageBottomRateView(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.closeOnScroll(scrollView)
        self.manageHeaderView(scrollView)
        self.manageBottomRateView(scrollView)
    }
    
}

//Mark:- HotelDetailsImgSlideCellDelegate
//=======================================
extension HotelDetailsVC: HotelDetailsImgSlideCellDelegate {
    func hotelImageTapAction(at index: Int) {
        // open gallery with show image at index
        if let topVC = UIApplication.topViewController() {
            ATGalleryViewController.show(onViewController: topVC, sourceView: self.imageView, startShowingFrom: index, datasource: self, delegate: self)
        }
    }
    
    func willShowImage(at index: Int, image: UIImage?) {
        self.imageView.image = image
    }
}

//Mark:- ATGallery Delegate And Datasource
//========================================
extension HotelDetailsVC: ATGalleryViewDelegate, ATGalleryViewDatasource {
    
    func numberOfImages(in galleryView: ATGalleryViewController) -> Int {
        return self.viewModel.hotelData?.photos.count ?? 0
    }
    
    func galleryView(galleryView: ATGalleryViewController, galleryImageAt index: Int) -> ATGalleryImage {
        var image = ATGalleryImage()
        image.imagePath = self.viewModel.hotelData?.photos[index]
        return image
    }
    
    func galleryView(galleryView: ATGalleryViewController, willShow image: ATGalleryImage, for index: Int) {
        self.imagesCollectionView?.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
    }
}

//Mark:- HotelDetailsBedsTableViewCellDelegate
//==========================
extension HotelDetailsVC: HotelDetailsBedsTableViewCellDelegate {
    func bookMarkButtonAction(sender: HotelDetailsBedsTableViewCell) {
        AppFlowManager.default.selectTrip { (trip) in
            
            delay(seconds: 0.3, completion: { [weak self] in
                guard let sSelf = self else {return}
                
                if let indexPath = sSelf.hotelTableView.indexPath(for: sender) {
                    let currentRatesData = sSelf.viewModel.ratesData[indexPath.section - 2]
                    let currentRoomData = sSelf.viewModel.roomRates[indexPath.section - 2]
                    
                    sSelf.viewModel.saveHotelWithTrip(toTrip: trip, forRate: currentRatesData, forRoomRate: Array(currentRoomData.keys)[indexPath.row])
                }
            })
        }
    }
}

//Mark:- GetFullInfoDelegate
//==========================
extension HotelDetailsVC: GetFullInfoDelegate {
    func expandCell(expandHeight: CGFloat, indexPath: IndexPath) {
        self.expandHeight = expandHeight
        if !allIndexPath.contains(indexPath) {
            self.allIndexPath.append(indexPath)
            self.hotelTableView.reloadData()
        }
    }
}

