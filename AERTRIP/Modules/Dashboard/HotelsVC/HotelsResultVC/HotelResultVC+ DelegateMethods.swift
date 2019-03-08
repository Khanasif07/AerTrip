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
        self.tableViewType = .SearchTableView
        animateHeaderToMapView()
        self.hotelSearchView.isHidden = false
        self.showSearchAnimation()
        self.reloadHotelList()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.fetchRequestType = .Searching
            self.predicateStr = ""
            self.loadSaveData()
            self.hotelSearchView.isHidden = true
            self.tableViewType = .ListTableView
            self.reloadHotelList()
        } else if searchText.count >= AppConstants.kSearchTextLimit {
            self.tableViewType = .SearchTableView
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

