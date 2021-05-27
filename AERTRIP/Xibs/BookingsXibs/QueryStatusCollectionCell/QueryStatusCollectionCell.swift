//
//  QueryStatusTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class QueryStatusCollectionCell: UICollectionViewCell {

    //MARK:- Variables
    //MARK:===========
    
    
    //MARK:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var iconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconTrailingConstraint: NSLayoutConstraint!
    
    var statusText: String = "" {
        didSet {
            self.setData()
        }
    }
    
    //MARK:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //MARK:- Functions
    //================
    private func configUI() {
        self.statusLabel.textColor = AppColors.themeGray60
        self.statusLabel.font = AppFonts.Regular.withSize(14.0)
        self.backgroundColor = AppColors.clear
        self.containerView.backgroundColor = AppColors.clear
        self.clipsToBounds = true
    }
    
    private func setData() {
        self.statusLabel.text = self.statusText
        self.statusImageView.image = nil
        
        self.statusLabel.textColor = AppColors.themeGray60
        if self.statusText.lowercased().hasSuffix("successful") {
            self.iconHeightConstraint.constant = 22
            self.iconTrailingConstraint.constant = -7
            self.statusImageView.image = AppImages.checkIcon
        }
        else if self.statusText.lowercased().hasSuffix("required") {
            self.iconHeightConstraint.constant = 8.0
            self.iconTrailingConstraint.constant = 0
            self.statusImageView.image = AppImages.ic_red_dot
        }
        else if self.statusText.lowercased().hasSuffix("pending") {
            self.iconHeightConstraint.constant = 8.0
            self.iconTrailingConstraint.constant = 0
            self.statusImageView.image = AppImages.ic_red_dot
        }
        else if self.statusText.lowercased().hasSuffix("aborted") ||
                    self.statusText.lowercased().hasSuffix("terminated") {
            self.statusLabel.textColor = AppColors.themeGray40
            self.statusImageView.image = nil
            self.iconHeightConstraint.constant = 0.0
            self.iconTrailingConstraint.constant = 8
        }
    }
    
    //MARK:- IBActions
    //================
    
}
