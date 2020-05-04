//
//  BaggageAirlineInfoTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BaggageAirlineInfoTableViewCellDelegate: class {
    func dimensionButtonTapped(_ dimensionButton: UIButton)
}

class BaggageAirlineInfoTableViewCell: UITableViewCell {

    
    //MARK: - IB Outlets
    @IBOutlet weak var airlineImageView: UIImageView!
    @IBOutlet weak var airlineNameLabel: UILabel!
    @IBOutlet weak var dimensionButton: UIButton!
    
    // MARK: - Variables
    weak var delegate: BaggageAirlineInfoTableViewCellDelegate?
    
    var flightDetail: FlightDetail? {
        didSet {
            self.configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpTextColor()
        self.setUpText()
    }

    // Helper methods
    
    private func setUpFont() {
        self.airlineNameLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.dimensionButton.titleLabel?.font = AppFonts.SemiBold.withSize(16.0)
        
    }
    
    private func setUpTextColor() {
        self.airlineNameLabel.textColor = AppColors.themeBlack
        self.dimensionButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    private func setUpText() {
       self.dimensionButton.setTitle(LocalizedString.Dimensions.localized, for: .normal)
    }
    
    
    private func configureCell() {
        self.airlineNameLabel.text = "\(self.flightDetail?.departCity ?? "") → \(self.flightDetail?.arrivalCity ?? "")"
//        var finalDetails = ""
//        if let obj = self.flightDetail?.operatedBy, !obj.isEmpty {
//            finalDetails = obj
//        }
        
//        let detail = "\(self.flightDetail?.carrierCode ?? LocalizedString.na.localized)-\(self.flightDetail?.flightNumber ?? LocalizedString.na.localized)・\(self.flightDetail?.cabinClass ?? LocalizedString.na.localized) \((self.flightDetail?.bookingClass.isEmpty ?? false) ? "" : ("(\(self.flightDetail?.bookingClass ?? ""))"))"
//
//        finalDetails += finalDetails.isEmpty ? detail : "\n\(detail)"
//
//        self.airlineCodeLabel.text = finalDetails
        
        if let code = self.flightDetail?.carrierCode, !code.isEmpty {
            let imageUrl = AppGlobals.shared.getAirlineCodeImageUrl(code: code)
            self.airlineImageView.setImageWithUrl(imageUrl, placeholder: AppPlaceholderImage.default, showIndicator: true)
        }
    }
    
    @IBAction func dimensionButtonTapped(_ sender: Any) {
        self.delegate?.dimensionButtonTapped(self.dimensionButton)
    }
    
    
}
