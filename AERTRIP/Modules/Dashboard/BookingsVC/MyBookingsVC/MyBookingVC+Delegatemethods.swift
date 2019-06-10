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
        perform(#selector(search(_:)), with: searchText, afterDelay: 0.5)
    }
    
    @objc private func search(_ forText: String) {
        printDebug(forText)
        self.sendDataChangedNotification(data: ATNotification.myBookingSearching)
        MyBookingFilterVM.shared.searchText = forText
    }
}

extension MyBookingsVC: MyBookingsVMDelegate {
    
   
    func getBookingDetailFail(error: ErrorCodes) {
        AppGlobals.shared.stopLoading()
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .hotelsSearch)
    }
    
    func willGetBookings() {
        AppGlobals.shared.startLoading()
        printDebug("Will get bookings ")
    }
    
    func getBookingsDetailSuccess() {
        //        if let obj = allChildVCs[0] as? UpcomingBookingsVC {
        //            obj.emptyStateSetUp()
        //        }
        //
        AppGlobals.shared.stopLoading()
        MyBookingsVM.shared.allTabTypes = CoreDataManager.shared.fetchData(fromEntity: "BookingData", forAttribute: "bookingTabType", usingFunction: "count").map({ ($0["bookingTabType"] as? Int16) ?? -1})
        self.emptyStateSetUp()
    }
}
