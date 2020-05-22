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
        seatView.roundedCorners(cornerRadius: 5)
        seatView.layer.borderColor = AppColors.themeGray20.cgColor
    }
    
    func setupCellFor(_ indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            seatNumberLbl.isHidden = true
            seatView.layer.borderWidth = 0
        } else if indexPath.section == 0 {
            seatNumberLbl.isHidden = false
            seatView.layer.borderWidth = 0
            seatNumberLbl.text = "\(indexPath.row - 1)"
        } else if indexPath.row == 0 {
            seatNumberLbl.isHidden = false
            seatView.layer.borderWidth = 0
            seatNumberLbl.text = "\(indexPath.section - 1)"
        } else {
            seatNumberLbl.isHidden = true
            seatView.layer.borderWidth = 0.5
        }
    }
}
