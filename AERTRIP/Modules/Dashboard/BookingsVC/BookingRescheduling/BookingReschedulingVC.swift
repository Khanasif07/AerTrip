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
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var topNavBar: TopNavigationView!
    @IBOutlet weak var passengerLabel: UILabel!
    @IBOutlet weak var reschedulingTableView: ATTableView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceViewAndButtonContainerView: UIView!
    @IBOutlet weak var priceViewAndButtonContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var totalNetRefundLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var continueButton: ATButton!
    @IBOutlet weak var headerContainer: UIView!
    
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarStyle = .darkContent
    }
    
    override func initialSetup() {
        self.reschedulingTableView.contentInset = UIEdgeInsets(top: headerContainer.height, left: 0, bottom: 0, right: 0)
        self.continueButton.isShadowColorNeeded = true
        self.continueButton.shadowColor = AppColors.clear
        self.priceViewAndButtonContainerView.backgroundColor = AppColors.clear
        self.setupTotalRefundAndCont()
        self.registerXib()
        self.setupNavBar()
        self.reschedulingTableView.dataSource = self
        self.reschedulingTableView.delegate = self
        self.reloadList()
        //self.continueButton.addGredient(isVertical: false)
        self.continueButton.shouldShowPressAnimation = false
        self.reschedulingTableView.backgroundColor = AppColors.themeGray04
        self.gradientView.addGredient(isVertical: false)
        self.selectAutometically()
        
    }
    
    func registerXib() {
        self.reschedulingTableView.register(UINib(nibName: self.footerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.footerViewIdentifier)
        self.reschedulingTableView.register(UINib(nibName: self.headerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.headerViewIdentifier)
        self.reschedulingTableView.registerCell(nibName: AirlineTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: BookingSchedulingPassengerDetailTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: BookingSchedulingPassengerDetailTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: BookingReschedulingPassengerAccordionTableViewCell.reusableIdentifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }
    
    override func setupNavBar() {
        self.topNavBar.delegate = self
        self.topNavBar.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.topNavBar.navTitleLabel.textColor = AppColors.themeBlack
        self.topNavBar.configureNavBar(title: self.viewModel.usingFor == .rescheduling ? LocalizedString.Rescheduling.localized : LocalizedString.Cancellation.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavBar.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Cancel.localized, selectedTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
    }
    
    override func setupFonts() {
        self.passengerLabel.font = AppFonts.Regular.withSize(16.0)
        self.totalNetRefundLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.totalPriceLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.continueButton.setTitleFont(font: AppFonts.SemiBold.withSize(20.0), for: .normal)
        self.continueButton.setTitleFont(font: AppFonts.SemiBold.withSize(20.0), for: .selected)
        self.continueButton.setTitleFont(font: AppFonts.SemiBold.withSize(20.0), for: .highlighted)
    }
    
    override func setupColors() {
        if (self.viewModel.legsData.first?.selectedPaxs.count == 0){//checked for pre selcted.
            self.continueButton.setTitleColor(AppColors.themeWhite.withAlphaComponent(0.5), for: .normal)
            self.continueButton.setTitleColor(AppColors.themeWhite.withAlphaComponent(0.5), for: .selected)
        }
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
    
    ///Select passenger autometically when journey have single leg with single passenger.
    private func selectAutometically(){
        if self.viewModel.legsData.count == 1 && self.viewModel.legsData.first?.pax.count == 1{
            self.viewModel.legsData[0].selectedPaxs = self.viewModel.legsData[0].pax
            self.reloadList()
        }
    }
    
    private func updateTotalRefund() {
        let totalRef = self.viewModel.usingFor == .rescheduling ?  self.viewModel.totRefundForRescheduling : self.viewModel.totalRefundForCancellation
        self.continueButton.isUserInteractionEnabled = true//totalRef != 0.0
//        self.totalPriceLabel.text = totalRef.delimiterWithSymbol
        self.totalPriceLabel.attributedText = self.getConvertedPrice(for: totalRef, with: self.viewModel.bookingDetails?.bookingCurrencyRate, using: AppFonts.SemiBold.withSize(18), isForCancellation: true)
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
            let legD = self.viewModel.legsData[indexPath.section]
            let index = indexPath.row -  legD.flight.count
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
            cell.bottomDividerView.isHidden = (index == legD.pax.count - 1)//true
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any)
    {
        var selectedCounts: [Int] = []
        
        for leg in self.viewModel.legsData {
            if !leg.selectedPaxs.isEmpty {
                selectedCounts.append(leg.selectedPaxs.count)
            }
        }
        
        if !selectedCounts.isEmpty {
            if self.viewModel.usingFor == .rescheduling {
                //rescheduling
                AppFlowManager.default.moveToRequestReschedulingVC(onNavController: self.navigationController, legs: self.viewModel.selectedLegs, isOnlyReturn: self.checkOnlyReturnIsSelected())
            }
            else {
                //cancellation
                if self.viewModel.checkNumberOfRemainingAdtIsGreaterInf(){
                    AppFlowManager.default.moveToReviewCancellationVC(onNavController: self.navigationController, usingAs: .flightCancellationReview, legs: self.viewModel.legsData, selectedRooms: nil, bookingDetails: self.viewModel.bookingDetails, isForflightCancellation: true)
                }else{
                    CustomToast.shared.showToast("Number of remaining infants cannot be more than remaining adults")
                }
                
            }
        }
        
    }
    
    
    private func checkOnlyReturnIsSelected() -> Bool{
        
        if self.viewModel.selectedLegs.count < self.viewModel.legsData.count{
            return !self.viewModel.selectedLegs.contains(where: {$0.legId == (self.viewModel.legsData.first?.legId ?? "")})
        }else{
            return false
        }
        
    }
    
    private func collapseCell(_ cell: BookingReschedulingPassengerAccordionTableViewCell, animated: Bool) {
        if let indexPath = reschedulingTableView.indexPath(for: cell) {
            let legD = self.viewModel.legsData[indexPath.section]
            let index = indexPath.row - legD.flight.count
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
            cell.headerDividerView.isHidden = (index == legD.pax.count - 1)
            cell.bottomDividerView.isHidden = true
        }
    }
    
    private func addToExpandedIndexPaths(_ indexPath: IndexPath) {
        self.expandedIndexPaths.append(indexPath)
    }
    
    private func removeFromExpandedIndexPaths(_ indexPath: IndexPath) {
        if let index = expandedIndexPaths.firstIndex(of: indexPath) {
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
            
            var pnrNoStr = paxD.pnr.isEmpty ? paxD.status : paxD.pnr
            if pnrNoStr.lowercased() == "pending"
            {
                pnrNoStr = pnrNoStr.capitalizedFirst()
            }
            var age = ""
            if !paxD.dob.isEmpty {
                age = AppGlobals.shared.getAgeLastString(dob: paxD.dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            }
            let cancelationValue = self.viewModel.usingFor == .rescheduling ? paxD.rescheduleCharge : paxD.cancellationCharge
            var cancelationValueText =  ""
            var saleValue = ""
            if self.viewModel.usingFor == .rescheduling{
                saleValue = self.getConvertedPrice(for: paxD.amountPaid, with: self.viewModel.bookingDetails?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16), isForCancellation: false).string //paxD.amountPaid.amountInDelimeterWithSymbol
                cancelationValueText = self.getConvertedPrice(for: paxD.rescheduleCharge, with: self.viewModel.bookingDetails?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16), isForCancellation: true).string //paxD.rescheduleCharge.amountInDelimeterWithSymbol
            }else{
                saleValue = self.getConvertedPrice(for: paxD.amountPaid, with: self.viewModel.bookingDetails?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16), isForCancellation: false).string
                    //(paxD.amountPaid - paxD.reversalMFPax).amountInDelimeterWithSymbol
                cancelationValueText = self.getConvertedPrice(for: paxD.rescheduleCharge, with: self.viewModel.bookingDetails?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16), isForCancellation: true).string
                //paxD.cancellationCharge.amountInDelimeterWithSymbol
            }
            if cancelationValue == -9{
                cancelationValueText = "NA"
            }else if cancelationValue == -1{
                cancelationValueText = self.viewModel.usingFor == .rescheduling ? "Not Permitted" : "Non-refundable"
            }else if cancelationValue == 0{
                cancelationValueText = self.viewModel.usingFor == .rescheduling ? "Free Rescheduling" : "Free Cancellation"
            }else if (((paxD.amountPaid - paxD.reversalMFPax) < paxD.cancellationCharge) && (self.viewModel.usingFor == .cancellation)){
                cancelationValueText =  "Non-refundable"
            }
            
            
            let refundValue:String
            if self.viewModel.usingFor == .rescheduling{
                refundValue = self.getConvertedPrice(for: paxD.netRefundForReschedule, with: self.viewModel.bookingDetails?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16), isForCancellation: false).string
            }else{
                refundValue = self.getConvertedPrice(for: paxD.netRefundForCancellation, with: self.viewModel.bookingDetails?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16), isForCancellation: false).string
            }
            
            bookingAccordionCell.configureCell(passengerName: paxD.paxName, pnrNo: pnrNoStr, saleValue: saleValue, cancellationCharge: cancelationValueText, refundValue: refundValue,  age: age)
            bookingAccordionCell.delegate = self
            
            bookingAccordionCell.cancellationChargeLabel.text = self.viewModel.usingFor == .rescheduling ? LocalizedString.ReschedulingCharges.localized : LocalizedString.CancellationCharges.localized

            bookingAccordionCell.selectedTravellerButton.isSelected = false
            if legD.selectedPaxs.contains(where: { $0.paxId == paxD.paxId }) {
                bookingAccordionCell.selectedTravellerButton.isSelected = true
            }
            //expandedIndexPaths
            bookingAccordionCell.headerDividerView.isHidden = (self.expandedIndexPaths.contains(indexPath) || (index == legD.pax.count - 1))
            bookingAccordionCell.bottomDividerView.isHidden = ((index == legD.pax.count - 1) || !self.expandedIndexPaths.contains(indexPath))
            bookingAccordionCell.selectedTravellerButton.isEnabled = !(paxD.inProcess)
            bookingAccordionCell.passengerNameLabel.isEnabled = !(paxD.inProcess)
            bookingAccordionCell.togglePaxDetails(hidden: paxD.inProcess)
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
            
            self.passengerLabel.text = self.viewModel.usingFor == .rescheduling ? LocalizedString.SelectPassengerFlightRescheduled.localized : LocalizedString.SelectPassengerFlightCancellation.localized
            self.priceView.isHidden = true
            self.priceViewAndButtonContainerHeight.constant = 50.0
        }
        else {
            self.continueButton.setTitleColor(AppColors.themeWhite.withAlphaComponent(1.0), for: .normal)
            let pasngTtl = ((selectedCounts.count == 1) && ((selectedCounts.first ?? 0) == 1)) ? LocalizedString.Passenger.localized : LocalizedString.Passengers.localized
            self.passengerLabel.text = "\(selectedCounts.joined(separator: ", ")) \(pasngTtl) \(LocalizedString.Selected.localized)"
            self.priceView.isHidden = true //false
            self.priceViewAndButtonContainerHeight.constant = 50.0//94.0
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
            return self.expandedIndexPaths.contains(indexPath) ? UITableView.automaticDimension : 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
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

            // To check all the pax cancellation amount is greater than cell amount.
            var isNonRefundable = true
            for paxD in legD.pax{
                if ((paxD.amountPaid - paxD.reversalMFPax) > paxD.cancellationCharge){
                    isNonRefundable = false
                }
            }
            
            refundOrResch = (!legD.refundable.toBool || isNonRefundable) ? LocalizedString.NonRefundable.localized : LocalizedString.Refundable.localized
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
        footerView.bottomDividerView.isHidden = (self.viewModel.legsData.count - 1) == section
        footerView.topDividerTopConstraints.constant = 0.2
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
            legD.selectedPaxs = legD.pax.filter({!($0.inProcess)})
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
