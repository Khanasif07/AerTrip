//
//  CancelledVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import CoreData
import UIKit

class CancelledVC: BaseVC {
    // Mark:- Variables
    //================
    let viewModel = UpcomingBookingsVM()
    var isComingFromFilter:Bool = false
    var tableViewHeaderCellIdentifier = "TravellerListTableViewSectionView"
    var showFirstDivider: Bool = false
    fileprivate let refreshControl = UIRefreshControl()
    
    // Mark:- IBOutlets
    //================
    @IBOutlet weak var cancelledBookingsTableView: UITableView! {
        didSet {
            self.cancelledBookingsTableView.delegate = self
            self.cancelledBookingsTableView.dataSource = self
            self.cancelledBookingsTableView.estimatedRowHeight = UITableView.automaticDimension
            self.cancelledBookingsTableView.rowHeight = UITableView.automaticDimension
            self.cancelledBookingsTableView.estimatedSectionFooterHeight = 0.0
            self.cancelledBookingsTableView.sectionFooterHeight = 0.0
        }
    }
    
    @IBOutlet weak var footerView: MyBookingFooterView! {
        didSet {
            self.footerView.delegate = self
            self.footerView.pendingActionSwitch.isOn = false
            footerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var footerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var footerBottomConstraint: NSLayoutConstraint!
    
    // fetch result controller
    var isOnlyPendingAction: Bool = false
    var fetchRequest: NSFetchRequest<BookingData> = BookingData.fetchRequest()
    lazy var fetchedResultsController: NSFetchedResultsController<BookingData> = {
        // booking will be in desending order by date
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateHeader", ascending: false), NSSortDescriptor(key: "bookingProductType", ascending: true), NSSortDescriptor(key: "bookingId", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "dateHeader", cacheName: nil)
        return fetchedResultsController
    }()
    
    // Empty State view
    // No Result Found empty View
    lazy var noCanceledBookingResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noCanceledBooking
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
        newEmptyView.vType = .noCanceledBookingFilter
        newEmptyView.delegate = self
        return newEmptyView
    }()
    
    var showFooterView = false
    
    // Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manageFooter(isHidden: showFooterView)
    }
    
    override func initialSetup() {
        self.registerXibs()
        self.loadSaveData(isForFirstTime: false)
        //        self.reloadList(isFirstTimeLoading: true)
        
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.refreshControl.tintColor = AppColors.themeGreen
        self.cancelledBookingsTableView.refreshControl = refreshControl
        self.cancelledBookingsTableView.showsVerticalScrollIndicator = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.dismissKeyboard()
    }
    
    // Mark:- Functions
    //================
    func manageFooter(isHidden: Bool) {
        //        guard self.isViewLoaded, let _ = self.view.window  else {return}
        self.footerView?.isHidden = isHidden
        self.footerHeightConstraint?.constant = isHidden ? 0.0 : 44.0
        self.footerBottomConstraint?.constant = isHidden ? 0.0 : AppFlowManager.default.safeAreaInsets.bottom
        //self.view.layoutIfNeeded()
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
    //
    func reloadTable() {
        self.cancelledBookingsTableView?.reloadData()
    }
    
    //    func reloadAndScrollToTop() {
    //        self.cancelledBookingsTableView?.reloadData()
    //        self.cancelledBookingsTableView?.layoutIfNeeded()
    //        self.cancelledBookingsTableView?.setContentOffset(.zero, animated: false)
    //
    //    }
    
    private func registerXibs() {
        self.cancelledBookingsTableView.registerCell(nibName: OthersBookingTableViewCell.reusableIdentifier)
        self.cancelledBookingsTableView.registerCell(nibName: SpaceTableViewCell.reusableIdentifier)
        self.cancelledBookingsTableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
        self.cancelledBookingsTableView.register(UINib(nibName: tableViewHeaderCellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderCellIdentifier)
    }
    
    private func emptyStateSetUp() {
        if let sections = self.fetchedResultsController.sections, !sections.isEmpty {
            self.cancelledBookingsTableView.backgroundView = nil
        } else {
            let emptyView: UIView?
            if MyBookingFilterVM.shared.searchText.isEmpty {
                if self.isOnlyPendingAction {
                    emptyView = noPendingActionmFoundEmptyView
                } else if self.isComingFromFilter || MyBookingFilterVM.shared.isFilterAplied() {
                    emptyView = noResultFilterEmptyView
                }
                else {
                    emptyView = noCanceledBookingResultemptyView
                }
            } else {
                noResultemptyView.searchTextLabel.isHidden = false
                noResultemptyView.searchTextLabel.text = "for \(MyBookingFilterVM.shared.searchText.quoted)"
                emptyView = noResultemptyView
            }
            self.cancelledBookingsTableView.backgroundView = emptyView
        }
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification {
            // refresh the data with filters
            
            switch noti {
            case .myBookingFilterApplied, .myBookingFilterCleared:
                self.isComingFromFilter = true
                self.loadSaveData()
                self.reloadTable()
            case .myBookingSearching:
                if  MyBookingFilterVM.shared.isFilterAplied() {
                    self.isComingFromFilter = true
                }
                self.loadSaveData()
                self.reloadTable()
            default:
                break
            }
        }
    }
    
    // Mark:- IBActions
    //================
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        MyBookingsVM.shared.getBookings(showProgress: false)
    }
}
extension CancelledVC: EmptyScreenViewDelegate {
    func firstButtonAction(sender: ATButton) {
    }
    
    func bottomButtonAction(sender: UIButton) {
        self.sendDataChangedNotification(data: ATNotification.myBookingFilterCleared)
    }
}
