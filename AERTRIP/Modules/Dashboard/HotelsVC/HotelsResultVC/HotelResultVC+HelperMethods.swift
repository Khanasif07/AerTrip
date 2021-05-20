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
            return
        }
        self.viewModel.fetchRequestType = .FilterApplied
        self.viewModel.filterApplied = filter
        self.viewModel.isFilterApplied = true
    }
    
    func applyPreviousFilter() {
        
        var filterApplied: UserInfo.HotelFilter = UserInfo.HotelFilter()
        if let oldFilter = self.viewModel.tempHotelFilter {
            filterApplied = oldFilter
        }
        
        let isRangeFilterApplied = HotelFilterVM.shared.filterAppliedFor(filterName: LocalizedString.Distance.localized, appliedFilter: filterApplied)
        let isStarFilterApplied = HotelFilterVM.shared.filterAppliedFor(filterName: LocalizedString.Ratings.localized, appliedFilter: filterApplied)
        
        var starStar = ""
        var distanceStr = ""
        if isStarFilterApplied {
            if !filterApplied.tripAdvisorRatingCount.difference(from: HotelFilterVM.shared.defaultTripAdvisorRatingCount).isEmpty {
                starStar = self.getStarString(fromArr: filterApplied.tripAdvisorRatingCount, maxCount: 5, isTripRating: true)
                
            } else {
                starStar = self.getStarString(fromArr: filterApplied.ratingCount, maxCount: 5, isTripRating: false)
            }
        }
        
        if isRangeFilterApplied {
            var distance = "\(filterApplied.distanceRange.toInt)"
            if filterApplied.distanceRange.toInt == 0 {
                distance = "0.5"
            }
            distanceStr = filterApplied.distanceRange > 20 ? "beyond \(distance) " : " within \(distance) "
            
            distanceStr = distanceStr.appending(LocalizedString.Kms.localized)
        }
        
        var finalStr = LocalizedString.ApplyPreviousFilter.localized
        
        
        if isRangeFilterApplied || isStarFilterApplied {
            finalStr = LocalizedString.ApplyPreviousFilter.localized + distanceStr + (starStar.isEmpty ? starStar : " \(starStar)") //+ AppConstants.kEllipses
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
            self.timer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
            }
        }
        
        if self.time >= 10 {
            self.timer?.invalidate()
            delay(seconds: 0.8) {
                self.timer?.invalidate()
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
        //self.switchView.isOn = false
        self.manageSwitchContainer(isHidden: true)
        self.viewModel.isUnpinHotelTapped = true
        self.selectedIndexPath = nil
        self.viewModel.updateFavourite(forHotels: self.viewModel.favouriteHotels, isUnpinHotels: true)
    }
    
    //    func expandGroup(_ hotels: [HotelSearched]) {
    //        if let topVC = UIApplication.topViewController() {
    //            let dataVC = HotelsGroupExpendedVC.instantiate(fromAppStoryboard: .HotelsSearch)
    //            dataVC.delegate = self
    //            dataVC.viewModel.sid = self.viewModel.sid
    //            dataVC.viewModel.hotelSearchRequest = self.viewModel.hotelSearchRequest
    //            self.hotelsGroupExpendedVC = dataVC
    //            dataVC.viewModel.samePlaceHotels = hotels
    //            dataVC.viewModel.isFromFavorite = self.switchView.isOn
    //            let sheet = PKBottomSheet.instanceFromNib
    //            sheet.isAddTapGesture = false
    //            sheet.headerHeight = 24.0
    //            sheet.headerView = dataVC.headerView
    //            sheet.isHideBottomSheetOnTap = false
    //
    //            dataVC.sheetView = sheet
    //
    //            sheet.frame = topVC.view.bounds
    //            sheet.delegate = self
    //            topVC.view.addSubview(sheet)
    //            sheet.present(presentedViewController: dataVC, animated: true)
    //        }
    //    }
    
    func updateFavOnList(forIndexPath: IndexPath?) {
        //update the current opened list as user make fav/unfav
        if let indexPath = forIndexPath {
            //            if self.viewModel.fetchRequestType == .Searching {
            self.hotelSearchTableView.reloadRow(at: indexPath, with: .none)
            //            }
            //            else {
            self.tableViewVertical.reloadRow(at: indexPath, with: .none)
            
            //            }
            selectedIndexPath = nil
        }
        else {
            //            if self.viewModel.fetchRequestType == .Searching {
            self.hotelSearchTableView.reloadData()
            //            }
            //            else {
            self.viewModel.fetchDataFromCoreData(isUpdatingFav: true)
            self.tableViewVertical.reloadData()
            
            //            }
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
        HotelFilterVM.shared.delegate?.updateHotelsCount()
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
        self.descriptionLabel.text = "\(checkIn) - \(checkOut) • \(numberOfRoom) \(numberOfRoom > 1 ? "Rooms" : "Room")"
        
    }
    
    func reloadHotelList(isUpdatingFav: Bool = false) {
        if !self.viewModel.searchTextStr.isEmpty {
            self.hotelSearchTableView.backgroundColor = self.viewModel.searchedHotels.count > 0 ? AppColors.themeWhite : AppColors.clear
        }
        if let section = self.viewModel.fetchedResultsController.sections, !section.isEmpty {
            self.tableViewVertical.isHidden = false
        }
        self.hotelMapVC?.resetAllMarker()
        self.hotelMapVC?.filterButton.isSelected =  !(HotelFilterVM.shared.isSortingApplied || self.viewModel.isFilterApplied) ? false : true
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
            //self.switchView.isOn = false
            self.viewModel.isFavouriteOn = false
            self.hideFavsButtons()
            tableViewVertical.setContentOffset(CGPoint(x: 0, y: -topContentSpace), animated: false)
            showBluredHeaderViewCompleted()
        }
        
    }
    
    func manageFloatingView(isHidden: Bool) {
        self.switchContainerView.isHidden = isHidden
        self.floatingButtonBackView.isHidden = isHidden
    }
    
    /*
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
     guard scrollView === tableViewVertical else {
     return
     }
     var yPosition = CGFloat()
     if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
     yPosition = 0
     }
     else {
     yPosition = -120
     }
     if self.isViewDidAppear, self.headerContainerViewTopConstraint.constant != yPosition {
     UIView.animate(withDuration: AppConstants.kAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
     self.headerContainerViewTopConstraint.constant = yPosition
     self.view.layoutIfNeeded()
     }, completion: nil)
     }
     }
     */
    
    // MARK: - Manage Header animation
    
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

//MARK:- Scroll related methods
extension HotelResultVC {
    
    fileprivate func hideHeaderBlurView(_ offsetDifference: CGFloat) {
        DispatchQueue.main.async {
            
            var yCordinate : CGFloat
            yCordinate = max (  -self.visualEffectViewHeight ,  -offsetDifference )
            yCordinate = min ( 0,  yCordinate)
            
            
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseOut], animations: {
                
                var rect = self.headerContainerView.frame
                let yCordinateOfView = rect.origin.y
                if ( yCordinateOfView  > yCordinate ) {
                    rect.origin.y = yCordinate
                    //printDebug("hideHeaderBlurView.frame : \(self.headerContainerView.frame )")
                    if self.headerContainerViewTopConstraint.constant != yCordinate {
                        self.headerContainerViewTopConstraint.constant = yCordinate
                        self.headerContainerView.layoutIfNeeded()
                    }
                    var value = self.topContentSpace - abs(yCordinate)
                    //printDebug("hideHeaderBlurView: \(value)")
                    if value < 0 {
                        value = 16
                    } else {
                        value += 16
                    }
                    self.tableViewVertical.contentInset = UIEdgeInsets(top: value, left: 0, bottom: 0, right: 0)
                    
                }
                if self.headerContainerViewTopConstraint.constant == 0 {
                    self.statusBarViewContainer.isHidden = true
                } else {
                    self.statusBarViewContainer.isHidden = false
                }
            } ,completion: nil)
        }
    }
    
    func revealBlurredHeaderView(_ invertedOffset: CGFloat) {
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseInOut], animations: {
                
                var rect = self.headerContainerView.frame
                
//                var yCordinate = rect.origin.y + invertedOffset
                var yCordinate = invertedOffset - 100.0
                yCordinate = min ( 0,  yCordinate)
                if self.tableViewVertical.contentOffset.y <= 0 || rect.origin.y == 20{
                    yCordinate = 0
                }
                rect.origin.y = yCordinate
                //printDebug("revealBlurredHeaderView.frame : \(self.headerContainerView.frame )")
                if self.headerContainerViewTopConstraint.constant != yCordinate {
                    self.headerContainerViewTopConstraint.constant = yCordinate
                    self.view.layoutIfNeeded()
                }
                var value = self.topContentSpace - abs(yCordinate)
                printDebug("revealBlurredHeaderView: \(value)")
                if value >= 0 {
                    value = self.topContentSpace + 16
                }
                if self.tableViewVertical.contentOffset.y < 100 {
                    value = self.topContentSpace 
                }
                if self.headerContainerViewTopConstraint.constant == 0 {
                    self.statusBarViewContainer.isHidden = true
                } else {
                    self.statusBarViewContainer.isHidden = false
                }
                self.tableViewVertical.contentInset = UIEdgeInsets(top: value, left: 0, bottom: 0, right: 0)
                
            } ,completion: nil)
        }
    }
    
    fileprivate func snapToTopOrBottomOnSlowScrollDragging(_ scrollView: UIScrollView) {
        
        var rect = self.headerContainerView.frame
        let yCoordinate = rect.origin.y * ( -1 )
        
        // After dragging if blurEffectView is at top or bottom position , snapping animation is not required
        if yCoordinate == 0 || yCoordinate == ( -visualEffectViewHeight){
            return
        }
        
        // If blurEffectView yCoodinate is close to top of the screen
        if  ( yCoordinate > ( visualEffectViewHeight / 2.0 ) ){
            rect.origin.y = -visualEffectViewHeight
            
            if scrollView.contentOffset.y < 100 {
                let zeroPoint = CGPoint(x: 0, y: self.topContentSpace)
                scrollView.setContentOffset(zeroPoint, animated: true)
            }
        }
        else {  //If blurEffectView yCoodinate is close to fully visible state of blurView
            rect.origin.y = 0
        }
        
        // Animatioon to move the blurEffectView
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseOut], animations: {
            if self.headerContainerViewTopConstraint.constant != rect.origin.y {
                self.headerContainerViewTopConstraint.constant = rect.origin.y
                self.view.layoutIfNeeded()
            }
            var value = self.topContentSpace - abs(rect.origin.y)
            if value >= 0 {
                value = self.topContentSpace + 16
            }
            if value < 0 {
                value = 16
            }
            if self.tableViewVertical.contentOffset.y < 100 {
                value = self.topContentSpace
            }
            if self.headerContainerViewTopConstraint.constant == 0 {
                self.statusBarViewContainer.isHidden = true
            } else {
                self.statusBarViewContainer.isHidden = false
            }
            self.tableViewVertical.contentInset = UIEdgeInsets(top: value, left: 0, bottom: 0, right: 0)
            
        } ,completion: nil)
    }
    
    func showBluredHeaderViewCompleted() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseInOut], animations: {
                if self.headerContainerViewTopConstraint.constant != 0 {
                    self.headerContainerViewTopConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
                self.statusBarViewContainer.isHidden = true
                //self.tableViewVertical.contentInset = UIEdgeInsets(top: self.topContentSpace, left: 0, bottom: 0, right: 0)
                
            } ,completion: nil)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView === tableViewVertical, self.isViewDidAppear else {return}
        scrollviewInitialYOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === tableViewVertical, self.isViewDidAppear else {return}
        
        let contentSize = scrollView.contentSize
        let scrollViewHeight = contentSize.height
        let viewHeight = self.view.frame.height
        
        if scrollViewHeight < (viewHeight + visualEffectViewHeight) {
            return
        }
        
        let contentOffset = scrollView.contentOffset
        let offsetDifference = contentOffset.y - scrollviewInitialYOffset
        if offsetDifference > 0 {
            hideHeaderBlurView(offsetDifference)
        }
        else {
            let invertedOffset = -offsetDifference
            revealBlurredHeaderView(invertedOffset)
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView){
        guard scrollView === tableViewVertical, self.isViewDidAppear else {return}
        showBluredHeaderViewCompleted()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView === tableViewVertical, self.isViewDidAppear else {return}
        snapToTopOrBottomOnSlowScrollDragging(scrollView)
        //        scrollviewInitialYOffset = 0.0
    }
}
