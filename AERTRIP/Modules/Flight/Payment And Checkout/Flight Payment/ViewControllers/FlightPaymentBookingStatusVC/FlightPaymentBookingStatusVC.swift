//
//  FlightPaymentBookingStatusVC.swift
//  AERTRIP
//
//  Created by Apple  on 04.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightPaymentBookingStatusVC: BaseVC {

    
    @IBOutlet weak var statusTableView: ATTableView!{
        didSet{
            self.statusTableView.contentInset = UIEdgeInsets.zero
            self.statusTableView.delegate = self
            self.statusTableView.dataSource = self
            self.statusTableView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.statusTableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.statusTableView.backgroundColor = AppColors.screensBackground.color
        }
    }
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var returnHomeButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressViewHeight: NSLayoutConstraint!
    
    var viewModel = FlightPaymentBookingStatusVM()
    var backView:RetryView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func initialSetup() {
        super.initialSetup()
        FirebaseEventLogs.shared.logEventsWithoutParam(with: .OpenFlightReceipt)
        self.viewModel.delegate = self
        self.viewModel.getBookingReceipt()
        self.registerCell()
        self.statusTableView.separatorStyle = .none
        self.setupReturnHomeButton()
        self.returnHomeButton.addGredient(isVertical: false)
        self.setBackgroundView()
        self.progressView.progressTintColor = UIColor.AertripColor
        self.progressView.trackTintColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func registerCell(){
        
        self.statusTableView.registerCell(nibName: YouAreAllDoneTableViewCell.reusableIdentifier)
        self.statusTableView.registerCell(nibName: EventAdddedTripTableViewCell.reusableIdentifier)
        self.statusTableView.register(UINib(nibName: "HCBookingDetailsTableViewHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HCBookingDetailsTableViewHeaderFooterView")
        self.statusTableView.register(UINib(nibName: "SelectSeatButtonFooterVew", bundle: nil), forHeaderFooterViewReuseIdentifier: "SelectSeatButtonFooterVew")
        self.statusTableView.registerCell(nibName: FlightCarriersTableViewCell.reusableIdentifier)
        self.statusTableView.registerCell(nibName: FlightBoardingAndDestinationTableViewCell.reusableIdentifier)
        self.statusTableView.registerCell(nibName: BookingPaymentDetailsTableViewCell.reusableIdentifier)
        self.statusTableView.registerCell(nibName: TravellersPnrStatusTableViewCell.reusableIdentifier)
        self.statusTableView.registerCell(nibName: HCTotalChargeTableViewCell.reusableIdentifier)
        self.statusTableView.registerCell(nibName: HCConfirmationVoucherTableViewCell.reusableIdentifier)
        self.statusTableView.registerCell(nibName: HCWhatNextTableViewCell.reusableIdentifier)
    }

  private func setupReturnHomeButton() {
      self.returnHomeButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
      self.returnHomeButton.setTitleColor(AppColors.themeWhite, for: .normal)
      self.returnHomeButton.setTitle("Return Home", for: .normal)
  }
    @IBAction func returnHomeButtonTapped(_ sender: UIButton) {
        AppFlowManager.default.flightReturnToHomefrom(self)
//        let vc = FlightPaymentPendingVC.instantiate(fromAppStoryboard: .FlightPayment)
//        self.navigationController?.pushViewController(vc, animated: true)
//        self.navigationController?.popViewController(animated: true)
        
    }
    
    func setBackgroundView(){
        
        let backView = Bundle.main.loadNibNamed("RetryView", owner: self, options: nil)?.first as? RetryView
        self.backView = backView
        self.backView?.retryButton.addTarget(self, action: #selector(tapRetry), for: .touchUpInside)
        
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
    
    func openActionSeat(){
        if self.viewModel.apiBookingIds.count > 1{
            let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: self.viewModel.availableSeatMaps.map{$0.name}, colors: self.viewModel.availableSeatMaps.map{$0.isSelectedForall ? AppColors.themeGray40 : AppColors.themeGreen})
            let cencelBtn = PKAlertButton(title: LocalizedString.Cancel.localized, titleColor: AppColors.themeDarkGreen,titleFont: AppFonts.SemiBold.withSize(20))
            _ = PKAlertController.default.presentActionSheet("Select Seats for…",titleFont: AppFonts.SemiBold.withSize(14), titleColor: AppColors.themeGray40, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: cencelBtn) { [weak self] _, index in
                guard let self = self else {return}
                let bookingId = self.viewModel.availableSeatMaps[index].bookingId
                self.instantiateSeatMapVC(bookingId)
            }
        }else{
            if let bookingId = self.viewModel.apiBookingIds.first{
                self.instantiateSeatMapVC(bookingId)
            }
        }
    }
    
    private func instantiateSeatMapVC(_ bookingId: String) {
        let vc = SeatMapContainerVC.instantiate(fromAppStoryboard: .Rishabh_Dev)
        var flightLegs = [BookingLeg]()
        var addOnsArr = [BookingAddons]()
        viewModel.bookingDetail.forEach { (bookingModel) in
            if let bookingMod = bookingModel, let bookingDet = bookingMod.bookingDetail {
                flightLegs.append(contentsOf: bookingDet.leg)
            }
            if let addOns = bookingModel?.bookinAddons {
                addOnsArr.append(contentsOf: addOns)
            }
        }
        vc.setBookingFlightLegsAndAddOns(flightLegs, addOnsArr)
        vc.setupFor(.postSelection, bookingId)
        vc.viewModel.bookingIds = self.viewModel.availableSeatMaps.map{$0.bookingId}
        let nav = AppFlowManager.default.getNavigationController(forPresentVC: vc)
        nav.setNavigationBarHidden(true, animated: false)
        nav.modalPresentationStyle = .overFullScreen
//        vc.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
}


extension FlightPaymentBookingStatusVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sectionData[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 1) ? 54 : CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HCBookingDetailsTableViewHeaderFooterView") as? HCBookingDetailsTableViewHeaderFooterView else { return nil }
            headerView.delegate = self
            return headerView
        } else {
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == (self.viewModel.sectionData.count - 2) && self.viewModel.isSeatSettingAvailable) ? UITableView.automaticDimension : CGFloat.leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (section == (self.viewModel.sectionData.count - 2) && self.viewModel.isSeatSettingAvailable){
            guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SelectSeatButtonFooterVew") as? SelectSeatButtonFooterVew else { return nil }
            if self.viewModel.apiBookingIds.count > 1{
                footerView.selectSeatButton.setTitle("Select Seats for...", for: .normal)
            }else{
                 footerView.selectSeatButton.setTitle("Select Seats", for: .normal)
            }
            footerView.handeller = {
                self.openActionSeat()
            }
            return footerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = self.viewModel.sectionData[indexPath.section]
        switch sectionData[indexPath.row]{
        case .allDoneCell:
            return self.getAllDoneCell(indexPath)
        case .eventSharedCell:
            return self.getEventSharedCell(indexPath)
        case .carriersCell:
            return self.getCarriarTableCell(indexPath)
        case .legInfoCell:
            return self.getLegInfoCell(indexPath)
        case .BookingPaymentCell:
            return getTravellerStatusHeader(indexPath)
        case .pnrStatusCell:
            return getTravellerCell(indexPath)
        case .totalChargeCell:
            return self.getTotalChargeCell(indexPath)
        case .confirmationHeaderCell:
            return self.getConfirmationVoucherHealderCell(indexPath)
        case .confirmationVoucherCell:
            return self.getConfirmationVoucherCell(indexPath)
        case .whatNextCell:
            return self.getWhatNextCell(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 && (indexPath.section < (self.viewModel.sectionData.count - 1)){
            let tripCities = (self.viewModel.bookingObject?.titleString.mutableCopy() as? NSMutableAttributedString) ?? NSMutableAttributedString(string: "")
            var bookingModel:BookingDetailModel?
            if (indexPath.section - 1) < self.viewModel.bookingDetail.count{
                if let booking = self.viewModel.bookingDetail[indexPath.section - 1]{
                    bookingModel = booking
                }else{
                    return
                }
            }else{
                if let booking = self.viewModel.bookingDetail.first{
                    bookingModel = booking
                }else{
                    return
                }
            }
            AppFlowManager.default.moveToBookingDetail(bookingDetail: bookingModel, tripCities: tripCities, legSectionTap: (indexPath.section - 1))
        }
    }
    
}

extension FlightPaymentBookingStatusVC: FlightPaymentBookingStatusVMDelegate{
    
    func willGetBookingDetail() {
        
    }
    
    func getBookingDetailSuccess() {
        self.view.isUserInteractionEnabled = true
        self.statusTableView.reloadData()
        self.hideProgressView()
    }
    
    func getBookingDetailFailure(error: ErrorCodes) {
        self.view.isUserInteractionEnabled = true
        self.hideProgressView()
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
    }
    
    
    func getBookingReceiptSuccess(){
        let val = Double(self.progressView.progress) + self.viewModel.perAPIPersentage
        UIView.animate(withDuration: 0.5) {
            self.progressView.setProgress(Float(val), animated: true)
        }
        if !self.viewModel.apiBookingIds.isEmpty{
            self.viewModel.getBookingDetail()
        }else{
            self.view.isUserInteractionEnabled = true
            self.hideProgressView()
        }
        self.viewModel.getSectionData()
        self.statusTableView.backgroundView = nil
        self.statusTableView.reloadData()
    }
    
    func willGetBookingReceipt(){
        self.view.isUserInteractionEnabled = false
        self.progressView.setProgress(0, animated: false)
        self.showProgressView()
        UIView.animate(withDuration: 0.5) {
             self.progressView.setProgress(0.20, animated: true)
         }
    }
    func getBookingReceiptFail(error:ErrorCodes){
        self.view.isUserInteractionEnabled = true
        self.hideProgressView()
        self.statusTableView.backgroundView = self.backView
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
    }
    
    func getBookingResponseWithIndex(success: Bool){
        let val = Double(self.progressView.progress) + self.viewModel.perAPIPersentage
        UIView.animate(withDuration: 0.5) {
            self.progressView.setProgress(Float(val), animated: true)
        }

    }
    
    @objc func tapRetry(_ sender: UIButton){
        self.statusTableView.backgroundColor = nil
        self.viewModel.getBookingReceipt()
        
    }
    
}
