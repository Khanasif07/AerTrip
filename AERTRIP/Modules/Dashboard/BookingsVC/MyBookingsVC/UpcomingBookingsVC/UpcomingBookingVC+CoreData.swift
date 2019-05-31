//
//  UpcomingBookingVC+CoreData.swift
//  AERTRIP
//
//  Created by apple on 29/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension UpcomingBookingsVC {
    
    // fetch data from Core Data
    func loadSaveData() {
        do {
            self.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "bookingTabType == '1'")
        
            try self.fetchedResultsController.performFetch()
        } catch {
            printDebug(error.localizedDescription)
            printDebug("Fetch failed")
        }
        
        self.upcomingBookingsTableView.reloadData()
    }
}
