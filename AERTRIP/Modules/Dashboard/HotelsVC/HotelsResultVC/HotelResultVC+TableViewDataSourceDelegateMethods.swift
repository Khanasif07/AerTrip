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
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.tableViewType == .SearchTableView {
            return 1
        } else {
            self.hotelSearchView.isHidden = true
            self.showFloatingView()
            self.getFavouriteHotels()
            if self.fetchedResultsController.sections?.count == 0, self.fetchRequestType == .FilterApplied {
                self.hotelSearchView.isHidden = false
                self.hideFloatingView()
                self.hotelSearchTableView.backgroundView = noHotelFoundOnFilterEmptyView
                self.noHotelFoundOnFilterEmptyView.backgroundColor = .red
                self.shimmerView.addSubview(self.noHotelFoundOnFilterEmptyView)
                self.view.bringSubviewToFront(self.shimmerView)
            }
            return (self.fetchedResultsController.sections?.count ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableViewType == .SearchTableView {
            if self.searchedHotels.count == 0, self.fetchRequestType == .Searching {
                self.hotelSearchTableView.backgroundView = self.noResultemptyView
            }
            self.hotelSearchTableView.backgroundView?.isHidden = self.searchedHotels.count > 0
            return self.searchedHotels.count
        } else {
            guard let sections = self.fetchedResultsController.sections else {
                printDebug("No sections in fetchedResultsController")
                return 0
            }
            let sectionInfo = sections[section]
            if sectionInfo.numberOfObjects > 0 {
                self.shimmerView.removeFromSuperview()
            }
            return sectionInfo.numberOfObjects
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableViewType == .SearchTableView {
            return UITableView.automaticDimension
        } else {
            return 53.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.tableViewType == .ListTableView {
            guard let sections = fetchedResultsController.sections, let hView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HotelResultSectionHeader") as? HotelResultSectionHeader else {
                return nil
            }
            
            var removeFirstChar = sections[section].name
            _ = removeFirstChar.removeFirst()
            let text = removeFirstChar + " kms"
            hView.titleLabel.text = "  \(text)   "
            
            return hView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tableViewType == .ListTableView {
            return 203.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.tableViewType == .SearchTableView {
            guard let cell = hotelSearchTableView.dequeueReusableCell(withIdentifier: self.hotelResultCellIdentifier, for: indexPath) as? HotelSearchTableViewCell else {
                printDebug("HotelSearchTableViewCell not found")
                return UITableViewCell()
            }
            cell.searchText = self.predicateStr
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
        self.selectedIndexPath = indexPath
        if self.tableViewType == .SearchTableView {
            let hData = self.searchedHotels[indexPath.row]
            if let cell = tableView.cellForRow(at: indexPath) {
                AppFlowManager.default.presentHotelDetailsVC(self,hotelInfo: hData, sourceView: cell.contentView, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest)
            }
        } else {
            let hData = fetchedResultsController.object(at: indexPath)
            if let cell = tableView.cellForRow(at: indexPath) {
                AppFlowManager.default.presentHotelDetailsVC(self,hotelInfo: hData, sourceView: cell.contentView, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest)
            }
        }
    }
}
