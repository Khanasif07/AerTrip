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
            HotelFilterVM.shared.resetToDefault()
            return
        }
        self.filterApplied = filter
    }
    
    func applyPreviousFilter() {
        let starStar = self.getStarString(fromArr: self.filterApplied.ratingCount, maxCount: 5)
        
        let distanceStr = self.filterApplied.distanceRange > 20 ? "beyond \(self.filterApplied.distanceRange.toInt) " : " within \(self.filterApplied.distanceRange.toInt) "
        
        let finalStr = LocalizedString.ApplyPreviousFilter.localized + starStar + distanceStr.appending(LocalizedString.Kms.localized) + AppConstants.kEllipses
        
        AppToast.default.showToastMessage(message: finalStr, onViewController: self, duration: 5.0, buttonTitle: LocalizedString.apply.localized, buttonImage: nil, buttonAction: self.completion, toastDidClose: self.toastDidClose)

    }
    
    func convertToMapView() {
        self.animateCollectionView(isHidden: false, animated: true)
    }
    
    func convertToListView() {
        self.animateCollectionView(isHidden: true, animated: true)
    }
    
    func getFavouriteHotels(shouldReloadData: Bool = false) {
        if let allFavs = CoreDataManager.shared.fetchData("HotelSearched", predicate: "fav == '1'")  as? [HotelSearched] {
            self.isLoadingListAfterUpdatingAllFav = false
            self.manageSwitchContainer(isHidden: allFavs.isEmpty)
            self.favouriteHotels = allFavs
            
            if shouldReloadData {
                //using shouldReloadData for breaking the func calling cycle from numberOfRows
                //load data after hiding/closing the switch button
                if allFavs.isEmpty {
                    delay(seconds: 0.3) { [weak self] in
                        self?.loadSaveData()
                    }
                }
                else {
                    self.updateFavOnList(forIndexPath: self.selectedIndexPath)
                }
            }
        }
        else if !isLoadingListAfterUpdatingAllFav {
            self.fetchRequestType = .normal
            self.isLoadingListAfterUpdatingAllFav = true
            self.loadSaveData()
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
        self.switchView.setOn(isOn: false)
        self.manageSwitchContainer(isHidden: true)
        self.viewModel.isUnpinHotelTapped = true
        self.selectedIndexPath = nil
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
    
    func updateFavOnList(forIndexPath: IndexPath?) {
        //update the current opened list as user make fav/unfav
        if let indexPath = forIndexPath {
            if self.fetchRequestType == .Searching {
                self.hotelSearchTableView.reloadRow(at: indexPath, with: .automatic)
            }
            else {
                if self.hoteResultViewType == .ListView {
                    self.tableViewVertical.reloadRow(at: indexPath, with: .automatic)
                }
                else if self.hoteResultViewType == .MapView {
                    self.collectionView.reloadItems(at: indexPath)
                }
            }
            selectedIndexPath = nil
        }
        else {
            if self.fetchRequestType == .Searching {
                self.hotelSearchTableView.reloadData()
            }
            else {
                if self.hoteResultViewType == .ListView {
                    self.fetchDataFromCoreData(isUpdatingFav: true)
                    self.tableViewVertical.reloadData()
                }
                else if self.hoteResultViewType == .MapView {
                    self.fetchDataFromCoreData(isUpdatingFav: true)
                    self.collectionView.reloadData()
                }
            }
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
            self.focusMarker(coordinates: loc)
        }
    }
    
    func animateMapToFirstHotelInMapMode() {
        if let locStr = self.viewModel.collectionViewList.keys.first, let loc = self.getLocationObject(fromLocation: locStr) {
            self.focusMarker(coordinates: loc)
        }
    }
    
    func getHotelsCount() {
        HotelFilterVM.shared.filterHotelCount = self.fetchedResultsController.fetchedObjects?.count ?? 0
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
        
        self.titleLabel.text = self.viewModel.searchedFormData.cityName
        let checkIn = Date.getDateFromString(stringDate: self.viewModel.searchedFormData.checkInDate, currentFormat: "yyyy-MM-dd", requiredFormat: "dd MMM") ?? ""
        let checkOut = Date.getDateFromString(stringDate: self.viewModel.searchedFormData.checkOutDate, currentFormat: "yyyy-MM-dd", requiredFormat: "dd MMM") ?? ""
        let numberOfRoom = self.viewModel.searchedFormData.adultsCount.count
        self.descriptionLabel.text = "\(checkIn) - \(checkOut) • \(numberOfRoom) Rooms"

    }
    
    func reloadHotelList(isUpdatingFav: Bool = false) {
        
//        if !isUpdatingFav {
//            self.getFavouriteHotels()
//        }
        
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
    
    func searchForText(_ searchText: String, shouldPerformAction: Bool = true) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if shouldPerformAction {
            perform(#selector(self.performSearchForText(_:)), with: searchText, afterDelay: 0.5)
        }
    }
    
    @objc private func performSearchForText(_ searchText: String) {
        self.searchHotels(forText: searchText)
    }
    
    private func searchHotels(forText: String) {
        self.fetchRequestType = .Searching
        printDebug("searching text is \(forText)")
        self.searchTextStr = forText
        self.loadSaveData()
        self.reloadHotelList()
    }
    
    func hideFavsButtons() {
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
    
    func manageSwitchContainer(isHidden: Bool, shouldOff: Bool = true) {
        if hoteResultViewType == .ListView {
            manageFloatingView(isHidden: false)
            self.currentLocationButton.isHidden = hoteResultViewType == .ListView
        }
        else {
            manageFloatingView(isHidden: false)
            self.currentLocationButton.isHidden = false
        }
        
        if !isHidden {
            self.switchContainerView.isHidden = false
        }
        let newFrame = CGRect(x: 0.0, y: isHidden ? 100.0 : 0.0, width: switchContainerView.width, height: switchContainerView.height)
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {[weak self] in
            guard let sSelf = self else {return}
            
            sSelf.switchContainerView.frame = newFrame
            sSelf.view.layoutIfNeeded()
            
            }, completion: { [weak self](isDone) in
                guard let sSelf = self else {return}
                
                if isHidden {
                    sSelf.switchContainerView.isHidden = true
                }
        })
        
        
        if isHidden, shouldOff {
            //if switch is hidden then it must be off, otherwise it should be as it is.
            self.switchView.setOn(isOn: false, animated: false, shouldNotify: false)
            self.hideFavsButtons()
        }
    }
    
    func manageFloatingView(isHidden: Bool) {
        self.currentLocationButton.isHidden = isHidden
        self.switchContainerView.isHidden = isHidden
        self.floatingButtonBackView.isHidden = isHidden
    }
    
    func addTapGestureOnMap() {
        //Add tap gesture to your view
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGestureOnMap))
        self.mapContainerView.addGestureRecognizer(tap)
    }
    
    // MARK: - Manage Header animation
    
    func manageTopHeader(_ scrollView: UIScrollView, velocity: CGPoint? = nil) {
        guard scrollView === tableViewVertical else {
            return
        }
        
        let animationThreshold: CGFloat = 10.0
        
        var isHeaderHidden: Bool {
            return self.headerContainerViewTopConstraint.constant < 0
        }
        
        func showHeader() {
            guard self.headerContainerViewTopConstraint.constant <= -(animationThreshold) else {return}
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
                self.headerContainerViewTopConstraint.constant = 0
                self.tableViewTopConstraint.constant = (self.hoteResultViewType == .MapView) ? 50.0 : 100.0
                self.mapContainerTopConstraint.constant = (self.hoteResultViewType == .MapView) ? 50.0 : 100.0
                self.view.layoutIfNeeded()
            })
            self.view.addBlurEffect()
        }
        
        func hideHeader() {
            guard self.headerContainerViewTopConstraint.constant != -140 else {return}
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
                self.headerContainerViewTopConstraint.constant = -140
                self.tableViewTopConstraint.constant = 0
                self.mapContainerTopConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        
        let yPosition = scrollView.contentOffset.y
        guard scrollView.contentSize.height > (scrollView.height + animationThreshold) else {
            if yPosition >= 0 {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            }
            else if yPosition < 0, isHeaderHidden {
                showHeader()
            }
            return
        }
        
        if 0...animationThreshold ~= yPosition {
            self.headerContainerViewTopConstraint.constant = -(yPosition)
        }
        else if yPosition < 0 {
            self.headerContainerViewTopConstraint.constant = -(animationThreshold)
        }

        if yPosition <= animationThreshold {
            // show
            showHeader()
        }
        else {
            // hide
            hideHeader()
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
        
        //for map re-focusing
        let currentX = scrollView.contentOffset.x
        guard currentX > 0 else {
            return
        }
        if currentX > self.oldOffset.x {
            self.isCollectionScrollingInc = true
        }
        else if currentX < self.oldOffset.x {
            self.isCollectionScrollingInc = false
        }
        self.oldOffset = scrollView.contentOffset
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.manageTopHeader(scrollView)
        self.oldScrollPosition = scrollView.contentOffset
        
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.manageTopHeader(scrollView)
    }
    
    func manageForCollectionView(atIndex: Int) {
        let locStr = Array(self.viewModel.collectionViewList.keys)[atIndex]
        
        if let loc = self.getLocationObject(fromLocation: locStr) {
            if let oldLoc = self.displayingHotelLocation, !(loc == oldLoc) {
                self.displayingHotelLocation = loc
                focusMarker(coordinates: loc)
            }
            else {
                self.displayingHotelLocation = loc
                focusMarker(coordinates: loc)
            }
        }
    }
    
    // GestureRecognizer
    @objc func handleGestureOnMap(gesture: UITapGestureRecognizer) -> Void {
        if hoteResultViewType == .MapView {
            
        }
    }
    
    // Disable mapButton and search bar when no data found on filter
    func noHotelFoundOnFilter() {
        self.mapButton.isUserInteractionEnabled = false
        self.searchBar.isUserInteractionEnabled = false
    }
    
    // enable mapButton and search bar when no data found on filter
    func dataFounOnFilter() {
        self.mapButton.isUserInteractionEnabled = true
        self.searchBar.isUserInteractionEnabled = true
    }
}


