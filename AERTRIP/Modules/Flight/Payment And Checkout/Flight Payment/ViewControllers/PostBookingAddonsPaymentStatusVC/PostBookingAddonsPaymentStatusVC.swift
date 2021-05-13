//
//  PostBookingAddonsPaymentStatusVC.swift
//  AERTRIP
//
//  Created by Apple  on 19.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class PostBookingAddonsPaymentStatusVC: BaseVC {
    
    @IBOutlet weak var paymentTable: ATTableView!{
        didSet{
            self.paymentTable.contentInset = UIEdgeInsets.zero
            self.paymentTable.delegate = self
            self.paymentTable.dataSource = self
            self.paymentTable.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.paymentTable.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.paymentTable.backgroundColor = AppColors.screensBackground.color
        }
    }
    @IBOutlet weak var returnHomeButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressViewHeight: NSLayoutConstraint!
    
    var viewModel = PostBookingAddonsPaymentStatusVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.setupReturnHomeButton()
        self.viewModel.delegate = self
        self.viewModel.getBookingReceipt()
        self.returnHomeButton.addGredient(isVertical: false)
        self.progressView.progressTintColor = UIColor.AertripColor
        self.progressView.trackTintColor = .clear
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }
    
    
    func registerCell(){
        self.paymentTable.registerCell(nibName: SeatBookingStatusCell.reusableIdentifier)
        self.paymentTable.register(UINib(nibName: "SelectSeatButtonFooterVew", bundle: nil), forHeaderFooterViewReuseIdentifier: "SelectSeatButtonFooterVew")
        self.paymentTable.registerCell(nibName: BookingPaymentDetailsTableViewCell.reusableIdentifier)
        self.paymentTable.registerCell(nibName: TravellersPnrStatusTableViewCell.reusableIdentifier)
        self.paymentTable.registerCell(nibName: ApplyCouponTableViewCell.reusableIdentifier)
        self.paymentTable.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.paymentTable.registerCell(nibName: AddonsPassangerCell.reusableIdentifier)
        self.paymentTable.registerCell(nibName: AddonsPassengerTitleCell.reusableIdentifier)
    }
    
    func showProgressView(){
        UIView.animate(withDuration: 2) {
            self.progressView.isHidden = false
            self.progressViewHeight.constant = 1
        }
    }
    
    func hideProgressView(){
        UIView.animate(withDuration: 2) {
            self.progressViewHeight.constant = 0
            self.progressView.isHidden = true
        }
    }
    
    private func setupReturnHomeButton() {
        self.returnHomeButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        self.returnHomeButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.returnHomeButton.setTitle("Return Home", for: .normal)
    }
    
    func openActionSeat(){
        if self.viewModel.bookingIds.count > 1{
            let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: self.viewModel.availableSeatMaps.map{$0.name}, colors: self.viewModel.availableSeatMaps.map{$0.isSelectedForall ? AppColors.themeGray40 : AppColors.themeGreen})
            let cencelBtn = PKAlertButton(title: LocalizedString.Cancel.localized, titleColor: AppColors.themeDarkGreen,titleFont: AppFonts.SemiBold.withSize(20))
            _ = PKAlertController.default.presentActionSheet("Select Seats for…",titleFont: AppFonts.SemiBold.withSize(14), titleColor: AppColors.themeGray40, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: cencelBtn) { [weak self] _, index in
                guard let self = self else {return}
                let bookingId = self.viewModel.availableSeatMaps[index].bookingId
                self.instantiateSeatMapVC(bookingId)
            }
        }else{
            if let bookingId = self.viewModel.bookingIds.first{
                self.instantiateSeatMapVC(bookingId)
            }
        }
        
    }
    
    
    func openActionSheetForBooking(){
        if self.viewModel.bookingIds.count > 1{
            let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: self.viewModel.availableSeatMaps.map{$0.name}, colors: self.viewModel.availableSeatMaps.map{$0.isSelectedForall ? AppColors.themeGray40 : AppColors.themeGreen})
            let cencelBtn = PKAlertButton(title: LocalizedString.Cancel.localized, titleColor: AppColors.themeDarkGreen,titleFont: AppFonts.SemiBold.withSize(20))
            _ = PKAlertController.default.presentActionSheet("Get Booking Details for...",titleFont: AppFonts.SemiBold.withSize(14), titleColor: AppColors.themeGray40, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: cencelBtn) { [weak self] _, index in
                guard let self = self else {return}
                self.openBookingDetails(for: index)
            }
        }else{
            if self.viewModel.bookingIds.first != nil{
                self.openBookingDetails(for: 0)
            }
        }
    }
    
    private func openBookingDetails(for index: Int){
        
        var bookingId = ""
        if index < self.viewModel.bookingDetails.count{
            if let booking = self.viewModel.bookingDetails[index]{
                bookingId = booking.id
            }else{
                return
            }
        }else{
            if let booking = self.viewModel.bookingDetails.first{
                bookingId = booking?.id ?? ""
            }else{
                return
            }
        }
        let tripCity = NSMutableAttributedString(string: self.viewModel.availableSeatMaps[index].name)
        AppFlowManager.default.moveToFlightBookingsDetailsVC(bookingId: bookingId, tripCitiesStr: tripCity)
//        AppFlowManager.default.moveToBookingDetail(bookingDetail: bookingModel, tripCities: tripCity, legSectionTap: index)
    }
    
    
    @IBAction func tapReturnToHomeButton(_ sender: UIButton) {
        AppFlowManager.default.flightReturnToHomefrom(self)
        self.viewModel.logEvents(with: .TapOnReturnToHomeButton)
    }
    
    
    private func instantiateSeatMapVC(_ bookingId: String) {
        let vc = SeatMapContainerVC.instantiate(fromAppStoryboard: .Rishabh_Dev)
        var flightLegs = [BookingLeg]()
        var addOnsArr = [BookingAddons]()
        viewModel.bookingDetails.forEach { (bookingModel) in
            if let bookingMod = bookingModel, let bookingDet = bookingMod.bookingDetail {
                flightLegs.append(contentsOf: bookingDet.leg)
            }
            if let addOns = bookingModel?.bookinAddons {
                addOnsArr.append(contentsOf: addOns)
            }
        }
        vc.setBookingFlightLegsAndAddOns(flightLegs, addOnsArr)
        vc.setupFor(.postSelection, bookingId)
        let nav = AppFlowManager.default.getNavigationController(forPresentVC: vc)
        nav.setNavigationBarHidden(true, animated: false)
        nav.modalPresentationStyle = .overFullScreen
        //        vc.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
}


extension PostBookingAddonsPaymentStatusVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionData.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sectionData[section].count
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == (self.viewModel.sectionData.count - 2)) ? UITableView.automaticDimension : CGFloat.leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (section == (self.viewModel.sectionData.count - 2)){
            guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SelectSeatButtonFooterVew") as? SelectSeatButtonFooterVew else { return nil }
            if self.viewModel.bookingIds.count > 1{
                footerView.selectSeatButton.setTitle("Select Seats for...", for: .normal)
            }else{
                 footerView.selectSeatButton.setTitle("Select Seats", for: .normal)
            }
            footerView.handeller = {[weak self] in
                self?.viewModel.logEvents(with: .TapOnSelectSeat)
                self?.openActionSeat()
            }
            footerView.dividerView.isHidden = true
            return footerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.viewModel.sectionData[indexPath.section][indexPath.row]{
        case .empty: return 35.0
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.viewModel.sectionData[indexPath.section][indexPath.row]{
        case .seatBooked:
            return self.getCellForSeatBooked(indexPath)
        case .empty:
            return self.getCellEmptyCell(indexPath)
        case .passenger:
            return self.getCellForPassenger(indexPath)
        case .flightTitle:
            return self.getCellForFlightTitle(indexPath)
        case .accessBooking:
            return self.getCellForAccessBooking(indexPath)

        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.viewModel.sectionData[indexPath.section][indexPath.row]{
        case .accessBooking:
            self.openActionSheetForBooking()
            self.viewModel.logEvents(with: .TapOnAccessThisBooking)
        default: break
            
        }
    }
    
    
    func getCellForSeatBooked(_ indexPath: IndexPath)-> UITableViewCell{
        guard let cell = self.paymentTable.dequeueReusableCell(withIdentifier: SeatBookingStatusCell.reusableIdentifier, for: indexPath) as? SeatBookingStatusCell else { return UITableViewCell() }
        cell.configCell(forBookingId: "", forCid: LocalizedString.na.localized, isBookingPending: false)

        return cell
    }
    
    func getCellEmptyCell(_ indexPath: IndexPath)-> UITableViewCell{
        guard let emptyCell = self.paymentTable.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier, for: indexPath) as? EmptyTableViewCell else {
            printDebug("Cell not found")
            return UITableViewCell()
        }
        emptyCell.clipsToBounds = true
        if ((self.viewModel.sectionData.count - 1) == indexPath.section) && (self.viewModel.sectionData[indexPath.section].count-1 == indexPath.row){
            emptyCell.bottomDividerView.isHidden = true
        }
        return emptyCell
    }
    
    
    func getCellForPassenger(_ indexPath: IndexPath)-> UITableViewCell{
        guard let cell = self.paymentTable.dequeueReusableCell(withIdentifier: AddonsPassangerCell.reusableIdentifier) as? AddonsPassangerCell else {return UITableViewCell()}
        let pnr = self.viewModel.cellDataToShow[indexPath.section - 1][indexPath.row].addonPax.addon.seat.name
        let islast = (indexPath.row == (self.viewModel.cellDataToShow[indexPath.section - 1].count - 1))
        if let pax = self.viewModel.cellDataToShow[indexPath.section - 1][indexPath.row].pax{
            
            cell.configCell(travellersImage: pax.profileImage, travellerName: "\(pax.firstName) \(pax.lastName)", travellerPnrStatus: pnr, firstName: (pax.firstName), lastName: (pax.lastName), isLastTraveller: islast,paxType: "", dob: pax.dob, salutation: pax.salutation)
            
        }else{
            
            let pax = self.viewModel.cellDataToShow[indexPath.section - 1][indexPath.row].addonPax
            cell.configCell(travellersImage: "", travellerName: "\(pax.salutation) \(pax.firstName) \(pax.lastName)", travellerPnrStatus: pnr, firstName: (pax.firstName), lastName: (pax.lastName), isLastTraveller: islast,paxType: "", dob: "", salutation: pax.salutation)
            
        }
        
        cell.clipsToBounds = true
        return cell
    }
    
    
    func getCellForFlightTitle(_ indexPath: IndexPath)-> UITableViewCell{
        guard let cell = self.paymentTable.dequeueReusableCell(withIdentifier: AddonsPassengerTitleCell.reusableIdentifier) as? AddonsPassengerTitleCell else {return UITableViewCell()}
        
        let title = self.viewModel.cellDataToShow[indexPath.section - 1][indexPath.row].flight.route
        cell.configCell(title: title, type: "Seat")
        return cell
    }
    
    
    func getCellForAccessBooking(_ indexPath: IndexPath)-> UITableViewCell{
        guard let applyCouponCell = self.paymentTable.dequeueReusableCell(withIdentifier: ApplyCouponTableViewCell.reusableIdentifier, for: indexPath) as? ApplyCouponTableViewCell else {
            return UITableViewCell()
        }
        applyCouponCell.couponView.isHidden = true
        applyCouponCell.couponLabel.text = "Access this booking"
        return applyCouponCell
    }
    
    
}
extension PostBookingAddonsPaymentStatusVC : FlightPaymentBookingStatusVMDelegate{
    
