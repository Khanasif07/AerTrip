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
        var timeStr = self.flightDetail?.layoverTime.asString(units: [.hour, .minute], style: .abbreviated) ?? LocalizedString.na.localized
        timeStr = "  •  \(timeStr)"
        let finalText = " Overnight Layover in \(flightDetail?.arrivalCity ?? LocalizedString.dash.localized)\(timeStr)"//
           // let finalText = " Overnight Layover in \("Thiruvananthapuram Thiruvananthapuram")\(timeStr)"//

            self.titleLabel.attributedText = self.getAttributedBoldText(text: finalText, boldText: timeStr, image: #imageLiteral(resourceName: "overnightIcon"))
        } else {
            var timeStr = self.flightDetail?.layoverTime.asString(units: [.hour, .minute], style: .abbreviated) ?? LocalizedString.na.localized
            timeStr = "  •  \(timeStr)"
            let finalText = "Layover in \(flightDetail?.arrivalCity ?? LocalizedString.dash.localized)\(timeStr)"
//            let finalText = " Overnight Layover in \("Thiruvananthapuram Thiruvananthapuram")\(timeStr)"//

            self.titleLabel.attributedText = self.getAttributedBoldText(text: finalText, boldText: timeStr, image: nil)
        }
         self.topBackgroundView.layer.cornerRadius = self.topBackgroundView.frame.height/2
    }
    
    // MARK: - Helper methods
    
    private func getAttributedBoldText(text: String, boldText: String, image: UIImage?) -> NSMutableAttributedString {
        
        
        let fullString = NSMutableAttributedString()
        let font = AppFonts.Regular.withSize(14.0)
        if let img = image {
        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        
        //        image1Attachment.bounds.origin = CGPoint(x: 0.0, y: 5.0)
//        if let size = imageSize {
//            image1Attachment.bounds = CGRect(x: startText.isEmpty ? 0 : -4, y: (font.capHeight - size).rounded() / 2, width: size, height: size)
//
//        } else {
            image1Attachment.bounds = CGRect(x: 0, y: (font.capHeight - img.size.height).rounded() / 2, width: img.size.width, height: img.size.height)
//        }
        image1Attachment.image = image
        
        // wrap the attachment in its own attributed string so we can append it
        
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(image1String)
        }
        
       // let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: font, .foregroundColor: AppColors.themeBlack])
        
        fullString.append(NSAttributedString(string: text))
        
        fullString.addAttributes([NSAttributedString.Key.font: font, .foregroundColor: AppColors.themeBlack], range: NSRange(location: 0, length: fullString.length))

        
        fullString.addAttributes([
            .font: AppFonts.SemiBold.withSize(14.0),
            .foregroundColor: AppColors.themeBlack
            ], range: (fullString.string as NSString).range(of: boldText))
        
        return fullString
    }

}
