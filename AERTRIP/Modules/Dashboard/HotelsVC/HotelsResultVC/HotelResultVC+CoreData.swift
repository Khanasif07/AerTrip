//
//  HotelResultVC+CoreData.swift
//  AERTRIP
//
//  Created by apple on 18/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
extension HotelResultVC {
    // Load Save Data from core data
    func getSearchTextPredicate() -> NSCompoundPredicate {
//        if self.searchTextStr.count >= AppConstants.kSearchTextLimit {
        return NSCompoundPredicate(type: .or, subpredicates: [NSPredicate(format: "hotelName CONTAINS[cd] %@", self.searchTextStr), NSPredicate(format: "address CONTAINS[cd] %@", self.searchTextStr)])
//        }
//        else {
//            return NSCompoundPredicate(format: "")
//        }
    }
    
    func loadSaveData() {
        
        // Predicate for searching based on Hotel Name and a
        let orPredicate = getSearchTextPredicate()
        switch self.fetchRequestType {
        case .FilterApplied:
            addSortDescriptors()
            self.filterButton.isSelected = true
            if self.searchTextStr == "" {
                andPredicate = NSCompoundPredicate(type: .and, subpredicates: self.createSubPredicates())
                self.fetchedResultsController.fetchRequest.predicate = andPredicate
            } else {
                andPredicate = NSCompoundPredicate(type: .and, subpredicates: self.createSubPredicates())
                if let andPredicate = andPredicate {
                    self.fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [orPredicate, andPredicate])
                }
            }
        case .Searching:
            if let andPredicate = self.andPredicate {
                self.fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [orPredicate, andPredicate])
            } else {
                self.fetchedResultsController.fetchRequest.predicate = orPredicate
            }
            
        case .normalInSearching :
            self.searchedHotels.removeAll()
            self.fetchRequestWithoutFilter()
            
        case .normal :
          self.fetchRequestWithoutFilter()
        }
        self.fetchDataFromCoreData()
        self.reloadHotelList()
    }
    
    // Add Sort Descriptors to fetch request
    func addSortDescriptors() {
        self.fetchedResultsController.fetchRequest.sortDescriptors?.removeAll()
        self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sectionTitle", ascending: true)]
        
        switch self.filterApplied.sortUsing {
        case .BestSellers:
            self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "bc", ascending: true))
        case .PriceLowToHigh:
            self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "price", ascending: true))
        case .TripAdvisorRatingHighToLow:
            self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "rating", ascending: false))
        case .StartRatingHighToLow:
            self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "star", ascending: false))
        case .DistanceNearestFirst:
            self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "distance", ascending: true))
        }
    }
    
    // Create Sub Predicates
    
    func createSubPredicates() -> [NSPredicate] {
        var subpredicates: [NSPredicate] = []
        let minimumPricePredicate = NSPredicate(format: "price >= \(filterApplied.leftRangePrice)")
        let maximumPricePredicate = NSPredicate(format: "price <= \(filterApplied.rightRangePrice)")
        subpredicates.append(minimumPricePredicate)
        subpredicates.append(maximumPricePredicate)
        if self.filterApplied.distanceRange <= 20 {
            let distancePredicate = NSPredicate(format: "distance <= \(self.filterApplied.distanceRange)")
            subpredicates.append(distancePredicate)
        }
        if self.filterApplied.isIncludeUnrated {
            self.filterApplied.ratingCount.append(0)
            self.filterApplied.tripAdvisorRatingCount.append(0)
        }
        
        if let amentitiesPredicate = amentitiesPredicate() {
            subpredicates.append(amentitiesPredicate)
        }
        
        if let starPredicate = starPredicate() {
            subpredicates.append(starPredicate)
        }
        
        if let tripAdvisorPredicate = tripAdvisonPredicate() {
            subpredicates.append(tripAdvisorPredicate)
        }
        
        return subpredicates
    }
    
    // Amentities Predicate
    
    func amentitiesPredicate() -> NSPredicate? {
        var amentitiesPredicate: NSPredicate?
        var predicates = [AnyHashable]()
        for amentity in self.filterApplied.amentities {
            predicates.append(NSPredicate(format: "amenities CONTAINS[c] ',\(amentity)'"))
        }
        if predicates.count > 0 {
            if let predicates = predicates as? [NSPredicate] {
                amentitiesPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            }
        }
        
        return amentitiesPredicate
    }
    
    // Star Predicacate
    
    func starPredicate() -> NSPredicate? {
        var starPredicate: NSPredicate?
        var starPredicates = [AnyHashable]()
        for star in self.filterApplied.ratingCount {
            starPredicates.append(NSPredicate(format: "filterStar CONTAINS[c] '\(star)'"))
        }
        
        if starPredicates.count > 0 {
            if let starPredicates = starPredicates as? [NSPredicate] {
                starPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: starPredicates)
            }
        }
        return starPredicate
    }
    
    // Create TripAdvisor Predicate
    
    func tripAdvisonPredicate() -> NSPredicate? {
        var tripAdvisorPredicate: NSPredicate?
        var tripAdvisorPredicates = [AnyHashable]()
        for rating in self.filterApplied.tripAdvisorRatingCount {
            tripAdvisorPredicates.append(NSPredicate(format: "filterTripAdvisorRating CONTAINS[c] '\(rating)'"))
        }
        
        if tripAdvisorPredicates.count > 0 {
            if let tripAdvisorPredicates = tripAdvisorPredicates as? [NSPredicate] {
                tripAdvisorPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: tripAdvisorPredicates)
            }
        }
        return tripAdvisorPredicate
    }
    
    // Fetch Request Without Filters
    
    func fetchRequestWithoutFilter() {
        if self.searchTextStr.isEmpty {
            self.fetchedResultsController.fetchRequest.predicate = switchView.on ? NSPredicate(format: "fav == \(1)") : nil
            
        } else {
            let orPredicate = getSearchTextPredicate()
            self.fetchedResultsController.fetchRequest.predicate = orPredicate
        }
    }
    
    // Fetch Data from core data
    
    func fetchDataFromCoreData() {
        do {
            try self.fetchedResultsController.performFetch()
            self.getHotelsCount()
            if !self.searchTextStr.isEmpty {
                self.searchedHotels = self.fetchedResultsController.fetchedObjects ?? []
                self.hotelSearchTableView.backgroundColor = self.searchedHotels.count > 0 ? AppColors.themeWhite : AppColors.clear
                
                self.hotelSearchTableView.reloadData()
            }
            
            self.reloadHotelList()
            self.viewModel.fetchHotelsDataForCollectionView(fromController: self.fetchedResultsController)
        } catch {
            printDebug(error.localizedDescription)
            print("Fetch failed")
        }
    }
}
