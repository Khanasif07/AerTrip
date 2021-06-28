//
//  HCBedDetailsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCBedDetailsTableViewCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var roomDescLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var passengerStackView: UIStackView!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var guestContainerView: UIView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        passengerStackView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    //Mark:- Methods
    //==============
    ///COnfigure UI
    private func configUI() {
        //Font
        self.roomNumberLabel.font = AppFonts.Regular.withSize(14.0)
        self.roomNameLabel.font = AppFonts.Regular.withSize(14.0)
        self.roomDescLabel.font = AppFonts.Regular.withSize(14.0)
        //Text
        
        //Color
        self.roomNumberLabel.textColor = AppColors.themeBlack
        self.roomNameLabel.textColor = AppColors.themeBlack
        self.roomDescLabel.textColor = AppColors.themeBlack
        
//        self.shadowView.addShadow(cornerRadius: 0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 8.0)
        let shadow = AppShadowProperties()
        self.shadowView.addShadow(cornerRadius: 0, maskedCorners:[], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
    }
    
    ///Configure Cell
    internal func configCell(roomData: Room, index: String, passengers: [TravellersList]) {
        //self.roomNameLabel.isHidden = true
        self.roomNumberLabel.text = LocalizedString.Room.localized + " \(index)"
        self.roomDescLabel.text = roomData.name
        self.roomNameLabel.isHidden = true
        for traveller in passengers {
           let view =  HCHotelPassengerView.instanciateFromNib()
            view.configCell(travellersImage: traveller.profile_image, travellerName: "\(traveller.first_name) \(traveller.last_name)", firstName: traveller.first_name, lastName: traveller.last_name, dob: traveller.dob, salutation: traveller.salutation, age: "\(traveller.age)")
            view.layoutIfNeeded()
            self.passengerStackView.addArrangedSubview(view)
        }
        
    }
    
    internal func setupForLastCell(isLastCell: Bool, isForAllDone:Bool = false) {
        if isLastCell {
            self.stackViewBottomConstraint.constant = 16
            self.containerBottomConstraint.constant = 26
            self.containerView.roundBottomCorners(cornerRadius: 10)
//            self.shadowView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 8.0)
            let shadow = AppShadowProperties()
            self.shadowView.addShadow(cornerRadius: shadow.cornerRadius, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
            self.dividerView.isHidden = false
        } else {
            self.stackViewBottomConstraint.constant = 8
            self.containerBottomConstraint.constant = 0
            self.containerView.roundBottomCorners(cornerRadius: 0)
//            self.shadowView.addShadow(cornerRadius: 0, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 8.0)
            let shadow = AppShadowProperties()
            self.shadowView.addShadow(cornerRadius: 0.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
            self.dividerView.isHidden = true
        }
        if isForAllDone{
            self.containerView.backgroundColor = AppColors.themeWhiteDashboard
            self.guestContainerView.backgroundColor = AppColors.themeWhiteDashboard
            for view in self.passengerStackView.subviews{
                if let passView = view as? HCHotelPassengerView{
                    passView.containerView.backgroundColor = AppColors.themeWhiteDashboard
                }
            }
        }
        self.contentView.layoutIfNeeded()
    }
}
