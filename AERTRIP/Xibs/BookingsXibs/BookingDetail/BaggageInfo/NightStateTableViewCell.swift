//
//  NightStateTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class NightStateTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topBackgroundView: UIView!
    
    
    var flightDetail: BookingFlightDetail? {
        didSet {
            self.configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.backgroundColor = AppColors.clear
//        self.topBackgroundView.layer.cornerRadius = 12.0
        self.topBackgroundView.layer.borderWidth = 0.2
        self.topBackgroundView.layer.borderColor = AppColors.themeGray20.cgColor
        self.topBackgroundView.backgroundColor = AppColors.themeGray04
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.topBackgroundView.layer.cornerRadius = self.topBackgroundView.frame.height/2
    }
    
    private func configureCell() {
        if flightDetail?.ovgtlo ?? false {
        self.imageview.image = #imageLiteral(resourceName: "overnightIcon")
        var timeStr = self.flightDetail?.layoverTime.asString(units: [.hour, .minute], style: .abbreviated) ?? LocalizedString.na.localized
        timeStr = "  •  \(timeStr)"
        let finalText = "Overnight Layover in \(flightDetail?.arrivalCity ?? LocalizedString.dash.localized)\(timeStr)"//
           // let finalText = "Overnight Layover in \("Thiruvananthapuram Thiruvananthapuram")\(timeStr)"//

        self.titleLabel.attributedText = self.getAttributedBoldText(text: finalText, boldText: timeStr)
        } else {
            self.imageview.image = nil
            var timeStr = self.flightDetail?.layoverTime.asString(units: [.hour, .minute], style: .abbreviated) ?? LocalizedString.na.localized
            timeStr = "  •  \(timeStr)"
            let finalText = "Layover in \(flightDetail?.arrivalCity ?? LocalizedString.dash.localized)\(timeStr)"
            //let finalText = "Overnight Layover in \("Thiruvananthapuram Thiruvananthapuram")\(timeStr)"//

            self.titleLabel.attributedText = self.getAttributedBoldText(text: finalText, boldText: timeStr)
        }
         self.topBackgroundView.layer.cornerRadius = self.topBackgroundView.frame.height/2
    }
    
    // MARK: - Helper methods
    
    private func getAttributedBoldText(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), .foregroundColor: AppColors.themeBlack])
        
        attString.addAttributes([
            .font: AppFonts.SemiBold.withSize(14.0),
            .foregroundColor: AppColors.themeBlack
            ], range: (text as NSString).range(of: boldText))
        
        return attString
    }

}
