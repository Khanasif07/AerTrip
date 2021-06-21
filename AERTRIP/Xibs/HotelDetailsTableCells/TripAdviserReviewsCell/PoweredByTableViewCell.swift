//
//  PoweredByTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class PoweredByTableViewCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var tripAdvisorImageView: UIImageView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    private func configUI() {
        self.titleLable.font = AppFonts.Regular.withSize(18.0)
        self.titleLable.textColor = AppColors.themeBlack
        self.tripAdvisorImageView.image = AppImages.tripAdvisorLogo
    }
    
    internal func configCell() {
    }
        
}
