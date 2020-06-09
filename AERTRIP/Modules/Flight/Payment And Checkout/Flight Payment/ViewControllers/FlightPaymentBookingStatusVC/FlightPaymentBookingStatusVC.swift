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
    
    var viewModel = FlightPaymentBookingStatusVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func initialSetup() {
        super.initialSetup()
        self.viewModel.getSectionData()
        self.registerCell()
        self.statusTableView.separatorStyle = .none
        self.setupPayButton()
        self.returnHomeButton.addGredient(isVertical: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
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

  private func setupPayButton() {
      self.returnHomeButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
      self.returnHomeButton.setTitleColor(AppColors.themeWhite, for: .normal)
      self.returnHomeButton.setTitle("Return Home", for: .normal)
  }
    @IBAction func returnHomeButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
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
        return (section == 1) ? 59 : CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HCBookingDetailsTableViewHeaderFooterView") as? HCBookingDetailsTableViewHeaderFooterView else { return nil }
            headerView.delegate = self
            return headerView
        } else {
            return UIView()
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == (self.viewModel.sectionData.count - 2) && self.viewModel.isSeatSettingAvailable) ? UITableView.automaticDimension : CGFloat.leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (section == (self.viewModel.sectionData.count - 2) && self.viewModel.isSeatSettingAvailable){
            guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SelectSeatButtonFooterVew") as? SelectSeatButtonFooterVew else { return nil }
            footerView.handeller = {
                printDebug("Hello jdsk")
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
    
}

extension FlightPaymentBookingStatusVC : HCBookingDetailsTableViewHeaderFooterViewDelegate{
    
    func emailIternaryButtonTapped(){
        let obj = HCEmailItinerariesVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.viewModel.isForDummy = true
        self.present(obj, animated: true, completion: nil)
    }
    
}
