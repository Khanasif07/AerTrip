//
//  HotelResultVC+HelperMethods.swift
//  AERTRIP
//
//  Created by apple on 18/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension HotelResultVC {
    func setUpFloatingView() {
        self.switchView.delegate = self
        self.unPinAllFavouriteButton.isHidden = true
        self.emailButton.isHidden = true
        self.shareButton.isHidden = true
    }
    
    func startProgress() {
        // Invalid timer if it is valid
        if self.timer?.isValid == true {
            self.timer?.invalidate()
        }
        
        self.time = 0.0
        self.progressView.setProgress(0.0, animated: false)
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
    }
    
    func getSavedFilter() {
        guard let filter = UserInfo.hotelFilter else {
            printDebug("filter not found")
            return
        }
        self.filterApplied = filter
    }
    
    func applyPreviousFilter() {
        AppToast.default.showToastMessage(message: LocalizedString.ApplyPreviousFilter.localized, onViewController: self, duration: 5.0, buttonTitle: LocalizedString.apply.localized, buttonImage: nil, buttonAction: self.completion)
    }
    
    func convertToMapView() {
        self.animateCollectionView(isHidden: false, animated: true)
    }
    
    func convertToListView() {
        self.animateCollectionView(isHidden: true, animated: true)
    }
    
    func getFavouriteHotels() {
        self.favouriteHotels = self.searchedHotels.filter { $0.fav == "1" }
        
        if let _ = UserInfo.loggedInUserId {
            self.manageSwitchContainer(isHidden: self.favouriteHotels.isEmpty)
        }
        else {
            self.manageSwitchContainer(isHidden: true)
        }
    }
    
    func getPinnedHotelTemplate() {
        if !self.favouriteHotels.isEmpty {
            self.viewModel.getPinnedTemplate(hotels: self.favouriteHotels)
        }
    }
    
    // MARK: Show progress
    
    @objc func setProgress() {
        self.time += 1.0
        self.progressView.setProgress(self.time / 10, animated: true)
        
        if self.time == 8 {
            self.timer?.invalidate()
            return
        }
        if self.time == 2 {
            self.timer!.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
            }
        }
        
        if self.time >= 10 {
            self.timer!.invalidate()
            delay(seconds: 0.8) {
                self.progressView.isHidden = true
            }
        }
    }
    
    func openSharingSheet() {
        let textToShare = [self.viewModel.shortUrl]
        let activityViewController =
            UIActivityViewController(activityItems: textToShare as [Any],
                                     applicationActivities: nil)
        UIApplication.shared.keyWindow?.tintColor = AppColors.themeGreen
        present(activityViewController, animated: true)
    }
    
    func removeAllFavouritesHotels() {
        self.viewModel.updateFavourite(forHotels: self.favouriteHotels, isUnpinHotels: true)
    }
    
    func expandGroup(_ hotels: [HotelSearched]) {
        if let topVC = UIApplication.topViewController() {
            let dataVC = HotelsGroupExpendedVC.instantiate(fromAppStoryboard: .HotelsSearch)
            self.hotelsGroupExpendedVC = dataVC
            dataVC.viewModel.samePlaceHotels = hotels
            let sheet = PKBottomSheet.instanceFromNib
            sheet.headerHeight = 24.0
            sheet.headerView = dataVC.headerView
            sheet.frame = topVC.view.bounds
            sheet.delegate = self
            topVC.view.addSubview(sheet)
            sheet.present(presentedViewController: dataVC, animated: true)
        }
    }
    
    func relocateSwitchButton(shouldMoveUp: Bool, animated: Bool) {
        let trans = shouldMoveUp ? CGAffineTransform.identity : CGAffineTransform(translationX: 0.0, y: 30.0)
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0) { [weak self] in
            self?.switchContainerView.transform = trans
            self?.view.layoutIfNeeded()
        }
    }
    
    func relocateCurrentLocationButton(shouldMoveUp: Bool, animated: Bool) {
        let trans = shouldMoveUp ? CGAffineTransform.identity : CGAffineTransform(translationX: 0.0, y: 30.0)
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0) { [weak self] in
            self?.currentLocationButton.transform = trans
            self?.view.layoutIfNeeded()
        }
    }
    
    func moveMapToCurrentCity() {
        if let loc = self.viewModel.searchedCityLocation {
            self.updateMarker(coordinates: loc)
        }
    }
    
    func getHotelsCount() {
        HotelFilterVM.shared.totalHotelCount = self.fetchedResultsController.fetchedObjects?.count ?? 0
        HotelFilterVM.shared.filterHotelCount = HotelFilterVM.shared.totalHotelCount
    }
    
    func setupTableHeader() {
        self.tableViewVertical.backgroundView = nil
        self.tableViewVertical.backgroundColor = AppColors.clear
        
        let shadowsHeight: CGFloat = 60.0
        
        let hView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: visibleMapHeightInVerticalMode))
        hView.backgroundColor = AppColors.clear
        
        let shadowView = UIView(frame: CGRect(x: 0.0, y: (hView.frame.height - shadowsHeight), width: UIDevice.screenWidth, height: shadowsHeight))
        shadowView.addGredient(colors: [AppColors.themeWhite.withAlphaComponent(0.01), AppColors.themeWhite])
        hView.addSubview(shadowView)
        
        self.tableViewVertical.tableHeaderView = hView
    }
    
    func setupNavigationTitleLabelText() {
        let checkIn = Date.getDateFromString(stringDate: viewModel.hotelSearchRequest?.requestParameters.checkIn ?? "", currentFormat: "yyyy-MM-dd", requiredFormat: "dd MMM") ?? ""
        let checkOut = Date.getDateFromString(stringDate: viewModel.hotelSearchRequest?.requestParameters.checkOut ?? " ", currentFormat: "yyyy-MM-dd", requiredFormat: "dd MMM") ?? ""
        let numberOfRoom = self.viewModel.hotelSearchRequest?.requestParameters.numOfRooms ?? ""
        self.descriptionLabel.text = "\(checkIn) - \(checkOut) • \(numberOfRoom) Rooms"
    }
    
    func reloadHotelList() {
        self.tableViewVertical.isHidden = true
        if let section = self.fetchedResultsController.sections, !section.isEmpty {
            self.tableViewVertical.isHidden = false
        }
        
        self.hotelSearchTableView.reloadData()
        
        if self.hoteResultViewType == .ListView {
            self.tableViewVertical.reloadData()
        }
        else {
            self.collectionView.reloadData()
        }
    }
    
    func searchForText(_ searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(self.performSearchForText(_:)), with: searchText, afterDelay: 0.5)
    }
    
    @objc private func performSearchForText(_ searchText: String) {
        self.searchHotels(forText: searchText)
    }
    
    private func searchHotels(forText: String) {
        self.fetchRequestType = .Searching
        printDebug("searching text is \(forText)")
        self.predicateStr = forText
        self.loadSaveData()
        self.reloadHotelList()
    }
    
    func hideButtons() {
        if self.hoteResultViewType == .ListView {
            self.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.emailButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.shareButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.unPinAllFavouriteButton.isHidden = true
            self.emailButton.isHidden = true
            self.shareButton.isHidden = true
        } else {
            self.floatingButtonOnMapView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.floatingButtonOnMapView.isHidden = true
        }
    }
    
    func manageSwitchContainer(isHidden: Bool) {
        if hoteResultViewType == .ListView {
            manageFloatingView(isHidden: isHidden)
            switchContainerView.isHidden = isHidden
            self.currentLocationButton.isHidden = hoteResultViewType == .ListView
        }
        else {
            manageFloatingView(isHidden: false)
            switchContainerView.isHidden = isHidden
            self.currentLocationButton.isHidden = false
        }
    }
    
    func manageFloatingView(isHidden: Bool) {
        self.floatingView.isHidden = isHidden
    }
    
    // MARK: - Manage Header animation
    
    func manageTopHeader(_ scrollView: UIScrollView) {
        guard scrollView === tableViewVertical else {
            return
        }
        
        let yPosition = scrollView.contentOffset.y
        if 20...30 ~= yPosition {
            // hide
            self.headerContainerViewTopConstraint.constant = -140
            self.tableViewTopConstraint.constant = 0
            self.mapContainerTopConstraint.constant = 0
            
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        } else if yPosition < 20 {
            // show
            self.headerContainerViewTopConstraint.constant = 0
            self.tableViewTopConstraint.constant = 100
            self.mapContainerTopConstraint.constant = 100
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func manageFloatingButtonOnPaginationScroll(_ scrollView: UIScrollView) {
        guard scrollView === collectionView else {
            return
        }
        
        let xPos = scrollView.contentOffset.x
        
        let fractional: CGFloat = xPos / UIDevice.screenWidth
        let decimal: CGFloat = floor(fractional)
        let progress = fractional - decimal
        
        let currentPoint = CGPoint(x: decimal * UIDevice.screenWidth, y: scrollView.contentOffset.y)
        guard 0.01...0.99 ~= progress else {
            if self.collectionView.indexPathForItem(at: currentPoint) != nil {
                // current grouped cell
                self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
            } else {
                // current normal cell
                self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
            }
            return
        }
        
        let nextPoint = CGPoint(x: (decimal + 1) * UIDevice.screenWidth, y: scrollView.contentOffset.y)
        let prevPoint = CGPoint(x: (decimal - 1) * UIDevice.screenWidth, y: scrollView.contentOffset.y)
        
        if xPos > self.oldScrollPosition.x {
            // forward
            printDebug("forward, \(fractional)")
            if self.collectionView.indexPathForItem(at: currentPoint) != nil {
                // current grouped cell
                if self.collectionView.indexPathForItem(at: nextPoint) != nil {
                    // next grouped cell
                    self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                    self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
                } else {
                    // next normal cell
                    if progress < 0.5 {
                        self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
                    } else {
                        self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                    }
                }
            } else {
                // current normal cell
                if self.collectionView.indexPathForItem(at: nextPoint) != nil {
                    // next grouped cell
                    if progress < 0.5 {
                        self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
                    } else {
                        self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                    }
                } else {
                    // next normal cell
                    self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                    self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
                }
            }
        } else {
            // backward
            printDebug("backward, \(fractional)")
            
            if self.collectionView.indexPathForItem(at: currentPoint) != nil {
                // current grouped cell
                if self.collectionView.indexPathForItem(at: prevPoint) != nil {
                    // prev grouped cell
                    self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                    self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
                } else {
                    // prev normal cell
                    if progress < 0.5 {
                        self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
                    } else {
                        self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                    }
                }
            } else {
                // current normal cell
                if self.collectionView.indexPathForItem(at: prevPoint) != nil {
                    // prev grouped cell
                    if progress < 0.5 {
                        self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
                    } else {
                        self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                    }
                } else {
                    // prev normal cell
                    self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                    self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
                }
            }
        }
        self.oldScrollPosition = scrollView.contentOffset
    }
    
    func manageMapViewOnScroll(_ scrollView: UIScrollView) {
        guard scrollView === self.tableViewVertical, let mView = self.mapView else {
            return
        }
        
        let yPosition = min(scrollView.contentOffset.y, visibleMapHeightInVerticalMode)
        
        mView.frame = CGRect(x: 0.0, y: -yPosition, width: mView.width, height: mView.height)
        mView.isHidden = scrollView.contentOffset.y > visibleMapHeightInVerticalMode
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.manageTopHeader(scrollView)
        self.manageMapViewOnScroll(scrollView)
        // self.manageFloatingButtonOnPaginationScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.manageTopHeader(scrollView)
        self.oldScrollPosition = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.manageTopHeader(scrollView)
    }
}
