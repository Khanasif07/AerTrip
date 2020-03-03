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
        self.viewModel.fetchRequestType = .FilterApplied
        self.viewModel.filterApplied = filter
    }
    
    func applyPreviousFilter() {
        
        let isRangeFilterApplied = HotelFilterVM.shared.filterAppliedFor(filterName: LocalizedString.Range.localized, appliedFilter: self.viewModel.filterApplied)
        let isStarFilterApplied = HotelFilterVM.shared.filterAppliedFor(filterName: LocalizedString.Ratings.localized, appliedFilter: self.viewModel.filterApplied)
        
        var starStar = ""
        var distanceStr = ""
        if isStarFilterApplied {
            if !self.viewModel.filterApplied.tripAdvisorRatingCount.difference(from: HotelFilterVM.shared.defaultTripAdvisorRatingCount).isEmpty {
                starStar = self.getStarString(fromArr: self.viewModel.filterApplied.tripAdvisorRatingCount, maxCount: 5, isTripRating: true)
                
            } else {
                starStar = self.getStarString(fromArr: self.viewModel.filterApplied.ratingCount, maxCount: 5, isTripRating: false)
            }
        }
        
        if isRangeFilterApplied {
            distanceStr = self.viewModel.filterApplied.distanceRange > 20 ? "beyond \(self.viewModel.filterApplied.distanceRange.toInt) " : " within \(self.viewModel.filterApplied.distanceRange.toInt) "
            distanceStr = distanceStr.appending(LocalizedString.Kms.localized)
        }
        
        var finalStr = LocalizedString.ApplyPreviousFilter.localized
        
        
        if isRangeFilterApplied || isStarFilterApplied {
            finalStr = LocalizedString.ApplyPreviousFilter.localized + distanceStr + (starStar.isEmpty ? starStar : " \(starStar)") + AppConstants.kEllipses
            finalStr = finalStr.replacingOccurrences(of: "  ", with: "")
        }
        finalStr = finalStr.removeLeadingTrailingWhitespaces
        printDebug(finalStr)
        AppToast.default.showToastMessage(message: finalStr, onViewController: self, duration: 5.0, buttonTitle: LocalizedString.apply.localized, buttonAction: self.completion, toastDidClose: self.toastDidClose)
        
    }
    
    // MARK: Show progress
    
    @objc func setProgress() {
        self.time += 1.0
        self.progressView?.setProgress(self.time / 10, animated: true)
        
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
                self.progressView?.isHidden = true
            }
        }
    }
    
    func openSharingSheet() {
        guard AppGlobals.shared.isNetworkRechable(showMessage: true) else {return}
        self.viewModel.getShareText()
    }
    
    func removeAllFavouritesHotels() {
        guard AppGlobals.shared.isNetworkRechable(showMessage: true) else {return}
        self.switchView.setOn(isOn: false)
        self.manageSwitchContainer(isHidden: true)
        self.viewModel.isUnpinHotelTapped = true
        self.selectedIndexPath = nil
        self.viewModel.updateFavourite(forHotels: self.viewModel.favouriteHotels, isUnpinHotels: true)
    }
    
    func expandGroup(_ hotels: [HotelSearched]) {
        if let topVC = UIApplication.topViewController() {
            let dataVC = HotelsGroupExpendedVC.instantiate(fromAppStoryboard: .HotelsSearch)
            dataVC.delegate = self
            dataVC.viewModel.sid = self.viewModel.sid
            dataVC.viewModel.hotelSearchRequest = self.viewModel.hotelSearchRequest
            self.hotelsGroupExpendedVC = dataVC
            dataVC.viewModel.samePlaceHotels = hotels
            dataVC.viewModel.isFromFavorite = self.switchView.on
            let sheet = PKBottomSheet.instanceFromNib
            sheet.isAddTapGesture = false
            sheet.headerHeight = 24.0
            sheet.headerView = dataVC.headerView
            sheet.isHideBottomSheetOnTap = false
            
            dataVC.sheetView = sheet
            
            sheet.frame = topVC.view.bounds
            sheet.delegate = self
            topVC.view.addSubview(sheet)
            sheet.present(presentedViewController: dataVC, animated: true)
        }
    }
    
    func updateFavOnList(forIndexPath: IndexPath?) {
        //update the current opened list as user make fav/unfav
        if let indexPath = forIndexPath {
            if self.viewModel.fetchRequestType == .Searching {
                self.hotelSearchTableView.reloadRow(at: indexPath, with: .none)
            }
            else {
                self.tableViewVertical.reloadRow(at: indexPath, with: .none)
                
            }
            selectedIndexPath = nil
        }
        else {
            if self.viewModel.fetchRequestType == .Searching {
                self.hotelSearchTableView.reloadData()
            }
            else {
                self.viewModel.fetchDataFromCoreData(isUpdatingFav: true)
                self.tableViewVertical.reloadData()
                
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
    
    
    
    
    func getHotelsCount() {
        HotelFilterVM.shared.filterHotelCount = self.viewModel.fetchedResultsController.fetchedObjects?.count ?? 0
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
        
        //self.tableViewVertical.tableHeaderView = hView
    }
    
    func setupNavigationTitleLabelText() {
        
        self.titleLabel.text = self.viewModel.searchedFormData.cityName
        let checkIn = Date.getDateFromString(stringDate: self.viewModel.searchedFormData.checkInDate, currentFormat: "yyyy-MM-dd", requiredFormat: "dd MMM") ?? ""
        let checkOut = Date.getDateFromString(stringDate: self.viewModel.searchedFormData.checkOutDate, currentFormat: "yyyy-MM-dd", requiredFormat: "dd MMM") ?? ""
        let numberOfRoom = self.viewModel.searchedFormData.adultsCount.count
        self.descriptionLabel.text = "\(checkIn) - \(checkOut) • \(numberOfRoom) Rooms"
        
    }
    
    func reloadHotelList(isUpdatingFav: Bool = false) {
        if !self.viewModel.searchTextStr.isEmpty {
            self.hotelSearchTableView.backgroundColor = self.viewModel.searchedHotels.count > 0 ? AppColors.themeWhite : AppColors.clear
        }
        if let section = self.viewModel.fetchedResultsController.sections, !section.isEmpty {
            self.tableViewVertical.isHidden = false
        }
        
        self.hotelSearchTableView.reloadData()
        self.tableViewVertical.reloadData()
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
        self.viewModel.fetchRequestType = .Searching
        printDebug("searching text is \(forText)")
        self.viewModel.searchTextStr = forText
        self.viewModel.loadSaveData()
        self.reloadHotelList()
    }
    
    func hideFavsButtons() {
        self.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 0, y: 0)
        self.emailButton.transform = CGAffineTransform(translationX: 0, y: 0)
        self.shareButton.transform = CGAffineTransform(translationX: 0, y: 0)
        self.unPinAllFavouriteButton.isHidden = true
        self.emailButton.isHidden = true
        self.shareButton.isHidden = true
        
    }
    
    
    func manageSwitchContainer(isHidden: Bool, shouldOff: Bool = true) {
        manageFloatingView(isHidden: false)
        
        if !isHidden {
            self.switchContainerView.isHidden = false
        }
        
        DispatchQueue.main.async {
            let newFrame = CGRect(x: 0.0, y: isHidden ? 100.0 : 0.0, width: self.switchContainerView.width, height: self.switchContainerView.height)
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
        }
        
        if isHidden, shouldOff {
            //if switch is hidden then it must be off, otherwise it should be as it is.
            self.switchView.setOn(isOn: false, animated: false, shouldNotify: false)
            self.viewModel.isFavouriteOn = false
            self.hideFavsButtons()
        }
    }
    
    func manageFloatingView(isHidden: Bool) {
        self.switchContainerView.isHidden = isHidden
        self.floatingButtonBackView.isHidden = isHidden
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === tableViewVertical else {
            return
        }
        updateHeaderView(scrollView)
        
    }
    
    
    // MARK: - Manage Header animation
    
    func showHeaderIfHiddenOnTopAfterEndScrolling(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        if yPosition >= 0 {
            if 0...96.0 ~= yPosition {
                let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration*0.5, curve: .linear) { [weak self] in
                    self?.headerContainerViewTopConstraint.constant = 0.0
                    self?.view.layoutIfNeeded()
                }
                animator.startAnimation()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        showHeaderIfHiddenOnTopAfterEndScrolling(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        showHeaderIfHiddenOnTopAfterEndScrolling(scrollView)
    }
    
    // Disable mapButton and search bar when no data found on filter
    func noHotelFoundOnFilter() {
        self.mapButton.isUserInteractionEnabled = false
        //self.searchBar.isUserInteractionEnabled = false
        self.mapButton.isHidden = true
    }
    
    // enable mapButton and search bar when no data found on filter
    func dataFounOnFilter() {
        self.mapButton.isUserInteractionEnabled = true
        self.searchBar.isUserInteractionEnabled = true
        self.mapButton.isHidden = false
    }
    
    func updateHeaderView(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        let maxBound = scrollView.contentSize.height - scrollView.height
        
        //        print(scrollView.panGestureRecognizer.velocity(in: self.view))
        if scrollView.contentSize.height <  scrollView.height {
            self.headerContainerViewTopConstraint.constant = 0.0
            return
        }
        if 0.5 < abs(yPosition), abs(yPosition) < abs(maxBound) {
            //show with progress after header height scrolled up
            let newProg = self.oldScrollPosition.y - yPosition
            var headrC = min(0,max(-140.0, (self.headerContainerViewTopConstraint.constant + newProg)))
            if yPosition <= 100.0 {
                headrC = 0.0
            }
            printDebug("ScrollView ContentOffset  Y: \(yPosition)")
            printDebug("ScrollView previous ContentOffset Y: \( self.oldScrollPosition.y)")
            printDebug("header height: \(headrC)")
            printDebug("headerContainerViewTopConstraint.constant: \(self.headerContainerViewTopConstraint.constant)")
            if headrC != self.headerContainerViewTopConstraint.constant {
                self.headerContainerViewTopConstraint.constant = headrC
            }
            
            
            //            let finalPos = 100.0 + headrC
            //            if finalPos != self.tableViewTopConstraint.constant {
            //                self.tableViewTopConstraint.constant = finalPos
            //                self.mapContainerTopConstraint.constant = finalPos
            //            }
            
            //            }
        }
        
        
        self.oldScrollPosition = scrollView.contentOffset
    }
}


//MARK:- Make colection view item in center
extension HotelResultVC {
    
    /// Get Star Rating
    private func getStarString(fromArr: [Int], maxCount: Int, isTripRating: Bool) -> String {
        var arr = Array(Set(fromArr))
        arr.sort()
        var final = ""
        var start: Int?
        var end: Int?
        var prev: Int?
        
        let starText = isTripRating ? LocalizedString.TripRating.localized : LocalizedString.stars.localized
        
        if arr.isEmpty || arr.count == maxCount {
            final = "All \(starText)" // "0 \(LocalizedString.stars.localized)"
            return final
        }
            //        else if arr.count == maxCount {
            //            final = "All \(LocalizedString.stars.localized)"
            //            return final
            //        }
        else if arr.count == 1 {
            final = "\(arr[0]) \((arr[0] == 1) ? "\(starText)" : "\(starText)")"
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
        return final + " \(starText)"
    }
    
    // show toast when come from Aerin Text Speech Controller
    func applyAerinFilter() {
        AppToast.default.showToastMessage(message: LocalizedString.FilterApplied.localized, onViewController: self, duration: 5.0, buttonTitle: LocalizedString.Undo.localized, buttonAction: self.aerinFilterUndoCompletion)
    }
    
}



