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
    func getHeightForBaggageInfo(_ indexPath: IndexPath) -> CGFloat {
        if let allLeg = self.viewModel.bookingDetail?.bookingDetail?.leg, allLeg[indexPath.section].flight.count > self.calculatedIndexForShowingFlightDetails {
            
            let detailsC = allLeg[indexPath.section].flight.reduce(into: 0) { $0 += $1.numberOfCellBaggage}
            
            if indexPath.row == 0 {
                self.calculatedIndexForShowingFlightDetails = 0
            }
            else if indexPath.row < detailsC, indexPath.row == self.calculatedTotalRows {
                self.calculatedIndexForShowingFlightDetails += 1
            }
            let flight = allLeg[indexPath.section].flight[self.calculatedIndexForShowingFlightDetails]
            self.calculatedTotalRows += (flight.numberOfCellBaggage)
        }
        switch indexPath.row {
        case 0:
            //aerline details
            return 80.0
            
        case 1,2,3,4:
            //baggage info
            return 28.0
            
        case 5:
            //layover time
            return 40.0
            
        default:
            return 0.0
        }
    }
    
    // get height For Flight Info For First section
    
    func getHeightForFlightInfo(_ indexPath: IndexPath) -> CGFloat {
        
        func getDetailsRelatedH() -> CGFloat {
            var flight: FlightDetail?
            if let allLeg = self.viewModel.bookingDetail?.bookingDetail?.leg, allLeg[indexPath.section].flight.count > self.calculatedIndexForShowingFlightDetails {
                
                let detailsC = allLeg[indexPath.section].flight.reduce(into: 0) { $0 += $1.numberOfCellFlightInfo}

                if indexPath.row == 0 {
                    self.calculatedIndexForShowingFlightDetails = 0
                }
                else if indexPath.row < detailsC, indexPath.row == self.calculatedTotalRows {
                    self.calculatedIndexForShowingFlightDetails += 1
                }
                flight = allLeg[indexPath.section].flight[self.calculatedIndexForShowingFlightDetails]
                self.calculatedTotalRows += (flight?.numberOfCellFlightInfo ?? 0)
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
            let detailsC = leg.flight.reduce(into: 0) { $0 += $1.numberOfCellFlightInfo}
            if indexPath.row < detailsC {
                return getDetailsRelatedH()
            }
            else if let pax = leg.pax.first, !pax.detailsToShow.isEmpty {
                //Travellers & Add-ons
                //175.0 for list + <for details>
                return 175.0 + (CGFloat(pax.detailsToShow.count) * 60.0)
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
            let detailsC = leg.flight.reduce(into: 0) { $0 += $1.numberOfCellFlightInfo}
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
        
        var flight: FlightDetail?
        if let leg = self.viewModel.bookingDetail?.bookingDetail?.leg[indexPath.section] {
            flight = leg.flight[self.calculatedIndexForShowingFlightDetails]
        }
        switch indexPath.row {
        case 0:
            //aerline details
            guard let airlineCell = self.tableView.dequeueReusableCell(withIdentifier: "BaggageAirlineInfoTableViewCell") as? BaggageAirlineInfoTableViewCell else {
                fatalError("BaggageAirlineInfoTableViewCell not found")
            }
            airlineCell.flightDetail = flight
            airlineCell.delegate = self
            return airlineCell
            
        case 1,2,3,4:
            //baggage info
            guard  let commonCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell", for: indexPath) as? BookingInfoCommonCell else {
                fatalError("BookingInfoCommonCell not found")
            }
            
            var leftLabelTxt = "Type"
            var middleLabelTxt = "Check-in"
            var rightLabelTxt = "Cabin"
            var font: UIFont? = AppFonts.SemiBold.withSize(18.0)
            
            if indexPath.row == 2 {
                //adult
                leftLabelTxt = "Per Adult"
                middleLabelTxt = flight?.baggage?.checkInBg?.adult ?? LocalizedString.na.localized
                rightLabelTxt = ("\(flight?.baggage?.cabinBg?.adult?.piece ?? "1") x \(flight?.baggage?.cabinBg?.adult?.weight ?? "23 kgs")")
                font = AppFonts.Regular.withSize(18.0)
            }
            else if indexPath.row == 3 {
                //child
                leftLabelTxt = "Per Child"
                middleLabelTxt = flight?.baggage?.checkInBg?.child ?? LocalizedString.na.localized
                rightLabelTxt = ("\(flight?.baggage?.cabinBg?.child?.piece ?? "1") x \(flight?.baggage?.cabinBg?.child?.weight ?? "23 kgs")")
                font = AppFonts.Regular.withSize(18.0)
            }
            else if indexPath.row == 4 {
                //infant
                leftLabelTxt = "Per Infant"
                middleLabelTxt = flight?.baggage?.checkInBg?.infant ?? LocalizedString.na.localized
                rightLabelTxt = ("\(flight?.baggage?.cabinBg?.infant?.piece ?? "1") x \(flight?.baggage?.cabinBg?.infant?.weight ?? "23 kgs")")
                font = AppFonts.Regular.withSize(18.0)
            }
            
            commonCell.middleLabel.font = font
            commonCell.rightLabel.font = font
            
            commonCell.leftLabel.text = leftLabelTxt
            commonCell.middleLabel.text = middleLabelTxt
            commonCell.rightLabel.text = rightLabelTxt
            
            return commonCell
            
        case 5:
            //layover time
            guard let nightStateCell = self.tableView.dequeueReusableCell(withIdentifier: NightStateTableViewCell.reusableIdentifier) as? NightStateTableViewCell else {
                fatalError("NightStateTableViewCell not found")
            }
            
            nightStateCell.flightDetail = flight
            
            return nightStateCell
            
        default:
            return UITableViewCell()
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
