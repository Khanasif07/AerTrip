//
//  CancelledVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import CoreData

class CancelledVC: BaseVC {

    //Mark:- Variables
    //================
    let viewModel = UpcomingBookingsVM()
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var emptyStateImageView: UIImageView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    @IBOutlet weak var emptyStateSubTitleLabel: UILabel!
    @IBOutlet weak var cancelledBookingsTableView: UITableView! {
        didSet {
            self.cancelledBookingsTableView.delegate = self
            self.cancelledBookingsTableView.dataSource = self
            self.cancelledBookingsTableView.contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.cancelledBookingsTableView.estimatedRowHeight = UITableView.automaticDimension
            self.cancelledBookingsTableView.rowHeight = UITableView.automaticDimension
            self.cancelledBookingsTableView.estimatedSectionHeaderHeight = 41.0
            self.cancelledBookingsTableView.sectionHeaderHeight = 41.0
            self.cancelledBookingsTableView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.cancelledBookingsTableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        }
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
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.registerXibs()

        //        self.viewModel.upcomingBookingData.removeAll()
        self.emptyStateSetUp()
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
        self.cancelledBookingsTableView.backgroundColor = AppColors.themeWhite
    }
    
    
    //Mark:- Functions
    //================
    private func registerXibs() {
        self.cancelledBookingsTableView.registerCell(nibName: OthersBookingTableViewCell.reusableIdentifier)
//        self.cancelledBookingsTableView.registerCell(nibName: QueryStatusTableViewCell.reusableIdentifier)
        self.cancelledBookingsTableView.registerCell(nibName: SpaceTableViewCell.reusableIdentifier)
        self.cancelledBookingsTableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
    }
    
    private func emptyStateSetUp() {
        if let sections = self.fetchedResultsController.sections, !sections.isEmpty {
            self.emptyStateImageView.isHidden = true
            self.emptyStateTitleLabel.isHidden = true
            self.emptyStateSubTitleLabel.isHidden = true
            self.cancelledBookingsTableView.isHidden = false
        }
        else {
            self.emptyStateImageView.isHidden = false
            self.emptyStateTitleLabel.isHidden = false
            self.emptyStateSubTitleLabel.isHidden = false
            self.cancelledBookingsTableView.isHidden = true
        }
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification, noti == .myBookingFilterApplied {
            //re-hit the search API
            printDebug("in cancelled \(MyBookingFilterVM.shared)")
        }
    }
    
    func reloadList() {
        self.emptyStateSetUp()
        self.cancelledBookingsTableView.reloadData()
    }
    
    //Mark:- IBActions
    //================
}
