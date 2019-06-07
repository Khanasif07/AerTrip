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
            MyBookingFilterVM.shared.filteredUpcomingResultCount = self.fetchedResultsController.fetchedObjects?.count ?? 0
        } catch {
            printDebug(error.localizedDescription)
            printDebug("Fetch failed")
        }
        
        self.upcomingBookingsTableView?.reloadData()
    }
    
    // upcoming Tab Type Predicate
    private func tabTypePredicate() -> NSPredicate? {
        return NSPredicate(format: "bookingTabType == '1'")
    }

}


extension UpcomingBookingsVC {
    //  Final Predicate
    private func createFinalPredicate () -> NSPredicate? {
        
        var allPred: [NSPredicate] = []
        
        if let obj = bookingDatePredicates() {
            allPred.append(obj)
        }
        
        if let obj = bookingTravelDatePredicates() {
            allPred.append(obj)
        }
        
        if let obj = tabTypePredicate() {
            allPred.append(obj)
        }
        
        if let obj = eventTypePredicates() {
            allPred.append(obj)
        }
        
        if allPred.isEmpty {
            return nil
        }
        else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: allPred)
        }
    }
    
    
    // Booking Date Predicates
    private func bookingDatePredicates() -> NSPredicate? {
        
        var fromPredicate: NSPredicate?
        var toPredicate: NSPredicate?
        if let fromDate = MyBookingFilterVM.shared.bookingFromDate?.toString(dateFormat: "yyyy-MM-dd 00:00:00") {
            fromPredicate = NSPredicate(format: "bookingDate >= %@", fromDate)
        }
        
        if let toDate = MyBookingFilterVM.shared.bookingToDate?.toString(dateFormat: "yyyy-MM-dd 00:00:00") {
            toPredicate = NSPredicate(format: "bookingDate <= %@",toDate)
        }
        
        if let from = fromPredicate, let to = toPredicate {
            return NSCompoundPredicate(andPredicateWithSubpredicates: [from, to])
        }
        else if let from = fromPredicate {
            return from
        }
        else if let to = toPredicate {
            return to
        }
        return nil
    }
    
    // Booking Travel Predicate
    
    private func bookingTravelDatePredicates() -> NSPredicate? {
        
        var fromPredicate: NSPredicate?
        var toPredicate: NSPredicate?
        if let fromDate = MyBookingFilterVM.shared.travelFromDate?.toString(dateFormat: "yyyy-MM-dd 00:00:00") {
            fromPredicate = NSPredicate(format: "dateHeader >= %@", fromDate)
        }
        
        if let toDate = MyBookingFilterVM.shared.travelToDate?.toString(dateFormat: "yyyy-MM-dd 00:00:00") {
            toPredicate = NSPredicate(format: "dateHeader <= %@",toDate)
        }
        
        if let from = fromPredicate, let to = toPredicate {
            return NSCompoundPredicate(andPredicateWithSubpredicates: [from, to])
        }
        else if let from = fromPredicate {
            return from
        }
        else if let to = toPredicate {
            return to
        }
        return nil
    }
    
    
    // Predicate for Event type
    
    private func eventTypePredicates() -> NSPredicate? {
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
