//
//  SelectedContactCollectionCell.swift
//  AERTRIP
//
//  Created by Admin on 09/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SelectedContactCollectionCellDelegate: class {
    func crossButtonAction(_ sender: UIButton)
}

class SelectedContactCollectionCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var crossButton: ATBlurButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var lastNameAgeContainer: UIView!
    @IBOutlet weak var roomLabel: UILabel!
    
    weak var delegate: SelectedContactCollectionCellDelegate?

    var contact: ATContact? {
        didSet {
            self.populateData()
        }
    }
    
    var isUsingForGuest: Bool = false {
        didSet {
            self.populateData()
        }
    }
    
    var isSelectedForGuest: Bool = false {
        didSet {
            self.populateData()
        }
    }
    
    var roomNo: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
        self.setupTextAndColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.profileImageView.layer.cornerRadius = self.profileImageView.height / 2.0
        self.profileImageView.layer.masksToBounds = true
    }
    
    private func initialSetup() {
        self.crossButton.blurColor = AppColors.clear
        self.crossButton.blurStyle = .dark
        //self.crossButton.blurAlpha = 0.6
        self.crossButton.borderWidth = 2.0
        self.crossButton.layer.masksToBounds = true
        self.crossButton.addTarget(self, action: #selector(crossButtonAction(_:)), for: UIControl.Event.touchUpInside)
        resetView()
    }
    
    private func setupTextAndColor() {
        self.nameLabel.font = AppFonts.Regular.withSize(14.0)
        self.nameLabel.textColor = AppColors.themeBlack
        self.lastNameLabel.font = AppFonts.Regular.withSize(14.0)
        self.ageLabel.font = AppFonts.Regular.withSize(14.0)
        self.lastNameLabel.textColor = AppColors.themeBlack
        self.ageLabel.textColor = AppColors.themeGray40
        self.roomLabel.font = AppFonts.Regular.withSize(14.0)
        self.roomLabel.textColor = AppColors.themeGray40
        
    }
    
    private func resetView() {
        lastNameLabel.isHidden = true
        ageLabel.isHidden = true
        lastNameAgeContainer.isHidden = true
        lastNameLabel.text = ""
        ageLabel.text = ""
        roomLabel.text = ""
    }
    
    private func populateData() {
        
        if self.isUsingForGuest {
            roomLabel.text = " "
            self.profileImageView.layer.borderColor = AppColors.clear.cgColor
            self.profileImageView.layer.borderWidth = 0.0
            
            self.nameLabel.text = ""
            if let fName = self.contact?.firstName, !fName.isEmpty {
                self.nameLabel.text = fName
                self.crossButton.isHidden = false
            }
            else if let type = self.contact?.passengerType, let number = self.contact?.numberInRoom, number >= 0 {
                self.crossButton.isHidden = true
                self.nameLabel.text = (type == PassengersType.Adult) ? "\(LocalizedString.Adult.localized) \(number)" : "\(LocalizedString.Child.localized) \(number)"
                
                if let year = self.contact?.age, year > 0 {
                    ageLabel.text = "(\(year)y)"
                    ageLabel.isHidden = false
                }
                
                
            }
            if let lName = self.contact?.lastName, !lName.isEmpty {
                lastNameLabel.text = lName
                lastNameLabel.isHidden = false
            }
            if let type = self.contact?.passengerType, let number = self.contact?.numberInRoom, number >= 0 {
                if type == PassengersType.Adult, number == 1, roomNo > 0 {
                    roomLabel.text = "\(LocalizedString.Room.localized) \(roomNo)"
                }
            }
            
            var placeHolder: UIImage = #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult")
            if let ptype = self.contact?.passengerType {
                if isSelectedForGuest {
                    placeHolder = (ptype == .Adult) ? #imageLiteral(resourceName: "ic_selected_hotel_guest_adult") : #imageLiteral(resourceName: "ic_selected_hotel_guest_child")
                    self.nameLabel.textColor = AppColors.themeBlack
                    self.lastNameLabel.textColor = AppColors.themeBlack
                }
                else {
                    placeHolder = (ptype == .Adult) ? #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult") : #imageLiteral(resourceName: "ic_deselected_hotel_guest_child")
                    self.nameLabel.textColor = AppColors.themeGray40
                    self.lastNameLabel.textColor = AppColors.themeGray40
                }
            }
            
            
            
            self.profileImageView.image = placeHolder
            if let img = self.contact?.profilePicture, !img.isEmpty {
                self.profileImageView.setImageWithUrl(img, placeholder: placeHolder, showIndicator: false)
                self.profileImageView.layer.borderColor = AppColors.themeGray40.cgColor
                self.profileImageView.layer.borderWidth = 1.0
            }
            else if let fName = self.contact?.firstName, !fName.isEmpty, let flImage = self.contact?.flImage {
                self.profileImageView.image = flImage
                self.profileImageView.layer.borderColor = AppColors.themeGray40.cgColor
                self.profileImageView.layer.borderWidth = 1.0
            }
            
            lastNameAgeContainer.isHidden = false
        }
        else {
            self.nameLabel.text = self.contact?.firstName ?? ""
            
            let placeholder = AppGlobals.shared.getImageFor(firstName: self.contact?.firstName, lastName: self.contact?.lastName, offSet: CGPoint(x: 0.0, y: 9.0))
            self.profileImageView.image = placeholder
            if let imgData = self.contact?.imageData {
                self.profileImageView.image = UIImage(data: imgData)
            }
            else if let img = self.contact?.image, !img.isEmpty {
                self.profileImageView.setImageWithUrl(img, placeholder: placeholder, showIndicator: false)
            }
            self.crossButton.isHidden = false
            self.profileImageView.layer.borderColor = AppColors.themeGray40.cgColor
            self.profileImageView.layer.borderWidth = 1.0
        }
    }
    
    @objc func crossButtonAction(_ sender: UIButton) {
        self.delegate?.crossButtonAction(sender)
    }
}
