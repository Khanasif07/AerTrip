//
//  PostBookingBaggageVC.swift
//  AERTRIP
//
//  Created by Apple  on 09.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class PostBookingBaggageVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var tableView: ATTableView!
    
    // MARK: - Variables
    let headerViewIdentifier = "BookingInfoHeaderView"
    let footerViewIdentifier = "BookingInfoEmptyFooterView"
    //let fareInfoHeaderViewIdentifier = "FareInfoHeaderView"
    let viewModel = BookingDetailVM()
    
    override func initialSetup() {
        self.view.layoutIfNeeded()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.registerXib()
//        delay(seconds: 0.3) { [weak self] in
//            self?.tableView.scrollToRow(at: IndexPath(row: 0, section: self?.viewModel.legSectionTap ?? 0), at: .top, animated: false)
//        }
        //        self.tableView.backgroundColor = AppColors.themeWhite
//        self.viewModel.getBookingFees()
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
        //self.tableView.register(UINib(nibName: self.fareInfoHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.fareInfoHeaderViewIdentifier)
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
        
        self.tableView.registerCell(nibName: BookingRequestStatusTableViewCell.reusableIdentifier)
        
        // Traveller Addon TableViewCell
        self.tableView.registerCell(nibName: BookingTravellerAddOnsTableViewCell.reusableIdentifier)
        self.tableView.registerCell(nibName: BookingInfoNotesCellTableViewCell.reusableIdentifier)

    }
    
}


extension PostBookingBaggageVC {
    
    // get height for Baggage row for first sections
    func getHeightForBaggageInfo(_ indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case self.viewModel.allBaggageCells.count:
            return UITableView.automaticDimension
        default:
            switch self.viewModel.allBaggageCells[indexPath.section][indexPath.row] {
            case .aerlineDetail: return 59.0
            case .title: return 20.0
            case .adult(let isLast): return isLast ? 54.0 : 28.0
            case .child(let isLast): return isLast ? 54.0 : 28.0
            case .infant(let isLast): return isLast ? 54.0 : 28.0
            case .layover(let isLast): return isLast ? 43.0 : 40.0
            case .note: return 43.0
            }
        }
    }
    
    func getFlightDetailsForBaggageInfo(indexPath: IndexPath) -> BookingFlightDetail {
        if self.viewModel.allBaggageCells.count == indexPath.section {
            return BookingFlightDetail()
        }
        var currentIdx: Int = 0
        var allTotal: Int = 0
        
        if let allLegs = self.viewModel.bookingDetail?.bookingDetail?.leg {
            for flg in allLegs[indexPath.section].flight {
                allTotal += flg.numberOfCellBaggage
                if indexPath.row <= (allTotal-1) {
                    break
                }
                else if indexPath.row > (allTotal-1) {
                    currentIdx += 1
                }
            }
        }
        return self.viewModel.legDetails[indexPath.section].flight[currentIdx]
    }
    
    func getCellForBaggageInfo(_ indexPath: IndexPath) -> UITableViewCell {
        let flight = self.getFlightDetailsForBaggageInfo(indexPath: indexPath)
        
        func getAerlineCell() -> UITableViewCell {
            // aerline details
            guard let airlineCell = self.tableView.dequeueReusableCell(withIdentifier: "BaggageAirlineInfoTableViewCell") as? BaggageAirlineInfoTableViewCell else {
                fatalError("BaggageAirlineInfoTableViewCell not found")
            }
            airlineCell.flightDetail = flight
            airlineCell.delegate = self
            return airlineCell
        }
        
        func getBaggageInfoCell(usingFor: BookingInfoCommonCell.UsingFor) -> UITableViewCell {
            // baggage info
            guard let commonCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell") as? BookingInfoCommonCell else {
                fatalError("BookingInfoCommonCell not found")
            }
            
            commonCell.setData(forFlight: flight, usingFor: usingFor)
            
            return commonCell
        }
        
        func getLayoverCell() -> UITableViewCell {
            // layover time
            guard let nightStateCell = self.tableView.dequeueReusableCell(withIdentifier: NightStateTableViewCell.reusableIdentifier) as? NightStateTableViewCell else {
                fatalError("NightStateTableViewCell not found")
            }
            
            nightStateCell.flightDetail = flight
            
            return nightStateCell
        }
        
        func getNoteCell() -> UITableViewCell {
            // layover time
            guard let nightStateCell = self.tableView.dequeueReusableCell(withIdentifier: BookingRequestStatusTableViewCell.reusableIdentifier) as? BookingRequestStatusTableViewCell else {
                fatalError("NightStateTableViewCell not found")
            }
            
            nightStateCell.containerView.backgroundColor = AppColors.clear
            nightStateCell.titleLabel.font = AppFonts.Regular.withSize(16.0)
            nightStateCell.titleLabel.textColor = AppColors.themeGray40
            nightStateCell.titleLabel.text = flight.baggage?.checkInBg?.notes ?? LocalizedString.dash.localized
            
            return nightStateCell
        }
        
        func getFinalNoteCell() -> UITableViewCell {
            // layover time
            guard let noteCell = self.tableView.dequeueReusableCell(withIdentifier: BookingInfoNotesCellTableViewCell.reusableIdentifier) as? BookingInfoNotesCellTableViewCell else {
                fatalError("BookingInfoNotesCellTableViewCell not found")
            }
            
            noteCell.flightDetail =
                self.viewModel.legDetails.flatMap({ (leg) in
                    return leg.flight
                })
            
            return noteCell
        }
        
        switch indexPath.section {
        case self.viewModel.allBaggageCells.count:
            return getFinalNoteCell()
        default:
            switch self.viewModel.allBaggageCells[indexPath.section][indexPath.row] {
            case .aerlineDetail: return getAerlineCell()
            case .title: return getBaggageInfoCell(usingFor: .title)
            case .adult: return getBaggageInfoCell(usingFor: .adult)
            case .child: return getBaggageInfoCell(usingFor: .child)
            case .infant: return getBaggageInfoCell(usingFor: .infant)
            case .layover: return getLayoverCell()
            case .note: return getNoteCell()
            }
        }
    }
    
}

