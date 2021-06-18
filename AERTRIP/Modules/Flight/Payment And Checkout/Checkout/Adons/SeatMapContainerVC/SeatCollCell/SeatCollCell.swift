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
    @IBOutlet weak var unAvailableImgView: UIImageView!
    
    // MARK: View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        seatView.layer.borderColor = AppColors.seatsBorder.cgColor
    }
    
    // MARK: Functions
    
    private func initialSetup() {
        seatNumberLbl.textColor = AppColors.themeGray40
        seatView.roundedCorners(cornerRadius: 5)
        seatView.layer.borderColor = AppColors.seatsBorder.cgColor
        backgroundColor = AppColors.themeWhite
    }
    
    func setupViewModel(_ seatData: SeatMapModel.SeatMapRow,_ flightFares: (Int, Int),_ setupFor: SeatMapContainerVM.SetupFor) {
        viewModel = SeatCollCellVM(seatData, flightFares, setupFor)
    }
    
    private func setupSeatPriceLbl() {
        seatNumberLbl.isHidden = true
        switch viewModel.seatData.columnData.availability {
        case .occupied:
            seatView.backgroundColor = AppColors.seatsGray
            return
        case .blocked, .none:
            seatView.backgroundColor = AppColors.seatsGray
            toggleUnavailableImgView(false)
            return
        default:    break
        }
        
        seatView.backgroundColor = AppColors.themeWhite
        seatNumberLbl.isHidden = false
        seatView.layer.borderColor = AppColors.seatsBorder.cgColor
        if let passenger = viewModel.seatData.columnData.passenger {
            seatNumberLbl.text = passenger.firstName.firstCharacter.uppercased() + passenger.lastName.firstCharacter.uppercased()
            seatView.backgroundColor = AppColors.themeGreen
            seatNumberLbl.textColor = .white//
            return
        } else if viewModel.seatData.isPreselected {
            seatView.layer.borderColor = AppColors.themeGreen.cgColor
            seatView.layer.borderWidth = 1
            seatNumberLbl.textColor = AppColors.themeGray40
            
        } else if viewModel.seatData.columnData.postBooking && viewModel.setupFor == .preSelection {
            seatView.backgroundColor = AppColors.lightYellow
            seatNumberLbl.textColor = AppColors.postBookingSeatColor
        }
        if viewModel.seatData.columnData.amount < viewModel.flightFares.minAmount {
            seatNumberLbl.text?.removeAll()
            seatNumberLbl.isHidden = true
        } else {
            seatNumberLbl.textColor = AppColors.blackWith15PerAlpha
            seatNumberLbl.isHidden = false
            let seatAmount = viewModel.seatData.columnData.amount
            let fareDiff: Float = Float(viewModel.flightFares.maxAmount - viewModel.flightFares.minAmount)
            let fareClass: Float = Float(seatAmount - viewModel.flightFares.minAmount)
            let farePercent = (fareClass/fareDiff) * 100
            switch farePercent {
            case 0..<33.33:
                seatNumberLbl.text = "₹"
            case 33.33..<66.66:
                seatNumberLbl.text = "₹₹"
            case 66.66...100:
                seatNumberLbl.text = "₹₹₹"
            default: break
            }
        }
    }
    
    func setupCellFor(_ indexPath: IndexPath,_ rowStr: String,_ columnStr: String) {
        seatView.isHidden = false
        seatView.backgroundColor = AppColors.themeWhite
        seatNumberLbl.textColor = AppColors.themeGray40
        seatNumberLbl.text?.removeAll()
        toggleUnavailableImgView(true)
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
            let columnText = columnStr.lowercased() == "aisle" ? "" : columnStr
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
    
    private func toggleUnavailableImgView(_ hidden: Bool) {
        if hidden {
            unAvailableImgView.isHidden = true
        } else {
            unAvailableImgView.isHidden = false
        }
    }
    
}
