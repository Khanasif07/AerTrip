//
//  BookingReschedulingHeaderView.swift
//  AERTRIP
//
//  Created by apple on 22/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookingReschedulingHeaderViewDelegate: class {
    func headerViewTapped(_ view: UITableViewHeaderFooterView)
}

class BookingReschedulingHeaderView: UITableViewHeaderFooterView {
    // MARK: - IBOutlet
    
    @IBOutlet var routeLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var selectedButton: UIButton!
    @IBOutlet var topBackgroundView: UIView!
    
    // MARK: - Variables
    
    weak var delegate: BookingReschedulingHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpColor()
        self.addGesture()
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleGesture))
        self.topBackgroundView.addGestureRecognizer(tap)
    }
    
    // GestureRecognizer
    @objc func handleGesture(gesture: UITapGestureRecognizer) {
        self.delegate?.headerViewTapped(self)
    }
}
