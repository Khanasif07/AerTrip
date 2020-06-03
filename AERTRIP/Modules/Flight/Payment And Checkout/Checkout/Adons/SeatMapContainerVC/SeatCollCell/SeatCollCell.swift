//
//  SeatCollCell.swift
//  AERTRIP
//
//  Created by Rishabh on 22/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SeatCollCell: UICollectionViewCell {

    // MARK: Variables
    
     var viewModel = SeatCollCellVM()

    // MARK: IBOutlets
    
    @IBOutlet weak var seatView: UIView!
    @IBOutlet weak var seatNumberLbl: UILabel!
    
    // MARK: View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    // MARK: Functions
    
    private func initialSetup() {
        seatNumberLbl.textColor = AppColors.themeGray40
        seatView.roundedCorners(cornerRadius: 5)
        seatView.layer.borderColor = AppColors.themeGray20.cgColor
    }
    
//    func setupCellFor(_ indexPath: IndexPath) {
//        seatView.isHidden = false
//        switch (indexPath.section, indexPath.item) {
//        case (0, 0):
//            seatNumberLbl.isHidden = true
//            seatView.layer.borderWidth = 0
//        case (0, let item):
//            seatNumberLbl.font = AppFonts.Regular.withSize(18)
//            seatNumberLbl.isHidden = false
//            seatView.layer.borderWidth = 0
//            seatNumberLbl.text = "\(item - 1)"
//        case (let sec, 0):
//            seatNumberLbl.font = AppFonts.Regular.withSize(18)
//            seatNumberLbl.isHidden = false
//            seatView.layer.borderWidth = 0
//            seatNumberLbl.text = viewModel.getUnicodeScalarStringFor(viewModel.seatLayout.getSeatSectionArr()[sec - 1])
//        case (let sec, _):
//            let curSectionType = viewModel.seatLayout.getSeatSectionArr()[sec - 1]
//            switch curSectionType {
//            case .blank:
//                seatView.isHidden = true
//            case .number(_):
//                seatNumberLbl.font = AppFonts.Regular.withSize(14)
//                seatNumberLbl.isHidden = true
//                seatView.layer.borderWidth = 0.5
//            }
//        }
//    }
    
    func setupViewModel(_ seatData: SeatMapModel.SeatMapRow,_ flightFares: (Int, Int)) {
        viewModel = SeatCollCellVM(seatData, flightFares)
    }
    
    private func setupSeatPriceLbl() {
        if viewModel.seatData.columnData.availability != .available || viewModel.seatData.columnData.postBooking {
            seatView.backgroundColor = AppColors.themeGray20
            seatNumberLbl.text?.removeAll()
            seatNumberLbl.isHidden = true
            return
        }
        seatView.backgroundColor = AppColors.themeWhite
        if viewModel.seatData.columnData.amount < viewModel.flightFares.minAmount {
            seatNumberLbl.text?.removeAll()
            seatNumberLbl.isHidden = true
        } else {
            seatNumberLbl.isHidden = false
            let seatAmount = viewModel.seatData.columnData.amount
            let fareDiff: Float = Float(viewModel.flightFares.maxAmount - viewModel.flightFares.minAmount)
            let fareClass: Float = Float(seatAmount - viewModel.flightFares.minAmount)
            let farePercent = (fareClass/fareDiff) * 100
            switch farePercent {
            case 0..<33.33:
                seatNumberLbl.text = "₹"
            case 33.34..<66.66:
                seatNumberLbl.text = "₹₹"
            case 66.67...100:
                seatNumberLbl.text = "₹₹₹"
            default: break
            }
        }
    }
    
    func setupCellFor(_ indexPath: IndexPath,_ rowStr: String,_ columnStr: String) {
        seatView.isHidden = false
        seatView.backgroundColor = AppColors.themeWhite
        switch (indexPath.section, indexPath.item) {
        case (0, 0):
            seatNumberLbl.isHidden = true
            seatView.layer.borderWidth = 0
        case (0, _):
            seatNumberLbl.font = AppFonts.Regular.withSize(18)
            seatNumberLbl.isHidden = false
            seatView.layer.borderWidth = 0
            seatNumberLbl.text = rowStr
        case (_, 0):
            seatNumberLbl.font = AppFonts.Regular.withSize(18)
            seatNumberLbl.isHidden = false
            seatView.layer.borderWidth = 0
            let columnText = columnStr == "aisle" ? "" : columnStr
            seatNumberLbl.text = columnText
        case (_, _):
            if columnStr.contains("aisle") {
                seatView.isHidden = true
            } else {
                seatNumberLbl.font = AppFonts.Regular.withSize(14)
                setupSeatPriceLbl()
                seatView.layer.borderWidth = 0.5
            }
        }
    }
    
}
