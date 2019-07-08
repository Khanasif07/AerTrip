//
//  OfflineDepositeSlipUoloadCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class OfflineDepositeSlipUoloadCell: UITableViewCell {
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var imageCenterYConstraint: NSLayoutConstraint!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.setFontAndColor()
    }
    
    private func setFontAndColor() {
        
        self.backgroundColor = AppColors.themeWhite
        
        self.fileNameLabel.font = AppFonts.Regular.withSize(16.0)
        self.fileNameLabel.textColor = AppColors.themeBlack
        
        self.fileSizeLabel.font = AppFonts.Regular.withSize(14.0)
        self.fileSizeLabel.textColor = AppColors.themeGray40
    }
}
