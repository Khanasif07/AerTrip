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
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return !((fetchedResultsController.fetchedObjects ?? []).isEmpty)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        animateHeaderToMapView()
        //self.predicateStr = searchBar.text ?? ""
        self.fetchRequestType = .Searching
//        self.searchForText(searchBar.text ?? "")
//        self.loadSaveData()
        self.hotelSearchTableView.backgroundView = nil
        self.showSearchAnimation()
        self.reloadHotelList()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.fetchRequestType = .Searching
        if searchText.isEmpty {
            self.searchTextStr = ""
            
            self.fetchRequestType = .normalInSearching //for getting all the data in search mode when the search text is blank
            self.loadSaveData()
            self.searchForText("", shouldPerformAction: false) //cancel all the previous operation
            self.reloadHotelList()
            noResultemptyView.searchTextLabel.text = ""
        } else if searchText.count >= AppConstants.kSearchTextLimit {
            noResultemptyView.searchTextLabel.isHidden = false
            noResultemptyView.searchTextLabel.text = "for \(searchText.quoted)"
            self.searchTextStr = searchBar.text ?? ""
            self.searchForText(searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchedHotels.count > 0 {
            self.fetchRequestType = .normal
            if self.hoteResultViewType == .ListView {
                self.animateHeaderToListView()
            }
            else {
                self.animateHeaderToMapView()
            }
            self.hideSearchAnimation()
            self.view.endEditing(true)
            self.reloadHotelList()
        } else {
            return
        }
    }
}

// MARK: - ATSwitchedChangeValueDelegate methods

extension HotelResultVC: ATSwitcherChangeValueDelegate {
    func switcherDidChangeValue(switcher: ATSwitcher, value: Bool) {
        self.loadSaveData()
        if value {
            if self.hoteResultViewType == .MapView {
                self.floatingButtonOnMapView.isHidden = false
            } else {
                self.unPinAllFavouriteButton.isHidden = false
                self.emailButton.isHidden = false
                self.shareButton.isHidden = false
            }
            self.animateButton()
            self.getFavouriteHotels(shouldReloadData: false)
            self.viewModel.getPinnedTemplate(hotels: self.favouriteHotels)
        }
        else {
            self.hideFavsButtons()
        }
        
        if self.hoteResultViewType == .MapView {
            //if user in map view then update map focus as fav switch changed.
           // self.animateMapToFirstHotelInMapMode()
            delay(seconds: 0.4) { [weak self] in
                guard let strongSelf = self else {return}
                let indexOfMajorCell = strongSelf.indexOfMajorCell()
                strongSelf.manageForCollectionView(atIndex: indexOfMajorCell)
            }
        }
        else {
            //if user in list view then scroll the list till top as fav switch changed.
            if let data = self.fetchedResultsController.fetchedObjects,data.count  > 2 {
                delay(seconds: 0.1) { [weak self] in
                    self?.tableViewVertical.setContentOffset(CGPoint(x: 0.0, y: -3.0), animated: true)
                }
            }

            
            if let data = self.fetchedResultsController.fetchedObjects,data.count  < 2 {
                printDebug("inside tesing block")
                DispatchQueue.main.async {
                    self.tableViewVertical.setContentOffset(CGPoint(x: 0, y: -140), animated: false)
                }
                
                reloadHotelList()
            
            }
        }
    }
}

extension HotelResultVC: PKBottomSheetDelegate {
    func updateNavWhileInMapMode(isHidden: Bool) {
        UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
            self?.headerContatinerViewHeightConstraint.constant = isHidden ? 0.0 : 50.0
            self?.tableViewTopConstraint.constant = isHidden ? 0.0 : 50.0
            self?.mapContainerTopConstraint.constant = isHidden ? 0.0 : 50.0
            self?.progressView.isHidden = true
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
    func willGetAllHotel() {
        // will call hotel
    }
    
    func callShareTextSuccess() {
        printDebug("get the share text")
        let textToShare = [self.viewModel.shareText]
        let activityViewController =
            UIActivityViewController(activityItems: textToShare as [Any],
                                     applicationActivities: nil)
        UIApplication.shared.keyWindow?.tintColor = AppColors.themeGreen
        present(activityViewController, animated: true)
    }
    
    func callShareTextfail(errors: ErrorCodes) {
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
    }
    
    func getAllHotelsOnPreferenceSuccess() {
        self.fetchRequestType = .normal
        self.addMapView()
        self.setupTexts()
        self.viewModel.hotelListOnPreferenceResult()
    }
    
    func getAllHotelsOnPreferenceFail() {
        
    }
    
    func noHotelFound() {
        self.hotelSearchView.isHidden = false
        self.progressView?.removeFromSuperview()
        self.manageShimmer(isHidden: true)
        self.hotelSearchTableView.backgroundView = noHotelFoundEmptyView
    }
    
    func loadFinalDataOnScreen() {
        self.filterButton.isEnabled = true
        self.mapButton.isEnabled = true
        
        if let isUse = UserDefaults.getObject(forKey: "shouldApplyFormStars") as? Bool, isUse {
            delay(seconds: 1.0) { [weak self] in
                HotelFilterVM.shared.ratingCount = HotelsSearchVM.hotelFormData.ratingCount
                self?.doneButtonTapped()
            }
        }
        else {
            self.loadSaveData()
            self.getFavouriteHotels()
        }
        
        self.getPinnedHotelTemplate()
        self.time += 1
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
        self.updateMarkers()

        if UserInfo.hotelFilter != nil {
             self.getSavedFilter()
            // Apply previous filter
            self.applyPreviousFilter()
            
            // Apply Aerin Filter
           // self.applyAerinFilter()
           }
    }
    
    func getAllHotelsOnResultFallbackSuccess(_ isDone: Bool) {
        loadFinalDataOnScreen()
    }
    
    func getAllHotelsOnResultFallbackFail(errors: ErrorCodes) {
        self.noHotelFound()
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
    }
    
    
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
//        self.updateFavOnList(forIndexPath: self.selectedIndexPath)
    }