//MARK:- Make colection view item in center
extension HotelResultVC {
    
    func calculateSectionInset() -> CGFloat {
        return CGFloat(12.0)
    }
    
    func configureCollectionViewLayoutItemSize() {
        //call this methods in viewDidLayoutSubviews
        let inset: CGFloat = calculateSectionInset() // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        collectionViewLayout.itemSize = CGSize(width: collectionViewLayout.collectionView!.frame.size.width - (inset * 2), height: 192.0)
    }
    
    func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItemInCollection = self.viewModel.collectionViewList.keys.count - 1
        let safeIndex = max(0, min(numberOfItemInCollection, index))
        return safeIndex
    }
    
    //ScrollView Delegate methods
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        indexOfCellBeforeDragging = indexOfMajorCell()
//    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard scrollView === self.collectionView else {return}
        
        let numberOfItemInCollection = self.viewModel.collectionViewList.keys.count - 1
        
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
        // calculate where scrollView should snap to:
        var indexOfMajorCell = self.indexOfMajorCell()
        
        // calculate conditions:
        let swipeVelocityThresholdToMove: CGFloat = 1.0
        
        let absVelocity = abs(velocity.x)
        if absVelocity >= swipeVelocityThresholdToMove {
            if velocity.x < 0 {
                indexOfMajorCell -= 1
            }
            else {
                indexOfMajorCell += 1
            }
            
            indexOfMajorCell = max(0,indexOfMajorCell)
            indexOfMajorCell = min(indexOfMajorCell,numberOfItemInCollection)
        }
        let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
        collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        self.manageForCollectionView(atIndex: indexOfMajorCell)
    }
    
    /// Get Star Rating
    private func getStarString(fromArr: [Int], maxCount: Int) -> String {
        var arr = Array(Set(fromArr))
        arr.sort()
        var final = ""
        var start: Int?
        var end: Int?
        var prev: Int?
        
        if arr.isEmpty || arr.count == maxCount {
            final = "All \(LocalizedString.stars.localized)" // "0 \(LocalizedString.stars.localized)"
            return final
        }
            //        else if arr.count == maxCount {
            //            final = "All \(LocalizedString.stars.localized)"
            //            return final
            //        }
        else if arr.count == 1 {
            final = "\(arr[0]) \((arr[0] == 1) ? "\(LocalizedString.star.localized)" : "\(LocalizedString.stars.localized)")"
            return final
        }
        
        for (idx, value) in arr.enumerated() {
            let diff = value - (prev ?? 0)
            if diff == 1 {
                // number is successor
                if start == nil {
                    start = prev
                }
                end = value
            }
            else if diff > 1 {
                // number is not successor
                if start == nil {
                    if let p = prev {
                        final += "\(p), "
                    }
                    
                    if idx == (arr.count - 1) {
                        final += "\(value), "
                    }
                }
                else {
                    if let s = start, let e = end {
                        final += (s != e) ? "\(s)-\(e), " : "\(s), "
                        start = nil
                        end = nil
                        prev = nil
                        if idx == (arr.count - 1) {
                            final += "\(value), "
                        }
                    }
                    else {
                        if idx == (arr.count - 1) {
                            final += "\(value), "
                        }
                    }
                }
            }
            prev = value
        }
        if let s = start, let e = end {
            final += (s != e) ? "\(s)-\(e), " : "\(s), "
            start = nil
            end = nil
        }
        final.removeLast(2)
        return final + " \(LocalizedString.stars.localized)"
    }

}
