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
    
    @IBOutlet weak var topNavBar: TopNavigationView!
    @IBOutlet weak var passengerLabel: UILabel!
    @IBOutlet weak var reschedulingTableView: ATTableView!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceViewAndButtonContainerView: UIView!
    @IBOutlet weak var priceViewAndButtonContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var totalNetRefundLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var continueButton: ATButton!
    
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
        self.continueButton.addGredient(isVertical: false)
        self.setupTotalRefundAndCont()
        self.registerXib()
        self.setupNavBar()
        self.reschedulingTableView.dataSource = self
        self.reschedulingTableView.delegate = self
        self.reloadList()
        self.continueButton.addGredient(isVertical: false)
        self.continueButton.shouldShowPressAnimation = false
    }
    
    func registerXib() {
        self.reschedulingTableView.register(UINib(nibName: self.footerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.footerViewIdentifier)
        self.reschedulingTableView.register(UINib(nibName: self.headerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.headerViewIdentifier)
        self.reschedulingTableView.registerCell(nibName: AirlineTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: BookingSchedulingPassengerDetailTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: BookingSchedulingPassengerDetailTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: BookingReschedulingPassengerAccordionTableViewCell.reusableIdentifier)
    }
    
    override func setupNavBar() {
        self.topNavBar.delegate = self
        self.topNavBar.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.topNavBar.navTitleLabel.textColor = AppColors.themeBlack
        self.topNavBar.configureNavBar(title: self.viewModel.usingFor == .rescheduling ? LocalizedString.Rescheduling.localized : LocalizedString.Cancellation.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavBar.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Cancel.localized, selectedTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
    }
    
    override func setupFonts() {
        self.continueButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        self.passengerLabel.font = AppFonts.Regular.withSize(16.0)
        self.totalNetRefundLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.totalPriceLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupColors() {
        self.continueButton.setTitleColor(AppColors.themeWhite.withAlphaComponent(0.5), for: .normal)
        self.continueButton.setTitleColor(AppColors.themeWhite.withAlphaComponent(0.5), for: .selected)
        self.passengerLabel.textColor = AppColors.textFieldTextColor51
        self.totalNetRefundLabel.textColor = AppColors.themeBlack
        self.totalPriceLabel.textColor = AppColors.themeBlack
    }
    
    override func setupTexts() {
        self.totalNetRefundLabel.text = LocalizedString.TotalNetRefund.localized
        self.continueButton.setTitle(LocalizedString.Continue.localized, for: .normal)
        self.continueButton.setTitle(LocalizedString.Continue.localized, for: .selected)
    }
    
    // MARK: - Helper methods
    private func setupTotalRefundAndCont() {
        if self.viewModel.usingFor == .rescheduling {
            //hide price
            self.priceViewAndButtonContainerHeight.constant = 94.0
        }
        else {
            //show price
            self.updateTotalRefund()
            self.priceView.isHidden = false
            self.priceViewAndButtonContainerHeight.constant = 94.0
        }
    }
    
    private func updateTotalRefund() {
        let totalRef = self.viewModel.usingFor == .rescheduling ?  self.viewModel.totRefundForRescheduling : self.viewModel.totalRefundForCancellation
        self.continueButton.isUserInteractionEnabled = true//totalRef != 0.0
        self.totalPriceLabel.text = totalRef.delimiterWithSymbol
    }
    
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
                self.reloadList()
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
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        if self.viewModel.usingFor == .rescheduling {
            //rescheduling
            AppFlowManager.default.moveToRequestReschedulingVC(onNavController: self.navigationController, legs: self.viewModel.selectedLegs)
        }
        else {
            //cancellation
            AppFlowManager.default.moveToReviewCancellationVC(onNavController: self.navigationController, usingAs: .flightCancellationReview, legs: self.viewModel.legsData, selectedRooms: nil)
        }
    }
    
    private func collapseCell(_ cell: BookingReschedulingPassengerAccordionTableViewCell, animated: Bool) {
        if let indexPath = reschedulingTableView.indexPath(for: cell) {
            if !animated {
                cell.setExpanded(false, animated: false)
                self.removeFromExpandedIndexPaths(indexPath)
                self.reloadList()
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
        let legD = self.viewModel.legsData[indexPath.section]
        
        if indexPath.row < legD.flight.count {
            guard let airlineCell = self.reschedulingTableView.dequeueReusableCell(withIdentifier: "AirlineTableViewCell") as? AirlineTableViewCell else {
                fatalError("AirlineTableViewCell not found")
            }
            
            airlineCell.flightDetail = legD.flight[indexPath.row]
            
            return airlineCell
        }
        else {
            guard let bookingAccordionCell = self.reschedulingTableView.dequeueReusableCell(withIdentifier: "BookingReschedulingPassengerAccordionTableViewCell") as? BookingReschedulingPassengerAccordionTableViewCell else {
                fatalError("BookingReschedulingPassengerAccordionTableViewCell not found")
            }
            
            let index = indexPath.row -  legD.flight.count
            let paxD = legD.pax[index]
            
            let pnrNoStr = paxD.pnr.isEmpty ? paxD.status : paxD.pnr
            
            bookingAccordionCell.configureCell(passengerName: paxD.fullNameWithSalutation, pnrNo: pnrNoStr, saleValue: paxD.amountPaid.delimiterWithSymbol, cancellationCharge:self.viewModel.usingFor == .rescheduling ? paxD.rescheduleCharge.delimiterWithSymbol : paxD.cancellationCharge.delimiterWithSymbol, refundValue: self.viewModel.usingFor == .rescheduling ? paxD.netRefundForReschedule.delimiterWithSymbol : paxD.netRefundForCancellation.delimiterWithSymbol)
            bookingAccordionCell.delegate = self
            bookingAccordionCell.headerDividerView.isHidden = (legD.pax.count - 1) == (indexPath.row - (legD.flight.count))
            
            bookingAccordionCell.cancellationChargeLabel.text = self.viewModel.usingFor == .rescheduling ? LocalizedString.ReschedulingCharges.localized : LocalizedString.CancellationCharges.localized

            bookingAccordionCell.selectedTravellerButton.isSelected = false
            if legD.selectedPaxs.contains(where: { $0.paxId == paxD.paxId }) {
                bookingAccordionCell.selectedTravellerButton.isSelected = true
            }
            
            return bookingAccordionCell
        }
    }
    
    private func manageSelectionTitle() {
        var selectedCounts: [Int] = []
        
        for leg in self.viewModel.legsData {
            if !leg.selectedPaxs.isEmpty {
                selectedCounts.append(leg.selectedPaxs.count)
            }
        }
        
        if selectedCounts.isEmpty {
            self.continueButton.setTitleColor(AppColors.themeWhite.withAlphaComponent(0.5), for: .normal)
            self.passengerLabel.text = LocalizedString.SelectPassengerFlightRescheduled.localized
            self.priceView.isHidden = true
            self.priceViewAndButtonContainerHeight.constant = 50.0
        }
        else {
            self.continueButton.setTitleColor(AppColors.themeWhite.withAlphaComponent(1.0), for: .normal)
            let pasngTtl = ((selectedCounts.count == 1) && ((selectedCounts.first ?? 0) == 1)) ? LocalizedString.Passenger.localized : LocalizedString.Passengers.localized
            self.passengerLabel.text = "\(selectedCounts.joined(separator: ", ")) \(pasngTtl) \(LocalizedString.Selected.localized)"
            self.priceView.isHidden = false
            self.priceViewAndButtonContainerHeight.constant = 94.0
        }
    }
    
    func reloadList() {
        self.updateTotalRefund()
        self.manageSelectionTitle()
        self.reschedulingTableView.reloadData()
    }
}

// MARK: - Top Navigation View Delegate

extension BookingReschedulingVC: UITableViewDataSource, UITableViewDelegate {
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.legsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.legsData[section].flight.count + self.viewModel.legsData[section].pax.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getCellForSection(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < self.viewModel.legsData[indexPath.section].flight.count {
            return 60
        }
        else {
            return self.expandedIndexPaths.contains(indexPath) ? 144.5 : 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 67.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35.0
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
        
        let legD = self.viewModel.legsData[section]
        
        var infoData = ""
        if let dateStr = legD.eventStartDate?.toString(dateFormat: "dd MMM yyyy"), !dateStr.isEmpty {
            infoData += dateStr
        }
        
        var refundOrResch = ""
        if self.viewModel.usingFor == .rescheduling {
            refundOrResch = legD.reschedulable.toBool ? LocalizedString.Reschedulable.localized : LocalizedString.NonReschedulable.localized
        }
        else {
            refundOrResch = legD.refundable.toBool ? LocalizedString.Refundable.localized : LocalizedString.NonRefundable.localized
        }
        infoData += infoData.isEmpty ? refundOrResch : " | \(refundOrResch)"

        headerView.delegate = self
        headerView.selectedButton.isSelected = (legD.pax.count == legD.selectedPaxs.count)
        headerView.routeLabel.text = legD.title
        headerView.infoLabel.text = infoData
        headerView.selectedButton.tag = section
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
    }
}



// MARK: - TopNavigationView delegate

extension BookingReschedulingVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: - BookingRescheduling header tapped

extension BookingReschedulingVC: BookingReschedulingHeaderViewDelegate {
    func selectAllButtonAction(_ sender: UIButton) {
        var legD = self.viewModel.legsData.remove(at: sender.tag)
        
        if legD.pax.count == legD.selectedPaxs.count {
            //remove all
            legD.selectedPaxs.removeAll()
        }
        else {
            //select all
            legD.selectedPaxs = legD.pax
        }
        
        self.viewModel.legsData.insert(legD, at: sender.tag)
        self.reloadList()
    }
}

// MARK: - Booking arrowButton Accordion Tapped

extension BookingReschedulingVC: BookingReschedulingPassengerAccordionTableViewCellDelegate {
    func arrowButtonAccordionTapped(arrowButton: UIButton) {
        if let indexPath = self.reschedulingTableView.indexPath(forItem: arrowButton) {
            var legD = self.viewModel.legsData.remove(at: indexPath.section)
            let passenger = legD.pax[indexPath.row - legD.flight.count]
            
            if let index = legD.selectedPaxs.firstIndex(where: { $0.paxId == passenger.paxId }) {
                legD.selectedPaxs.remove(at: index)
            }
            else {
                legD.selectedPaxs.append(passenger)
            }
            
            self.viewModel.legsData.insert(legD, at: indexPath.section)
            self.reloadList()
        }
    }
}
