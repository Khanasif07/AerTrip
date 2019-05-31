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
    
    var fetchRequest: NSFetchRequest<BookingData> = BookingData.fetchRequest()
    
    // fetch result controller
    lazy var fetchedResultsController: NSFetchedResultsController<BookingData> = {
        
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "bookingProductType", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "bookingDate", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            printDebug("Error in performFetch: \(error) at line \(#line) in file \(#file)")
        }
        return fetchedResultsController
    }()
    
    
    //Mark:- LifeCycle
    //================
   
    override func initialSetup() {
        
        self.registerXibs()
        printDebug(MyBookingsVM.shared.upComingBookings)
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
        self.upcomingBookingsTableView.backgroundColor = AppColors.themeWhite
    }

    
    //Mark:- Functions
    //================
    private func registerXibs() {
        self.upcomingBookingsTableView.registerCell(nibName: OthersBookingTableViewCell.reusableIdentifier)
        self.upcomingBookingsTableView.registerCell(nibName: QueryStatusTableViewCell.reusableIdentifier)
        self.upcomingBookingsTableView.registerCell(nibName: SpaceTableViewCell.reusableIdentifier)
        self.upcomingBookingsTableView.registerCell(nibName: HotelTableViewCell.reusableIdentifier)
        self.upcomingBookingsTableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
    }
    
     func emptyStateSetUp() {
        if MyBookingsVM.shared.upComingBookings.isEmpty {
            self.emptyStateImageView.isHidden = false
            self.emptyStateTitleLabel.isHidden = false
            self.emptyStateSubTitleLabel.isHidden = false
            self.upcomingBookingsTableView.isHidden = true
        } else {
            self.emptyStateImageView.isHidden = true
            self.emptyStateTitleLabel.isHidden = true
            self.emptyStateSubTitleLabel.isHidden = true
            self.upcomingBookingsTableView.isHidden = false
        }
    }
    
    override func dataChanged(_ note: Notification) {
         if let _ = note.object as? MyBookingFilterVC {
            printDebug("Booking Filter applied replied")
        }
    }
    
    //Mark:- IBActions
    //================
}

//Mark:- Extensions
//=================
//extension UpcomingBookingsVC: UITableViewDelegate , UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
////        return self.viewModel.upcomingBookingData.count
//        return 1
//    }
//    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.viewModel.upcomingBookingData[section].numbOfRows + 1
//        if let eventData = self.viewModel.upcomingDetails[self.viewModel.allDates[section]] as? [UpComingBookingEvent] {
//            return (eventData.reduce(0) { $0 + $1.numbOfRows}) + 1
//        }
//        return 0
        
        return MyBookingsVM.shared.upComingBookings.count
    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        guard let eventData = self.viewModel.upcomingDetails[self.viewModel.allDates[indexPath.section]] as? [UpComingBookingEvent] else { return UITableViewCell() }
////        let currentSecData = eventData[0]
////        let currentRows = currentSecData.cellType()
//        
//        
//        guard let cell = self.upcomingBookingsTableView.dequeueReusableCell(withIdentifier: "HotelTableViewCell") as? HotelTableViewCell else {
//            fatalError("HotelTableViewCell not fund ")
//        }
////        let upcomingBooking = MyBookingsVM.shared.upComingBookings[indexPath.row]
////        cell.configCell(plcaeName: upcomingBooking.bookingDetails?.hotelName ?? "", travellersName: upcomingBooking.bookingDetails?.passengerDetail.first ?? "")
//      
//        return cell
////        switch currentRows[indexPath.row] {
////        case .eventTypeCell:
////            let cell = self.getEventTypeCell(tableView, indexPath: indexPath, eventData: currentSecData)
////            return cell
////        default:
//////        case .spaceCell:
//////            let cell = self.getSpaceCell(tableView, indexPath: indexPath)
//////            return cell
//////        case .queryCell:
////            let cell = self.getQueryCell(tableView, indexPath: indexPath, eventData: currentSecData)
//////            return cell
//////        }
////    }
//        
//    }
//    
//    
////    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//////        let currentSecData = self.viewModel.upcomingBookingData[section]
////        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DateTableHeaderView.className) as? DateTableHeaderView else { return nil }
////        if let currentSecData = self.viewModel.upcomingDetails[self.viewModel.allDates[section]] as? [UpComingBookingEvent] {
////            headerView.dateLabel.text = currentSecData[0].creationDate
//////            headerView.configView(date: currentSecData[0].creationDate, isFirstHeaderView: T##Bool)
////            headerView.dateLabelTopConstraint.constant = 11.0
////        }
////        headerView.contentView.backgroundColor = AppColors.themeWhite
////        headerView.backgroundColor = AppColors.themeWhite
////        return headerView
////    }
//}

extension UpcomingBookingsVC {
    internal func getEventTypeCell(_ tableView: UITableView, indexPath: IndexPath , eventData: UpComingBookingEvent) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OthersBookingTableViewCell.reusableIdentifier, for: indexPath) as? OthersBookingTableViewCell else { return UITableViewCell() }
        cell.configCell(plcaeName: eventData.placeName, travellersName: eventData.travellersName, bookingTypeImg: eventData.eventType.image , isOnlyOneCell: eventData.queries.isEmpty)
        return cell
    }
    
    internal func getSpaceCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SpaceTableViewCell.reusableIdentifier, for: indexPath) as? SpaceTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = AppColors.themeWhite
        return cell
    }
    
    internal func getQueryCell(_ tableView: UITableView, indexPath: IndexPath , eventData: UpComingBookingEvent) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QueryStatusTableViewCell.reusableIdentifier, for: indexPath) as? QueryStatusTableViewCell else { return UITableViewCell() }
        cell.configCell(status: eventData.queries[indexPath.row - 1], statusImage: #imageLiteral(resourceName: "checkIcon"), isLastCell: (eventData.queries.count - 1 == indexPath.row - 1))
        if (eventData.queries.count - 1 == indexPath.row - 1) {
            cell.containerViewBottomConstraint.constant = 5.0
        } else {
            cell.containerViewBottomConstraint.constant = 0.0
        }
        return cell
    }
}
