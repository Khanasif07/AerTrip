//
//  HotelResultSectionHeader.swift
//  AERTRIP
//
//  Created by Admin on 01/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelResultSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelBackgroundView: UIView!
    @IBOutlet weak var labelCenterConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.layer.cornerRadius = titleLabel.frame.size.height / 2
        labelBackgroundView.layer.cornerRadius =  labelBackgroundView.frame.size.height / 2
        labelBackgroundView.layer.masksToBounds = true
        titleLabel.layer.masksToBounds = true
        labelBackgroundView.addBlurEffect(backgroundColor: AppColors.themeGray10.withAlphaComponent(0.85), style:  UIBlurEffect.Style.light, alpha: 1)
        labelBackgroundView.backgroundColor = AppColors.clear
        titleLabel.font = AppFonts.Regular.withSize(14.0)
        //        UIView.animate(withDuration: 0.5) {
        //            if #available(iOS 14.0, *) {
        //                self.setNeedsUpdateConfiguration()
        //            } else {
        //                // Fallback on earlier versions
        //            }
        //        }
        self.backgroundView?.backgroundColor = AppColors.clear
        self.containerView.backgroundColor = AppColors.clear
        self.contentView.backgroundColor = AppColors.clear
        self.backgroundColor = AppColors.clear
        
        if #available(iOS 14.0, *) {
            var bgConfig = UIBackgroundConfiguration.listPlainCell()
            bgConfig.backgroundColor = UIColor.clear
            self.backgroundConfiguration = bgConfig
            //For cell use: UITableViewCell.appearance().backgroundConfiguration = bgConfig
            
            //            self.automaticallyUpdatesContentConfiguration = false
            //            self.automaticallyUpdatesBackgroundConfiguration = false
        } else {
            // Fallback on earlier versions
        }
        
    }
}
