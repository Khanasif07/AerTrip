//
//  HotelResultVC+ DelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 04/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManager

// MARK: - Search bar delegate methods

extension HotelResultVC: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        return true//!((viewModel.fetchedResultsController.fetchedObjects ?? []).isEmpty)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
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
                    self.searchResultHeaderView.updateHeight(height: CGFloat.leastNormalMagnitude)
                    self.tableViewVertical.sectionHeaderHeight = CGFloat.leastNormalMagnitude
            searchResultHeaderView.configureView(searhText: "")
            self.viewModel.searchTextStr = ""
            
            self.viewModel.fetchRequestType = self.filterButton.isSelected ? .FilterApplied : .normalInSearching //for getting all the data in search mode when the search text is blank
            self.viewModel.loadSaveData()
            self.searchForText("", shouldPerformAction: false) //cancel all the previous operation
            self.reloadHotelList()
            noResultemptyView.searchTextLabel.text = ""
            noResultemptyViewVerticalTableView.searchTextLabel.text = ""
        } else { //else if searchText.count >= AppConstants.kSearchTextLimit {
//            self.searchResultHeaderView.updateHeight(height: HotelSearchResultHeaderViewHeight)
            self.tableViewVertical.sectionHeaderHeight = HotelSearchResultHeaderViewHeight
            noResultemptyView.searchTextLabel.isHidden = false
            noResultemptyView.searchTextLabel.text = "for \(searchText.quoted)"
            noResultemptyViewVerticalTableView.searchTextLabel.isHidden = false
            noResultemptyViewVerticalTableView.searchTextLabel.text = "for \(searchText.quoted)"
            self.viewModel.searchTextStr = searchBar.text ?? ""
            searchResultHeaderView.configureView(searhText: searchText)
            self.searchForText(searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        //        if viewModel.searchedHotels.count > 0 {
        //            self.viewModel.fetchRequestType = .normal
        //            self.hideSearchAnimation()
        //            self.view.endEditing(true)
        //            self.reloadHotelList()
        //        } else {
        //            return
        //        }
        self.searchResultHeaderView.updateHeight(height: HotelSearchResultHeaderViewHeight)
        self.hideSearchAnimation()
        self.reloadHotelList()
    }
}

// MARK: - ATSwitchedChangeValueDelegate methods

extension HotelResultVC: ATSwitcherChangeValueDelegate {
    func switcherDidChangeValue(switcher: ATSwitcher, value: Bool) {
        self.viewModel.isFavouriteOn = value
        self.viewModel.loadSaveData()
        if value {
            
            self.unPinAllFavouriteButton.isHidden = false
            self.emailButton.isHidden = false
            self.shareButton.isHidden = false
            self.animateButton()
            // nitin self.getFavouriteHotels(shouldReloadData: false)
            //self.viewModel.getPinnedTemplate(hotels: self.favouriteHotels)
        }
        else {
            self.hideFavsButtons(isAnimated: true)
        }
        
        tableViewVertical.setContentOffset(CGPoint(x: 0, y: -topContentSpace), animated: false)
        showBluredHeaderViewCompleted()
    }
}

