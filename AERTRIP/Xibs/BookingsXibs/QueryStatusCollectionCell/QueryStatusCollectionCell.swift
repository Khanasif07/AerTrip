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
        self.statusLabel.textColor = AppColors.themeBlack
        self.statusLabel.font = AppFonts.Regular.withSize(14.0)
        self.backgroundColor = AppColors.clear
        self.containerView.backgroundColor = AppColors.clear
        self.clipsToBounds = true
    }
    
    private func setData() {
        self.statusLabel.text = self.statusText
        self.statusImageView.image = nil
        
        self.statusLabel.textColor = AppColors.themeBlack
        if self.statusText.lowercased().hasSuffix("successful") {
            self.iconHeightConstraint.constant = 22.0
            self.statusImageView.image = #imageLiteral(resourceName: "checkIcon")
        }
        else if self.statusText.lowercased().hasSuffix("required") {
            self.iconHeightConstraint.constant = 8.0
            self.statusImageView.image = #imageLiteral(resourceName: "ic_red_dot")
        }
        else if self.statusText.lowercased().hasSuffix("pending") {
            self.iconHeightConstraint.constant = 8.0
            self.statusImageView.image = #imageLiteral(resourceName: "ic_red_dot")
        }
        else if self.statusText.lowercased().hasSuffix("aborted") {
            self.statusLabel.textColor = AppColors.themeGray20
            self.statusImageView.image = nil
            self.iconHeightConstraint.constant = 0.0
        }
    }
    
    //MARK:- IBActions
    //================
    
}
