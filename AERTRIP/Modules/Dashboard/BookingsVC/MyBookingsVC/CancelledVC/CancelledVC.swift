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
    
    
    // Mark:- IBOutlets
    //================
    @IBOutlet weak var emptyStateImageView: UIImageView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    @IBOutlet weak var emptyStateSubTitleLabel: UILabel!
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
        }
    }
    
    @IBOutlet weak var footerHeightConstraint: NSLayoutConstraint!
    
    // fetch result controller
    var isOnlyPendingAction: Bool = false
    var fetchRequest: NSFetchRequest<BookingData> = BookingData.fetchRequest()
    lazy var fetchedResultsController: NSFetchedResultsController<BookingData> = {
        // booking will be in desending order by date
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateHeader", ascending: false), NSSortDescriptor(key: "bookingProductType", ascending: false), NSSortDescriptor(key: "bookingId", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "dateHeader", cacheName: nil)
        return fetchedResultsController
    }()
    
    // Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
        self.emptyStateTitleLabel.text = LocalizedString.YouHaveNoCancelledBookings.localized
        self.emptyStateSubTitleLabel.text = LocalizedString.NewDestinationsAreAwaiting.localized
    }
    
    override func setupFonts() {
        self.emptyStateTitleLabel.font = AppFonts.Regular.withSize(22.0)
        self.emptyStateSubTitleLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.emptyStateTitleLabel.textColor = AppColors.themeBlack
        self.emptyStateSubTitleLabel.textColor = AppColors.themeGray60
        self.cancelledBookingsTableView.backgroundColor = AppColors.themeWhite
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.dismissKeyboard()
    }
    
    // Mark:- Functions
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
    }
    
    private func emptyStateSetUp() {
        self.emptyStateTitleLabel?.text = self.isOnlyPendingAction ? LocalizedString.YouHaveNoPendingAction.localized : LocalizedString.YouHaveNoCancelledBookings.localized
        if let sections = self.fetchedResultsController.sections, !sections.isEmpty {
            self.emptyStateImageView?.isHidden = true
            self.emptyStateTitleLabel?.isHidden = true
            self.emptyStateSubTitleLabel?.isHidden = true
            self.cancelledBookingsTableView?.isHidden = false
        }
        else {
            self.emptyStateImageView?.isHidden = false
            self.emptyStateTitleLabel?.isHidden = false
            self.emptyStateSubTitleLabel?.isHidden = false
            self.cancelledBookingsTableView?.isHidden = true
        }
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification {
            // refresh the data with filters
            
            if noti == .myBookingFilterApplied || noti == .myBookingFilterCleared {
                self.loadSaveData()
                self.reloadTable()
            }
            else if noti == .myBookingSearching {
                self.loadSaveData()
                self.reloadTable()
            }
        }
    }
    
    // Mark:- IBActions
    //================
}
