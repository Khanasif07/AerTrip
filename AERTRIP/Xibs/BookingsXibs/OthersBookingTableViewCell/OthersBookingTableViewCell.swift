//
//  OthersBookingTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class OthersBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bookingTypeImgView: UIImageView!
    @IBOutlet weak var plcaeNameLabel: UILabel!
    @IBOutlet weak var travellersNameLabel: UILabel!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shouldRoundAllCorners {
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner ,.layerMinXMaxYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
            self.containerViewBottomConstraint.constant = 5.0
        } else {
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
            self.containerViewBottomConstraint.constant = 0.0
        }
    }
    
    var bookingData: BookingData? {
        didSet {
            self.configCell()
        }
    }

    var shouldRoundAllCorners: Bool = false {
        didSet {
            layoutSubviews()
        }
    }
    
    private func configUI() {
        self.bookingTypeImgView.image = #imageLiteral(resourceName: "others")
        self.plcaeNameLabel.textColor = AppColors.themeBlack
        self.travellersNameLabel.textColor = AppColors.themeGray40
        self.plcaeNameLabel.font = AppFonts.Regular.withSize(18.0)
        self.travellersNameLabel.font = AppFonts.Regular.withSize(14.0)
        self.backgroundColor = AppColors.themeWhite
        self.clipsToBounds = true
    }
    
    private func configCell() {
        
        self.plcaeNameLabel.text = bookingData?.tripCitiesStr ?? ""
        self.travellersNameLabel.text = bookingData?.paxStr ?? ""
        self.bookingTypeImgView.image = bookingData?.productType.icon
    }
}
