//
//  BookingReschedulingVC.swift
//  AERTRIP
//
//  Created by apple on 23/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingReschedulingVC: BaseVC {
    // MARK: - IBOutlet
    
    @IBOutlet var topNavBar: TopNavigationView!
    @IBOutlet var passengerLabel: UILabel!
    @IBOutlet var reschedulingTableView: ATTableView!
    
    // MARK: - Variables
    
    let footerViewIdentifier = "BookingInfoEmptyFooterView"
    let headerViewIdentifier = "BookingReschedulingHeaderView"
    let viewModel = BookingReschedulingVM()
    
    // TODO: -  Need to handle for dynamic cell handling  .
    var indexesForExpanded: [IndexPath] = [] // handling dynmaic cells
    
    var expandedIndexPaths = [IndexPath]() // Array for storing indexPath
    var isToggleAnimated = false // Maintain toogling off animation
    var shouldScrollIfNeededAfterCellExpand = true
    var expandCompletionHandler: () -> Void = {} // completion for expand
    var collapseCompletionHandler: () -> Void = {} // completion for collapse
    
    override func initialSetup() {
        self.registerXib()
        self.setupNavBar()
        self.setUpBookingPassengers()
        self.reschedulingTableView.dataSource = self
        self.reschedulingTableView.delegate = self
        self.reschedulingTableView.reloadData()
    }
    
    func registerXib() {
        self.reschedulingTableView.register(UINib(nibName: self.footerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.footerViewIdentifier)
        self.reschedulingTableView.register(UINib(nibName: self.headerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.headerViewIdentifier)
        self.reschedulingTableView.registerCell(nibName: AirlineTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: BookingSchedulingPassengerDetailTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: BookingPassengerTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: BookingSchedulingPassengerDetailTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: BookingReschedulingPassengerAccordionTableViewCell.reusableIdentifier)
    }
    
    override func setupNavBar() {
        self.topNavBar.delegate = self
        self.topNavBar.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.topNavBar.navTitleLabel.textColor = AppColors.themeBlack
        self.topNavBar.configureNavBar(title: LocalizedString.Rescheduling.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
        self.topNavBar.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Cancel.localized, selectedTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
    }
    
    override func setupFonts() {
        self.passengerLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupColors() {
        self.passengerLabel.textColor = AppColors.textFieldTextColor51
    }
    
    override func setupTexts() {
        self.passengerLabel.text = LocalizedString.SelectPassengerFlightRescheduled.localized
    }
    
    func setUpBookingPassengers() {
        for i in 0...2 {
            var passenger = BookingPassenger()
            passenger.id = "\(i)"
            passenger.name = "Mr. Alan McCarthy"
            passenger.isChecked = false
            passenger.isExpanded = false
            passenger.passengerDetails = ["SPF6LG", "₹ 27,000", "₹ 27,000", "₹ 27,000"]
            self.viewModel.passengers.append(passenger)
        }
    }
    
    // MARK: - Helper methods
    
    func toggleCell(_ cell: BookingReschedulingPassengerAccordionTableViewCell, animated: Bool) {
        if cell.expanded {
            self.collapseCell(cell, animated: animated)
        } else {
            self.expandCell(cell, animated: animated)
        }
    }
    
    private func expandCell(_ cell: BookingReschedulingPassengerAccordionTableViewCell, animated: Bool) {
        if let indexPath = reschedulingTableView.indexPath(for: cell) {
            if !animated {
                self.addToExpandedIndexPaths(indexPath)
                cell.setExpanded(true, animated: false)
                self.reschedulingTableView.reloadData()
                self.scrollIfNeededAfterExpandingCell(at: indexPath)
                self.expandCompletionHandler()
            } else {
                CATransaction.begin()
                
                CATransaction.setCompletionBlock { [weak self] in
                    self?.scrollIfNeededAfterExpandingCell(at: indexPath)
                    self?.expandCompletionHandler()
                }
                
                self.reschedulingTableView.beginUpdates()
                self.addToExpandedIndexPaths(indexPath)
                cell.setExpanded(true, animated: true)
                self.reschedulingTableView.endUpdates()
                
                CATransaction.commit()
            }
            cell.headerDividerView.isHidden = true
            cell.bottomDividerView.isHidden = false
        }
    }
    
    private func collapseCell(_ cell: BookingReschedulingPassengerAccordionTableViewCell, animated: Bool) {
        if let indexPath = reschedulingTableView.indexPath(for: cell) {
            if !animated {
                cell.setExpanded(false, animated: false)
                self.removeFromExpandedIndexPaths(indexPath)
                self.reschedulingTableView.reloadData()
                self.collapseCompletionHandler()
            } else {
                CATransaction.begin()
                
                CATransaction.setCompletionBlock { [weak self] in
                    self?.collapseCompletionHandler()
                }
                
                self.reschedulingTableView.beginUpdates()
                cell.setExpanded(false, animated: true)
                self.removeFromExpandedIndexPaths(indexPath)
                self.reschedulingTableView.endUpdates()
                
                CATransaction.commit()
            }
            cell.headerDividerView.isHidden = false
            cell.bottomDividerView.isHidden = true
        }
    }
    
    private func addToExpandedIndexPaths(_ indexPath: IndexPath) {
        self.expandedIndexPaths.append(indexPath)
    }
    
    private func removeFromExpandedIndexPaths(_ indexPath: IndexPath) {
        if let index = expandedIndexPaths.index(of: indexPath) {
            self.expandedIndexPaths.remove(at: index)
        }
    }
    
    private func scrollIfNeededAfterExpandingCell(at indexPath: IndexPath) {
        guard self.shouldScrollIfNeededAfterCellExpand,
            let cell = reschedulingTableView.cellForRow(at: indexPath) as? BookingReschedulingPassengerAccordionTableViewCell else {
            return
        }
        let cellRect = reschedulingTableView.rectForRow(at: indexPath)
        let isCompletelyVisible = reschedulingTableView.bounds.contains(cellRect)
        if cell.expanded, !isCompletelyVisible {
            self.reschedulingTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func getCellForSection(_ indexPath: IndexPath) -> UITableViewCell {
        //        guard let passengerCell = self.reschedulingTableView.dequeueReusableCell(withIdentifier: "BookingPassengerTableViewCell") as? BookingPassengerTableViewCell else {
        //            fatalError("BookingPassengerTableViewCell not found")
        //        }
        //
        //        guard let passengerDetailCell = self.reschedulingTableView.dequeueReusableCell(withIdentifier: "BookingSchedulingPassengerDetailTableViewCell") as? BookingSchedulingPassengerDetailTableViewCell else {
        //            fatalError("BookingSchedulingPassengerDetailTableViewCell not found")
        //        }
        
        //        passengerCell.delegate = self
        
        if indexPath.row < self.viewModel.airlinesDetail.count {
            guard let airlineCell = self.reschedulingTableView.dequeueReusableCell(withIdentifier: "AirlineTableViewCell") as? AirlineTableViewCell else {
                fatalError("AirlineTableViewCell not found")
            }
            
            airlineCell.configureCell(airlineName: "Air India", info: "AI - 348・Economy Saver")
            return airlineCell
        } else {
            //            if self.indexesForExpanded.count > 0  {
            //                for idxPath in self.indexesForExpanded {
            //                    if indexPath.row  < idxPath.row + self.indexesForExpanded.count * 4  {
            //                        passengerDetailCell.configureCell()
            //                        return passengerDetailCell
            //                    } else {
            //                        passengerCell.passenger = self.viewModel.passengers[(indexPath.row - self.viewModel.airlinesDetail.count - self.indexesForExpanded.count * 4)]
            //                        return passengerCell
            //                    }
            //                }
            //            }
            //            else {
            //                passengerCell.passenger = self.viewModel.passengers[indexPath.row - self.viewModel.airlinesDetail.count]
            //                return passengerCell
            //            }
            
            //
            guard let bookingAccordionCell = self.reschedulingTableView.dequeueReusableCell(withIdentifier: "BookingReschedulingPassengerAccordionTableViewCell") as? BookingReschedulingPassengerAccordionTableViewCell else {
                fatalError("BookingReschedulingPassengerAccordionTableViewCell not found")
            }
            
            let passenger = self.viewModel.passengers[indexPath.row - self.viewModel.airlinesDetail.count]
            bookingAccordionCell.configureCell(passengerName: self.viewModel.passengers[indexPath.row - self.viewModel.airlinesDetail.count].name, pnrNo: "SPF6LG", saleValue: "₹ 27,000", cancellationCharge: "₹ 27,000", refundValue: "₹ 27,000")
            bookingAccordionCell.delegate = self
            bookingAccordionCell.headerDividerView.isHidden = self.viewModel.passengers.count - 1 == indexPath.row - self.viewModel.airlinesDetail.count
            
            if self.viewModel.selectedPassenger.contains(passenger.id) {
                bookingAccordionCell.selectedTravellerButton.isSelected = true
            } else {
                bookingAccordionCell.selectedTravellerButton.isSelected = false
            }
            return bookingAccordionCell
        }
    }
}

// MARK: - Top Navigation View Delegate

extension BookingReschedulingVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.viewModel.airlinesDetail.count + self.viewModel.passengers.count + (self.indexesForExpanded.count * 4)
        return self.viewModel.airlinesDetail.count + self.viewModel.passengers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getCellForSection(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { if indexPath.row < 2 {
        return 60
    } else {
        return self.expandedIndexPaths.contains(indexPath) ? 144.5 : 44.0
    }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? BookingReschedulingPassengerAccordionTableViewCell {
            let expanded = expandedIndexPaths.contains(indexPath)
            cell.setExpanded(expanded, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = reschedulingTableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingReschedulingHeaderView else {
            fatalError(" BookingReschedulingHeaderView not  found")
        }
        
        headerView.delegate = self
        headerView.routeLabel.text = self.viewModel.sectionData[section].title
        headerView.infoLabel.text = self.viewModel.sectionData[section].info
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = self.reschedulingTableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as? BookingInfoEmptyFooterView else {
            fatalError("BookingInfoFooterView not found")
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? BookingReschedulingPassengerAccordionTableViewCell {
            self.toggleCell(cell, animated: self.isToggleAnimated)
        }
//        if let cell  = self.reschedulingTableView.cellForRow(at: indexPath) , cell is BookingPassengerTableViewCell {
//            printDebug("Passengers cell is tapped")
//            if self.indexesForExpanded.contains(indexPath) {
//                self.indexesForExpanded.remove(object: indexPath)
//            } else {
//                self.indexesForExpanded.append(indexPath)
//            }
//
//            self.reschedulingTableView.reloadData()
//        }
    }
}

// MARK: - TopNavigationView delegate

extension BookingReschedulingVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: - BookingRescheduling header tapped

extension BookingReschedulingVC: BookingReschedulingHeaderViewDelegate {
    func headerViewTapped(_ view: UITableViewHeaderFooterView) {
        printDebug("header view Tapped")
    }
}

// MARK: - PassengersCell delgate methods

extension BookingReschedulingVC: BookingPassengerTableViewCellDelegate {
    func arrowButtonTapped(arrowButton: UIButton) {
        printDebug("arrow Button tapped")
    }
}

// MARK: - Booking arrowButton Accordion Tapped

extension BookingReschedulingVC: BookingReschedulingPassengerAccordionTableViewCellDelegate {
    func arrowButtonAccordionTapped(arrowButton: UIButton) {
        if let indexPath = self.reschedulingTableView.indexPath(forItem: arrowButton) {
            let passenger = self.viewModel.passengers[indexPath.row - self.viewModel.airlinesDetail.count]
            if self.viewModel.selectedPassenger.contains(passenger.id) {
                self.viewModel.selectedPassenger.remove(object: passenger.id)
            } else {
                self.viewModel.selectedPassenger.append(passenger.id)
            }
        }
        self.reschedulingTableView.reloadData()
    }
}
