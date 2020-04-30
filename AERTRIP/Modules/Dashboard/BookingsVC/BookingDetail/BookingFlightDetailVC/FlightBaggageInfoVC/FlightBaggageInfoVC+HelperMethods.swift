//
//  FlightBaggageInfoVC+HelperMethods.swift
//  AERTRIP
//
//  Created by Admin on 30/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
extension FlightBaggageInfoVC {

    // get height for Baggage row for first sections
    func getHeightForBaggageInfo(_ indexPath: IndexPath) -> CGFloat {
        switch self.viewModel.allBaggageCells[indexPath.section][indexPath.row] {
        case .aerlineDetail: return 60.0
        case .title: return 29.0
        case .adult(let isLast): return isLast ? 43.0 : 29.0
        case .child(let isLast): return isLast ? 43.0 : 29.0
        case .infant(let isLast): return isLast ? 43.0 : 29.0
        case .layover(let isLast): return isLast ? 43.0 : 40.0
        case .note: return 43.0
        }
    }
    
    func getFlightDetailsForBaggageInfo(indexPath: IndexPath) -> FlightDetail {
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

extension FlightBaggageInfoVC:TravellerAddOnsCellHeightDelegate {
    
    func needToUpdateHeight(at index:IndexPath){
        self.tableView.beginUpdates()
        UIView.animate(withDuration: 0.3) {
            self.tableView.endUpdates()
        }
    }
    
}
