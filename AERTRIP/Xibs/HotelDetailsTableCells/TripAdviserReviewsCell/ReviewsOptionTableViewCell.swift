//
//  ReviewsOptionTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ReviewsOptionTableViewCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightImgView: UIImageView!
    @IBOutlet weak var dividerView: ATDividerView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    private func configUI() {
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        self.titleLabel.textColor = AppColors.reviewGreen
    }
    
    internal func configCell() {
        
    }
}
