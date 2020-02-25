//
//  CompletedVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import CoreData

class CompletedVC: BaseVC {

    //Mark:- Variables
    //================
    let viewModel = UpcomingBookingsVM()
    var isComingFromFilter: Bool = false
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var completedBookingsTableView: UITableView! {
        didSet {
            self.completedBookingsTableView.delegate = self
            self.completedBookingsTableView.dataSource = self
            self.completedBookingsTableView.estimatedRowHeight = UITableView.automaticDimension
            self.completedBookingsTableView.rowHeight = UITableView.automaticDimension
            self.completedBookingsTableView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.completedBookingsTableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        }
    }
    @IBOutlet weak var footerView: MyBookingFooterView!{
        didSet {
            footerView.delegate = self
            footerView.pendingActionSwitch.isOn = false
        }
    }
    @IBOutlet weak var footerHeightConstraint: NSLayoutConstraint!
    
    // Empty State view
    // No Result Found empty View
    lazy var noCompletedBookingResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noCompletedBooking
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
    
    
    
    var isOnlyPendingAction: Bool = false
    
    // fetch result controller
    var fetchRequest: NSFetchRequest<BookingData> = BookingData.fetchRequest()
    lazy var fetchedResultsController: NSFetchedResultsController<BookingData> = {
        // booking will be in desending order by date
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateHeader", ascending: false), NSSortDescriptor(key: "bookingProductType", ascending: false), NSSortDescriptor(key: "bookingId", ascending: true)]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "dateHeader", cacheName: nil)
        return fetchedResultsController
    }()
    
    //Mark:- LifeCycle
        //================
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override func initialSetup() {
            self.registerXibs()
            self.loadSaveData(isForFirstTime: MyBookingFilterVM.shared.searchText.isEmpty)
    //        self.reloadList(isFirstTimeLoading: true)
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
//            self?.reloadAndScrollToTop()
//        }
//    }
    
    
    func reloadTable() {
        self.completedBookingsTableView?.reloadData()
    }
    
//    func reloadAndScrollToTop() {
//        self.completedBookingsTableView?.reloadData()
//        self.completedBookingsTableView?.layoutIfNeeded()
//        self.completedBookingsTableView?.setContentOffset(.zero, animated: false)
//
//    }
    
    private func registerXibs() {
        self.completedBookingsTableView.registerCell(nibName: OthersBookingTableViewCell.reusableIdentifier)
        self.completedBookingsTableView.registerCell(nibName: SpaceTableViewCell.reusableIdentifier)
        self.completedBookingsTableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
    }
    
    private func emptyStateSetUp() {
        if let sections = self.fetchedResultsController.sections, !sections.isEmpty {
            self.completedBookingsTableView.backgroundView = nil
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
                         emptyView = noCompletedBookingResultemptyView
                    }
                } else {
                    noResultemptyView.searchTextLabel.isHidden = false
                    noResultemptyView.searchTextLabel.text = "for \(MyBookingFilterVM.shared.searchText.quoted)"
                    emptyView = noResultemptyView
                }
            self.completedBookingsTableView.backgroundView = emptyView
        }
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification {
            //refresh the data with filters
            
            if (noti == .myBookingFilterApplied || noti == .myBookingFilterCleared) {
                self.isComingFromFilter  = true
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
