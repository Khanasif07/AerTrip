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
        
        var detailsC: Int = 0
        if self.viewModel.legDetails[indexPath.section].flight.count > self.calculatedIndexForShowingFlightDetails {
            
            detailsC = self.viewModel.legDetails[indexPath.section].flight.reduce(into: 0) { $0 += $1.numberOfCellBaggage}
            
            if indexPath.row == 0 {
                self.calculatedIndexForShowingFlightDetails = 0
            }
            else if indexPath.row < detailsC, indexPath.row == self.calculatedTotalRows {
                self.calculatedIndexForShowingFlightDetails += 1
            }
            let flight = self.viewModel.legDetails[indexPath.section].flight[self.calculatedIndexForShowingFlightDetails]
            self.calculatedTotalRows += (flight.numberOfCellBaggage)
        }
        
        switch indexPath.row {
        case 0:
            //aerline details
            return 60.0
            
        case 1,2,3,4:
            //baggage info
            if ((1...3 ~= indexPath.row) && (indexPath.row == (detailsC-1))) || (indexPath.row == 4) {
                return 43.0
            }
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
            if self.viewModel.legDetails[indexPath.section].flight.count > self.calculatedIndexForShowingFlightDetails {
                
                let detailsC = self.viewModel.legDetails[indexPath.section].flight.reduce(into: 0) { $0 += $1.numberOfCellFlightInfo}
                
                if indexPath.row == 0 {
                    self.calculatedIndexForShowingFlightDetails = 0
                }
                else if indexPath.row < detailsC, indexPath.row == self.calculatedTotalRows {
                    self.calculatedIndexForShowingFlightDetails += 1
                }
                flight = self.viewModel.legDetails[indexPath.section].flight[self.calculatedIndexForShowingFlightDetails]
                self.calculatedTotalRows += (flight?.numberOfCellFlightInfo ?? 0)
            }
            
            switch (indexPath.row % self.calculatedTotalRows) {
            case 0:
                //aerline details
                return 82.0
            case 1:
                //flight details
                return 140
            case 2:
                //aminities
                let heightForOneRow: CGFloat = 55.0
                let lineSpace = (CGFloat(flight?.totalRowsForAmenities ?? 1) * 5.0)
                //10 id collection view top & bottom in xib
                return (CGFloat(flight?.totalRowsForAmenities ?? 1) * heightForOneRow) + lineSpace + 25.0
            case 3:
                //layover time
                return 40.0
            default:
                return 0
            }
        }
        
        let detailsC = self.viewModel.legDetails[indexPath.section].flight.reduce(into: 0) { $0 += $1.numberOfCellFlightInfo}
        if indexPath.row < detailsC {
            return getDetailsRelatedH()
        }
        else if let pax = self.viewModel.legDetails[indexPath.section].pax.first, !pax.detailsToShow.isEmpty {
            //Travellers & Add-ons
            //175.0 for list + <for details>
            return 175.0 + (CGFloat(pax.detailsToShow.count) * 60.0)
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
        
        
        let detailsC = self.viewModel.legDetails[indexPath.section].flight.reduce(into: 0) { $0 += $1.numberOfCellFlightInfo}
        let flight = self.viewModel.legDetails[indexPath.section].flight[self.calculatedIndexForShowingFlightDetails]
        if indexPath.row < detailsC {
            return getDetailsRelatedCell(flight: flight)
        }
        else {
            //Travellers & Add-ons
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: BookingTravellerAddOnsTableViewCell.reusableIdentifier) as? BookingTravellerAddOnsTableViewCell else {
                fatalError("BookingTravellerAddOnsTableViewCell not found")
            }
            
            cell.paxDetails = self.viewModel.legDetails[indexPath.section].pax
            
            return cell
        }
    }
    
    
    func getCellForBaggageInfo(_ indexPath: IndexPath) -> UITableViewCell {
        
        let flight = self.viewModel.legDetails[indexPath.section].flight[self.calculatedIndexForShowingFlightDetails]
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
                middleLabelTxt = flight.baggage?.checkInBg?.adult ?? LocalizedString.na.localized
                rightLabelTxt = ("\(flight.baggage?.cabinBg?.adult?.piece ?? "1") x \(flight.baggage?.cabinBg?.adult?.weight ?? "23 kgs")")
                font = AppFonts.Regular.withSize(18.0)
            }
            else if indexPath.row == 3 {
                //child
                leftLabelTxt = "Per Child"
                middleLabelTxt = flight.baggage?.checkInBg?.child ?? LocalizedString.na.localized
                rightLabelTxt = ("\(flight.baggage?.cabinBg?.child?.piece ?? "1") x \(flight.baggage?.cabinBg?.child?.weight ?? "23 kgs")")
                font = AppFonts.Regular.withSize(18.0)
            }
            else if indexPath.row == 4 {
                //infant
                leftLabelTxt = "Per Infant"
                middleLabelTxt = flight.baggage?.checkInBg?.infant ?? LocalizedString.na.localized
                rightLabelTxt = ("\(flight.baggage?.cabinBg?.infant?.piece ?? "1") x \(flight.baggage?.cabinBg?.infant?.weight ?? "23 kgs")")
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
    
    func getCancelChargesCount(charge: BookingFeeDetail.Charges?) -> Int {
        var temp = 0
        guard let can = charge else {
            return temp
        }
        temp += 1 //headers
        
        if let _ = can.adult {
            temp += 1
        }
        if let _ = can.child {
            temp += 1
        }
        if let _ = can.infant {
            temp += 1
        }
        
        temp += 1 //blank space
        
        return temp
    }
    
    func getResChargesCount(charge: BookingFeeDetail.Charges?) -> Int {
        var temp = 0
        guard let res = charge else {
            return temp
        }
        temp += 1 //headers
        
        if let _ = res.adult {
            temp += 1
        }
        if let _ = res.child {
            temp += 1
        }
        if let _ = res.infant {
            temp += 1
        }
        
        return temp
    }
    
    func getNumberOfCellsInFareInfoForNormalFlight(forData infoData: BookingFeeDetail?) -> Int {
        var temp = 2 //for notes
        
        if let info = infoData {
            if let can = info.aerlineCanCharges {
                temp += getCancelChargesCount(charge: can)
            }
            
            if let res = info.aerlineResCharges {
                temp += getResChargesCount(charge: res)
            }
        }
        
        return temp
    }
    
    func getNumberOfCellsInFareInfoForMultiFlight() -> Int {
        return 4
    }
    
    func getFeeDetailsCell(indexPath: IndexPath, type: String, aerlineFee: Int, aertripFee: Int) -> UITableViewCell {
        guard  let commonCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell", for: indexPath) as? BookingInfoCommonCell else {
            fatalError("BookingInfoCommonCell not found")
        }
        
        commonCell.middleLabel.font = AppFonts.Regular.withSize(16.0)
        commonCell.rightLabel.font = AppFonts.Regular.withSize(16.0)
        
        commonCell.leftLabel.text = type
        commonCell.middleLabel.attributedText = aerlineFee.toDouble.amountInDoubleWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        commonCell.rightLabel.attributedText = aertripFee.toDouble.amountInDoubleWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        return commonCell
    }
    
    func getFeeTitleCell(indexPath: IndexPath, type: String, aerline: String, aertrip: String) -> UITableViewCell {
        guard  let commonCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell", for: indexPath) as? BookingInfoCommonCell else {
            fatalError("BookingInfoCommonCell not found")
        }
        
        commonCell.middleLabel.font = AppFonts.SemiBold.withSize(16.0)
        commonCell.rightLabel.font = AppFonts.SemiBold.withSize(16.0)
        
        commonCell.leftLabel.text = type
        commonCell.middleLabel.text = aerline
        commonCell.rightLabel.text = aertrip
        return commonCell
    }
    
    func getHeightForFareInfo(_ indexPath: IndexPath) -> CGFloat {
        if let booking = self.viewModel.bookingDetail, booking.isReturnFlight() {
            if indexPath.row == 0 {
                return UITableView.automaticDimension
            }
            else {
                return indexPath.row == 3 ? 45.0 : 27.0
            }
        }
        else
        {
            if indexPath.row == (self.getNumberOfCellsInFareInfoForNormalFlight(forData: self.viewModel.bookingFee)-1) {
                return UITableView.automaticDimension
            }
            else if let info = self.viewModel.bookingFee {
                if let can = info.aerlineCanCharges {
                    if indexPath.row == (getCancelChargesCount(charge: can)-1) {
                        return 45.0
                    }
                    return 27.0
                }
                
                if let res = info.aerlineResCharges {
                    if indexPath.row == (getResChargesCount(charge: res)-1) {
                        return 45.0
                    }
                    return 27.0
                }
            }
            return UITableView.automaticDimension
        }
    }
    
    func getCellForFareInfoForNormalFlight(_ indexPath: IndexPath) -> UITableViewCell  {
        
        func getNotesCell() -> UITableViewCell {
            guard let fareInfoNoteCell = self.tableView.dequeueReusableCell(withIdentifier: "FareInfoNoteTableViewCell") as? FareInfoNoteTableViewCell else {
                fatalError("FareInfoNoteTableViewCell not found")
            }
            fareInfoNoteCell.isForBookingPolicyCell = false
            fareInfoNoteCell.noteLabel.text = LocalizedString.Notes.localized
            fareInfoNoteCell.configCell(notes: self.viewModel.fareInfoNotes)
            return fareInfoNoteCell
        }
        
        func getBlankSpaceCell() -> UITableViewCell {
            guard let emptyDividerViewCell = self.tableView.dequeueReusableCell(withIdentifier: "EmptyDividerViewCellTableViewCell") as? EmptyDividerViewCellTableViewCell else {
                fatalError("EmptyDividerViewCellTableViewCell not found")
            }
            return emptyDividerViewCell
        }
        
        var finalCell = UITableViewCell()
        if let info = self.viewModel.bookingFee {
            if let can = info.aerlineCanCharges, indexPath.row < getCancelChargesCount(charge: can)  {
                
                if indexPath.row == 0 {
                    //headers
                    finalCell = getFeeTitleCell(indexPath: indexPath, type: "Cancellation", aerline: "Airline Fee", aertrip: "Aertrip Fee")
                }
                else if indexPath.row == 1, let val = can.adult {
                    //adult
                    finalCell = getFeeDetailsCell(indexPath: indexPath, type: "Per Adult", aerlineFee: val, aertripFee: info.aertripCanCharges?.adult ?? 0)
                }
                else if indexPath.row <= 2, let val = can.child {
                    //Child
                    finalCell = getFeeDetailsCell(indexPath: indexPath, type: "Per Child", aerlineFee: val, aertripFee: info.aertripCanCharges?.child ?? 0)
                }
                else if indexPath.row <= 3, let val = can.infant {
                    if indexPath.row == 3 {
                        //blank
                        finalCell = getBlankSpaceCell()
                    }
                    else {
                        //infant
                        finalCell = getFeeDetailsCell(indexPath: indexPath, type: "Per Infant", aerlineFee: val, aertripFee: info.aertripCanCharges?.infant ?? 0)
                    }
                }
                else if indexPath.row == (getCancelChargesCount(charge: info.aerlineCanCharges) - 1) {
                    //blank space
                    finalCell = getBlankSpaceCell()
                }
            }
            
            if let res = info.aerlineResCharges {
                let oldCount = getCancelChargesCount(charge: info.aerlineCanCharges)
                let newIndex = indexPath.row - oldCount
                if newIndex == 0 {
                    //headers
                    finalCell = getFeeTitleCell(indexPath: indexPath, type: "Re-scheduling", aerline: "Airline Fee", aertrip: "Aertrip Fee")
                }
                else if newIndex == 1, let val = res.adult {
                    //adult
                    finalCell = getFeeDetailsCell(indexPath: indexPath, type: "Per Adult", aerlineFee: val, aertripFee: info.aertripResCharges?.adult ?? 0)
                }
                else if newIndex <= 2, let val = res.child {
                    //Child
                    finalCell = getFeeDetailsCell(indexPath: indexPath, type: "Per Child", aerlineFee: val, aertripFee: info.aertripResCharges?.child ?? 0)
                }
                else if newIndex <= 3, let val = res.infant {
                    if newIndex == 3 {
                        //blank
                        finalCell = getBlankSpaceCell()
                    }
                    else {
                        //infant
                        finalCell = getFeeDetailsCell(indexPath: indexPath, type: "Per Infant", aerlineFee: val, aertripFee: info.aertripResCharges?.infant ?? 0)
                    }
                }
                else if newIndex > 0 {
                    //blank space
                    finalCell = getBlankSpaceCell()
                }
            }
            if indexPath.row == getNumberOfCellsInFareInfoForNormalFlight(forData: info) - 1 {
                //blank space
                finalCell = getNotesCell()
            }
        }
        else {
            if indexPath.row == 0{
                finalCell = getBlankSpaceCell()
            }
            else {
                finalCell = getNotesCell()
            }
        }
        return finalCell
    }
    
    func getCellForFareInfoForMultiFlight(_ indexPath: IndexPath) -> UITableViewCell  {
        
        let index = indexPath.row
        var finalCell = UITableViewCell()
        switch index {
        case 0:
            //flight details
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: RouteFareInfoTableViewCell.reusableIdentifier) as? RouteFareInfoTableViewCell else {
                fatalError("RouteFareInfoTableViewCell not found")
            }
            
            cell.flightDetails = self.viewModel.legDetails[indexPath.section].flight[index]
            cell.delegate = self
            
            finalCell = cell
            
        case 1:
            //title
            finalCell = getFeeTitleCell(indexPath: indexPath, type: "Per Pax", aerline: "Airline Fee", aertrip: "Aertrip Fee")
            
        case 2:
            //cancelation
            finalCell = getFeeDetailsCell(indexPath: indexPath, type: "Cancellation", aerlineFee: self.viewModel.bookingFee?.aerlineCanCharges?.adult ?? 0, aertripFee: self.viewModel.bookingFee?.aertripCanCharges?.adult ?? 0)
            
        case 3:
            //reschdule
            finalCell = getFeeDetailsCell(indexPath: indexPath, type: "Rescheduling", aerlineFee: self.viewModel.bookingFee?.aerlineResCharges?.adult ?? 0, aertripFee: self.viewModel.bookingFee?.aertripResCharges?.adult ?? 0)
            
        default:
            return finalCell
        }
        
        return finalCell
    }
}
