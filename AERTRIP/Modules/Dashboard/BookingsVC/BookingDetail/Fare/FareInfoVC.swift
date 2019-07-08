//
//  FareInfoVC.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FareInfoVC: BaseVC {
    
    @IBOutlet weak var fareInfoTableView: ATTableView!
    
    let footerViewIdentifier = "BookingInfoEmptyFooterView"
    let fareInfoHeaderViewIdentifier = "FareInfoHeaderView"
    let viewModel = FareInfoVM()
    
    override func initialSetup() {
        
        self.registerXib()
        self.fareInfoTableView.dataSource = self
        self.fareInfoTableView.delegate  = self
        self.fareInfoTableView.reloadData()
        
    }
    
    
    private func registerXib() {
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.fareInfoTableView.tableHeaderView = UIView(frame: frame)
        
        self.fareInfoTableView.register(UINib(nibName: self.fareInfoHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.fareInfoHeaderViewIdentifier)
        self.fareInfoTableView.register(UINib(nibName: self.footerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.footerViewIdentifier)

        self.fareInfoTableView.registerCell(nibName: EconomySaverTableViewCell.reusableIdentifier)
        self.fareInfoTableView.registerCell(nibName: BookingInfoCommonCell.reusableIdentifier)
        self.fareInfoTableView.registerCell(nibName: FareInfoNoteTableViewCell.reusableIdentifier)
        self.fareInfoTableView.registerCell(nibName: EmptyDividerViewCellTableViewCell.reusableIdentifier)
    }
}


// MARK: - UITableViewDataSource and UITableViewDelegate methods

extension FareInfoVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let fbn = self.viewModel.legDetails?.flight.first?.fbn {
            return !fbn.isEmpty ? 114.0 : 74.0
        }
        return 0.0
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let fbn = self.viewModel.legDetails?.flight.first?.fbn {
            
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.fareInfoHeaderViewIdentifier) as? FareInfoHeaderView else { return nil }
            
            let titleTxt = fbn
            headerView.titleLabel.text = titleTxt
            headerView.dividerView.isHidden = titleTxt.isEmpty
            
            headerView.refundPolicyLabel.text = "Refund Policy"
//            headerView.delegate = self
            headerView.fareRulesButton.setTitle(LocalizedString.FareRules.localized, for: .normal)
            
            var infoText = "We do not have information regarding refundability/reschedulability"
            if let leg = self.viewModel.legDetails {
                if leg.refundable == 1 {
                    infoText = "Refundable"
                }
                else if leg.refundable == -9 {
                    infoText = LocalizedString.na.localized
                }
                else {
                    infoText = "Non-refundable"
                }
                
                
                if leg.reschedulable == 1 {
                    infoText += infoText.isEmpty ? "Reschedulable" : " • Reschedulable"
                }
                else if leg.refundable == -9 {
                    infoText += infoText.isEmpty ? LocalizedString.na.localized : " • \(LocalizedString.na.localized)"
                }
                else {
                    infoText += infoText.isEmpty ? "Non-reschedulable" : " • Non-reschedulable"
                }
            }
            
            headerView.infoLabel.text = infoText
            
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as? BookingInfoEmptyFooterView else {
            fatalError("BookingInfoFooterView not found")
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getNumberOfCellsInFareInfoForNormalFlight(forData: self.viewModel.bookingFee)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == (self.getNumberOfCellsInFareInfoForNormalFlight(forData: self.viewModel.bookingFee)-1) {
            return UITableView.automaticDimension
        }
        else if let info = self.viewModel.bookingFee {
            if let can = info.aerlineCanCharges {
                if indexPath.row == (getCancelChargesCount(charge: can)-1) {
                    return 50.0
                }
                return 28.0
            }
            
            if let res = info.aerlineResCharges {
                if indexPath.row == (getResChargesCount(charge: res)-1) {
                    return 50.0
                }
                return 28.0
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCellForFareInfoForNormalFlight(indexPath)
    }
}

extension FareInfoVC {
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
    
    func getFeeDetailsCell(indexPath: IndexPath, type: String, aerlineFee: Int, aertripFee: Int) -> UITableViewCell {
        guard  let commonCell = self.fareInfoTableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell", for: indexPath) as? BookingInfoCommonCell else {
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
        guard  let commonCell = self.fareInfoTableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell", for: indexPath) as? BookingInfoCommonCell else {
            fatalError("BookingInfoCommonCell not found")
        }
        
        commonCell.middleLabel.font = AppFonts.SemiBold.withSize(16.0)
        commonCell.rightLabel.font = AppFonts.SemiBold.withSize(16.0)
        
        commonCell.leftLabel.text = type
        commonCell.middleLabel.text = aerline
        commonCell.rightLabel.text = aertrip
        return commonCell
    }
    
    func getCellForFareInfoForNormalFlight(_ indexPath: IndexPath) -> UITableViewCell  {
        
        func getNotesCell() -> UITableViewCell {
            guard let fareInfoNoteCell = self.fareInfoTableView.dequeueReusableCell(withIdentifier: "FareInfoNoteTableViewCell") as? FareInfoNoteTableViewCell else {
                fatalError("FareInfoNoteTableViewCell not found")
            }
            fareInfoNoteCell.isForBookingPolicyCell = false
            fareInfoNoteCell.noteLabel.text = LocalizedString.Notes.localized
            fareInfoNoteCell.configCell(notes: self.viewModel.fareInfoNotes)
            return fareInfoNoteCell
        }
        
        func getBlankSpaceCell() -> UITableViewCell {
            guard let emptyDividerViewCell = self.fareInfoTableView.dequeueReusableCell(withIdentifier: "EmptyDividerViewCellTableViewCell") as? EmptyDividerViewCellTableViewCell else {
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

}
