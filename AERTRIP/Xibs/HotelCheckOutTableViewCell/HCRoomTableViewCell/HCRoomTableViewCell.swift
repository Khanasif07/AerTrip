//
//  HCRoomTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 02/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCRoomTableViewCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var cntainerView: UIView!
    @IBOutlet weak var roomTitleLabel: UILabel!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configCell()
    }
    
    //Mark:- Functions
    //================
    private func configCell() {
        self.cntainerView.backgroundColor = AppColors.screensBackground.color
        self.roomTitleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.roomTitleLabel.text = LocalizedString.Room.localized
        self.roomTitleLabel.textColor = AppColors.themeBlack
    }
}
