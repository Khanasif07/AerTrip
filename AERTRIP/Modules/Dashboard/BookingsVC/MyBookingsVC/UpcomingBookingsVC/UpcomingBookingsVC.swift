//
//  UpcomingBookingsVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import CoreData

class UpcomingBookingsVC: BaseVC {
    
    //MARK:- Variables
    //================
    let viewModel = UpcomingBookingsVM()
    var subpredicates: [NSPredicate] = []
    
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var upcomingBookingsTableView: UITableView! {
        didSet {
            self.upcomingBookingsTableView.delegate = self
            self.upcomingBookingsTableView.dataSource = self
            self.upcomingBookingsTableView.estimatedRowHeight = UITableView.automaticDimension
            self.upcomingBookingsTableView.rowHeight = UITableView.automaticDimension
            self.upcomingBookingsTableView.estimatedSectionFooterHeight = 0.0
            self.upcomingBookingsTableView.sectionFooterHeight = 0.0
        }
    }
    @IBOutlet weak var footerView: MyBookingFooterView! {
        didSet {
            footerView.delegate = self
            footerView.pendingActionSwitch.isOn = false
        }
    }
    @IBOutlet weak var footerHeightConstraint: NSLayoutConstraint!
    
    
    var isOnlyPendingAction: Bool = false
    var isComingFromFilter: Bool = false
    var fetchRequest: NSFetchRequest<BookingData> = BookingData.fetchRequest()
    
    // fetch result controller
    lazy var fetchedResultsController: NSFetchedResultsController<BookingData> = {
        // booking will be in ascending order by date
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateHeader", ascending: true), NSSortDescriptor(key: "bookingProductType", ascending: false), NSSortDescriptor(key: "bookingId", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "dateHeader", cacheName: nil)
        
        return fetchedResultsController
    }()
    
    // Empty State view
    // No Result Found empty View
    lazy var noUpCommingBookingResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noUpCommingBooking
        return newEmptyView
    }()
    
    // No Pending Found empty View
    lazy var noPendingActionmFoundEmptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noPendingAction
        return newEmptyView
    }()
    
    
    // Not Search Found Empty View
    lazy var noResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    //Mark:- LifeCycle
    //================
    
    override func initialSetup() {
        self.registerXibs()
        self.loadSaveData(isForFirstTime: MyBookingFilterVM.shared.searchText.isEmpty)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.dismissKeyboard()
    }
    
    //Mark:- Functions
    //================
    private func manageFooter(isHidden: Bool) {
        self.footerView?.isHidden = isHidden
        self.footerHeightConstraint?.constant = isHidden ? 0.0 : 44.0
    }
    
    func reloadList(isFirstTimeLoading: Bool = false) {
        if isFirstTimeLoading, let count = self.fetchedResultsController.fetchedObjects?.count {
            self.manageFooter(isHidden: count <= 0)
        }
        self.emptyStateSetUp()
    }
    
    //    func reloadTable() {
    //        delay(seconds: 0.2) { [weak self] in
    //              self?.reloadAndScrollToTop()
    //        }
    //    }
    
    func reloadTable() {
        self.upcomingBookingsTableView?.reloadData()
    }
    
    //    func reloadAndScrollToTop() {
    //        self.upcomingBookingsTableView.reloadData()
    //        self.upcomingBookingsTableView.layoutIfNeeded()
    //        self.upcomingBookingsTableView.setContentOffset(.zero, animated: false)
    //
    //    }
    
    private func registerXibs() {
        self.upcomingBookingsTableView.registerCell(nibName: OthersBookingTableViewCell.reusableIdentifier)
        self.upcomingBookingsTableView.registerCell(nibName: SpaceTableViewCell.reusableIdentifier)
        self.upcomingBookingsTableView.registerCell(nibName: HotelTableViewCell.reusableIdentifier)
        self.upcomingBookingsTableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
    }
    
    func emptyStateSetUp() {
        if let sections = self.fetchedResultsController.sections, !sections.isEmpty {
            self.upcomingBookingsTableView.backgroundView = nil
            //            self.upcomingBookingsTableView?.isHidden = false
        } else {
            let emptyView: UIView?
            if MyBookingFilterVM.shared.searchText.isEmpty {
                if self.isOnlyPendingAction {
                    emptyView = noPendingActionmFoundEmptyView
                } else if self.isComingFromFilter {
                    noResultemptyView.searchTextLabel.isHidden = false
                    noResultemptyView.messageLabel.isHidden = true
                    noResultemptyView.searchTextLabel.text = "No Bookings Available. We couldn’t find bookings to match your filters. Try changing the filters, or reset them."
                    emptyView = noResultemptyView
                }
                else {
                     emptyView = noUpCommingBookingResultemptyView
                }
            } else {
                noResultemptyView.searchTextLabel.isHidden = false
                noResultemptyView.searchTextLabel.text = "for \(MyBookingFilterVM.shared.searchText.quoted)"
                emptyView = noResultemptyView
            }
            self.upcomingBookingsTableView.backgroundView = emptyView
            //            self.upcomingBookingsTableView?.isHidden = true
        }
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification {
            //refresh the data with filters
            
            if (noti == .myBookingFilterApplied || noti == .myBookingFilterCleared) {
                self.isComingFromFilter = true
                self.loadSaveData()
                self.reloadTable()
            }
            else if noti == .myBookingSearching {
                self.loadSaveData()
                self.reloadTable()
            }
        }
    }
    
    //Mark:- IBActions
    //================
}


extension UpcomingBookingsVC {
    
    internal func getSpaceCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SpaceTableViewCell.reusableIdentifier, for: indexPath) as? SpaceTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = AppColors.themeWhite
        return cell
    }
}
