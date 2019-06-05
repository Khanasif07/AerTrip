//
//  FlightCarriersTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 29/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightCarriersTableViewCell: UITableViewCell {

    //MARK:- Variables
    //MARK:===========
    
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var firstFlightCarriersContView: UIView!
    @IBOutlet weak var firstFlightCarriersImgVw: UIImageView!
    @IBOutlet weak var secondFlightCarriersContView: UIView!
    @IBOutlet weak var secondFlightCarriersImgVw: UIImageView!
    @IBOutlet weak var moreFlightCarriersContView: UIView!
    @IBOutlet weak var moreFlightCarriersImgVw: UIImageView!
    @IBOutlet weak var moreFlightCarriersLabel: UILabel!
    @IBOutlet weak var totalCarriersOrFlNameLabel: UILabel!
    @IBOutlet weak var flightCode: UILabel!
    @IBOutlet weak var remainingCodesLabel: UILabel!
    @IBOutlet weak var nextScreenImageView: UIImageView!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configUI() {
        //Font
        self.moreFlightCarriersLabel.font = AppFonts.Regular.withSize(11.0)
        self.totalCarriersOrFlNameLabel.font = AppFonts.Regular.withSize(16.0)
        self.flightCode.font = AppFonts.Regular.withSize(16.0)
        self.remainingCodesLabel.font = AppFonts.Regular.withSize(14.0)
        
        //Color
        self.moreFlightCarriersLabel.textColor = AppColors.themeWhite
        self.totalCarriersOrFlNameLabel.textColor = AppColors.themeBlack
        self.flightCode.textColor = AppColors.themeBlack
        self.remainingCodesLabel.textColor = AppColors.themeGray40
        
        //SetUp
        self.secondFlightCarriersContView.isHidden = true
        self.moreFlightCarriersContView.isHidden = true
        
        //Shadow
//        self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
        self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
    }
    
    internal func configCell(totalNumberOfCarriers: Int , flightNo: String, flightName: String) {
        self.remainingCodesLabel.text = "+\(totalNumberOfCarriers - 1) \(LocalizedString.More.localized)"
        self.flightCode.text = flightNo
        self.remainingCodesLabel.isHidden = false
        switch totalNumberOfCarriers {
        case 1:
            self.secondFlightCarriersContView.isHidden = true
            self.moreFlightCarriersContView.isHidden = true
            self.totalCarriersOrFlNameLabel.text = flightName
            self.remainingCodesLabel.isHidden = true
        case 2:
            self.moreFlightCarriersContView.isHidden = true
            self.totalCarriersOrFlNameLabel.text = flightName
        default:
            self.secondFlightCarriersContView.isHidden = false
            self.moreFlightCarriersContView.isHidden = false
            self.moreFlightCarriersLabel.text = "\(totalNumberOfCarriers - 2)"
            self.totalCarriersOrFlNameLabel.text = "\(totalNumberOfCarriers) \(LocalizedString.Carriers.localized)"
        }
    }
    
    //MARK:- IBActions
    //MARK:===========
    
}

//MARK:- Extensions
//MARK:============