    func getBookingResponseWithIndex(success: Bool) {
        let val = Double(self.progressView.progress) + self.viewModel.perAPIPersentage
        UIView.animate(withDuration: 0.5) {
            self.progressView.setProgress(Float(val), animated: true)
        }

    }
    
    
    func willGetBookingReceipt() {
        self.view.isUserInteractionEnabled = false
        self.progressView.setProgress(0, animated: false)
        self.showProgressView()
        delay(seconds: 0.2) {
            UIView.animate(withDuration: 0.5) {
                self.progressView.setProgress(0.20, animated: true)
            }
        }
    }
    
    func getBookingReceiptSuccess() {
        let val = Double(self.progressView.progress) + self.viewModel.perAPIPersentage
        UIView.animate(withDuration: 0.5) {
            self.progressView.setProgress(Float(val), animated: true)
        }
        self.viewModel.getBookingDetail()
        self.viewModel.getSectionData()
        self.paymentTable.reloadData()
    }
    
    func getBookingReceiptFail(error: ErrorCodes) {
        self.view.isUserInteractionEnabled = true
        self.hideProgressView()
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
    }
    
    func willGetBookingDetail() {
        
    }
    
    func getBookingDetailSuccess() {
        self.view.isUserInteractionEnabled = true
        self.viewModel.getSectionData()
        self.paymentTable.reloadData()
        self.hideProgressView()
    }
    
    func getBookingDetailFailure(error: ErrorCodes) {
        self.view.isUserInteractionEnabled = true
        self.hideProgressView()
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
    }
}
