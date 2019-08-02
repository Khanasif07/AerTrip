//
//  BookingReschedulingHeaderView.swift
//  AERTRIP
//
//  Created by apple on 22/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookingReschedulingHeaderViewDelegate: class {
    func selectAllButtonAction(_ sender: UIButton)
}

class BookingReschedulingHeaderView: UITableViewHeaderFooterView {
    // MARK: - IBOutlet
    
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var topBackgroundView: UIView!
    
    // MARK: - Variables
    
    weak var delegate: BookingReschedulingHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpColor()
        self.addGesture()
        
        self.selectedButton.isSelected = false
    }
    
    // MARK: - Helper methods
    
    func setUpFont() {
        self.routeLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.infoLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    func setUpColor() {
        self.routeLabel.textColor = AppColors.themeBlack
        self.infoLabel.textColor = AppColors.themeBlack
    }
    
    private func addGesture() {
        // Add tap gesture to your view
        self.selectedButton.addTarget(self, action: #selector(selectAllButtonAction(_:)), for: .touchUpInside)
    }
    
    @objc private func selectAllButtonAction(_ sender: UIButton) {
        self.delegate?.selectAllButtonAction(sender)
    }
}
