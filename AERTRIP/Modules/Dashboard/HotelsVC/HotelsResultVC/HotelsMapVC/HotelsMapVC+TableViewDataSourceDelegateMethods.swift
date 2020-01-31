//
//  HotelResultVC+TableViewDataSourceDelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 18/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

// MARK: - Table view datasource and delegate methods

// MARK: -

extension HotelsMapVC: UITableViewDataSource, UITableViewDelegate {
    func manageViewForSearchAndFilterMode() {
        
        let count = self.fetchedResultsController.fetchedObjects?.count ?? 0
        if (self.fetchRequestType == .FilterApplied), count <= 0 {
            self.hotelSearchView.isHidden = false
            self.hotelSearchTableView.backgroundView = noHotelFoundOnFilterEmptyView
            self.noHotelFoundOnFilter()
            self.manageFloatingView(isHidden: true)
        }
        else if (self.fetchRequestType == .Searching) {
            self.manageFloatingView(isHidden: true)
            self.hotelSearchView.isHidden = false
            self.hotelSearchTableView.backgroundView = self.noResultemptyView
            if !self.searchedHotels.isEmpty {
                self.hotelSearchTableView.backgroundView?.isHidden = true
            }
            else {
                self.hotelSearchTableView.backgroundView?.isHidden = (self.searchTextStr.isEmpty && self.searchedHotels.isEmpty)
            }
            manageFloatingView(isHidden: true)
        }
        else if (self.fetchRequestType == .normalInSearching) {
            self.searchedHotels.removeAll()
            self.hotelSearchView.isHidden = false
            hotelSearchTableView.backgroundColor = AppColors.clear
            self.hotelSearchTableView.backgroundView?.isHidden = true
            manageFloatingView(isHidden: true)
        }
        else {
            self.dataFounOnFilter()
            self.hotelSearchView.isHidden = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        manageViewForSearchAndFilterMode()
        if tableView === hotelSearchTableView {
            searchBar.enablesReturnKeyAutomatically = self.searchedHotels.count < 0
            return 1
        }
        else {
            return self.fetchedResultsController.sections?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.searchedHotels.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 110.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 110.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = hotelSearchTableView.dequeueReusableCell(withIdentifier: self.hotelResultCellIdentifier, for: indexPath) as? HotelSearchTableViewCell else {
                printDebug("HotelSearchTableViewCell not found")
                return UITableViewCell()
            }
            cell.searchText = self.searchTextStr
            if self.searchedHotels.count > 0 {
                cell.hotelData = self.searchedHotels[indexPath.row]
            }
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        self.selectedIndexPath = indexPath
            let hData = self.searchedHotels[indexPath.row]
            if let cell = tableView.cellForRow(at: indexPath) {
                AppFlowManager.default.presentHotelDetailsVC(self,hotelInfo: hData, sourceView: cell.contentView, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest){
                    self.statusBarColor = AppColors.themeWhite
                }
                self.selectedIndexPath = indexPath
            }
    }
}



