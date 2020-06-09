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
        profileImageView.contentMode = .scaleAspectFill
    }
    
    private func setupTextAndColor() {
        self.nameLabel.font = AppFonts.Regular.withSize(14.0)
        self.nameLabel.textColor = AppColors.themeBlack
        self.roomLabel.font = AppFonts.Regular.withSize(14.0)
        self.roomLabel.textColor = AppColors.themeGray40
        
    }
    
    private func resetView() {
        roomLabel.text = ""
    }
    
    private func populateData() {
        
        if self.isUsingForGuest {
            let imageBackGroundColor = isSelectedForGuest ? AppColors.themeGray20 : AppColors.imageBackGroundColor
            let textColor = isSelectedForGuest ? AppColors.themeBlack : AppColors.themeGray60

            
            roomLabel.text = " "
            self.profileImageView.layer.borderColor = AppColors.clear.cgColor
            self.profileImageView.layer.borderWidth = 0.0
            
            self.nameLabel.text = ""
            if let fName = self.contact?.firstName, !fName.isEmpty {
                self.nameLabel.text = fName
                self.crossButton.isHidden = false
            }
            else if let lName = self.contact?.lastName, lName.isEmpty, let type = self.contact?.passengerType, let number = self.contact?.numberInRoom, number >= 0 {
                self.crossButton.isHidden = true
                switch type{
                case .Adult:
                    self.nameLabel.text = "\(LocalizedString.Adult.localized) \(number)"
                case .child:
                    self.nameLabel.text = "\(LocalizedString.Child.localized) \(number)"
                case .infant:
                   self.nameLabel.text = "\(LocalizedString.Infant.localized) \(number)"
                }
//                self.nameLabel.text = (type == PassengersType.Adult) ? "\(LocalizedString.Adult.localized) \(number)" : "\(LocalizedString.Child.localized) \(number)"
                
//                if let year = self.contact?.age, year > 0 {
//                    ageLabel.text = "(\(year)y)"
//                    ageLabel.isHidden = false
//                }
                
                
            }else if let lName = self.contact?.lastName, !lName.isEmpty {
                    self.nameLabel.text = lName
                    self.crossButton.isHidden = false                
            }else {
                self.nameLabel.text = " "
                self.crossButton.isHidden = false
            }
            
            if let type = self.contact?.passengerType, let number = self.contact?.numberInRoom, number >= 0 {
                if type == PassengersType.Adult, number == 1, roomNo > 0 {
                    roomLabel.text = "\(LocalizedString.Room.localized) \(roomNo)"
                }
            }
            
            var placeHolder: UIImage = #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult")
            if let ptype = self.contact?.passengerType {
                if isSelectedForGuest {
                    switch ptype{
                    case .Adult:
                        placeHolder = #imageLiteral(resourceName: "ic_selected_hotel_guest_adult")
                    case .child:
                        placeHolder = #imageLiteral(resourceName: "ic_selected_hotel_guest_child")
                    case .infant:
                        placeHolder = #imageLiteral(resourceName: "ic_selected_hotel_guest_infant")
                    }
//                    placeHolder = (ptype == .Adult) ? #imageLiteral(resourceName: "ic_selected_hotel_guest_adult") : #imageLiteral(resourceName: "ic_selected_hotel_guest_child")
                    self.nameLabel.textColor = AppColors.themeBlack
                }
                else {
                    switch ptype{
                    case .Adult:
                        placeHolder = #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult")
                    case .child:
                        placeHolder = #imageLiteral(resourceName: "ic_deselected_hotel_guest_child")
                    case .infant:
                        placeHolder = #imageLiteral(resourceName: "ic_deselected_hotel_guest_infant")
                    }
//                    placeHolder = (ptype == .Adult) ? #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult") : #imageLiteral(resourceName: "ic_deselected_hotel_guest_child")
                    self.nameLabel.textColor = AppColors.themeGray40
                }
            }
            
            
            
            self.profileImageView.image = placeHolder
            if let img = self.contact?.profilePicture, !img.isEmpty {
                self.profileImageView.setImageWithUrl(img, placeholder: placeHolder, showIndicator: false)
//                self.profileImageView.layer.borderColor = AppColors.themeGray40.cgColor
//                self.profileImageView.layer.borderWidth = 1.0
            }else if let imageData = self.contact?.imageData {
                self.profileImageView.image = UIImage(data: imageData)
            }
            else if let fName = self.contact?.firstName, let lName = self.contact?.lastName {
                if (!fName.isEmpty || !lName.isEmpty) {
                self.profileImageView.image = AppGlobals.shared.getImageFor(firstName: fName, lastName: lName, font: AppFonts.Light.withSize(36.0),textColor: textColor, offSet: CGPoint(x: 0, y: 12), backGroundColor: imageBackGroundColor)
                }

            }
                
                
                
//            else if let fName = self.contact?.firstName, !fName.isEmpty, let flImage = self.contact?.flImage {
//                self.profileImageView.image = flImage
//                self.profileImageView.layer.borderColor = AppColors.themeGray40.cgColor
//                self.profileImageView.layer.borderWidth = 1.0
//            }else if let lName = self.contact?.lastName, !lName.isEmpty, let flImage = self.contact?.flImage {
//                self.profileImageView.image = flImage
//                self.profileImageView.layer.borderColor = AppColors.themeGray40.cgColor
//                self.profileImageView.layer.borderWidth = 1.0
//            }
            
            
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
            self.profileImageView.layer.borderColor = AppColors.themeGray60.cgColor
            self.profileImageView.layer.borderWidth = 1.0
        }
    }
    
    @objc func crossButtonAction(_ sender: UIButton) {
        self.delegate?.crossButtonAction(sender)
    }
}



class SelectedContactImportCollectionCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var crossButton: ATBlurButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
        self.setupTextAndColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.profileImageView.layer.cornerRadius = self.profileImageView.height / 2.0
        self.profileImageView.layer.masksToBounds = true
    }
    
    private func initialSetup() {
        self.crossButton.borderWidth = 2.0
        self.crossButton.blurColor = AppColors.clear
        self.crossButton.blurStyle = .dark
        
        //self.crossButton.blurAlpha = 0.6
        
        self.crossButton.addTarget(self, action: #selector(crossButtonAction(_:)), for: UIControl.Event.touchUpInside)
        profileImageView.contentMode = .scaleAspectFill
    }
    
    private func setupTextAndColor() {
        self.nameLabel.font = AppFonts.Regular.withSize(14.0)
        self.nameLabel.textColor = AppColors.themeBlack
    }
    
    
    
    private func populateData() {
        
        if self.isUsingForGuest {
            self.profileImageView.layer.borderColor = AppColors.clear.cgColor
            self.profileImageView.layer.borderWidth = 0.0
            
            self.nameLabel.text = ""
            if let fName = self.contact?.firstName, !fName.isEmpty {
                self.nameLabel.text = fName
                self.crossButton.isHidden = false
            }
            else if let type = self.contact?.passengerType, let number = self.contact?.numberInRoom, number >= 0 {
                self.crossButton.isHidden = true
//                self.nameLabel.text = (type == PassengersType.Adult) ? "\(LocalizedString.Adult.localized) \(number)" : "\(LocalizedString.Child.localized) \(number)"
                switch type{
                case .Adult:
                    self.nameLabel.text = "\(LocalizedString.Adult.localized) \(number)"
                case .child:
                    self.nameLabel.text = "\(LocalizedString.Child.localized) \(number)"
                case .infant:
                   self.nameLabel.text = "\(LocalizedString.Infant.localized) \(number)"
                }

                
            }
            
            
            var placeHolder: UIImage = #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult")
            if let ptype = self.contact?.passengerType {
                if isSelectedForGuest {
                    switch ptype{
                    case .Adult:
                        placeHolder = #imageLiteral(resourceName: "ic_selected_hotel_guest_adult")
                    case .child:
                        placeHolder = #imageLiteral(resourceName: "ic_selected_hotel_guest_child")
                    case .infant:
                        placeHolder = #imageLiteral(resourceName: "ic_selected_hotel_guest_infant")
                    }
//                    placeHolder = (ptype == .Adult) ? #imageLiteral(resourceName: "ic_selected_hotel_guest_adult") : #imageLiteral(resourceName: "ic_selected_hotel_guest_child")
                    self.nameLabel.textColor = AppColors.themeBlack
                }
                else {
                    switch ptype{
                    case .Adult:
                        placeHolder = #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult")
                    case .child:
                        placeHolder = #imageLiteral(resourceName: "ic_deselected_hotel_guest_child")
                    case .infant:
                        placeHolder = #imageLiteral(resourceName: "ic_deselected_hotel_guest_infant")
                    }
//                    placeHolder = (ptype == .Adult) ? #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult") : #imageLiteral(resourceName: "ic_deselected_hotel_guest_child")
                    self.nameLabel.textColor = AppColors.themeGray40
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
            
        }
        else {
            if let firstName = self.contact?.fullName, !firstName.isEmpty {
                self.nameLabel.text = firstName
            } else if let lastName = self.contact?.lastName , !lastName.isEmpty {
                self.nameLabel.text = lastName
            } else {
                self.nameLabel.text = ""
            }
            
            let placeholder = AppGlobals.shared.getImageFor(firstName: self.contact?.firstName, lastName: self.contact?.lastName, offSet: CGPoint(x: 0.0, y: 9.0),backGroundColor: AppColors.imageBackGroundColor)
            self.profileImageView.image = placeholder
            if let imgData = self.contact?.imageData {
                self.profileImageView.image = UIImage(data: imgData)
            }
            else if let img = self.contact?.image, !img.isEmpty {
                self.profileImageView.setImageWithUrl(img, placeholder: placeholder, showIndicator: false)
            }
            self.crossButton.isHidden = false
//            self.profileImageView.layer.borderColor = AppColors.themeGray40.cgColor
//            self.profileImageView.layer.borderWidth = 1.0
        }
    }
    
    @objc func crossButtonAction(_ sender: UIButton) {
        self.delegate?.crossButtonAction(sender)
    }
}
