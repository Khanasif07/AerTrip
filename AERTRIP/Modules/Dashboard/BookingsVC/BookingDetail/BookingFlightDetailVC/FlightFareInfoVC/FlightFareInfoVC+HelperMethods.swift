//
//  FlightFareInfoVC+HelperMethods.swift
//  AERTRIP
//
//  Created by Admin on 30/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
extension FlightFareInfoVC {

    func getCancelChargesCount(charge: AerlineCharge?) -> Int {
        var temp = 0
        guard let can = charge else {
            return temp
        }
        temp += 1 // headers

        if let adult = can.adult {
            temp += adult.count//1
        }
//        if let _ = can.child {
//            temp += 1
//        }
//        if let _ = can.infant {
//            temp += 1
//        }

        temp += 1 // blank space

        return temp
    }

    func getResChargesCount(charge: AerlineCharge?) -> Int {
        var temp = 0
        guard let res = charge else {
            return temp
        }
        temp += 1 // headers

        if let adult = res.adult {
            temp += adult.count//1
        }
//        if let _ = res.child {
//            temp += 1
//        }
//        if let _ = res.infant {
//            temp += 1
//        }

        return temp
    }
    
    func getNumberOfCellsInFareInfoForNormalFlight(forData infoData: BookingFeeDetail?) -> Int {
        var temp = 3 // for notes and Discalmer
        
        if let info = infoData {
            if let can = info.aerlineCanCharges {
                temp += self.getCancelChargesCount(charge: can)
            }
            
            if let res = info.aerlineResCharges {
                temp += self.getResChargesCount(charge: res)
            }
        }
        
        return temp
    }
    
    func getNumberOfCellsInFareInfoForMultiFlight() -> Int {
        return 4
    }
    
    func getFeeDetailsCell(indexPath: IndexPath, type: String, aerlineFee: Int, aertripFee: Int) -> UITableViewCell {
        guard let commonCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell") as? BookingInfoCommonCell else {
            fatalError("BookingInfoCommonCell not found")
        }
        
        commonCell.rightLabel.font = AppFonts.Regular.withSize(16.0)
        