    func updateFavouriteSuccess() {
        self.getFavouriteHotels(shouldReloadData: true)//to manage the switch button and original hotel list (if no fav then load full list) after updating favs.
        if self.viewModel.isUnpinHotelTapped {
             self.reloadHotelList()
             self.viewModel.isUnpinHotelTapped = false
        } else {
//             self.updateFavOnList(forIndexPath: self.selectedIndexPath)
        }
    }

    func updateFavouriteFail(errors:ErrorCodes) {
        self.getFavouriteHotels(shouldReloadData: true)//to manage the switch button and original hotel list (if no fav then load full list) after updating favs.
//        self.updateFavOnList(forIndexPath: self.selectedIndexPath)
        if let _ = UserInfo.loggedInUser {
            if errors.contains(array: [-1]){
                if let _  = UserInfo.loggedInUser?.userId {
                    AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
                }
            } else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
            }
        }
    }

    func getAllHotelsListResultSuccess(_ isDone: Bool) {
        if !isDone {
            self.viewModel.hotelListOnPreferenceResult()
        } else {
            loadFinalDataOnScreen()
        }
    }

    func getAllHotelsListResultFail(errors: ErrorCodes) {
        if errors.contains(array: [37]) {
            self.viewModel.hotelListOnResultFallback()
        } else if errors.isEmpty {
            self.noHotelFound()
        }
    }
}

// MARK: - Hotel Card collection view Delegate methods

extension HotelResultVC: HotelCardCollectionViewCellDelegate {
    func saveButtonActionFromLocalStorage(_ sender: UIButton, forHotel: HotelSearched) {
        if let indexPath = self.collectionView.indexPath(forItem: sender) {
            self.selectedIndexPath = indexPath
        } else if let indexPath = self.tableViewVertical.indexPath(forItem: sender) {
             self.selectedIndexPath = indexPath
        }
        self.viewModel.getPinnedTemplate(hotels: self.favouriteHotels)
        self.viewModel.updateFavourite(forHotels: [forHotel], isUnpinHotels: false)
        // reload that item at particular indexPath
        if let indexPath = self.selectedIndexPath {
           self.updateFavOnList(forIndexPath: indexPath)
        }
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
        HotelFilterVM.shared.isSortingApplied = false
        UserInfo.hotelFilter = nil
        HotelFilterVM.shared.resetToDefault()
        self.loadSaveData()
        
        //manage switch button when clear all filters
        self.getFavouriteHotels(shouldReloadData: false)
    }

    func doneButtonTapped() {
        if let isUse = UserDefaults.getObject(forKey: "shouldApplyFormStars") as? Bool, isUse {
            UserInfo.hotelFilterApplied = UserInfo.hotelFilter
        }
        
        
        if HotelFilterVM.shared.isFilterApplied {
         HotelFilterVM.shared.saveDataToUserDefaults()
        }
        printDebug("done button tapped")
        self.getSavedFilter()
        self.loadSaveData()
        
        //manage switch button for the filttred data.
        if let _ = self.fetchedResultsController.fetchedObjects {
            if  let allFavs = CoreDataManager.shared.fetchData("HotelSearched", predicate: "fav == '1'")  as? [HotelSearched]  {
                 self.manageSwitchContainer(isHidden: allFavs.isEmpty, shouldOff: false)
            }
        }
        else {
            self.manageSwitchContainer(isHidden: true, shouldOff: false)
        }
        self.filterButton.isSelected =  !(HotelFilterVM.shared.isSortingApplied || self.isFilterApplied) ? false : true
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


// MARK: - Hotel Detail VC Delegate

extension HotelResultVC: HotelDetailsVCDelegate {
    func hotelFavouriteUpdated() {
        //work of this method has been handeled in data changed also, we can remove HotelDetailsVCDelegate after confirming with team.
    }
}


// MARK: - HotelGroupExpendedVCDelegate methods

extension HotelResultVC: HotelsGroupExpendedVCDelegate {
    func saveButtonActionFromLocalStorage(forHotel: HotelSearched) {
        self.viewModel.updateFavourite(forHotels: [forHotel], isUnpinHotels: false)
    }
}
