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

extension HotelResultVC: UITableViewDataSource, UITableViewDelegate {
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
        delay(seconds: 0.5) { [weak self] in
            guard let `self` = self else {return}
           // self.tableViewVertical.isScrollEnabled = self.tableViewVertical.contentSize.height > self.tableViewVertical.height
        }
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
        if tableView === hotelSearchTableView {
            return self.searchedHotels.count
        } else {
            guard let sections = self.fetchedResultsController.sections else {
                printDebug("No sections in fetchedResultsController")
                return 0
            }
            let sectionInfo = sections[section]
        //    let dbData = fetchedResultsController.fetchedObjects ?? []//CoreDataManager.shared.fetchData("HotelSearched") ?? []
            // shimmer will be remain hidden in this case 
            self.manageShimmer(isHidden: true)
            manageViewForSearchAndFilterMode()
            return sectionInfo.numberOfObjects
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView === hotelSearchTableView {
            return 0.0
        }
        else {
           return  section == 0 ?  0 :  53.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView === hotelSearchTableView {
            return nil
        }
        else {
            guard let hView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HotelResultSectionHeader") as? HotelResultSectionHeader else {
                return nil
            }
            
            hView.titleLabel.text = self.getSectionTitle(forSection: section)
            hView.titleLabelWidthConstraint.constant = hView.titleLabel.intrinsicContentSize.width + 9
            return hView
        }
    }
    
    func getSectionTitle(forSection section: Int) -> String {
        guard let allSections = self.fetchedResultsController.sections else {
            return ""
        }
        
        var finalText = "a" // for handling empty case
        if section >= (allSections.count - 1) {
            //it's a last section updated this
            
            let title = allSections[section].name
            if title.contains("to") {
                var titleArr = allSections[section].name.components(separatedBy: "to")
                titleArr[1] = " \(Int((self.filterApplied.distanceRange < 1.0) ? 1.0 : self.filterApplied.distanceRange))"
                
                finalText = titleArr.joined(separator: "to")
            }
            else {
                finalText = title
            }
        }
        else {
            //not a last section return as it is
            finalText = allSections[section].name
        }
        
        _ = finalText.removeFirst()
        if !finalText.isEmpty {
            finalText += " kms"
        }
        
        return finalText
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView === hotelSearchTableView {
            return 110.0
        } else {
            return 203.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === hotelSearchTableView {
            guard let cell = hotelSearchTableView.dequeueReusableCell(withIdentifier: self.hotelResultCellIdentifier, for: indexPath) as? HotelSearchTableViewCell else {
                printDebug("HotelSearchTableViewCell not found")
                return UITableViewCell()
            }
            cell.searchText = self.searchTextStr
            if self.searchedHotels.count > 0 {
                cell.hotelData = self.searchedHotels[indexPath.row]
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelCardTableViewCell") as? HotelCardTableViewCell else {
                fatalError("HotelCardTableViewCell not found")
            }
            
            let hData = fetchedResultsController.object(at: indexPath)
            self.isAboveTwentyKm = hData.isHotelBeyondTwentyKm
            self.isFotterVisible = self.isAboveTwentyKm
            cell.hotelListData = hData
            cell.delegate = self
            cell.contentView.backgroundColor = AppColors.themeWhite
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        self.selectedIndexPath = indexPath
        if tableView === hotelSearchTableView {
            let hData = self.searchedHotels[indexPath.row]
            if let cell = tableView.cellForRow(at: indexPath) {
                AppFlowManager.default.presentHotelDetailsVC(self,hotelInfo: hData, sourceView: cell.contentView, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest){
                    self.statusBarColor = AppColors.themeWhite
                }
                self.selectedIndexPath = indexPath
            }
        } else {
            let hData = fetchedResultsController.object(at: indexPath)
            if let cell = tableView.cellForRow(at: indexPath) as? HotelCardTableViewCell {
                AppFlowManager.default.presentHotelDetailsVC(self,hotelInfo: hData, sourceView: cell.collectionView, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest){
                    self.statusBarColor = AppColors.themeWhite
                }
            }
        }
    }
}



