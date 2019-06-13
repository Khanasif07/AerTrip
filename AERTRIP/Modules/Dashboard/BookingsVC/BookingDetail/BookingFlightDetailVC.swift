//
//  BookingFlightDetailVC.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

enum BookingDetailType {
    case flightInfo
    case baggage
    case fareInfo
}


class BookingFlightDetailVC: BaseVC {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var topNavigationView: TopNavigationView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: ATTableView!
    
    // MARK: - Variables
    let headerViewIdentifier = "BookingInfoHeaderView"
    let footerViewIdentifier = "BookingInfoEmptyFooterView"
    let fareInfoHeaderViewIdentifier = "FareInfoHeaderView"
    var bookingDetailType: BookingDetailType = .flightInfo
    var calculatedIndexForShowingFlightDetails: Int = 0
    var calculatedTotalRows: Int = 0
    
    let viewModel = BookingDetailVM()
    
    override func initialSetup() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setUpSegmentControl()
        self.registerXib()
        self.reloadDetails()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    
    private func configureNavBar() {
        
        self.topNavigationView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
        self.topNavigationView.navTitleLabel.attributedText = self.viewModel.tripCitiesStr
        self.topNavigationView.delegate = self
    }
    
    
    private func setUpSegmentControl() {
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
    }
    
    private func registerXib() {
        self.tableView.register(UINib(nibName: self.headerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.headerViewIdentifier)
        self.tableView.register(UINib(nibName: self.fareInfoHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.fareInfoHeaderViewIdentifier)
        self.tableView.register(UINib(nibName: self.footerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.footerViewIdentifier)
        self.tableView.registerCell(nibName: BaggageAirlineInfoTableViewCell.reusableIdentifier)
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
        
        // Traveller Addon TableViewCell
        self.tableView.registerCell(nibName: BookingTravellerAddOnsTableViewCell.reusableIdentifier)
    }
    
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.bookingDetailType = .flightInfo
        case 1:
            printDebug("Baggage  tapped")
            self.bookingDetailType = .baggage
        case 2:
            printDebug("Fare info tapped")
            self.bookingDetailType = .fareInfo
            self.tableView.estimatedRowHeight = UITableView.automaticDimension
            self.tableView.rowHeight = UITableView.automaticDimension
        default:
            printDebug("Tapped")
        }
        self.reloadDetails()
    }
    
    func reloadDetails() {
        self.configureNavBar()
        self.tableView.reloadData()
    }
}


// MARK: - Top Navigation View Delegate

extension BookingFlightDetailVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.mainNavigationController.popViewController(animated: true)
    }
}

// MARK: - Fare Info header view Delegate

extension BookingFlightDetailVC: FareInfoHeaderViewDelegate {
    func fareButtonTapped() {
        printDebug("fare info butto n tapped")
        AppFlowManager.default.presentBookingFareInfoDetailVC()
    }
}



