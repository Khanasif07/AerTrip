//
//  CompletedVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension CancelledVC {
    
    // fetch data from Core Data
    func loadSaveData(isForFirstTime: Bool = false) {
        do {
            self.fetchedResultsController.fetchRequest.predicate = createFinalPredicate()
            
            try self.fetchedResultsController.performFetch()
            MyBookingFilterVM.shared.filteredCanceledResultCount = self.fetchedResultsController.fetchedObjects?.count ?? 0
            self.footerView?.isHidden = false
            if let allObjct = self.fetchedResultsController.fetchedObjects, allObjct.isEmpty, !self.isOnlyPendingAction {
                self.footerView?.isHidden = true
            }
        } catch {
            printDebug(error.localizedDescription)
            printDebug("Fetch failed")
        }
        
        if !isForFirstTime {
            self.reloadList(isFirstTimeLoading: isForFirstTime)
            mangePendingActionView()
        }
    }
    
    // upcoming Tab Type Predicate
    private func tabTypePredicate() -> NSPredicate? {
        return NSPredicate(format: "bookingTabType == '3'")
    }
    
    private func mangePendingActionView() {
        let pridicate = createFinalPredicate(showPending: true)
        let result = CoreDataManager.shared.fetchData("BookingData", nsPredicate: pridicate) ?? []
        print("CancelledVC result.count: \(result.count)")
        manageFooter(isHidden: result.isEmpty)
        showFooterView = result.isEmpty
    }
}

extension CancelledVC {
    //  Final Predicate
    private func createFinalPredicate (showPending: Bool = false) -> NSPredicate? {
        
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
        
        if let obj = onlyPendingActionPredicate(showPending: showPending) {
            allPred.append(obj)
        }
        
        if let obj = getSearchPredicates() {
            allPred.append(obj)
        }
        
        if allPred.isEmpty {
            return nil
        }
        else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: allPred)
        }
    }
    
    private func getSearchPredicates() -> NSPredicate?{
        if !MyBookingFilterVM.shared.searchText.isEmpty {
            let hotelName = NSPredicate(format: "hotelName CONTAINS[c] '\(MyBookingFilterVM.shared.searchText)'")
            let tripType = NSPredicate(format: "tripType CONTAINS[c] '\(MyBookingFilterVM.shared.searchText)'")
            let destination = NSPredicate(format: "destination CONTAINS[c] '\(MyBookingFilterVM.shared.searchText)'")
            let origin = NSPredicate(format: "origin CONTAINS[c] '\(MyBookingFilterVM.shared.searchText)'")
            let product = NSPredicate(format: "product CONTAINS[c] '\(MyBookingFilterVM.shared.searchText)'")
            let serviceType = NSPredicate(format: "serviceType CONTAINS[c] '\(MyBookingFilterVM.shared.searchText)'")

            let tripCitiesArrStr = NSPredicate(format: "tripCitiesArrStr CONTAINS[c] '\(MyBookingFilterVM.shared.searchText)'")
            let routesArrStr = NSPredicate(format: "routesArrStr CONTAINS[c] '\(MyBookingFilterVM.shared.searchText)'")
            let travelledCitiesArrStr = NSPredicate(format: "travelledCitiesArrStr CONTAINS[c] '\(MyBookingFilterVM.shared.searchText)'")
            let paxArrStr = NSPredicate(format: "paxArrStr CONTAINS[c] '\(MyBookingFilterVM.shared.searchText)'")
            let stepsArrayStr = NSPredicate(format: "stepsArrayStr CONTAINS[c] '\(MyBookingFilterVM.shared.searchText)'")
            
            return NSCompoundPredicate(orPredicateWithSubpredicates: [hotelName, tripType, destination, origin, product, serviceType, tripCitiesArrStr, routesArrStr, travelledCitiesArrStr, paxArrStr, stepsArrayStr])
        }
        return nil
    }
    
    private func onlyPendingActionPredicate(showPending: Bool = false) -> NSPredicate?{
        if self.isOnlyPendingAction || showPending {
            return NSPredicate(format: "isContainsPending == '1'")
        }
        return nil
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
        var allEvents = MyBookingFilterVM.shared.eventType
        if allEvents.isEmpty {
            allEvents = [1,2,3]
        }
        for type in allEvents {
            typePredicate.append(NSPredicate(format: "bookingProductType == \(type)"))
        }
        
        let finalTypePredicate = NSCompoundPredicate(orPredicateWithSubpredicates: typePredicate)
        
        return finalTypePredicate
        
    }
    
}
