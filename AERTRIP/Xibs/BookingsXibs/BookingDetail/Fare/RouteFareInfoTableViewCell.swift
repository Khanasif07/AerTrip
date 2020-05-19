//
//  RouteFareInfoTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol RouteFareInfoTableViewCellDelegate: class {
    func viewDetailsButtonTapped(_ sender: UIButton)
}

class RouteFareInfoTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var viewDetailButton: UIButton!
    
    // MARK: - Variables
    weak var delegate: RouteFareInfoTableViewCellDelegate?
    
    var flightDetails: BookingFlightDetail? {
        didSet {
            self.configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.setUpFont()
        self.setUpTextColor()
        
    }
    
    private func setUpFont() {
        self.routeLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.infoLabel.font = AppFonts.Regular.withSize(14.0)
        self.viewDetailButton.titleLabel?.font = AppFonts.SemiBold.withSize(16.0)
    }
    
    private func setUpTextColor() {
        self.routeLabel.textColor = AppColors.themeBlack
        self.infoLabel.textColor = AppColors.themeGray40
        self.viewDetailButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.viewDetailButton.setTitle(LocalizedString.ViewDetails.localized, for: .normal)
    }
    
    private func configureCell() {
        self.routeLabel.text = "\(flightDetails?.departCity ?? LocalizedString.na.localized) → \(flightDetails?.arrivalCity ?? LocalizedString.na.localized)"
        
        //18 Jul 2018
        var dateStr = (flightDetails?.departDate?.toString(dateFormat: "dd MMM yyyy") ?? "")
        dateStr = dateStr.isEmpty ? LocalizedString.na.localized : dateStr
        self.infoLabel.text = "\(dateStr) • \(flightDetails?.fbn ?? LocalizedString.na.localized)"
    }
    
    @IBAction func viewDetailButtonTapped(_ sender: UIButton) {
        delegate?.viewDetailsButtonTapped(sender)
    }
}
