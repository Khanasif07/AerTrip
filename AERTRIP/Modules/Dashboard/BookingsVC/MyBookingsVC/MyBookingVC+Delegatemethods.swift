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
        perform(#selector(search(_:)), with: searchText, afterDelay: 0.5)
    }
    
    @objc private func search(_ forText: String) {
        printDebug(forText)
        MyBookingFilterVM.shared.searchText = forText.removeLeadingTrailingWhitespaces
        self.sendDataChangedNotification(data: ATNotification.myBookingSearching)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         self.view.endEditing(true)
    }
}

extension MyBookingsVC: MyBookingsVMDelegate {
    
   
    func getBookingDetailFail(error: ErrorCodes) {
        //AppGlobals.shared.stopLoading()
        stopProgress()
        self.emptyStateSetUp()
        AppToast.default.showToastMessage(message: LocalizedString.SomethingWentWrong.localized)
        self.sendDataChangedNotification(data: ATNotification.myBookingSearching)
    }
    
    func willGetBookings() {
        //AppGlobals.shared.startLoading()
        printDebug("Will get bookings ")
        startProgress()
    }
    
    func getBookingsDetailSuccess() {

        //AppGlobals.shared.stopLoading()
        MyBookingsVM.shared.allTabTypes = [1,2,3] //CoreDataManager.shared.fetchData(fromEntity: "BookingData", forAttribute: "bookingTabType", usingFunction: "count").map({ ($0["bookingTabType"] as? Int16) ?? -1})
        
        let allEvents = [1,2,3]
        MyBookingFilterVM.shared.bookigEventAvailableType.removeAll()
               for type in allEvents {
                let result = CoreDataManager.shared.fetchData("BookingData", nsPredicate: NSPredicate(format: "bookingProductType == \(type)")) ?? []
                if !result.isEmpty {
                    MyBookingFilterVM.shared.bookigEventAvailableType.append(type)
                }
               }
        self.emptyStateSetUp()
        self.sendDataChangedNotification(data: ATNotification.myBookingSearching)
        stopProgress()
    }
}
