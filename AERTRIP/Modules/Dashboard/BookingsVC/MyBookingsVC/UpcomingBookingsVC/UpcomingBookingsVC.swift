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
    @IBOutlet weak var emptyStateImageView: UIImageView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    @IBOutlet weak var emptyStateSubTitleLabel: UILabel!
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
    
    
    //Mark:- LifeCycle
    //================
   
    override func initialSetup() {
        
        self.emptyStateImageView.isUserInteractionEnabled = false
        self.emptyStateTitleLabel.isUserInteractionEnabled = false
        self.emptyStateSubTitleLabel.isUserInteractionEnabled = false
        
        self.registerXibs()
        self.loadSaveData(isForFirstTime: MyBookingFilterVM.shared.searchText.isEmpty)
//        self.reloadList(isFirstTimeLoading: true)
    }
    
    override func setupTexts() {
        self.emptyStateImageView.image = #imageLiteral(resourceName: "upcoming_emptystate")
        self.emptyStateTitleLabel.text = LocalizedString.YouHaveNoUpcomingBookings.localized
        self.emptyStateSubTitleLabel.text = LocalizedString.NewDestinationsAreAwaiting.localized
        
    }
    
    override func setupFonts() {
        self.emptyStateTitleLabel.font = AppFonts.Regular.withSize(22.0)
        self.emptyStateSubTitleLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.emptyStateTitleLabel.textColor = AppColors.themeBlack
        self.emptyStateSubTitleLabel.textColor = AppColors.themeGray60
        self.upcomingBookingsTableView.backgroundColor = AppColors.themeWhite
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
        self.emptyStateTitleLabel?.text = self.isOnlyPendingAction ? LocalizedString.YouHaveNoPendingAction.localized : LocalizedString.YouHaveNoUpcomingBookings.localized
        if let sections = self.fetchedResultsController.sections, !sections.isEmpty {
            self.emptyStateImageView?.isHidden = true
            self.emptyStateTitleLabel?.isHidden = true
            self.emptyStateSubTitleLabel?.isHidden = true
            self.upcomingBookingsTableView?.isHidden = false
        } else {
            if !isComingFromFilter {
                self.emptyStateTitleLabel?.text = " No Bookings Available. We couldn’t find bookings to match your filters."
                self.emptyStateSubTitleLabel?.text = " Try changing the filters, or reset them."
            }
            self.emptyStateImageView?.isHidden = false
            self.emptyStateTitleLabel?.isHidden = false
            self.emptyStateSubTitleLabel?.isHidden = false
            self.upcomingBookingsTableView?.isHidden = true
        }
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification {
            //refresh the data with filters
            
            if (noti == .myBookingFilterApplied || noti == .myBookingFilterCleared) {
                self.isComingFromFilter = false
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
