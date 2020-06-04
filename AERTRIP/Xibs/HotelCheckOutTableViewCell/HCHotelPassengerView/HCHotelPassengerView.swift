//
//  HCHotelPassengerView.swift
//  AERTRIP
//
//  Created by Admin on 02/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class HCHotelPassengerView: UIView {
    
    // MARK: - Variables
    
    // MARK: ===========
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var travellerProfileImage: UIImageView!
    @IBOutlet weak var travellerName: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //MARK:- Class Function
    //MARK:-
    class func instanciateFromNib() -> HCHotelPassengerView {
        return Bundle .main .loadNibNamed("HCHotelPassengerView", owner: self, options: nil)![0] as! HCHotelPassengerView
    }
    
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configureUI() {
        self.dividerView.isHidden = true
        self.travellerName.font = AppFonts.Regular.withSize(16.0)
        self.travellerName.textColor = AppColors.themeBlack
        
        self.travellerProfileImage.makeCircular(borderWidth: 1.0, borderColor: AppColors.themeGray20)
    }
    
    internal func configCell(travellersImage: String, travellerName: String,firstName: String,lastName: String, dob: String, salutation: String, age: String) {
        //self.travellerName.text = travellerName
        if !travellersImage.isEmpty {
            self.travellerProfileImage.setImageWithUrl(travellersImage, placeholder: #imageLiteral(resourceName: "profilePlaceholder"), showIndicator: true)
            self.travellerProfileImage.contentMode = .scaleAspectFit
        } else {
            //self.travellerProfileImage.image = AppGlobals.shared.getImageFor(firstName: firstName, lastName: lastName, font: AppFonts.Regular.withSize(35.0))
//            if congigureForHotelDetail {
                self.travellerProfileImage.image = AppGlobals.shared.getEmojiIconFromAge(ageString: age, salutation: salutation)
//            } else {
//                self.travellerProfileImage.image = AppGlobals.shared.getEmojiIcon(dob: dob, salutation: salutation, dateFormatter: Date.DateFormat.yyyy_MM_dd.rawValue)
//            }
            
            self.travellerProfileImage.contentMode = .center
        }
        var ageString = ""
//        if congigureForHotelDetail {
            if !age.isEmpty, let intAge = Int(age), (intAge > 0 && intAge <= 12) {
                ageString = " (\(age)y)"
                //travelName += age
            }
//        } else {
//            if !dob.isEmpty {
//                ageString = AppGlobals.shared.getAgeLastString(dob: dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
//            }
//        }
        // self.travellerNameLabel.text = travelName
        self.travellerName.appendFixedText(text: travellerName, fixedText: ageString)
        if !age.isEmpty {
            self.travellerName.AttributedFontColorForText(text: age, textColor: AppColors.themeGray40)
        }
        
    }
    

}
