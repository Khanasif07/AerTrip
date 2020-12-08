//
//  HotelCheckoutDetailVC+UITableViewDelegate.swift
//  AERTRIP
//
//  Created by Admin on 29/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

// Mark:- UITableView Delegate DataSource
//======================================
extension HotelCheckoutDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let hotelDetails = self.viewModel, let rates = hotelDetails.rates?.first else { return UITableViewCell() }
        let sectionData = self.sectionData[indexPath.section]
        switch sectionData[indexPath.row] {
        case .imageSlideCell:
            let cell = self.getImageSlideCell(indexPath: indexPath, hotelDetails: hotelDetails)
            return cell
        case .noImageCell:
            let cell = self.getNoImageCell()
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
            if let cell = self.getBedDeailsCell(indexPath: indexPath, ratesData: rates, roomData: self.roomRates[indexPath.section - 2]) {
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
            let sectionData = self.sectionData[indexPath.section]
            switch sectionData[indexPath.row] {
            case .noImageCell:
                if (self.viewModel?.hid ?? "") == TAViewModel.shared.hotelId, let data = TAViewModel.shared.hotelTripAdvisorDetails{
                    let urlString = "https:\(data.seeAllPhotos)"
                    let screenTitle = LocalizedString.Photos.localized
                    guard let url = URL(string: urlString) else {return}
                    AppFlowManager.default.showURLOnATWebView(url, screenTitle: screenTitle)
                }
            case .addressCell:
                guard let reqParams = self.requestParameters, let destParams = self.viewModel else { return }
                AppGlobals.shared.redirectToMap(sourceView: self.view, originLat: reqParams.latitude, originLong: reqParams.longitude, destLat: destParams.lat, destLong: destParams.long)
            case .overViewCell:
                AppFlowManager.default.presentHotelDetailsOverViewVC(overViewInfo: self.viewModel?.info ?? "")
            case .tripAdvisorRatingCell:
                if let locid = self.viewModel?.locid {
                    !locid.isEmpty ? AppFlowManager.default.presentHotelDetailsTripAdvisorVC(hotelId: self.viewModel?.hid ?? "") : printDebug(locid + "location id is empty")
                }
            case .amenitiesCell:
                self.viewAllButtonAction()
            default: break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow(tableView: tableView, indexPath: indexPath, isForEstimateHeight: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow(tableView: tableView, indexPath: indexPath, isForEstimateHeight: false)
    }
    
    internal func heightForRow(tableView: UITableView, indexPath: IndexPath, isForEstimateHeight: Bool) -> CGFloat {
        if let hotelData = self.viewModel {
            let sectionData = self.sectionData[indexPath.section]
            if sectionData[indexPath.row] == .paymentPolicyCell  || sectionData[indexPath.row] == .checkOutCell{
                return CGFloat.leastNormalMagnitude
            } else if indexPath.section == 0, indexPath.row == 2 {
                    let text = hotelData.address + "\nMaps 1234"
                    let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
                    return size.height + 46.5
                        + 13  + 2.0 // y of textview 46.5 + bottom space 14.0 + 7.0
            } else if sectionData[indexPath.row] == .overViewCell{
                //overview cell
                if !isForEstimateHeight {
                    return UITableView.automaticDimension
                }
                    let textView = UITextView()
                    textView.frame.size = CGSize(width: UIDevice.screenWidth - 32.0, height: 100.0)
                    textView.font = AppFonts.Regular.withSize(18)
                    textView.text = hotelData.info
                    if textView.numberOfLines >= 3{
                        if let lineHeight = textView.font?.lineHeight{
                            return ((3 * lineHeight) + 62)
                        }
                    }else{
                    let text = hotelData.address + "Maps    "
                    let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
                    return size.height + 46.5
                        + 13.0  + 2.0//y of textview 46.5 + bottom space 14.0 + 7.0
                    }
            }
            
        }
        return isForEstimateHeight ? 100 : UITableView.automaticDimension
    }
}

extension HotelCheckoutDetailVC: GetFullInfoDelegate {
    func expandCell(expandHeight: CGFloat, indexPath: IndexPath) {
        if !allIndexPath.contains(indexPath) {
            self.allIndexPath.append(indexPath)
            self.hotelDetailsTableView.reloadData()
        } else {
            if let index = self.allIndexPath.firstIndex(of: indexPath){
                self.allIndexPath.remove(at: index)
            }
            self.hotelDetailsTableView.reloadData()
        }
        printDebug(indexPath)
    }
}

extension HotelCheckoutDetailVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        delegate?.addHotelInFevList()
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// Mark:- HotelDetailAmenitiesCellDelegate
//=======================================
extension HotelCheckoutDetailVC: HotelDetailAmenitiesCellDelegate {
    func viewAllButtonAction() {
        if let hotelData = self.viewModel {
            AppFlowManager.default.showHotelDetailAmenitiesVC(amenitiesGroups: hotelData.amenitiesGroups , amentites: hotelData.amenities, amenitiesGroupOrder: hotelData.amenities_group_order)
        }
    }
}

// Mark:- ScrollView Delegate
//==========================
extension HotelCheckoutDetailVC {
    private func manageHeaderView(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if (hotelImageHeight - headerView.height) < yOffset {
            // show
            self.headerView.navTitleLabel.text = self.hotelInfo?.hotelName
            self.headerView.animateBackView(isHidden: false, completion: nil)
            let selectedFevImage: UIImage = self.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "save_icon_green")
            self.headerView.leftButton.setImage(selectedFevImage, for: .normal)
            self.headerView.firstRightButton.setImage(#imageLiteral(resourceName: "black_cross"), for: .normal)
            self.headerView.firstRightButtonTrailingConstraint.constant = 0
            self.headerView.dividerView.isHidden = false
        } else {
            // hide
            self.headerView.navTitleLabel.text = ""
            self.headerView.animateBackView(isHidden: true, completion: nil)
            let buttonImage: UIImage = self.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
            self.headerView.leftButton.setImage(buttonImage, for: .normal)
            self.headerView.firstRightButton.setImage(#imageLiteral(resourceName: "CancelButtonWhite"), for: .normal)
            self.headerView.firstRightButtonTrailingConstraint.constant = -3
            self.headerView.dividerView.isHidden = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.manageHeaderView(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.manageHeaderView(scrollView)
    }
}

// Mark:- HotelDetailsImgSlideCellDelegate
//=======================================
extension HotelCheckoutDetailVC: HotelDetailsImgSlideCellDelegate, ImageDeletionDelegate {
    func hotelImageTapAction(at index: Int) {
        guard let data = self.viewModel, (data.atImageData.filter{$0.image != nil}).count != 0 else {return}
        let gVC = PhotoGalleryVC.instantiate(fromAppStoryboard: .Dashboard)
        gVC.parentVC = self
        if let images = self.viewModel?.photos {
            gVC.imageNames = images
            gVC.startShowingFrom = index
        }
        gVC.isTAAvailable = !(self.viewModel?.locid.isEmpty ?? true)
        gVC.hid = self.viewModel?.hid ?? ""
        self.present(gVC, animated: true, completion: nil)
    }
    
    func willShowImage(at index: Int, image: UIImage?) {
    }
    
    func shouldRemoveImage(_ image: UIImage?, for urlString: String?) {
        let str = urlString ?? ""
        let images = self.viewModel?.atImageData ?? []
        guard let index = images.firstIndex(where: {($0.imagePath ?? "") == str}) else {return}
        if let img = image{
            if self.viewModel?.atImageData.count != 0{
                self.viewModel?.atImageData[index].image = img
            }
        }
    }
    
}

// Mark:- ATGallery Delegate And Datasource
//========================================
extension HotelCheckoutDetailVC: ATGalleryViewDelegate, ATGalleryViewDatasource {
    func galleryViewWillClose(galleryView: ATGalleryViewController) {
    }
    
    func galleryViewDidClose(galleryView: ATGalleryViewController) {
    }
    
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

extension HotelCheckoutDetailVC: HotelRatingInfoCellDelegate {
    func shareButtonAction(_ sender: UIButton) {
//        if let parentVC = self.parent {
            AppGlobals.shared.shareWithActivityViewController(VC: self, shareData: "https://beta.aertrip.com")
//        }
    }
}
