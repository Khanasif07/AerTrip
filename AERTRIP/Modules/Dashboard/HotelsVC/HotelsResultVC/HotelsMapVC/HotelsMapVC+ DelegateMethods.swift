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

extension HotelsMapVC: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true //!((viewModel.fetchedResultsController.fetchedObjects ?? []).isEmpty)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        animateHeaderToMapView()
        //self.predicateStr = searchBar.text ?? ""
        self.viewModel.fetchRequestType = .Searching
        //        self.searchForText(searchBar.text ?? "")
        //        self.loadSaveData()
        self.hotelSearchTableView.backgroundView = nil
        self.showSearchAnimation()
        self.reloadHotelList()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.fetchRequestType = .Searching
        if searchText.isEmpty {
            self.viewModel.searchTextStr = ""
            
            self.viewModel.fetchRequestType = self.filterButton.isSelected ? .FilterApplied : .normalInSearching //for getting all the data in search mode when the search text is blank
            self.viewModel.loadSaveData()
            self.searchForText("", shouldPerformAction: false) //cancel all the previous operation
            self.reloadHotelList()
            noResultemptyView.searchTextLabel.text = ""
        } else if searchText.count >= AppConstants.kSearchTextLimit {
            noResultemptyView.searchTextLabel.isHidden = false
            noResultemptyView.searchTextLabel.text = "for \(searchText.quoted)"
            self.viewModel.searchTextStr = searchBar.text ?? ""
            self.searchForText(searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
//        if viewModel.searchedHotels.count > 0 {
//            self.viewModel.fetchRequestType = .normal
//            self.animateHeaderToMapView()
//            self.hideSearchAnimation()
//            self.view.endEditing(true)
//            self.reloadHotelList()
//        } else {
//            return
//        }
    }
}

// MARK: - ATSwitchedChangeValueDelegate methods

extension HotelsMapVC: ATSwitcherChangeValueDelegate {
    func switcherDidChangeValue(switcher: ATSwitcher, value: Bool) {
        self.viewModel.isFavouriteOn = value
        self.viewModel.loadSaveData()
        if value {
                self.floatingButtonOnMapView.isHidden = false
            self.animateButton()
            // nitin self.getFavouriteHotels(shouldReloadData: false)
            //self.viewModel.getPinnedTemplate(hotels: self.favouriteHotels)
        }
        else {
            self.hideFavsButtons()
        }
        //self.updateMarkers()
            //if user in map view then update map focus as fav switch changed.
            delay(seconds: 0.4) { [weak self] in
                guard let strongSelf = self else {return}
                //                let indexOfMajorCell = strongSelf.indexOfMajorCell()
                //                strongSelf.manageForCollectionView(atIndex: indexOfMajorCell)
                strongSelf.animateMapToFirstHotelInMapMode()
                
            }
    }
}

