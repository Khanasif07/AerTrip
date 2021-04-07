//
//  FlightFareInfoVC.swift
//  AERTRIP
//
//  Created by Admin on 30/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightFareInfoVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var tableView: ATTableView!
    
    // MARK: - Variables
    let headerViewIdentifier = "BookingInfoHeaderView"
    let footerViewIdentifier = "BookingInfoEmptyFooterView"
    let fareInfoHeaderViewIdentifier = "FareInfoHeaderView"
    let viewModel = BookingDetailVM()
    
    override func initialSetup() {
        self.view.layoutIfNeeded()
        self.viewModel.fecthTableCellsForFareInfo()
        self.registerXib()
        delay(seconds: 0.3) { [weak self] in
            let sec = self?.viewModel.legSectionTap ?? 0
            guard let numberOfSection = self?.tableView?.numberOfSections, sec < numberOfSection else {return}
            let row = (self?.tableView?.numberOfRows(inSection: sec) ?? 0)
            guard (sec < self?.tableView?.numberOfSections ?? 0) && (row > 0) else {return}
            self?.tableView?.scrollToRow(at: IndexPath(row: 0, section: self?.viewModel.legSectionTap ?? 0), at: .top, animated: false)
        }
        //        self.tableView.backgroundColor = AppColors.themeWhite
        self.viewModel.getBookingFees()

        FirebaseEventLogs.shared.logAccountsEventsWithAccountType(with: .BookingsFlightDetailsFareInfo, AccountType: UserInfo.loggedInUser?.userCreditType.rawValue ?? "n/a", isFrom: "Bookings")

    }
    
    
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    private func registerXib() {
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tableView.tableHeaderView = UIView(frame: frame)
        self.tableView.backgroundColor = AppColors.themeGray04
        
        self.tableView.register(UINib(nibName: self.headerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.headerViewIdentifier)
        self.tableView.register(UINib(nibName: self.fareInfoHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.fareInfoHeaderViewIdentifier)
        self.tableView.register(UINib(nibName: self.footerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.footerViewIdentifier)
        self.tableView.registerCell(nibName: FareInfoNoteTableViewCell.reusableIdentifier)
        self.tableView.registerCell(nibName: EmptyDividerViewCellTableViewCell.reusableIdentifier)
        self.tableView.registerCell(nibName: BookingInfoCommonCell.reusableIdentifier)
        self.tableView.registerCell(nibName: NightStateTableViewCell.reusableIdentifier)
        self.tableView.registerCell(nibName: FlightInfoTableViewCell.reusableIdentifier)
        
        self.tableView.registerCell(nibName: FlightTimeLocationInfoTableViewCell.reusableIdentifier)
        
        self.tableView.registerCell(nibName: AmentityTableViewCell.reusableIdentifier)
        self.tableView.registerCell(nibName: BookingTravellerTableViewCell.reusableIdentifier)
        self.tableView.registerCell(nibName: BookingTravellerDetailTableViewCell.reusableIdentifier)
        self.tableView.registerCell(nibName: RouteFareInfoTableViewCell.reusableIdentifier)
        
        self.tableView.registerCell(nibName: BookingRequestStatusTableViewCell.reusableIdentifier)
        
        // Traveller Addon TableViewCell
        self.tableView.registerCell(nibName: BookingTravellerAddOnsTableViewCell.reusableIdentifier)
        
        self.tableView.registerCell(nibName: FareInfoCommonCell.reusableIdentifier)
        self.tableView.registerCell(nibName: FareInfoCombineCell.reusableIdentifier)

        tableView.showsVerticalScrollIndicator = true
    }
    
}
