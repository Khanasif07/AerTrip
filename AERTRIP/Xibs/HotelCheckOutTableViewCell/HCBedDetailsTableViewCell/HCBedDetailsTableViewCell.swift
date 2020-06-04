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
        self.roomNumberLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.roomNameLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.roomDescLabel.font = AppFonts.Regular.withSize(14.0)
        //Text
        
        //Color
        self.roomNumberLabel.textColor = AppColors.themeBlack
        self.roomNameLabel.textColor = AppColors.themeBlack
        self.roomDescLabel.textColor = AppColors.themeBlack
        
        self.shadowView.addShadow(cornerRadius: 0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.15), offset: CGSize.zero, opacity: 1, shadowRadius: 8.0)
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
            self.passengerStackView.addArrangedSubview(view)
        }
        
    }
    
    internal func setupForLastCell(isLastCell: Bool) {
        if isLastCell {
            self.stackViewBottomConstraint.constant = 16
            self.containerBottomConstraint.constant = 26
            self.containerView.roundBottomCorners(cornerRadius: 10)
            self.shadowView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.15), offset: CGSize.zero, opacity: 1, shadowRadius: 8.0)
            self.dividerView.isHidden = false
        } else {
            self.stackViewBottomConstraint.constant = 26
            self.containerBottomConstraint.constant = 0
            self.containerView.roundBottomCorners(cornerRadius: 0)
            self.shadowView.addShadow(cornerRadius: 0, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.15), offset: CGSize.zero, opacity: 1, shadowRadius: 8.0)
            self.dividerView.isHidden = true
        }
        self.contentView.layoutIfNeeded()
    }
}
