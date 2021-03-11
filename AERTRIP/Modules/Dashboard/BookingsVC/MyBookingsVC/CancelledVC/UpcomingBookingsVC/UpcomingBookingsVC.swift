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
            footerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var footerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var footerBottomConstraint: NSLayoutConstraint!
    
    var isOnlyPendingAction: Bool = false
    var isComingFromFilter: Bool = false
    var fetchRequest: NSFetchRequest<BookingData> = BookingData.fetchRequest()
    var tableViewHeaderCellIdentifier = "TravellerListTableViewSectionView"
    var showFirstDivider: Bool = false
    fileprivate let refreshControl = UIRefreshControl()
    
    // fetch result controller
    lazy var fetchedResultsController: NSFetchedResultsController<BookingData> = {
        // booking will be in ascending order by date
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateHeader", ascending: true), NSSortDescriptor(key: "bookingProductType", ascending: true), NSSortDescriptor(key: "bookingId", ascending: false)]
        
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
    
    // No Filter result Found Empty View
    lazy var noResultFilterEmptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noUpCommingBookingFilter
        newEmptyView.delegate = self
        return newEmptyView
    }()
    
    //Mark:- LifeCycle
    //================
    
    override func initialSetup() {
        self.registerXibs()
        self.loadSaveData(isForFirstTime: MyBookingFilterVM.shared.searchText.isEmpty)
        
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.refreshControl.tintColor = AppColors.themeGreen
        self.upcomingBookingsTableView.refreshControl = refreshControl
        self.upcomingBookingsTableView.showsVerticalScrollIndicator = true
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
        self.upcomingBookingsTableView.register(UINib(nibName: tableViewHeaderCellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderCellIdentifier)
        
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
                    emptyView = noResultFilterEmptyView
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
    
    //Mark:- IBActions
    //================
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        MyBookingsVM.shared.getBookings(showProgress: false)
    }
}


extension UpcomingBookingsVC {
    
    internal func getSpaceCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SpaceTableViewCell.reusableIdentifier, for: indexPath) as? SpaceTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = AppColors.themeWhite
        return cell
    }
}
extension UpcomingBookingsVC: EmptyScreenViewDelegate {
    func firstButtonAction(sender: ATButton) {
    }
    
    func bottomButtonAction(sender: UIButton) {
        self.sendDataChangedNotification(data: ATNotification.myBookingFilterCleared)
    }
}