extension HotelResultVC: PKBottomSheetDelegate {
    func updateNavWhileInMapMode(isHidden: Bool) {
        UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
            self?.headerContatinerViewHeightConstraint.constant = isHidden ? 0.0 : 50.0
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

extension HotelResultVC: HotelResultDelegate {
    
    func updateFavouriteAndFilterView() {
        self.unPinAllFavouriteButton.isHidden = !self.viewModel.isFavouriteOn
        self.emailButton.isHidden = !self.viewModel.isFavouriteOn
        self.shareButton.isHidden = !self.viewModel.isFavouriteOn
        self.animateFloatingButtonOnListView(isAnimated: false)
        self.filterButton.isSelected = self.viewModel.isFilterApplied
        self.switchContainerView.isHidden = self.viewModel.favouriteHotels.isEmpty
        self.floatingButtonOnMapView.isHidden = true//!self.viewModel.isFavouriteOn
        self.switchView.isOn = self.viewModel.isFavouriteOn
        if self.viewModel.searchTextStr.isEmpty {
            self.searchBar.text = ""
            self.searchResultHeaderView.updateHeight(height: CGFloat.leastNormalMagnitude)
            self.tableViewVertical.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        }
        self.tableViewVertical.reloadData()
        self.filterCollectionView.reloadData()
    }
    
    func updateFavOnList() {
        updateFavOnList(forIndexPath: self.selectedIndexPath)
    }
    
    func deleteRow(index: IndexPath) {
        tableViewVertical.deleteRows(at: [index], with: .fade)
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
        self.searchButton.isUserInteractionEnabled = false
    }
    
    func loadFinalDataOnScreen() {
        self.isDataFetched = true
        self.filterCollectionView.isUserInteractionEnabled = true
        //        self.filterButton.isEnabled = true
        //        self.mapButton.isEnabled = true
        //        self.searchButton.isEnabled = true
        self.filterButton.isUserInteractionEnabled = true
        self.mapButton.isUserInteractionEnabled = true
        self.searchButton.isUserInteractionEnabled = true
        
        var ignorePreviousFilter = false
        if self.viewModel.searchedFormData.destType == "Hotel" || self.viewModel.searchedFormData.destType == "POI" || self.viewModel.searchedFormData.destType == "Area" ||
            self.viewModel.searchedFormData.isHotelNearMeSelected {
            self.viewModel.fetchRequestType = .FilterApplied
            self.viewModel.filterApplied.sortUsing = .DistanceNearestFirst(ascending: true)
            HotelFilterVM.shared.sortUsing = .DistanceNearestFirst(ascending: true)
            HotelFilterVM.shared.isFilterAppliedForDestinetionFlow = true
            ignorePreviousFilter = true
        } else {
            if HotelFilterVM.shared.isFilterAppliedForDestinetionFlow {
                UserInfo.hotelFilter = nil
                HotelFilterVM.shared.resetToDefault()
            }
            HotelFilterVM.shared.sortUsing = .BestSellers
            HotelFilterVM.shared.isFilterAppliedForDestinetionFlow = false
            if let filter = UserInfo.hotelFilter {
                self.viewModel.tempHotelFilter = filter
            }
            UserInfo.hotelFilter = nil
            HotelFilterVM.shared.resetToDefault()
            self.filterCollectionView.reloadData()
        }
        
        if let isUse = UserDefaults.getObject(forKey: "shouldApplyFormStars") as? Bool, isUse {
            delay(seconds: 1.0) { [weak self] in
                HotelFilterVM.shared.ratingCount = HotelsSearchVM.hotelFormData.ratingCount
                self?.doneButtonTapped()
            }
        }
        else {
            self.viewModel.loadSaveData()
            // nitin  self.getFavouriteHotels()
        }
        
        self.time += 1
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
        //self.updateMarkers()
        
        if self.viewModel.tempHotelFilter != nil, !ignorePreviousFilter {
         //   self.getSavedFilter()
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
       // AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
    }
    
    
    func willGetPinnedTemplate() {
       // AppGlobals.shared.startLoading()
        self.emailButton.setImage(nil, for: .normal)
    }
    
    func getPinnedTemplateSuccess() {
      //  AppGlobals.shared.stopLoading()
        self.emailButton.setImage(#imageLiteral(resourceName: "emailIcon"), for: .normal)
    }
    
    func getPinnedTemplateFail() {
      //  AppGlobals.shared.stopLoading()
        self.emailButton.setImage(#imageLiteral(resourceName: "emailIcon"), for: .normal)
    }
    
    func willUpdateFavourite() {
        //
        //        self.updateFavOnList(forIndexPath: self.selectedIndexPath)
    }
    
    func updateFavouriteSuccess(isHotelFavourite: Bool) {
        if self.switchView.isOn, !isHotelFavourite  {
            self.viewModel.loadSaveData()
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
        self.switchView.isOn = self.viewModel.isFavouriteOn
    }
    
    func updateFavouriteFail(errors: ErrorCodes, isHotelFavourite: Bool) {
        if self.switchView.isOn, !isHotelFavourite  {
            self.viewModel.loadSaveData()
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
        
        self.switchView.isOn = self.viewModel.isFavouriteOn
    }
    
    func getAllHotelsListResultSuccess(_ isDone: Bool) {
        if !isDone {
            self.viewModel.hotelListOnPreferenceResult()
        } else {
            loadFinalDataOnScreen()
        }
        
        if let recentSearchFilter = viewModel.getConvertedRecentSearchFilter() {
            self.applyButtonTapped = true
            UserDefaults.setObject(false, forKey: "shouldApplyFormStars")
            self.viewModel.fetchRequestType = .FilterApplied
            HotelFilterVM.shared.setData(from: recentSearchFilter)
            self.doneButtonTapped()
        }
    }
    
    func getAllHotelsListResultFail(errors: ErrorCodes) {
        if errors.contains(array: [37]) {
            self.viewModel.hotelListOnResultFallback()
        } else if errors.contains(ATErrorManager.LocalError.requestTimeOut.rawValue) {
            self.noHotelFound()
        } else if errors.isEmpty {
            self.noHotelFound()
        }
    }
}

// MARK: - Hotel Card collection view Delegate methods

extension HotelResultVC: HotelCardCollectionViewCellDelegate {
    func saveButtonActionFromLocalStorage(_ sender: UIButton, forHotel: HotelSearched) {
        guard AppGlobals.shared.isNetworkRechable(showMessage: true) else {return}
        if let indexPath = self.tableViewVertical.indexPath(forItem: sender) {
            self.selectedIndexPath = indexPath
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
    func collectionViewContentOffset(offsetX: CGFloat) {
        self.filterCollectionView.setContentOffset(CGPoint(x: offsetX + abs(self.filterCollectionView.contentInset.left), y: 0), animated: true)
    }
    
    func clearAllButtonTapped() {
        self.filterCollectionView.scrollToItem(at: IndexPath(item: HotelFilterVM.shared.lastSelectedIndex, section: 0), at: .centeredHorizontally, animated: false)
        self.viewModel.fetchRequestType = .normal
        self.filterButton.isSelected = false
        self.viewModel.isFilterApplied = false
        HotelFilterVM.shared.isSortingApplied = false
        let isFilterAppliedForDestinetionFlow = HotelFilterVM.shared.isFilterAppliedForDestinetionFlow
        UserInfo.hotelFilter = nil
        HotelFilterVM.shared.resetToDefault()
        self.viewModel.filterApplied = UserInfo.HotelFilter()
        if isFilterAppliedForDestinetionFlow {
            self.viewModel.fetchRequestType = .FilterApplied
            self.viewModel.isFilterApplied = true
            self.viewModel.filterApplied.sortUsing = .DistanceNearestFirst(ascending: true)
            HotelFilterVM.shared.sortUsing = .DistanceNearestFirst(ascending: true)
            HotelFilterVM.shared.isFilterAppliedForDestinetionFlow = true
            HotelFilterVM.shared.saveDataToUserDefaults()
            //self.getSavedFilter()
        }
        self.viewModel.loadSaveData()
        self.filterCollectionView.reloadData()
        //manage switch button when clear all filters
        // nitin self.getFavouriteHotels(shouldReloadData: false)
        viewModel.updateRecentSearch()
    }
    
    func doneButtonTapped() {
        self.filterCollectionView.scrollToItem(at: IndexPath(item: HotelFilterVM.shared.lastSelectedIndex, section: 0), at: .centeredHorizontally, animated: false)
        
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
        // self.filterButton.isSelected =  !(HotelFilterVM.shared.isSortingApplied || self.viewModel.isFilterApplied) ? false : true
        self.filterButton.isSelected = HotelFilterVM.shared.isFilterApplied
        self.filterCollectionView.reloadData()
        
        viewModel.updateRecentSearch()
    }
}





// MARK: - Hotel Detail VC Delegate

extension HotelResultVC: HotelDetailsVCDelegate {
    func hotelFavouriteUpdated() {
        //work of this method has been handeled in data changed also, we can remove HotelDetailsVCDelegate after confirming with team.
    }
    
    func imageUpdated() {
        if let indexPath = self.selectedIndexPath {
            self.tableViewVertical.reloadRow(at: indexPath, with: .none)
        }
    }
}


// MARK: - HotelGroupExpendedVCDelegate methods

extension HotelResultVC: HotelsGroupExpendedVCDelegate {
    func saveButtonActionFromLocalStorage(forHotel: HotelSearched) {
        self.viewModel.updateFavourite(forHotels: [forHotel], isUnpinHotels: false)
    }
}

// MARK: - HotelSearchResultHeaderViewDelegate methods
extension HotelResultVC: HotelSearchResultHeaderViewDelegate {
    func clearSearchView() {
        //        self.searchResultHeaderView.updateHeight(height: CGFloat.leastNormalMagnitude)
        //        self.tableViewVertical.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        //        self.searchResultHeaderView.configureView(searhText: "")
        //        self.viewModel.searchTextStr = ""
        //        self.searchBar.text = ""
        //        self.viewModel.fetchRequestType = self.filterButton.isSelected ? .FilterApplied : .normalInSearching //for getting all the data in search mode when the search text is blank
        //        self.viewModel.loadSaveData()
        //        self.searchForText("", shouldPerformAction: false) //cancel all the previous operation
        //        self.reloadHotelList()
        //        noResultemptyView.searchTextLabel.text = ""
        //        noResultemptyViewVerticalTableView.searchTextLabel.text = ""
        //self.searchBar.becomeFirstResponder()
        
        
        self.cancelButtonTapped(self.cancelButton)
    }
}
// MARK: - EmptyScreenViewDelegate methods
extension HotelResultVC: EmptyScreenViewDelegate {
    func firstButtonAction(sender: ATButton) {
    }
    
    func bottomButtonAction(sender: UIButton) {
        self.clearAllButtonTapped()
    }
}
