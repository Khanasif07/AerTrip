//
//  CurrencyCellTableViewCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencySymbolLabel: UILabel!
    @IBOutlet weak var sepratorView: ATDividerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        setFonts()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.currencySymbolLabel.attributedText = nil
        self.currencySymbolLabel.text = nil
        setFonts()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setFonts(){
        let fontSize: CGFloat = UIScreen.width > 320 ? 18 : 14
        currencyNameLabel.font = AppFonts.Regular.withSize(fontSize)
        currencyCodeLabel.font = AppFonts.Regular.withSize(fontSize)
        currencySymbolLabel.font = AppFonts.Regular.withSize(fontSize)
    }
    
    func populateData(country : CurrencyModel, isSelected : Bool){
                self.currencySymbolLabel.text = country.currencySymbol
                self.currencyNameLabel.text = country.currencyName
                self.currencyCodeLabel.text = country.currencyCode
        self.tickImageView.isHidden = isSelected
        
        /*
        //        self.currencySymbolLabel.text = country.currencySymbol
        self.currencyNameLabel.text = country.name
        self.currencyCodeLabel.text = country.code
        
        if let image = UIImage(named: country.icon.replacingOccurrences(of: "icon icon_", with: "")) {
            
            if country.textSuffix  {
                self.currencySymbolLabel.attributedText = getTextWithImage(startText: "", image: image, endText: country.text, font: AppFonts.Regular.withSize(18), imageSize: 16)
                
            } else {
                self.currencySymbolLabel.attributedText = getTextWithImage(startText: country.text, image: image, endText: "", font: AppFonts.Regular.withSize(18), imageSize: 16)
                
            }
        } else {
            self.currencySymbolLabel.text = country.text
        }
 */
        
    }
    
    func getTextWithImage(startText: String, image: UIImage, endText: String, font: UIFont, imageSize: CGFloat? = nil) -> NSMutableAttributedString {
        // create an NSMutableAttributedString that we'll append everything to
        let fullString = NSMutableAttributedString()
        
        if !startText.isEmpty {
            fullString.append(NSAttributedString(string: startText))
        }
        
        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        
        //        image1Attachment.bounds.origin = CGPoint(x: 0.0, y: 5.0)
        if let size = imageSize {
            image1Attachment.bounds = CGRect(x: startText.isEmpty ? 0 : -4, y: (font.capHeight - size).rounded() / 2, width: size, height: size)
            
        } else {
            image1Attachment.bounds = CGRect(x: 0, y: (font.capHeight - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        }
        image1Attachment.image = image
        
        // wrap the attachment in its own attributed string so we can append it
        
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(image1String)
        
        if !endText.isEmpty {
            fullString.append(NSAttributedString(string: endText))
        }
        
        fullString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: fullString.length))
        
        return fullString
    }
    
}
