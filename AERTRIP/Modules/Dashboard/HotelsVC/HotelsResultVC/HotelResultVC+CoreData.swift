//
//  HotelResultVC+CoreData.swift
//  AERTRIP
//
//  Created by apple on 18/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
import CoreData

extension HotelResultVC: NSFetchedResultsControllerDelegate {
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
        var finalPredicate: NSCompoundPredicate?
        let orPredicate = getSearchTextPredicate()
        switch self.fetchRequestType {
        case .FilterApplied:
            switch self.filterApplied.sortUsing {
            case .DistanceNearestFirst:
                addSortDescriptors()
                self.fetchedResultsController =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "sectionTitle", cacheName: nil)
            default:
                addSortDescriptors()
                self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            }
            
            if self.searchTextStr == "" {
                andPredicate = NSCompoundPredicate(type: .and, subpredicates: self.createSubPredicates())
                finalPredicate = andPredicate
            } else {
                andPredicate = NSCompoundPredicate(type: .and, subpredicates: self.createSubPredicates())
                if let andPredicate = andPredicate {
                    finalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [orPredicate, andPredicate])
                }
            }
            
            //if switch is on then all the operations must be only on fav data
            if self.switchView.on {
                let favPred = NSPredicate(format: "fav == '1'")
                if let oldPred = finalPredicate {
                    finalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [oldPred, favPred])
                }
                else {
                    finalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [favPred])
                }
            }
            
        case .Searching:
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            var finalPred: NSCompoundPredicate!
            if let andPredicate = self.andPredicate {
                finalPred = NSCompoundPredicate(andPredicateWithSubpredicates: [orPredicate, andPredicate])
            } else {
                finalPred = orPredicate
            }
            
            if self.switchView.on {
                //if switch is on then all the operations must be only on fav data
                let favPred = NSPredicate(format: "fav == '1'")
                finalPred = NSCompoundPredicate(andPredicateWithSubpredicates: [favPred, finalPred])
            }
            
            finalPredicate = finalPred
            
        case .normalInSearching, .normal :
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            if self.fetchRequestType == .normalInSearching {
                self.searchedHotels.removeAll()
            }
            
            if self.switchView.on {
                //if switch is on then all the operations must be only on fav data
                let favPred = NSPredicate(format: "fav == '1'")
                finalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [favPred])
            }
            else {
                self.fetchRequestWithoutFilter()
            }
        }
        
        if let pred = finalPredicate {
            self.fetchedResultsController.fetchRequest.predicate = pred
        }
        
        
        //        if let pred = finalPredicate {
        //            if let starPred = starPredicate(forStars: HotelsSearchVM.hotelFormData.ratingCount) {
        //                self.fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [starPred, pred])
        //            }
        //            else {
        //                self.fetchedResultsController.fetchRequest.predicate = pred
        //            }
        //        }
        //        else if let starPred = starPredicate(forStars: HotelsSearchVM.hotelFormData.ratingCount) {
        //            self.fetchedResultsController.fetchRequest.predicate = starPred
        //        }
        self.fetchDataFromCoreData(finalPredicate: finalPredicate)
    }
    
    // Add Sort Descriptors to fetch request
    func addSortDescriptors() {
        self.fetchedResultsController.fetchRequest.sortDescriptors?.removeAll()
        self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sectionTitle", ascending: true)]
        
        switch self.filterApplied.sortUsing {
        case .BestSellers:
            self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "bc", ascending: true)]
        case .PriceLowToHigh:
            self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "price", ascending: true)]
        case .TripAdvisorRatingHighToLow:
            self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
        case .StartRatingHighToLow:
            self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "star", ascending: false)]
        case .DistanceNearestFirst:
            self.fetchedResultsController.fetchRequest.sortDescriptors =  [NSSortDescriptor(key: "distance", ascending: true)]
            
        }
    }
    
    // Create Sub Predicates
    
    func createSubPredicates() -> [NSPredicate] {
        
        if HotelFilterVM.shared.distanceRange == HotelFilterVM.shared.defaultDistanceRange && HotelFilterVM.shared.leftRangePrice == HotelFilterVM.shared.defaultLeftRangePrice && HotelFilterVM.shared.rightRangePrice == HotelFilterVM.shared.defaultRightRangePrice && (HotelFilterVM.shared.ratingCount.difference(from: HotelFilterVM.shared.defaultRatingCount).isEmpty || HotelFilterVM.shared.ratingCount.count == 0)  &&  HotelFilterVM.shared.tripAdvisorRatingCount.difference(from: HotelFilterVM.shared.defaultTripAdvisorRatingCount).isEmpty && HotelFilterVM.shared.isIncludeUnrated == HotelFilterVM.shared.defaultIsIncludeUnrated && HotelFilterVM.shared.priceType == HotelFilterVM.shared.defaultPriceType && HotelFilterVM.shared.amenitites.difference(from: HotelFilterVM.shared.defaultAmenitites).isEmpty && HotelFilterVM.shared.roomMeal.difference(from: HotelFilterVM.shared.defaultRoomMeal).isEmpty && HotelFilterVM.shared.roomCancelation.difference(from: HotelFilterVM.shared.defaultRoomCancelation).isEmpty && HotelFilterVM.shared.roomOther.difference(from: HotelFilterVM.shared.defaultRoomOther).isEmpty   {
            return []
        }
        
        // Boolean flag to check and manage red dot icon.
        self.isFilterApplied = true
        var subpredicates: [NSPredicate] = []
        let minimumPricePredicate = NSPredicate(format: "perNightPrice >= \(filterApplied.leftRangePrice)")
        let maximumPricePredicate = NSPredicate(format: "perNightPrice <= \(filterApplied.rightRangePrice)")
        subpredicates.append(minimumPricePredicate)
        subpredicates.append(maximumPricePredicate)
        if self.filterApplied.distanceRange < 20 {
            let distancePredicate = NSPredicate(format: "distance <= \(self.filterApplied.distanceRange)")
            subpredicates.append(distancePredicate)
        }
        if self.filterApplied.isIncludeUnrated {
            self.filterApplied.ratingCount.append(0)
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
        
        // set up filter button red-dot setup
        // self.filterButton.isSelected = true
        
        return subpredicates
    }
    
    // Amentities Predicate
    
    func amentitiesPredicate() -> NSPredicate? {
        var amentitiesPredicate: NSPredicate?
        var predicates = [AnyHashable]()
        for amentity in self.filterApplied.amentities {
            predicates.append(NSPredicate(format: "amenities CONTAINS[c] ',\(amentity),'"))
        }
        if predicates.count > 0 {
            if let predicates = predicates as? [NSPredicate] {
                amentitiesPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            }
        }
        
        return amentitiesPredicate
    }
    
    // Star Predicacate
    
    func starPredicate(forStars: [Int]? = nil) -> NSPredicate? {
        var starPredicate: NSPredicate?
        var starPredicates = [AnyHashable]()
        let finalStars = forStars ?? self.filterApplied.ratingCount
        for star in finalStars {
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
        
        if self.filterApplied.tripAdvisorRatingCount.isEmpty {
            tripAdvisorPredicates.append(NSPredicate(format: "filterTripAdvisorRating CONTAINS[c] '0'"))
        }
        else {
            for rating in self.filterApplied.tripAdvisorRatingCount {
                tripAdvisorPredicates.append(NSPredicate(format: "filterTripAdvisorRating CONTAINS[c] '\(rating)'"))
            }
            if !self.filterApplied.tripAdvisorRatingCount.contains(0) {
                tripAdvisorPredicates.append(NSPredicate(format: "filterTripAdvisorRating CONTAINS[c] '0'"))
            }
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
            self.fetchedResultsController.fetchRequest.predicate = nil
            
        } else {
            self.fetchedResultsController.fetchRequest.predicate = getSearchTextPredicate()
        }
    }
    
    // Fetch Data from core data
    
    func fetchDataFromCoreData(isUpdatingFav: Bool = false,finalPredicate: NSPredicate? = nil) {
        do {
            try self.fetchedResultsController.performFetch()
            self.getHotelsCount()
            if !self.searchTextStr.isEmpty {
                self.searchedHotels = self.fetchedResultsController.fetchedObjects ?? []
                self.hotelSearchTableView.backgroundColor = self.searchedHotels.count > 0 ? AppColors.themeWhite : AppColors.clear
            }
            
            self.viewModel.fetchHotelsDataForCollectionView(fromController: self.fetchedResultsController)
            
            if !isUpdatingFav {
                self.reloadHotelList()
            }
            
            self.getFavouriteHotels(shouldReloadData: false,finalPredicate: finalPredicate)
            
        } catch {
            printDebug(error.localizedDescription)
            printDebug("Fetch failed")
        }
    }
    
    func getFavouriteHotels(shouldReloadData: Bool = false, finalPredicate: NSPredicate? = nil) {
        
        var pred: NSPredicate = NSPredicate(format: "fav == '1'")
        if let all = finalPredicate {
            pred = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "fav == '1'"), all])
        }
        
        if let allFavs = CoreDataManager.shared.fetchData("HotelSearched", nsPredicate: pred)  as? [HotelSearched] {
            self.isLoadingListAfterUpdatingAllFav = false
            self.manageSwitchContainer(isHidden: allFavs.isEmpty)
            self.favouriteHotels = allFavs
            
            if shouldReloadData {
                //using shouldReloadData for breaking the func calling cycle from numberOfRows
                //load data after hiding/closing the switch button
                if allFavs.isEmpty {
                    delay(seconds: 0.3) { [weak self] in
                        self?.loadSaveData()
                    }
                }
                else {
                    self.updateFavOnList(forIndexPath: self.selectedIndexPath)
                }
            }
        }
        else if !isLoadingListAfterUpdatingAllFav {
            self.fetchRequestType = .normal
            self.isLoadingListAfterUpdatingAllFav = true
            self.loadSaveData()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
            //        case .insert:
            //            if let indexPath = newIndexPath {
            //                tableViewVertical.insertRows(at: [indexPath], with: .fade)
        //            }
        case .delete:
            
            if self.hoteResultViewType == .ListView, self.switchView.on, let indexPath = indexPath {
                tableViewVertical.deleteRows(at: [indexPath], with: .fade)
                if let hotel = anObject as? HotelSearched {
                    self.viewModel.deleteHotelsDataForCollectionView(hotel: hotel)
                    self.collectionView.reloadData()
                }
            }
            //        case .update:
            //            if let indexPath = indexPath, let cell = tableViewVertical.cellForRow(at: indexPath) as? HotelCardTableViewCell {
            //                configureCell(cell: cell, at: indexPath)
            //            }
            //        case .move:
            //            if let indexPath = indexPath {
            //                tableViewVertical.deleteRows(at: [indexPath], with: .fade)
            //            }
            //
            //            if let newIndexPath = newIndexPath {
            //                tableViewVertical.insertRows(at: [newIndexPath], with: .fade)
        //            }
       
            
        @unknown default: break
        }
    }
}