extension PostBookingBaggageVC:TravellerAddOnsCellHeightDelegate {
    
    func needToUpdateHeight(at index:IndexPath){
        self.tableView.beginUpdates()
        UIView.animate(withDuration: 0.3) {
            self.tableView.endUpdates()
        }
    }
    
}


extension PostBookingBaggageVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.allBaggageCells.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude//60.0
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingInfoHeaderView else { return nil }
    //
    //        headerView.tripRougteLabel.text = self.viewModel.legDetails[section].title
    //        return headerView
    //
    //    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
//        if self.viewModel.allBaggageCells.count == 1 {
//            return 0
//        } else {
            return 35.0
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as? BookingInfoEmptyFooterView else {
            fatalError("BookingInfoFooterView not found")
        }
        
        let totalSection = self.numberOfSections(in: self.tableView) - 1
        footerView.bottomDividerView.isHidden = totalSection == section
        return footerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case self.viewModel.allBaggageCells.count:
            return 1
        default:
            return self.viewModel.allBaggageCells[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getHeightForBaggageInfo(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCellForBaggageInfo(indexPath)
    }
}

// Delegate methods

extension PostBookingBaggageVC: BaggageAirlineInfoTableViewCellDelegate {
    func dimensionButtonTapped(_ dimensionButton: UIButton) {
        printDebug("Dimension Button Tapped ")
        var detail: BaggageInfo?
        if let cell = self.tableView.cell(forItem: dimensionButton) as? BaggageAirlineInfoTableViewCell {
            if let obj = cell.flightDetail?.baggage?.cabinBg?.infant {
                detail = obj
            }
            if let obj = cell.flightDetail?.baggage?.cabinBg?.child {
                detail = obj
            }
            if let obj = cell.flightDetail?.baggage?.cabinBg?.adult {
                detail = obj
            }
        }
        
        if let obj = detail?.dimension {
            AppFlowManager.default.presentBaggageInfoVC(dimension: obj)
        }
    }
}

extension PostBookingBaggageVC: BookingDetailVMDelegate {
    func willGetBookingFees() {}
    
    func getBookingFeesSuccess() {
        self.tableView.reloadData()
    }
    
    func getBookingFeesFail() {}
}
