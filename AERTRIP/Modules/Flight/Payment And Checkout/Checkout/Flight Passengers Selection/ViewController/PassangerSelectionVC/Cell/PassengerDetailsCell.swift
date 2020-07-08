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
    var journeyType:JourneyType = .domestic
    var lastJourneyDate = Date()
    var isAllPaxInfoRequired = false
    var minMNS = 10
    var maxMNS = 10
    var innerCellIndex:IndexPath?
    
    var contact: ATContact? {
        didSet {
            self.configData()
        }
    }
    
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
            infoImageView.image = #imageLiteral(resourceName: "add_icon")
            var finalText = ""
            if let type = self.contact?.passengerType {
                switch type{
                case .Adult:
                    iconImageView.image = #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult")
                    finalText = "\(LocalizedString.Adult.localized) \(self.contact?.numberInRoom ?? 0)"
                case .child:
                    iconImageView.image = #imageLiteral(resourceName: "ic_deselected_hotel_guest_child")
                    finalText = "\(LocalizedString.Child.localized) \(self.contact?.numberInRoom ?? 0)"
                case .infant:
                    iconImageView.image = #imageLiteral(resourceName: "ic_deselected_hotel_guest_infant")
                    finalText = "\(LocalizedString.Infant.localized) \(self.contact?.numberInRoom ?? 0)"
                }
            }
            var ageText = ""
            if let year = self.contact?.age, year > 0 {
                //ageLabel.text = "(\(year)y)"
                finalText += " (\(year)y)"
                ageText = "(\(year)y)"
            }
            ageLabel.isHidden = false
            lastNameAgeContainer.isHidden = false
            firstNameLabel.attributedText = self.atributedtedString(text: finalText, ageText: ageText)
        }
        self.iconImageView.clipsToBounds = true
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.height / 2.0
        if let fName = self.contact?.firstName, let lName = self.contact?.lastName, let saltn = self.contact?.salutation {
            infoImageView.image = #imageLiteral(resourceName: "ic_info_incomplete")
            infoImageView.isHidden = true

            let placeHolder = self.contact?.flImage ?? #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult")
            self.iconImageView.image = placeHolder

            if (fName.isEmpty && lName.isEmpty) {
                infoImageView.isHidden = false
                setupForAdd()
            }
            else {
                infoImageView.isHidden = !((fName.isEmpty || fName.count < 3) || (lName.isEmpty || lName.count < 3) || saltn.isEmpty)
                firstNameLabel.text = fName
                lastNameLabel.text = lName
                if !lName.isEmpty {
                    lastNameLabel.isHidden = false
                    lastNameAgeContainer.isHidden = false
                }

                if let img = self.contact?.profilePicture, !img.isEmpty {
                    self.iconImageView.setImageWithUrl(img, placeholder: placeHolder, showIndicator: false)
                }
                else {
                    self.iconImageView.image = AppGlobals.shared.getImageFor(firstName: self.contact?.firstName, lastName: self.contact?.lastName, font: AppFonts.Light.withSize(36.0),textColor: AppColors.themeGray60, offSet: CGPoint(x: 0, y: 12), backGroundColor: AppColors.imageBackGroundColor)
                }

                if let year = self.contact?.age, year > 0 {
                    ageLabel.text = "(\(year)y)"
                    ageLabel.isHidden = false
                    lastNameAgeContainer.isHidden = false
                }
            }
            self.ageValidation()
            if self.journeyType == .domestic{
                self.checkForDomestic()
            }else{
                self.checkForInternational()
            }
            self.validatationForEmailAndMobile()
        }
        else {
            setupForAdd()
        }
    }
    
    private func checkForDomestic(){
        guard let guest = self.contact else {return}
        switch guest.passengerType{
        case .Adult, .child:
            break;
        case .infant:
            if guest.displayDob.isEmpty{
                infoImageView.isHidden = false
            }
        }
    }
    
    private func checkForInternational(){
        guard let guest = self.contact else {return}
        if guest.nationality.isEmpty{
            let indx = self.innerCellIndex ?? [0,0]
            GuestDetailsVM.shared.guests[0][indx.row].nationality = "India"
            GuestDetailsVM.shared.guests[0][indx.row].countryCode = "In"
        }
        if infoImageView.isHidden{
            infoImageView.isHidden = !(guest.displayDob.isEmpty || guest.nationality.isEmpty || guest.passportNumber.isEmpty || guest.displayPsprtExpDate.isEmpty)
        }
        
    }
    
    private func ageValidation(){
//        if self.journeyType == .domestic{
//            if let type = self.contact?.passengerType, type == .infant{
//                if !self.calculateAge(with: 2){
//                    self.infoImageView.isHidden = false
//                }
//            }
//        }else{
            if let type = self.contact?.passengerType{
                guard let indx = self.innerCellIndex else {return}
                switch type{
                case .Adult:break
                case .child:
                    if !self.calculateAge(with: 12){
                        GuestDetailsVM.shared.guests[0][indx.row].dob = ""
                        self.infoImageView.isHidden = false
                    }
                case .infant:
                    if !self.calculateAge(with: 2){
                        GuestDetailsVM.shared.guests[0][indx.row].dob = ""
                        self.infoImageView.isHidden = false
                    }
                }
            }
//        }
    }
    
    func validatationForEmailAndMobile(){
        guard ((self.contact?.passengerType ?? .Adult) == .Adult) else {return}
        if self.isAllPaxInfoRequired{
            let mobileText = self.contact?.contact ?? ""
            let isValidMobile = !(!(mobileText.isEmpty) && (mobileText.count >= minMNS)  && (mobileText.count <= maxMNS))
            let isValidMail = !(self.contact?.emailLabel.isEmail ?? true)
            if isValidMail || isValidMobile{
                self.infoImageView.isHidden = false
            }
        }
    }
    
    private func calculateAge(with year:Int)-> Bool{
        guard let dob = self.contact?.displayDob,
            let date = dob.toDate(dateFormat: "dd MMM yyyy") else {return false}
        let component = Calendar.current.dateComponents([.year], from: date, to: lastJourneyDate)
        return (component.year ?? 0) < year
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
