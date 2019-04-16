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
        self.backgroundColor = AppColors.themeWhite
    }
    
    internal func configCell(status: String , statusImage: UIImage , isLastCell: Bool) {
        self.statusLabel.text = status
        self.statusImageView.image = statusImage
        if isLastCell {
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner ,.layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize(width: 0.0, height: 1.5), opacity: 0.7, shadowRadius: 1.5)
        } else {
            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize(width: 0.0, height: 1.5), opacity: 0.7, shadowRadius: 1.5)
        }
    }
    
    //Mark:- IBActions
    //================
    
}
