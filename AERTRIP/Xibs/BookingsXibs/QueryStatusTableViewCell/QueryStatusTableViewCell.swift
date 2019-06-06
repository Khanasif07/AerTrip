//
//  QueryStatusTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class QueryStatusTableViewCell: UITableViewCell {

    //MARK:- Variables
    //MARK:===========
    
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configUI() {
        self.statusLabel.textColor = AppColors.themeBlack
        self.statusLabel.font = AppFonts.Regular.withSize(14.0)
        self.backgroundColor = AppColors.themeWhite
        self.clipsToBounds = true
    }
    
    internal func configCell(status: String , statusImage: UIImage , isLastCell: Bool) {
        self.statusLabel.text = status
        self.statusImageView.image = statusImage
        if isLastCell {
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner ,.layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
        } else {
            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
        }
    }
    
    //MARK:- IBActions
    //MARK:===========
    
}
