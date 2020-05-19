//
//  FlightInfoVC+ HelperMethods.swift
//  AERTRIP
//
//  Created by Admin on 30/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension FlightBookingInfoVC {
    
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
    
    func getFlightDetailsForFlightInfo(indexPath: IndexPath) -> FlightDetail {
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
extension FlightBookingInfoVC:TravellerAddOnsCellHeightDelegate {
    
    func needToUpdateHeight(at index:IndexPath){
        self.tableView.beginUpdates()
        UIView.animate(withDuration: 0.3) {
            self.tableView.endUpdates()
        }
    }
    
}