        commonCell.leftLabel.text = type
        let final = aerlineFee.toDouble.amountInDelimeterWithSymbol + " + " + aertripFee.toDouble.amountInDelimeterWithSymbol
        commonCell.rightLabel.attributedText = final.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        return commonCell
    }
    
    func getFeeTitleCell(indexPath: IndexPath, type: String, aerline: String, aertrip: String) -> UITableViewCell {
        guard let commonCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell") as? BookingInfoCommonCell else {
            fatalError("BookingInfoCommonCell not found")
        }

        commonCell.rightLabel.font = AppFonts.SemiBold.withSize(16.0)

        commonCell.leftLabel.text = type
        commonCell.rightLabel.text =  aerline + " + " + aertrip
        return commonCell
    }
    
    func getHeightForFareInfo(_ indexPath: IndexPath) -> CGFloat {
        if let booking = self.viewModel.bookingDetail, booking.isMultipleFlight() {
            if indexPath.row == 0 {
                return UITableView.automaticDimension
            }
            else {
                return indexPath.row == 3 ? 45.0 : 29.0
            }
        }
        else {
            // Height for Disclamare Cell
            if indexPath.row == (self.getNumberOfCellsInFareInfoForNormalFlight(forData: self.viewModel.bookingFee.first)-2) {
                return UITableView.automaticDimension
            }
            // Height for notes cell
            if indexPath.row == (self.getNumberOfCellsInFareInfoForNormalFlight(forData: self.viewModel.bookingFee.first) - 1) {
                return UITableView.automaticDimension
            }
            else if let info = self.viewModel.bookingFee.first {
                if let can = info.aerlineCanCharges {
                    if indexPath.row == (self.getCancelChargesCount(charge: can) - 1) {
                        //blank
                        return 40.0
                    }
                    return 29.0
                }
                
                if let res = info.aerlineResCharges {
                    if indexPath.row == (self.getResChargesCount(charge: res) - 1) {
                        //blank
                        return 43.0
                    }
                    return 29.0
                }
            }
            return UITableView.automaticDimension
        }
    }
    
    func getNotesCell() -> UITableViewCell {
        guard let fareInfoNoteCell = self.tableView.dequeueReusableCell(withIdentifier: "FareInfoNoteTableViewCell") as? FareInfoNoteTableViewCell else {
            fatalError("FareInfoNoteTableViewCell not found")
        }
        fareInfoNoteCell.isForBookingPolicyCell = false
        fareInfoNoteCell.notesTopConstraint.constant = 26
        fareInfoNoteCell.noteTextViewTopConstraint.constant = 0
        fareInfoNoteCell.noteTextViewBottomConstraint.constant = 16
        fareInfoNoteCell.noteLabel.text = nil //LocalizedString.Notes.localized
        //fareInfoNoteCell.configCell(notes: AppConstants.kfareInfoNotes)
        fareInfoNoteCell.noteTextView.attributedText = fareInfoNoteCell.getFareInfoAttributedNote()
        fareInfoNoteCell.layoutIfNeeded()
        return fareInfoNoteCell
    }
    
    func getCellForFareInfoForNormalFlight(_ indexPath: IndexPath) -> UITableViewCell {
        func getNotesCell() -> UITableViewCell {
            guard let fareInfoNoteCell = self.tableView.dequeueReusableCell(withIdentifier: "FareInfoNoteTableViewCell") as? FareInfoNoteTableViewCell else {
                fatalError("FareInfoNoteTableViewCell not found")
            }
            fareInfoNoteCell.isForBookingPolicyCell = false
            fareInfoNoteCell.noteTextViewTopConstraint.constant = 10
            fareInfoNoteCell.noteLabel.text = LocalizedString.Notes.localized
            fareInfoNoteCell.configCell(notes: AppConstants.kfareInfoNotes)
            return fareInfoNoteCell
        }
        
        func getDisclamerCell() -> UITableViewCell {
            guard let fareInfoDisclaimer = self.tableView.dequeueReusableCell(withIdentifier: "FareInfoNoteTableViewCell") as? FareInfoNoteTableViewCell else {
                fatalError("FareInfoNoteTableViewCell not found")
            }
            fareInfoDisclaimer.isForBookingPolicyCell = false
            fareInfoDisclaimer.noteTextViewTopConstraint.constant = 10
            fareInfoDisclaimer.noteLabel.text = LocalizedString.Disclaimer.localized
            fareInfoDisclaimer.configCell(notes: AppConstants.kfareInfoDisclamer)
            return fareInfoDisclaimer
        }
        
        func getBlankSpaceCell() -> UITableViewCell {
            guard let emptyDividerViewCell = self.tableView.dequeueReusableCell(withIdentifier: "EmptyDividerViewCellTableViewCell") as? EmptyDividerViewCellTableViewCell else {
                fatalError("EmptyDividerViewCellTableViewCell not found")
            }
            return emptyDividerViewCell
        }
        
        var finalCell = UITableViewCell()
        if let info = self.viewModel.bookingFee.first {
            if let can = info.aerlineCanCharges, indexPath.row < getCancelChargesCount(charge: can) {
                if indexPath.row == 0 {
                    // headers
                    finalCell = self.getFeeTitleCell(indexPath: indexPath, type: "Cancellation", aerline: "Airline Fee", aertrip: "Aertrip Fee")
                }
                else if indexPath.row == 1, let val = can.adult {
                    // adult csz
                    finalCell = self.getFeeDetailsCell(indexPath: indexPath, type: "Per Adult", aerlineFee: val.reduce(0, { (result, object) -> Int in
                        return result + (object.value ?? 0)
                    }), aertripFee: info.aertripCanCharges?.adult ?? 0)
                }
                else if indexPath.row <= 2, let val = can.child {
                    // Child
                    finalCell = self.getFeeDetailsCell(indexPath: indexPath, type: "Per Child", aerlineFee: val.reduce(0, { (result, object) -> Int in
                        return result + (object.value ?? 0)
                    }), aertripFee: info.aertripCanCharges?.child ?? 0)
                }
                else if indexPath.row <= 3, let val = can.infant {
                    if indexPath.row == 3 {
                        // blank
                        finalCell = getBlankSpaceCell()
                    }
                    else {
                        // infant
                        finalCell = self.getFeeDetailsCell(indexPath: indexPath, type: "Per Infant", aerlineFee: val.reduce(0, { (result, object) -> Int in
                            return result + (object.value ?? 0)
                        }), aertripFee: info.aertripCanCharges?.infant ?? 0)
                    }
                }
                else if indexPath.row == (self.getCancelChargesCount(charge: info.aerlineCanCharges) - 1) {
                    // blank space
                    finalCell = getBlankSpaceCell()
                }
            }
            
            if let res = info.aerlineResCharges {
                let oldCount = self.getCancelChargesCount(charge: info.aerlineCanCharges)
                let newIndex = indexPath.row - oldCount
                if newIndex >= 0 {
                    if newIndex == 0 {
                        // headers
                        finalCell = self.getFeeTitleCell(indexPath: indexPath, type: "Re-scheduling", aerline: "Airline Fee", aertrip: "Aertrip Fee")
                    }
                    else if newIndex == 1, let val = res.adult {
                        // adult
                        finalCell = self.getFeeDetailsCell(indexPath: indexPath, type: "Per Adult", aerlineFee: val.reduce(0, { (result, object) -> Int in
                            return result + (object.value ?? 0)
                        }), aertripFee: info.aertripResCharges?.adult ?? 0)
                    }
                    else if newIndex <= 2, let val = res.child {
                        // Child
                        finalCell = self.getFeeDetailsCell(indexPath: indexPath, type: "Per Child", aerlineFee: val.reduce(0, { (result, object) -> Int in
                            return result + (object.value ?? 0)
                        }), aertripFee: info.aertripResCharges?.child ?? 0)
                    }
                    else if newIndex <= 3, let val = res.infant {
                        if newIndex == 3 {
                            // blank
                            finalCell = getBlankSpaceCell()
                        }
                        else {
                            // infant
                            finalCell = self.getFeeDetailsCell(indexPath: indexPath, type: "Per Infant", aerlineFee: val.reduce(0, { (result, object) -> Int in
                                return result + (object.value ?? 0)
                            }), aertripFee: info.aertripResCharges?.infant ?? 0)
                        }
                    }
                    else if newIndex > 0 {
                        // blank space
                        finalCell = getBlankSpaceCell()
                    }
                }
            }
            
            if indexPath.row == self.getNumberOfCellsInFareInfoForNormalFlight(forData: info) - 2 {
                // Notes cell
                finalCell = getNotesCell()
            }
            
            if indexPath.row == getNumberOfCellsInFareInfoForNormalFlight(forData: info) - 1 {
                finalCell = getDisclamerCell()
            }
        }
        else {
            if indexPath.row == 0 {
                finalCell = getBlankSpaceCell()
            }
            else {
                finalCell = getNotesCell()
            }
        }
        return finalCell
    }
    
    func getCellForFareInfoForMultiFlight(_ indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        var finalCell = UITableViewCell()
        switch index {
        case 0:
            // flight details
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: RouteFareInfoTableViewCell.reusableIdentifier) as? RouteFareInfoTableViewCell else {
                fatalError("RouteFareInfoTableViewCell not found")
            }
            
            cell.flightDetails = self.viewModel.legDetails[indexPath.section].flight[index]
            cell.delegate = self
            
            finalCell = cell
            
        case 1:
            //title
            finalCell = self.getFeeTitleCell(indexPath: indexPath, type: "Per Pax", aerline: "Airline Fee", aertrip: "Aertrip Fee")
            
        case 2:
            // cancelation
//            finalCell = self.getFeeDetailsCell(indexPath: indexPath, type: "Cancellation", aerlineFee: self.viewModel.bookingFee[indexPath.section].aerlineCanCharges?.adult?.reduce(0, { (result, object) -> Int in
//                return result + (object.value ?? 0)
//            }) ?? 0, aertripFee: self.viewModel.bookingFee[indexPath.section].aertripCanCharges?.adult ?? 0)
            finalCell = self.getFeeDetailsCell(indexPath: indexPath, type: "Cancellation", aerlineFee:  0, aertripFee: self.viewModel.bookingFee[indexPath.section].aertripCanCharges?.adult ?? 0)
        case 3:
            // reschdule
            finalCell = self.getFeeDetailsCell(indexPath: indexPath, type: "Rescheduling", aerlineFee: self.viewModel.bookingFee[indexPath.section].aerlineResCharges?.adult?.reduce(0, { (result, object) -> Int in
                return result + (object.value ?? 0)
            }) ?? 0, aertripFee: self.viewModel.bookingFee[indexPath.section].aertripResCharges?.adult ?? 0)
            
        default:
            return finalCell
        }
        
        return finalCell
    }
}
extension FlightFareInfoVC:TravellerAddOnsCellHeightDelegate {
    
    func needToUpdateHeight(at index:IndexPath){
        self.tableView.beginUpdates()
        UIView.animate(withDuration: 0.3) {
            self.tableView.endUpdates()
        }
    }
    
}
