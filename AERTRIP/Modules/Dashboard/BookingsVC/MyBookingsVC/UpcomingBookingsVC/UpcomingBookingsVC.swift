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
            self.upcomingBookingsTableView.estimatedSectionHeaderHeight = 41.0
            self.upcomingBookingsTableView.sectionHeaderHeight = 41.0
            self.upcomingBookingsTableView.estimatedSectionFooterHeight = 0.0
            self.upcomingBookingsTableView.sectionFooterHeight = 0.0
        }
    }
    @IBOutlet var footerView: MyBookingFooterView! {
        didSet {
            footerView.delegate = self
            footerView.pendingActionSwitch.isOn = false
        }
    }
    @IBOutlet weak var footerHeightConstraint: NSLayoutConstraint!
    
    
    var isOnlyPendingAction: Bool = false
    var fetchRequest: NSFetchRequest<BookingData> = BookingData.fetchRequest()
    
    // fetch result controller
    lazy var fetchedResultsController: NSFetchedResultsController<BookingData> = {
        
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateHeader", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "dateHeader", cacheName: nil)
        
//        do {
//            try fetchedResultsController.performFetch()
//        } catch {
//            printDebug("Error in performFetch: \(error) at line \(#line) in file \(#file)")
//        }
        return fetchedResultsController
    }()
    
    
    //Mark:- LifeCycle
    //================
   
    override func initialSetup() {
        
        self.registerXibs()
        self.loadSaveData()
        self.reloadList(isFirstTimeLoading: true)
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
        self.upcomingBookingsTableView?.reloadData()
    }
    
    private func registerXibs() {
        self.upcomingBookingsTableView.registerCell(nibName: OthersBookingTableViewCell.reusableIdentifier)
//        self.upcomingBookingsTableView.registerCell(nibName: QueryStatusTableViewCell.reusableIdentifier)
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
                self.loadSaveData()
            }
            else if noti == .myBookingSearching {
                self.loadSaveData()
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
