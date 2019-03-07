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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        animateHeaderToMapView()
        self.hotelSearchView.isHidden = false
        showSearchAnimation()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.fetchRequestType = .Searching
            self.predicateStr = ""
            self.loadSaveData()
           self.hotelSearchView.isHidden = true
            self.reloadHotelList()
        } else if searchText.count >= AppConstants.kSearchTextLimit {
            noResultemptyView.searchTextLabel.isHidden = false
            noResultemptyView.searchTextLabel.text = "for \(searchText.quoted)"
            self.hotelSearchView.isHidden = false
            self.searchHotels(forText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.hotelSearchView.isHidden = true
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.hotelSearchView.isHidden = true
    }
    
    
}

// MARK: - Hotel Search View Delegate methods

extension HotelResultVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.hotelSearchTableView.backgroundView?.isHidden = self.searchedHotels.count > 0
        return self.searchedHotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: hotelResultCellIdentifier, for: indexPath) as? HotelSearchTableViewCell else {
            printDebug("HotelSearchTableViewCell not found")
            return UITableViewCell()
        }
        cell.searchText = self.predicateStr
        cell.hotelData = self.searchedHotels[indexPath.row]
        return cell
    }

}
