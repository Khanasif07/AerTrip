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
        self.predicateStr = ""
        self.loadSaveData()
        self.hotelSearchView.isHidden = false
        self.hotelSearchTableView.backgroundView = nil
        self.showSearchAnimation()
        self.reloadHotelList()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         self.fetchRequestType = .Searching
        if searchText == "" {
            self.predicateStr = ""
            self.loadSaveData()
            self.hotelSearchView.isHidden = true
            self.tableViewType = .ListTableView
            self.searchForText(searchText)
            self.reloadHotelList()
        } else if searchText.count >= AppConstants.kSearchTextLimit {
            self.tableViewType = .SearchTableView
            noResultemptyView.searchTextLabel.isHidden = false
            noResultemptyView.searchTextLabel.text = "for \(searchText.quoted)"
            self.hotelSearchView.isHidden = false
            self.searchForText(searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.hotelSearchView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.animateHeaderToListView()
        self.hideSearchAnimation()
        self.hotelSearchView.isHidden = true
        self.view.endEditing(true)
        self.tableViewType = .ListTableView
        self.reloadHotelList()
    }
}

// MARK: - Hotel Search View Delegate methods
