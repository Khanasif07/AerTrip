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
    var tableViewHeaderCellIdentifier = "TravellerListTableViewSectionView"
    var showFirstDivider: Bool = false
    fileprivate let refreshControl = UIRefreshControl()
    
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
            footerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var footerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var footerBottomConstraint: NSLayoutConstraint!
    
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
    
    // No Filter result Found Empty View
    lazy var noResultFilterEmptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noCompletedBookingFilter
        newEmptyView.delegate = self
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
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.refreshControl.tintColor = AppColors.themeGreen
        self.completedBookingsTableView.refreshControl = refreshControl
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.dismissKeyboard()
    }
    
    //Mark:- Functions
    //================
    func manageFooter(isHidden: Bool) {
        self.footerView?.isHidden = isHidden
        self.footerHeightConstraint?.constant = isHidden ? 0.0 : 44.0
        self.footerBottomConstraint?.constant = isHidden ? 0.0 : AppFlowManager.default.safeAreaInsets.bottom
        //        self.view.layoutIfNeeded()
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
        self.completedBookingsTableView.register(UINib(nibName: tableViewHeaderCellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderCellIdentifier)
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
                    emptyView = noResultFilterEmptyView
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
            
            switch noti {
            case .myBookingFilterApplied, .myBookingFilterCleared:
                self.isComingFromFilter  = true
                self.loadSaveData()
                self.reloadTable()
            case .myBookingSearching:
                self.loadSaveData()
                self.reloadTable()
            default:
                break
            }
        }
    }
    
    //Mark:- IBActions
    //================
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        MyBookingsVM.shared.getBookings(showProgress: false)
    }
}
extension CompletedVC: EmptyScreenViewDelegate {
    func firstButtonAction(sender: ATButton) {
    }
    
    func bottomButtonAction(sender: UIButton) {
        self.sendDataChangedNotification(data: ATNotification.myBookingFilterCleared)
    }
}
