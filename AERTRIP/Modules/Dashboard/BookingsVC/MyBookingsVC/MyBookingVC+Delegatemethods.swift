//
//  MyBookingVC+Delegatemethods.swift
//  AERTRIP
//
//  Created by apple on 24/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension MyBookingsVC: MyBookingsVMDelegate {
    
   
    func getBookingDetailFail(error: ErrorCodes) {
        self.view.removeBluerLoader()
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .hotelsSearch)
    }
    
    func willGetBookings() {
        self.view.showBlurLoader(frame:self.view.frame)
        printDebug("Will get bookings ")
    }
    
    func getBookingsDetailSuccess() {
        //        if let obj = allChildVCs[0] as? UpcomingBookingsVC {
        //            obj.emptyStateSetUp()
        //        }
        //
        self.view.removeBluerLoader()
        self.allChildVCs.removeAll()
        self.emptyStateSetUp()
        
        
        
    }
    
  
    
}
