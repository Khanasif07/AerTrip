//
//  HotelCheckOutDetailsVIew+Delegates.swift
//  AERTRIP
//
//  Created by Admin on 02/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//Mark:- UITableView Delegate DataSource
//======================================
extension HotelCheckOutDetailsVIew: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let hotelDetails = self.viewModel , let rates = hotelDetails.rates?.first else { return UITableViewCell() }
        let sectionData = self.sectionData[indexPath.section]
        switch sectionData[indexPath.row] {
            
        case .imageSlideCell:
            let cell = self.getImageSlideCell(indexPath: indexPath, hotelDetails: hotelDetails)
            return cell
        case .hotelRatingCell:
            let cell = self.getHotelRatingInfoCell(indexPath: indexPath, hotelDetails: hotelDetails)
            return cell
        case .addressCell:
            let cell = self.getHotelInfoAddressCell(indexPath: indexPath, hotelDetails: hotelDetails)
            return cell
        case .checkInOutDateCell:
            if let cell = self.getCheckInOutCell(tableView, indexPath: indexPath, hotelDetails: hotelDetails) {
                return cell
            }
        case .amenitiesCell:
            let cell = self.getHotelDetailsAmenitiesCell(indexPath: indexPath, hotelDetails: hotelDetails)
            return cell
        case .overViewCell:
            let cell = self.getHotelOverViewCell(indexPath: indexPath, hotelDetails: hotelDetails)
            return cell
        case .tripAdvisorRatingCell:
            let cell = self.getTripAdviserCell(indexPath: indexPath)
            return cell
        case .roomDetailsCell:
            if let cell = self.getRoomCell(tableView, indexPath: indexPath) {
                return cell
            }
        case .roomBedsTypeCell:
            if let cell = self.getBedDeailsCell(indexPath: indexPath, ratesData: rates, roomData: rates.roomData){
                return cell
            }
        case .inclusionCell:
            if let cell = self.getInclusionCell(indexPath: indexPath, ratesData: rates) {
                return cell
            }
        case .otherInclusionCell:
            if let cell = self.otherInclusionCell(indexPath: indexPath, ratesData: rates) {
                return cell
            }
        case .cancellationPolicyCell:
            if let cell = self.getCancellationCell(indexPath: indexPath, ratesData: rates) {
                return cell
            }
        case .paymentPolicyCell:
            if let cell = self.getPaymentInfoCell(indexPath: indexPath, ratesData: rates) {
                return cell
            }
        case .notesCell:
            if let cell = self.getNotesCell(indexPath: indexPath, ratesData: rates) {
                return cell
            }
        default:
            printDebug("cell is not in UI")
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if (tableView.cellForRow(at: indexPath) as? HotelInfoAddressCell) != nil {
                if indexPath.row == 2 {
                    self.redirectToMap()
                } else if indexPath.row == 3 {
                    AppFlowManager.default.presentHotelDetailsOverViewVC(overViewInfo: self.viewModel?.info ?? "")
                }
            } else if (tableView.cellForRow(at: indexPath) as? TripAdvisorTableViewCell) != nil , let locid = self.viewModel?.locid {
                !locid.isEmpty ? AppFlowManager.default.presentHotelDetailsTripAdvisorVC(hotelId: self.viewModel?.hid ?? "") : printDebug(locid + "location id is empty")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0, indexPath.row == 2 {
            if let hotelData = self.viewModel {
                let text = hotelData.address + "Maps   "
                let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
                return size.height + 46.5
                    + 14.0//y of textview 46.5 + bottom space 14.0
            }
        }
        return UITableView.automaticDimension
    }
}

extension HotelCheckOutDetailsVIew: GetFullInfoDelegate {
    
    func expandCell(expandHeight: CGFloat, indexPath: IndexPath) {
        if !allIndexPath.contains(indexPath) {
            self.allIndexPath.append(indexPath)
            self.hotelDetailsTableView.reloadData()
        }
        printDebug(indexPath)
    }
}

extension HotelCheckOutDetailsVIew: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        delegate?.addHotelInFevList()
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        delegate?.crossButtonTapped()
    }
}

//Mark:- HotelDetailAmenitiesCellDelegate
//=======================================
extension HotelCheckOutDetailsVIew: HotelDetailAmenitiesCellDelegate {
    func viewAllButtonAction() {
        if let hotelData = self.viewModel {
            AppFlowManager.default.showHotelDetailAmenitiesVC(hotelDetails: hotelData)
        }
    }
}

//Mark:- ScrollView Delegate
//==========================
extension HotelCheckOutDetailsVIew: UIScrollViewDelegate {
    private func manageHeaderView(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if (hotelImageHeight - headerView.height) < yOffset {
            //show
            self.headerView.navTitleLabel.text = self.hotelInfo?.hotelName
            self.headerView.animateBackView(isHidden: false, completion: nil)
            let selectedFevImage: UIImage = self.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "save_icon_green")
            self.headerView.leftButton.setImage(selectedFevImage, for: .normal)
            self.headerView.firstRightButton.setImage(#imageLiteral(resourceName: "black_cross"), for: .normal)
        }
        else {
            //hide
            self.headerView.navTitleLabel.text = ""
            self.headerView.animateBackView(isHidden: true, completion: nil)
            let buttonImage: UIImage = self.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
            self.headerView.leftButton.setImage(buttonImage, for: .normal)
            self.headerView.firstRightButton.setImage(#imageLiteral(resourceName: "CancelButtonWhite"), for: .normal)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.manageHeaderView(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.manageHeaderView(scrollView)
    }
}

//Mark:- HotelDetailsImgSlideCellDelegate
//=======================================
extension HotelCheckOutDetailsVIew: HotelDetailsImgSlideCellDelegate {
    func hotelImageTapAction(at index: Int) {
        // open gallery with show image at index
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = self.hotelDetailsTableView.cellForRow(at: indexPath) as? HotelDetailsImgSlideCell else { return }
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
extension HotelCheckOutDetailsVIew: ATGalleryViewDelegate, ATGalleryViewDatasource {

    func numberOfImages(in galleryView: ATGalleryViewController) -> Int {
        return self.viewModel?.photos.count ?? 0
    }

    func galleryView(galleryView: ATGalleryViewController, galleryImageAt index: Int) -> ATGalleryImage {
        var image = ATGalleryImage()
        image.imagePath = self.viewModel?.photos[index]
        return image
    }

    func galleryView(galleryView: ATGalleryViewController, willShow image: ATGalleryImage, for index: Int) {
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = self.hotelDetailsTableView.cellForRow(at: indexPath) as? HotelDetailsImgSlideCell else { return }
        cell.imageCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
    }
}
