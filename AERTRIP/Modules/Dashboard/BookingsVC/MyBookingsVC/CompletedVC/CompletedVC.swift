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
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var emptyStateImageView: UIImageView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    @IBOutlet weak var emptyStateSubTitleLabel: UILabel!
    @IBOutlet weak var completedBookingsTableView: UITableView! {
        didSet {
            self.completedBookingsTableView.delegate = self
            self.completedBookingsTableView.dataSource = self
            self.completedBookingsTableView.contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.completedBookingsTableView.estimatedRowHeight = UITableView.automaticDimension
            self.completedBookingsTableView.rowHeight = UITableView.automaticDimension
            self.completedBookingsTableView.estimatedSectionHeaderHeight = 41.0
            self.completedBookingsTableView.sectionHeaderHeight = 41.0
            self.completedBookingsTableView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.completedBookingsTableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        }
    }
    
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.registerXibs()

        self.emptyStateSetUp()
        self.loadSaveData()
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
        self.completedBookingsTableView.backgroundColor = AppColors.themeWhite
    }
    
    
    // fetch result controller
    var fetchRequest: NSFetchRequest<BookingData> = BookingData.fetchRequest()
    lazy var fetchedResultsController: NSFetchedResultsController<BookingData> = {
        
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "bookingProductType", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "eventStartDate", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            printDebug("Error in performFetch: \(error) at line \(#line) in file \(#file)")
        }
        return fetchedResultsController
    }()
    
    //Mark:- Functions
    //================
    private func registerXibs() {
        self.completedBookingsTableView.registerCell(nibName: OthersBookingTableViewCell.reusableIdentifier)
//        self.completedBookingsTableView.registerCell(nibName: QueryStatusTableViewCell.reusableIdentifier)
        self.completedBookingsTableView.registerCell(nibName: SpaceTableViewCell.reusableIdentifier)
        self.completedBookingsTableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
    }
    
    private func emptyStateSetUp() {
        if let sections = self.fetchedResultsController.sections, !sections.isEmpty {
            self.emptyStateImageView.isHidden = true
            self.emptyStateTitleLabel.isHidden = true
            self.emptyStateSubTitleLabel.isHidden = true
            self.completedBookingsTableView.isHidden = false
        }
        else {
            self.emptyStateImageView.isHidden = false
            self.emptyStateTitleLabel.isHidden = false
            self.emptyStateSubTitleLabel.isHidden = false
            self.completedBookingsTableView.isHidden = true
        }
    }
    
    
    override func dataChanged(_ note: Notification) {
        if let _ = note.object as? MyBookingFilterVC {
            printDebug("Booking filter applied : Completed VC")
        }
    }

    func reloadList() {
        self.emptyStateSetUp()
        self.completedBookingsTableView.reloadData()
    }
    
    //Mark:- IBActions
    //================
}
