//
//  SelectSeatButtonFooterVew.swift
//  AERTRIP
//
//  Created by Apple  on 05.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SelectSeatButtonFooterVew: UITableViewHeaderFooterView {

    @IBOutlet weak var selectSeatButton: UIButton!
    @IBOutlet weak var dividerView: ATDividerView!

    var handeller:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let bg = UIView(frame: self.frame)
        bg.backgroundColor = AppColors.themeWhite
        self.backgroundView = bg
        
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        self.backgroundColor = AppColors.themeWhite
        self.selectSeatButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        self.selectSeatButton.backgroundColor = AppColors.themeWhite
        self.selectSeatButton.cornerRadius = 10.0
        self.selectSeatButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.selectSeatButton.setTitleColor(AppColors.themeGreen, for: .selected)
        self.selectSeatButton.layer.borderWidth = 1.0
        self.selectSeatButton.layer.borderColor = AppColors.themeGreen.cgColor
        self.selectSeatButton.setTitle("Select Seat For...", for: .normal)
        self.selectSeatButton.setTitle("Select Seat For...", for: .selected)
    }

    @IBAction func tapSelectSeatButton(_ sender: UIButton){
        self.handeller?()
    }
    
    
}
