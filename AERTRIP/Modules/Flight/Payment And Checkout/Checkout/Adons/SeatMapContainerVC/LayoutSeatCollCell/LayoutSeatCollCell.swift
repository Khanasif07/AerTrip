//
//  LayoutSeatCollCell.swift
//  AERTRIP
//
//  Created by Rishabh on 09/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class LayoutSeatCollCell: UICollectionViewCell {
    
    // MARK: Variables
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var seatView: UIView!
    
    // MARK: View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        intialSetup()
    }
    
    // MARK: Functions
    
    private func intialSetup() {
        seatView.roundedCorners(cornerRadius: 0.5)
        seatView.addShadow(withColor: AppColors.themeGray10)
    }
    
    func populateCell(_ seatData: SeatMapModel.SeatMapRow,_ columnStr: String) {
        if columnStr.contains("aisle") {
            seatView.isHidden = true
        } else {
            seatView.isHidden = false
            if seatData.columnData.availability != .available || seatData.columnData.postBooking {
                seatView.backgroundColor = AppColors.themeGray20
            } else if seatData.columnData.passenger != nil {
                seatView.backgroundColor = AppColors.themeGreen
            } else {
                seatView.backgroundColor = AppColors.themeWhite
            }
        }
    }
}
