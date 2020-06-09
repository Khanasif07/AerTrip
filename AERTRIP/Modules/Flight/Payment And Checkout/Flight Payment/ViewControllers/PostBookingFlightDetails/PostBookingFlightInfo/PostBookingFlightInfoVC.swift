//
//  PostBookingFlightInfoVC.swift
//  AERTRIP
//
//  Created by Apple  on 09.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class PostBookingFlightInfoVC: BaseVC {
    
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
    }
}


extension PostBookingFlightInfoVC {
    
    // get height For Flight Info For First section
    func getHeightForFlightInfo(_ indexPath: IndexPath) -> CGFloat {
        
        switch self.viewModel.allFlightInfoCells[indexPath.section][indexPath.row] {
        case .aerlineDetail: return 82.0
        case .flightInfo: return 140.0
        case .amenities(let totalRowsForAmenities):
            let heightForOneRow: CGFloat = 55.0
            let lineSpace = (CGFloat(totalRowsForAmenities) * 5.0)
            // 10 id collection view top & bottom in xib
            return (CGFloat(totalRowsForAmenities) * heightForOneRow) + lineSpace + 25.0
            
        case .layover: return 40.0
        case .paxData:
            //            if let pax = self.viewModel.legDetails[indexPath.section].pax.first, !pax.detailsToShow.isEmpty {
            //                // Travellers & Add-ons
            //                // 175.0 for list + <for details>
            //                return 175.0 + (CGFloat(pax.detailsToShow.count) * 60.0)
            //            }
            return UITableView.automaticDimension//0.0
        }
    }
    
    func getFlightDetailsForFlightInfo(indexPath: IndexPath) -> BookingFlightDetail {
        var currentIdx: Int = 0
        var allTotal: Int = 1
        
        if let allLegs = self.viewModel.bookingDetail?.bookingDetail?.leg {
            for flg in allLegs[indexPath.section].flight {
                allTotal += flg.numberOfCellFlightInfo
                if indexPath.row <= (allTotal-2) {
                    break
                }
                else if indexPath.row > (allTotal-2) {
                    currentIdx += 1
                }
            }
        }
        if (allTotal - 1) == indexPath.row {
            //pax data
            currentIdx -= 1
        }
        return self.viewModel.legDetails[indexPath.section].flight[currentIdx]
    }
    
    // return cell for Flight Info
    func getCellForFlightInfo(_ indexPath: IndexPath) -> UITableViewCell {
        
        let flight = self.getFlightDetailsForFlightInfo(indexPath: indexPath)
        
        func getAerlineInfoCell() -> UITableViewCell {
            // aerline details
            guard let flightInfoCell = self.tableView.dequeueReusableCell(withIdentifier: FlightInfoTableViewCell.reusableIdentifier) as? FlightInfoTableViewCell else {
                fatalError("FlightInfoTableViewCell not found")
            }
            
            flightInfoCell.flightDetail = flight
            
            return flightInfoCell
        }
        
        func getFlightInfoCell() -> UITableViewCell {
            // flight details
            guard let fligthTimeLocationInfoCell = self.tableView.dequeueReusableCell(withIdentifier: FlightTimeLocationInfoTableViewCell.reusableIdentifier) as? FlightTimeLocationInfoTableViewCell else {
                fatalError("FlightTimeLocationInfoTableViewCell not found")
            }
            
            fligthTimeLocationInfoCell.flightDetail = flight
            fligthTimeLocationInfoCell.isMoonIConNeedToHide = !flight.ovgtf
            return fligthTimeLocationInfoCell
        }
        
        func getAminitiesCell() -> UITableViewCell {
            // aminities
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AmentityTableViewCell.reusableIdentifier) as? AmentityTableViewCell else {
                fatalError("AmentityTableViewCell not found")
            }
            
            cell.flightDetail = flight
            
            return cell
        }
        
        func getLayoverTimeCell() -> UITableViewCell {
            // layouver time
            guard let nightStateCell = self.tableView.dequeueReusableCell(withIdentifier: NightStateTableViewCell.reusableIdentifier) as? NightStateTableViewCell else {
                fatalError("NightStateTableViewCell not found")
            }
            
            nightStateCell.flightDetail = flight
            
            return nightStateCell
        }
        
        func getPaxDataCell() -> UITableViewCell {
            // Travellers & Add-ons
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: BookingTravellerAddOnsTableViewCell.reusableIdentifier) as? BookingTravellerAddOnsTableViewCell else {
                fatalError("BookingTravellerAddOnsTableViewCell not found")
            }
            cell.flightDetail = flight
            cell.paxDetails = self.viewModel.legDetails[indexPath.section].pax
            cell.parentIndexPath = indexPath
            cell.heightDelegate = self
            return cell
            
        }
        
        switch self.viewModel.allFlightInfoCells[indexPath.section][indexPath.row] {
        case .aerlineDetail: return getAerlineInfoCell()
        case .flightInfo: return getFlightInfoCell()
        case .amenities( _): return getAminitiesCell()
        case .layover: return getLayoverTimeCell()
        case .paxData: return getPaxDataCell()
        }
    }
    
}
extension PostBookingFlightInfoVC:TravellerAddOnsCellHeightDelegate {
    
    func needToUpdateHeight(at index:IndexPath){
        self.tableView.beginUpdates()
        UIView.animate(withDuration: 0.3) {
            self.tableView.endUpdates()
        }
    }
    
}


extension PostBookingFlightInfoVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.legDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingInfoHeaderView else { return nil }
        
        headerView.tripRougteLabel.text = self.viewModel.legDetails[section].title
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35.0
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
        let detailsC = self.viewModel.legDetails[section].flight.reduce(into: 0) { $0 += $1.numberOfCellFlightInfo }
        return self.viewModel.legDetails[section].pax.isEmpty ? detailsC : (detailsC + 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getHeightForFlightInfo(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCellForFlightInfo(indexPath)
    }
}

extension PostBookingFlightInfoVC: BookingDetailVMDelegate {
    func willGetBookingFees() {}
    
    func getBookingFeesSuccess() {
        self.tableView.reloadData()
    }
    
    func getBookingFeesFail() {}
}
