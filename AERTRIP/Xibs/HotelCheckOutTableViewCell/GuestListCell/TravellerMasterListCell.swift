//
//  TravellerMasterListCell.swift
//  AERTRIP
//
//  Created by Admin on 10/05/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

class TravellerMasterListCell: UITableViewCell {
    
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var meLabel: UILabel!
    
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
        self.userImageView.contentMode = .scaleAspectFill
    }
    
    private func setupTextAndColor() {
        self.nameLabel.textColor = AppColors.themeBlack
        self.nameLabel.font = AppFonts.Regular.withSize(18.0)
        self.meLabel.textColor = AppColors.themeGray60
        self.meLabel.font = AppFonts.Regular.withSize(16.0)
        self.meLabel.text = "Me"
    }

    private func populateData() {
        self.selectionButton.isSelected = false
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
        self.setName()
        if showSalutationImage {
            self.userImageView.makeCircular(borderWidth: 0.0, borderColor: AppColors.themeGray20)
            self.userImageView.cancelImageDownloading()
            self.userImageView.image =  AppGlobals.shared.getEmojiIcon(dob: self.contact?.dob ?? "", salutation: self.contact?.salutation ?? "", dateFormatter: Date.DateFormat.yyyy_MM_dd.rawValue)
        }
        
    }
    
    
    func setName(){
        guard let contact = contact else {return}
        let dateStr = AppGlobals.shared.getAgeLastString(dob: contact.dob, formatter: "yyyy-MM-dd")
        let attributedDateStr = AppGlobals.shared.getAttributedBoldText(text: dateStr, boldText: dateStr,color: AppColors.themeGray40)
        
        let firstName = contact.firstName
        let lastName = contact.lastName
        let boldTextAttributed = self.getAttributedText(firstName: firstName, lastName: lastName)
        boldTextAttributed.append(attributedDateStr)
        self.nameLabel.attributedText = boldTextAttributed
        
    }
    
    
    
    private func getAttributedText(firstName: String, lastName: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: "")
        let boldFont = AppFonts.SemiBold.withSize(18.0)//:[NSAttributedString.Key : Any]
        let lightFont = AppFonts.Regular.withSize(18.0)
        let color = AppColors.themeBlack
        
        if UserInfo.loggedInUser?.generalPref?.displayOrder == "LF" {
            if (UserInfo.loggedInUser?.generalPref?.sortOrder == "LF"){
                attString.append(NSAttributedString(string: lastName, attributes: [.font: boldFont, .foregroundColor: color]))
                if !lastName.isEmpty{
                    attString.append(NSAttributedString(string: " \(firstName)", attributes: [.font: lightFont, .foregroundColor: color]))
                }else{
                    attString.append(NSAttributedString(string: "\(firstName)", attributes: [.font: boldFont, .foregroundColor: color]))
                }
            }else{
                attString.append(NSAttributedString(string: lastName, attributes: [.font: lightFont, .foregroundColor: color]))
                let fName = lastName.isEmpty ? "\(firstName)" : " \(firstName)"
                attString.append(NSAttributedString(string: fName, attributes: [.font: boldFont, .foregroundColor: color]))
            }
            
        } else {
            if (UserInfo.loggedInUser?.generalPref?.sortOrder == "LF"){
                if !lastName.isEmpty{
                    attString.append(NSAttributedString(string: "\(firstName) ", attributes: [.font: lightFont, .foregroundColor: color]))
                }else{
                    attString.append(NSAttributedString(string: "\(firstName)", attributes: [.font: boldFont, .foregroundColor: color]))
                }
                attString.append(NSAttributedString(string: "\(lastName)", attributes: [.font: boldFont, .foregroundColor: color]))
            }else{
                attString.append(NSAttributedString(string: firstName, attributes: [.font: boldFont, .foregroundColor: color]))
                let lName = firstName.isEmpty ? "\(lastName)" : " \(lastName)"
                attString.append(NSAttributedString(string: lName, attributes: [.font: lightFont, .foregroundColor: color]))
            }
        }
           
        return attString
    }
    
    
}
