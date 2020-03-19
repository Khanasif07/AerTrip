//
//  BookingHotelDetailVC+DelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource and UITableViewDeleagate methods

extension BookingHotelDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        // 2 is added here: one for hotelimages cell,checkInCheckOut,rating and other for Adress,phone,website,overview and amenities
        return 2 + (self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // hotelImages cell,checkInCeckOut,ratings etc
        if section == 0 {
            return 4
            
            // Room data details
        } else if section >= 1, section <= self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0 {
            return 5
            // Adress,phone,website,overview and amenities
        } else if section == ((self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0) + 1) {
            return 6
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height for hotelImages cell,checkInCeckOut,ratings etc
        if indexPath.section == 0 {
            return getHeightForRowFirstSection(indexPath)
            // height for room details cell
        } else if indexPath.section >= 1, indexPath.section <= self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0 {
            return getHeightForRoomSection(indexPath)
            // Adress,phone,website,overview and amenities
        } else if indexPath.section == ((self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0) + 1) {
            return getHeightForLastSection(indexPath)
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // height for hotelImages cell,checkInCeckOut,ratings etc
        if indexPath.section == 0 {
            return getCellForFirstSection(indexPath)
            // height for room details cell
        } else if indexPath.section >= 1, indexPath.section <= self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0 {
            return getCellForRoomSection(indexPath)
            // Adress,phone,website,overview and amenities
        } else if indexPath.section == ((self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0) + 1) {
            return getCellForLastSection(indexPath)
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section >= 1, section <= self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0 {
            return UITableView.automaticDimension
        } else {
            return 0
        }
    }
    
    // header for footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == ((self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0) + 1) {
            return 35.0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 93.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Room Data Header section
        if section >= 1, section <= self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0 {
            guard let headerView = self.hotelDetailTableView.dequeueReusableHeaderFooterView(withIdentifier: "BookingHDRoomDetailHeaderView") as? BookingHDRoomDetailHeaderView else {
                fatalError("BookingHDRoomDetailHeaderView not found ")
            }
            var roomTitle: String = "\(LocalizedString.Room.localized) \(section)"
            if let voucher = self.viewModel.bookingDetail?.bookingDetail?.roomDetails[section-1].voucher, !voucher.isEmpty {
                roomTitle.append("-")
                roomTitle.append((self.viewModel.bookingDetail?.bookingDetail?.roomDetails[section - 1].voucher ?? ""))
            }
            headerView.configureHeader(roomTitle: roomTitle, roomType: self.viewModel.bookingDetail?.bookingDetail?.roomDetails[section - 1].roomType ?? "", roomDescription: self.viewModel.bookingDetail?.bookingDetail?.roomDetails[section - 1].description ?? "")
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == ((self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0) + 1) {
            guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as? BookingInfoEmptyFooterView else {
                fatalError("BookingInfoFooterView not found")
            }
            return footerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == ((self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 0) + 1) {
            if indexPath.row == 0 { // Address Cell {
                self.openMaps()
            } else if indexPath.row == 1 { // Phone cell
                var uc = URLComponents()
                uc.scheme = "tel"
                uc.path =  self.viewModel.bookingDetail?.bookingDetail?.phoneDetail ?? ""
                
                if let phoneURL = uc.url {
                    //            let alert = UIAlertController(title: phoneNumber, message: nil, preferredStyle: .alert)
                    //            alert.view.tintColor = AppColors.themeGreen
                    //            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { _ in
                    //
                    //            }))
                    UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                   // UIApplication.shared.openURL(phoneURL as URL)
                    //   alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    // self.present(alert, animated: true, completion: nil)
                }
            } else if indexPath.row == 2 { // Website
                 let website = self.viewModel.bookingDetail?.bookingDetail?.websiteDetail ?? ""
                if !website.isEmpty{
                    guard let url = URL(string: website) else {return}
                    UIApplication.shared.open(url, options: [:])
                }
            }
            
            else if indexPath.row == 3, (self.viewModel.bookingDetail?.bookingDetail?.overViewData ?? "") != LocalizedString.SpaceWithHiphen.localized { // Overview cell {
                AppFlowManager.default.presentHotelDetailsOverViewVC(overViewInfo: self.viewModel.bookingDetail?.bookingDetail?.info ?? "")
            } else if indexPath.row == 5 {
                AppFlowManager.default.presentHotelDetailsTripAdvisorVC(hotelId: self.viewModel.bookingDetail?.bookingDetail?.hotelId ?? "")
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        printDebug("scroll inset \(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y <= 54 {
            self.topNavigationView.animateBackView(isHidden: true) { [weak self] _ in
                guard let sSelf = self else { return }
                sSelf.topNavigationView.backView.backgroundColor = AppColors.clear
                sSelf.topNavigationView.leftButton.setImage(#imageLiteral(resourceName: "whiteBackIcon"), for: .normal)
                sSelf.topNavigationView.leftButton.setImage(#imageLiteral(resourceName: "whiteBackIcon"), for: .selected)
                sSelf.topNavigationView.navTitleLabel.text = " "
                sSelf.topNavigationView.dividerView.isHidden = true
            }
        } else {
            self.topNavigationView.animateBackView(isHidden: false) { [weak self] _ in
                guard let sSelf = self else { return }
                sSelf.topNavigationView.backView.backgroundColor = AppColors.themeWhite
                sSelf.topNavigationView.navTitleLabel.text = self?.viewModel.hotelTitle
                sSelf.topNavigationView.leftButton.setImage(#imageLiteral(resourceName: "backGreen"), for: .normal)
                  sSelf.topNavigationView.leftButton.setImage(#imageLiteral(resourceName: "backGreen"), for: .selected)
                sSelf.topNavigationView.dividerView.isHidden = false
            }
        }
    }
}

// MARK:

extension BookingHotelDetailVC: HotelDetailsImgSlideCellDelegate {
    func hotelImageTapAction(at index: Int) {
        // open gallery with show image at index
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = self.hotelDetailTableView.cellForRow(at: indexPath) as? HotelDetailsImgSlideCell else { return }
        if let topVC = UIApplication.topViewController() {
            ATGalleryViewController.show(onViewController: topVC, sourceView: cell.imageCollectionView, startShowingFrom: index, datasource: self, delegate: self)
        }
    }
    
    func willShowImage(at index: Int, image: UIImage?) {
        //        self.imageView.image = image
    }
}

// Mark:- ATGallery Delegate And Datasource
//========================================
extension BookingHotelDetailVC: ATGalleryViewDelegate, ATGalleryViewDatasource {
    func galleryViewWillClose(galleryView: ATGalleryViewController) {
    }
    
    func galleryViewDidClose(galleryView: ATGalleryViewController) {
    }
    
    func numberOfImages(in galleryView: ATGalleryViewController) -> Int {
        return self.viewModel.bookingDetail?.bookingDetail?.completePhotos.count ?? 0
    }
    
    func galleryView(galleryView: ATGalleryViewController, galleryImageAt index: Int) -> ATGalleryImage {
        var image = ATGalleryImage()
        image.imagePath = self.viewModel.bookingDetail?.bookingDetail?.completePhotos[index]
        return image
    }
    
    func galleryView(galleryView: ATGalleryViewController, willShow image: ATGalleryImage, for index: Int) {
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = self.hotelDetailTableView.cellForRow(at: indexPath) as? HotelDetailsImgSlideCell else { return }
        cell.imageCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
    }
}

// Top Navigation View Delegate
extension BookingHotelDetailVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

// HotelDetailAmenitiesCellDelegate methods

extension BookingHotelDetailVC: HotelDetailAmenitiesCellDelegate {
    // TODO: - Amentities data not coming
    func viewAllButtonAction() {
        AppFlowManager.default.showHotelDetailAmenitiesVC(amenitiesGroups: self.viewModel.bookingDetail?.bookingDetail?.amenitiesGroups ?? [:], amentites: self.viewModel.bookingDetail?.bookingDetail?.amenities)
    }
}

// Booking Cancellation policy Delegate methods

extension BookingHotelDetailVC: BookingCancellationPolicyTableViewCellDelegate {
    func bookingPolicyButtonTapped() {
        AppFlowManager.default.presentPolicyVC(.bookingPolicy, bookingDetail: self.viewModel.bookingDetail)
    }
    
    func cancellationPolicyButonTapped() {
        AppFlowManager.default.presentPolicyVC(.cancellationPolicy, bookingDetail: self.viewModel.bookingDetail)
    }
}

// Booking Select trip Trip

extension BookingHotelDetailVC: SelectTripVCDelegate {
    func selectTripVC(sender: SelectTripVC, didSelect trip: TripModel, tripDetails: TripDetails?) {
        //
    }
}
