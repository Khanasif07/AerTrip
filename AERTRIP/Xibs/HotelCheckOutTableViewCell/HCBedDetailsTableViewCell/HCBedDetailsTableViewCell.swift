//
//  HCBedDetailsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCBedDetailsTableViewCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var roomDescLabel: UILabel!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Methods
    //==============
    ///COnfigure UI
    private func configUI() {
        //Font
        self.roomNumberLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.roomNameLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.roomDescLabel.font = AppFonts.Regular.withSize(14.0)
        //Text
        
        //Color
        self.roomNumberLabel.textColor = AppColors.themeBlack
        self.roomNameLabel.textColor = AppColors.themeBlack
        self.roomDescLabel.textColor = AppColors.themeBlack
    }
    
    ///Configure Cell
    internal func configCell(roomData: Room, index: String) {
        self.roomNumberLabel.text = LocalizedString.Room.localized + " \(index)"
        self.roomDescLabel.text = roomData.name
    }
}