extension HotelsMapVC: PKBottomSheetDelegate {
    func updateNavWhileInMapMode(isHidden: Bool) {
        UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
//            self?.headerContatinerViewHeightConstraint.constant = isHidden ? 0.0 : 50.0
//            self?.tableViewTopConstraint.constant = isHidden ? 0.0 : 50.0
//            self?.mapContainerTopConstraint.constant = isHidden ? 0.0 : 50.0
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

extension HotelsMapVC: HotelResultDelegate {
    func updateFavouriteAndFilterView() {
        // do nothing for map view
    }
    
    func deleteRow(index: IndexPath) {
        
    }
    
    func updateFavOnList() {
        updateFavOnList(forIndexPath: self.selectedIndexPath)
    }
    
    func reloadHotelList(isUpdatingFav: Bool) {
        reloadHotelList(isUpdatingFav: isUpdatingFav, drawMarkers: true)
    }
    
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
        self.viewModel.fetchRequestType = .normal
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
        self.hotelsMapCV.delegate = self
        self.hotelsMapCV.dataSource = self
        self.filterButton.isEnabled = true
        self.addMapView()
        self.reloadHotelList()
        delay(seconds: 0.4) { [weak self] in
            self?.adjustMapPadding()
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
        AppGlobals.shared.startLoading()
    }
    
    func getPinnedTemplateSuccess() {
        AppGlobals.shared.stopLoading()
    }
    
    func getPinnedTemplateFail() {
        AppGlobals.shared.stopLoading()
    }
    
    func willUpdateFavourite() {
        //
        //        self.updateFavOnList(forIndexPath: self.selectedIndexPath)
    }
    
    func updateFavouriteSuccess(isHotelFavourite: Bool) {
        if self.switchView.isOn, !isHotelFavourite  {
            //self.loadSaveData()
            if let indexPath = self.selectedIndexPath, self.viewModel.collectionViewLocArr.indices.contains(indexPath.item),let hData = self.viewModel.collectionViewList[self.viewModel.collectionViewLocArr[indexPath.item]] as? [HotelSearched], let hotel = hData.first  {
                let locStr = self.viewModel.collectionViewLocArr[indexPath.item]
                self.viewModel.deleteHotelsDataForCollectionView(hotel: hotel)
                self.hotelsMapCV.reloadData()
                if let loc = self.getLocationObject(fromLocation: locStr) {
                    self.deleteMarker(atLocation: loc)
                    if let selectedLocation = self.displayingHotelLocation, selectedLocation == loc {
                        self.displayingHotelLocation = nil
                    }
                }
            }
            self.viewModel.getFavouriteHotels(shouldReloadData: true)
        } else {
            self.viewModel.getFavouriteHotels(shouldReloadData: false)//to manage the switch button and original hotel list (if no fav then load full list) after updating favs.
        }
        if self.viewModel.isUnpinHotelTapped {
            self.reloadHotelList()
            self.viewModel.isUnpinHotelTapped = false
        } else {
            self.updateFavOnList(forIndexPath: self.selectedIndexPath)
        }
        self.showHotelOnMap(duration: 0.4)
        
    }
    
    func updateFavouriteFail(errors: ErrorCodes, isHotelFavourite: Bool) {
        if self.switchView.isOn, !isHotelFavourite  {
            //self.loadSaveData()
            if let indexPath = self.selectedIndexPath, self.viewModel.collectionViewLocArr.indices.contains(indexPath.item),let hData = self.viewModel.collectionViewList[self.viewModel.collectionViewLocArr[indexPath.item]] as? [HotelSearched], let hotel = hData.first  {
                let locStr = self.viewModel.collectionViewLocArr[indexPath.item]
                self.viewModel.deleteHotelsDataForCollectionView(hotel: hotel)
                self.hotelsMapCV.reloadData()
                if let loc = self.getLocationObject(fromLocation: locStr) {
                    self.deleteMarker(atLocation: loc)
                    if let selectedLocation = self.displayingHotelLocation, selectedLocation == loc {
                        self.displayingHotelLocation = nil
                    }
                }
            }
            self.viewModel.getFavouriteHotels(shouldReloadData: true)
        }else {
            self.viewModel.getFavouriteHotels(shouldReloadData: false)//to manage the switch button and original hotel list (if no fav then load full list) after updating favs.
            self.updateFavOnList(forIndexPath: self.selectedIndexPath)
        }
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
        
        self.showHotelOnMap(duration: 0.4)
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

extension HotelsMapVC: HotelCardCollectionViewCellDelegate {
    func saveButtonActionFromLocalStorage(_ sender: UIButton, forHotel: HotelSearched) {
        guard AppGlobals.shared.isNetworkRechable(showMessage: true) else {return}
        if let indexPath = self.hotelsMapCV.indexPath(forItem: sender) {
            self.selectedIndexPath = indexPath
            hotelsMapCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        //self.viewModel.getPinnedTemplate(hotels: self.favouriteHotels)
        self.viewModel.updateFavourite(forHotels: [forHotel], isUnpinHotels: false)
        // reload that item at particular indexPath
        if self.selectedIndexPath != nil {
            // self.updateFavOnList(forIndexPath: indexPath)
        }
        
    }
    
    func saveButtonAction(_ sender: UIButton, forHotel: HotelsModel) {
        //
    }
    
    func pagingScrollEnable(_ indexPath: IndexPath, _ scrollView: UIScrollView) {
        printDebug("Hotel page scroll delegate ")
        
        
    }
}

// MARK: - Section Footer Delgate methods

extension HotelsMapVC: SectionFooterDelegate {
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

extension HotelsMapVC: HotelFilteVCDelegate {
    func clearAllButtonTapped() {
        self.viewModel.fetchRequestType = .normal
        self.filterButton.isSelected = false
        self.viewModel.isFilterApplied = false
        HotelFilterVM.shared.isSortingApplied = false
        UserInfo.hotelFilter = nil
        HotelFilterVM.shared.resetToDefault()
        self.viewModel.loadSaveData()
        
        //manage switch button when clear all filters
        // nitin self.getFavouriteHotels(shouldReloadData: false)
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
        self.viewModel.loadSaveData()
        // nitin self.getFavouriteHotels()
        
        //manage switch button for the filttred data.
        if let _ = self.viewModel.fetchedResultsController.fetchedObjects {
            if  let allFavs = CoreDataManager.shared.fetchData("HotelSearched", predicate: "fav == '1'")  as? [HotelSearched]  {
                self.manageSwitchContainer(isHidden: allFavs.isEmpty, shouldOff: false)
            }
        }
        else {
            self.manageSwitchContainer(isHidden: true, shouldOff: false)
        }
        self.filterButton.isSelected =  !(HotelFilterVM.shared.isSortingApplied || self.viewModel.isFilterApplied) ? false : true
    }
}

// MARK: - CL Location manager Delegate

extension HotelsMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        printDebug("location \(String(describing: locations.last))")
        self.currentLocation = locations.last
        self.addMapView()
    }
}


// MARK: - Hotel Detail VC Delegate

extension HotelsMapVC: HotelDetailsVCDelegate {
    func hotelFavouriteUpdated() {
        //work of this method has been handeled in data changed also, we can remove HotelDetailsVCDelegate after confirming with team.
    }
}


// MARK: - HotelGroupExpendedVCDelegate methods

extension HotelsMapVC: HotelsGroupExpendedVCDelegate {
    func saveButtonActionFromLocalStorage(forHotel: HotelSearched) {
        self.viewModel.updateFavourite(forHotels: [forHotel], isUnpinHotels: false)
    }
}
