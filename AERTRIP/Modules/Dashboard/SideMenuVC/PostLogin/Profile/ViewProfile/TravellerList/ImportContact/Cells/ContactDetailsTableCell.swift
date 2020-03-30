//
//  ContactDetailsTableCell.swift
//  AERTRIP
//
//  Created by Admin on 09/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Contacts

class ContactDetailsTableCell: UITableViewCell {
    
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var userImageView: UIImageView!
    
    var contact: ATContact? {
        didSet {
            self.populateData()
        }
    }
    
    var traveller: TravellerModel? {
        didSet {
            self.populateData()
        }
    }
    
    var cnContact: CNContact? {
        didSet {
            self.populateData()
        }
    }
    
    var showSalutationImage = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        initialSetup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showSalutationImage = false
        userImageView.image = nil
        nameLabel.text = nil
    }
  
    private func initialSetup() {
        self.contentView.layoutIfNeeded()
        self.userImageView.makeCircular()
    }
    
    private func setupTextAndColor() {
        self.nameLabel.textColor = AppColors.themeBlack
        self.nameLabel.font = AppFonts.Regular.withSize(18.0)
    }

    private func populateData() {
        if contact != nil {
            self.selectionButton.isSelected = false
            self.nameLabel.text = self.contact?.fullName ?? ""
            let placeholder = AppGlobals.shared.getImageFor(firstName: self.contact?.firstName, lastName: self.contact?.lastName, offSet: CGPoint(x: 0.0, y: 9.0))
            self.userImageView.image = placeholder
            self.userImageView.makeCircular(borderWidth: 0.0, borderColor: AppColors.themeGray20)
            if let imgData = self.contact?.imageData {
                self.userImageView.image = UIImage(data: imgData)
            }
            else if let img = self.contact?.image, !img.isEmpty {
                self.userImageView.setImageWithUrl(img, placeholder: placeholder, showIndicator: false)
                self.userImageView.makeCircular(borderWidth: 1.0, borderColor: AppColors.themeGray20)
            } else {
                self.userImageView.makeCircular(borderWidth: 1.0, borderColor: AppColors.themeGray20)
            }
            var age = ""
            if let dob = self.contact?.dob, !dob.isEmpty {
                age = AppGlobals.shared.getAgeLastString(dob: dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            }
            let firstName = self.contact?.firstName ?? ""
            let lastName = self.contact?.lastName ?? ""
            self.nameLabel.appendFixedText(text: "\(firstName) \(lastName)", fixedText: age)
            self.nameLabel.AttributedFont(textFont : AppFonts.Regular.withSize(18.0), textColor : AppColors.themeBlack)
            self.nameLabel.AttributedFontForText(text: firstName, textFont: AppFonts.SemiBold.withSize(18.0))
            if !age.isEmpty {
                self.nameLabel.AttributedFontColorForText(text: age, textColor: AppColors.themeGray40)
            }
            
            if showSalutationImage {
                self.userImageView.makeCircular(borderWidth: 0.0, borderColor: AppColors.themeGray20)
                self.userImageView.cancelImageDownloading()
                self.userImageView.image =  AppGlobals.shared.getEmojiIcon(dob: self.contact?.dob ?? "", salutation: self.contact?.salutation ?? "", dateFormatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            }
        }
        else {
            self.selectionButton.isSelected = false
            self.nameLabel.text = self.traveller?.fullName ?? ""
            
            let placeholder = AppGlobals.shared.getImageFor(firstName: self.traveller?.firstName, lastName: self.traveller?.lastName, offSet: CGPoint(x: 0.0, y: 9.0))
            self.userImageView.image = placeholder
            if let img = self.traveller?.profileImage, !img.isEmpty {
                self.userImageView.setImageWithUrl(img, placeholder: placeholder, showIndicator: false)
            }else {
                self.userImageView.makeCircular(borderWidth: 1.0, borderColor: AppColors.themeGray20)
            }
            
            var age = ""
            if let dob = self.traveller?.dob, !dob.isEmpty {
                age = AppGlobals.shared.getAgeLastString(dob: dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            }
            let firstName = self.traveller?.firstName ?? ""
            let lastName = self.traveller?.lastName ?? ""
            self.nameLabel.appendFixedText(text: "\(firstName) \(lastName)", fixedText: age)
            self.nameLabel.AttributedFont(textFont : AppFonts.Regular.withSize(18.0), textColor : AppColors.themeBlack)
            self.nameLabel.AttributedFontForText(text: firstName, textFont: AppFonts.SemiBold.withSize(18.0))
            if !age.isEmpty {
                self.nameLabel.AttributedFontColorForText(text: age, textColor: AppColors.themeGray40)
            }
        }
    }
}
