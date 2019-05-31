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
            
            self.fetchedResultsController.fetchRequest.predicate = createFinalPredicate()
            try self.fetchedResultsController.performFetch()
        } catch {
            printDebug(error.localizedDescription)
            printDebug("Fetch failed")
        }
        
        self.upcomingBookingsTableView.reloadData()
    }
    

    
    //  Final Predicate
    private func createFinalPredicate () -> NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [bookingDatePredicates(),tabTypePredicate(),eventTypePredicates()])
    }
    
    
    // upcoming Tab Type Predicate
    
    private func tabTypePredicate() -> NSPredicate {
        return NSPredicate(format: "bookingTabType == '1'")
    }
    
    
    // Booking Date Predicates
    
    private func bookingDatePredicates() -> NSPredicate {
        let fromDate = MyBookingFilterVM.shared.bookingFromDate.addDay(days: -60)
        let toDate = MyBookingFilterVM.shared.bookingFromDate.addDay(days: 1)
        // Set predicate as date being today's date
        let fromPredicate = NSPredicate(format: "bookingDate >= %@",fromDate ?? NSPredicate())
        let toPredicate = NSPredicate(format: "bookingDate <= %@",toDate ?? NSPredicate())
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        return datePredicate
       }
    
    // Booking Travel Predicate
    
    private func bookingTravelDatePredicates() -> NSPredicate {
        let fromTravelDate = MyBookingFilterVM.shared.bookingFromDate.addDay(days: -3)
        let toTravelDate = MyBookingFilterVM.shared.bookingFromDate.addDay(days: 1)
        // Set predicate as date being today's date
        let fromTravelDatePredicate = NSPredicate(format: "depart >= %@",fromTravelDate ?? NSPredicate())
        let toTravelDatePredicate = NSPredicate(format: "depart <= %@",toTravelDate ?? NSPredicate())
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromTravelDatePredicate, toTravelDatePredicate])
        return datePredicate
    }
    
    
    // Predicate for Event type
    
    private func eventTypePredicates() -> NSPredicate {
        var typePredicate : [NSPredicate] = []
        if MyBookingFilterVM.shared.eventType.isEmpty {
            MyBookingFilterVM.shared.eventType = [1,2,3]
        }
        for type in MyBookingFilterVM.shared.eventType {
            typePredicate.append(NSPredicate(format: "bookingProductType == \(type)"))
        }
        
        let finalTypePredicate = NSCompoundPredicate(orPredicateWithSubpredicates: typePredicate)
        
        return finalTypePredicate
        
    }
    
}
