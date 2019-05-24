//
//  BookingPassengerTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 23/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookingPassengerTableViewCellDelegate: class {
    func arrowButtonTapped(arrowButton: UIButton)
}

class BookingPassengerTableViewCell: ATTableViewCell {
    // MARK: - IBOutlet
    
    @IBOutlet var passengerNameLabel: UILabel!
    @IBOutlet var arrowButton: UIButton!
    @IBOutlet var statusButton: UIButton!
    
    // MARK: - Variabels
    
    weak var delegate: BookingPassengerTableViewCellDelegate?
    
    var passenger: BookingPassenger = BookingPassenger() {
        didSet {
            self.configureCell()
        }
    }
    
    // MARK: - Override methods
    
    override func setupFonts() {
        self.passengerNameLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.passengerNameLabel.textColor = AppColors.themeBlack
    }
    
    func configureCell() {
        self.passengerNameLabel.text = self.passenger.name
    }
    
    @IBAction func arrowButtonTapped(_ sender: UIButton) {
        self.delegate?.arrowButtonTapped(arrowButton: sender)
    }
}
