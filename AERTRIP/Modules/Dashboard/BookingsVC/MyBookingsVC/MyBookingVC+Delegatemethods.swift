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
    
    @objc func search(_ forText: String) {
        printDebug(forText)
                
        let jsonDict :JSONDictionary = ["SearchQuery":forText]
        FirebaseEventLogs.shared.logSearchBarEvents(with: .MyBookingsSearchOptionSelected, value: jsonDict)

        MyBookingFilterVM.shared.searchText = forText.removeLeadingTrailingWhitespaces
        self.sendDataChangedNotification(data: ATNotification.myBookingSearching)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar){
                
        FirebaseEventLogs.shared.logMyBookingsEvent(with: .MyBookingsSpeechToTextOptionSelected)

        AppFlowManager.default.moveToSpeechToText(with: self)
    }
}

extension MyBookingsVC: MyBookingsVMDelegate {
    
    func getBookingDetailFail(error: ErrorCodes,showProgress: Bool) {
        //AppGlobals.shared.stopLoading()
        if showProgress {
            stopProgress()
        }
        self.emptyStateSetUp()
        AppToast.default.showToastMessage(message: LocalizedString.SomethingWentWrong.localized)
        self.sendDataChangedNotification(data: ATNotification.myBookingSearching)
    }
    
    func willGetBookings(showProgress: Bool) {
        //AppGlobals.shared.startLoading()
        printDebug("Will get bookings ")
        if showProgress {
            startProgress()
        }
    }
    
    func getBookingsDetailSuccess(showProgress: Bool) {
        

        //AppGlobals.shared.stopLoading()
        MyBookingsVM.shared.allTabTypes = CoreDataManager.shared.fetchData(fromEntity: "BookingData", forAttribute: "bookingTabType", usingFunction: "count").map({ ($0["bookingTabType"] as? Int16) ?? -1})
        
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
        MyBookingsVM.shared.getMinAndMaxBookingDate(bookings: MyBookingsVM.shared.bookings)
        
        if showProgress {
            stopProgress()
        }
        if MyBookingsVM.shared.isNeedToOpenCompleted{
            MyBookingsVM.shared.isNeedToOpenCompleted = false
            if MyBookingFilterVM.shared.bookigEventAvailableType.count > 1{
                self.parchmentView?.select(index: 1, animated: true)
            }
        }
    }
    
    func getDeepLinkDetailsSuccess(_ bookingDetailModel: BookingDetailModel){
        
        switch bookingDetailModel.product.lowercased(){
        case "hotel":
            AppFlowManager.default.moveToHotelBookingsDetailsVC(bookingId: bookingDetailModel.id, isForDeepLink: true, bookingDetails: bookingDetailModel)
        case "flight":
            AppFlowManager.default.moveToFlightBookingsDetailsVC(bookingId: bookingDetailModel.id, tripCitiesStr: bookingDetailModel.tripCitiesStr, isForDeepLink: true, bookingDetails: bookingDetailModel)
        default:
            AppFlowManager.default.moveToOtherBookingsDetailsVC(bookingId: bookingDetailModel.id, isForDeepLink: true, bookingDetails: bookingDetailModel)
        }
        
    }
    
}

extension MyBookingsVC: SpeechToTextVCDelegate{
    func getSpeechToText(_ text: String) {
        guard !text.isEmpty else {return}        
        searchBar.hideMiceButton(isHidden: false)
        
        let jsonDict :JSONDictionary = ["SearchQuery":text]
        FirebaseEventLogs.shared.logSearchBarEvents(with: .MyBookingsConvertedSpeechToText, value: jsonDict)

        self.searchBar.text = text
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(search(_:)), with: text, afterDelay: 0.5)
    }

    
}
