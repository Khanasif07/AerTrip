//
//  MyBookingVC+Delegatemethods.swift
//  AERTRIP
//
//  Created by apple on 24/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension MyBookingsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        // 800 milliseconds for searching the text same as Android 
        perform(#selector(search(_:)), with: searchText, afterDelay: 0.8)
    }
    
    @objc private func search(_ forText: String) {
        printDebug(forText)
        self.sendDataChangedNotification(data: ATNotification.myBookingSearching)
        MyBookingFilterVM.shared.searchText = forText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         self.view.endEditing(true)
    }
}

extension MyBookingsVC: MyBookingsVMDelegate {
    
   
    func getBookingDetailFail(error: ErrorCodes) {
        AppGlobals.shared.stopLoading()
        self.emptyStateSetUp()
        AppToast.default.showToastMessage(message: LocalizedString.SomethingWentWrong.localized)
    }
    
    func willGetBookings() {
        AppGlobals.shared.startLoading()
        printDebug("Will get bookings ")
    }
    
    func getBookingsDetailSuccess() {

        AppGlobals.shared.stopLoading()
        MyBookingsVM.shared.allTabTypes = CoreDataManager.shared.fetchData(fromEntity: "BookingData", forAttribute: "bookingTabType", usingFunction: "count").map({ ($0["bookingTabType"] as? Int16) ?? -1})
        self.emptyStateSetUp()
    }
}
