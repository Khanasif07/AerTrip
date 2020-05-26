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
    
    private var viewModel = SeatCollCellVM()
    var seatLayout: SeatCollCellVM.PlaneSeatsLayout = .four {
        didSet {
            viewModel.seatLayout = seatLayout
        }
    }
    
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
    
    func setupCellFor(_ indexPath: IndexPath) {
        seatView.isHidden = false
        switch (indexPath.section, indexPath.item) {
        case (0, 0):
            seatNumberLbl.isHidden = true
            seatView.layer.borderWidth = 0
        case (0, let item):
            seatNumberLbl.font = AppFonts.Regular.withSize(18)
            seatNumberLbl.isHidden = false
            seatView.layer.borderWidth = 0
            seatNumberLbl.text = "\(item - 1)"
        case (let sec, 0):
            seatNumberLbl.font = AppFonts.Regular.withSize(18)
            seatNumberLbl.isHidden = false
            seatView.layer.borderWidth = 0
            seatNumberLbl.text = viewModel.getUnicodeScalarStringFor(viewModel.seatLayout.getSeatSectionArr()[sec - 1])
        case (let sec, _):
            let curSectionType = viewModel.seatLayout.getSeatSectionArr()[sec - 1]
            switch curSectionType {
            case .blank:
                seatView.isHidden = true
            case .number(_):
                seatNumberLbl.font = AppFonts.Regular.withSize(14)
                seatNumberLbl.isHidden = true
                seatView.layer.borderWidth = 0.5
            }
        }
    }
    
    func setupCellFor(_ indexPath: IndexPath,_ rowStr: String,_ columnStr: String,_ seatData: SeatMapModel.SeatMapRow) {
        seatView.isHidden = false
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
                seatNumberLbl.isHidden = true
                seatView.layer.borderWidth = 0.5
            }
            
        }
    }
}
