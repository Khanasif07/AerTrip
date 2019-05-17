//
//  BookingRequestStatusTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 17/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingRequestStatusTableViewCell: ATTableViewCell {

      // MARK:- IBOutlet
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    // MARK:- Override methods
    
    
    override func setupColors() {
        self.containerView.backgroundColor = AppColors.themeGray40
        self.titleLabel.textColor = AppColors.themeWhite
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        
    }
    
    
    // MARK: - Helper methods
    
    func configureCell(_ title: String) {
        self.titleLabel.text = title
        }
    
    
    
    
    
}
