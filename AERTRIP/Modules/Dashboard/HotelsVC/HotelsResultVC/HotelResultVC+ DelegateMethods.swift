//
//  HotelResultVC+ DelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 04/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Search bar delegate methods

extension HotelResultVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        animateHeaderToMapView()
        self.predicateStr = searchBar.text ?? ""
        self.fetchRequestType = .Searching
        self.loadSaveData()
        self.hotelSearchTableView.backgroundView = nil
        self.showSearchAnimation()
        self.reloadHotelList()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.fetchRequestType = .Searching
        if searchText.isEmpty {
            self.predicateStr = ""
            self.loadSaveData()
            self.searchForText(searchText)
            self.reloadHotelList()
        } else if searchText.count >= AppConstants.kSearchTextLimit {
            noResultemptyView.searchTextLabel.isHidden = false
            noResultemptyView.searchTextLabel.text = "for \(searchText.quoted)"
            self.searchForText(searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.fetchRequestType = .normal
        self.animateHeaderToListView()
        self.hideSearchAnimation()
        self.view.endEditing(true)
        self.reloadHotelList()
    }
}

// MARK: - Hotel Search View Delegate methods

extension HotelResultVC: ATSwitcherChangeValueDelegate {
    func switcherDidChangeValue(switcher: ATSwitcher, value: Bool) {
        if value {
            if self.hoteResultViewType == .MapView {
                self.floatingButtonOnMapView.isHidden = false
            } else {
                self.unPinAllFavouriteButton.isHidden = false
                self.emailButton.isHidden = false
                self.shareButton.isHidden = false
            }
            self.animateButton()
        } else {
            self.hideButtons()
        }
    }
}

extension HotelResultVC: PKBottomSheetDelegate {
    func updateNavWhileInMapMode(isHidden: Bool) {
        UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
            self?.headerContatinerViewHeightConstraint.constant = isHidden ? 0.0 : 50.0
            self?.tableViewTopConstraint.constant = isHidden ? 0.0 : 50.0
            self?.mapContainerTopConstraint.constant = isHidden ? 0.0 : 50.0
            self?.progressView.isHidden = isHidden
            self?.view.layoutIfNeeded()
        }
    }

    func willShow(_ sheet: PKBottomSheet) {
        self.updateNavWhileInMapMode(isHidden: true)
    }

    func willHide(_ sheet: PKBottomSheet) {
        self.updateNavWhileInMapMode(isHidden: false)
        self.hotelsGroupExpendedVC?.animateCardsToClose()
    }
}

// MARK: - HotelResultVM Delegate methods

extension HotelResultVC: HotelResultDelegate {
    func willGetPinnedTemplate() {
        //
    }

    func getPinnedTemplateSuccess() {
        //
    }

    func getPinnedTemplateFail() {
        //
    }

    func willUpdateFavourite() {
        //
    }

    func updateFavouriteSuccess() {
        self.reloadHotelList()
    }

    func updateFavouriteFail() {
        //
    }

    func getAllHotelsListResultSuccess(_ isDone: Bool) {
        if !isDone {
            self.viewModel.hotelListOnPreferenceResult()
        } else {
            self.loadSaveData()
            self.getPinnedHotelTemplate()
            self.time += 1
            self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
            self.updateMarkers()
            if UserInfo.hotelFilter != nil {
                self.applyPreviousFilter()
                self.fetchRequestType = .FilterApplied
                self.getSavedFilter()
            }
        }
    }

    func getAllHotelsListResultFail(errors: ErrorCodes) {
        self.progressView.removeFromSuperview()
        self.shimmerView.removeFromSuperview()
        self.manageFloatingView(isHidden: true)
        self.hotelSearchTableView.backgroundView = noHotelFoundEmptyView
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
    }
}

// MARK: - Hotel Card collection view Delegate methods

extension HotelResultVC: HotelCardCollectionViewCellDelegate {
    func saveButtonActionFromLocalStorage(_ sender: UIButton, forHotel: HotelSearched) {
        self.viewModel.updateFavourite(forHotels: [forHotel], isUnpinHotels: false)
    }

    func saveButtonAction(_ sender: UIButton, forHotel: HotelsModel) {
        //
    }

    func pagingScrollEnable(_ indexPath: IndexPath, _ scrollView: UIScrollView) {
        printDebug("Hotel page scroll delegate ")

        if let cell = tableViewVertical.cellForRow(at: indexPath) as? HotelCardTableViewCell {
            cell.pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
        }
    }
}

// MARK: - Section Footer Delgate methods

extension HotelResultVC: SectionFooterDelegate {
    func showHotelBeyond() {
        if self.isAboveTwentyKm {
            printDebug("hide hotel beyond ")
            self.isAboveTwentyKm = false
            //  self.hideSection = 1
            // self.footeSection = 2
            self.reloadHotelList()
        } else {
            printDebug("show hotel beyond ")
            self.isAboveTwentyKm = true
            // self.hideSection = 0
            // self.footeSection = 1
            self.reloadHotelList()
        }
    }
}

// MARK: - Hotel filter Delegate methods

extension HotelResultVC: HotelFilteVCDelegate {
    func clearAllButtonTapped() {
        self.fetchRequestType = .normal
        self.filterButton.isSelected = false
        UserInfo.hotelFilter = nil
        self.loadSaveData()
    }

    func doneButtonTapped() {
        self.fetchRequestType = .FilterApplied
        HotelFilterVM.shared.saveDataToUserDefaults()
        printDebug("done button tapped")
        self.filterButton.isSelected = true
        self.getSavedFilter()
        self.loadSaveData()
    }
}

// MARK: - CL Location manager Delegate

extension HotelResultVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        printDebug("location \(String(describing: locations.last))")
        self.currentLocation = locations.last
        self.addMapView()
    }
}
