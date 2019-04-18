//
//  QueryStatusTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class QueryStatusTableViewCell: UITableViewCell {

    //Mark:- Variables
    //================
    
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        self.statusLabel.textColor = AppColors.themeBlack
        self.statusLabel.font = AppFonts.Regular.withSize(14.0)
        self.backgroundColor = AppColors.screensBackground.color
//        self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner ,.layerMinXMaxYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.1), offset: CGSize(width: 0.0, height: 2.0), opacity: 0.7, shadowRadius: 2.0)
    }
    
    internal func configCell(status: String , statusImage: UIImage) {
        self.statusLabel.text = status
        self.statusImageView.image = statusImage
    }
    
    //Mark:- IBActions
    //================
    
}
