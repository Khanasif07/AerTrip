//
//  PassengerDetailsCell.swift
//  Aertrip
//
//  Created by Apple  on 04.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class PassengerDetailsCell: UICollectionViewCell {
    // Mark:- IBOutlets
    // Mark:-
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameAgeContainer: UIView!
    @IBOutlet weak var ageLabel: UILabel!
    
    
    private(set) var isForAdult: Bool = false
    
//    var contact: ATContact? {
//        didSet {
//            self.configData()
//        }
//    }
    
    // Mark:- LifeCycles
    // Mark:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }
    
    // Mark:- Functions
    // Mark:-
    
    private func configUI() {
        self.layoutIfNeeded()
        iconImageView.image = #imageLiteral(resourceName: "adultPassengers")
        
        firstNameLabel.font = AppFonts.Regular.withSize(14.0)
        firstNameLabel.textColor = AppColors.themeBlack
        
        lastNameLabel.font = AppFonts.Regular.withSize(14.0)
        lastNameLabel.textColor = AppColors.themeBlack
        
        ageLabel.font = AppFonts.Regular.withSize(14.0)
        ageLabel.textColor = AppColors.themeGray40
        firstNameLabel.text = "Adult 1"
        
        resetView()
    }
    
    private func resetView() {
        lastNameLabel.isHidden = true
        ageLabel.isHidden = true
        lastNameAgeContainer.isHidden = true
        lastNameLabel.text = ""
        ageLabel.text = ""
    }
    
    private func configData() {
        
        func setupForAdd() {
//            infoImageView.image = #imageLiteral(resourceName: "add_icon")
//            var finalText = ""
//            if let type = self.contact?.passengerType {
//                iconImageView.image = (type == .Adult) ? #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult") : #imageLiteral(resourceName: "ic_deselected_hotel_guest_child")
//
//                finalText = "\((type == .Adult) ? LocalizedString.Adult.localized : LocalizedString.Child.localized) \(self.contact?.numberInRoom ?? 0)"
//            }
//            var ageText = ""
//            if let year = self.contact?.age, year > 0 {
//                //ageLabel.text = "(\(year)y)"
//                finalText += " (\(year)y)"
//                ageText = "(\(year)y)"
//            }
//            ageLabel.isHidden = false
//            lastNameAgeContainer.isHidden = false
//            firstNameLabel.attributedText = self.atributedtedString(text: finalText, ageText: ageText)
        }
        
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.height / 2.0
//        if let fName = self.contact?.firstName, let lName = self.contact?.lastName, let saltn = self.contact?.salutation {
//            infoImageView.image = #imageLiteral(resourceName: "ic_info_incomplete")
//            infoImageView.isHidden = true
//
//            let placeHolder = self.contact?.flImage ?? #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult")
//            self.iconImageView.image = placeHolder
//
//            if (fName.isEmpty && lName.isEmpty) {
//                infoImageView.isHidden = false
//                setupForAdd()
//            }
//            else {
//                infoImageView.isHidden = !((fName.isEmpty || fName.count < 3) || (lName.isEmpty || lName.count < 3) || saltn.isEmpty)
//                firstNameLabel.text = fName
//                lastNameLabel.text = lName
//                if !lName.isEmpty {
//                    lastNameLabel.isHidden = false
//                    lastNameAgeContainer.isHidden = false
//                }
//
//                if let img = self.contact?.profilePicture, !img.isEmpty {
//                    self.iconImageView.setImageWithUrl(img, placeholder: placeHolder, showIndicator: false)
//                }
//                else {
//                    self.iconImageView.image = AppGlobals.shared.getImageFor(firstName: self.contact?.firstName, lastName: self.contact?.lastName, font: AppFonts.Light.withSize(36.0),textColor: AppColors.themeGray60, offSet: CGPoint(x: 0, y: 12), backGroundColor: AppColors.imageBackGroundColor)
//                }
//
//                if let year = self.contact?.age, year > 0 {
//                    ageLabel.text = "(\(year)y)"
//                    ageLabel.isHidden = false
//                    lastNameAgeContainer.isHidden = false
//                }
//            }
//
//        }
//        else {
//            setupForAdd()
//        }
    }
    
    // Mark:- IBActions
    // Mark:-
    
    func atributedtedString(text: String, ageText: String)-> NSAttributedString{
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: AppFonts.Regular.withSize(14),
            .foregroundColor: AppColors.themeBlack
        ])
        attributedString.addAttribute(.foregroundColor, value: AppColors.themeGray40, range: (text as NSString).range(of: ageText))
        return attributedString
    }
}
