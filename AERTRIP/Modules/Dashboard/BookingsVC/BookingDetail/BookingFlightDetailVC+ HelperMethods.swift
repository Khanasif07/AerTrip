//
//  BookingFlightDetailVC + HelperMethods.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension BookingFlightDetailVC {
    
    // get height for Baggage row for first sections
    func getHeightForBaggageInfoRowFirstSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0,6:
            return 44.0
        case 5:
            return 72.0
        default:
            return 34.0
        }
    }
    
    // get height for row for second sections
    func getHeightForBaggageInfoRowSecondSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 44.0
        default:
            return 34.0
        }
    }
    
    // get height For Flight Info For First section
    
    func getHeightForFlightInfo(_ indexPath: IndexPath) -> CGFloat {
        
        func getDetailsRelatedH() -> CGFloat {
            var flight: FlightDetail?
            if let allLeg = self.viewModel.bookingDetail?.bookingDetail?.leg, allLeg[indexPath.section].flight.count > self.calculatedIndexForShowingFlightDetails {
                
                let detailsC = allLeg[indexPath.section].flight.reduce(into: 0) { $0 += $1.numberOfCell}

                if indexPath.row == 0 {
                    self.calculatedIndexForShowingFlightDetails = 0
                }
                else if indexPath.row < detailsC, indexPath.row == self.calculatedTotalRows {
                    self.calculatedIndexForShowingFlightDetails += 1
                }
                flight = allLeg[indexPath.section].flight[self.calculatedIndexForShowingFlightDetails]
                self.calculatedTotalRows += (flight?.numberOfCell ?? 0)
            }
            
            switch (indexPath.row % self.calculatedTotalRows) {
            case 0:
                //aerline details
                return 80.0
            case 1:
                //flight details
                return 140
            case 2:
                //aminities
                let heightForOneRow: CGFloat = 55.0
                let lineSpace = (CGFloat(flight?.totalRowsForAmenities ?? 1) * 5.0)
                //10 id collection view top & bottom in xib
                return (CGFloat(flight?.totalRowsForAmenities ?? 1) * heightForOneRow) + lineSpace + 20.0
            case 3:
                //layover time
                return 40.0
            default:
                return 0
            }
        }
        
        if let leg = self.viewModel.bookingDetail?.bookingDetail?.leg[indexPath.section] {
            let detailsC = leg.flight.reduce(into: 0) { $0 += $1.numberOfCell}
            if indexPath.row < detailsC {
                return getDetailsRelatedH()
            }
            else {
                //Travellers & Add-ons
                //175.0 for list + <for details>
                return 540.0
            }
        }
        return 0.0
    }
    
    
    // return cell for Flight Info
    func getCellForFlightInfo(_ indexPath: IndexPath) -> UITableViewCell {
        
        func getDetailsRelatedCell(flight: FlightDetail?) -> UITableViewCell {
            
            switch indexPath.row {
            case 0:
                //aerline details
                guard let flightInfoCell = self.tableView.dequeueReusableCell(withIdentifier: FlightInfoTableViewCell.reusableIdentifier) as? FlightInfoTableViewCell else {
                    fatalError("FlightInfoTableViewCell not found")
                }
                
                flightInfoCell.flightDetail = flight
                
                return flightInfoCell
                
            case 1:
                //flight details
                guard let fligthTimeLocationInfoCell = self.tableView.dequeueReusableCell(withIdentifier: FlightTimeLocationInfoTableViewCell.reusableIdentifier) as? FlightTimeLocationInfoTableViewCell else {
                    fatalError("FlightTimeLocationInfoTableViewCell not found")
                }
                
                fligthTimeLocationInfoCell.flightDetail = flight
                
                return fligthTimeLocationInfoCell
                
            case 2:
                //aminities
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AmentityTableViewCell.reusableIdentifier) as? AmentityTableViewCell else {
                    fatalError("AmentityTableViewCell not found")
                }
                
                cell.flightDetail = flight
                
                return cell
                
            case 3:
                //layouver time
                guard let nightStateCell = self.tableView.dequeueReusableCell(withIdentifier: NightStateTableViewCell.reusableIdentifier) as? NightStateTableViewCell else {
                    fatalError("NightStateTableViewCell not found")
                }
                
                nightStateCell.flightDetail = flight
                
                return nightStateCell
                
            default:
                return UITableViewCell()
            }
        }
        
        
        if let leg = self.viewModel.bookingDetail?.bookingDetail?.leg[indexPath.section] {
            let detailsC = leg.flight.reduce(into: 0) { $0 += $1.numberOfCell}
            let flight = leg.flight[self.calculatedIndexForShowingFlightDetails]
            if indexPath.row < detailsC {
                return getDetailsRelatedCell(flight: flight)
            }
            else {
                //Travellers & Add-ons
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: BookingTravellerAddOnsTableViewCell.reusableIdentifier) as? BookingTravellerAddOnsTableViewCell else {
                    fatalError("BookingTravellerAddOnsTableViewCell not found")
                }
                
                cell.paxDetails = leg.pax
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func getCellForBaggageInfo(_ indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0,6:
                guard let airlineCell = self.tableView.dequeueReusableCell(withIdentifier: "BaggageAirlineInfoTableViewCell") as? BaggageAirlineInfoTableViewCell else {
                    fatalError("BaggageAirlineInfoTableViewCell not found")
                }
                airlineCell.backgroundColor = .green
                airlineCell.airlineNameLabel.text = "Airline Name"
                airlineCell.airlineCodeLabel.text = "EK-5154・Economy (E)"
                airlineCell.delegate = self
                return airlineCell
            case 1,2,3,4,7,8,9,10:
                guard  let commonCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell", for: indexPath) as? BookingInfoCommonCell else {
                    fatalError("BookingInfoCommonCell not found")
                }
                commonCell.leftLabel.text = "Type"
                commonCell.middleLabel.text = "Check-in"
                commonCell.rightLabel.text = "Cabin"
                return commonCell
            case 5:
                guard let nightStateCell = self.tableView.dequeueReusableCell(withIdentifier: "NightStateTableViewCell") as? NightStateTableViewCell else {
                    fatalError("NightStateTableViewCell not found")
                }
                
                nightStateCell.flightDetail = nil
                
                return nightStateCell
            default:
                return UITableViewCell()
            }
        } else {
            switch indexPath.row  {
            case 0:
                guard let airlineCell = self.tableView.dequeueReusableCell(withIdentifier: "BaggageAirlineInfoTableViewCell") as? BaggageAirlineInfoTableViewCell else {
                    fatalError("BaggageAirlineInfoTableViewCell not found")
                }
                airlineCell.backgroundColor = .red
                airlineCell.airlineNameLabel.text = "Airline Name"
                airlineCell.airlineCodeLabel.text = "EK-5154・Economy (E)"
                airlineCell.delegate = self
                return airlineCell
            case 1,2:
                guard  let commonCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell", for: indexPath) as? BookingInfoCommonCell else {
                    fatalError("BookingInfoCommonCell not found")
                }
                commonCell.leftLabel.text = "Type"
                commonCell.middleLabel.text = "Check-in"
                commonCell.rightLabel.text = "Cabin"
                return commonCell
            default:
                return UITableViewCell()
                
            }
        }
    }
    
    func getCellForFareInfo(_ indexPath: IndexPath) -> UITableViewCell  {
        switch indexPath.row {
        case 0,1,2,3,4,6,7,8,12,13,14: // three type common cell
            guard  let commonCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell", for: indexPath) as? BookingInfoCommonCell else {
                fatalError("BookingInfoCommonCell not found")
            }
            commonCell.leftLabel.text = "Type"
            commonCell.middleLabel.text = "Check-in"
            commonCell.rightLabel.text = "Cabin"
            return commonCell
        case 5,9:  // Empty Divider view Cell
            guard let emptyDividerViewCell = self.tableView.dequeueReusableCell(withIdentifier: "EmptyDividerViewCellTableViewCell") as? EmptyDividerViewCellTableViewCell else {
                fatalError("EmptyDividerViewCellTableViewCell not found")
            }
            return emptyDividerViewCell
        case 10:  // Notes point cell
            guard let fareInfoNoteCell = self.tableView.dequeueReusableCell(withIdentifier: "FareInfoNoteTableViewCell") as? FareInfoNoteTableViewCell else {
                fatalError("FareInfoNoteTableViewCell not found")
            }
            fareInfoNoteCell.isForBookingPolicyCell = false
            fareInfoNoteCell.noteLabel.text = LocalizedString.Notes.localized
            fareInfoNoteCell.configCell(notes: ["Hello","Hello","Hello","Hello","Hello","Hello","Hello","Hello"])
            return fareInfoNoteCell
            
        case 11: // Route fare info cell
            guard let routeFareInfoCell = self.tableView.dequeueReusableCell(withIdentifier: "RouteFareInfoTableViewCell") as? RouteFareInfoTableViewCell else {
                fatalError("RouteFareInfoTableViewCell not found")
            }
            routeFareInfoCell.delegate = self
            routeFareInfoCell.configureCell()
            return routeFareInfoCell
            
            
        default:
            return UITableViewCell()
        }
    }
    
    
}
